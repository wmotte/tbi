#!/home1/wim/R-3.2.3/bin/Rscript --no-save --no-restore

library( 'reshape2' )
library( 'ggplot2' )
library( 'dplyr' )

###### Read in all relevant data: dMRI parameters, T2, T1 and FC for all TBI and control rats


## Define working directory
setwd("/home1/michel/projects/TBI/processed/")
wd <- getwd()

## Define outdir
outdir <- "/home1/michel/projects/TBI/analyses/logistic_regression/"

## Read in ROIs
rois <- as.character( read.csv("/home1/michel/projects/TBI/atlas/Roi_IDs_TBI_DTI.csv")$abbr[c(1,5,7,9,11,13)] )
rois <- substr(rois, 4,8)

# S1FL/M1 are merged to 'cortex'
rois[1] <- paste ("Cortex")

## Make variables
studies = c( "qs", "tbi" )
numbers = c( "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128")
times = c( "pre", "00h", "24h", "01w", "01m", "03m", "04m" )
metrics <- c("FA_new", "MD_new", "RD_new", "AD_new", "t2values", "pdvalues", "t1values")
types <- c("DTI", "T1", "T2")

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
			
			for (type in types)
			
				{

	infile <- paste (wd, "/",type,"/", study, number, "_", time, "/ROI_values/", metric, ".txt", sep = "" )
		print(infile)

	if (file.exists(infile) )

		{
#1 [1:18] because 19 and 20 are (small) CST, some rats don't have one of them...
table <- as.data.frame(read.table(infile, dec =".", header = FALSE) )[1:6]
colnames(table) <- rois


### Read in new CC data in between, and paste data in existing 'cc collumn'
infile2 <- paste (wd, "/",type,"/", study, number, "_", time, "/ROI_values/CC-", metric, ".txt", sep = "" )
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

# If metric is MD, AD or RD, multiply with 100
if(df$Metric=="AD_new" | df$Metric=="MD_new" | df$Metric=="RD_new")
	{
	table <- table*100
	}

df.complete <- cbind(df, table)

#l <- melt(df.complete, id=c("Rat", "Time", "Metric"))

#2
all <- rbind (all, df.complete)

					}

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

## Reshape data
df.FA <- df.merged[df.merged$Metric=="FA_new",]
colnames(df.FA) <- c("Rat", "Time", "Metric", "FA.cortex", "FA.CPu", "FA.hipp", "FA.ic", "FA.cp", "FA.cg", "FA.cc", "Group", "Condition", "Class")
df.FA$Metric <- NULL

df.MD <- df.merged[df.merged$Metric=="MD_new",]
colnames(df.MD) <- c("Rat", "Time", "Metric", "MD.cortex", "MD.CPu", "MD.hipp", "MD.ic", "MD.cp", "MD.cg", "MD.cc", "Group", "Condition", "Class")
df.MD$Metric <- NULL

df.RD <- df.merged[df.merged$Metric=="RD_new",]
colnames(df.RD) <- c("Rat", "Time", "Metric", "RD.cortex", "RD.CPu", "RD.hipp", "RD.ic", "RD.cp", "RD.cg", "RD.cc", "Group", "Condition", "Class")
df.RD$Metric <- NULL

df.AD <- df.merged[df.merged$Metric=="AD_new",]
colnames(df.AD) <- c("Rat", "Time", "Metric", "AD.cortex", "AD.CPu", "AD.hipp", "AD.ic", "AD.cp", "AD.cg", "AD.cc", "Group", "Condition", "Class")
df.AD$Metric <- NULL

df.t1 <- df.merged[df.merged$Metric=="t1values",]
colnames(df.t1) <- c("Rat", "Time", "Metric", "t1.cortex", "t1.CPu", "t1.hipp", "t1.ic", "t1.cp", "t1.cg", "t1.cc", "Group", "Condition", "Class")
df.t1$Metric <- NULL

df.t2 <- df.merged[df.merged$Metric=="t2values",]
colnames(df.t2) <- c("Rat", "Time", "Metric", "t2.cortex", "t2.CPu", "t2.hipp", "t2.ic", "t2.cp", "t2.cg", "t2.cc", "Group", "Condition", "Class")
df.t2$Metric <- NULL

df.pd <- df.merged[df.merged$Metric=="pdvalues",]
colnames(df.pd) <- c("Rat", "Time", "Metric", "pd.cortex", "pd.CPu", "pd.hipp", "pd.ic", "pd.cp", "pd.cg", "pd.cc", "Group", "Condition", "Class")
df.pd$Metric <- NULL


## Merge transformed datasets
merge1 <- merge(df.FA, df.MD, by = c("Rat", "Time", "Group", "Condition", "Class") )
merge2 <- merge(merge1, df.RD, by = c("Rat", "Time", "Group", "Condition", "Class") )
merge3 <- merge(merge2, df.AD, by = c("Rat", "Time", "Group", "Condition", "Class") )
merge4 <- merge(merge3, df.t1, by = c("Rat", "Time", "Group", "Condition", "Class") )
merge5 <- merge(merge4, df.t2, by = c("Rat", "Time", "Group", "Condition", "Class") )
merge6 <- merge(merge5, df.pd, by = c("Rat", "Time", "Group", "Condition", "Class") )


## Select only controls + mild TBI
df.select <- merge6[merge6$Class!="Moderate",]
df.select$FA <- ( df.select$FA.hipp + df.select$FA.cg + df.select$FA.cc ) / 3
df.select$MD <- ( df.select$MD.hipp + df.select$MD.cg + df.select$MD.cc ) / 3
df.select$RD <- ( df.select$RD.hipp + df.select$RD.cg + df.select$RD.cc ) / 3
df.select$AD <- ( df.select$AD.hipp + df.select$AD.cg + df.select$AD.cc ) / 3
df.select$t1 <- ( df.select$t1.hipp + df.select$t1.cg + df.select$t1.cc ) / 3
df.select$t2 <- ( df.select$t2.hipp + df.select$t2.cg + df.select$t2.cc ) / 3
df.select$pd <- ( df.select$pd.hipp + df.select$pd.cg + df.select$pd.cc ) / 3

df.select$Class <- as.factor (df.select$Class)

## To perform some logistic linear mixed model analyses with glmmTMB (laptop), write CSV file
write.table(df.select, "/home1/michel/projects/TBI/analyses/data/logistic_data.csv", sep=";", dec=",", row.names=FALSE)




