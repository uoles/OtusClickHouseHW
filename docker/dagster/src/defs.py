from dagster import Definitions
import assets

defs = Definitions(
    assets=[assets.asset_load_xml, assets.asset_add_to_clickhouse]
)