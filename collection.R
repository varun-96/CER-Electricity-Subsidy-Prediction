collection <- function(){
    
    library(dplyr)
    
    Survey_features = read.csv("newdf.csv")
    
    total1 = read.csv("Total1.csv")
    total2 = read.csv("Total2.csv")
    total3 = read.csv("Total3.csv")
    total4 = read.csv("Total4.csv")
    total5 = read.csv("Total5.csv")
    total6 = read.csv("Total6.csv")
    
    total = rbind(total1,total2,total3,total4,total5,total6)
    
    finalDF = merge(total, Survey_features, by = "MeterID")
    
    finalDF = as.data.frame(finalDF)
    finalDF
}