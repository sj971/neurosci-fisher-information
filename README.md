# neurosci-fisher-information
Example Matlab code illustrating a neural computational model of human sensory discrimination behavior.

## About
The repository contains Matlab functions for modeling the brain processes underlying sensory decoding i.e., decoding the contrast (c) or orientation (s) of a briefly presented visual stimulus. Behavioral data from n = 7 observers (~2000 trials each) was collected and used for model validation.

The model consists of three core components: an early **encoding or sensor** stage (i.e., a population of neurons involved in processing visual input), a **noise model** defining the response statistics of these neurons (e.g., Poisson-spiking in individual sensory neurons), and a final **decoding or readout** stage (mathematically defined as the bound, in an information-theoretic sense, on estimation performance i.e., Fisher Information).

![Model schematic](schematic_of_model.png)

The relevant Matlab files are:
- fisher_singleStim.m (core model)
- run_fisher_singleStim.m (wrapper for running optimization)
- compute_g_gprime.m (helper file for computing contrast response)
- compute_h_hprime.m (helper file for computing orientation-tuned response)
- thresholds_c_singleStim.mat (raw data from a contrast discrimination experiment)
- thresholds_s_singleStim.mat (raw data from an orientation discrimination experiment)

Note that the optimization routine described in the code was originally run on a High-Performance Computing cluster at NYU, and utilizes a cutting-edge stochastic optimization method known as [Covariance Matrix Adaptation](https://www.lri.fr/~hansen/cmaesintro.html).

### Further details

Details of the experiments and model derivations can be found in Chapters 2 and 3 of my PhD thesis here:                              
http://sj971.github.io/docs/thesis_sjackson.pdf
