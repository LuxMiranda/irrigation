import pandas as pd
import numpy as np

data = pd.read_csv('FactorScores.csv')
data = data[['Rule','Fitness']]
data = data.groupby('Rule').agg({'Fitness':lambda x: list(x)})
data['Avg_fitness'] = data['Fitness'].apply(np.mean)
data['n_samples'] = data['Fitness'].apply(len)
#data = data[data['n_samples'].apply(lambda n : n >= 3)]
data = data.sort_values('Avg_fitness', ascending=False)
data[['Avg_fitness','n_samples']].to_csv('Top.csv')
