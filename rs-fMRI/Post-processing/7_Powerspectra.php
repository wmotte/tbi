#!/usr/bin/php
<?php
include 'rs-fmri-setup.php';	

## Loop over rats
		
	foreach ($rats as $rat)
	{

		# Define indir en processed dir
		$dir="$outputdir/$rat";
		
		## Calculate mean signal
		print "We are calculating the mean signal of rat ".$rat. "\n";
		$input1 = "$dir/fc/rs-fmri-afni-filtered-0.01-0.1-mc-regressed.nii.gz";
		$input2 = "$dir/fc-alt/rs-fmri-afni-filtered-0.01-0.06-mc-regressed.nii.gz";
		$mask = "$dir/MCoutput/tSNR10-mask.nii.gz";
		$output1 = "$dir/fc/FC_AFNI_mean_signal.txt";
		$output2 = "$dir/fc-alt/FC_AFNI_mean_signal.txt";

		if(file_exists($input1) && file_exists($input2) && file_exists($mask))
			
			# Calculate mean signal for AFNI filtered fc data
			{
			system("fslmeants -m $mask -i $input1 -o $output1");
			}
			
			# Calculate mean signal for AFNI (mayer wave) filtered fc data
		    	{
			system("fslmeants -m $mask -i $input2 -o $output2");
			}
			
}


	
foreach ($rats as $rat)
	{
		
		# Define indir en processed dir
		$dir="$outputdir/$rat";
	    
		## Calculate power spectrum
		print "We are calculating the powerspectrum of rat ".$rat."\n";
		$input1 = "$dir/fc/FC_AFNI_mean_signal.txt";
		$input2 = "$dir/fc-alt/FC_AFNI_mean_signal.txt";
		$output1 = "$dir/fc/FC_AFNI_powerspectrum_mean_signal.png";
		$output2 = "$dir/fc-alt/FC_AFNI_powerspectrum_mean_signal.png";
		$TR = 0.9548;
	
	    	## Calculate and plot powerspectrum AFNI filtered mean signal
		if(file_exists($input1))
			{
			system("$processdir/Spectra.R " .$input1 ." " .$output1 ." " .$TR);
			}
		
		## Calculate and plot powerspectrum AFNI filtered mean signal (alternative bandwith)
		if(file_exists($input2))
			{
			system("$processdir/Spectra.R " .$input2 ." " .$output2 ." " .$TR);
			}

}




