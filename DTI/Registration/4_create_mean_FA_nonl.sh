# get all non-linear registered FA maps and create mean image
find ../../. -name FA2ref_nonl.nii.gz > ../../reference/FA_nonl.list
fslmerge -t ../../reference/FA_nonl.nii.gz `find ../../. -name FA2ref_nonl.nii.gz`
fslmaths ../../reference/FA_nonl.nii.gz -Tmean ../../reference/FA_nonl_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ../../reference/FA_nonl_mean.nii.gz 

# create mask
fslmaths ../../reference/FA_nonl_mean.nii.gz -thr 0.01 -bin ../../reference/FA_nonl_mean_mask.nii.gz 
