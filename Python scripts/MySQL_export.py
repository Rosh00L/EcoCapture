import pandas as pd
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String ,text
import numpy as np
import csv

# Credentials to database connection
hostname="localhost"
dbname="ecocapture"
uname="root"
pwd="rootroot"

# Create dataframe

# Create SQLAlchemy engine to connect to MySQL Database
engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))


sql_traveler = pd.read_sql( 
    "SELECT * FROM ecocapture.traveller", 
    con=engine 
) 
sql_traveler.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_traveler.xlsx',index=False)

sql_date = pd.read_sql( 
    "SELECT * FROM ecocapture.dateall", 
    con=engine 
) 
sql_date.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_date.xlsx',index=False)

sql_Country = pd.read_sql( 
    "SELECT * FROM ecocapture.traveller_country", 
    con=engine 
) 
sql_Country.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_traveler_Country.xlsx',index=False)

sql_location = pd.read_sql( 
    "SELECT * FROM ecocapture.location", 
    con=engine 
) 
sql_location.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_Location.xlsx',index=False)

sql_sia = pd.read_sql( 
    "SELECT * FROM ecocapture.siarating", 
    con=engine 
) 
sql_sia.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_siarating.xlsx',index=False)

sql_act = pd.read_sql( 
    "SELECT * FROM ecocapture.activity",
con=engine 
) 
sql_act.to_excel(r"C:\Github_proj\EcoCapture-Analytics\QC files\QC_activity.xlsx",index=False)

'''''
# read table data using sql query
sql_traveler = pd.read_sql( 
    "SELECT * FROM ecocapture.traveler", 
    con=engine 
) 
sql_traveler.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_traveler.xlsx',index=False)
 
sql_country = pd.read_sql( 
    "SELECT * FROM ecocapture.country", 
    con=engine 
) 
sql_country.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_country.xlsx',index=False)

'''''