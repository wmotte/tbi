#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################


####
# Make registration images to check the registered ROIs.
##
function REGimages ( $indir, $outputdir, $subject )
{
    echo "*** Make FA and ROI images to check registration: $subject \n";

    // inputs
	$rois = "$outputdir/$subject/regs/CC2FA_nonl.nii.gz";
	$ref = "$outputdir/$subject/regs/ref2FA_nonl.nii.gz";
    	$FA = "$outputdir/$subject/dtifit/dti_FA.nii.gz";
	$bet = "$outputdir/$subject/bet_adjusted.nii.gz";

    // output
    $outdir = "$outputdir/TBI_CCrois_checks/";
	
	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    $outputrois = "$outdir/$subject"."_rois.png";
	$outputref = "$outdir/$subject"."_ref.png";
    $outputFA = "$outdir/$subject"."_FA.png";


## Define center of gravity y coordinate + minimum and maximum values for making images  
$cog = round ( system("fslstats $ref -C | awk '{print $2}' ") );
$ss = $cog;
$se = $cog+20;

      
    {

       system("colormap -b $FA --nm -c 4 --ss $ss --se $se --sk 1 --sf 3 -d 1 -o $outputFA");
	#system("colormap -b $ref --nm -c 4 --ss $ss --se $se --sk 1 --sf 3 -d 1 -o $outputref");
        system("colormap -b $FA -i $rois --int 0 -l "."colorcube"." --nm -c 4 --ss $ss --se $se --sk 1 --sf 3 -d 1 -o $outputrois");
        
    }
      

    


}
##################################


foreach( $rats as $subject )
{  
        $indir = "$niidir/$subject";
        $workingdir = "$workingdir";

        if( is_dir( $indir ) )
            REGimages( $indir, $outputdir, $subject );
}


?>
