## Needed library 
library(data.table)
library(lubridate)
library(dplyr)
library(datasets)

## Chek dataset and read it.
if (!file.exists("./data/exdata-data-household_power_consumption.zip")) {
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/exdata-data-household_power_consumption.zip", method = "curl")
}
DT <- read.csv(unz("./data/exdata-data-household_power_consumption.zip", "household_power_consumption.txt"), sep = ";", header = TRUE, 
		colClasses = c("character",
                        "character",
                        "numeric",
                        "numeric",
                        "numeric",
                        "numeric",
                        "numeric",
                        "numeric",
                        "numeric"),
              strip.white = TRUE,
              na.strings = c("?",""))
DT = data.table(DT)
tables()

## Subsetting data.
myDT <- filter(DT, Date == "1/2/2007" | Date == "2/2/2007")
myDT$DateTime = dmy_hms(paste(myDT$Date, myDT$Time))
rm("DT")


## Save current system's locale
locale <- Sys.getlocale(category = "LC_TIME")

## Set English locale
Sys.setlocale("LC_TIME", "en_US.UTF-8")

## Plot3
png(filename = "plot3.png",
    width = 480, height = 480, units = "px", pointsize = 12,
     bg = "white",  res = NA,
    type = c("cairo", "cairo-png", "Xlib", "quartz"))

with(plot(myDT$DateTime, myDT$Sub_metering_1, type = "l", lwd = 1,
     xlab = "", ylab = "Energy sub metering", col="black"))
with(lines(myDT$DateTime, myDT$Sub_metering_2, type = "l", lwd = 1,
     col="red"))
with(lines(myDT$DateTime, myDT$Sub_metering_3, type = "l", lwd = 1,
     col="blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()

## Restore system's original locale
Sys.setlocale("LC_TIME", locale)

