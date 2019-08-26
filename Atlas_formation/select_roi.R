#!/usr/bin/env Rscript 

# Author:	Wim Otte (w.m.otte@umcutrecht.nl)
# Date: 	09-05-2017
# Aim:		Extract region from atlas

###
# Run
##
run <- function( input, output, csv, name )
{
	library( "oro.nifti" )

	# check labels
	if( !file.exists( csv ) )
	{
		stop( paste( "*** ERROR ***", csv, "does not exist!" ) )
	}

	# check rois
	if( !file.exists( input ) )
	{
		stop( paste( "*** ERROR ***", input, "does not exist!" ) )
	}

	# read labels
	head( d <- read.csv( csv ) )

	# check if name is present als colnames
	if( sum( colnames( d ) %in% name ) == 0 )
	{
		stop( paste( "*** ERROR ***", name, "is not a column in", csv, "!" ) )
	}	

	# ids corresponding with the voxel intensities
	rois <- d[ d[, name ] == 'yes', 'id' ]

	# read column and check if at least one value is 'yes'
	if( length( rois ) == 0 )
	{
		stop( paste( "*** ERROR ***", name, "in", csv, "does not contain any regions!" ) )
	}

	# read input image
	input.image <- readNIfTI( input )

	# set ROI voxels to 1, other voxels to 0
	voxels <- input.image[]
	voxels[ ! voxels %in% rois ] <- 0
	voxels[ voxels %in% rois ] <- 1
		
	# create output object with modified voxels
	output.image <- input.image
	output.image[] <- voxels
	
	# write to disk (remove '.nii.gz' from string as this is added by the function
	oro.nifti::writeNIfTI( output.image, filename = gsub('.{7}$', '', output ), verbose = FALSE )
}

#####################################
# START OPTIONS
#####################################
library( "optparse" )

option_list <- list( 
	make_option( c( "-i", "--input" ), action = "store", help = "Input 3D atlas image (required)" ),
	make_option( c( "-o", "--output" ), action = "store", help = "Output 3D region image (required)" ),
	make_option( c( "-c", "--csv" ), action = "store", help = "Input csv file with name-specific 'yes/no' column (required)" ),
	make_option( c( "-n", "--name" ), action = "store", help = "Column name specified in input csv file (required)" ),
make_option( c( "-v", "--value" ), action = "store", help = "Define value for ROI (required)" ) )

opt <- optparse::parse_args( optparse::OptionParser( option_list = option_list ) )

if( is.null( opt$input ) | is.null( opt$output ) | is.null( opt$csv ) | is.null( opt$name ) )
{
	print_help( optparse::OptionParser( option_list = option_list ) )
	quit()
}

######################################

#opt <- NULL
#opt$input <- 'rois.nii.gz'
#opt$csv <- 'rois.csv'
#opt$name <- 'hippocampus'
#opt$output <- 'out.nii.gz'

# run analysis
run( opt$input, opt$output, opt$csv, opt$name )

