########################################################################
#
# Statistical models TBI logistic regression
# m.r.t.sinke@umcutrecht.nl
#
########################################################################
# Set working dir
setwd("D:/Werk/Projecten/TBI/Statistics/")

library( 'lme4' )
#library( 'emmeans' )
library( 'glmmTMB' )
library( 'pscl' )


# create outdir
outdir <- 'logistic.stats'
dir.create( outdir, showWarnings = FALSE )

# indir
indir <- 'data'

# read data
head( df <- read.csv( paste0( indir, '/logistic_data_TBI.csv' ), sep=";", dec="," ) )
df$response <- NULL
df$response[df$Class=="Moderate"] <- 1
df$response[df$Class=="Mild"] <- 0
      
# make three timepoint selections
df.hour <- df[df$Time=="00h",]
df.day <- df[df$Time=="24h",]
df.week <- df[df$Time=="01w",]
      

### FOR 1 HOUR POST-TBI ####

### Specifiy different models, from complex to simple
m1 <- glm(Class ~ FA + AD + RD + t2, data = df.hour,
            family = binomial(link = "logit"))

m2 <- glm(Class ~ FA + AD + RD, data = df.hour,
          family = binomial(link = "logit"))

m3 <- glm(Class ~ FA + AD, data = df.hour,
          family = binomial(link = "logit"))

m4 <- glm(Class ~ FA + RD, data = df.hour,
          family = binomial(link = "logit"))

m5 <- glm(Class ~ AD + RD, data = df.hour,
          family = binomial(link = "logit"))

m6 <- glm(Class ~ AD, data = df.hour,
          family = binomial(link = "logit"))

m7 <- glm(Class ~ RD, data = df.hour,
          family = binomial(link = "logit"))

m8 <- glm(Class ~ FA, data = df.hour,
          family = binomial(link = "logit"))

m9 <- glm(Class ~ t2, data = df.hour,
          family = binomial(link = "logit"))



## Specify null-model
m0 <- glm(Class ~ 1, data = df.hour,
          family = binomial(link = "logit"))

## Compare all models
aovmodels1h <- anova(m0,m1,m2,m3,m4,m5,m6,m7,m8,m9, test="Chisq")

write.table(as.data.frame(aovmodels1h), paste(getwd(),"/",outdir,"/logr_models_mild_moderate.csv", sep=""), sep=";", dec=",")

## Calculate R2 and McFadden for all models
Rm1 <- as.data.frame(t (pR2(m1)) )
Rm2 <- as.data.frame(t (pR2(m2)) )
Rm3 <- as.data.frame(t (pR2(m3)) )
Rm4 <- as.data.frame(t (pR2(m4)) )
Rm5 <- as.data.frame(t (pR2(m5)) )
Rm6 <- as.data.frame(t (pR2(m6)) )
Rm7 <- as.data.frame(t (pR2(m7)) )
Rm8 <- as.data.frame(t (pR2(m8)) )
Rm9 <- as.data.frame(t (pR2(m9)) )
Rm.total <- rbind(Rm1, Rm2, Rm3, Rm4, Rm5, Rm6, Rm7, Rm8, Rm9)
row.names(Rm.total) <- c("m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9")

write.table(Rm.total, paste(getwd(),"/",outdir,"/logr_R2s_mild_moderate.csv", sep=""), sep=";", dec=",", row.names=TRUE, col.names=TRUE)




### REPEAT FOR 1 DAY POST-TBI ####


### Specifiy different models, from complex to simple
m1 <- glm(Class ~ FA + AD + RD + t2, data = df.day,
          family = binomial(link = "logit"))

m2 <- glm(Class ~ FA + AD + RD, data = df.day,
          family = binomial(link = "logit"))

m3 <- glm(Class ~ FA + AD, data = df.day,
          family = binomial(link = "logit"))

m4 <- glm(Class ~ FA + RD, data = df.day,
          family = binomial(link = "logit"))

m5 <- glm(Class ~ AD + RD, data = df.day,
          family = binomial(link = "logit"))

m6 <- glm(Class ~ AD, data = df.day,
          family = binomial(link = "logit"))

m7 <- glm(Class ~ RD, data = df.day,
          family = binomial(link = "logit"))

m8 <- glm(Class ~ FA, data = df.day,
          family = binomial(link = "logit"))

m9 <- glm(Class ~ t2, data = df.day,
          family = binomial(link = "logit"))



## Specify null-model
m0 <- glm(Class ~ 1, data = df.day,
          family = binomial(link = "logit"))

## Compare all models
aovmodels24h <- anova(m0,m1,m2,m3,m4,m5,m6,m7,m8,m9, test="Chisq")

write.table(as.data.frame(aovmodels24h), paste(getwd(),"/",outdir,"/logr_models_mild_moderate_24h.csv", sep=""), sep=";", dec=",")

## Calculate R2 and McFadden for all models
Rm1 <- as.data.frame(t (pR2(m1)) )
Rm2 <- as.data.frame(t (pR2(m2)) )
Rm3 <- as.data.frame(t (pR2(m3)) )
Rm4 <- as.data.frame(t (pR2(m4)) )
Rm5 <- as.data.frame(t (pR2(m5)) )
Rm6 <- as.data.frame(t (pR2(m6)) )
Rm7 <- as.data.frame(t (pR2(m7)) )
Rm8 <- as.data.frame(t (pR2(m8)) )
Rm9 <- as.data.frame(t (pR2(m9)) )
Rm.total <- rbind(Rm1, Rm2, Rm3, Rm4, Rm5, Rm6, Rm7, Rm8, Rm9)
row.names(Rm.total) <- c("m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9")

write.table(Rm.total, paste(getwd(),"/",outdir,"/logr_R2s_mild_moderate_24h.csv", sep=""), sep=";", dec=",", row.names=TRUE, col.names=TRUE)



