import nl4py
from numpy.random import default_rng; rng = default_rng()

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
    'set debug False',
    'set best False',
    'setup',
    'calibrate'
]

def main():
    concurrent_runs = 1
    n_samples = 3
    nlogo_path = '/home/lux/netlogo-6.0.2/'
    model_path = './main.nlogo'

    nl4py.initialize(nlogo_path)
    workspaces = []
    for i in range(concurrent_runs):
        print('Creating workspace {}'.format(i))
        workspaces.append(nl4py.create_headless_workspace())
        workspaces[i].open_model(model_path)

    for i in range(n_samples):
        for workspace in workspaces:
            for command in setup:
                workspace.command(command)

        for workspace in workspaces:
            print(workspace.report('fit'))

if __name__ == '__main__':
    #main()
    exit(0)
