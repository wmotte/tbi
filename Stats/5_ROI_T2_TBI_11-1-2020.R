########################################################################################################
## Study: QNRF TBI ## Author: M.R.T. Sinke ## Department: Biomedical MR Imaging and Spectroscopy Group ####
############################################################################################################
## Institution: University Medical Center Utrecht ## Script: Determine T2 values of all rats #############
########################################################################################################

## Load some packages
require("plyr")
require("ggplot2")
require("reshape")
if(!require("gridExtra")){install.packages("gridExtra")};require("gridExtra")

## Define working directory
setwd("/home1/michel/projects/TBI/processed/T2/")
wd <- getwd()

## Define outdir
outdir <- "/home1/michel/projects/TBI/analyses/output_T2_11-1-2020/"
dir.create(outdir)

## Read in ROIs
rois <- as.character( read.csv("/home1/michel/projects/TBI/atlas/Roi_IDs_TBI_DTI.csv")$abbr[c(1,5,7,9,11,13)] )
rois <- substr(rois, 4,8)

# S1FL/M1 are merged to 'cortex'
rois[1] <- paste ("Cortex")

## Make variables
studies = c( "qs", "tbi" )
numbers = c( "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128")
times = c( "pre", "00h", "24h", "01w", "01m", "03m", "04m" )
metrics <- c("t2",  "pd")

all <- NULL
l <- NULL

for (study in studies)
{

	for (number in numbers)

	{
	    
	    for (time in times)
	    
	        {
	        
	            for (metric in metrics)
	            
	                {

	infile <- paste (wd, "/", study, number, "_", time, "/ROI_values/", metric, "values.txt", sep = "" )
		print(infile)

	if (file.exists(infile) )

		{
#1 Read in table and ROI labels
table <- as.data.frame(read.table(infile, dec =".", header = FALSE) )[1:6]
colnames(table) <- rois


### Read in new CC data in between, and paste data in existing 'cc collumn'
infile2 <- paste (wd, "/", study, number, "_", time, "/ROI_values/CC-", metric, "values.txt", sep = "" )
		print(infile)

	if (file.exists(infile2) )

		{
		table$cc <- read.table(infile2, dec =".", header = FALSE)[[1]]
		}

### Read in new Hippocampus data in between, and paste data in existing 'hippocampus collumn'
infile3 <- paste (wd, "/", study, number, "_", time, "/ROI_values/Hipp-", metric, "values.txt", sep = "" )
		print(infile)

	if (file.exists(infile3) )

		{
		table$hipp <- read.table(infile3, dec =".", header = FALSE)[[1]]
		}

# If number is 1-9 the 0 should be removed
defnumber <- number

if( (study=="tbi" | study=="qs") & (number=="01" | number=="02" | number=="03" | number=="04" | number=="05" | number=="06" | number=="07" | number=="08" | number=="09") )
		{ defnumber <- substr(number,2,2)  }

rat <- paste (study, defnumber, sep="")

df <- data.frame(Rat=rat, Time=time, Metric=metric )

df.complete <- cbind(df, table)

l <- melt(df.complete, id=c("Rat", "Time", "Metric"))

#2
all <- rbind (all, l)

		        }

	        }

         }

    }

}

## Read in condition info

conditions <- read.csv("/home1/michel/projects/TBI/analyses/TBI_groups.csv", sep=",")

## Merge conditions with datafile
df.merged <- merge(all, conditions, by="Rat")
df.merged$Class[df.merged$Group=="Control"] <- "Sham"
df.merged$Class[df.merged$Group=="TBI"&df.merged$Condition=="Mild"] <- "Mild TBI"
df.merged$Class[df.merged$Group=="TBI"&df.merged$Condition=="Moderate"] <- "Moderate TBI"

## Make one 'chronic timepoint' (combine 3m and 4m)
df.merged$Timepoint <- NULL
df.merged$Timepoint[df.merged$Time=="03m" | df.merged$Time=="04m"] <- paste("3m-4m")
df.merged$Timepoint[df.merged$Time=="pre"] <- paste("pre")
df.merged$Timepoint[df.merged$Time=="00h"] <- paste("00h")
df.merged$Timepoint[df.merged$Time=="24h"] <- paste("24h")
df.merged$Timepoint[df.merged$Time=="01w"] <- paste("01w")
df.merged$Timepoint[df.merged$Time=="01m"] <- paste("01m")
df.merged$Timepoint <- factor(df.merged$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m") )

## Construct roi-labels
df.merged$roi <- NULL
df.merged$roi[df.merged$variable=="Cortex"] <- paste("Cortex")
df.merged$roi[df.merged$variable=="Cpu"] <- paste("Caudate Putamen")
df.merged$roi[df.merged$variable=="hipp"] <- paste("Hippocampus")
df.merged$roi[df.merged$variable=="cc"] <- paste("Corpus Callosum")
df.merged$roi[df.merged$variable=="ic"] <- paste("Internal Capsule")
df.merged$roi[df.merged$variable=="cp"] <- paste("Cerebral Peduncles")
df.merged$roi[df.merged$variable=="cg"] <- paste("Cingulum")

# Construct factors
df.merged$Class <- factor(df.merged$Class, levels=c("Sham", "Mild TBI", "Moderate TBI") )

### Make subgroup of moderate TBI
df.mild <- df.merged[df.merged$Condition=="Mild",]
df.moderate <- df.merged[!(df.merged$Condition=="Mild" & df.merged$Group=="TBI"),]

## Change factor levels
df.mild$Timepoint <- factor(df.mild$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m") )
df.moderate$Timepoint <- factor(df.moderate$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m") )
df.mild$Group <- factor(df.mild$Group, levels=c("TBI", "Control") )
df.moderate$Group <- factor(df.moderate$Group, levels=c("TBI", "Control") )

## Calculate mean +/- SD T2 all ROIs for all timepoints for controls and TBI animals
mild.parameters <- ddply ( df.mild, .(Timepoint, variable, Group, Metric), summarise,
				Mean = mean( value ),
				SD = sd( value ) )

moderate.parameters <- ddply ( df.moderate, .(Timepoint, variable, Group, Metric), summarise,
				Mean = mean( value ),
				SD = sd( value ) )


## Change factor levels
mild.parameters$Timepoint <- factor(mild.parameters$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m") )
moderate.parameters$Timepoint <- factor(moderate.parameters$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m") )
mild.parameters$Group <- factor(mild.parameters$Group, levels=c("TBI", "Control") )
moderate.parameters$Group <- factor(moderate.parameters$Group, levels=c("TBI", "Control") )



#### Make Combi-plots ####
# Make two combination of three plots (to combine them with other plots)
df.merged1 <- df.merged[df.merged$variable=="Cortex"|df.merged$variable=="Cpu"|df.merged$variable=="hipp",]

df.merged2 <- df.merged[df.merged$variable=="ic"|df.merged$variable=="cg"|df.merged$variable=="cc",]

# Function to round tick labels to 2 decimals, output is used in 'labels'
scaleFUN <- function(x) sprintf("%.2f", x)

plot <- ggplot( data = df.merged1[df.merged1$Metric=="t2",], aes( x = Timepoint, y = value, group = Class, fill = Class, color = Class ) ) +
  	geom_smooth() + scale_y_continuous(labels=scaleFUN, breaks=scales::pretty_breaks(n=3), limits=c(0.03,0.08)) +
	facet_wrap(~roi, scales="free_y", ncol=3) + 
  	xlab( "" ) +
  	ylab( paste("", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	scale_colour_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text.x=element_text(size=18, angle=45, hjust=1), 
        	axis.title=element_text(size=20, face="bold")) + 
  	theme(axis.text.y=element_text(size=18)) +
    	theme(legend.position="none") +
	#ggtitle( paste(as.character("T2-relaxation over time"), "\n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 20, unit = "pt"))) 


outfile <- paste( outdir, "/T2-combi-smooth.png", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 10, height = 4 ) 

outfile <- paste( outdir, "/T2-combi-smooth.pdf", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 10, height = 4 ) 


#Plot second
scaleFUN <- function(x) sprintf("%.2f", x)

plot <- ggplot( data = df.merged2[df.merged2$Metric=="t2",], aes( x = Timepoint, y = value, group = Class, fill = Class, color = Class ) ) +
  	geom_smooth() + scale_y_continuous(labels=scaleFUN, breaks=scales::pretty_breaks(n=3), limits=c(0.03,0.08)) +
	facet_wrap(~roi, scales="free_y", ncol=3) + 
  	xlab( "" ) +
  	ylab( paste("", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	scale_colour_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text.x=element_text(size=18, angle=45, hjust=1), 
        	axis.title=element_text(size=20, face="bold")) + 
  	theme(axis.text.y=element_text(size=18)) +
    	theme(legend.position="none") +
	#ggtitle( paste(as.character("T2-relaxation over time"), "\n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 20, unit = "pt"))) 


outfile <- paste( outdir, "/T2-combi-smooth2.png", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 10, height = 4 ) 

outfile <- paste( outdir, "/T2-combi-smooth2.pdf", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 10, height = 4 ) 



## To perform some linear mixed model analyses with glmmTMB (laptop), write CSV file
df.select <- df.merged[df.merged$Metric=="t2" & df.merged$variable!="cp",]

write.table(df.select, "/home1/michel/projects/TBI/analyses/data_final/t2_data.csv", sep=";", dec=",", row.names=FALSE)

