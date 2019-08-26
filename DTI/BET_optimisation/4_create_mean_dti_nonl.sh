# get all nonlinear registered DTI and create mean image
find ../. -name dti2ref_nonl.nii.gz > ./dti_nonl.list
fslmerge -t ./dti_nonl.nii.gz `find ../. -name dti2ref_nonl.nii.gz`
fslmaths ./dti_nonl.nii.gz -Tmean ./dti_nonl_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ./dti_nonl_mean.nii.gz 

# create mask
fslmaths ./dti_nonl_mean.nii.gz -thr 0.01 -bin ./dti_nonl_mean_mask.nii.gz
