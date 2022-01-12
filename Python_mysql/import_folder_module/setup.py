from setuptools import setup
setup(
    name = 'import_folder_tosql',
    version = 1.0,
    description = 'Module to import a folder into an SQL Database',
    long_description = '''This is a module I made which looks through each file in a provided directory
                          and adds each csv table in the directory to the provided database.''',
    author = 'Shua Friedman',
    author_email = 'sfriedman291@gmail.com',
    py_modules = ['import_folder_tosql']
)  

    