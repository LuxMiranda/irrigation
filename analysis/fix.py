import pandas as pd

factor_names=['consider_altruism','consider_heuristic','consider_pseudorandom','consider_random','consider_relative_income','consider_selfishness','consider_utilitarian','downstream_homophily','upstream_homophily','combine','multiply','subtract','divide']
data = pd.read_csv('FactorScores.csv')
for col in data.columns:
    if col in factor_names:
        data[col] = data[col].apply(lambda x : int(float(x)))
data.to_csv('fixed.csv', index=False)
