import pandas as pd
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String ,text
import numpy as np
import csv
import re

# Credentials to database connection
hostname="localhost"
dbname="ecocapture"
uname="root"
pwd="rootroot"

# Create dataframe

# Create SQLAlchemy engine to connect to MySQL Database
engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))


comments = pd.read_sql( 
    "SELECT * FROM ecocapture.comment", 
    con=engine 
) 

df=pd.DataFrame(comments)


def pick_only_key_sentence(str1, word):
    result = re.findall(r'([^.]*'+word+'[^.]*)', str1)
    return result
df['filter_Photo']=df['comments'].apply(lambda x : pick_only_key_sentence(x,'photo')).astype(str)
df['filter_Photo'].apply(', '.join)
df['filter_Photo']=df['filter_Photo'].str[2:]
df['filter_Photo']=df['filter_Photo'].str[:-2]
print (df)
df['Photo_not']=df['filter_Photo'].apply(lambda x : pick_only_key_sentence(x,'not')).reset_index(drop=True)

#df['Photo_no']=df['Photo_not'].apply(lambda x : pick_only_key_sentence(x,'no'))
#df['prohibited']=df['Photo_no'].apply(lambda x : pick_only_key_sentence(x,'prohibited'))
#df['arent']=df['prohibited'].apply(lambda x : pick_only_key_sentence(x,"aren't"))
#df['cannot']=df['arent'].apply(lambda x : pick_only_key_sentence(x,"cannot"))
#df['forbidden']=df['cannot'].apply(lambda x : pick_only_key_sentence(x,"forbidden"))
#df['is not condoned']=df['forbidden'].apply(lambda x : pick_only_key_sentence(x,"is not condoned"))



print("\nText with the word 'photo':")
df.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_photo.xlsx',index=False)   