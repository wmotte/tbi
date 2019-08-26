#!/usr/bin/php
<?php
include 'rs-fmri-setup.php';	

## Loop over rats
foreach ($rats as $rat)
{
    
    ## Specificy rat working directory
    $dir = "$outputdir/$rat";
    
    ## Define input file
    $mri = "$dir/fc/rs-fmri-afni-filtered-0.01-0.1-mc-regressed.nii.gz";
   
    ## Define output directory and output file
    $outdir = "$dir/fc/";
    $timeseries = "$outdir/$rat-AFNI-filtered-timeseries.csv";
       
    ## Specificy ROIs
    $rois = "$dir/regs/FC-rois.nii.gz";
             
    ## Determine timeseries
    print("We are determining AFNI filtered timeseries of ROIs for rat $rat \n");
    
    system("meants -i $mri -o $timeseries -m $rois"); 

}


?>
