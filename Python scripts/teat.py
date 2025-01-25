# import python pandas package
import pandas as pd

# import the numpy package
import numpy as np

# Create sample dataframe data1 and data2
data1 = pd.DataFrame(np.random.randint(100, size=(1000, 3)),
					columns=['EMI', 'Salary', 'Debt'])
data2 = pd.DataFrame(np.random.randint(100, size=(1000, 3)),
					columns=['Salary', 'Debt', 'Bonus'])

# Merge the DataFrames
df_merged = pd.merge(data1, data2, how='inner', left_index=True,
					right_index=True, suffixes=('', '_remove'))

# remove the duplicate columns
#df_merged.drop([i for i in df_merged.columns if 'remove' in i],
#			axis=1, inplace=True)

print(df_merged)
