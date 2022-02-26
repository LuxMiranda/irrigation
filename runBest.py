import nl4py
from numpy.random import default_rng; rng = default_rng()
import numpy as np
import pandas as pd
import multiprocessing
import time

# Return a NetLogo set command for the specified hyperparameter,
# randomly initialized about ±5% of the specified optimal value
def paramCommand(param, value):
    maxNudge     = 0.05
    nudgePercent = rng.uniform(-1*maxNudge, maxNudge)
    nudgedValue  = value + (nudgePercent * value) 
    return 'set {} {}'.format(param, nudgedValue)

# Setup commands
def newSetup():
    setup = [
    # Randomly initialize hyperparameters to a set nudge about
    # their optimal values reported in Baggio & Jannsen 2013, Table 3
    # --- pseudorandom ---
    paramCommand('meaninv',   0.00), # inv
    paramCommand('sdinv',     0.00), # inv
    paramCommand('sdnoise',   0.49), # n (StDev)
    paramCommand('sdnoise2',  1.00), # n_2 (StDev)
    # --- heuristic ------
    paramCommand('pself-heuristic', 0.40), # p_s
    paramCommand('meantrust',       0.63), # tr
    paramCommand('sdtrust',         0.00), # tr
    paramCommand('meanimpact',      1.30), # w_i
    paramCommand('sdimpact',        0.00), # w_i
    paramCommand('meanwanted',     -1.40), # w_e
    paramCommand('sdwanted',        0.00), # w_e
    # --- utilitarian ---- paramCommand('pself-utilitarian', 0.00), # p_s
    paramCommand('meanalpha',         0.96), # alpha
    paramCommand('stdevalpha',        0.00), # alpha
    paramCommand('meanbeta',          0.57), # beta
    paramCommand('stdevbeta',         0.00), # beta
    paramCommand('meaneco',           0.41), # eta
    paramCommand('stdeveco',          0.00), # eta
    paramCommand('meanlambda',        0.61), # lambda
    paramCommand('stdevlambda',       0.00), # lambda
    paramCommand('meangamma1',        0.90), # tau_1
    paramCommand('stdevgamma1',       0.00), # tau_1
    paramCommand('meangamma2',        0.26), # tau_2
    paramCommand('stdevgamma2',       0.00), # tau_2
    # Probabilization obtuseness
    'set probabilization-obtuseness {}'.format(rng.uniform(1,10)),
    # -- Setup commands -- 
    'set modeltype "utilitarian"',
    'set debug False',
    'set best False',
    'setup',
    'calibrate'
    ]
    print('Made setup')
    return setup

def insertModel(modelLine='random 11'):
    lines = open('main.nlogo','r').readlines()
    outFile = open('model_test.nlogo','w')
    tab = '       '
    for i in range(len(lines)):
        if '@EMD' in lines[i]:
            lines[i+1] = '{}{}\n'.format(tab,modelLine)
    outFile.writelines(lines)

def runModel(model, workspaces, samples_per_workspace):
    # Set the model 
    insertModel(model)
    # Fitness result list
    results = []
    # For each workspace
    print('Running {}'.format(model))
    for workspace in workspaces:
        # Open the model
        print('Opening model...')
        workspace.open_model('model_test.nlogo')
        # for samples_per_workspace:
        for i in range(samples_per_workspace):
            # Run the setup commands
            print('New setup...')
            for command in newSetup():
                print(command)
                workspace.command(command)
            print('Commands sent...')
            # Report the fitness
            print('Fitness:')
            fit = workspace.report('fit')
            print(fit)
            results.append(fit)
    return results

def doRun(model):
    concurrent_workspaces = 1
    samples_per_workspace = 1
    nlogo_path = '/home/lux/netlogo-6.0.2/'

    # Initialize nl4py 
    nl4py.initialize(nlogo_path)
    # Create the workspace
    workspaces = [nl4py.create_headless_workspace() for i in range(concurrent_workspaces)]
    results = runModel(model, workspaces, samples_per_workspace)
    resultsFile = open('topModels.csv','a')
    resultsFile.write('{},{}\n'.format(model,results[0]))
    resultsFile.close()

def dispatchRun(model):
    timeout = 30
    process = multiprocessing.Process(target=doRun, args=(model,))
    process.daemon = True
    process.start()
    process.join(timeout)
    time.sleep(3)
    if process.is_alive():
        print(' ####### Process hanging, terminating and trying again.')
        process.terminate()
        dispatchRun(model)

def main():
    # Open the top models file
    models = pd.read_csv('analysis/Top.csv')['Rule'].head(100)
    # For each model
    for model in models:
        # Collect 30 samples
        for i in range(30):
            dispatchRun(model)

if __name__ == '__main__':
    main()
