# get all affine registered T2 and create mean image
find ../. -name T2_2ref_aff.nii.gz > ./T2_aff.list
fslmerge -t ./T2_aff.nii.gz `find ../. -name T2_2ref_aff.nii.gz`
fslmaths ./T2_aff.nii.gz -Tmean ./T2_aff_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ./T2_aff_mean.nii.gz 
