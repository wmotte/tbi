#!/usr/bin/Rscript --no-save --no-restore

library('ggplot2', lib.loc="/home1/michel/R/x86_64-pc-linux-gnu-library/3.2/")
library('gridExtra', lib.loc="/home1/michel/R/x86_64-pc-linux-gnu-library/3.2/")
library('labeling', lib.loc="/home1/michel/R/x86_64-pc-linux-gnu-library/3.2/")
###################################################################################################

args <- commandArgs( T ) 

input <- args[ 1 ] 			# raw.txt
output <- args[ 2 ] 		# power_spectral_density.png
tr <- as.numeric( args[ 3 ] )	# TR (in seconds (e.g. 0.7))

if( file.exists( input ) == FALSE )
	stop( paste( "File: ", input, "does not exist!" ) )

# read input
data <- read.table( input )

# get total number of volumes
nvolumes <- nrow( data )
nsecs <- nvolumes * tr

print( paste( "Number of volumes:", nvolumes ) )
print( paste( "Number of seconds:", nsecs ) )

# axes labels
xlab = expression( bold( paste( "Frequency (Hz)" ) ) )
ylab = expression( bold( paste( "Power (unit"^2, "/frequency)" ) ) )
xlabraw = expression( bold( "Time (sec)" ) )
ylabraw = expression( bold( "Amplitude (a.u.)" ) )

# indicate filtering window for rs-fMRI analysis
lines <- geom_vline( xintercept = c( 0.01, 0.1 ), linetype="dotted" )

# convert to time-series (frequency in Hz (e.g. s-1))
xt <- ts( data$V1, frequency = nvolumes / nsecs )

# get power spectral density
spec <- stats::spec.pgram( xt, pad = 1, taper = 0, plot = FALSE )

# plots with and without log scale
d <- data.frame( spec = spec$spec, freq = spec$freq )
p <- ggplot( data = d, aes( x = freq, y = spec ) ) + geom_line( color = 'darkred' ) + xlab( xlab ) + theme_minimal()
p1 <- p + xlab( xlab ) + ylab( ylab ) + lines 
p2 <- p + xlab( xlab ) + ylab( ylab ) + lines + scale_y_continuous( trans = 'log10')
 
# raw data in seconds
data$time <- ( 1:nrow( data ) ) * tr
p3 <- ggplot( data = data, aes( x = time, y = V1 ) ) + geom_line( color = 'darkblue' ) + xlab( xlabraw ) + ylab( ylabraw ) + theme_minimal()

# combine images
png( file = output, width = 1024, height = 1024, res = 150 )

# write csv
write.csv( d, file = paste( output, '.csv', sep = '' ) )

grid.arrange( p3, p1, p2, ncol = 1 )
dev.off()


