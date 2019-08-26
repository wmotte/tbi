#!/usr/bin/php
<?php
include 'setup_registration.php';

##################################

####
# Function to extract values (e.g. mean AD, RD) of ROIs from all rats
##
function Hippvals( $indir, $outdir, $subject )
{
    echo "*** Calculate mean FA, AD, RD and MD for ROIs of rat: $subject \n";

	// make outdir if not exists
	if( !is_dir( $outdir) )
		mkdir( $outdir, 0755, true );

    	// define all relevant input and output files
	$FA = "$indir/dtifit/dti_FA.nii.gz";    	
	$AD = "$indir/dtifit/dti_AD.nii.gz";
	$RD = "$indir/dtifit/dti_RD.nii.gz";
	$MD = "$indir/dtifit/dti_MD.nii.gz";
	$outFA = "$outdir/Hipp-FA_new.txt";
	$outAD = "$outdir/Hipp-AD_new.txt";
	$outRD = "$outdir/Hipp-RD_new.txt";
	$outMD = "$outdir/Hipp-MD_new.txt";
	$labels = "$indir/regs/Hipp2FA_nonl.nii.gz";
	
	// extract all values
    {
        
        system("fslmeants -i $FA -o $outFA --label=$labels");
        system("fslmeants -i $AD -o $outAD --label=$labels");
        system("fslmeants -i $RD -o $outRD --label=$labels");
        system("fslmeants -i $MD -o $outMD --label=$labels");

    }
}
##################################

## Loop over all rats
foreach( $rats as $subject )
{  
	
	$indir = "$outputdir/$subject/";
	$outdir = "$outputdir/$subject/ROI_values/";

        if( is_dir( $indir ) )
            Hippvals( $indir, $outdir, $subject );
}


?>
