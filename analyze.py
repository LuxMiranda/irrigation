import pandas as pd

data = pd.read_csv('log/run_2021-06-27_14:18:59.csv')

data = data.sort_values('Fitness', ascending=False)

data.head(10).to_csv('Top.csv')
