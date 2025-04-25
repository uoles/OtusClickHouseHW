from dagster import asset, AssetExecutionContext

import requests
import xmltodict
from clickhouse_driver import Client

@asset()
def asset_load_xml(context: AssetExecutionContext) -> dict:
    url = "https://cbr.ru/scripts/XML_daily.asp?date_req=01/01/2020.xml"
    data = '{}'
    with requests.get(url) as response:
        data = xmltodict.parse(response.content)
        context.log.info(f"Output data is: {data}")
        context.add_output_metadata({"valute": data})
    return data
    
@asset(deps=[asset_load_xml])
def asset_add_to_clickhouse(context: AssetExecutionContext, asset_load_xml: dict):
    data = asset_load_xml
    context.log.info(f"Prepared data is: {data["ValCurs"]["@name"]}")
    
    client = Client(
        host='clickhouse-server',  
        port=9000,         
        user='username',   
        password='password',       
        database='my_database'    
    )

    create_table_query = """
        CREATE TABLE IF NOT EXISTS valute (
            c_date String NOT NULL,
            c_name String NOT NULL,
            c_str_id String NOT NULL,
            c_num_code String NOT NULL,
            c_char_code String NOT NULL,
            c_nominal String NOT NULL,
            c_value String NOT NULL
        ) ENGINE = MergeTree()
        ORDER BY (c_date)
    """
    client.execute(create_table_query)
    context.log.info("Table exists")
    
    c_date = data["ValCurs"]["@Date"]
    
    select_query = "SELECT 1 FROM valute WHERE c_date = %(c_date)s"
    result = client.execute(select_query, {'c_date': c_date})
    
    if len(result) == 0:
        insert_query = "INSERT INTO valute (c_date, c_name, c_str_id, c_num_code, c_char_code, c_nominal, c_value) VALUES"
        insert_data = [
            (data["ValCurs"]["@Date"], item["Name"], item["@ID"], item["NumCode"], item["CharCode"], item["Nominal"], item["Value"])
            for item in data["ValCurs"]["Valute"]
        ]
        client.execute(insert_query, insert_data)
        context.log.info("Data inserted")
    else:
        context.log.info("Data already loaded")
