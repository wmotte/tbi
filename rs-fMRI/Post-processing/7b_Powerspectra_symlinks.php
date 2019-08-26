#!/usr/bin/php
<?php
include 'rs-fmri-setup.php';	

## Specify 
$outdir = "/home1/michel/projects/TBI/processing/rs-fMRI/power_spectra/";

// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

## Loop over all rats and construct a symlink to the powerspectrum of each rat
foreach ($rats as $rat)
{
    
    ## Specificy rat working directory
    $dir = "$outputdir/$rat";
               
    ## Make symlink separately for 'standard FC' and alternative FC
    
    if(is_dir($dir) )
        {    
        system("ln -s $dir/fc/FC_AFNI_powerspectrum_mean_signal.png $outdir/AFNI-powerspectrum-$rat.png");    
    
        system("ln -s $dir/fc-alt/FC_AFNI_powerspectrum_mean_signal.png $outdir/AltAFNI-powerspectrum-$rat.png");
        }

}


?>
