
'''''
def searchW(res,n):
    '''Searches for text, and retrieves n words either side of the text, which are retuned seperatly'''
    word = r"\W*([\w]+)"
    groups = re.search(r'{}\W*{}{}'.format(word*n,'not',word*n), res).groups()
    return groups[:n],groups[n:]    

def search(row):
    return row['comments']
# Applying the function row-wise

result = df.apply(search, axis=1)

for res in result:
    print(res)
    searchW(res,3)
''''''



for index, row in df.iterrows():
    word = r"\W*([\w]+)"
    groups = row['InputID'] , re.search(r'{}\W*{}{}'.format(word*4,'photo',word*4), row['comments'])
    print( groups)    

