# EMD, when halted before it is allowed to shutdown, can leave behind temporary
# files that interfere with future runs. 
def cleanUpTemporaryFiles():
    import os
    thisdir = os.listdir('./')
    for file in thisdir:
        if file.endswith('.EMD.nlogo'):
            os.remove(os.path.join('./', file))

cleanUpTemporaryFiles()
from EvolutionaryModelDiscovery import EvolutionaryModelDiscovery
from scoop import futures
from numpy.random import default_rng; rng = default_rng()

# Netlogo path
netlogoPath = '/home/lux/netlogo-6.0.2/'
# Model path. Note that the "./" is necessary. 
modelPath = './main.nlogo'


# Return a NetLogo set command for the specified hyperparameter,
# randomly initialized about ±5% of the specified optimal value
def paramCommand(param, value):
    maxNudge     = 0.05
    nudgePercent = rng.uniform(-1*maxNudge, maxNudge)
    nudgedValue  = value + (nudgePercent * value) 
    return 'set {} {}'.format(param, nudgedValue)

# Setup commands
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
    # --- utilitarian ----
    paramCommand('pself-utilitarian', 0.00), # p_s
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
    'set best False',
    'setup'
]
# Measurement reporters
measurements = [
        'fit', 'fit1', 'fit2', 'fit3', 'fit4', 'fit5'
]
# Number of ticks to run each simulation for
ticks = 15

# Initialize EMD
emd = EvolutionaryModelDiscovery(
        netlogo_path=netlogoPath,
        model_path=modelPath,
        setup_commands=setup,
        measurement_reporters=measurements,
        ticks_to_run=ticks,
        go_command='calibrate'
        )

def fitness(results):
    return results['fit'].mean()

# Minimal hyperparameters
emd.set_replications(1)
emd.set_population_size(20)
emd.set_mutation_rate(0.6)
emd.set_crossover_rate(0.8)
emd.set_generations(4)
emd.set_depth(2,8)


# Set the objective function
emd.set_objective_function(fitness)

if __name__ == '__main__':
    print(emd.evolve())
    fi = emd.get_factor_importances_calculator("FactorScores.csv")
    GI = fi.get_gini_importances(interactions=True)
    PI = fi.get_permutation_accuracy_importances(interactions=True)
    print(GI)
    print(PI)
    emd.shutdown()
