def import_folder_tosql(engine, folder_path):
    """ 
    This function takes two arguements: a database engine string, and a folder path.
        
    engine syntax-- server://id:password@localhost/schema_name

    folder_path syntax-- Depends on the path format:
        a) Using single '\', place an 'r' outside the path to make the string literal
        b) Or use double '\\' 
    Note: Current version deletes any non UTF-8 characters from all values.
    """
        
    import pandas as pd
    import sqlalchemy
    import os
    engine = sqlalchemy.create_engine(engine)
    os.chdir(folder_path)
    for file in os.listdir(folder_path):
        if '.csv' in file:  #check to make sure the file is a csv file
            df = pd.read_csv(file )
            df.replace({r'[^\x00-\x7F]+':''}, regex=True, inplace=True) #regex to delete all non UTF-8 values in the dataframe
            table_name = str(file.strip('.csv'))
            df.to_sql(table_name, con = engine, if_exists = 'replace')

    return print("Databse Updated")
import_folder_tosql('mysql://root:root@localhost/practice', r'C:\Users\sfrie\Downloads\archive (5)')
