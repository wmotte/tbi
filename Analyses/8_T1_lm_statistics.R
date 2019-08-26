########################################################################
#
# Statistical models TBI T1 data
# m.r.t.sinke@umcutrecht.nl adapted from w.m.otte@umcutrecht.nl (23-Aug-2018 - hawk)
#
########################################################################
# Set working dir
setwd("D:/Werk/Projecten/TBI/Statistics/")

#library( 'lme4' )
#library( 'emmeans' )
library( 'glmmTMB' )
library( 'multcomp' )
library( 'lsmeans' )

#################################
# FUNCTIONS
#################################

###
# Required for multcomp
##
glht_glmmTMB <- function (model, ..., component="cond") {
    glht(model, ...,
         coef. = function(x) fixef(x)[[component]],
         vcov. = function(x) vcov(x)[[component]],
         df = NULL)
}

###
# Required for multcomp
##
modelparm.glmmTMB <- function (model, 
                               coef. = function(x) fixef(x)[[component]],
                               vcov. = function(x) vcov(x)[[component]],
                               df = NULL, component="cond", ...) {
    multcomp:::modelparm.default(model, coef. = coef., vcov. = vcov.,
                        df = df, ...)
}

###
# Fit model and write output to file
##
fit_model <- function( df, set, outdir, percentage = FALSE )
{
	# convert Value to proportion
	if( percentage )
		df$Value <- df$Value / 100
		
	# fit gaussian random effects model
	m <- glmmTMB::glmmTMB( value ~ Class + Timepoint + ( 1 | Rat ), data = df, family = gaussian() )
	lm  <- lme4::lmer( value ~ Class + Timepoint + Timepoint*Class + ( 1 | Rat ), data = df)

	# post-hoc comparisons Group and Day
	g_grp <- multcomp::glht( m, linfct = mcp( Class = "Tukey" ) )
	g_day <- multcomp::glht( m, linfct = mcp( Timepoint = "Tukey" ) )
	g_int <- lsmeans( lm, pairwise~Timepoint*Class, adjust = "tukey" )
	
	# summary reports from post-hoc comparisons in txt-format
	sum_grp <- capture.output( summary( g_grp ) )
	sum_day <- capture.output( summary( g_day ) )
	
	# make dataframe of significant interactions only
	df_int <- as.data.frame(g_int$contrasts)
	df_sig.int <- df_int[df_int$p.value<0.05,]
	sum_int <- capture.output(df_sig.int)
	
	# make dataframe with trends and n.s. contrasts
	df_trends <- df_int[df_int$p.value>0.05 & df_int$p.value<0.1,]
	df_ns <- df_int[df_int$p.value>0.1,]

	# output file
	outfile <- paste0( outdir, '/summary_report__', set, '.txt' )

	# output to file
	cat( sum_grp, file = outfile, sep = '\n' )
	cat( sum_day, file = outfile, sep = '\n', append = TRUE )
	cat( sum_int, file = outfile, sep = '\n', append = TRUE )
	
	
	# output files for trends and n.s. results
	write.table(df_trends, file=paste(outdir, '/trends_report__', set, '.csv', sep=""), sep=";", dec=",", row.names=F )
	write.table(df_ns, file=paste(outdir, '/ns_report__', set, '.csv', sep=""), sep=";", dec=",", row.names=F )

}

#################################
# END FUNCTIONS
#################################


# create outdir
outdir <- 't1.stats'
dir.create( outdir, showWarnings = FALSE )

indir <- 'data'

metrics <- c( "t1" )

rois <- c( "cc", "hipp", "Cortex" )


# loop over options
for( roi in rois )
{
    for( metric in metrics )
      {
	
	# read data
	head( df <- read.csv( paste0( indir, '/t1_data.csv' ), sep=";", dec="," ) )
      
      # reorder levels timepoints
      df$Timepoint <- factor(df$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m"))
      
      # make selection based on roi and metric
      df.select <- df[df$Metric==metric & df$variable==roi,]
      
      # define 'set'
      set <- paste(roi, "_", metric, sep="")
      print(set)
      
      # option print.max
      options(max.print = 10000)

	# fit model
		fit_model( df.select, set, outdir )
      }
}