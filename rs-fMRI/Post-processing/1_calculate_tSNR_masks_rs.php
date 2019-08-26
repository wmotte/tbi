#!/usr/bin/php
<?php
include 'rs-fmri-setup.php';


	foreach ($rats as $rat)
	{
				
        $dir="$outputdir/$rat";
		
		print "We are calculating the resting-state fMRI tSNRmask for  rat " .$rat ."\n";
	
		#Calculate standard devation over time
		$input = $dir ."/MCoutput/rs-fmri-mc.nii.gz";
		$output = $dir ."/MCoutput/rs-fmri-Tstd.nii.gz";

		#if(file_exists($input) &&! file_exists($output))
			{
			system("fslmaths " .$input ." -Tstd " .$output);
			}

		#Calculate tSNR by mean/Tstd
		$input = $dir ."/MCoutput/rs-fmri-mean.nii.gz";
		$output = $dir ."/MCoutput/rs-fmri-tSNR.nii.gz";
		$tstd = $dir ."/MCoutput/rs-fmri-Tstd.nii.gz";
		#if(file_exists($input) && file_exists($tstd) &&! file_exists($output))
			{
			system("fslmaths " .$input ." -div " .$tstd ." " .$output);
			}

		#mask tSNR
		$input = $dir ."/MCoutput/rs-fmri-tSNR.nii.gz";
		$mask = $dir ."/mask_adjusted.nii.gz";
		$output = $dir ."/MCoutput/rs-fmri-tSNR-masked.nii.gz";
		#if(file_exists($input) && file_exists($mask) &&! file_exists($output))
			{
			system("fslmaths " .$input ." -mas " .$mask ." " .$output);
			}

		#Make tSNR10 by thresholding at 10 and binarizing
		$input = $dir ."/MCoutput/rs-fmri-tSNR-masked.nii.gz";
		$output = $dir ."/MCoutput/tSNR10-mask.nii.gz";
		#if(file_exists($input) &&! file_exists($output))
			{
			system("fslmaths " .$input ." -thr 10 -bin " .$output);
			}
}

### Threshold ROIs in subject space

foreach ($rats as $rat)
	{
        $dir="$outputdir/$rat";
		
		print "We are thresholding the ROIs for rat " .$rat ."\n";
		$input = $dir ."/regs/rois2rs-fmri.nii.gz";
		$mask = $dir ."/MCoutput/tSNR10-mask.nii.gz";
		$output = $dir ."/regs/rois2rs-fmri-tSNR10-masked.nii.gz";
		#if(file_exists($input) && file_exists($mask) &&! file_exists($output))
			{
			system("fslmaths " .$input ." -mas " .$mask ." " .$output);
			}
		

}


########### CHECK MASKS BY MAKING IMAGES #########
####
# Make images to check the tSNR images.
##
function MASKimages ( $indir, $outputdir, $subject, $processdir )
{
    echo "*** Make images to check tSNR image, mask and ROIs for: $subject \n";

    // inputs
	$image = "$outputdir/$subject/MCoutput/rs-fmri-mean.nii.gz";    	
	$tsnr = "$outputdir/$subject/MCoutput/rs-fmri-tSNR-masked.nii.gz";
	$mask = "$outputdir/$subject/MCoutput/tSNR10-mask.nii.gz";
    	$rois = "$outputdir/$subject/regs/rois2rs-fmri-tSNR10-masked.nii.gz";

    // output
    $outdir = "$processdir/tsnr_mask_checks/";
	
	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	$output_image = "$outdir/$subject"."_image.png";
    	$output_tsnr = "$outdir/$subject"."_imtsnr.png";
	$output_mask = "$outdir/$subject"."_mask.png";
	$output_rois = "$outdir/$subject"."_rois.png";
  
    ## Make color maps of all images
    {
       system("colormap -b $image --nm  -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $output_image");
        system("colormap -b $tsnr ---nm -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $output_tsnr");
	system("colormap -b $mask --nm  -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $output_mask");
        system("colormap -b $rois ---nm -c 4 --ss 10 --se 52 --sk 4 -d 1 --scale 4 -o $output_rois");
        
    }
      
    

}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
        $workingdir = "$workingdir";

        if( is_dir( $indir ) )
            MASKimages( $indir, $outputdir, $subject, $processdir );
}



?>
