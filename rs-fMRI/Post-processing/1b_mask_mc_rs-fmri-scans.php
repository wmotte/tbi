#!/usr/bin/php
<?php 
include 'rs-fmri-setup.php';

foreach($rats as $rat){   

	print "We are masking the resting-state fMRI of " .$rat ."\n";

# Define workdir
$dir="$outputdir/$rat";

// make functional connectivity (fc) outdir if not exists
	if( !is_dir( "$dir/fc/") )
		mkdir( "$dir/fc/", 0755, true );

## Mask functional MRI data for all rats
system("fslmaths $dir/MCoutput/rs-fmri-mc.nii.gz -mas $dir/mask_adjusted.nii.gz $dir/fc/rs-fmri-mc-masked.nii.gz");

}

?>
