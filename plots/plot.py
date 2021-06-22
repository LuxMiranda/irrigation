import matplotlib.pyplot as plt
import seaborn as sns; sns.set_style('whitegrid')
import pandas as pd

labels = ['selfish','heuristic','pseudorandom','altruistic','2*utilitarian','total_water/roi^2','utilitarian','random','inverse upstream homophily']
data = [ 0.012592660032397, 0.012592660032397,0.012592660032397, 0.074704781396134, 0.420674498300101, 0.436645289846139, 0.461066396964689, 0.50406269389549, 0.545859694621545]

hue = [ 'Original models', 'Original models', 'Original models', 'EMD-discovered', 'EMD-discovered', 'Original models', 'Original models', 'Original models', 'EMD-discovered']

sns.barplot(x=data,y=labels,hue=hue, dodge=False)
plt.xlabel('Fitness ($f^{mlt}$)')
plt.ylabel('Model')
plt.show()
