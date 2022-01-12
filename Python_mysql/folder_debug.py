# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
import pandas as pd
import sqlalchemy
import os


# %%
engine = sqlalchemy.create_engine('mysql://root:root@localhost/spotify')


# %%
folder_path = r"C:\Users\sfrie\Downloads\archive (5)"
os.chdir(folder_path)
for file in os.listdir(folder_path):
    if '.csv' in file:
        df = pd.read_csv(file)
        table_name = str(file.strip('.csv'))
        df.to_sql(table_name, con = engine, if_exists = 'replace')


# %%
string = 'table.csv'
string.strip('.csv')


