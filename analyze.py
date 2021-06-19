import pandas as pd

data = pd.read_csv('FactorScores.csv')

data = data.sort_values('Fitness', ascending=False)

data.head(10).to_csv('Top.csv')
