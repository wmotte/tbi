#!/usr/bin/php
<?php
include 'rs-fmri-setup.php';

## Loop over all rats and perform AFNI filtering and regression of mc-parameters
	
	foreach ($rats as $rat)
	{
		
		print "We are processing rat ".$rat. "\n";

		# Define input dir and files		
		$inputDir  = $outputdir."/".$rat."/";
		$input = $inputDir ."/fc/rs-fmri-mc-masked.nii.gz";

		# Define output dir and files
		$output = $inputDir ."/fc/rs-fmri-mc-regressed";
		$mask = $inputDir ."/mask_adjusted.nii.gz";
		$motion = $inputDir ."/MCoutput/rs-fmri-mc.par"; 
		$mean = $inputDir ."/MCoutput/rs-fmri-mean.nii.gz";

		if(file_exists($input) && file_exists($motion))
			{
			system("nice fsl_glm --demean -i $input -d $motion -m $mask --out_res=$output");
			system("fslmaths " .$output ." -add " .$mean ." " .$output);
			system("fslmaths " .$output ." -mas " .$mask ." " .$output);
			}
		
		# Define input and output NIFTIs and copies to reset the TR after MC regression
		$outputnifti = $inputDir ."/fc/rs-fmri-mc-regressed.nii.gz";
		$copy = $inputDir ."/fc/rs-fmri-mc-regressed-TR-correct.nii";
		$inputnifti = $inputDir ."/fc/rs-fmri-mc-regressed.nii";
		$copy2 = $inputDir ."/fc/rs-fmri-mc-regressed-TR-correct.nii.gz";
		if(file_exists($copy))
			{
			system("rm $copy");
			}

		if(file_exists($outputnifti) )
			{		
			system("gunzip $outputnifti");
			system("nifti_tool -prefix $copy -infiles $inputnifti -mod_hdr -mod_field pixdim '0 6.0 6.0 6.0 0.9548 0 0 0' ");
			system("gzip $inputnifti");
			system("gzip $copy");
			}

		
		$output2 = $inputDir ."/fc/rs-fmri-afni-filtered-0.01-0.1-mc-regressed.nii.gz";
		
		if(file_exists($copy2) )
			{
			system("nice 3dFourier -prefix " .$output2 ." -highpass 0.01 -lowpass 0.1 " .$copy2 ." -retrend ");
			}		
	
}

?>
