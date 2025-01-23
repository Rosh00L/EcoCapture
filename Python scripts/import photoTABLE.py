import pandas as pd

from scipy.stats import ttest_ind
from statsmodels.stats.weightstats import ztest as ztest
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

TwoCatall = pd.read_sql( 
    "SELECT * FROM ecocapture.v_photographyvsnonall", 
    con=engine 
) 

df = pd.DataFrame(TwoCatall)

#define samples
group1 = df[df['Photography']=='No photography']
group2 = df[df['Photography']=='photography']

#perform independent two sample t-test
test=ttest_ind(group1['rating'], group2['rating'])
Ztest=ztest(group1['rating'], group2['rating'])


print(test)
print(Ztest)

''''''
photography = pd.read_sql( 
    "SELECT * FROM ecocapture._photography", 
    con=engine 
) 
photography.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\photography.xlsx',index=False)

No_photography = pd.read_sql( 
    "SELECT * FROM ecocapture._no_photography", 
    con=engine 
) 
No_photography.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\No_photography.xlsx',index=False)
''''''