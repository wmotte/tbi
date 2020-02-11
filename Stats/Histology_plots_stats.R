## Script to plot and analyse histological MBP data ## 16-2-2020 ## UMC Utrecht ##
## Author: Michel R.T. Sinke ## Biomedical MR Imaging and Spectroscopy Group #####
##################################################################################

## Load packages
library( 'reshape2')
library( 'ggplot2')
library( 'plyr' )

## Set Working Directory
setwd("D:/Werk/Projecten/TBI/Histologie/")

## create outdir
outdir <- 'output'
dir.create( outdir, showWarnings = FALSE )

## Read in data and key-file
key <- read.table("Key_histology.csv", sep=";", header=TRUE)
data <- read.table("ROIs_tbi.csv", sep=";", header=TRUE)


## Merge data and key
df <- merge(key, data, by="Rat")

## Average cingulum left/right and cortex left/right
df$Cortex <- (df$Cortex_left+df$Cortex_right)/2
df$Cingulum <- (df$Cingulum_left+df$Cingulum_right)/2
df$Cortex[10] <- df$Cortex_left[10]

# Remove lateral ROIs
df$Cortex_left <- NULL
df$Cortex_right <- NULL
df$Cingulum_left <- NULL
df$Cingulum_right <- NULL

# Remove rat 25
df <- df[df$Rat!="Rat_25",]


### Normalize values, which range from 0-255 grey-scale -> (outside-value)/255
df$CC_norm <- ((255-df$CC) - (255-df$Outside)) /(255-df$Outside)
df$Cortex_norm <- ((255-df$Cortex) - (255-df$Outside)) /(255-df$Outside)
df$Cingulum_norm <- ((255-df$Cingulum) - (255-df$Outside)) /(255-df$Outside)

#df$CC_norm <- ((255-df$CC) - (255-df$Outside)) 
#df$Cortex_norm <- ((255-df$Cortex) - (255-df$Outside)) 
#df$Cingulum_norm <- ((255-df$Cingulum) - (255-df$Outside)) 

### Make labels and group conditions
df$group <- NULL
df$group[df$Condition=="Control"] <- paste("Sham")
df$group[df$Condition=="Mild"] <- paste("Mild TBI")
df$group[df$Condition=="Moderate"] <- paste("Moderate TBI")

# Select sham only (should be used twice, two timepoints)
df.sham <- df[df$Condition=="Control",]
df.sham$Time <- NULL
df.sham$Time <- paste("24h")

df$Time <- as.character(df$Timepoint)
df$Time[df$Condition=="Control"] <- paste("3-4 months")
df$Time[df$Timepoint=="3m"] <- paste("3-4 months")

# Merge dataframes
df2 <- rbind(df, df.sham)


# Remove normal columns
df2$Outside <- NULL
df2$CC <- NULL
df2$Cingulum <- NULL
df2$Cortex <- NULL


### Reshape dataset
df.melt <- melt(df2, c("Rat", "Timepoint", "Condition", "group", "Time"))
df.melt$value <- as.numeric(df.melt$value)

# Make levels
df.melt$Time <- factor(df.melt$Time, levels=c("24h", "3-4 months") )
df.melt$group <- factor(df.melt$group, levels=c("Sham", "Mild TBI", "Moderate TBI") )

# Calculate mean and SD values
df.average <- ddply( na.omit(df.melt), .( Time, group, variable ), summarise, 
                           mean = mean(value),
                           sd = sd(value) ) 

# Make labels
df.average$labels <- NULL
df.average$labels[df.average$variable=="Cortex_norm"] <- paste("Cortex")
df.average$labels[df.average$variable=="Cingulum_norm"] <- paste("Cingulum")
df.average$labels[df.average$variable=="CC_norm"] <- paste("Corpus Callosum")


### Plot all ROI values at 24h post-TBI
# Set number of decimals on 0
  scaleFUN <- function(x) sprintf("%.0f", x)
  
# Make plot
  plot <-
    ggplot( data = na.omit(df.average), aes( x = labels, y = mean, ymin = mean-sd, ymax = mean+sd, group = group, fill = group ) ) +
    geom_bar( position = "dodge", width = 0.8, stat = 'identity', colour = 'black' ) +
    geom_errorbar( position = "dodge", width = 0.8, stat = 'identity', colour = 'black' ) +
    scale_y_continuous(labels=scaleFUN, breaks=scales::pretty_breaks(n=4)) +
    facet_wrap( ~Time, scales = "free_y" ) +  
    scale_fill_manual( values = c("darkolivegreen3", "darkorange2", 			"firebrick3") ) + 
    scale_colour_manual( values = c("black", "darkorange2", "firebrick3") ) +
    xlab( "\n Brain region" ) +
    ylab( "MBP Intensity \n" ) +
    theme_minimal() +
    theme_bw( base_size = 10 ) + 
    theme(axis.text=element_text(size=20), 
          axis.title=element_text(size=25, face="bold")) + 
    theme(axis.text.y=element_text(size=20)) +
    theme(axis.text.x=element_text(size=20, angle = 45, hjust=1)) +
    theme(plot.title = element_text(size=25,face="bold", hjust=0.5 )) +
    theme(legend.position="right" ) + theme(legend.title = element_blank()) +
    ggtitle(paste("Time point \n") ) + 
    theme(strip.text.x = element_text(size = 20, face="bold")) +
    theme(plot.title = element_text(margin=margin(b = 15, unit = "pt"))) +
    theme(legend.text=element_text(size=25) )
  
  # Write output
  outfile <- paste( outdir, "/Plot_MBP_24h_3m.png", sep = "" )
  ggsave( file = outfile, plot = plot, dpi = 500, width = 12, height = 8 ) 



#### Statistical testing of histological findings 24h post-TBI
aov <- aov(CC_norm ~ Condition, data = df.acute)
summary(aov)

aov <- aov(Cingulum_norm ~ Condition, data = df.acute)
summary(aov)

aov <- aov(Cortex_norm ~ Condition, data = df.acute)
summary(aov)



#### Statistical testing of histological findings 3m post-TBI
aov <- aov(CC_norm ~ Condition, data = df.chronic)
summary(aov)

aov <- aov(Cingulum_norm ~ Condition, data = df.chronic)
summary(aov)

aov <- aov(Cortex_norm ~ Condition, data = df.chronic)
summary(aov)






