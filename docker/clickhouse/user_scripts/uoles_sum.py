import sys
from clickhouse_driver import Client

if __name__ == '__main__':
    transaction_id = ''
    for line in sys.stdin:
        transaction_id = str(line)

    select_query = """
        select sum(price * quantity) 
        from my_database.transactions 
        where transaction_id = %(transaction_id)s
        group by transaction_id
    """
   
    client = Client(host='localhost', port=9000 , user='username', password='password')
    result = client.execute(select_query, {'transaction_id': transaction_id})
    
    if len(result) > 0:
        print(str(result))
    else:
        print("Result is empty")
        
    sys.stdout.flush()