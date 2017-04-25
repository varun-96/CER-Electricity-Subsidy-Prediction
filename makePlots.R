makePlots = function(df)
{
    png("Yearly_vs_Heavy.png")
    g1 = ggplot(df,aes(x = factor(total_heavy_devices), y = Average_consumption_by_year,fill = factor(total_heavy_devices))) + geom_boxplot() +guides(fill = F) +
            ggtitle("Yearly Consumption vs Heavy devices") + xlab("Total number of heavy devices") + ylab("Average yearly consumption")
    plot(g1)
    dev.off()
    
    
    png("Yearly_vs_Income.png")
    g2 = ggplot(df,aes(x = factor(income_category), y = Average_consumption_by_year,fill = factor(income_category))) + geom_boxplot() +guides(fill = F) +
        ggtitle("Yearly Consumption vs Income Category") + xlab("Income category") + ylab("Average yearly consumption(in kWh)")
    plot(g2)
    dev.off()
    
    
    png("Yearly_vs_Peoplee.png")
    g3 = ggplot(df,aes(x = factor(total_number_of_people), y = Average_consumption_by_year,fill = factor(total_number_of_people))) + geom_boxplot() +guides(fill = F) +
        ggtitle("Yearly Consumption vs Number of People") + xlab("Total number of people") + ylab("Average yearly consumption(in kWh)")
    plot(g3)
    dev.off()
    
    png("Comparison.png")
    x = ggplot(df[1:20,],aes(x =  MeterID)) + geom_line(aes(y = Sleeping.Hours.Consumption.x),color = "Green") + xlab("MeterID") + ylab("Consumption") + ggtitle("Consumption in different time slots")
    x = x+  geom_line(aes(y = Working.Hours.Consumption.x),color = "Red")
    x = x + geom_line(aes(y = Evening.Hours.Consumption.x),color = "Blue")
    plot(x)
    dev.off()
    
}
