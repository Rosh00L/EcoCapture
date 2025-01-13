import pandas as pd
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String ,text
import numpy as np
import csv

# Credentials to database connection
hostname="localhost"
dbname="project"
uname="root"
pwd="rootroot"

# Create dataframe

# Create SQLAlchemy engine to connect to MySQL Database
engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))


sql_traveler = pd.read_sql( 
    "SELECT * FROM project.traveler", 
    con=engine 
) 
sql_traveler.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_traveler.xlsx',index=False)

sql_date = pd.read_sql( 
    "SELECT * FROM project.date", 
    con=engine 
) 
sql_date.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_date.xlsx',index=False)


sql_type = pd.read_sql( 
    "SELECT * FROM project.type", 
    con=engine 
) 
sql_type.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_type.xlsx',index=False)


sql_Country = pd.read_sql( 
    "SELECT * FROM project.traveler_country", 
    con=engine 
) 
sql_Country.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_traveler_Country.xlsx',index=False)

sql_location = pd.read_sql( 
    "SELECT * FROM project.location", 
    con=engine 
) 
sql_location.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_Location.xlsx',index=False)

sql_travel_cat = pd.read_sql( 
    "SELECT * FROM project.travel_cats", 
    con=engine 
) 
sql_travel_cat.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_travel_cats.xlsx',index=False)



'''''
# read table data using sql query
sql_traveler = pd.read_sql( 
    "SELECT * FROM project.traveler", 
    con=engine 
) 
sql_traveler.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_traveler.xlsx',index=False)
 
sql_country = pd.read_sql( 
    "SELECT * FROM project.country", 
    con=engine 
) 
sql_country.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_country.xlsx',index=False)

'''''