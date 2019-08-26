# get all nonlinear registered T1 and create mean image
find ../. -name T1_2ref_nonl.nii.gz > ./T1_nonl.list
fslmerge -t ./T1_nonl.nii.gz `find ../. -name T1_2ref_nonl.nii.gz`
fslmaths ./T1_nonl.nii.gz -Tmean ./T1_nonl_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ./T1_nonl_mean.nii.gz 

# create mask
fslmaths ./T1_nonl_mean.nii.gz -thr 0.01 -bin ./T1_nonl_mean_mask.nii.gz
