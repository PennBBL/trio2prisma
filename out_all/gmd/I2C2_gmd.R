# For GMD (smoothed)
library('ANTsR')
library('parallel')

# Import brain mask and compute desired dimensions
mask <- antsImageRead("../4mmstd_mask.nii.gz",3)
xdim <- dim(mask)[1]
ydim <- dim(mask)[2]
zdim <- dim(mask)[3]
vecmask <- (mask > 0)
numelem <- length(mask[vecmask])

# Prepare a vector of subject identifiers
bblids <- unlist(read.table('../../bblidlist'))
bblids_rdin <- unlist(sapply(read.table('../../subjectlist'),function(x) strtoi(substr(x,1,5))))
scanids <- unlist(sapply(read.table('../../subjectlist'),function(x) strtoi(substr(x,7,10))))
#bblids_input <- rep(bblids,each=4)
bblids_input <- rep(bblids,each=2)
scanids_input <- rep(scanids,each=2)
# 11 : HUP6 / BBL
# 12 : HUP6 / HCP
# 21 : Prisma / BBL
# 22 : Prisma / HCP
scancode <- new.env()
scancode[["hup6/BBL"]] <- 11
scancode[["hup6/HCP"]] <- 12
scancode[["prisma/BBL"]] <- 21
scancode[["prisma/HCP"]] <- 22
#visit <- c(11,12,21,22)
visit <- c(11,22)
visit_input <- rep(visit,times=10)

# Initialise the all-subject matrix
omnimat <- matrix(, nrow = numelem, ncol = length(bblids_input))

# Find all images
imgpath <- list.files(pattern="*_sm6_ds.nii.gz",recursive=TRUE)
num_img <- length(imgpath)

for (i in 1:num_img) {
  
  # Load in the image
  curimg <- imgpath[i]
  nifti <- antsImageRead(curimg,3)
  
  # Vectorise the image
  nvec <- nifti[vecmask]
  
  # Determine the BBL ID and the scan code
  scan <- dirname(curimg)
  subj <- basename(curimg)
  scanid <- strtoi(substr(subj,3,6))
  sccode <- strtoi(scancode[[scan]])
  scindex <- which(scanids %in% scanid)
  idxmatch1 <- which(bblids_input %in% bblids_rdin[scindex])
  idxmatch2 <- which(visit_input %in% sccode)
  idxin <- intersect(idxmatch1, idxmatch2)
  
  # Write the vector into the matrix
  omnimat[,idxin] <- nvec
  
}

omnimat <- t(omnimat)

source("../../../../applications/I2C2_software_PNC/I2C2_inference.R")
 
#system.time( gmd.lambda <- I2C2(omnimat, id = bblids_input, visit = visit_input, J = 4, I = 10, p = numelem) )
system.time( gmd.lambda <- I2C2(omnimat, id = bblids_input, visit = visit_input, J = 2, I = 10, p = numelem, demean = TRUE) )
 
gmd.lambda$lambda
 
#### Computing the 95% CI of I2C2
system.time( gmd.ci <- I2C2.mcCI( omnimat, id = bblids_input, visit = visit_input, J = 2, I = 10, p = numelem, R = 100, rseed = 99, demean = TRUE, ci = 0.95 ) )
x11()
hist( unlist(gmd.ci) )
 
#### Compute the Null Distribution of I2C2
#### For input, demeaned data were used.
system.time( gmd.NullDist <- I2C2.mcNulldist( gmd.lambda$demean_y, id = bblids_input, visit = visit_input, J = 2, I = 10, R = 100, rseed = 1, demean = FALSE ) )  
x11()
hist( unlist(gmd.NullDist), main = 'NullDistribution' )
 
#### Draw the beanplot
library(beanplot)
beanplot( data.frame(gmd = gmd.NullDist), border = 8, ylim = c(-0.5,1), cex.main = 2, cex.axis = 1.5, main = "I2C2-gmd seed maps", ll = 0.001, col = c(8, 8, "#B2DF8A") )
lines( rep(1, 2), gmd.ci$CI, col = 1, lwd = 3, lty = 1)
lines( c(0.8, 1.2), rep(gmd.ci$CI[1], 2), col = 1, lty = 1, lwd = 3)
lines( c(0.8, 1.2), rep(gmd.ci$CI[2], 2), col = 1, lty = 1, lwd = 3)
lines(c(0.9, 1.1), rep(gmd.lambda$lambda,2), col = 2, lwd = 4, lty = 1)
legend('topright',c("I2C2","95% CI","Null"),lwd=3,cex=1,col=c(2,1,8))
