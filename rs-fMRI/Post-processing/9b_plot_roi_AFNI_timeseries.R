########################################################################################################
## Study: CONNECT ## Author: M.R.T. Sinke ## Department: Biomedical MR Imaging and Spectroscopy Group ####
############################################################################################################
## Institution: University Medical Center Utrecht ## Script: Determine ROI volumes of all rats ###########
########################################################################################################

## Load some packages
require("plyr")
require("ggplot2")
require("reshape")

## Define working directory
setwd("/home1/michel/projects/TBI/processed/rs-fMRI/")
wd <- getwd()

## Define outdir
outdir <- "/home1/michel/projects/TBI/processing/rs-fMRI/AFNI-timeseries/"
dir.create(outdir)

## Read in ROIs
rois <- as.character( c("le_M1", "le_M1_sd", "ri_M1", "ri_M1_sd", "le_S1FL", "le_S1FL_sd", "ri_S1FL", "ri_S1FL_sd", "le_GP", "le_GP_sd", "ri_GP", "ri_GP_sd", "le_Cpu", "le_Cpu_sd", "ri_Cpu", "ri_Cpu_sd", "le_Acc", "le_Acc_sd", "ri_Acc", "ri_Acc_sd", "le_hipp", "le_hipp_sd", "ri_hipp", "ri_hipp_sd") )

## Make variables
studies = c( "qs", "tbi" )
numbers = c( "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128")
times = c( "pre", "00h", "24h", "01w", "01m", "03m", "04m" )

all <- NULL
l <- NULL

for (study in studies)
{

	for (number in numbers)

	{
	    
	    for (time in times)
	    
	        {

	infile <- paste (wd, "/", study, number, "_", time, "/fc/", study, number, "_", time, "-AFNI-filtered-timeseries.csv", sep = "" )
		print(infile)

	if (file.exists(infile) )

		{
#1
l$rat <- paste(study,number, sep="")

#2
l$time <- time

#3
table <- as.data.frame(read.table(infile, sep = ",", dec =".", header = 1) )

colnames(table) <- c("time", rois)

table$time <- rownames(table)

# Remove SDs from table for now
table <- table[,c(1,2,4,6,8,10,12,14,16,18,20,22,24)]

l$table <- melt(table, id = "time")

all <- rbind (all, l)

			}

		}

	}

}

## Plot with GGplot2 (used 'expression' to allow superscript; used 'atop' to allow a line break)
for (i in 1:length(all[,1]))

{

name <- paste(all[[i,1]], "_", all[[i,2]], sep="")
  
p <-  ggplot(all[[i,3]], aes(as.numeric(time), value, group=variable, color=variable)) + geom_line() +
  labs(x = "\n MRI Volume", y = "Signal intensity \n" ) +
       ggtitle( bquote (atop ( "ROI timeseries: ", atop( .(name) )  ) ) ) + theme(plot.title = element_text(size=25, face="bold") ) +
  theme(axis.text=element_text(size=20), axis.text.y=element_text(size=20), axis.title=element_text(size=20) ) + scale_x_continuous(breaks = seq(0, 800, 50)) + theme(legend.text=element_text(size=15), legend.title=element_text(size=20) )
 
ggsave( file = paste( outdir, "AFNI-timeseries_plot_", all[[i,1]], "_", all[[i,2]], ".png", sep ="" ), plot = p, dpi = 300, width = 20, height = 8  )


}



