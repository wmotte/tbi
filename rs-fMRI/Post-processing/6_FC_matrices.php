#!/usr/bin/php
<?php
include 'rs-fmri-setup.php';

## Loop over rats
	foreach ($rats as $rat)
	{
		
		# Define indir en processed dir
		$dir = "$outputdir/$rat/"; 

		# First threshold ROIs, only keep 1-12
		$ROIs = "$dir/regs/rois2rs-fmri-tSNR10-masked.nii.gz";
		$FCROIs = "$dir/regs/FC-rois.nii.gz";

		## Select ROIs	
		system("fslmaths $ROIs -uthr 12 $FCROIs");
	    	    
		## Processing to FC matrix
		print "We are processing rat ".$rat." \n";
		$inputmatrix = "$dir/fc/rs-fmri-afni-filtered-0.01-0.1-mc-regressed.nii.gz";
		$inputmatrix2 = "$dir/fc-alt/rs-fmri-afni-filtered-0.01-0.06-mc-regressed.nii.gz";
		$outputmatrix = "$dir/fc/fc-matrix-z-scores.nii.gz";
		$outputmatrix2 = "$dir/fc-alt/fc-matrix-z-scores.nii.gz";

        	## Calculate output FC matrix for AFNI filtered data
		if(file_exists($inputmatrix) && file_exists($FCROIs))
			{
			system("fcm -i $inputmatrix -o $outputmatrix -x TRUE -l $FCROIs -a 6 --lr 1 12");
			}	

		## Calculate output FC matrix for AFNI filtered data with alternative band-pass filtering (0.01-0.06)
		if(file_exists($inputmatrix2) && file_exists($FCROIs))
			{
			system("fcm -i $inputmatrix2 -o $outputmatrix2 -x TRUE -l $FCROIs -a 6 --lr 1 12");
			}	

        	#### Transform output FC matrices to CSV matrices
		$matrixin = $outputmatrix;
		$matrixin2 = $outputmatrix2;
		
		$matrixcsv = "$dir/fc/fc-matrix-z-scores.csv";
        	$matrixcsv2 = "$dir/fc-alt/fc-matrix-z-scores.csv";

        	## Transform nii-matrix to csv-matrix for AFNI data
		if(file_exists($matrixin))
			{
			system("matrix2csv -i $matrixin -o $matrixcsv");
			}
		
		## Transform nii-matrix to csv-matrix for AFNI data with alternative lowpass/highpass filters
		if(file_exists($matrixin2))
			{
			system("matrix2csv -i $matrixin2 -o $matrixcsv2");
			}
			
}


