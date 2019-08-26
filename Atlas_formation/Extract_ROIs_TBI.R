### SCRIPT TO EXTRACT SELECTED ROIS FROM PAXINOS ATLAS ###

## Set working directory
setwd("/home1/michel/projects/TBI/atlas/")

## Read in table with selected ROIs
rois <- read.csv("Roi_IDs_TBI_DTI.csv")

## Make TMP directory
dir.create("tmp_TBI")

## Loop over all rois
for ( i in 1:length(rois$name) )
{

roi <- as.character(rois$abbr[i])

system( paste ( "/home1/mriconnect/connect/connect-data-processor/atlas/select_roi.R -i /home1/mriconnect/connect/connect-data-processor/atlas/paxinos_bilateral.nii.gz -o tmp_TBI/roi-", i, ".nii.gz -c /home1/mriconnect/connect/connect-data-processor/atlas/paxinos_bilateral.csv -n ", roi, " -v ", rois$value[[i]], sep = "" ) )

}


## Merge all ROIs in one single atlas (V1) with fslmaths

# First put roi 1 in 'atlas' to enable looping with fslmaths
system( "fslmaths tmp_TBI/roi-1.nii.gz -add 0 tmp_TBI/atlas_TBI.nii.gz" )

for ( i in 2:length(rois$name) )
{

system( paste ( "fslmaths tmp_TBI/atlas_TBI.nii.gz -add tmp_TBI/roi-", i, ".nii.gz tmp_TBI/atlas_TBI.nii.gz", sep = "" ) )

}


## Copy atlas to main folder and remove tmp-file of atlas
system( "cp tmp_TBI/atlas_TBI.nii.gz atlas_TBI_DTI_20190424.nii.gz" )
system( "rm tmp_TBI/atlas_TBI.nii.gz")
