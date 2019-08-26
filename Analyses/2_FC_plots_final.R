########################################################################################################
## Study: QNRF TBI ## Author: M.R.T. Sinke ## Department: Biomedical MR Imaging and Spectroscopy Group ####
############################################################################################################
## Institution: University Medical Center Utrecht ## Script: Determine FC of all rats ####################
########################################################################################################

## Load some packages
require("plyr")
require("ggplot2")
require("reshape")
if(!require("gridExtra")){install.packages("gridExtra")};require("gridExtra")

## Define working directory
setwd("/home1/michel/projects/TBI/processed/rs-fMRI/")
wd <- getwd()

## Define outdir
outdir <- "/home1/michel/projects/TBI/analyses/output_FC_final/"
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

#4 make connectivity variables
cpu <- table["le_Cpu","ri_Cpu"]
hipp <- table["le_hipp","ri_hipp"]
m1 <- table["le_M1","ri_M1"]
s1fl <- table["le_S1FL","ri_S1FL"]

cpu.m1 <- (table["le_Cpu","le_M1"]+table["ri_Cpu","ri_M1"])/2
cpu.s1fl <- (table["le_Cpu","le_S1FL"]+table["ri_Cpu","ri_S1FL"])/2
m1.s1fl <-(table["le_M1","le_S1FL"]+table["ri_M1","ri_S1FL"])/2

df <- data.frame("CPu" = cpu, "Hippocampus" = hipp, "M1" = m1, "S1FL" = s1fl, 
		"CPu-M1" = cpu.m1, "CPu-S1FL" = cpu.s1fl, "M1-S1FL" = m1.s1fl)

#5 melt df
l <- melt(df)
colnames(l) <- c("ROI", "FC")

l$Type[l$ROI=="CPu" | l$ROI=="M1" | l$ROI=="S1FL" | l$ROI=="Hippocampus"] <- "Interhemispheric"
l$Type[l$ROI=="CPu.M1" | l$ROI=="CPu.S1FL" | l$ROI=="M1.S1FL"] <- "Intrahemispheric"

l$Rat <- rat
l$Time <- time

## Merge all
all <- rbind (all, l)

			}

		}

	}

}


# Rename Time labels
all$time <- all$Time
all$Time <- NULL
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
df.all$time <- NULL
df.all <- df.all[!is.na(df.all$ROI),]

colnames(df.all)[8] <- paste("Group")

## Merge 3 and 4 months
colnames(df.all)[2] <- paste ("time")
df.all$Timepoint <- df.all$time
df.all$Timepoint[df.all$time=="3m" | df.all$time=="4m"] <- paste("3m-4m")

## Set factors
levels(df.all$Timepoint) <- c("pre", "1h", "24h", "1w", "1m", "3m-4m")
levels(df.all$Group) <- c("Control", "Mild", "Moderate")
df.all$Distortion[is.na(df.all$Distortion)] <- paste("good")

## Reorder factor levels
df.all$Time <- factor(df.all$Time, levels=c("pre", "1h", "24h", "1w", "1m", "3m-4m") )
df.all$Group <- factor(df.all$Group, levels=c("Control", "Mild", "Moderate") )
df.all$Distortion <- factor(df.all$Distortion, levels=c("good", "mild", "moderate", "severe") )

# Make two groups
df.all$Twogroups[df.all$Distortion=="good"] <- paste("good")
df.all$Twogroups[df.all$Distortion!="good"] <- paste("bad")
df.all$Twogroups <- factor(df.all$Twogroups, levels=c("good", "bad") )
df.all$Type <- factor(df.all$Type, levels=c("Intrahemispheric", "Interhemispheric") )

## Make final selectoin
df.selection <- df.all[df.all$Twogroups=="good",]
df.selection$Distortion <- NULL
df.selection$Condition <- NULL
df.selection$Twogroups <- NULL

## Make grid labels for plots
df.selection$lable[df.selection$ROI=="Hippocampus"] <- paste("Hippocampus")
df.selection$lable[df.selection$ROI=="M1"] <- paste("M1")
df.selection$lable[df.selection$ROI=="S1FL"] <- paste("S1FL")
df.selection$lable[df.selection$ROI=="CPu"] <- paste("CPu")
df.selection$lable[df.selection$ROI=="CPu.S1FL"] <- paste("CPu-S1FL")
df.selection$lable[df.selection$ROI=="CPu.M1"] <- paste("CPu-M1")
df.selection$lable[df.selection$ROI=="M1.S1FL"] <- paste("M1-S1FL")


# Make plots for different ROIs
for ( t in levels(df.selection$Type) )
	{

subset <- df.selection[df.selection$Type==t,]

# Legend
leg <- ifelse(t=="Intrahemispheric", paste("right"), paste("none") )

# Function to round tick labels to 2 decimals, output is used in 'labels'
scaleFUN <- function(x) sprintf("%.2f", x)

plot <- ggplot( data = na.omit(subset), aes( x = Time, y = FC, group = Group, fill = Group, color = Group ) ) +
  	geom_smooth() + scale_y_continuous(labels=scaleFUN, breaks=scales::pretty_breaks(n=3)) +
	facet_wrap(~lable, scales="free_y", ncol=4) + 
  	xlab( "\n  Time point" ) +
  	ylab( paste("Mean +/- SD", " \n", sep="") ) + 
	scale_x_discrete(labels = c("Pre", "<1h", "24h", "1 week", "1 month", "3-4 months") ) +
                     theme_bw() +
  	scale_fill_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	scale_colour_manual( values = c("darkolivegreen3", "darkorange2", "firebrick3") ) + 
  	theme_minimal() +
  	theme_bw( base_size = 10 ) + 
  	theme(axis.text.x=element_text(size=18, angle=45, hjust=1), 
        	axis.title=element_text(size=20, face="bold")) + 
  	theme(axis.text.y=element_text(size=18)) +
    	theme(legend.position=leg) + 
	ggtitle( paste(as.character(subset$Type[[1]])," Functional Connectivity \n", sep="") ) + 
  	theme(plot.title = element_text(size=25,face="bold", hjust=0.5 ), legend.title=element_blank(), legend.text=element_text(size=20) ) +
  	theme(strip.text.x = element_text(size = 20, face="bold")) +
  	theme(plot.title = element_text(margin=margin(b = 20, unit = "pt"))) 


outfile <- paste( outdir, subset$Type[[1]], "-combi-smooth.png", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 14, height = 6 ) 

outfile <- paste( outdir, subset$Type[[1]], "-combi-smooth.pdf", sep = "" )
ggsave( file = outfile, plot = plot, dpi = 500, width = 14, height = 6 ) 

}



## To perform some linear mixed model analyses with glmmTMB (laptop), write CSV file
write.table(df.selection, "/home1/michel/projects/TBI/analyses/data/FC_data.csv", sep=";", dec=",", row.names=FALSE)

