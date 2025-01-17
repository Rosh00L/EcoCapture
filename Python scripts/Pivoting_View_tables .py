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


activity = pd.read_sql( 
    "SELECT * FROM ecocapture.activity", 
    con=engine 
) 


activ_sum_V = pd.read_sql( 
    "SELECT * FROM ecocapture.activ_sum", 
    con=engine 
) 


activDF=pd.DataFrame(activ_sum_V)
activTran = activDF.transpose()
activTrandf=pd.DataFrame(activTran).reset_index()
activTrandf.columns=['Activity_type','sum']

with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS activ_sum_pivot"))

activTrandf.to_sql('activ_sum_pivot', engine, if_exists='replace', index=False)    

activityDF=pd.DataFrame(activity)
### User Text data #######

def copute_act(Flag):
    Flag + _Int=activityDF[["InputID","Traveller_ID","Flag"]].drop_duplicates().reset_index(drop=True)
    Flag + _Int=Flag + _Int.rename(columns={'Flag':'ActivityCat'})
    Flag + df=pd.DataFrame(Flag + Int).sort_values(by=("InputID")) 

def copute_act(Flag + _df):
  Flag + _df.loc[(photography_df['ActivityCat'] =='1') ,'Traveller_act']="Flag + "

copute_act(photography_df)





dfUserCoun= pd.concat([photography_df, Sightseeing_df,Wildlife_and_Photography_df,Wildlife_nature_df],ignore_index=type)


with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS activ_sum_pivot"))
    conn.execute(text("DROP TABLE IF EXISTS act_table"))

activTrandf.to_sql('activ_sum_pivot', engine, if_exists='replace', index=False)    
dfUserCoun.to_sql('act_table', engine, if_exists='replace', index=False)   