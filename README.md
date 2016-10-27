# neurosci-fisher-information
Example Matlab code illustrating a neural computational model of human sensory discrimination behavior.

## About
The repository contains Matlab functions for fitting low-level, sensory discrimination thresholds e.g., performance of a human observer at discriminating differences in stimulus contrast (c) or orientation (s). The model comsists of three stages: an early **encoding or sensor** stage (i.e., the response of neurons involved in visual processing in the brain), a **noise model** (e.g., Poisson), and a final **decoding or readout** stage (formally defined as the bound on estimation performance, in an information-theoretic sense). Details of the experiments and model derivation can be found in Chapters 2 and 3 of my [PhD thesis](https://sj971.github.io/docs/thesis_sjackson.pdf).

The relevant Matlab files are (in order):
- fisher_singleStim.m (core model code)
- run_fisher_singleStim.m (wrapper for running optimization)
- compute_g_gprime.m (helper file for computing contrast response)
- compute_h_hprime.m (helper file for computing orientation-tuned response)

![Model schematic](schematic_of_model.png)

Note that the optimization routine described in the code was originally run on a High-Performance Computing cluster at NYU, and utilizes a cutting-edge stochastic optimization method known as [Covariance Matrix Adaptation](https://www.lri.fr/~hansen/cmaesintro.html).

### Further details

Details of the experiments and model derivation can be found in Chapters 2 and 3 of my PhD thesis here:                              
http://sj971.github.io/docs/thesis_sjackson.pdf
