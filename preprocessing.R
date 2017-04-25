preprocessing <- function(fname){
library(data.table)
library(tidyr)
library(caTools)
library(dplyr)

text1 <- fread(fname)
colnames(text1) <- c("MeterID","Code","Consumption")

newtext1 <- separate(text1, Code, into = c("Day_Code","Time_Code"), sep = 3, remove = F)

#Time_Code is from 01-95

newtext1$Time_Code = as.numeric(newtext1$Time_Code)

newtext1$Time_Code = newtext1$Time_Code %% 48;
newtext1$Time_Code[newtext1$Time_Code == 0] = 48

range(newtext1$Time_Code)

time <- newtext1$Time_Code

time[(time >= 37 & time <= 48) | (time >= 1 & time <= 4)] = 300
time[time >= 21 & time <= 36] = 200
time[time >= 5 & time <= 20] = 100

newtext1$newtime <- as.numeric(time)


agg <- aggregate(newtext1$Consumption, by = list(newtext1$MeterID),FUN = "mean")
colnames(agg) <- c("MeterID", "Average_Consumption")
write.csv(agg, "aggregate.csv",row.names = F)

agg_newtime = aggregate(newtext1$Consumption, by = list(newtext1$MeterID, newtext1$newtime), FUN = "mean")
agg_newtime$Time = agg_newtime$Group.2
agg_newtime$Time[agg_newtime$Time == 100] = "Sleeping Hours"
agg_newtime$Time[agg_newtime$Time == 200] = "Working Hours"
agg_newtime$Time[agg_newtime$Time == 300] = "Evening Hours"

agg_newtime$Time = as.factor(agg_newtime$Time)

colnames(agg_newtime) = c("MeterID","Time_Duration","Consumption","Time")

new = agg_newtime[agg_newtime$Time_Duration == 100,]
new1 = agg_newtime[agg_newtime$Time_Duration == 200,]
new2 = agg_newtime[agg_newtime$Time_Duration == 300,]

newdff = merge(new,new1, by = "MeterID")
newdff = merge(newdff,new2, by = "MeterID")

newdff = subset(newdff, select = c(1,3,6,9))
colnames(newdff) = c("MeterID","Sleeping Hours Consumption","Working Hours Consumption","Evening Hours Consumption")

####Day_Code is from 195-365-730
# 195 = 14 July
newtext1$Day_Code = as.numeric(newtext1$Day_Code)

year = newtext1$Day_Code
year = ifelse(year>=195 & year<= 365,1,2)

newtext1$year = year

agg_yearly = aggregate(newtext1$Consumption, by = list(newtext1$MeterID, newtext1$year), FUN = "sum")
colnames(agg_yearly) = c("MeterID", "Year", "Total Consumption")

agg_yearly[agg_yearly$MeterID == 1932, ]
agg_yearly[agg_yearly$MeterID == 1492, ]

new = agg_yearly[agg_yearly$Year == 1,]
new1 = agg_yearly[agg_yearly$Year == 2,]

newdff1 = merge(new,new1, by = "MeterID")

newdff1 = subset(newdff, select = c(1,3,5))
colnames(newdff1) = c("MeterID","Year1 Consumption","Year2 Consumption")


### Monthly

newtext1$Month = newtext1$Day_Code

newtext1$Month = newtext1$Month %% 365
newtext1$Month[newtext1$Month == 0] = 365

newtext1$Month[newtext1$Month >= 1 & newtext1$Month <= 31] = 1100
newtext1$Month[newtext1$Month >= 32 & newtext1$Month <= 59] = 1200
newtext1$Month[newtext1$Month >= 60 & newtext1$Month <= 90] = 1300
newtext1$Month[newtext1$Month >= 91 & newtext1$Month <= 120] = 1400
newtext1$Month[newtext1$Month >= 121 & newtext1$Month <= 151] = 1500
newtext1$Month[newtext1$Month >= 152 & newtext1$Month <= 181] = 1600
newtext1$Month[newtext1$Month >= 182 & newtext1$Month <= 212] = 1700
newtext1$Month[newtext1$Month >= 213 & newtext1$Month <= 243] = 1800
newtext1$Month[newtext1$Month >= 244 & newtext1$Month <= 273] = 1900
newtext1$Month[newtext1$Month >= 274 & newtext1$Month <= 304] = 2000
newtext1$Month[newtext1$Month >= 305 & newtext1$Month <= 334] = 2100
newtext1$Month[newtext1$Month >= 335 & newtext1$Month <= 365] = 2200


agg_monthly = aggregate(newtext1$Consumption, by = list(newtext1$MeterID, newtext1$Month), FUN = "sum")
colnames(agg_monthly) = c("MeterID","Month","Total Consumption")

new = agg_monthly[agg_monthly$Month == 1100,]
new1 = agg_monthly[agg_monthly$Month == 1200,]
new2 = agg_monthly[agg_monthly$Month == 1300,]
new3 = agg_monthly[agg_monthly$Month == 1400,]
new4 = agg_monthly[agg_monthly$Month == 1500,]
new5 = agg_monthly[agg_monthly$Month == 1600,]
new6 = agg_monthly[agg_monthly$Month == 1700,]
new7 = agg_monthly[agg_monthly$Month == 1800,]
new8 = agg_monthly[agg_monthly$Month == 1900,]
new9 = agg_monthly[agg_monthly$Month == 2000,]
new10 = agg_monthly[agg_monthly$Month == 2100,]
new11 = agg_monthly[agg_monthly$Month == 2200,]

agg_monthly[agg_monthly$Group.1 == 1950,]

neww = Reduce(function(x, y) merge(x, y, by = "MeterID"), list(new,new1,new2,new3,new4,new5,new6,new7,new8,new9,new10,new11))
neww = subset(neww, select = c(1,3,5,7,9,11,13,15,17,19,21,23,25))
colnames(neww) = c("MeterID","Jan Consumption","Feb Consumption","Mar Consumption","Apr Consumption","May Consumption","Jun Consumption","July Consumption","Aug Consumption","Sept Consumption","Oct Consumption","Nov Consumption","Dec Consumption")

agg <- aggregate(newtext1$Consumption, by = list(newtext1$MeterID),FUN = "mean")
colnames(agg) <- c("MeterID", "Average_Consumption")

Total = merge(newdff, neww, by = "MeterID")
Total = merge(Total, newdff1, by = "MeterID")
Total = merge(Total, agg, by = "MeterID")


write.csv(Total, paste("Total",substr(fname,5,5),".csv",sep=""), row.names = F)

}