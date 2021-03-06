[![DOI](https://zenodo.org/badge/204529402.svg)](https://zenodo.org/badge/latestdoi/204529402)

# tbi
All scripts related to the study on traumatic brain injury in rats are available in this repository.
The study is described in:

* Michel R.T. Sinke, Willem M. Otte, Anu E. Meerwaldt, Bart A.A. Franx, Annette van der Toorn, Caroline L. Van Heijningen, Christel E. Smeele, Erwin L.A. Blezer & Rick M. Dijkhuizen. [Changes in sensorimotor function after traumatic brain injury are related to alterations in white matter integrity as shown with MRI in rats](https://journals.sagepub.com/doi/full/10.1177/0271678X19850985), [BS07-6,
Session Brain Injuries: Traumatic, Ischemic, & Hypoxic, 2019]

## Study background

The aim of the present study was to characterize the spatiotemporal pattern of white matter injury with diffusion MRI, and to
elucidate its relationship to changes in sensorimotor function at different levels of traumatic brain injury.

### Methods

We induced mild or moderate TBI in 52 adult male Sprague-Dawley rats using the Marmarou weight-drop-model under isoflurane anesthesia. Fourteen animals underwent a sham procedure.
Diffusion-weighted MRI (4.7T; 2D multislice EPI; isotropic 0.5-mm voxels; b = 1282 s/mm2; 60 diffusion-weighting directions) was done under isoflurane anesthesia prior to injury, and at 1h, 24h, one week, one month and three to four months after injury. 
Images were (non)-linearly registered to a 3D digital rat brain atlas.
Fractional anisotropy, mean diffusivity (MD), axial (AD) and radial diffusivity (RD), were calculated in various white and grey matter regions. Sensorimotor function was assessed from a sensorimotor deficit score and a beam walk test.

### Results

The figure below presents the traumatic brain injury model (1A) and some of the results.
![Figure 1](figures/Figure_1.png)
Sensorimotor deficits were apparent at 24h and one week after moderate brain injury, followed by normalization at later time-points (1B). No deficits were found in the mild injury and sham groups. Radial, axial and mean diffusivity were increased, while the fractional anisotropy (FA) was reduced, in the corpus callosum and hippocampi at 1h, 24h and one week after moderate brain injury (1B). Values normalized over time. Diffusion parameters were not significantly altered in the mild injury and sham groups. There was a strong relationship between sensorimotor function and diffusion parameters in the corpus callosum at 24h after moderate TBI (1C). 

### Data processing

The image processing relies on programs from [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki) and [AFNI](https://afni.nimh.nih.gov) as well as on inhouse C++-tools.
Source code for these tools is provided [here](https://github.com/wmotte/toolkid/).
Binaries – compiled on a Ubuntu 64bit server – are [available](bin/) as well.

The scripts are ordered as follows:
* Anatomical: scripts to process the anatomical scans.
* DTI: scripts to process the diffusion-weighted images.
* rs-fMRI: scripts to process the resting-state functional MRI data.
* T1: scripts to process the T1-weighted images.
* T2: scripts to process the T2/T2-weighted images.
* Atlas_formation: scripts to extract rat brain atlas regions-of-interest.
* Analyses: R scripts for data plotting and statistical analysis.

Sub-directories include:
* BET_preprocessing: brain extraction and addition preprocessing steps, including motion correction.
* BET_optimisation: scripts to optimize brain extraction in rat brain.
* Post_processing: postprocessing scripts, including functional connectivity map constuction and regional quantification.
* Registration: scripts to map images linearly and nonlinearly.

The rat atlas is available in [this](https://github.com/wmotte/rat_brain_atlas) repository.

## License

This project is licensed - see the [LICENSE](LICENSE) file for details
