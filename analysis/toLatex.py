import pandas as pd

models = pd.read_csv('FinalTopModels.csv')

possible_decisions = ''
consider_altruism,consider_heuristic,consider_pseudorandom,consider_random,consider_relative_income,consider_selfishness,consider_utilitarian,downstream_homophily,upstream_homophily = 'F_{alt}','F_{heur}','F_{pseu}','F_{rand}','F_{inc}','F_{self}','F_{util}','F_{down}','F_{up}'

def infix(op):
    def outer(l):
        def inner(r):
            return '({}) {} ({})'.format(l,op,r)
        return inner
    return outer

def get_min_one_of(blah):
    def rest(x):
        return '$\\argmin {}$'.format(x)
    return rest

def get_max_one_of(blah):
    def rest(x):
        return '$\\argmax {}$'.format(x)
    return rest

combine  = infix('+')
subtract = infix('-')
multiply = infix('*')
divide   = infix('/')

for row in models.iterrows():
    m = row[1]['Model']
    fit = row[1]['Mean_fit']
    m = m.replace(' ','')
    m = m[1:-1]
    m = m.replace('((','(')
    m = m.replace('))',')')
    m = m.replace('-','_')
    m = eval(m)
    if '*' not in m and '/' not in m:
        m = m.replace('(','')
        m = m.replace(')','')
    print(m + ' & {:0.4f}\\\\'.format(fit))
