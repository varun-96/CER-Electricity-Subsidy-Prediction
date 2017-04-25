
## Reading files

source("preprocessing.R")

preprocessing("File1.txt")
preprocessing("File2.txt")
preprocessing("File3.txt")
preprocessing("File4.txt")
preprocessing("File5.txt")
preprocessing("File6.txt")


##  Reading Survey File

source("feature_extraction.R")
source("collection.R")

finalDF = collection()

## Data Visualization

source("makePlots.R")
makePlots(finalDF)  ## exploratory data analysis


## Predictive Modeling

source("elbow.R")
source("algorithms.R")

elbow(finalDF) ## Choose appropriate K value for kmeans Clustering
Algorithms(finalDF) ## creates solution.csv as final output


## Final Outcome

Subsidy <- read.csv("solution.csv")
SubsidyID = Subsidy$MeterID
