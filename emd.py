from EvolutionaryModelDiscovery import EvolutionaryModelDiscovery

# Netlogo path

# Model path
modelPath = 'main.nlogo'
# Setup commands
setup = ['setup', 'calibrate']
# Measurement reporters
measurements = ['fit']
# Number of ticks to run each simulation for
ticks = 100

# Initialize EMD
emd = EvolutionaryModelDiscovery(modelPath, setup, measurements, ticks)
