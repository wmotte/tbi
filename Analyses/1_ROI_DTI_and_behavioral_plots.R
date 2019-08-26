########################################################################################################
## Study: QNRF TBI ## Author: M.R.T. Sinke ## Department: Biomedical MR Imaging and Spectroscopy Group ####
############################################################################################################
## Institution: University Medical Center Utrecht ## Script: Determine ROI dtifit values of all rats #####
########################################################################################################

## Load some packages
require("plyr")
require("ggplot2")
require("reshape")
if(!require("gridExtra")){install.packages("gridExtra")};require("gridExtra")

## Define working directory
setwd("/home1/michel/projects/TBI/processed/DTI/")
wd <- getwd()

## Define outdir
outdir <- "/home1/michel/projects/TBI/analyses/output_final/"

## Read in ROIs
rois <- as.character( read.csv("/home1/michel/projects/TBI/atlas/Roi_IDs_TBI_DTI.csv")$abbr[c(1,5,7,9,11,13)] )
rois <- substr(rois, 4,8)

# S1FL/M1 are merged to 'cortex'
rois[1] <- paste ("Cortex")

## Make variables
studies = c( "qs", "tbi" )
numbers = c( "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128")
times = c( "pre", "00h", "24h", "01w", "01m", "03m", "04m" )
metrics <- c("FA", "MD", "RD", "AD")

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

	infile <- paste (wd, "/", study, number, "_", time, "/ROI_values/", metric, "_new.txt", sep = "" )
		print(infile)

	if (file.exists(infile) )

		{
#1 [1:18] because 19 and 20 are (small) CST, some rats don't have one of them...
table <- as.data.frame(read.table(infile, dec =".", header = FALSE) )[1:6]
colnames(table) <- rois


### Read in new CC data in between, and paste data in existing 'cc collumn'
infile2 <- paste (wd, "/", study, number, "_", time, "/ROI_values/CC-", metric, ".txt", sep = "" )
		print(infile)

	if (file.exists(infile2) )

		{
		table$cc <- read.table(infile2, dec =".", header = FALSE)[[1]]
		}


# If number is 1-9 the 0 should be removed
defnumber <- number

if( (study=="tbi" | study=="qs") & (number=="01" | number=="02" | number=="03" | number=="04" | number=="05" | number=="06" | number=="07" | number=="08" | number=="09") )
		{ defnumber <- substr(number,2,2)  }

rat <- paste (study, defnumber, sep="")

df <- data.frame(Rat=rat, Time=time, Metric=metric )

# If metric is MD, AD or RD, multiply with 1000
if(df$Metric=="AD" | df$Metric=="MD" | df$Metric=="RD")
	{
	table <- table*1000
	}

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
df.merged$Class[df.merged$Group=="Control"] <- "Control"
df.merged$Class[df.merged$Group=="TBI"&df.merged$Condition=="Mild"] <- "Mild"
df.merged$Class[df.merged$Group=="TBI"&df.merged$Condition=="Moderate"] <- "Moderate"

## Concatenate 'margin data'
margins <- read.csv("/home1/michel/projects/TBI/analyses/Plot_margins_data_new.csv", sep=";")[1:8]
df.merged <- rbind(df.merged, margins)

## Make one 'chronic timepoint' (combine 3m and 4m)
df.merged$Timepoint <- NULL
df.merged$Timepoint[df.merged$Time=="03m" | df.merged$Time=="04m" | df.merged$Time=="3m-4m"] <- paste("3m-4m")
df.merged$Timepoint[df.merged$Time=="pre"] <- paste("pre")
df.merged$Timepoint[df.merged$Time=="00h"] <- paste("00h")
df.merged$Timepoint[df.merged$Time=="24h"] <- paste("24h")
df.merged$Timepoint[df.merged$Time=="01w"] <- paste("01w")
df.merged$Timepoint[df.merged$Time=="01m"] <- paste("01m")
df.merged$Timepoint <- factor(df.merged$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m") )

## Construct roi-labels
df.merged$roi <- NULL
df.merged$roi[df.merged$variable=="Cortex"] <- paste("Sensorimotor Cortex")
df.merged$roi[df.merged$variable=="Cpu"] <- paste("Caudate Putamen")
df.merged$roi[df.merged$variable=="hipp"] <- paste("Hippocampus")
df.merged$roi[df.merged$variable=="cc"] <- paste("Corpus Callosum")
df.merged$roi[df.merged$variable=="ic"] <- paste("Internal Capsule")
df.merged$roi[df.merged$variable=="cp"] <- paste("Cerebral Peduncles")
df.merged$roi[df.merged$variable=="cg"] <- paste("Cingulum")

# Construct factors
df.merged$Class <- factor(df.merged$Class, levels=c("Control", "Mild", "Moderate", "Lower", "Higher") )


########### Make QQplots to check data normality ############
dir.create(paste(outdir, "qqplots/", sep=""))

for(metric in levels(df.merged$Metric))
{
	for(roi in levels(df.merged$variable))
		{
			for(group in levels(df.merged$Class))
				{

	png(paste(outdir, "qqplots/qqplot-", metric, "-", roi, "-", group, ".png", sep=""))
	car::qqPlot(df.merged$value[df.merged$Metric==metric & df.merged$variable==roi & df.merged$Class==group])
	dev.off()

		}

	}
}



## Create some density plots
for(metric in levels(df.merged$Metric))
{
	for(roi in levels(df.merged$variable))
		{
			for(group in levels(df.merged$Class))
				{

	png(paste(outdir, "qqplots/density-", metric, "-", roi, "-", group, ".png", sep=""))
	plot( density(df.merged$value[df.merged$Metric==metric & df.merged$variable==roi & df.merged$Class==group]) )
	dev.off()

		}

	}
}


### Make subgroup of moderate TBI
df.mild <- df.merged[df.merged$Condition=="Mild",]
df.moderate <- df.merged[!(df.merged$Condition=="Mild" & df.merged$Group=="TBI"),]

## Change factor levels
df.mild$Timepoint <- factor(df.mild$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m") )
df.moderate$Timepoint <- factor(df.moderate$Timepoint, levels=c("pre", "00h", "24h", "01w", "01m", "3m-4m") )
df.mild$Group <- factor(df.mild$Group, levels=c("TBI", "Control") )
df.moderate$Group <- factor(df.moderate$Group, levels=c("TBI", "Control") )

## Calculate mean +/- SD FA, MD, AD and RD for all ROIs for all timepoints for controls and TBI animals
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

### Make longitudinal plots, separate lines and geom_smooth

for (roi in rois)
	{
	for (metric in metrics)
		{

subset <- df.mild[df.mild$Metric==metric & df.mild$variable==roi,]


plot1 <- ggplot( data = subset, aes( x = Timepoint, y = value, group = Rat, fill = Group, color = Group ) ) +
  	geom_line( position = "dodge", size = 1.2) +
  	xlab( "\n  Timepoint" ) +
  	ylab( paste("Mean ", as.character(subset$Metric[[1]]), " +/- SD", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_brewer( palette = "Set1" ) + 
  	scale_colour_brewer( palette = "Set1" ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text=element_text(size=20, angle=45, hjust=1), 
        	axis.title=element_text(size=25, face="bold")) + 
  	theme(axis.text.y=element_text(size=20)) +
    	theme(legend.position="right") +
  	ggtitle( paste(as.character(subset$roi[[1]]), "\n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 15, unit = "pt"))) 


outfile1 <- paste( outdir, "plots/Mild-",subset$variable[[1]], "-", subset$Metric[[1]], ".png", sep = "" )
ggsave( file = outfile1, plot = plot1, dpi = 500, width = 12, height = 6 ) 




plot2 <- ggplot( data = subset, aes( x = Timepoint, y = value, group = Group, fill = Group, color = Group ) ) +
  	geom_smooth() +
  	xlab( "\n  Timepoint" ) +
  	ylab( paste("Mean ", as.character(subset$Metric[[1]]), " +/- SD", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_brewer( palette = "Set1" ) + 
  	scale_colour_brewer( palette = "Set1" ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text=element_text(size=20, angle=45, hjust=1), 
        	axis.title=element_text(size=25, face="bold")) + 
  	theme(axis.text.y=element_text(size=20)) +
    	theme(legend.position="right") +
  	ggtitle( paste(as.character(subset$roi[[1]]), "\n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 15, unit = "pt"))) 


outfile2 <- paste( outdir, "smooth/Mild-",subset$variable[[1]], "-", subset$Metric[[1]], "-smooth.png", sep = "" )
ggsave( file = outfile2, plot = plot2, dpi = 500, width = 12, height = 6 ) 

	}
}


### For moderate TBI

for (roi in rois)
	{
	for (metric in metrics)
		{

subset <- df.moderate[df.moderate$Metric==metric & df.moderate$variable==roi,]


plot1 <- ggplot( data = subset, aes( x = Timepoint, y = value, group = Rat, fill = Group, color = Group ) ) +
  	geom_line( position = "dodge", size = 1.2) +
  	xlab( "\n  Timepoint" ) +
  	ylab( paste("Mean ", as.character(subset$Metric[[1]]), " +/- SD", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_brewer( palette = "Set1" ) + 
  	scale_colour_brewer( palette = "Set1" ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text=element_text(size=20, angle=45, hjust=1), 
        	axis.title=element_text(size=25, face="bold")) + 
  	theme(axis.text.y=element_text(size=20)) +
    	theme(legend.position="right") +
  	ggtitle( paste(as.character(subset$roi[[1]]), "\n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 15, unit = "pt"))) 


outfile1 <- paste( outdir, "plots/Moderate-",subset$variable[[1]], "-", subset$Metric[[1]], ".png", sep = "" )
ggsave( file = outfile1, plot = plot1, dpi = 500, width = 12, height = 6 ) 




plot2 <- ggplot( data = subset, aes( x = Timepoint, y = value, group = Group, fill = Group, color = Group ) ) +
  	geom_smooth() +
  	xlab( "\n  Timepoint" ) +
  	ylab( paste("Mean ", as.character(subset$Metric[[1]]), " +/- SD", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_brewer( palette = "Set1" ) + 
  	scale_colour_brewer( palette = "Set1" ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text=element_text(size=20, angle=45, hjust=1), 
        	axis.title=element_text(size=25, face="bold")) + 
  	theme(axis.text.y=element_text(size=20)) +
    	theme(legend.position="right") +
  	ggtitle( paste(as.character(subset$roi[[1]]), "\n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 15, unit = "pt"))) 


outfile2 <- paste( outdir, "smooth/Moderate-",subset$variable[[1]], "-", subset$Metric[[1]], "-smooth.png", sep = "" )
ggsave( file = outfile2, plot = plot2, dpi = 500, width = 12, height = 6 ) 

	}
}



#### Make Combi-plots #####

## Mild TBI

# First multiply MD, AD and RD values by 1000 (bring them in similar range to FA)
for (roi in c("cc",rois))
	{

subset <- df.merged[df.merged$variable==roi&df.merged$Metric!="MD",]

# Function to round tick labels to 2 decimals, output is used in 'labels'
scaleFUN <- function(x) sprintf("%.2f", x)

plot <- ggplot( data = subset, aes( x = Timepoint, y = value, group = Class, fill = Class, color = Class ) ) +
  	geom_smooth() + scale_y_continuous(labels=scaleFUN, breaks=scales::pretty_breaks(n=4)) +
	facet_wrap(~Metric, scales="free_y", ncol=3) + 
  	xlab( "\n  Time point" ) +
  	ylab( paste("Mean +/- SD", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3", "transparent", "transparent") ) + 
  	scale_colour_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3", "transparent", "transparent") ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text.x=element_text(size=18, angle=45, hjust=1), 
        	axis.title=element_text(size=20, face="bold")) + 
  	theme(axis.text.y=element_text(size=18)) +
    	theme(legend.position="right") +
	ggtitle( paste(as.character(subset$roi[[1]]), "\n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=c(20) ) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 20, unit = "pt"))) 


outfile <- paste( outdir, "combi/",subset$roi[[1]], "-combi-smooth.png", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 14, height = 6 ) 

outfile <- paste( outdir, "combi/",subset$roi[[1]], "-combi-smooth.pdf", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 14, height = 6 ) 

}





######################################################################################################
## Read in Behavioral Data ##
######################################################################################################

## Remove qs rats and 00h from data.merged (no behavioral data)
df.data <- df.merged[grep("^tbi", df.merged$Rat),]
df.data <- df.data[df.data$Timepoint!="00h",]

## Read in behavioral data
nss <- read.csv("/home1/michel/projects/TBI/behavioral_data/nss.csv")
slips <- read.csv("/home1/michel/projects/TBI/behavioral_data/bw_slips.csv")

## NSS
# Make data compatible with each other
nss$Rat <- paste("tbi",nss$Animal,sep="")
nss$Timepoint[nss$Day=="1_0days"] <- paste("pre")
nss$Timepoint[nss$Day=="2_1day"] <- paste("24h")
nss$Timepoint[nss$Day=="3_1week"] <- paste("01w")
nss$Timepoint[nss$Day=="4_1month"] <- paste("01m")
nss$Timepoint[nss$Day=="5_3months"] <- paste("3m-4m")

# Set levels
nss$Timepoint <- factor(nss$Timepoint, levels=c("pre", "24h", "01w", "01m", "3m-4m") )
nss$Day <- NULL
nss$Animal <- NULL
nss$Group <- NULL
names(nss)[1] <- paste("NSS")

## SLIPS
# Make data compatible with each other
slips$Rat <- paste("tbi",slips$Animal,sep="")
slips$Timepoint[slips$Day=="1_0days"] <- paste("pre")
slips$Timepoint[slips$Day=="2_1day"] <- paste("24h")
slips$Timepoint[slips$Day=="3_1week"] <- paste("01w")
slips$Timepoint[slips$Day=="4_1month"] <- paste("01m")
slips$Timepoint[slips$Day=="5_3months"] <- paste("3m-4m")

# Set levels
slips$Timepoint <- factor(slips$Timepoint, levels=c("pre", "24h", "01w", "01m", "3m-4m") )
slips$Day <- NULL
slips$Animal <- NULL
slips$Group <- NULL
names(slips)[1] <- paste("Slips")

## Merge data
df.merge1 <- merge(df.data, nss, by=c("Rat", "Timepoint") )
df.all.data <- merge(df.merge1, slips, by=c("Rat", "Timepoint") )

### NSS plot
# Inverse NSS score
df.all.data$NSS <- 10-df.all.data$NSS

## 1 decimal
scaleFUN <- function(x) sprintf("%.0f", x)

plot <- ggplot( data = df.all.data[df.all.data$variable=="cp" & df.all.data$Metric=="AD",], aes( x = Timepoint, 		y = NSS, group = Class, fill = Class, color = Class ) ) + geom_smooth() + 					scale_y_continuous(labels=scaleFUN, breaks=scales::pretty_breaks(n=3)) +
	#facet_wrap(~Metric, scales="free_y") +
  	xlab( "\n  Time point" ) +
  	ylab( paste("Sensorimotor deficit score", " \n", "(Mean +/- SD)", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	scale_colour_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text.x=element_text(size=18, angle=45, hjust=1), 
        	axis.title=element_text(size=20, face="bold")) + 
  	theme(axis.text.y=element_text(size=18)) +
    	theme(legend.position="right") +
  	ggtitle( "Sensorimotor deficits  \n" ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), 			legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 20, unit = "pt"))) 


outfile <- paste( outdir, "behavior/NSS-over-time-smooth.png", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 8, height = 6 ) 


### Slips plot
scaleFUN <- function(x) sprintf("%.0f", x)

plot <- ggplot( data = df.all.data[df.all.data$variable=="cp" & df.all.data$Metric=="AD",], aes( x = Timepoint, 		y = Slips, group = Class, fill = Class, color = Class ) ) +
  	geom_smooth() + scale_y_continuous(labels=scaleFUN, breaks=scales::pretty_breaks(n=3)) +
	#facet_wrap(~Metric, scales="free_y") +
  	xlab( "\n  Time point" ) +
  	ylab( paste("Number of slips"," \n","(Mean +/- SD)", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	scale_colour_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text.x=element_text(size=18, angle=45, hjust=1), 
        	axis.title=element_text(size=20, face="bold")) + 
  	theme(axis.text.y=element_text(size=18)) +
    	theme(legend.position="right") +
  	ggtitle( "Number of slips  \n" ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), 			legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 20, unit = "pt"))) 


outfile <- paste( outdir, "behavior/Slips-over-time-smooth.png", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 8, height = 6 ) 


## To perform some linear mixed model analyses with gmTMB (laptop), write CSV file
df.select <- df.merged[df.merged$Class=="Control" | df.merged$Class=="Mild" | df.merged$Class=="Moderate" ,]

write.table(df.select, "/home1/michel/projects/TBI/analyses/data/diffusion_data.csv", sep=";", dec=",", row.names=FALSE)


