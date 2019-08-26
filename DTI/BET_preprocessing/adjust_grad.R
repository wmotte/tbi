#### Set working directory
setwd("/home1/michel/projects/TBI/")
wd <- getwd()

## Make directory list to make a loop
dirlist <- list.dirs(path="./processed/DTI/", full.names = FALSE, recursive=FALSE)[3:203]

for (dir in dirlist)

{

print(paste("Processing: ", dir, sep=""))

#### First read in bvecs and bvals ####
bvecs <- read.csv( paste(wd, "/data/DTI/", dir, "/bvecs", sep=""), sep = "\t", dec = ".", header = FALSE )
bvals <- read.csv( paste(wd, "/data/DTI/", dir, "/bvals", sep=""), sep = "\t", dec = ".", header = FALSE )


#### Change order and direction of gradients according to ExploreDTI Suggestion
bvecs.new <- bvecs
bvecs.new$v1 <- bvecs$V1*-1
bvecs.new$v2 <- bvecs$V2
bvecs.new$v3 <- bvecs$V3

# Remove old values
bvecs.new$V1 <- NULL
bvecs.new$V2 <- NULL
bvecs.new$V3 <- NULL


#### Write new bvecs file for FSL
write.table(bvecs.new, file=paste(wd, "/processed/DTI/", dir, "/bvecs_fsl", sep=""), col.names=FALSE, row.names=FALSE)


##### Construct MRtrix3 Grad-file by combining bvecs and bvals (x,y,z,b), x direction should be multiplied by -1 since MRtrix3 uses 
##### a differen convention
grad <- bvecs.new
grad$v1 <- grad$v1*-1
grad <- cbind(grad, bvals)

## Write MRtrix3 Grad-file and bvals
write.table(grad, file=paste(wd, "/processed/DTI/", dir, "/grad.txt", sep=""), col.names=FALSE, row.names=FALSE)
write.table(bvals, file=paste(wd, "/processed/DTI/", dir, "/bvals", sep=""), col.names=FALSE, row.names=FALSE)

}

