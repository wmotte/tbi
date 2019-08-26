#Quick individual analysis for 3d resting state GE-EPI and block design 3d GE-EPI fMRI scans
#Copy files from vnmrj to /home1/tessa/projects/MFGD-EXPERIMENT/data_cohort2/rat'X'

#First process the .fid files using Matlab; use MFGD-EXPERIMENT/process_all_MFGD_data.m

#process bssfp (Change rat number 4 times here)
#for i in `seq 17 32`; do echo $i; mkdir processed_data_cohort2/rat${i}/bssfp; done
#Process data in Matlab using processbssfp.m
for i in `seq 17 32`; do echo $i; cp ../data_cohort2/rat${i}/processed/anatomical.nii.gz rat${i}/bssfp3D_rat${i}.nii.gz; done

#Multiply all with 10 for FSL--> Done in scripts from Annette already (in the .m files)
#for i in `seq 17 32`; do echo $i; changespacing -m 10 -i rat${i}/fMRI_gastric_swapped.nii.gz; done
#check all rats with fslview

#Remove first 20 images to reach steady state
#be in MFGD-EXPERIMENT/processed_data_cohort2
for i in `seq 17 32`; do echo $i; fslroi rat${i}/rsfMRI_noise.nii.gz rat${i}/rsfMRI_noise_180.nii.gz 20 180; done
for i in `seq 17 32`; do echo $i; fslroi rat${i}/rsfMRI_neg_gpe.nii.gz rat${i}/rsfMRI_neg_gpe_180.nii.gz 20 180; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/rsfMRI_pre.nii.gz rat${i}/rsfMRI_pre_780.nii.gz 20 780; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/rsfMRI_inbetween.nii.gz rat${i}/rsfMRI_inbetween_780.nii.gz 20 780; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/rsfMRI_postboth.nii.gz rat${i}/rsfMRI_postboth_780.nii.gz 20 780; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/rsfMRI_inbetweenSS.nii.gz rat${i}/rsfMRI_inbetweenSS_780.nii.gz 20 780; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/fMRI_neg_gpe.nii.gz rat${i}/fMRI_neg_gpe_180.nii.gz 20 180; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/fMRI_sucrose1.nii.gz rat${i}/fMRI_sucrose1_660.nii.gz 20 660; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/fMRI_gastric.nii.gz rat${i}/fMRI_gastric_660.nii.gz 20 660; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/fMRI_salt.nii.gz rat${i}/fMRI_salt_660.nii.gz 20 660; done 
for i in `seq 17 32`; do echo $i; fslroi rat${i}/fMRI_sucrose2.nii.gz rat${i}/fMRI_sucrose2_660.nii.gz 20 660; done 

#Apply motioncorrection
#be in MFGD-EXPERIMENT/processed_data_cohort2
for i in `seq 17 32`; do echo $i; mkdir rat${i}/motioncorrected; done
#noise niet gedaan! for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/rsfMRI_noise_180.nii.gz ; done
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/rsfMRI_neg_gpe_180.nii.gz -o rat${i}/motioncorrected/rsfMRI_neg_gpe_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/rsfMRI_pre_780.nii.gz -o rat${i}/motioncorrected/rsfMRI_pre_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/rsfMRI_inbetween_780.nii.gz -o rat${i}/motioncorrected/rsfMRI_inbetween_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/rsfMRI_postboth_780.nii.gz -o rat${i}/motioncorrected/rsfMRI_postboth_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/rsfMRI_inbetweenSS_780.nii.gz -o rat${i}/motioncorrected/rsfMRI_inbetweenSS_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/fMRI_neg_gpe_180.nii.gz -o rat${i}/motioncorrected/fMRI_neg_gpe_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/fMRI_sucrose1_660.nii.gz -o rat${i}/motioncorrected/fMRI_sucrose1_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/fMRI_gastric_660.nii.gz -o rat${i}/motioncorrected/fMRI_gastric_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/fMRI_salt_660.nii.gz -o rat${i}/motioncorrected/fMRI_salt_mc.nii.gz -meanvol -plots -mats -report; done 
for i in `seq 17 32`; do echo $i; mcflirt -in rat${i}/fMRI_sucrose2_660.nii.gz -o rat${i}/motioncorrected/fMRI_sucrose2_mc.nii.gz -meanvol -plots -mats -report; done 

#Check with fslview! DONE; rat 19, 20, 25 still rubbish

#Create a mean of every set of data
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/rsfMRI_neg_gpe_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_rsfMRI_neg_gpe_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/rsfMRI_pre_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_rsfMRI_pre_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/rsfMRI_inbetween_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_rsfMRI_inbetween_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/rsfMRI_postboth_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_rsfMRI_postboth_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/rsfMRI_inbetweenSS_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_rsfMRI_inbetweenSS_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/fMRI_neg_gpe_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_fMRI_neg_gpe_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/fMRI_sucrose1_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_fMRI_sucrose1_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/fMRI_gastric_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_fMRI_gastric_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/fMRI_salt_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_fMRI_salt_mc.nii.gz; done 
for i in `seq 17 32`; do echo $i; fslmaths rat${i}/motioncorrected/fMRI_sucrose2_mc.nii.gz -Tmean rat${i}/motioncorrected/mean_fMRI_sucrose2_mc.nii.gz; done 

#Apply n3 on mean motioncorrected data for removal of inhomogeneities
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_rsfMRI_neg_gpe_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_rsfMRI_pre_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_rsfMRI_inbetween_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_rsfMRI_postboth_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_rsfMRI_inbetweenSS_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_fMRI_neg_gpe_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_fMRI_sucrose1_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_fMRI_gastric_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_fMRI_salt_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -sf 4 4 2 -fwhm 15; done 
for i in `seq 17 32`; do echo $i; n3 -i rat${i}/motioncorrected/mean_fMRI_sucrose2_mc.nii.gz -o rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -sf 4 4 2 -fwhm 15; done 

#Register all individual bssfp to home1/software/atlases/paxinos/lowres/bssfp.nii.gz
#Be in /disk3/home3/tessa/projects/MFGD-EXPERIMENT/processed_data_cohort2
mkdir bssfp_template
for i in `seq 17 32`; do echo $i; cp rat${i}/bssfp3D_rat${i}.nii.gz bssfp_template/.; done
cd bssfp_template
#perform n3 over individual bssfp's to be able to register them
for i in `seq 17 32`; do echo $i; n3 -i bssfp3D_rat${i}.nii.gz -o bssfp3D_rat${i}_n3.nii.gz --fwhm 7.5 --sf 8.5 10.7 6.4; done
mkdir bet_bssfp
cp bssfp3D_rat*_n3.nii.gz bet_bssfp/
cd bet_bssfp
dividespacing -i bssfp3D_rat17_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat18_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat19_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat20_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat21_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat22_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat23_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat24_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat25_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat26_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat27_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat28_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat29_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat30_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat31_n3.nii.gz -d 1 -m 1.8
dividespacing -i bssfp3D_rat32_n3.nii.gz -d 1 -m 1.8

#Create a mask for every bssfp, to be able to perform a proper flirt
for i in `seq 17 32`; do echo $i; bet bssfp3D_rat${i}_n3.nii.gz bet_bssfp_rat${i}.nii.gz -r 90; done
for i in `seq 17 32`; do echo $i; fslview bet_bssfp_rat${i}.nii.gz bssfp3D_rat${i}_n3.nii.gz; done

for i in `seq 17 32`; do echo ${i}; fslmaths bet_bssfp_rat${i}.nii.gz -bin mask_bssfp_rat${i}.nii.gz; done
for i in `seq 17 32`; do echo ${i}; copyinfo -i mask_bssfp_rat${i}.nii.gz -r ../bssfp3D_rat${i}_n3.nii.gz; done
cp mask_bssfp_rat* ..
cd ..

#mask the bssfps (be in processed_data/registration/bssfp_template)
for i in `seq 17 32`; do echo ${i}; fslmaths bssfp3D_rat${i}_n3.nii.gz -mas mask_bssfp_rat${i}.nii.gz bssfp3D_rat${i}_n3_masked.nii.gz; done
fslview bssfp3D_rat*_n3_masked.nii.gz

#flirt all individual bssfps to home1/software/atlases/paxinos/lowres/bssfp.nii.gz (be in: MFGD-EXPERIMENT/processed_data_cohort2/bssfp_template)
for i in `seq 17 32`; do echo $i; flirt -in bssfp3D_rat${i}_n3_masked.nii.gz -ref ../../../../../../../home1/software/atlases/paxinos/lowres/bssfp.nii.gz -omat bssfp_rat${i}_2_atlas.mat; done
for i in `seq 17 32`; do echo ${i}; flirt -applyxfm -in bssfp3D_rat${i}_n3_masked.nii.gz -ref ../../../../../../../home1/software/atlases/paxinos/lowres/bssfp.nii.gz -init bssfp_rat${i}_2_atlas.mat -o test_rat${i}_bssfpmasked_2_atlas.nii.gz -interp nearestneighbour; done
fslview ../../../../../../../home1/software/atlases/paxinos/lowres/bssfp.nii.gz test_rat*

#Take a mean of registered bssfps and make a bssfp template in waxholm space
fslmerge -t all_flirts_bssfpmasked2atlas.nii.gz test_rat17_bssfpmasked_2_atlas.nii.gz test_rat18_bssfpmasked_2_atlas.nii.gz test_rat19_bssfpmasked_2_atlas.nii.gz test_rat20_bssfpmasked_2_atlas.nii.gz test_rat21_bssfpmasked_2_atlas.nii.gz test_rat22_bssfpmasked_2_atlas.nii.gz test_rat23_bssfpmasked_2_atlas.nii.gz test_rat24_bssfpmasked_2_atlas.nii.gz test_rat25_bssfpmasked_2_atlas.nii.gz test_rat26_bssfpmasked_2_atlas.nii.gz test_rat27_bssfpmasked_2_atlas.nii.gz test_rat28_bssfpmasked_2_atlas.nii.gz test_rat29_bssfpmasked_2_atlas.nii.gz test_rat30_bssfpmasked_2_atlas.nii.gz test_rat31_bssfpmasked_2_atlas.nii.gz test_rat32_bssfpmasked_2_atlas.nii.gz
fslmaths all_flirts_bssfpmasked2atlas.nii.gz -Tmean template_bssfp.nii.gz
fslview template_bssfp.nii.gz
cp template_bssfp.nii.gz ..
cd ..

#Remove the low-intensity border around the bssf_template
fslmaths template_bssfp.nii.gz -thr 0.01 template_bssfp_thresholded.nii.gz
fslmaths template_bssfp_thresholded.nii.gz -bin mask_template_bssfp.nii.gz
fslview template_bssfp_thresholded.nii.gz template_bssfp.nii.gz  mask_template_bssfp.nii.gz 

#Flirt and fnirt individual bssfps to the template_bssfp_thresholded.nii.gz with flirt and fnirt and subsequently take the inverse
#flirt bssfps to bssfptemplate
cd bssfp_template

for i in `seq 17 32`; do echo $i; flirt -in bssfp3D_rat${i}_n3_masked.nii.gz -ref ../template_bssfp_thresholded.nii.gz -omat bssfp_rat${i}_2_bssfptemplate.mat; done

for i in `seq 17 32`; do echo $i; fnirt --config=../../../fnirt_config.sh --in=bssfp3D_rat${i}_n3_masked.nii.gz --ref=../template_bssfp_thresholded.nii.gz --aff=bssfp_rat${i}_2_bssfptemplate.mat --refmask=../mask_template_bssfp.nii.gz --inmask=mask_bssfp_rat${i}.nii.gz --iout=fnirt_rat${i}_bssfp2bssfptemplate.nii.gz --cout=fnirt_rat${i}_bssfp2bssfptemplate.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
fslview  fnirt_rat*_bssfp2bssfptemplate.nii.gz ../template_bssfp_thresholded.nii.gz

for i in `seq 17 32`; do echo $i; invwarp --warp=fnirt_rat${i}_bssfp2bssfptemplate.coef.nii.gz --ref=bssfp3D_rat${i}_n3_masked.nii.gz --out=fnirt_bssfptemplate_2_bssfprat${i}.coef.nii.gz; done
for i in `seq 17 32`; do echo $i; applywarp --ref=bssfp3D_rat${i}_n3_masked.nii.gz --in=../template_bssfp_thresholded.nii.gz --warp=fnirt_bssfptemplate_2_bssfprat${i}.coef.nii.gz --out=test_bssfptemplate_in_rat${i}_space.nii.gz --interp=nn --mask=mask_bssfp_rat${i}.nii.gz; done

fslview test_bssfptemplate_in_rat17_space.nii.gz  bssfp3D_rat17_n3_masked.nii.gz
fslview test_bssfptemplate_in_rat22_space.nii.gz  bssfp3D_rat22_n3_masked.nii.gz
fslview test_bssfptemplate_in_rat31_space.nii.gz  bssfp3D_rat31_n3_masked.nii.gz
#I checked all

#Create templates of all animals per sequence type
#Chose an animal which was nicely positioned in all data sets, which was rat 27
#Flirt individual scans to the same type of scan of rat 27
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -omat registration/rsfMRI_neg_gpe_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -omat registration/rsfMRI_pre_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -omat registration/rsfMRI_inbetween_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -omat registration/rsfMRI_postboth_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -omat registration/rsfMRI_inbetweenSS_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -omat registration/fMRI_neg_gpe_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -omat registration/fMRI_sucrose1_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -omat registration/fMRI_gastric_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -omat registration/fMRI_salt_rat${i}_2_rat27.mat; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -omat registration/fMRI_sucrose2_rat${i}_2_rat27.mat; done 

#Apply flirt to be able to check position
mkdir registration/tests_applyflirt
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -init registration/rsfMRI_neg_gpe_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_rsfMRI_neg_gpe_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -init registration/rsfMRI_pre_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_rsfMRI_pre_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -init registration/rsfMRI_inbetween_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_rsfMRI_inbetween_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -init registration/rsfMRI_postboth_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_rsfMRI_postboth_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -ref rat27/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -init registration/rsfMRI_inbetweenSS_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_rsfMRI_inbetweenSS_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -init registration/fMRI_neg_gpe_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_fMRI_neg_gpe_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -init registration/fMRI_sucrose1_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_fMRI_sucrose1_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -init registration/fMRI_gastric_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_fMRI_gastric_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -init registration/fMRI_salt_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_fMRI_salt_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -ref rat27/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -init registration/fMRI_sucrose2_rat${i}_2_rat27.mat -o registration/tests_applyflirt/test_fMRI_sucrose2_rat${i}_2_rat27.nii.gz -interp nearestneighbour; done

#Create a mean of all scans registered to rat 27, excluding rat 19,20 and 25 because of crappy data
cd registration/tests_applyflirt
fslmerge -t all_tests_rsfMRI_neg_gpe.nii.gz ../../rat27/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz test_rsfMRI_neg_gpe_rat17_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat18_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat21_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat22_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat23_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat24_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat26_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat28_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat29_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat30_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat31_2_rat27.nii.gz test_rsfMRI_neg_gpe_rat32_2_rat27.nii.gz

fslmerge -t all_tests_rsfMRI_pre.nii.gz ../../rat27/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz test_rsfMRI_pre_rat17_2_rat27.nii.gz test_rsfMRI_pre_rat18_2_rat27.nii.gz test_rsfMRI_pre_rat21_2_rat27.nii.gz test_rsfMRI_pre_rat22_2_rat27.nii.gz test_rsfMRI_pre_rat23_2_rat27.nii.gz test_rsfMRI_pre_rat24_2_rat27.nii.gz test_rsfMRI_pre_rat26_2_rat27.nii.gz test_rsfMRI_pre_rat28_2_rat27.nii.gz test_rsfMRI_pre_rat29_2_rat27.nii.gz test_rsfMRI_pre_rat30_2_rat27.nii.gz test_rsfMRI_pre_rat31_2_rat27.nii.gz test_rsfMRI_pre_rat32_2_rat27.nii.gz

fslmerge -t all_tests_rsfMRI_inbetween.nii.gz ../../rat27/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz test_rsfMRI_inbetween_rat17_2_rat27.nii.gz test_rsfMRI_inbetween_rat18_2_rat27.nii.gz test_rsfMRI_inbetween_rat21_2_rat27.nii.gz test_rsfMRI_inbetween_rat22_2_rat27.nii.gz test_rsfMRI_inbetween_rat23_2_rat27.nii.gz test_rsfMRI_inbetween_rat24_2_rat27.nii.gz test_rsfMRI_inbetween_rat26_2_rat27.nii.gz test_rsfMRI_inbetween_rat28_2_rat27.nii.gz test_rsfMRI_inbetween_rat29_2_rat27.nii.gz test_rsfMRI_inbetween_rat30_2_rat27.nii.gz test_rsfMRI_inbetween_rat31_2_rat27.nii.gz test_rsfMRI_inbetween_rat32_2_rat27.nii.gz

fslmerge -t all_tests_rsfMRI_postboth.nii.gz ../../rat27/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz test_rsfMRI_postboth_rat17_2_rat27.nii.gz test_rsfMRI_postboth_rat18_2_rat27.nii.gz test_rsfMRI_postboth_rat21_2_rat27.nii.gz test_rsfMRI_postboth_rat22_2_rat27.nii.gz test_rsfMRI_postboth_rat23_2_rat27.nii.gz test_rsfMRI_postboth_rat24_2_rat27.nii.gz test_rsfMRI_postboth_rat26_2_rat27.nii.gz test_rsfMRI_postboth_rat28_2_rat27.nii.gz test_rsfMRI_postboth_rat29_2_rat27.nii.gz test_rsfMRI_postboth_rat30_2_rat27.nii.gz test_rsfMRI_postboth_rat31_2_rat27.nii.gz test_rsfMRI_postboth_rat32_2_rat27.nii.gz

fslmerge -t all_tests_rsfMRI_inbetweenSS.nii.gz ../../rat27/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz test_rsfMRI_inbetweenSS_rat17_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat18_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat21_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat23_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat24_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat26_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat28_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat29_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat30_2_rat27.nii.gz test_rsfMRI_inbetweenSS_rat32_2_rat27.nii.gz

fslmerge -t all_tests_fMRI_neg_gpe.nii.gz ../../rat27/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz test_fMRI_neg_gpe_rat17_2_rat27.nii.gz test_fMRI_neg_gpe_rat18_2_rat27.nii.gz test_fMRI_neg_gpe_rat21_2_rat27.nii.gz test_fMRI_neg_gpe_rat22_2_rat27.nii.gz test_fMRI_neg_gpe_rat23_2_rat27.nii.gz test_fMRI_neg_gpe_rat24_2_rat27.nii.gz test_fMRI_neg_gpe_rat26_2_rat27.nii.gz test_fMRI_neg_gpe_rat28_2_rat27.nii.gz test_fMRI_neg_gpe_rat29_2_rat27.nii.gz test_fMRI_neg_gpe_rat30_2_rat27.nii.gz test_fMRI_neg_gpe_rat31_2_rat27.nii.gz test_fMRI_neg_gpe_rat32_2_rat27.nii.gz

fslmerge -t all_tests_fMRI_sucrose1.nii.gz ../../rat27/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz test_fMRI_sucrose1_rat17_2_rat27.nii.gz test_fMRI_sucrose1_rat18_2_rat27.nii.gz test_fMRI_sucrose1_rat21_2_rat27.nii.gz test_fMRI_sucrose1_rat22_2_rat27.nii.gz test_fMRI_sucrose1_rat23_2_rat27.nii.gz test_fMRI_sucrose1_rat24_2_rat27.nii.gz test_fMRI_sucrose1_rat26_2_rat27.nii.gz test_fMRI_sucrose1_rat28_2_rat27.nii.gz test_fMRI_sucrose1_rat29_2_rat27.nii.gz test_fMRI_sucrose1_rat30_2_rat27.nii.gz test_fMRI_sucrose1_rat31_2_rat27.nii.gz test_fMRI_sucrose1_rat32_2_rat27.nii.gz

fslmerge -t all_tests_fMRI_gastric.nii.gz ../../rat27/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz test_fMRI_gastric_rat17_2_rat27.nii.gz test_fMRI_gastric_rat18_2_rat27.nii.gz test_fMRI_gastric_rat21_2_rat27.nii.gz test_fMRI_gastric_rat22_2_rat27.nii.gz test_fMRI_gastric_rat23_2_rat27.nii.gz test_fMRI_gastric_rat24_2_rat27.nii.gz test_fMRI_gastric_rat26_2_rat27.nii.gz test_fMRI_gastric_rat28_2_rat27.nii.gz test_fMRI_gastric_rat29_2_rat27.nii.gz test_fMRI_gastric_rat30_2_rat27.nii.gz test_fMRI_gastric_rat31_2_rat27.nii.gz test_fMRI_gastric_rat32_2_rat27.nii.gz

fslmerge -t all_tests_fMRI_salt.nii.gz ../../rat27/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz test_fMRI_salt_rat17_2_rat27.nii.gz test_fMRI_salt_rat21_2_rat27.nii.gz test_fMRI_salt_rat23_2_rat27.nii.gz test_fMRI_salt_rat24_2_rat27.nii.gz test_fMRI_salt_rat26_2_rat27.nii.gz test_fMRI_salt_rat28_2_rat27.nii.gz test_fMRI_salt_rat29_2_rat27.nii.gz test_fMRI_salt_rat30_2_rat27.nii.gz  test_fMRI_salt_rat32_2_rat27.nii.gz

fslmerge -t all_tests_fMRI_sucrose2.nii.gz ../../rat27/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz test_fMRI_sucrose2_rat17_2_rat27.nii.gz test_fMRI_sucrose2_rat18_2_rat27.nii.gz test_fMRI_sucrose2_rat21_2_rat27.nii.gz test_fMRI_sucrose2_rat23_2_rat27.nii.gz test_fMRI_sucrose2_rat24_2_rat27.nii.gz test_fMRI_sucrose2_rat26_2_rat27.nii.gz test_fMRI_sucrose2_rat28_2_rat27.nii.gz test_fMRI_sucrose2_rat29_2_rat27.nii.gz test_fMRI_sucrose2_rat30_2_rat27.nii.gz test_fMRI_sucrose2_rat32_2_rat27.nii.gz
cd ../..
#Take the mean of the merged scans, thereby creating templates
for i in rsfMRI_neg_gpe rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_neg_gpe fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo $i; fslmaths registration/tests_applyflirt/all_tests_${i}.nii.gz -Tmean registration/template_${i}.nii.gz; done
fslview registration/template_*.nii.gz
#Create a bet of the templates
cd registration
mkdir bet_templates
cp template_*.nii.gz bet_templates/
cd bet_templates
dividespacing -i template_fMRI_gastric.nii.gz -d 1 -m 2.4
dividespacing -i template_fMRI_neg_gpe.nii.gz -d 1 -m 2.4
dividespacing -i template_fMRI_salt.nii.gz -d 1 -m 2.4
dividespacing -i template_fMRI_sucrose1.nii.gz -d 1 -m 2.4
dividespacing -i template_fMRI_sucrose2.nii.gz -d 1 -m 2.4
dividespacing -i template_rsfMRI_inbetween.nii.gz -d 1 -m 2.4
dividespacing -i template_rsfMRI_inbetweenSS.nii.gz -d 1 -m 2.4
dividespacing -i template_rsfMRI_neg_gpe.nii.gz -d 1 -m 2.4
dividespacing -i template_rsfMRI_postboth.nii.gz -d 1 -m 2.4
dividespacing -i template_rsfMRI_pre.nii.gz -d 1 -m 2.4

for i in rsfMRI_neg_gpe rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_neg_gpe fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo $i; bet template_${i}.nii.gz bet_template_${i}.nii.gz -r 65; done
for i in rsfMRI_neg_gpe rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_neg_gpe fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo $i; fslview bet_template_${i}.nii.gz template_${i}.nii.gz; done
#Adapted all manually (except for the neg_gpe's), twice...
for i in rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo ${i}; fslmaths bet_template_${i}_manually_adapted2.nii.gz -bin mask_template_${i}.nii.gz; done
for i in rsfMRI_neg_gpe rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_neg_gpe fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo ${i}; copyinfo -i mask_template_${i}.nii.gz -r ../template_${i}.nii.gz; done
cp mask_template_* ..
cd ..
fslview mask_template_*
#Also tried with a threshold
for i in rsfMRI_neg_gpe rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_neg_gpe fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo $i; fslmaths bet_template_${i}.nii.gz -thr 0.114 bet_template_${i}_thresholded.nii.gz; done
fslview bet_template_*_thresholded.nii.gz
#than manually adapted and saved as *TH_MA1.nii.gz
for i in rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo $i; fslmaths bet_template_${i}_TH_MA1.nii.gz -bin mask_template_${i}_TH_MA1.nii.gz; done
for i in rsfMRI_neg_gpe rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_neg_gpe fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo ${i}; copyinfo -i mask_template_${i}_TH_MA1.nii.gz -r ../template_${i}.nii.gz; done
cp mask_template_*_TH_MA1.nii.gz ..
cd ..
fslview mask_template_*_TH_MA1.nii.gz

#Lateron: TH_MA1 trial seemed not as good as originals (with regards to registration); so if you repeat this analysis, leave manual adaption out.

#Lateron: also saved manually adapted (MA) 1 because MA2 seemed to be too small
for i in rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo ${i}; fslmaths bet_template_${i}_manually_adapted.nii.gz -bin mask_template_${i}_MA1.nii.gz; done
#niet dat de neg_gpe's MA zijn, maar anders moet ik heel de tijd aparte lijnen maken, dus toch maar even:
for i in rsfMRI_neg_gpe fMRI_neg_gpe fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo ${i}; fslmaths bet_template_${i}.nii.gz -bin mask_template_${i}_MA1.nii.gz; done
for i in rsfMRI_neg_gpe rsfMRI_pre rsfMRI_inbetween rsfMRI_postboth rsfMRI_inbetweenSS fMRI_neg_gpe fMRI_sucrose1 fMRI_gastric fMRI_salt fMRI_sucrose2; do echo ${i}; copyinfo -i mask_template_${i}_MA1.nii.gz -r ../template_${i}.nii.gz; done
cp mask_template_*_MA1.nii.gz ..

#Register templates to individual data  (also tried indiv scan to template [for rat27 fMRI_gastric] and then inverse, but that was less succesfull)
#(be in MFGD-EXPERIMENT/processed_data_cohort2/registration)
for i in `seq 17 32`; do echo rs_neg_$i; flirt -in template_rsfMRI_neg_gpe.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -omat template_rsfMRI_neg_gpe_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo pre_$i; flirt -in template_rsfMRI_pre.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -omat template_rsfMRI_pre_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo inbetw_$i; flirt -in template_rsfMRI_inbetween.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -omat template_rsfMRI_inbetween_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo postb_$i; flirt -in template_rsfMRI_postboth.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -omat template_rsfMRI_postboth_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo inbSS_$i; flirt -in template_rsfMRI_inbetweenSS.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -omat template_rsfMRI_inbetweenSS_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo fMRI_neg_$i; flirt -in template_fMRI_neg_gpe.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -omat template_fMRI_neg_gpe_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo sucr1_$i; flirt -in template_fMRI_sucrose1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -omat template_fMRI_sucrose1_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo gastr_$i; flirt -in template_fMRI_gastric.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -omat template_fMRI_gastric_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo salt_$i; flirt -in template_fMRI_salt.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -omat template_fMRI_salt_2_rat${i}.mat; done 
for i in `seq 17 32`; do echo sucr2_$i; flirt -in template_fMRI_sucrose2.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -omat template_fMRI_sucrose2_2_rat${i}.mat; done 

#apply flirt to visualize in fslview
for i in `seq 17 32`; do echo rs_neg_$i; flirt -applyxfm -in template_rsfMRI_neg_gpe.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -init template_rsfMRI_neg_gpe_2_rat${i}.mat -o applied_template_rsfMRI_neg_gpe_2_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo pre_$i; flirt -applyxfm -in template_rsfMRI_pre.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -init template_rsfMRI_pre_2_rat${i}.mat -o applied_template_rsfMRI_pre_2_rat${i}.nii.gz -interp nearestneighbour; done 
for i in `seq 17 32`; do echo inbetw_$i; flirt -applyxfm -in template_rsfMRI_inbetween.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -init template_rsfMRI_inbetween_2_rat${i}.mat -o applied_template_rsfMRI_inbetween_2_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo postb_$i; flirt -applyxfm -in template_rsfMRI_postboth.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -init template_rsfMRI_postboth_2_rat${i}.mat -o applied_template_rsfMRI_postboth_2_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo inbSS_$i; flirt -applyxfm -in template_rsfMRI_inbetweenSS.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -init template_rsfMRI_inbetweenSS_2_rat${i}.mat -o applied_template_rsfMRI_inbetweenSS_2_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo fMRI_neg_$i; flirt -applyxfm -in template_fMRI_neg_gpe.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -init template_fMRI_neg_gpe_2_rat${i}.mat -o applied_template_fMRI_neg_gpe_2_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo sucr1_$i; flirt -applyxfm -in template_fMRI_sucrose1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -init template_fMRI_sucrose1_2_rat${i}.mat -o applied_template_fMRI_sucrose1_2_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo gastr_$i; flirt -applyxfm -in template_fMRI_gastric.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -init template_fMRI_gastric_2_rat${i}.mat -o applied_template_fMRI_gastric_2_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo salt_$i; flirt -applyxfm -in template_fMRI_salt.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -init template_fMRI_salt_2_rat${i}.mat -o applied_template_fMRI_salt_2_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo sucr2_$i; flirt -applyxfm -in template_fMRI_sucrose2.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -init template_fMRI_sucrose2_2_rat${i}.mat -o applied_template_fMRI_sucrose2_2_rat${i}.nii.gz -interp nearestneighbour; done
#radomly fslviewed 1 animal per sequence/template

#Apply the registration to the mask of the template and via this way get a mask per animal per sequence without doing a bet for a 1000 times; #Register all masks from the templates to individual space
#mkdir inmasks
for i in `seq 17 32`; do echo rs_neg_$i; flirt -applyxfm -in mask_template_rsfMRI_neg_gpe.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -init template_rsfMRI_neg_gpe_2_rat${i}.mat -o inmasks/mask_rsfMRI_neg_gpe_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo pre_$i; flirt -applyxfm -in mask_template_rsfMRI_pre.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -init template_rsfMRI_pre_2_rat${i}.mat -o inmasks/mask_rsfMRI_pre_rat${i}.nii.gz -interp nearestneighbour; done 
for i in `seq 17 32`; do echo inbetw_$i; flirt -applyxfm -in mask_template_rsfMRI_inbetween.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -init template_rsfMRI_inbetween_2_rat${i}.mat -o inmasks/mask_rsfMRI_inbetween_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo postb_$i; flirt -applyxfm -in mask_template_rsfMRI_postboth.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -init template_rsfMRI_postboth_2_rat${i}.mat -o inmasks/mask_rsfMRI_postboth_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo inbSS_$i; flirt -applyxfm -in mask_template_rsfMRI_inbetweenSS.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -init template_rsfMRI_inbetweenSS_2_rat${i}.mat -o inmasks/mask_rsfMRI_inbetweenSS_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo fMRI_neg_$i; flirt -applyxfm -in mask_template_fMRI_neg_gpe.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -init template_fMRI_neg_gpe_2_rat${i}.mat -o inmasks/mask_fMRI_neg_gpe_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo sucr1_$i; flirt -applyxfm -in mask_template_fMRI_sucrose1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -init template_fMRI_sucrose1_2_rat${i}.mat -o inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo gastr_$i; flirt -applyxfm -in mask_template_fMRI_gastric.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -init template_fMRI_gastric_2_rat${i}.mat -o inmasks/mask_fMRI_gastric_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo salt_$i; flirt -applyxfm -in mask_template_fMRI_salt.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -init template_fMRI_salt_2_rat${i}.mat -o inmasks/mask_fMRI_salt_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo sucr2_$i; flirt -applyxfm -in mask_template_fMRI_sucrose2.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -init template_fMRI_sucrose2_2_rat${i}.mat -o inmasks/mask_fMRI_sucrose2_rat${i}.nii.gz -interp nearestneighbour; done

#Apply the registration to the TH_MA1 mask of the template and via this way get a mask per animal per sequence without doing a bet for a 1000 times; #Register all masks from the templates to individual space
mkdir inmasks_TH_MA1
for i in `seq 17 32`; do echo rs_neg_$i; flirt -applyxfm -in mask_template_rsfMRI_neg_gpe.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -init template_rsfMRI_neg_gpe_2_rat${i}.mat -o inmasks_TH_MA1/mask_rsfMRI_neg_gpe_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo pre_$i; flirt -applyxfm -in mask_template_rsfMRI_pre_TH_MA1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -init template_rsfMRI_pre_2_rat${i}.mat -o inmasks_TH_MA1/mask_rsfMRI_pre_rat${i}.nii.gz -interp nearestneighbour; done 
for i in `seq 17 32`; do echo inbetw_$i; flirt -applyxfm -in mask_template_rsfMRI_inbetween_TH_MA1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -init template_rsfMRI_inbetween_2_rat${i}.mat -o inmasks_TH_MA1/mask_rsfMRI_inbetween_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo postb_$i; flirt -applyxfm -in mask_template_rsfMRI_postboth_TH_MA1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -init template_rsfMRI_postboth_2_rat${i}.mat -o inmasks_TH_MA1/mask_rsfMRI_postboth_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo inbSS_$i; flirt -applyxfm -in mask_template_rsfMRI_inbetweenSS_TH_MA1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -init template_rsfMRI_inbetweenSS_2_rat${i}.mat -o inmasks_TH_MA1/mask_rsfMRI_inbetweenSS_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo fMRI_neg_$i; flirt -applyxfm -in mask_template_fMRI_neg_gpe.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -init template_fMRI_neg_gpe_2_rat${i}.mat -o inmasks_TH_MA1/mask_fMRI_neg_gpe_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo sucr1_$i; flirt -applyxfm -in mask_template_fMRI_sucrose1_TH_MA1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -init template_fMRI_sucrose1_2_rat${i}.mat -o inmasks_TH_MA1/mask_fMRI_sucrose1_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo gastr_$i; flirt -applyxfm -in mask_template_fMRI_gastric_TH_MA1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -init template_fMRI_gastric_2_rat${i}.mat -o inmasks_TH_MA1/mask_fMRI_gastric_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo salt_$i; flirt -applyxfm -in mask_template_fMRI_salt_TH_MA1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -init template_fMRI_salt_2_rat${i}.mat -o inmasks_TH_MA1/mask_fMRI_salt_rat${i}.nii.gz -interp nearestneighbour; done
for i in `seq 17 32`; do echo sucr2_$i; flirt -applyxfm -in mask_template_fMRI_sucrose2_TH_MA1.nii.gz -ref ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -init template_fMRI_sucrose2_2_rat${i}.mat -o inmasks_TH_MA1/mask_fMRI_sucrose2_rat${i}.nii.gz -interp nearestneighbour; done

#Mask individual scans with individual masks
for i in `seq 17 32`; do echo rs_neg_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -mas inmasks/mask_rsfMRI_neg_gpe_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo pre_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -mas inmasks/mask_rsfMRI_pre_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo inbetw_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -mas inmasks/mask_rsfMRI_inbetween_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo postb_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -mas  inmasks/mask_rsfMRI_postboth_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo inbSS_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -mas inmasks/mask_rsfMRI_inbetweenSS_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo fMRI_neg_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -mas inmasks/mask_fMRI_neg_gpe_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo sucr1_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -mas inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo gastr_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -mas inmasks/mask_fMRI_gastric_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo salt_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -mas inmasks/mask_fMRI_salt_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo sucr2_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -mas inmasks/mask_fMRI_sucrose2_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz; done

#Mask individual scans with individual masks; also for inmasks_TH_MA1 masks
for i in `seq 17 32`; do echo rs_neg_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc.nii.gz -mas inmasks_TH_MA1/mask_rsfMRI_neg_gpe_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo pre_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc.nii.gz -mas inmasks_TH_MA1/mask_rsfMRI_pre_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo inbetw_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc.nii.gz -mas inmasks_TH_MA1/mask_rsfMRI_inbetween_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo postb_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc.nii.gz -mas  inmasks_TH_MA1/mask_rsfMRI_postboth_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo inbSS_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc.nii.gz -mas inmasks_TH_MA1/mask_rsfMRI_inbetweenSS_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo fMRI_neg_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc.nii.gz -mas inmasks_TH_MA1/mask_fMRI_neg_gpe_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo sucr1_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz -mas inmasks_TH_MA1/mask_fMRI_sucrose1_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo gastr_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc.nii.gz -mas inmasks_TH_MA1/mask_fMRI_gastric_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo salt_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc.nii.gz -mas inmasks_TH_MA1/mask_fMRI_salt_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked_TH_MA1.nii.gz; done
for i in `seq 17 32`; do echo sucr2_$i; fslmaths ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc.nii.gz -mas inmasks_TH_MA1/mask_fMRI_sucrose2_rat${i}.nii.gz ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked_TH_MA1.nii.gz; done

#Check how well the individual scans are masked, i.e. how well the registration is (not done again for TH_MA1)
dbedit -i ../rat*/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_fMRI_neg_gpe_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz -l 100
dbedit -i ../rat*/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz -l 100

fslview ../rat*/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc_masked.nii.gz #do-able-ish, extra edges
fslview ../rat*/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz #do-able, some extra edges
fslview ../rat*/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz #pretty good (pretty good is better than pretty okay)
fslview ../rat*/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz #pretty okay
fslview ../rat*/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz #okay (pretty okay is better than okay)
fslview ../rat*/motioncorrected/mean_n3_fMRI_neg_gpe_mc_masked.nii.gz #do-able-ish, extra edges
fslview ../rat*/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz #pretty okay
fslview ../rat*/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz #pretty good
fslview ../rat*/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz #okay
fslview ../rat*/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz #pretty okay
cd ..

#Flirt all individual rsfMRI's and fMRI's to individual bssfp, be in MFGD-EXPERIMENT/processed_data_cohort2
#Use the mean_n3_mc_masked of all individual rsfMRIs and fMRIs
#mkdir registration
#HAS A DIFFERENT ORIENTATION! for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_neg_gpe_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_neg_gpe_2_indivbssfp.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_pre_2_indivbssfp.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_inbetween_2_indivbssfp.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_postboth_2_indivbssfp.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_inbetweenSS_2_indivbssfp.mat -cost corratio -nosearch; done 
#HAS A DIFFERENT ORIENTATION! for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_neg_gpe_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_neg_gpe_2_indivbssfp.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_sucrose1_2_indivbssfp.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_gastric_2_indivbssfp.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_salt_2_indivbssfp.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_sucrose2_2_indivbssfp.mat -cost corratio -nosearch; done 

#Trial for TH_MA1 mask:
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked_TH_MA1.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_pre_2_indivbssfp_TH_MA1.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked_TH_MA1.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_inbetween_2_indivbssfp_TH_MA1.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked_TH_MA1.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_postboth_2_indivbssfp_TH_MA1.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked_TH_MA1.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_rsfMRI_inbetweenSS_2_indivbssfp_TH_MA1.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked_TH_MA1.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_sucrose1_2_indivbssfp_TH_MA1.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked_TH_MA1.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_gastric_2_indivbssfp_TH_MA1.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked_TH_MA1.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_salt_2_indivbssfp_TH_MA1.mat -cost corratio -nosearch; done 
for i in `seq 17 32`; do echo $i; flirt -in rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked_TH_MA1.nii.gz -ref bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -omat registration/rat${i}_fMRI_sucrose2_2_indivbssfp_TH_MA1.mat -cost corratio -nosearch; done 

#Take the inverse, resulting in registration from individual bssfp to individual (rs)fMRI
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2rsfMRI_pre.mat -inverse registration/rat${i}_rsfMRI_pre_2_indivbssfp.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2rsfMRI_inbetween.mat -inverse registration/rat${i}_rsfMRI_inbetween_2_indivbssfp.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2rsfMRI_postboth.mat -inverse registration/rat${i}_rsfMRI_postboth_2_indivbssfp.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2rsfMRI_inbetweenSS.mat -inverse registration/rat${i}_rsfMRI_inbetweenSS_2_indivbssfp.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2fMRI_sucrose1.mat -inverse registration/rat${i}_fMRI_sucrose1_2_indivbssfp.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2fMRI_gastric.mat -inverse registration/rat${i}_fMRI_gastric_2_indivbssfp.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2fMRI_salt.mat -inverse registration/rat${i}_fMRI_salt_2_indivbssfp.mat; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2fMRI_sucrose2.mat -inverse registration/rat${i}_fMRI_sucrose2_2_indivbssfp.mat; done 
#TH_MA1 mask trial:
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2rsfMRI_pre_TH_MA1.mat -inverse registration/rat${i}_rsfMRI_pre_2_indivbssfp_TH_MA1.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2rsfMRI_inbetween_TH_MA1.mat -inverse registration/rat${i}_rsfMRI_inbetween_2_indivbssfp_TH_MA1.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2rsfMRI_postboth_TH_MA1.mat -inverse registration/rat${i}_rsfMRI_postboth_2_indivbssfp_TH_MA1.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2rsfMRI_inbetweenSS_TH_MA1.mat -inverse registration/rat${i}_rsfMRI_inbetweenSS_2_indivbssfp_TH_MA1.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2fMRI_sucrose1_TH_MA1.mat -inverse registration/rat${i}_fMRI_sucrose1_2_indivbssfp_TH_MA1.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2fMRI_gastric_TH_MA1.mat -inverse registration/rat${i}_fMRI_gastric_2_indivbssfp_TH_MA1.mat ; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2fMRI_salt_TH_MA1.mat -inverse registration/rat${i}_fMRI_salt_2_indivbssfp_TH_MA1.mat; done 
for i in `seq 17 32`; do echo $i; convert_xfm -omat registration/rat${i}_indivbssfp2fMRI_sucrose2_TH_MA1.mat -inverse registration/rat${i}_fMRI_sucrose2_2_indivbssfp_TH_MA1.mat; done 

#Apply flirt from indiv bssfp to indiv (rs)fMRI
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz -init registration/rat${i}_indivbssfp2rsfMRI_pre.mat -o registration/indivbssfp_rat${i}_in_rsfMRI_pre_space.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz -init registration/rat${i}_indivbssfp2rsfMRI_inbetween.mat -o registration/indivbssfp_rat${i}_in_rsfMRI_inbetween_space.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz -init registration/rat${i}_indivbssfp2rsfMRI_postboth.mat -o registration/indivbssfp_rat${i}_in_rsfMRI_postboth_space.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz -init registration/rat${i}_indivbssfp2rsfMRI_inbetweenSS.mat -o registration/indivbssfp_rat${i}_in_rsfMRI_inbetweenSS_space.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -init registration/rat${i}_indivbssfp2fMRI_sucrose1.mat -o registration/indivbssfp_rat${i}_in_fMRI_sucrose1_space.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz -init registration/rat${i}_indivbssfp2fMRI_gastric.mat -o registration/indivbssfp_rat${i}_in_fMRI_gastric_space.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz -init registration/rat${i}_indivbssfp2fMRI_salt.mat -o registration/indivbssfp_rat${i}_in_fMRI_salt_space.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz -init registration/rat${i}_indivbssfp2fMRI_sucrose2.mat -o registration/indivbssfp_rat${i}_in_fMRI_sucrose2_space.nii.gz; done 
#TH_MA1 mask trial
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked_TH_MA1.nii.gz -init registration/rat${i}_indivbssfp2rsfMRI_pre_TH_MA1.mat -o registration/indivbssfp_rat${i}_in_rsfMRI_pre_space_TH_MA1.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked_TH_MA1.nii.gz -init registration/rat${i}_indivbssfp2rsfMRI_inbetween_TH_MA1.mat -o registration/indivbssfp_rat${i}_in_rsfMRI_inbetween_space_TH_MA1.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked_TH_MA1.nii.gz -init registration/rat${i}_indivbssfp2rsfMRI_postboth_TH_MA1.mat -o registration/indivbssfp_rat${i}_in_rsfMRI_postboth_space_TH_MA1.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked_TH_MA1.nii.gz -init registration/rat${i}_indivbssfp2rsfMRI_inbetweenSS_TH_MA1.mat -o registration/indivbssfp_rat${i}_in_rsfMRI_inbetweenSS_space_TH_MA1.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked_TH_MA1.nii.gz -init registration/rat${i}_indivbssfp2fMRI_sucrose1_TH_MA1.mat -o registration/indivbssfp_rat${i}_in_fMRI_sucrose1_space_TH_MA1.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked_TH_MA1.nii.gz -init registration/rat${i}_indivbssfp2fMRI_gastric_TH_MA1.mat -o registration/indivbssfp_rat${i}_in_fMRI_gastric_space_TH_MA1.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked_TH_MA1.nii.gz -init registration/rat${i}_indivbssfp2fMRI_salt_TH_MA1.mat -o registration/indivbssfp_rat${i}_in_fMRI_salt_space_TH_MA1.nii.gz; done 
for i in `seq 17 32`; do echo $i; flirt -applyxfm -in bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -ref rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked_TH_MA1.nii.gz -init registration/rat${i}_indivbssfp2fMRI_sucrose2_TH_MA1.mat -o registration/indivbssfp_rat${i}_in_fMRI_sucrose2_space_TH_MA1.nii.gz; done 

cd registration

#Check all!
dbedit -i indivbssfp_rat*_in_rsfMRI_pre_space*.nii.gz --max 0.1
dbedit -i indivbssfp_rat*_in_rsfMRI_inbetween_space.nii.gz --max 0.1
dbedit -i indivbssfp_rat*_in_rsfMRI_postboth_space.nii.gz --max 0.1
dbedit -i indivbssfp_rat*_in_rsfMRI_inbetweenSS_space.nii.gz --max 0.1
dbedit -i indivbssfp_rat*_in_fMRI_sucrose1_space.nii.gz --max 0.1
dbedit -i indivbssfp_rat*_in_fMRI_gastric_space.nii.gz --max 0.1
dbedit -i indivbssfp_rat*_in_fMRI_salt_space.nii.gz --max 0.1
dbedit -i indivbssfp_rat*_in_fMRI_sucrose2_space.nii.gz  --max 0.1

for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz indivbssfp_rat${i}_in_rsfMRI_pre_space*; done 
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz indivbssfp_rat${i}_in_rsfMRI_inbetween_space*  ; done 
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz indivbssfp_rat${i}_in_rsfMRI_postboth_space* ; done 
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz indivbssfp_rat${i}_in_rsfMRI_inbetweenSS_space* ; done 
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz indivbssfp_rat${i}_in_fMRI_sucrose1_space*  ; done 
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz indivbssfp_rat${i}_in_fMRI_gastric_space* ; done 
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz indivbssfp_rat${i}_in_fMRI_salt_space* ; done 
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz indivbssfp_rat${i}_in_fMRI_sucrose2_space* ; done 
#TH_MA1 trial
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked_TH_MA1.nii.gz indivbssfp_rat${i}_in_fMRI_sucrose1_space_TH_MA1.nii.gz; done 

##GO FOR OLD VERSION --> NO TH_MA1 TRIAL
#Try fnirt from indivbssfp to indiv (rs)fMRI... (be in processed_data_cohort2)
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2fMRI_sucrose1.mat --refmask=registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done

for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --ref=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --in=rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --aff=registration/rat${i}_fMRI_sucrose1_2_indivbssfp.mat --inmask=registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz --refmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indiv_sucrose1_rat${i}_2_indivbssfp.nii.gz --cout=registration/fnirt_indiv_sucrose1_rat${i}_2_indivbssfp.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done

for i in `seq 17 32`; do echo $i; nice invwarp --warp=registration/fnirt_indiv_sucrose1_rat${i}_2_indivbssfp.coef.nii.gz --ref=rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --out=registration/fnirt_inverse_now_indivbssfp2indivsucr1_rat${i}.coef.nii.gz; done

for i in `seq 17 32`; do echo $i; nice applywarp --ref=rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --warp=registration/fnirt_inverse_now_indivbssfp2indivsucr1_rat${i}.coef.nii.gz --out=registration/test_fnirt_inverse_now_indivbssfp2indivsucr1_rat${i}.nii.gz --interp=nn --mask=registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz; done

for i in `seq 17 32`; do echo $i; fslview rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz registration/indivbssfp_rat${i}_in_fMRI_sucrose1_space.nii.gz registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.nii.gz registration/test_fnirt_inverse_now_indivbssfp2indivsucr1_rat${i}.nii.gz; done

### 'Normal' fnirt is best, better than fnirt via inverse, better than flirt only. 

#Fnirt indivbssfp's to indiv (rs)fMRI
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2rsfMRI_pre.mat --refmask=registration/inmasks/mask_rsfMRI_pre_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_pre.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_pre.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2rsfMRI_inbetween.mat --refmask=registration/inmasks/mask_rsfMRI_inbetween_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_inbetween.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_inbetween.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2rsfMRI_postboth.mat --refmask=registration/inmasks/mask_rsfMRI_postboth_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_postboth.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_postboth.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2rsfMRI_inbetweenSS.mat --refmask=registration/inmasks/mask_rsfMRI_inbetweenSS_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_inbetweenSS.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_inbetweenSS.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2fMRI_sucrose1.mat --refmask=registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2fMRI_gastric.mat --refmask=registration/inmasks/mask_fMRI_gastric_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_gastric.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_gastric.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2fMRI_salt.mat --refmask=registration/inmasks/mask_fMRI_salt_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_salt.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_salt.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2fMRI_sucrose2.mat --refmask=registration/inmasks/mask_fMRI_sucrose2_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose2.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose2.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
 
#check all:
for i in `seq 17 32`; do echo $i; fslview rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz  registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_pre.nii.gz; done
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_inbetween.nii.gz; done
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_postboth.nii.gz; done
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz registration/fnirt_indivbssfp_rat${i}_2_indiv_rs_inbetweenSS.nii.gz; done
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.nii.gz; done
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz registration/fnirt_indivbssfp_rat${i}_2_indiv_gastric.nii.gz; done
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz registration/fnirt_indivbssfp_rat${i}_2_indiv_salt.nii.gz ; done
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo $i; fslview rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose2.nii.gz ; done
#Checked all... what a work!

#Mask 4D data in individual space with specific mask in individual space per sequence to be able to apply the concatenated warp to it (atlas in bssfp_template space to indiv bssfp to indiv (rs)fMRI)
#cd .. --> Be in MFGD-EXPERIMENT/processed_data_cohort2
for i in `seq 17 32`; do echo rsfMRI_neg_gpe$i; fslmaths rat${i}/motioncorrected/rsfMRI_neg_gpe_mc.nii.gz -mas registration/inmasks/mask_rsfMRI_neg_gpe_rat${i}.nii.gz rat${i}/motioncorrected/rsfMRI_neg_gpe_mc_masked.nii.gz; done
for i in `seq 17 32`; do echo rsfMRI_pre$i; fslmaths rat${i}/motioncorrected/rsfMRI_pre_mc.nii.gz -mas registration/inmasks/mask_rsfMRI_pre_rat${i}.nii.gz rat${i}/motioncorrected/rsfMRI_pre_mc_masked.nii.gz; done 
for i in `seq 17 32`; do echo rsfMRI_inbetween_$i; fslmaths rat${i}/motioncorrected/rsfMRI_inbetween_mc.nii.gz -mas registration/inmasks/mask_rsfMRI_inbetween_rat${i}.nii.gz rat${i}/motioncorrected/rsfMRI_inbetween_mc_masked.nii.gz; done 
for i in `seq 17 32`; do echo rsfMRI_postboth_$i; fslmaths rat${i}/motioncorrected/rsfMRI_postboth_mc.nii.gz -mas registration/inmasks/mask_rsfMRI_postboth_rat${i}.nii.gz rat${i}/motioncorrected/rsfMRI_postboth_mc_masked.nii.gz; done 
for i in `seq 17 32`; do echo rsfMRI_inbetweenSS_$i; fslmaths rat${i}/motioncorrected/rsfMRI_inbetweenSS_mc.nii.gz -mas registration/inmasks/mask_rsfMRI_inbetweenSS_rat${i}.nii.gz rat${i}/motioncorrected/rsfMRI_inbetweenSS_mc_masked.nii.gz; done 
for i in `seq 17 32`; do echo fMRI_neg_gpe_$i; fslmaths rat${i}/motioncorrected/fMRI_neg_gpe_mc.nii.gz -mas registration/inmasks/mask_fMRI_neg_gpe_rat${i}.nii.gz rat${i}/motioncorrected/fMRI_neg_gpe_mc_masked.nii.gz; done 
for i in `seq 17 32`; do echo fMRI_sucrose1_$i; fslmaths rat${i}/motioncorrected/fMRI_sucrose1_mc.nii.gz -mas registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz rat${i}/motioncorrected/fMRI_sucrose1_mc_masked.nii.gz; done 
for i in `seq 17 32`; do echo fMRI_gastric_$i; fslmaths rat${i}/motioncorrected/fMRI_gastric_mc.nii.gz -mas registration/inmasks/mask_fMRI_gastric_rat${i}.nii.gz rat${i}/motioncorrected/fMRI_gastric_mc_masked.nii.gz; done 
for i in `seq 17 32`; do echo fMRI_salt_$i; fslmaths rat${i}/motioncorrected/fMRI_salt_mc.nii.gz -mas registration/inmasks/mask_fMRI_salt_rat${i}.nii.gz rat${i}/motioncorrected/fMRI_salt_mc_masked.nii.gz; done 
for i in `seq 17 32`; do echo fMRI_sucrose2_$i; fslmaths rat${i}/motioncorrected/fMRI_sucrose2_mc.nii.gz -mas registration/inmasks/mask_fMRI_sucrose2_rat${i}.nii.gz rat${i}/motioncorrected/fMRI_sucrose2_mc_masked.nii.gz; done 

#Be in MFGD-EXPERIMENT/processed_data_cohort2
#NEW APPROACH = MAKE A PROPER INDIVIDUAL BET ON RAT27 MEAN_N3_FMRI_SUCROSE1.NII.GZ --> FLIRT ALL MASKED FMRI'S TO MASKED RAT27_SUCROSE1 SO THAT DATA STAYS IN EPI-SPACE AND RESOLUTION WOULD BE BLOWN UP WHEN REGISTERED TO BSSFP  (CHECK IF THIS WORKS BECAUSE BETS ARE RETRIEVED FROM REGISTERING MASK FROM TEMPLATES TO INDIVIDUAL FMRI'S). THEN THE GLM CAN BE RUNNED IN RAT27_SUCROSE1 SPACE AND ROIS CAN BE REGISTERED TO THIS SPACE BY REGISTERING THEM FROM BSSFPTEMPLATE TO INDIV BSSFP TO INDIV FMRI TO RAT27_SUCROSE1.
#First create a good bet of rat27_sucrose1
mkdir general_fMRI_template
cp rat27/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz  general_fMRI_template/
cp rat27/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz  general_fMRI_template/
cd  general_fMRI_template/
cp mean_n3_fMRI_sucrose1_mc.nii.gz ./for_bet.nii.gz
dividespacing -i for_bet.nii.gz -d 1 -m 2.5
bet for_bet.nii.gz bet_rat27.nii.gz -c 31 30 17 -r 65; fslview for_bet.nii.gz bet_rat27.nii.gz
fslmaths bet_rat27.nii.gz -thr 0.08 bet_thresholded_rat27_0.08.nii.gz; fslview bet_thresholded_rat27_0.08.nii.gz for_bet.nii.gz 
fslview bet_thresholded_rat27_0.08.nii.gz bet_rat27.nii.gz for_bet.nii.gz #Manually remove non-brain-voxels from bet_thresholded_rat27_0.075.nii.gz!
copyinfo -i bet_thresholded_rat27_0.08_MA.nii.gz -r ../rat27/motioncorrected/mean_n3_fMRI_sucrose1_mc.nii.gz 
fslmaths bet_thresholded_rat27_0.08_MA.nii.gz -bin mask_rat27_sucrose1.nii.gz
fslview mask_rat27_sucrose1.nii.gz mean_n3_fMRI_sucrose1_mc.nii.gz 
fslmaths mean_n3_fMRI_sucrose1_mc.nii.gz -mas mask_rat27_sucrose1.nii.gz rat27_sucrose1_masked.nii.gz
fslview rat27_sucrose1_masked.nii.gz mean_n3_fMRI_sucrose1_mc*

#mean_n3_fMRI_sucrose1_mc_masked.nii.gz is masked with ../registration/inmasks/mask_fMRI_sucrose1_rat27.nii.gz and seems to be better than manually_adapted2...

#Flirt all fMRI's to rat27_sucrose1_masked.nii.gz. Still be in MFGD-EXPERIMENT/processed_data_cohort2/general_fMRI_template.
for i in `seq 17 32`; do echo sucrose1_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -ref rat27_sucrose1_masked.nii.gz -omat rat${i}_sucrose1_2_rat27sucrose1.mat; done 
for i in `seq 17 32`; do echo gastric_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz -ref rat27_sucrose1_masked.nii.gz -omat rat${i}_gastric_2_rat27sucrose1.mat; done 
for i in `seq 17 32`; do echo salt_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz -ref rat27_sucrose1_masked.nii.gz -omat rat${i}_salt_2_rat27sucrose1.mat; done 
for i in `seq 17 32`; do echo sucrose2_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz -ref rat27_sucrose1_masked.nii.gz -omat rat${i}_sucrose2_2_rat27sucrose1.mat; done 
for i in `seq 17 32`; do echo pre_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz -ref rat27_sucrose1_masked.nii.gz -omat rat${i}_rsfMRI_pre_2_rat27sucrose1.mat; done 
for i in `seq 17 32`; do echo inbetween_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz -ref rat27_sucrose1_masked.nii.gz -omat rat${i}_rsfMRI_inbetween_2_rat27sucrose1.mat; done 
for i in `seq 17 32`; do echo postboth_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz -ref rat27_sucrose1_masked.nii.gz -omat rat${i}_rsfMRI_postboth_2_rat27sucrose1.mat; done 
for i in `seq 17 32`; do echo inbetweenSS_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz -ref rat27_sucrose1_masked.nii.gz -omat rat${i}_rsfMRI_inbetweenSS_2_rat27sucrose1.mat; done 

#Fnirt all! with new mask (not template mask from inmasks...)
for i in `seq 17 32`; do echo sucrose1_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --ref=rat27_sucrose1_masked.nii.gz --aff=rat${i}_sucrose1_2_rat27sucrose1.mat --refmask=mask_rat27_sucrose1.nii.gz --inmask=../registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz --iout=fnirt_rat${i}_sucrose1_2_rat27sucrose1.nii.gz --cout=fnirt_rat${i}_sucrose1_2_rat27sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo gastric_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz --ref=rat27_sucrose1_masked.nii.gz --aff=rat${i}_gastric_2_rat27sucrose1.mat --refmask=mask_rat27_sucrose1.nii.gz --inmask=../registration/inmasks/mask_fMRI_gastric_rat${i}.nii.gz --iout=fnirt_rat${i}_gastric_2_rat27sucrose1.nii.gz --cout=fnirt_rat${i}_gastric_2_rat27sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo salt_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz --ref=rat27_sucrose1_masked.nii.gz --aff=rat${i}_salt_2_rat27sucrose1.mat --refmask=mask_rat27_sucrose1.nii.gz --inmask=../registration/inmasks/mask_fMRI_salt_rat${i}.nii.gz --iout=fnirt_rat${i}_salt_2_rat27sucrose1.nii.gz --cout=fnirt_rat${i}_salt_2_rat27sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo sucrose2_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz --ref=rat27_sucrose1_masked.nii.gz --aff=rat${i}_sucrose2_2_rat27sucrose1.mat --refmask=mask_rat27_sucrose1.nii.gz --inmask=../registration/inmasks/mask_fMRI_sucrose2_rat${i}.nii.gz --iout=fnirt_rat${i}_sucrose2_2_rat27sucrose1.nii.gz --cout=fnirt_rat${i}_sucrose2_2_rat27sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo pre_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_rsfMRI_pre_mc_masked.nii.gz --ref=rat27_sucrose1_masked.nii.gz --aff=rat${i}_rsfMRI_pre_2_rat27sucrose1.mat --refmask=mask_rat27_sucrose1.nii.gz --inmask=../registration/inmasks/mask_rsfMRI_pre_rat${i}.nii.gz --iout=fnirt_rat${i}_rsfMRI_pre_2_rat27sucrose1.nii.gz --cout=fnirt_rat${i}_rsfMRI_pre_2_rat27sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo inbetween_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetween_mc_masked.nii.gz --ref=rat27_sucrose1_masked.nii.gz --aff=rat${i}_rsfMRI_inbetween_2_rat27sucrose1.mat --refmask=mask_rat27_sucrose1.nii.gz --inmask=../registration/inmasks/mask_rsfMRI_inbetween_rat${i}.nii.gz --iout=fnirt_rat${i}_rsfMRI_inbetween_2_rat27sucrose1.nii.gz --cout=fnirt_rat${i}_rsfMRI_inbetween_2_rat27sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo postboth_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_rsfMRI_postboth_mc_masked.nii.gz --ref=rat27_sucrose1_masked.nii.gz --aff=rat${i}_rsfMRI_postboth_2_rat27sucrose1.mat --refmask=mask_rat27_sucrose1.nii.gz --inmask=../registration/inmasks/mask_rsfMRI_postboth_rat${i}.nii.gz --iout=fnirt_rat${i}_rsfMRI_postboth_2_rat27sucrose1.nii.gz --cout=fnirt_rat${i}_rsfMRI_postboth_2_rat27sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo inbetweenSS_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_rsfMRI_inbetweenSS_mc_masked.nii.gz --ref=rat27_sucrose1_masked.nii.gz --aff=rat${i}_rsfMRI_inbetweenSS_2_rat27sucrose1.mat --refmask=mask_rat27_sucrose1.nii.gz --inmask=../registration/inmasks/mask_rsfMRI_inbetweenSS_rat${i}.nii.gz --iout=fnirt_rat${i}_rsfMRI_inbetweenSS_2_rat27sucrose1.nii.gz --cout=fnirt_rat${i}_rsfMRI_inbetweenSS_2_rat27sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done

#Check all registrations to rat27_sucrose1
fslview rat27_sucrose1_masked.nii.gz fnirt_rat*_sucrose1_2_rat27sucrose1.nii.gz
fslview rat27_sucrose1_masked.nii.gz fnirt_rat*_gastric_2_rat27sucrose1.nii.gz
fslview rat27_sucrose1_masked.nii.gz fnirt_rat*_salt_2_rat27sucrose1.nii.gz
fslview rat27_sucrose1_masked.nii.gz fnirt_rat*_sucrose2_2_rat27sucrose1.nii.gz 
fslview rat27_sucrose1_masked.nii.gz fnirt_rat*_rsfMRI_pre_2_rat27sucrose1.nii.gz
fslview rat27_sucrose1_masked.nii.gz fnirt_rat*_rsfMRI_inbetween_2_rat27sucrose1.nii.gz
fslview rat27_sucrose1_masked.nii.gz fnirt_rat*_rsfMRI_postboth_2_rat27sucrose1.nii.gz
fslview rat27_sucrose1_masked.nii.gz fnirt_rat*_rsfMRI_inbetweenSS_2_rat27sucrose1.nii.gz

#Some look a bit weird:
#So: create a rsfMRI and a fMRI template by taking the the mean of merged data
fslmerge -t merged_fMRIs.nii.gz rat27_sucrose1_masked.nii.gz fnirt_rat17_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat18_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat21_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat22_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat23_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat24_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat26_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat28_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat29_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat30_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat31_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat32_sucrose1_2_rat27sucrose1.nii.gz fnirt_rat17_gastric_2_rat27sucrose1.nii.gz fnirt_rat18_gastric_2_rat27sucrose1.nii.gz fnirt_rat21_gastric_2_rat27sucrose1.nii.gz fnirt_rat22_gastric_2_rat27sucrose1.nii.gz fnirt_rat23_gastric_2_rat27sucrose1.nii.gz fnirt_rat24_gastric_2_rat27sucrose1.nii.gz fnirt_rat26_gastric_2_rat27sucrose1.nii.gz fnirt_rat27_gastric_2_rat27sucrose1.nii.gz fnirt_rat28_gastric_2_rat27sucrose1.nii.gz fnirt_rat29_gastric_2_rat27sucrose1.nii.gz fnirt_rat30_gastric_2_rat27sucrose1.nii.gz fnirt_rat31_gastric_2_rat27sucrose1.nii.gz fnirt_rat32_gastric_2_rat27sucrose1.nii.gz fnirt_rat17_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat18_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat21_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat23_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat24_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat26_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat27_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat28_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat29_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat30_sucrose2_2_rat27sucrose1.nii.gz  fnirt_rat32_sucrose2_2_rat27sucrose1.nii.gz fnirt_rat17_salt_2_rat27sucrose1.nii.gz fnirt_rat21_salt_2_rat27sucrose1.nii.gz fnirt_rat23_salt_2_rat27sucrose1.nii.gz fnirt_rat24_salt_2_rat27sucrose1.nii.gz fnirt_rat26_salt_2_rat27sucrose1.nii.gz fnirt_rat27_salt_2_rat27sucrose1.nii.gz fnirt_rat28_salt_2_rat27sucrose1.nii.gz fnirt_rat29_salt_2_rat27sucrose1.nii.gz fnirt_rat30_salt_2_rat27sucrose1.nii.gz fnirt_rat32_salt_2_rat27sucrose1.nii.gz
fslmaths merged_fMRIs.nii.gz -Tmean template_fMRI.nii.gz
fslview template_fMRI.nii.gz

#Flirt (and fnirt?) individual fMRI data to template_fMRI
mkdir registrations_2_fMRI_template
for i in 18 22 24; do echo sucrose1_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -ref template_fMRI_thresholded.nii.gz -omat registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI_thr.mat; done 
for i in `seq 17 32`; do echo sucrose1_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -ref template_fMRI.nii.gz -omat registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI.mat; done 
for i in `seq 17 32`; do echo gastric_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz -ref template_fMRI.nii.gz -omat registrations_2_fMRI_template/rat${i}_gastric_2_template_fMRI.mat; done 
for i in `seq 17 32`; do echo salt_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz -ref template_fMRI.nii.gz -omat registrations_2_fMRI_template/rat${i}_salt_2_template_fMRI.mat; done 
for i in `seq 17 32`; do echo sucrose2_$i; flirt -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz -ref template_fMRI.nii.gz -omat registrations_2_fMRI_template/rat${i}_sucrose2_2_template_fMRI.mat; done 

#Apply flirt to see how well it went
for i in 18 22 24; do echo sucrose1_$i; flirt -applyxfm -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -ref template_fMRI_thresholded.nii.gz -init registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI_thr.mat -o registrations_2_fMRI_template/rat${i}_sucrose1_in_template_space_thr.nii.gz ; done 
for i in `seq 17 32`; do echo sucrose1_$i; flirt -applyxfm -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -ref template_fMRI.nii.gz -init registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI.mat -o registrations_2_fMRI_template/rat${i}_sucrose1_in_template_space.nii.gz ; done 
for i in `seq 17 32`; do echo gastric_$i; flirt -applyxfm -in ../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz -ref template_fMRI.nii.gz -init registrations_2_fMRI_template/rat${i}_gastric_2_template_fMRI.mat -o registrations_2_fMRI_template/rat${i}_gastric_in_template_space.nii.gz; done 
for i in `seq 17 32`; do echo salt_$i; flirt -applyxfm -in ../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz -ref template_fMRI.nii.gz -init registrations_2_fMRI_template/rat${i}_salt_2_template_fMRI.mat -o registrations_2_fMRI_template/rat${i}_salt_in_template_space.nii.gz; done 
for i in `seq 17 32`; do echo sucrose2_$i; flirt -applyxfm -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz -ref template_fMRI.nii.gz -init registrations_2_fMRI_template/rat${i}_sucrose2_2_template_fMRI.mat -o registrations_2_fMRI_template/rat${i}_sucrose2_2_template_space.nii.gz; done 

fslview template_fMRI.nii.gz registrations_2_fMRI_template/rat*_sucrose1_in_template_space.nii.gz registrations_2_fMRI_template/rat*_gastric_in_template_space.nii.gz registrations_2_fMRI_template/rat*_salt_in_template_space.nii.gz registrations_2_fMRI_template/rat*_sucrose2_2_template_space.nii.gz

fslview template_fMRI.nii.gz registrations_2_fMRI_template/rat18_sucrose1_in_template_space.nii.gz registrations_2_fMRI_template/rat22_sucrose1_in_template_space.nii.gz registrations_2_fMRI_template/rat24_sucrose1_in_template_space.nii.gz registrations_2_fMRI_template/rat18_sucrose1_in_template_space_thr.nii.gz registrations_2_fMRI_template/rat22_sucrose1_in_template_space_thr.nii.gz registrations_2_fMRI_template/rat24_sucrose1_in_template_space_thr.nii.gz #thresholded of niet maakt letterlijk niets uit voor een flirt!


#Fnirt all to fMRI template
fslmaths template_fMRI.nii.gz -thr 0.027 template_fMRI_thresholded.nii.gz
fslmaths template_fMRI_thresholded.nii.gz -bin mask_template_fMRI.nii.gz
fslview mask_template_fMRI.nii.gz template_fMRI_thresholded.nii.gz
for i in 18 22 24; do echo sucrose1_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --ref=template_fMRI_thresholded.nii.gz --aff=registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI.mat --refmask=mask_template_fMRI.nii.gz --inmask=../registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz --iout=registrations_2_fMRI_template/fnirt_rat${i}_sucrose1_2_template_thr.nii.gz --cout=registrations_2_fMRI_template/fnirt_rat${i}_sucrose1_2_template_thr.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done

for i in `seq 17 32`; do echo sucrose1_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --ref=template_fMRI.nii.gz --aff=registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI.mat --refmask=mask_template_fMRI.nii.gz --inmask=../registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz --iout=registrations_2_fMRI_template/fnirt_rat${i}_sucrose1_2_template.nii.gz --cout=registrations_2_fMRI_template/fnirt_rat${i}_sucrose1_2_template.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo gastric_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz --ref=template_fMRI.nii.gz --aff=registrations_2_fMRI_template/rat${i}_gastric_2_template_fMRI.mat --refmask=mask_template_fMRI.nii.gz --inmask=../registration/inmasks/mask_fMRI_gastric_rat${i}.nii.gz --iout=registrations_2_fMRI_template/fnirt_rat${i}_gastric_2_template.nii.gz --cout=registrations_2_fMRI_template/fnirt_rat${i}_gastric_2_template.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo salt_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz --ref=template_fMRI.nii.gz --aff=registrations_2_fMRI_template/rat${i}_salt_2_template_fMRI.mat --refmask=mask_template_fMRI.nii.gz --inmask=../registration/inmasks/mask_fMRI_salt_rat${i}.nii.gz --iout=registrations_2_fMRI_template/fnirt_rat${i}_salt_2_template.nii.gz --cout=registrations_2_fMRI_template/fnirt_rat${i}_salt_2_template.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done
for i in `seq 17 32`; do echo sucrose2_$i; nice fnirt --config=../../../fnirt_config.sh --in=../rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz --ref=template_fMRI.nii.gz --aff=registrations_2_fMRI_template/rat${i}_sucrose2_2_template_fMRI.mat --refmask=mask_template_fMRI.nii.gz --inmask=../registration/inmasks/mask_fMRI_sucrose2_rat${i}.nii.gz --iout=registrations_2_fMRI_template/fnirt_rat${i}_sucrose2_2_template.nii.gz --cout=registrations_2_fMRI_template/fnirt_rat${i}_sucrose2_2_template.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done

#Compare flirt and fnirt to template from rat 18, 22, 24
cd registrations_2_fMRI_template
fslview ../template_fMRI.nii.gz rat18_gastric_in_template_space.nii.gz  fnirt_rat18_gastric_2_template.nii.gz rat22_gastric_in_template_space.nii.gz fnirt_rat22_gastric_2_template.nii.gz rat24_gastric_in_template_space.nii.gz fnirt_rat24_gastric_2_template.nii.gz
cd ..

cd registrations_2_fMRI_template
fslview ../template_fMRI.nii.gz rat18_sucrose1_in_template_space.nii.gz  fnirt_rat18_sucrose1_2_template.nii.gz fnirt_rat18_sucrose1_2_template_thr.nii.gz fnirt_rat22_sucrose1_2_template.nii.gz fnirt_rat22_sucrose1_2_template_thr.nii.gz fnirt_rat24_sucrose1_2_template.nii.gz fnirt_rat24_sucrose1_2_template_thr.nii.gz
cd .. #doesn't get better when registering to the thresholded template
##ONLY FLIRT IS BETTER!!!

###Register individual fMRI data to fMRI_template space (be in processed_data_cohort2)
mkdir indiv4D_mc_masked_data_in_fMRI_template_space
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo sucrose1_$i; flirt -applyxfm -in rat${i}/motioncorrected/fMRI_sucrose1_mc.nii.gz -ref general_fMRI_template/template_fMRI.nii.gz -init general_fMRI_template/registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI.mat -o indiv4D_mc_masked_data_in_fMRI_template_space/rat${i}_sucrose1_in_template_space.nii.gz ; done 

for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo gastric_$i; flirt -applyxfm -in rat${i}/motioncorrected/fMRI_gastric_mc.nii.gz -ref general_fMRI_template/template_fMRI.nii.gz -init general_fMRI_template/registrations_2_fMRI_template/rat${i}_gastric_2_template_fMRI.mat -o indiv4D_mc_masked_data_in_fMRI_template_space/rat${i}_gastric_in_template_space.nii.gz; done 

for i in 17 21 23 24 26 27 28 29 30 32; do echo salt_$i; flirt -applyxfm -in rat${i}/motioncorrected/fMRI_salt_mc.nii.gz -ref general_fMRI_template/template_fMRI.nii.gz -init general_fMRI_template/registrations_2_fMRI_template/rat${i}_salt_2_template_fMRI.mat -o indiv4D_mc_masked_data_in_fMRI_template_space/rat${i}_salt_in_template_space.nii.gz; done 

for i in 17 18 21 23 24 26 27 28 29 30 32; do echo sucrose2_$i; flirt -applyxfm -in rat${i}/motioncorrected/fMRI_sucrose2_mc.nii.gz -ref general_fMRI_template/template_fMRI.nii.gz -init general_fMRI_template/registrations_2_fMRI_template/rat${i}_sucrose2_2_template_fMRI.mat -o indiv4D_mc_masked_data_in_fMRI_template_space/rat${i}_sucrose2_in_template_space.nii.gz; done 

#And the masked versions
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo sucrose1_$i; flirt -applyxfm -in rat${i}/motioncorrected/fMRI_sucrose1_mc_masked.nii.gz -ref general_fMRI_template/template_fMRI.nii.gz -init general_fMRI_template/registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI.mat -o indiv4D_mc_masked_data_in_fMRI_template_space/rat${i}_sucrose1_in_template_space_masked.nii.gz ; done 

for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo gastric_$i; flirt -applyxfm -in rat${i}/motioncorrected/fMRI_gastric_mc_masked.nii.gz -ref general_fMRI_template/template_fMRI.nii.gz -init general_fMRI_template/registrations_2_fMRI_template/rat${i}_gastric_2_template_fMRI.mat -o indiv4D_mc_masked_data_in_fMRI_template_space/rat${i}_gastric_in_template_space_masked.nii.gz; done 

for i in 17 21 23 24 26 27 28 29 30 32; do echo salt_$i; flirt -applyxfm -in rat${i}/motioncorrected/fMRI_salt_mc_masked.nii.gz -ref general_fMRI_template/template_fMRI.nii.gz -init general_fMRI_template/registrations_2_fMRI_template/rat${i}_salt_2_template_fMRI.mat -o indiv4D_mc_masked_data_in_fMRI_template_space/rat${i}_salt_in_template_space_masked.nii.gz; done 

for i in 17 18 21 23 24 26 27 28 29 30 32; do echo sucrose2_$i; flirt -applyxfm -in rat${i}/motioncorrected/fMRI_sucrose2_mc_masked.nii.gz -ref general_fMRI_template/template_fMRI.nii.gz -init general_fMRI_template/registrations_2_fMRI_template/rat${i}_sucrose2_2_template_fMRI.mat -o indiv4D_mc_masked_data_in_fMRI_template_space/rat${i}_sucrose2_in_template_space_masked.nii.gz; done 

##to be done###Register ROIs from Waxholm space via individual_bssfp_space via individual_fMRI_space to fMRI_template space
##to be done#be in processed_data/registration/bssfp_template
##to be done#fnirt_bssfptemplate_2_bssfprat${i}.coef.nii.gz
##to be done#be in processed_data_cohort2
##to be done for i in `seq 17 32`; do echo $i; nice fnirt --config=../../fnirt_config.sh --in=bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz --ref=rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz --aff=registration/rat${i}_indivbssfp2fMRI_sucrose1.mat --refmask=registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz --inmask=bssfp_template/mask_bssfp_rat${i}.nii.gz --iout=registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.nii.gz --cout=registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.coef.nii.gz  --applyrefmask=1 --applyinmask=1; done

##to be donefor i in `seq 17 32`; do echo sucrose1_$i; fslmaths rat${i}/motioncorrected/fMRI_sucrose1_mc.nii.gz -mas registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz rat${i}/motioncorrected/fMRI_sucrose1_mc_masked.nii.gz; done 

##to be donefor i in `seq 17 32`; do echo sucrose1_$i; flirt -applyxfm -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -ref template_fMRI.nii.gz -init registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI.mat -o registrations_2_fMRI_template/rat${i}_sucrose1_in_template_space.nii.gz ; done 

#From here I copied it from script_first_processing_data_adapted.sh which has to be done before I can switch to script_first_and_second_level_glm.sh
#Normalise all data to be able to concatenate it
#be in MFGD-EXPERIMENT/processed_data_cohort2/indiv4D_mc_masked_data_in_fMRI_template_space
mkdir normalized_data
#go to /disk2/home2/tessa/projects/MFGD-EXPERIMENT/data_cohort2/rat17
pp -f 3Depicor_task_sucrose1_01.fid -k nv 
28
pp -f 3Depicor_task_sucrose1_01.fid -k tr
0.0348
#TR*number of phase encoding directions = sample-spacing=acquisition time per volume
# 0.0348 * 28 = 0.9744 for fMRI = sample-spacing
#go back to processed_data_cohort2/indiv4D_mc_masked_data_in_fMRI_template_space
for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo sucrose1_$i; /home1/anu/R/rsfilter.R --input=rat${i}_sucrose1_in_template_space_masked.nii.gz --output=normalized_data/rat${i}_sucrose1_in_template_space_masked_normalized --sample-spacing=0.9744 --mask=../general_fMRI_template/mask_template_fMRI.nii.gz --lowpass=10000 --highpass=0 --gm=FALSE --detrend=FALSE --intnorm=100 --design0=../rat${i}/motioncorrected/fMRI_sucrose1_mc.nii.gz.par; done 

for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo gastric_$i; /home1/anu/R/rsfilter.R --input=rat${i}_gastric_in_template_space_masked.nii.gz --output=normalized_data/rat${i}_gastric_in_template_space_masked_normalized --sample-spacing=0.9744 --mask=../general_fMRI_template/mask_template_fMRI.nii.gz --lowpass=10000 --highpass=0 --gm=FALSE --detrend=FALSE --intnorm=100 --design0=../rat${i}/motioncorrected/fMRI_gastric_mc.nii.gz.par; done 

for i in 17 21 23 24 26 27 28 29 30 32; do echo salt_$i; /home1/anu/R/rsfilter.R --input=rat${i}_salt_in_template_space_masked.nii.gz --output=normalized_data/rat${i}_salt_in_template_space_masked_normalized --sample-spacing=0.9744 --mask=../general_fMRI_template/mask_template_fMRI.nii.gz --lowpass=10000 --highpass=0 --gm=FALSE --detrend=FALSE --intnorm=100 --design0=../rat${i}/motioncorrected/fMRI_salt_mc.nii.gz.par; done 

for i in 17 18 21 23 24 26 27 28 29 30 32; do echo sucrose2_$i; /home1/anu/R/rsfilter.R --input=rat${i}_sucrose2_in_template_space_masked.nii.gz --output=normalized_data/rat${i}_sucrose2_in_template_space_masked_normalized --sample-spacing=0.9744 --mask=../general_fMRI_template/mask_template_fMRI.nii.gz --lowpass=10000 --highpass=0 --gm=FALSE --detrend=FALSE --intnorm=100 --design0=../rat${i}/motioncorrected/fMRI_sucrose2_mc.nii.gz.par; done
##check of --design0 ook moet voor normaliseren!!
####CONTINUE HERE
#Copy registered 4D normalized data one directory up and copy into right subdirectories according to group
cd normalized_data
mkdir first_sucrose_group
mkdir first_gastric_group
cd first_sucrose_group
mkdir adlib FR
cd ../first_gastric_group
mkdir adlib FR
cd ..

cp rat17_* first_gastric_group/FR/.
cp rat18_* first_gastric_group/adlib/.
cp rat19_* first_sucrose_group/FR/.
cp rat20_* first_sucrose_group/adlib/.
cp rat21_* first_gastric_group/FR/.
cp rat22_* first_gastric_group/adlib/.
cp rat23_* first_sucrose_group/FR/.
cp rat24_* first_sucrose_group/adlib/.
cp rat25_* first_gastric_group/FR/.
cp rat26_* first_gastric_group/adlib/.
cp rat27_* first_sucrose_group/FR/.
cp rat28_* first_sucrose_group/adlib/.
cp rat29_* first_gastric_group/FR/.
cp rat30_* first_gastric_group/adlib/.
cp rat31_* first_sucrose_group/FR/.
cp rat32_* first_sucrose_group/adlib/.

ls first_sucrose_group/FR
ls first_sucrose_group/adlib
ls first_gastric_group/FR
ls first_gastric_group/adlib
ls

#Continue with the not-normalized data, because this should work for first-and-second level GLM approach.
#Copy into separate directories:
#Be in /disk2/home2/tessa/projects/MFGD-EXPERIMENT/processed_data_cohort2/indiv4D_mc_masked_data_in_fMRI_template_space/
mkdir first_sucrose_group
mkdir first_gastric_group
cd first_sucrose_group
mkdir adlib FR
cd ../first_gastric_group
mkdir adlib FR
cd ..

cp rat17_* first_gastric_group/FR/.
cp rat18_* first_gastric_group/adlib/.
cp rat19_* first_sucrose_group/FR/.
cp rat20_* first_sucrose_group/adlib/.
cp rat21_* first_gastric_group/FR/.
cp rat22_* first_gastric_group/adlib/.
cp rat23_* first_sucrose_group/FR/.
cp rat24_* first_sucrose_group/adlib/.
cp rat25_* first_gastric_group/FR/.
cp rat26_* first_gastric_group/adlib/.
cp rat27_* first_sucrose_group/FR/.
cp rat28_* first_sucrose_group/adlib/.
cp rat29_* first_gastric_group/FR/.
cp rat30_* first_gastric_group/adlib/.
cp rat31_* first_sucrose_group/FR/.
cp rat32_* first_sucrose_group/adlib/.

ls first_sucrose_group/FR
ls first_sucrose_group/adlib
ls first_gastric_group/FR
ls first_gastric_group/adlib
ls

#Switch to script script_first_and_second_level_glm_second_cohort.sh

#Continue here if you want to look at signal over time in specific ROIs
#First make ROIs using script_to_get_ROIs_from_paxinos.sh which can be found in: /disk2/home2/tessa/projects/MFGD-EXPERIMENT/processed_data_cohort2/paxinos_rois

#applywarp to get /home1/software/atlases/paxinos/lowres/bssfp.nii.gz  into indiv bssfp space and then into indiv fMRI space (and lateron to fMRI_template if you want to project the ROIs on the GLM maps)

#Be in /disk2/home2/tessa/projects/MFGD-EXPERIMENT/processed_data_cohort2
#mkdir register_rois
#For sucrose1:
for i in `seq 17 32`; do echo ${i}; applywarp -i paxinos_rois/rois_total_ascending_numbers_for_MFGD.nii.gz -o register_rois/rois_total_in_bssfp_rat${i}.nii.gz -r bssfp_template/bssfp3D_rat${i}_n3_masked.nii.gz -m bssfp_template/mask_bssfp_rat${i}.nii.gz -w bssfp_template/fnirt_bssfptemplate_2_bssfprat${i}.coef.nii.gz --interp=nn ; done 
for i in `seq 17 32`; do echo ${i}; applywarp -i register_rois/rois_total_in_bssfp_rat${i}.nii.gz -o register_rois/rois_total_in_sucrose1space_rat${i}.nii.gz -r rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -m registration/inmasks/mask_fMRI_sucrose1_rat${i}.nii.gz -w registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose1.coef.nii.gz --interp=nn ; done 

#For gastric
for i in `seq 17 32`; do echo ${i}; applywarp -i register_rois/rois_total_in_bssfp_rat${i}.nii.gz -o register_rois/rois_total_in_gastricspace_rat${i}.nii.gz -r rat${i}/motioncorrected/mean_n3_fMRI_gastric_mc_masked.nii.gz -m registration/inmasks/mask_fMRI_gastric_rat${i}.nii.gz -w registration/fnirt_indivbssfp_rat${i}_2_indiv_gastric.coef.nii.gz --interp=nn ; done 

#For sucrose2
for i in `seq 17 32`; do echo ${i}; applywarp -i register_rois/rois_total_in_bssfp_rat${i}.nii.gz -o register_rois/rois_total_in_sucrose2space_rat${i}.nii.gz -r rat${i}/motioncorrected/mean_n3_fMRI_sucrose2_mc_masked.nii.gz -m registration/inmasks/mask_fMRI_sucrose2_rat${i}.nii.gz -w registration/fnirt_indivbssfp_rat${i}_2_indiv_sucrose2.coef.nii.gz --interp=nn ; done 

#For salt
for i in `seq 17 32`; do echo ${i}; applywarp -i register_rois/rois_total_in_bssfp_rat${i}.nii.gz -o register_rois/rois_total_in_saltspace_rat${i}.nii.gz -r rat${i}/motioncorrected/mean_n3_fMRI_salt_mc_masked.nii.gz -m registration/inmasks/mask_fMRI_salt_rat${i}.nii.gz -w registration/fnirt_indivbssfp_rat${i}_2_indiv_salt.coef.nii.gz --interp=nn ; done 

## Check if registered ROIs total is good per sucrose1 per rat!
dbedit -i register_rois/rois_total_in_sucrose1space_rat*.nii.gz -l 15
for i in `seq 17 32`; do echo ${i}; fslview rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz register_rois/rois_total_in_sucrose1space_rat${i}.nii.gz  ; done

# Calculate timesignal per rois_total (thus per ROI) per rat and plot it in graphs per rat (thus 32 lines in one graph for each animal)
mkdir timeseries_in_ROIs_test
for i in `seq 17 32`; do echo ${i}; meants -i rat${i}/motioncorrected/fMRI_sucrose1_mc_masked.nii.gz -o timeseries_in_ROIs_test/timeseries_sucrose1_rat${i}.csv -m register_rois/rois_total_in_sucrose1space_rat${i}.nii.gz; done
for i in `seq 17 32`; do echo ${i}; meants -i rat${i}/motioncorrected/fMRI_gastric_mc_masked.nii.gz -o timeseries_in_ROIs_test/timeseries_gastric_rat${i}.csv -m register_rois/rois_total_in_gastricspace_rat${i}.nii.gz; done
for i in `seq 17 32`; do echo ${i}; meants -i rat${i}/motioncorrected/fMRI_sucrose2_mc_masked.nii.gz -o timeseries_in_ROIs_test/timeseries_sucrose2_rat${i}.csv -m register_rois/rois_total_in_sucrose2space_rat${i}.nii.gz; done
for i in `seq 17 32`; do echo ${i}; meants -i rat${i}/motioncorrected/fMRI_salt_mc_masked.nii.gz -o timeseries_in_ROIs_test/timeseries_salt_rat${i}.csv -m register_rois/rois_total_in_saltspace_rat${i}.nii.gz; done

meants -i rat17/motioncorrected/fMRI_sucrose1_mc_masked.nii.gz -o timeseries_in_ROIs_test/timeseries_sucrose1_rat17_test_labels.csv -m register_rois/rois_total_in_sucrose1space_rat17.nii.gz -l labels_rois.txt

##Register ROIs from Waxholm space via individual_bssfp_space via individual_fMRI_space to fMRI_template space
##for i in `seq 17 32`; do echo sucrose1_$i; flirt -applyxfm -in ../rat${i}/motioncorrected/mean_n3_fMRI_sucrose1_mc_masked.nii.gz -ref template_fMRI.nii.gz -init registrations_2_fMRI_template/rat${i}_sucrose1_2_template_fMRI.mat -o registrations_2_fMRI_template/rat${i}_sucrose1_in_template_space.nii.gz ; done 

#Use script 2_dertermine_roi_timeseries.R

#Merge plots per animal
cd output
for i in `seq 17 32`; do echo ${i}; pngappend timeseries_plot_sucrose1_rat${i}.png + timeseries_plot_gastric_rat${i}.png temp_added_rat${i}_horizontally.png; done

for i in `seq 17 32`; do echo ${i}; pngappend timeseries_plot_sucrose2_rat${i}.png + timeseries_plot_salt_rat${i}.png temp_added_rat${i}_horizontally2.png; done

for i in `seq 17 32`; do echo ${i}; pngappend temp_added_rat${i}_horizontally.png - temp_added_rat${i}_horizontally2.png total_graphs_rat${i}.png; done























#For fMRI sucrose and gastric series: try a GLM analysis with mean data and with concatenated data
#First started with concatenation:
fslmerge -t merged_fMRIgastric_GDMF.nii.gz first_gastric_group/FR/fMRI_gastric_rat*_in_bssfptemplatespace_normalized.nii.gz first_gastric_group/adlib/fMRI_gastric_rat*_in_bssfptemplatespace_normalized.nii.gz

fslmerge -t merged_fMRIsucrose_GDMF.nii.gz first_gastric_group/FR/fMRI_sucrose_rat*_in_bssfptemplatespace_normalized.nii.gz first_gastric_group/adlib/fMRI_sucrose_rat*_in_bssfptemplatespace_normalized.nii.gz

fslmerge -t merged_fMRIgastric_MFGD.nii.gz first_sucrose_group/FR/fMRI_gastric_rat*_in_bssfptemplatespace_normalized.nii.gz first_sucrose_group/adlib/fMRI_gastric_rat*_in_bssfptemplatespace_normalized.nii.gz

fslmerge -t merged_fMRIsucrose_MFGD.nii.gz first_sucrose_group/FR/fMRI_sucrose_rat*_in_bssfptemplatespace_normalized.nii.gz first_sucrose_group/adlib/fMRI_sucrose_rat*_in_bssfptemplatespace_normalized.nii.gz

fslmerge -t merged_fMRIgastric_FR.nii.gz first_gastric_group/FR/fMRI_gastric_rat*_in_bssfptemplatespace_normalized.nii.gz first_sucrose_group/FR/fMRI_gastric_rat*_in_bssfptemplatespace_normalized.nii.gz

fslmerge -t merged_fMRIsucrose_FR.nii.gz first_gastric_group/FR/fMRI_sucrose_rat*_in_bssfptemplatespace_normalized.nii.gz first_sucrose_group/FR/fMRI_sucrose_rat*_in_bssfptemplatespace_normalized.nii.gz

fslmerge -t merged_fMRIgastric_adlib.nii.gz first_gastric_group/adlib/fMRI_gastric_rat*_in_bssfptemplatespace_normalized.nii.gz first_sucrose_group/adlib/fMRI_gastric_rat*_in_bssfptemplatespace_normalized.nii.gz

fslmerge -t merged_fMRIsucrose_adlib.nii.gz first_gastric_group/adlib/fMRI_sucrose_rat*_in_bssfptemplatespace_normalized.nii.gz first_sucrose_group/adlib/fMRI_sucrose_rat*_in_bssfptemplatespace_normalized.nii.gz

fslinfo merged_fMRIgastric_GDMF.nii.gz 
fslinfo merged_fMRIsucrose_GDMF.nii.gz
fslinfo merged_fMRIgastric_MFGD.nii.gz
fslinfo merged_fMRIsucrose_MFGD.nii.gz
fslinfo merged_fMRIgastric_FR.nii.gz
fslinfo merged_fMRIsucrose_FR.nii.gz
fslinfo merged_fMRIgastric_adlib.nii.gz
fslinfo merged_fMRIsucrose_adlib.nii.gz
#Check normalization by visually inspecting timeseries in fslview
fslview merged_fMRIgastric_GDMF.nii.gz 
fslview merged_fMRIsucrose_GDMF.nii.gz
fslview merged_fMRIgastric_MFGD.nii.gz
fslview merged_fMRIsucrose_MFGD.nii.gz
fslview merged_fMRIgastric_FR.nii.gz
fslview merged_fMRIsucrose_FR.nii.gz
fslview merged_fMRIgastric_adlib.nii.gz
fslview merged_fMRIsucrose_adlib.nii.gz

#Go to script create_regressors_MFGD.nii.gz to create sucrose and gastric regressor
#Perform glm on concatenated data (notice: this data is unsmoothed!)
#Because rat 9 is excluded because of broken balloon, these groups need the regressor for 7 rats:
merged_fMRIgastric_GDMF.nii.gz 
merged_fMRIsucrose_GDMF.nii.gz
merged_fMRIgastric_FR.nii.gz
merged_fMRIsucrose_FR.nii.gz

#And these need the regressor for 8 rats:
merged_fMRIgastric_MFGD.nii.gz
merged_fMRIsucrose_MFGD.nii.gz
merged_fMRIgastric_adlib.nii.gz
merged_fMRIsucrose_adlib.nii.gz

#Be in:
tessa@lion:/home4/tessa/projects/MFGD-EXPERIMENT/processed_data/registration/individualdata_in_pseudoimage_space$
mkdir output_glm_concatenated
#Perform glm on concatenated data (notice: this data is unsmoothed!)
#RETUNRNS THIS ERROR:
#ols_dof: Error in determining the trace, resorting to basic calculation
#ERROR: contrast matrix GLM design does not match GLM design

for i in merged_fMRIgastric_GDMF merged_fMRIsucrose_GDMF merged_fMRIgastric_FR merged_fMRIsucrose_FR; do echo ${i}; fsl_glm -i ${i}.nii.gz -d regressor_for_7rats.mat -c contrast.con -m ../bssfp_template/mask_template_bssfp_masked.nii.gz -o output_glm_concatenated/glm_output_${i} --demean --out_cope=output_glm_concatenated/output_cope_${i}.nii.gz --out_p=output_glm_concatenated/output_pmap_${i}.nii.gz --out_z=output_glm_concatenated/output_zmap_${i}.nii.gz; done

for i in merged_fMRIgastric_MFGD merged_fMRIsucrose_MFGD merged_fMRIgastric_adlib merged_fMRIsucrose_adlib; do echo ${i}; fsl_glm -i ${i}.nii.gz -d regressor_for_8rats.mat -c contrast.con -m ../bssfp_template/mask_template_bssfp_masked.nii.gz -o output_glm_concatenated/glm_output_${i} --demean --out_cope=output_glm_concatenated/output_cope_${i}.nii.gz --out_p=output_glm_concatenated/output_pmap_${i}.nii.gz --out_z=output_glm_concatenated/output_zmap_${i}.nii.gz; done


#colormaps 2 sigma --> after this trial, make sure to do an fdr-correction for multiple testing!
for i in merged_fMRIgastric_GDMF merged_fMRIsucrose_GDMF merged_fMRIgastric_FR merged_fMRIsucrose_FR merged_fMRIgastric_MFGD merged_fMRIsucrose_MFGD merged_fMRIgastric_adlib merged_fMRIsucrose_adlib; do echo $i; colormap -b ../bssfp_template/template_bssfp_masked.nii.gz  --min 0 --max 0.03 -m ../bssfp_template/mask_template_bssfp_masked.nii.gz -i output_glm_concatenated/output_zmap_${i}.nii.gz output_glm_concatenated/output_zmap_${i}.nii.gz -l winter hot --no-mask -c 6 --lt -2 2 --ut -15 15 -o output_glm_concatenated/colormaps_2sigma_${i}.png --ss 24 --se 130 --skip 3 --sf 12; done 
#--sf 8
eog output_glm_concatenated/colormaps_*.png


#Here follows the trial with mean data per group
#Create a mean; therefore, first add the data series per group
fslmaths output_normalized.nii.gz -add all_data_series_normalized.nii.gz -add all_data_series_normalized.nii.gz 
fslinfo added_fMRIgastric_GDMF.nii.gz 
#Divide intensity by number of added images to create a mean per group
fslmaths added_fMRIgastric_GDMF.nii.gz -div 7 mean_fMRIgastric_GDMF.nii.gz 
fslview mean_fMRI*.nii.gz

#Run a GLM over the mean data per group #check if I did this correct!!!!
mkdir output_glm_meangroups
for i in mean_fMRIgastric_adlib mean_fMRIgastric_GDMF mean_fMRIsucrose_adlib mean_fMRIsucrose_GDMF mean_fMRIgastric_FR mean_fMRIgastric_MFGD mean_fMRIsucrose_FR mean_fMRIsucrose_MFGD; do echo ${i}; fsl_glm -i ${i}.nii.gz -d regressor_1rat.mat -c contrast_1rat.con -m ../bssfp_template/mask_template_bssfp_masked.nii.gz -o output_glm_meangroups/glm_output_${i} --demean --out_cope=output_glm_meangroups/output_cope_mean_${i}.nii.gz --out_p=output_glm_meangroups/output_pmap_${i}.nii.gz --out_z=output_glm_meangroups/output_zmap_${i}.nii.gz; done

#colormaps 2 sigma --> after this trial, make sure to do an fdr-correction for multiple testing!
for i in mean_fMRIgastric_adlib mean_fMRIgastric_GDMF mean_fMRIsucrose_adlib mean_fMRIsucrose_GDMF mean_fMRIgastric_FR mean_fMRIgastric_MFGD mean_fMRIsucrose_FR mean_fMRIsucrose_MFGD; do echo $i; colormap -b ../bssfp_template/template_bssfp_masked.nii.gz  --min 0 --max 0.03 -m ../bssfp_template/mask_template_bssfp_masked.nii.gz -i output_glm_meangroups/output_zmap_${i}.nii.gz output_glm_meangroups/output_zmap_${i}.nii.gz -l winter hot --no-mask -c 6 --lt -2 2 --ut -15 15 -o output_glm_meangroups/colormaps_2sigma_${i}.png --ss 24 --se 130 --skip 3 --sf 12; done 

eog output_glm_meangroups/colormaps_*.png












#COUPLING THE FLIRT TO FNIRT; THIS WAS A NICE IDEA, BUT A GLM ON (RS)FMRI DATA CANNOT BE RUNNED IN BSSFP SPACE (VOXELSIZES ARE MADE SMALLER, RESULTING IN A KIND OF SMOOTHING)
mkdir registered_individual4D_mc_masked_data_in_waxholmspace

for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo sucrose1_$i; applywarp -i rat${i}/motioncorrected/fMRI_sucrose1_mc_masked.nii.gz -o registered_individual4D_mc_masked_data_in_waxholmspace/fMRI_sucrose1_rat${i}.nii.gz -r template_bssfp_thresholded.nii.gz -m mask_template_bssfp.nii.gz -w bssfp_template/fnirt_rat${i}_bssfp2bssfptemplate.coef.nii.gz --premat=registration/rat${i}_fMRI_sucrose1_2_indivbssfp.mat; done 

for i in 17 18 21 22 23 24 26 27 28 29 30 31 32; do echo gastric_$i; applywarp -i rat${i}/motioncorrected/fMRI_gastric_mc_masked.nii.gz -o registered_individual4D_mc_masked_data_in_waxholmspace/fMRI_gastric_rat${i}.nii.gz -r template_bssfp_thresholded.nii.gz -m mask_template_bssfp.nii.gz -w bssfp_template/fnirt_rat${i}_bssfp2bssfptemplate.coef.nii.gz --premat=registration/rat${i}_fMRI_gastric_2_indivbssfp.mat;done 

for i in 17 21 23 24 26 27 28 29 30 32; do echo salt_$i; applywarp -i rat${i}/motioncorrected/fMRI_salt_mc_masked.nii.gz -o registered_individual4D_mc_masked_data_in_waxholmspace/fMRI_salt_rat${i}.nii.gz -r template_bssfp_thresholded.nii.gz -m mask_template_bssfp.nii.gz -w bssfp_template/fnirt_rat${i}_bssfp2bssfptemplate.coef.nii.gz --premat=registration/rat${i}_fMRI_salt_2_indivbssfp.mat; done 

for i in 17 18 21 23 24 26 27 28 29 30 32; do echo sucrose2_$i; applywarp -i rat${i}/motioncorrected/fMRI_sucrose2_mc_masked.nii.gz -o registered_individual4D_mc_masked_data_in_waxholmspace/fMRI_sucrose2_rat${i}.nii.gz -r template_bssfp_thresholded.nii.gz -m mask_template_bssfp.nii.gz -w bssfp_template/fnirt_rat${i}_bssfp2bssfptemplate.coef.nii.gz --premat=registration/rat${i}_fMRI_sucrose2_2_indivbssfp.mat; done 

