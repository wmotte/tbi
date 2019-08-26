#!/usr/bin/php
<?php
include 'rs-fmri-setup.php';	

## Loop over rats
	foreach ($rats as $rat)
	{
				
	# Define indir en processed dir
	$Dir = "$outputdir/$rat/";
	    
	    # Make one ROI (extract from S1FL left and right) to calculate FC maps 
	    system("fslmaths $Dir/regs/rois2rs-fmri-tSNR10-masked.nii.gz -thr 7 -uthr 7 $Dir/fc/fcmap_CPU_roi.nii.gz");
	    
		print "We are calculating the fcmap without global mean regression of " .$rat ." \n";
		
		$input1 = "$Dir/fc/rs-fmri-afni-filtered-0.01-0.1-mc-regressed.nii.gz";
		$input2 = "$Dir/fc-alt/rs-fmri-afni-filtered-0.01-0.06-mc-regressed.nii.gz";
		$roi = "$Dir/fc/fcmap_CPU_roi.nii.gz";
		$output1 = "$Dir/fc/fcmap_CPU_AFNI_filtered_mc_regressed.nii.gz";
		$output2 = "$Dir/fc-alt/fcmap_CPU_AFNI_filtered_mc_regressed.nii.gz";
		
		if(file_exists($input1) && file_exists($roi) && file_exists($input2))
			{
			# Calculate FC map based on 1 ROI for AFNI filtered data (normal range)
			system("fcmap -i $input1 -l $roi -o $output1 -z TRUE");

			# Calculate FC map based on 1 ROI for alterative AFNI filtered data (0.01 - 0.06)
			system("fcmap -i $input2 -l $roi -o $output2 -z TRUE");
			
			}
		
}



