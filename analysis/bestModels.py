import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns; sns.set_style('white')

data = pd.read_csv('topModelRuns2.csv')

data = data.groupby('Model')['Fitness'].apply(list).reset_index(name='Samples')

data['Mean_fit'] = data['Samples'].apply(np.mean)
data['Max_fit']  = data['Samples'].apply(np.max)

data = data.sort_values('Mean_fit',ascending=False)
#data.to_csv('sorted_by_mean.csv')

# Hist plot suggests a major threshold at 0.5 fitness
#sns.histplot(data['Mean_fit'], bins=20)
#plt.show()

#data.sort_values('Max_fit', ascending=False)
#data.to_csv('sorted_by_max.csv')

utilitarian = data[data['Model'].apply(lambda x : x == '( get-max-one-of (( possible-decisions  ) ) (( consider-utilitarian  ) )  ) ')]
random = data[data['Model'].apply(lambda x : x == '( get-max-one-of (( possible-decisions  ) ) (( consider-random  ) )  ) ')]

data = data[data['Mean_fit'].apply(lambda x : x >= 0.5)]
# This hist plot suggests that >0.54 is a decent cut off for the "best" models
sns.histplot(data['Mean_fit'], bins=10)
plt.show()

data = data[data['Mean_fit'].apply(lambda x : x >= 0.525)]
data.to_csv('FinalTopModels.csv')

data = data[data['Mean_fit'].apply(lambda x : x >= 0.54)]
data = data.reset_index()

# Maybe name them something funner than just numbers
data['Model number'] = data.apply(lambda x : 'Model EMD{}'.format(x.name), axis=1)
data = data.set_index('Model number')[['Model','Samples']]

data.loc['Random'] = random.iloc[0]
data.loc['Utilitarian'] = utilitarian.iloc[0]

print(data['Samples'])

ax = sns.boxplot(data=data['Samples'], orient='h')
ax.set_yticklabels(['Lux Model {}'.format(i) for i in range(7)] + ['Random model', 'Original model'])
ax.set_xlabel('Fitness ($f_{mlt}$)')
plt.show()

   
