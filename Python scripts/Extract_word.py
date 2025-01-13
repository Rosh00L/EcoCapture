import pandas as pd,re, itertools
from sqlalchemy import create_engine, MetaData , Table , Column, Integer, String ,text
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
dbname="project"
uname="root"
pwd="rootroot"

# Create SQLAlchemy engine to connect to MySQL Database
engine = create_engine("mysql+pymysql://{user}:{pw}@{host}/{db}"
				.format(host=hostname, db=dbname, user=uname, pw=pwd))

Tbtext = pd.read_sql( 
    "SELECT * FROM project.text", 
    con=engine 
)

df=pd.DataFrame(Tbtext).reset_index()

df['clean_comments'] = df['Text'].fillna('')

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

def preprocess_text(text):
    tokens = word_tokenize(text)
    tokens = [word.lower() for word in tokens]
    tokens = [word for word in tokens if word.isalpha() or word in string.punctuation]
    pos_tags = nltk.pos_tag(tokens)
    tokens = [lemmatizer.lemmatize(word, get_wordnet_pos(pos)) for word, pos in pos_tags]
    tokens = [word for word in tokens if word not in stop_words]

    return " ".join(tokens)

df['processed_comments'] = df['clean_comments'].apply(preprocess_text)

sia = SentimentIntensityAnalyzer()

def get_sentiment(text):
    sentiment_score = sia.polarity_scores(text)['compound']
    if sentiment_score >= 0.05:
        return "positive"
    elif sentiment_score <= -0.05:
        return "negative"
    else:
        return "neutral"
        
df['sentiment_comments'] = df['processed_comments'].apply(get_sentiment)

cols = df[['Text', 'clean_comments', 'processed_comments', 'sentiment_comments']]

df_sentiment = pd.DataFrame(cols)

negatives_df = df_sentiment[df_sentiment['sentiment_comments'] == 'negative'][['Text', 'processed_comments']]
negatives = negatives_df['Text'].tolist()

positives_df = df_sentiment[df_sentiment['sentiment_comments'] == 'positive'][['Text', 'processed_comments']]
positives = positives_df['Text'].tolist()

def most_common(df, top_n=25):
    all_words = [word for word in ' '.join(df['processed_comments']).split() if word not in string.punctuation]
    word_counts = Counter(all_words)
    top_25_words = word_counts.most_common(top_n)

    return top_25_words
print(most_common(negatives_df))
print(most_common(positives_df))
df.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_groups.xlsx',index=False)   
#textvr=pd.Series(textCOL).reset_index(drop=True)
#strx.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_textfile.xlsx',index=False)
#print (texts)
#texts['SPLText']=texts['Text'].str.split(' ')
#s= (texts['Text'])
#texts.to_excel(r'G:\BrainStation\Poject\Qc outputs\QC_groups.xlsx',index=False)    