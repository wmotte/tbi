# get all affine registered BSSFP and create mean image
find ../../. -name bssfp2ref_aff.nii.gz > ../../reference/bssfp_aff.list
fslmerge -t ../../reference/bssfp_aff.nii.gz `find ../../. -name bssfp2ref_aff.nii.gz`
fslmaths ../../reference/bssfp_aff.nii.gz -Tmean ../../reference/bssfp_aff_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ../../reference/bssfp_aff_mean.nii.gz 
