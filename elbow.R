elbow = function(df)
{
    ## Elbow method
    rng<-2:20 
    tries <-100 
    avg.totw.ss <-integer(length(rng))
    for(v in rng)
    {
        v.totw.ss <-integer(tries) 
        for(i in 1:tries)
        {
            k.temp <-kmeans(df[,-1],centers=v) 
            v.totw.ss[i] <-k.temp$tot.withinss    
        }
        avg.totw.ss[v-1] <-mean(v.totw.ss) 
    }
    
    df = data.frame(x = rng,y = avg.totw.ss)
    g = ggplot(df,aes(x = x,y = y)) + geom_line() + xlab("Value of k") + ylab("Average Total Within Sum of Squares") + ggtitle("Total Within SS by Various K")
    png("Elbow_Method.png")
    plot(g)
    dev.off()
}