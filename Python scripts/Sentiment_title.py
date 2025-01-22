import pandas as pd,re, itertools
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String, text
import numpy as np

import string
from collections import Counter
import nltk
from nltk.corpus import stopwords
from nltk.corpus import wordnet
from nltk.sentiment import SentimentIntensityAnalyzer
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import word_tokenize

'''''
nltk.download('punkt')
nltk.download('wordnet')
nltk.download('stopwords')
nltk.download('averaged_perceptron_tagger')
nltk.download('vader_lexicon')
nltk.download('punkt_tab')
nltk.download('averaged_perceptron_tagger_eng')
'''''


lemmatizer = WordNetLemmatizer()
stop_words = set(stopwords.words('english'))

# Credentials to database connection
hostname="localhost"
dbname="ecocapture"
uname="root"
pwd="rootroot"

# Create SQLAlchemy engine to connect to MySQL Database
engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))

Tbcomments = pd.read_sql( 
    "SELECT * FROM ecocapture.comment", 
    con=engine 
)

df=pd.DataFrame(Tbcomments).reset_index()
print (df)

df['clean_Title'] = df['Title'].fillna('')

def get_wordnet_pos(treebank_tag):
    """Map POS tag to first character used by WordNetLemmatizer"""
    if treebank_tag.startswith('J'):
        return wordnet.ADJ
    elif treebank_tag.startswith('V'):
        return wordnet.VERB
    elif treebank_tag.startswith('N'):
        return wordnet.NOUN
    elif treebank_tag.startswith('R'):
        return wordnet.ADV
    else:
        return wordnet.NOUN  # by default, treat as noun

def preprocess_text(Title):
    tokens = word_tokenize(Title)
    tokens = [word.lower() for word in tokens]
    tokens = [word for word in tokens if word.isalpha() or word in string.punctuation]
    pos_tags = nltk.pos_tag(tokens)
    tokens = [lemmatizer.lemmatize(word, get_wordnet_pos(pos)) for word, pos in pos_tags]
    tokens = [word for word in tokens if word not in stop_words]

    return " ".join(tokens)

df['processed_Title'] = df['clean_Title'].apply(preprocess_text)

sia = SentimentIntensityAnalyzer()

def get_sentiment(Title):
    sentiment_score = sia.polarity_scores(Title)['compound']
    if sentiment_score >= 0.05:
        return "positive"
    elif sentiment_score <= -0.05:
        return "negative"
    else:
        return "neutral"
        
df['sentiment_Title'] = df['processed_Title'].apply(get_sentiment)


with engine.connect() as conn:
    conn.execute(text("DROP TABLE IF EXISTS siatitle"))

#Sia_Title=df[["InputID","Traveller_ID","processed_Title","sentiment_Title"]].reset_index(drop=True)
#Sia_Title=pd.DataFrame(Sia_Title).sort_values(by=("InputID"))
#sia = pd.DataFrame(Sia_Title)
#sia.to_sql('siaTitle', engine, dtype={"InputID":Integer(), "Traveller_ID": Integer(),"processed_Title": String (9000), "sentiment_Title":String(10)}, if_exists='replace', index=False)

cols = df[['Title', 'clean_Title', 'processed_Title', 'sentiment_Title']]

df_sentiment = pd.DataFrame(cols)

negatives_df = df_sentiment[df_sentiment['sentiment_Title'] == 'negative'][['Title', 'processed_Title']]
negatives = negatives_df['Title'].tolist()

positives_df = df_sentiment[df_sentiment['sentiment_Title'] == 'positive'][['Title', 'processed_Title']]
positives = positives_df['Title'].tolist()

def most_common(df, top_n=25):
    all_words = [word for word in ' '.join(df['processed_Title']).split() if word not in string.punctuation]
    word_counts = Counter(all_words)
    top_25_words = word_counts.most_common(top_n)

    return top_25_words
print(most_common(negatives_df))
print(most_common(positives_df))

Sia_Title=(most_common(positives_df))
Sia_Title=pd.DataFrame(Sia_Title)
sia = pd.DataFrame(Sia_Title)
sia.to_sql('siatitle', engine, dtype={"Sia_Title": String (50)}, if_exists='replace', index=False)


df.to_excel(r'C:\Github_proj\EcoCapture-Analytics\QC files\QC_SIA_Title.xlsx',index=False)   
#Titlevr=pd.Series(TitleCOL).reset_index(drop=True)
#strx.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_Titlefile.xlsx',index=False)
#print (Titles)
#Titles['SPLTitle']=Titles['Title'].str.split(' ')
#s= (Titles['Title'])
#Titles.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_groups.xlsx',index=False)    