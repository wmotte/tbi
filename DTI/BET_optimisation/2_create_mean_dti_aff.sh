# get all affine registered DTI and create mean image
find ../. -name dti2ref_aff.nii.gz > ./dti_aff.list
fslmerge -t ./dti_aff.nii.gz `find ../. -name dti2ref_aff.nii.gz`
fslmaths ./dti_aff.nii.gz -Tmean ./dti_aff_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ./dti_aff_mean.nii.gz 
