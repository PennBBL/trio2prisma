# trio2prisma

The primary purpose of this repository is to document the analyses in the BBL's report regarding the proposed switch from the Siemens Trio scanner "HUP6" to the Siemens Prisma scanner at the University of Pennsylvania. By following the instructions here, it should be possible to reproduce the presented results exactly as they appear in the report.

## Preliminary analyses

Preliminary analyses were performed using Stathis Gennatas's strucpipe and the restbold_pipeline included in this repository. (This version of restbold_pipeline should not be used for any other projects.) Inputs to the restbold_pipeline were provided by wrapper_restbold and wrapper_restbold_hcp.

## Intraclass correlation coefficients

I2C2 was computed by calling R scripts provided by Haochang Shou. The I2C2 scripts were called by I2C2_net.R, I2C2_PCC.R, and I2C2_GMD.R, which reshaped data from each image into a voxelwise vector of observations, in the process masking out image regions that were not of interest.

## Louvain community detection

Louvain community detection was performed using scripts from the Brain Connectivity Toolbox. Z-score of the Rand coefficient was computed using a script from the gen Louvain package on NetWiki.
