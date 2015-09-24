# For networks
library('ANTsR')
library('parallel')

# Import brain mask and compute desired dimensions
mask <- antsImageRead("matmask.nii.gz",3)
xdim <- dim(mask)[1]
ydim <- dim(mask)[2]
zdim <- dim(mask)[3]
vecmask <- (mask > 0)
numelem <- length(mask[vecmask])

# Prepare a vector of subject identifiers
bblids <- unlist(read.table('../../bblidlist'))
#bblids_input <- rep(bblids,each=4)
bblids_input <- rep(bblids,each=2)
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
omnimat <- matrix(, ncol = numelem, nrow = length(bblids_input))

# Find all images
imgpath <- list.files(pattern="*_adjmat.nii",recursive=TRUE)
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
  bblid <- strtoi(substr(subj,1,5))
  sccode <- strtoi(scancode[[scan]])
  idxmatch1 <- which(bblids_input %in% bblid)
  idxmatch2 <- which(visit_input %in% sccode)
  idxin <- intersect(idxmatch1, idxmatch2)
  
  # Write the vector into the matrix
  omnimat[idxin,] <- nvec[vecmask]
  
}

source("../../../../applications/I2C2_software_PNC/I2C2_inference.R")

#system.time( net.lambda <- I2C2(omnimat, id = bblids_input, visit = visit_input, J = 4, I = 10, p = numelem) )
system.time( net.lambda <- I2C2(omnimat, id = bblids_input, visit = visit_input, J = 2, I = 10, p = numelem, demean = TRUE) )
 
net.lambda$lambda
 
#### Computing the 95% CI of I2C2
system.time( net.ci <- I2C2.mcCI( omnimat, id = bblids_input, visit = visit_input, J = 2, I = 10, p = numelem, R = 100, rseed = 99, demean = TRUE, ci = 0.95 ) )
x11()
hist( unlist(net.ci) )
 
#### Compute the Null Distribution of I2C2
#### For input, demeaned data were used.
system.time( net.NullDist <- I2C2.mcNulldist( net.lambda$demean_y, id = bblids_input, visit = visit_input, J = 2, I = 10, R = 100, rseed = 1, demean = FALSE ) )  
x11()
hist( unlist(net.NullDist), main = 'NullDistribution' )
 
#### Draw the beanplot
library(beanplot)
beanplot( data.frame(net = net.NullDist), border = 8, ylim = c(-0.5,1), cex.main = 2, cex.axis = 1.5, main = "I2C2-net seed maps", ll = 0.001, col = c(8, 8, "#B2DF8A") )
lines( rep(1, 2), net.ci$CI, col = 1, lwd = 3, lty = 1)
lines( c(0.8, 1.2), rep(net.ci$CI[1], 2), col = 1, lty = 1, lwd = 3)
lines( c(0.8, 1.2), rep(net.ci$CI[2], 2), col = 1, lty = 1, lwd = 3)
lines(c(0.9, 1.1), rep(net.lambda$lambda,2), col = 2, lwd = 4, lty = 1)
legend('topright',c("I2C2","95% CI","Null"),lwd=3,cex=1,col=c(2,1,8))
