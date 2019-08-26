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
outdir <- "/home1/michel/projects/TBI/processing/rs-fMRI/artefact-plots/"
dir.create(outdir)

## Read in ROIs
rois <- as.character( c("le_M1", "ri_M1", "le_S1FL", "ri_S1FL", "le_GP", "ri_GP", "le_Cpu", "ri_Cpu", "le_Acc", "ri_Acc", "le_hipp", "ri_hipp") )

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

	infile <- paste (wd, "/", study, number, "_", time, "/fc/fc-matrix-z-scores.csv", sep = "" )
		print(infile)

	if (file.exists(infile) )

		{
#1
# If number is 1-9 the 0 should be removed
defnumber <- number

if( (study=="tbi" | study=="qs") & (number=="01" | number=="02" | number=="03" | number=="04" | number=="05" | number=="06" | number=="07" | number=="08" | number=="09") )
		{ defnumber <- substr(number,2,2)  }

rat <- paste (study, defnumber, sep="")

#2
time <- time

#3
table <- as.matrix(read.table(infile, sep = ",", dec =".", header = FALSE) )
colnames(table) <- rois
rownames(table) <- rois

l <- melt(table)
colnames(l) <- c("ROI1", "ROI2", "FC")
l$Rat <- rat
l$Time <- time

## Merge all
all <- rbind (all, l)

			}

		}

	}

}

## Remove self-connections
all <- all[ all$ROI1 != all$ROI2, ]
colnames(all)[5] <- paste("time")

# Rename Time labels
all$Time[all$time=="pre"] <- paste("pre")
all$Time[all$time=="00h"] <- paste("1h")
all$Time[all$time=="24h"] <- paste("24h")
all$Time[all$time=="01w"] <- paste("1w")
all$Time[all$time=="01m"] <- paste("1m")
all$Time[all$time=="03m"] <- paste("3m")
all$Time[all$time=="04m"] <- paste("4m")
all$time <- NULL

## Read in information about artefacts
artefacts <- read.table("/home1/michel/projects/TBI/processing/rs-fMRI/rs-fMRI-scans.csv", sep=";", header=TRUE)
groups <- read.table("/home1/michel/projects/TBI/analyses/TBI_groups.csv", sep=",", header=TRUE)

## Merge artefact information
df.merged <- merge(all, artefacts, by=c("Rat", "Time"), all=TRUE )
df.merged$Distortion[df.merged$S1FL=="mild" | df.merged$CPU =="mild"] <- "mild"
df.merged$Distortion[df.merged$S1FL=="moderate" | df.merged$CPU =="moderate"] <- "moderate"
df.merged$Distortion[df.merged$S1FL=="severe" | df.merged$CPU =="severe"] <- "severe"
df.merged$CPU <- NULL
df.merged$S1FL <- NULL

## Merge group information
df.all <- merge(df.merged, groups, by="Rat", all=TRUE)
df.all$Groep[df.all$Group=="Control"] <- "Control"
df.all$Groep[df.all$Group=="TBI" & df.all$Condition=="Mild"] <- "Mild"
df.all$Groep[df.all$Group=="TBI" & df.all$Condition=="Moderate"] <- "Moderate"
df.all$Group <- NULL

colnames(df.all)[8] <- paste("Group")

## Merge 3 and 4 months
colnames(df.all)[2] <- paste ("time")
df.all$Time <- df.all$time
df.all$Time[df.all$time=="3m" | df.all$time=="4m"] <- paste("3m-4m")


## Select 3 ROIs (6 bilateral), 30 plots
selectrois <- c("le_Cpu", "ri_Cpu", "le_M1", "ri_M1", "le_S1FL", "ri_S1FL")
df.sel <- df.all[df.all$ROI1=="le_Cpu" | df.all$ROI1=="ri_Cpu" | df.all$ROI1=="le_M1" | df.all$ROI1=="ri_M1" | df.all$ROI1=="le_S1FL" | df.all$ROI1=="ri_S1FL",]
df.selection <- df.sel[df.sel$ROI2=="le_Cpu" | df.sel$ROI2=="ri_Cpu" | df.sel$ROI2=="le_M1" | df.sel$ROI2=="ri_M1" | df.sel$ROI2=="le_S1FL" | df.sel$ROI2=="ri_S1FL",]

## Set factors
levels(df.selection$Time) <- c("pre", "1h", "24h", "1w", "1m", "3m-4m")
levels(df.selection$Group) <- c("Control", "Mild", "Moderate")
df.selection$Distortion[is.na(df.selection$Distortion)] <- paste("good")

## Reorder factor levels
df.selection$Time <- factor(df.selection$Time, levels=c("pre", "1h", "24h", "1w", "1m", "3m-4m") )
df.selection$Group <- factor(df.selection$Group, levels=c("Control", "Mild", "Moderate") )
df.selection$Distortion <- factor(df.selection$Distortion, levels=c("good", "mild", "moderate", "severe") )

# Make two groups
df.selection$Twogroups[df.selection$Distortion=="good"] <- paste("good")
df.selection$Twogroups[df.selection$Distortion!="good"] <- paste("bad")
df.selection$Twogroups <- factor(df.selection$Twogroups, levels=c("good", "bad") )



# Make plots for different ROIs
for (roi in selectrois)
	{

subset <- df.selection[df.selection$ROI1==roi,]
subset$Condition <- NULL
subset$time <- NULL

# Function to round tick labels to 2 decimals, output is used in 'labels'
scaleFUN <- function(x) sprintf("%.2f", x)

plot <- ggplot( data = na.omit(subset), aes( x = Time, y = FC, group = Twogroups, fill = Twogroups, color = Twogroups ) ) +
  	geom_smooth() + scale_y_continuous(labels=scaleFUN, breaks=scales::pretty_breaks(n=3)) +
	facet_wrap(~ROI2, scales="free_y", ncol=6) + 
  	xlab( "\n  Time point" ) +
  	ylab( paste("Mean +/- SD", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_manual( values = c("darkolivegreen3", "firebrick3") ) + 
  	scale_colour_manual( values = c("darkolivegreen3", "firebrick3") ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text.x=element_text(size=18, angle=45, hjust=1), 
        	axis.title=element_text(size=20, face="bold")) + 
  	theme(axis.text.y=element_text(size=18)) +
    	theme(legend.position="right") +
	ggtitle( paste(as.character(subset$roi[[1]]), "\n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 20, unit = "pt"))) 


outfile <- paste( outdir, subset$ROI1[[1]], "-combi-smooth.png", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 20, height = 6 ) 

outfile <- paste( outdir, subset$ROI1[[1]], "-combi-smooth.pdf", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 20, height = 6 ) 

}






## Plot with GGplot2 (used 'expression' to allow superscript; used 'atop' to allow a line break)
for (i in 1:length(all[,1]))

{

name <- paste(all[[i,1]], "_", all[[i,2]], sep="")
  
p <-  ggplot(all[[i,3]], aes(as.numeric(time), value, group=variable, color=variable)) + geom_line() +
  labs(x = "\n MRI Volume", y = "Signal intensity \n" ) +
       ggtitle( bquote (atop ( "ROI timeseries: ", atop( .(name) )  ) ) ) + theme(plot.title = element_text(size=25, face="bold") ) +
  theme(axis.text=element_text(size=20), axis.text.y=element_text(size=20), axis.title=element_text(size=20) ) + scale_x_continuous(breaks = seq(0, 800, 50)) + theme(legend.text=element_text(size=15), legend.title=element_text(size=20) )
 
ggsave( file = paste( outdir, "timeseries_plot_", all[[i,1]], "_", all[[i,2]], ".png", sep ="" ), plot = p, dpi = 300, width = 20, height = 8  )


}



#### Extract timeseries and check plots for 'filtered data'!!!!!!
