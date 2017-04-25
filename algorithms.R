Algorithms <- function(df)
{
library(data.table)
library(dplyr)
library(ggplot2)
library(caret)
library(e1071)
library(randomForest)


########

test = subset(df, income_category == -1)
test = test[,-13]
train = subset(df, income_category != -1)
train$income_category = as.factor(train$income_category)



#####Using support vector machine prediction

fit <- svm(income_category ~ ., data = train)
predicted = predict(fit,newdata = test)
predicted = as.data.frame(predicted)

test = test[,-15]
test$income_category = predicted$predicted

ddf = rbind(train, test)

set.seed(123)
kmeans.model = kmeans(ddf[,-1], 4)
tags = kmeans.model$cluster
Groups = as.factor(tags)

png("Sleeping_Hours_vs_Working_Hours.png")
g <- ggplot(ddf,aes(x = Sleeping.Hours.Consumption.x,y = Working.Hours.Consumption.x,color = Groups)) + geom_point()
plot(g)
dev.off()

png("Light_Devices_vs_Average Consumption in half hour.png")
g <- ggplot(ddf,aes(x = total_light_devices,y = Average_Consumption,color = Groups)) + geom_point()
plot(g)
dev.off()

png("Yearly_vs_People.png")
g <- ggplot(ddf,aes(x = total_number_of_people,y = Average_consumption_by_year,color = Groups)) + geom_point()
plot(g)
dev.off()

png("Average Consumption in half hour_vs_Income.png")
g <- ggplot(ddf,aes(x = Average_Consumption,y = income_category,color = Groups)) + geom_point()
plot(g)
dev.off()

subsidy.svm = ddf[kmeans.model$cluster == 2,]



##Using Random Forest Prediction
fit.randomforest = randomForest(income_category ~ ., data = train)
predict.rf = predict(fit.randomforest, newdata = test)
predict.rf = as.data.frame(predict.rf)

test = test[,-15]
test$income_category = predict.rf$predict.rf

ddf = rbind(train, test)
set.seed(234)
kmeans.model = kmeans(ddf[,-1], 4)
tags = kmeans.model$cluster
Groups = as.factor(tags)

##PLots
png("Sleeping_Hours2_vs_Working_Hours2.png")
g <- ggplot(ddf,aes(x = Sleeping.Hours.Consumption.x,y = Working.Hours.Consumption.x,color = Groups)) + geom_point()
plot(g)
dev.off()

png("Light_Devices2_vs_Average Consumption in half hour2.png")
g <- ggplot(ddf,aes(x = total_light_devices,y = Average_Consumption,color = Groups)) + geom_point()
plot(g)
dev.off()

png("Yearly2_vs_People2.png")
g <- ggplot(ddf,aes(x = total_number_of_people,y = Average_consumption_by_year,color = Groups)) + geom_point()
plot(g)
dev.off()

png("Average Consumption in half hour2_vs_Income2.png")
g <- ggplot(ddf,aes(x = Average_Consumption,y = income_category,color = Groups)) + geom_point()
plot(g)
dev.off()


subsidy.rf = ddf[kmeans.model$cluster == 4,]

#####

subsidy = intersect(subsidy.rf, subsidy.svm)
write.csv(subsidy, "solution.csv", row.names = F)

}