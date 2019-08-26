# get all affine registered BSSFP and create mean image
find ../../. -name bssfp2ref_nonl.nii.gz > ../../reference/bssfp_nonl.list
fslmerge -t ../../reference/bssfp_nonl.nii.gz `find ../../. -name bssfp2ref_nonl.nii.gz`
fslmaths ../../reference/bssfp_nonl.nii.gz -Tmean ../../reference/bssfp_nonl_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ../../reference/bssfp_nonl_mean.nii.gz 

# create mask
fslmaths ../../reference/bssfp_nonl_mean.nii.gz -thr 0.01 -bin ../../reference/bssfp_nonl_mean_mask.nii.gz 
