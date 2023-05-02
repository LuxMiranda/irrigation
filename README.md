This repository contains the code for the 2023 article _Evolutionary Model Discovery of Human Behavioral Factors Driving Decision-Making in Irrigation Experiments_, by Lux Miranda, Jacopo Baggio, and Ozlem Ozmen Garibay published in the Journal of Artificial Societies and Social Simulation. DOI: [https://doi.org/10.18564/jasss.5069](https://doi.org/10.18564/jasss.5069) 

## Contents

* ``emd.py`` - The main file for running evolutionary model discovery
* ``main.nlogo`` - The original irrigation ABM from Baggio et al, surgically modified to allow EMD to change the agent investment behavior
* ``factors.nls`` - The factors themselves (Table 1), in NetLogo!
* ``environment.yml`` - Conda environment file (see below)
* ``log/`` - Log folder where the results from EMD runs are stored 

## Environment setup

This repo uses [conda](https://docs.conda.io/en/latest/miniconda.html) to easily manage Python installation and dependencies! You can set up the required python environment with:
```
conda env create -f environment.yml
```
And then load it with:
```
conda activate emd
```

Lastly, you'll need [NetLogo 6.0.2](https://ccl.northwestern.edu/netlogo/6.0.2/) and change [line 20 in emd.py](https://github.com/LuxMiranda/irrigation/blob/main/emd.py#L20) to direct to your NetLogo-6.0.2 installation folder :) 
