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

def create_tables(
    config: list, connection: pg.extensions.connection
):
    cur = connection.cursor()
    for table in config:
        name = table.get('name')
        schema = table.get('schema')
        ddl = f"""CREATE TABLE IF NOT EXISTS {name} ({schema})"""
        cur.execute(ddl)
        print("""Created {} table.""".format(name))

    connection.commit()
    print("""Commited all creations.""")

def unzip_files(
    config: list, prefix: str=None
):
    ## Extract CSVs from Zip files
    for table in config:
        table_name = table.get('name')
        table_name_zip = table_name if not prefix else prefix + table_name
        table_source = data_path.joinpath(f"{table_name_zip}.zip")
        print("""Started to unzip {} data from {}.""".format(table_name, table_source))
        with zipfile.ZipFile(table_source, 'r') as zip_ref:
            zip_ref.extractall(data_path)

def load_tables(
    config: list, connection: pg.extensions.connection, prefix: str=None
):
    # Iterate and load
    cur = connection.cursor()
    for table in config:
        table_name = table.get('name')
        table_name_csv = table_name if not prefix else prefix + table_name
        table_source = data_path.joinpath(f"{table_name_csv}.csv")
        print("""Started to load {} data to db from {}.""".format(table_name, table_source))
        with open(table_source, 'r', encoding='utf-8') as f:
            next(f)
            cur.copy_expert(f"COPY {table_name} FROM STDIN CSV NULL AS ''", f)
        connection.commit()
        print("""Completed loading {} table.""".format(table_name))

def create_database(
    database_name: string, connection: pg.extensions.connection
):
    print("""Creating database: {}.""".format(database_name))
    connection.autocommit = True
    # establish connection
    cursor = connection.cursor()
    # drop old db if it exists and create new one
    cursor.execute(f'DROP DATABASE IF EXISTS {database_name}')
    cursor.execute(f"CREATE DATABASE {database_name}")
    print("""Created database: {}.""".format(database_name))
    # clean up
    connection.commit()
    cursor.close()
    connection.close()
    print("""Close connection """)

def set_up(default_dbname = "postgres"):
    # DB connection
    print("""Setup started.""")
    print("""Establishing connection to postgres {} listening on {}, port {} with user name: {}.""".format(default_dbname, host, port, user))
    connection = pg.connect(
        host=host,
        port=port,
        dbname=default_dbname,
        user=user,
        password=password,
        sslmode='require'       
    )
    create_database(database_name=dbname, connection=connection)
    print("""Setup completed""")

def etl():
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
    print("""Successfully created db connection.""")
    # Table creation and data insertion
    config = load_config()
    unzip_files(config=config)
    create_tables(config=config, connection=connection)
    load_tables(config=config, connection=connection)
    print("""ETL completed.""")


def clean_up():
    # remove csvs from directory
    config = load_config()    
    ## remove each csv file
    for table in config:
        table_name = table.get('name')
        file_name = data_path.joinpath(f"{table_name}.csv")
        os.remove(file_name)
    print("""Cleanup completed.""")

if __name__ == '__main__':
    set_up()
    etl()
    clean_up()


