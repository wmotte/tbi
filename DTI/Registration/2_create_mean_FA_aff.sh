# get all affine registered FA maps and create mean image
find ../../. -name FA2ref_aff.nii.gz > ../../reference/FA_aff.list
fslmerge -t ../../reference/FA_aff.nii.gz `find ../../. -name FA2ref_aff.nii.gz`
fslmaths ../../reference/FA_aff.nii.gz -Tmean ../../reference/FA_aff_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ../../reference/FA_aff_mean.nii.gz 
