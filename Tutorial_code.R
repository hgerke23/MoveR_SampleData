#code following the how to tutorial at : https://qpetitjean.github.io/MoveR/articles/MoveR-ImportData.html



# Install and load package ------------------------------------------------


# install.packages("remotes")
remotes::install_github("qpetitjean/MoveR")

library("MoveR")

# Tutorial code -----------------------------------------------------------

# dl the first dataset from the sample data repository
Path2Data <- MoveR::DLsampleData(dataSet = 1, tracker = "TRex")
Path2Data


# Import the sample data
trackdat <-
  MoveR::readTrex("C:/Users/hannah/Documents/GitHub/MoveR_SampleData/sample_1/TRexOutput")

# check the class, number of tracklets and their id
class(trackdat)

length(trackdat)

names(trackdat)


# display the data for the first particle (animal) only 
str(trackdat[[1]])


# The function import the data as an object of class “tracklets”, a list of
# tracklets (data frame) numbered according to the identity specified by the
# tracking software and containing 7 elements classically used for further
# computations using the MoveR package.
#
# Note that, by default, the output of the various read functions is
# standardized. However, it is also possible to import other elements that are
# specific to the tracking software used by specifying rawDat = TRUE.

# Import the sample data
trackdatFull <-
  MoveR::readTrex(Path2Data[[1]],
                  rawDat = TRUE)

# display the data for the first particle only
str(trackdatFull[[1]])

# check the additional information retrieved from the tracking output (depends on the tracking software used)
MoveR::getInfo(trackdat)

# set the the image resolution, but not the scale as it will not be useful for this tutorial
trackdat <- MoveR::setInfo(trackdat, imgRes = c(3840, 2160))



# Look at Trajectories ----------------------------------------------------


# split the graphical window in 2 columns
par(mfrow = c(1, 2))

# draw the trajectories of all particles
MoveR::drawTracklets(trackdat)

# add a letter identifying the plot to the upper left corner of the first plot
mtext(
  substitute(paste(bold("A"))),
  side = 3,
  line = 0,
  adj = 0,
  padj = -0.5
)

# draw the trajectories only for the first five particles
MoveR::drawTracklets(
  trackdat,
  selTrack = c(1:5)
)

# add a letter identifying the plot to the upper left corner of the second plot
mtext(
  substitute(paste(bold("B"))),
  side = 3,
  line = 0,
  adj = 0,
  padj = -0.5
)


# split the graphical window in 2 columns
par(mfrow=c(1,2))

#Focus on trajectories within certain frames

# draw the trajectories over a time window of 1000 frames (between 1 and 999 frames)
MoveR::drawTracklets(
  trackdat,
  timeWin = list(c(1, 999))
)

# add a letter identifying the plot to the upper left corner of the first plot
mtext(substitute(paste(bold("A"))), side = 3, line = 0, adj = 0, padj = -0.5)

# draw the trajectories over two time windows of 1000 frames (between 6000 and 6999 and 11000 and 11999 frames)
MoveR::drawTracklets(
  trackdat,
  timeWin = list(c(6000, 6999), c(11000, 11999))
)

# add a letter identifying the plot to the upper left corner of the second plot
mtext(substitute(paste(bold("B"))), side = 3, line = 0, adj = 0, padj = -0.5)


#color track by a categorical variable: here the identity of the particles is a
#numerical variable, we hence need to convert it to a factor, for instance by
#appending “Tricho” (i.e., part of the micro-wasps genus name) in front of each
#id. For this purpose, the easiest way is to use the “convert2List” function,
#transform the identity variable then convert back the data as a list of
#tracklets using convert2Tracklets as follow:

trackdatList <- MoveR::convert2List(trackdat)
trackdatList[["identity"]] <- paste("Tricho", trackdatList[["identity"]], sep = "_")
trackdat <- MoveR::convert2Tracklets(trackdatList, by = "identity")

str(trackdat)

# split the graphical window in 2 columns
par(mfrow=c(1,2))

# draw the trajectories over the whole video timeline and color it according to particles' identity
MoveR::drawTracklets(
  trackdat,
  colId = "identity"
)

# add a letter identifying the plot to the upper left corner of the first plot
mtext(substitute(paste(bold("A"))), side = 3, line = 0, adj = 0, padj = -0.5)

# draw the trajectories over two time windows of 1000 frames (between 6000 and 6999 and 11000 and 11999 frames)
MoveR::drawTracklets(
  trackdat,
  timeWin = list(c(1, 999)),
  colId = "identity"
)

# add a letter identifying the plot to the upper left corner of the second plot
mtext(substitute(paste(bold("B"))), side = 3, line = 0, adj = 0, padj = -0.5)

# By looking at the fig. 4B, we can see that some particles’ tracks are
# interrupted. This is particularly obvious for Tricho_7 or Tricho_11, let’s
# take a closer look.

# restore the graphical window as default
par(mfrow=c(1,1))

# draw the selected tracklets over the whole video timeline and color it according to tracklets
MoveR::drawTracklets(
  trackdat,
  colId = "selTrack",
  selTrack = c("Tricho_7","Tricho_11")
)

#It indicate that the tracking software have lost or perhaps switched the
#identity of some animals over the tracking session. The dataset hence need to
#cleaned/filtered to remove as much artifacts as possible. It indicate that the
#tracking software have lost or perhaps switched the identity of some animals
#over the tracking session. The dataset hence need to cleaned/filtered to remove
#as much artifacts as possible.