# get all nonlinear registered T2 and create mean image
find ../. -name T2_2ref_nonl.nii.gz > ./T2_nonl.list
fslmerge -t ./T2_nonl.nii.gz `find ../. -name T2_2ref_nonl.nii.gz`
fslmaths ./T2_nonl.nii.gz -Tmean ./T2_nonl_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ./T2_nonl_mean.nii.gz 

# create mask
fslmaths ./T2_nonl_mean.nii.gz -thr 0.01 -bin ./T2_nonl_mean_mask.nii.gz
