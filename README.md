# neurosci-fisher-information
Example Matlab code illustrating a neural computational model of human sensory discrimination behavior

## About
The repository contains Matlab functions for fitting human sensory discrimination
thresholds e.g., threshold performance at discriminating two different luminance contrasts, or distinguishing between two different stimulus orientations. 

The model combines early **encoding** or **sensor** components (i.e., neurons involved in visual processing in the brain) with a later **decoding** (i.e., readout) stage. 

Details of the experiments and model-related math can be found in Chapters 2 and 3 of my PhD thesis. 

Note that the optimization routine here was originally run on a high-performance computing cluster, and utilizes a cutting-edge stochastic optimization method known as [Covariance Matrix Adaptation](https://www.lri.fr/~hansen/cmaesintro.html).

![Model schematic](fisher_singleStim_schematic.png)
