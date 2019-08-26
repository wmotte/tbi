#!/usr/bin/php
<?php
include 'rs-fmri-setup.php';

## Loop over all rats and perform AFNI filtering and regression of mc-parameters
	
	foreach ($rats as $rat)
	{
		
		print "We are processing rat ".$rat. "\n";

		// make alternative functional connectivity (fc) outdir if not exists
		if( !is_dir( "$outputdir"."/"."$rat/fc-alt/") )
		mkdir( "$outputdir"."/"."$rat/fc-alt/", 0755, true );

		# Define input dir and files		
		$inputDir  = $outputdir."/".$rat."/";
		
		# Define input and output NIFTIs and copies to redo AFNI filtering
		$copy2 = $inputDir ."/fc/rs-fmri-mc-regressed-TR-correct.nii.gz";
		$output2 = $inputDir ."/fc-alt/rs-fmri-afni-filtered-0.01-0.06-mc-regressed.nii.gz";
		
		if(file_exists($copy2) )
			{
			system("nice 3dFourier -prefix " .$output2 ." -highpass 0.01 -lowpass 0.06 " .$copy2 ." -retrend ");
			}		
	
}

?>
