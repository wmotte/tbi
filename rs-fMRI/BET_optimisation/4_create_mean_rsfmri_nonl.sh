# get all nonlinear registered rs-fMRI and create mean image
find ../. -name rs-fmri2ref_nonl.nii.gz > ./rs-fmri_nonl.list
fslmerge -t ./rs-fmri_nonl.nii.gz `find ../. -name rs-fmri2ref_nonl.nii.gz`
fslmaths ./rs-fmri_nonl.nii.gz -Tmean ./rs-fmri_nonl_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ./rs-fmri_nonl_mean.nii.gz 

# create mask
fslmaths ./rs-fmri_nonl_mean.nii.gz -thr 0.01 -bin ./rs-fmri_nonl_mean_mask.nii.gz
