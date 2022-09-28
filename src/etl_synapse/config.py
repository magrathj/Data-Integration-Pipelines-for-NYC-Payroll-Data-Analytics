import os
from pathlib import Path

os.environ['HOME'] = ""
    
#Set path
schema_path = Path(
        os.environ['HOME'],
        'src',
        'schemas',
        'postgres',
        'schemas.yaml'
    )
data_path =  Path(
        os.environ['HOME'],
        'data'
    )

#Set db variables
host='[HOSTNAME].postgres.database.azure.com'
port=5432
dbname='[NEW_DATABASE_NAME]'
user='[USER_NAME]@udacity-postgres'
password = "[PASSWORD]"
