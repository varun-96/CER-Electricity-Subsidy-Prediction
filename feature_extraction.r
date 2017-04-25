library(data.table)
library(dplyr)

final_df <- c()

collect_data <- function()
{
    pre_survey <- fread('Smart meters Residential pre-trial survey data.csv')
    pre_survey_df <- as.data.frame(pre_survey)
    #pre_survey_df <- pre_survey_df[, c(1,3,4,10:14,35:60,71:115,135:138)]
    #pre_survey_df[is.na(pre_survey_df)] <- 0
    return(pre_survey_df)
}

create_df <- function(df)
{
    n <- nrow(df)
    s <- c('ID','total_number_of_people', 'house_occupancy', 'area_of_home', 'total_usage_purpose', 'total_heavy_devices', 'total_light_devices', 'total_heavy_device_usage', 'total_light_device_usage', 'income_category')
    m <- length(s)
    final_df <<- data.frame(matrix(0, nrow = n, ncol = m))
    colnames(final_df) <<- s
    final_df[,1] <<- df[,1]
}

total_people <- function(df)
{
    #column 2 for total number of people
    for(i in 1:nrow(df))
    {
        if(is.na(df[i,10]))
            next
        if(df[i,10] == 1)
        {
            final_df[i,2] <<- 1
            final_df[i,3] <<- 0
        }
        else if(df[i, 10] == 2)
        {
            final_df[i,2] <<- df[i,11]
            if(df[i,12] != 8)
                final_df[i,3] <<- final_df[i,3] + df[i,12]
            else if(df[i,12] == 8)
                final_df[i,3] <<- final_df[i,3] + 0
        }
        else
        {
            final_df[i,2] <<- df[i,11] + df[i,13]
            
            if(df[i,12] != 8)
                final_df[i,3] <<- final_df[i,3] + df[i,12]
            else if(df[i,12] == 8)
                final_df[i,3] <<- final_df[i,3] + 0
            
            if(df[i,14] != 8)
                final_df[i,3] <<- final_df[i,3] + df[i,14]
            else if(df[i,14] == 8)
                final_df[i,3] <<- final_df[i,3] + 0
        }
    }
}

area_of_home <- function(df)
{
    #can find corr between number of rooms and area of home
    final_df[,4] <<- df[,39]
    for(i in 1:nrow(df))
    {
        if(is.na(df[i,40]))
            next
        if(df[i,40] == 1)
            final_df[i,4] <<- final_df[i,4] * 0.093
        if(df[i,39] == 999999999)
            final_df[i,4] <<- -1
    }
}

usage <- function(df)
{
    for(i in 1:nrow(df))
    {
        if(df[i,43] == 1 && !is.na(df[i,43]))
            final_df[i,5] <<- final_df[i,5] + 1
        if(df[i,50] == 1 && !is.na(df[i,50]))
            final_df[i,5] <<- final_df[i,5] + 1
        if(df[i,51] == 1 && !is.na(df[i,51]))
            final_df[i,5] <<- final_df[i,5] + 1
        if(df[i,52] == 1 && !is.na(df[i,52]))
            final_df[i,5] <<- final_df[i,5] + 1
        if((df[i,60] == 1 || df[i,60] == 5) && !is.na(df[i,60]))
            final_df[i,5] <<- final_df[i,5] + 1
    }
    
    final_df[,8] <<- df[,101]
    for(i in range(102,110))
        final_df[,8] <<- final_df[,8] + df[, i]
    
    final_df[,9] <<- df[,111]
    for(i in range(112,115))
        final_df[,9] <<- final_df[,9] + df[, i]
}


devices2 <- function(df)
{
    for(i in 1:nrow(df))
    {
        final_df[i,6] <<- sum(df[i,81:90]) - 10
        final_df[i,7] <<- sum(df[i,96:100]) - 5
    }
}

calc_income <- function(df)
{
    #consider question 402
    income <- df[,136]
    for(i in 1:nrow(df))
    {
        if(is.na(income[i]))
        {
            income[i] <- df[i,135]
        }
        if(income[i] == 1)
            income[i] = 15000
        if(income[i] == 2)
            income[i] = 30000
        if(income[i] == 3)
            income[i] = 50000
        if(income[i] == 4)
            income[i] = 75000
        if(income[i] == 5)
            income[i] = 100000
        if(income[i] == 6)
            income[i] = -1
        
        if(is.na(df[i,137]))
            next
        if(df[i, 137] == 1)
            income[i] = income[i] *52
        
        if(df[i, 137] == 2)
            income[i] = income[i] *12
    }
    final_df[,10] <<- income
}

##Function calling

collect_data()
create_df(pre_survey)
total_people(pre_survey)
usage(pre_survey)
devices2(pre_survey)
calc_income(pre_survey)
area_of_home(pre_survey)

write.csv(final_df, "final_df.csv",row.names = F)

