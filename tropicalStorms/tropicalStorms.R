library(xml2)
library(tidyr)
library(XML)
library(plyr)
library(ggplot2)


tsxml <- read_xml("https://www.nhc.noaa.gov/TCR_StormReportsIndex.xml")
x <- read_xml("<foo> <bar> text <baz/> </bar> </foo>")

d <- xmlParse(tsxml,useInternalNodes = TRUE)


xL <- xmlToList(d)

tsdata <- ldply(xL, data.frame)

ts_yb <- as.data.frame(table(tsdata$Year, tsdata$Basin))

names(ts_yb)[1] <- 'Year'
names(ts_yb)[2] <- 'Basin'

ts_yb$Year <- as.character(ts_yb$Year)

ggplot(ts_yb, aes(x=Year, y=Freq, group = Basin,color=Basin)) + 
  geom_point() + geom_line() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  geom_smooth(method = "lm") + 
  scale_x_discrete(breaks=seq(1958, 2018, 10))

dev.copy(png,width=700, 'ts_trend.png')
dev.off()
