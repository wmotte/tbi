# get all affine registered rs-fMRI and create mean image
find ../. -name rs-fmri2ref_aff.nii.gz > ./rs-fmri_aff.list
fslmerge -t ./rs-fmri_aff.nii.gz `find ../. -name rs-fmri2ref_aff.nii.gz`
fslmaths ./rs-fmri_aff.nii.gz -Tmean ./rs-fmri_aff_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ./rs-fmri_aff_mean.nii.gz 
