from EvolutionaryModelDiscovery import EvolutionaryModelDiscovery
from scoop import futures

# Netlogo path
netlogoPath = '/home/lux/netlogo-6.0.2/'
# Model path. Note that the "./" is necessary. 
modelPath = './main.nlogo'
# Setup commands
setup = ['setup']
# Measurement reporters
measurements = ['fit']
# Number of ticks to run each simulation for
ticks = 14

# Initialize EMD
emd = EvolutionaryModelDiscovery(netlogoPath, modelPath, setup, measurements, ticks, go_command='calibrate')

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
