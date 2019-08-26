# get all affine registered T1 and create mean image
find ../. -name T1_2ref_aff.nii.gz > ./T1_aff.list
fslmerge -t ./T1_aff.nii.gz `find ../. -name T1_2ref_aff.nii.gz`
fslmaths ./T1_aff.nii.gz -Tmean ./T1_aff_mean.nii.gz
dbedit -min 0.01 -max 0.05 -i ./T1_aff_mean.nii.gz 
