import pandas as pd

data = pd.read_csv('MacroTreatment.csv')
data = data[[col for col in data.columns if col != 'divide']]
for col in data.columns:
    if col != 'Rule':
        data[col] = data[col].apply(int)
data.to_csv('fixed.csv', index=False)
