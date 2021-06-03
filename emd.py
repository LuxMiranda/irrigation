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
    # Values reported in Baggio & Jannsen 2013, Table 3
    # --- pseudorandom ---
    paramCommand('meaninv',   0.00), # inv
    paramCommand('sdinv',     0.00),
    paramCommand('sdnoise',   0.49), # n (StDev)
    paramCommand('sdnoise2',  1.00), # n2 (StDev)
    # --- heuristic ------
    paramCommand('pself',     0.40), # ps
    paramCommand('meantrust', 0.63), # tr
    paramCommand('sdtrust',   0.00),
    # --- utilitarian ----
    'setup'
]
# Measurement reporters
measurements = ['fit', 'fit1', 'fit2', 'fit3', 'fit4', 'fit5']
# Number of ticks to run each simulation for
ticks = 15

# Initialize EMD
emd = EvolutionaryModelDiscovery(netlogoPath, modelPath, setup, measurements,\
        ticks, go_command='calibrate')

# The fitness function, defined simply as "fit" in the literature
def fitness(results):
    print(results)
    return results.mean()[0]

# Minimal hyperparameters
emd.set_replications(1)
emd.set_mutation_rate(0.1)
emd.set_crossover_rate(0.8)
emd.set_generations(1)
#emd.set_generations(20)
emd.set_is_minimize(True)


# Set the objective function
emd.set_objective_function(fitness)

if __name__ == '__main__':
    print(emd.evolve())
    print('Here the thing!')

    emd.shutdown()
