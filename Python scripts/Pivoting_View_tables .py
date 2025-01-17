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
photography_Int=activityDF[["InputID","Traveller_ID","photography_Interest"]].drop_duplicates().reset_index(drop=True)
photography_Int=photography_Int.rename(columns={'photography_Interest':'ActivityCat'})
photography_df=pd.DataFrame(photography_Int).sort_values(by=("InputID")) 

def copute_act(photography_df):
  photography_df.loc[(photography_df['ActivityCat'] =='1') ,'Traveller_act']="photography"
copute_act(photography_df)

Sightseeing_Int=activityDF[["InputID","Traveller_ID","Sightseeing"]].drop_duplicates().reset_index(drop=True)
Sightseeing_Int=Sightseeing_Int.rename(columns={'Sightseeing':'ActivityCat'})
Sightseeing_df=pd.DataFrame(Sightseeing_Int).sort_values(by=("InputID")) 

def copute_act(Sightseeing_df):
  Sightseeing_df.loc[(Sightseeing_df['ActivityCat'] =='1') ,'Traveller_act']="Sightseeing"
copute_act(Sightseeing_df)

Wildlife_and_Photography_Int=activityDF[["InputID","Traveller_ID","Wildlife_and_Photography"]].drop_duplicates().reset_index(drop=True)
Wildlife_and_Photography_Int=Wildlife_and_Photography_Int.rename(columns={'Wildlife_and_Photography':'ActivityCat'})
Wildlife_and_Photography_df=pd.DataFrame(Wildlife_and_Photography_Int).sort_values(by=("InputID")) 

def copute_act(Wildlife_and_Photography_df):
  Wildlife_and_Photography_df.loc[(Wildlife_and_Photography_df['ActivityCat'] =='1') ,'Traveller_act']="Wildlife_and_Photography"
copute_act(Wildlife_and_Photography_df)


Wildlife_nature_Int=activityDF[["InputID","Traveller_ID","Wildlife_nature"]].drop_duplicates().reset_index(drop=True)
Wildlife_nature_Int=Wildlife_nature_Int.rename(columns={'Wildlife_nature':'ActivityCat'})
Wildlife_nature_df=pd.DataFrame(Wildlife_nature_Int).sort_values(by=("InputID")) 

def copute_act(Wildlife_nature_df):
  Wildlife_nature_df.loc[(Wildlife_nature_df['ActivityCat'] =='1') ,'Traveller_act']="Wildlife_nature"
copute_act(Wildlife_nature_df)


dfUserCoun= pd.concat([photography_df, Sightseeing_df,Wildlife_and_Photography_df,Wildlife_nature_df],ignore_index=type)


with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS activ_sum_pivot"))
    conn.execute(text("DROP TABLE IF EXISTS act_table"))

activTrandf.to_sql('activ_sum_pivot', engine, if_exists='replace', index=False)    
dfUserCoun.to_sql('act_table', engine, if_exists='replace', index=False)   