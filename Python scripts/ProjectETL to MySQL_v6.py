import pandas as pd
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String ,text
from sqlalchemy_utils import create_database, database_exists
import numpy as np
#import itertools
#from geopy.geocoders import Nominatim
#import pycountry
#import datetime

# Credentials to database connection
hostname="localhost"
dbname="project"
uname="root"
pwd="rootroot"

# Create dataframe

fileCSV="C:\BrainStation\Poject\Source\Tourism and Travel Reviews Sri Lankan Destinations\Tourism and Travel Reviews Sri Lankan Destinations\Reviews.csv"
allRev = pd.read_csv(fileCSV,sep=',',encoding='latin')#
DfRev=pd.DataFrame(allRev).reset_index()

DfRev['Traveler_ID']= DfRev['User_ID'].str.extract('(\d+)')
DfRev['Traveler_ID']=pd.to_numeric(DfRev['Traveler_ID'])

#~~~~Genarating PK ID as Traveler Reviews count Traveler_ID|| Rev_count~~~~~~~~~~~~~~~~~~~~~~#

DfRev['Index_']=DfRev['index'].astype(str)
DfRev['lengths'] = DfRev['Index_'].apply(len)
DfRev['IndexFix']=pd.to_numeric(DfRev['Index_'])
Town = DfRev['Location'].str.split(",", n=1, expand=True)
DfRev['Town']=Town[0]
DfRev['Province']=Town[1]

def copute_town(DfRev):
  DfRev.loc[(DfRev['Town'] =='North Central Province') ,'Town']="North Central"
  DfRev.loc[(DfRev['Town'] =='Udawalawe National Park') ,'Town']="Udawalawe"
  DfRev.loc[(DfRev['Town'] =='Uva Province') ,'Town']="Uva"

copute_town(DfRev)

#print (DfRev.dtypes)
def fixId(DfRev):
    DfRev.loc[(DfRev['lengths']==5) ,'InputID']=pd.concat([DfRev['IndexFix']+40000]) 
    DfRev.loc[(DfRev['lengths']==4) ,'InputID']=pd.concat([DfRev['IndexFix']+40000])
    DfRev.loc[(DfRev['lengths']==3) ,'InputID']=pd.concat([DfRev['IndexFix']+30000])
    DfRev.loc[(DfRev['lengths']==2) ,'InputID']=pd.concat([DfRev['IndexFix']+20000])
    DfRev.loc[((DfRev['lengths']==1) & (DfRev['IndexFix']==0)), 'InputID']=pd.concat([DfRev['IndexFix']+10001])
    DfRev.loc[((DfRev['lengths']==1) & (DfRev['IndexFix']!=0)) ,'InputID']=pd.concat([10000+(DfRev['IndexFix']+1)])
   
fixId(DfRev)

#DfRev['InputID']=pd.to_numeric(DfRev['Input_ID'])
DfReviews=pd.DataFrame(DfRev)

#DfReviews.to_excel(r'C:\BrainStation\Poject\Source\Check_PKList.xlsx',index=False)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


UserData = DfReviews.drop_duplicates( 
  subset = ["Traveler_ID","User_Location","Travel_Date","Published_Date"], 
  keep = 'first').reset_index(drop = True).sort_values(by=['Traveler_ID',"User_Location"])

UserData["Traveler_Location"] = UserData["User_Location"].str.strip().str.title()
dfUserData=pd.DataFrame(UserData)


#^^^^^^^^^^^^^^^^^^^Normalising country Names^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#

CountryMap=r'C:\BrainStation\Poject\Source\User_country_and_city_vf1.0.xlsx'

uCountry = pd.read_excel(CountryMap, sheet_name='Sheet1')
uCountry=uCountry.fillna('')

def copute_Country(uCountry):
  uCountry.loc[(uCountry['Country1'] !='') & (uCountry['Country3'] !='') ,'Traveler_Country']=uCountry['Country3']
  uCountry.loc[(uCountry['Country1'] =='' ) & (uCountry['Country2'] !='') ,'Traveler_Country']=uCountry['Country2']
  uCountry.loc[(uCountry['Country1'] !='') & (uCountry['Country3'] =='') ,'Traveler_Country']=uCountry['Country1']

copute_Country(uCountry)

uCountry=pd.DataFrame(uCountry).reset_index().drop(columns=(['Country1','Country2','Country3']))
uCountry['Traveler_Country']=uCountry['Traveler_Country'].str.strip()
uCountry.drop(columns=['index'], inplace=True)
#print(uCountry)
uCountry.to_excel(r'C:\BrainStation\Poject\Source\UserCountryList.xlsx',index=False)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#~~~~~~~~~~~~~~~~~~~~~~~~Merging user country~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
dfUserData=pd.DataFrame(dfUserData).sort_values(by="Traveler_Location",ascending=True)
dfCountry=pd.DataFrame(uCountry).sort_values(by="Traveler_Location",ascending=True)
dfUserCoun= pd.merge(dfUserData, dfCountry, on="Traveler_Location", how="left")
#print(dfUserCoun)
dfUserCoun.to_excel(r'C:\BrainStation\Poject\Qc outputs\UserCountryMer.xlsx',index=False)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

###^^^^^^^^^ All Travel Data,  Year + 'User_ID','Traveler_ID','Travel_Date','Traveler_Country','Rating','Text' ^^^^^^^^^^###
Date=DfReviews[["Traveler_ID","Travel_Date"]].drop_duplicates().reset_index(drop=True)
YM= Date['Travel_Date'].str.split("-", n=1, expand=True)
Date['Travel_Year']=YM[0].astype(int)
Date['Travel_Month']=YM[1]
dfDate=pd.DataFrame(Date)

dfUDConntry=pd.DataFrame(dfUserCoun).sort_values(by=['Traveler_ID','Travel_Date'],ascending=True)
dfYear=pd.DataFrame(dfDate).sort_values(by=['Traveler_ID','Travel_Date'],ascending=True)

dfUserYear= pd.merge(dfUDConntry, dfYear, on=['Traveler_ID','Travel_Date'], how="left")

TravelData=dfUserYear[['InputID','Traveler_ID','Traveler_Location','Travel_Date','Travel_Year','Travel_Month','Traveler_Country','Location_Name','Located_City','Town','Province','Location_Type',
                       "Published_Date","Title",'Rating',"Helpful_Votes",'Text']].sort_values(by='Travel_Year').reset_index()

TravelData.to_excel(r'C:\BrainStation\Poject\Qc outputs\TravelData.xlsx',index=False)

# # Get column names
#TravelData_columns = TravelData.columns
#print(TravelData_columns)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


###################################

### Traveler #######
dfTraveler=TravelData[["InputID","Traveler_ID","Traveler_Location"]].reset_index(drop=True)
Traveler=pd.DataFrame(dfTraveler).sort_values(by=(['InputID','Traveler_ID']))

### Traveler Country #######
dfCountry=TravelData[["Traveler_Location","Traveler_Country"]].reset_index(drop=True)
dfCountryNDup = dfCountry.drop_duplicates( 
  subset = ["Traveler_Location","Traveler_Country"], 
  keep = 'first').reset_index(drop = True).sort_values(by=['Traveler_Location','Traveler_Country'])
dfCountryNDup = dfCountryNDup.dropna(how='any',axis=0) 

Country=pd.DataFrame(dfCountryNDup).sort_values(by=(['Traveler_Location','Traveler_Country'])).reset_index(drop=True)
print (Country)

#'''''
# ### Date #######
dfTraveler=TravelData[["InputID","Traveler_ID",'Travel_Date', 'Travel_Year', 'Travel_Month',"Published_Date"]]
Date=pd.DataFrame(dfTraveler).sort_values(by=(['InputID','Traveler_ID']))

### Rating #######
dfRating=TravelData[["InputID","Traveler_ID","Location_Name","Rating"]].drop_duplicates()
Rating=pd.DataFrame(dfRating).sort_values(by=("InputID"))

### User Text data #######
Text=TravelData[["InputID","Traveler_ID","Title","Text"]].drop_duplicates().reset_index(drop=True)
Text=pd.DataFrame(Text).sort_values(by=("InputID"))

### Helpful_Votes ###
Helpful_Votes=TravelData[["InputID","Traveler_ID","Helpful_Votes"]].drop_duplicates().reset_index(drop=True)
Votes=pd.DataFrame(Helpful_Votes).sort_values(by=("InputID"))

###Location#######
dfLocation=TravelData[["InputID","Traveler_ID","Town","Province"]].drop_duplicates().reset_index(drop=True)
Location=pd.DataFrame(dfLocation).sort_values(by=("InputID"))
Location.rename(columns={'Location_Name': 'Location'}, inplace=True)

### Location_ type #######
dfLocation_Type=TravelData[["InputID","Traveler_ID","Location_Type"]].drop_duplicates().reset_index(drop=True)
Location_Type=pd.DataFrame(dfLocation_Type).sort_values(by=("InputID"))


# Create SQLAlchemy engine to connect to MySQL Database
#DBengine = create_engine("mysql+pymysql://{user}:{pw}@{host}"
#				.format(host=hostname, user=uname, pw=pwd))

# Query for existing databases
#with DBengine.connect() as dbconn:
#  dbconn.execute(text("CREATE SCHEMA IF NOT EXISTS dbname"))
  
engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))
if not database_exists(engine.url): create_database(engine.url)        

# Execute the DROP TABLE statement directly
with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS Traveler"))
    conn.execute(text("DROP TABLE IF EXISTS Country"))
    conn.execute(text("DROP TABLE IF EXISTS Date"))
    conn.execute(text("DROP TABLE IF EXISTS city"))
    conn.execute(text("DROP TABLE IF EXISTS rating"))
    conn.execute(text("DROP TABLE IF EXISTS location"))
    conn.execute(text("DROP TABLE IF EXISTS text"))
    conn.execute(text("DROP TABLE IF EXISTS Type"))
    conn.execute(text("DROP TABLE IF EXISTS Votes"))
  
#'''''	


#'''''
# Convert dataframe to sql table 
Traveler.to_sql('Traveler', engine,dtype={"InputID":Integer(), "Traveler_ID": Integer(),"Traveler_Location": String (200)}, if_exists='replace', index=False)
Country.to_sql('Country', engine,dtype={"Traveler_Country":String (200),"Traveler_Location": String (200)}, if_exists='replace', index=False)
Date.to_sql('Date', engine,dtype={"InputID":Integer(),"Traveler_ID": Integer(),"Travel_Year": Integer(),"Travel_Month": Integer()}, if_exists='replace', index=False) 
Location.to_sql('Location', engine, dtype={"InputID":Integer(),"Traveler_ID": Integer(),"Town": String (200),"Province": String (200)}, if_exists='replace', index=False)
Location_Type.to_sql('Type', engine, dtype={"InputID":Integer(),"Traveler_ID": Integer(),"Location_Type": String (200)}, if_exists='replace', index=False)
Rating.to_sql('Rating', engine,dtype={"InputID":Integer(),"Traveler_ID": Integer(),"Location_Name": String (200),"Rating": Integer()},  if_exists='replace', index=False)
Votes.to_sql('Votes', engine, dtype={"InputID":Integer(),"Traveler_ID": Integer(),"Helpful_Votes": Integer()}, if_exists='replace', index=False)
Text.to_sql('Text', engine, dtype={"InputID":Integer(), "Traveler_ID": Integer(),"Title": String (200), "text": String(90000)}, if_exists='replace', index=False)
#DfReviews.to_sql('all', engine, if_exists='replace', index=False)
