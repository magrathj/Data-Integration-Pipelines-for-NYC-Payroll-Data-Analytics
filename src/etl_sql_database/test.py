import string
import psycopg2 as pg
import yaml
from pathlib import Path
import os
import pandas as pd
import configparser
from config import *
import zipfile
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def load_config() -> list:
    with open(schema_path) as schema_file:
        config = yaml.safe_load(schema_file)
    return config

def query_tables(
    config: list, connection: pg.extensions.connection
):
    cur = connection.cursor()
    for table in config:
        name = table.get('name')
        ddl = f"""SELECT COUNT(*) FROM {name}"""
        cur.execute(ddl)
        table_count = cur.fetchone()
        print("""table count: {} table: {}.""".format(table_count, name))

    connection.commit()
    print("""Commited all creations.""")

def test_database():
    # DB connection
    print("""ETL started.""")
    print("""Establishing connection to database {} listening on {}, port {} with user name: {}.""".format(dbname, host, port, user))
    connection = pg.connect(
        host=host,
        port=port,
        dbname=dbname,
        user=user,
        password=password,
        sslmode='require'
    )
    config = load_config()
    query_tables(config=config, connection=connection)
    

if __name__ == '__main__':
    test_database()


