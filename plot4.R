# Set locale to English for time axis
Sys.setlocale("LC_TIME", "English")

# Download the zip file into a temporary file
tmpFile <- tempfile()
download.file(url      = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              destfile = tmpFile,
              mode     = "wb")

# Load the datafile into an object
dataRead <- read.table(file      = unz(description = tmpFile,
                                       filename = "household_power_consumption.txt"),
                       header    = TRUE,
                       sep       = ";",
                       na.string = "?")

# We do not need the temporary file anymore, it can be deleted
unlink(tmpFile)
rm(tmpFile)

# Create a real date column to ease processing
dataRead$DateTime <- as.POSIXct(paste(dataRead$Date, dataRead$Time), 
                                format = "%d/%m/%Y %H:%M:%S")

# Subset the data to only keep
minDate <- as.POSIXct("2007-02-01")
maxDate <- as.POSIXct("2007-02-03")

dataGraph <- dataRead[dataRead$DateTime < maxDate &
                      dataRead$DateTime >= minDate,]

# Clear loaded dataset, we don't need it anymore
rm(dataRead)
rm(minDate)
rm(maxDate)

# Setup more global parameters for graphs
xaxisData <- dataGraph$DateTime



# Initialize lines and infos for chart #2
linesSpecs = matrix(c("Sub_metering_1", "Black",
                      "Sub_metering_2", "OrangeRed2",
                      "Sub_metering_3", "Blue"),
                    nrow = 2,
                    ncol = 3)

# Initialize device
png(filename = "plot4.png",
    width    = 480,
    height   = 480)

par(mfcol = c(2,2))

# Draw plot #1
plot(x    = xaxisData,
     y    = dataGraph$Global_active_power,
     type = "l",       # Line chart without points
     xlab = "",
     ylab = "Global Active Power")

# Draw the empty plot for plot #2
plot(x    = xaxisData,
     y    = dataGraph$Sub_metering_1,
     type = "n",         # No line drawn
     xlab = "",
     ylab = "Energy Sub Metering")

# Add the lines in plot #2 as defined higher
for (curr in 1:ncol(linesSpecs))
{
    points(x    = xaxisData,
           type = "l",           # Line without points
           y    = dataGraph[,linesSpecs[1, curr]],
           col  = linesSpecs[2, curr])
}

# Add legend to plot #2
legend("topright", linesSpecs[1,], col = linesSpecs[2,], lwd = 1, bty="n")

# Draw the 3rd plot
plot(x    = xaxisData,
     y    = dataGraph$Voltage,
     type = "l",       # Line chart without points
     xlab = "datetime",
     ylab = "Voltage")


# draw the 4th plot
plot(x    = xaxisData,
     y    = dataGraph$Global_reactive_power,
     type = "l",       # Line chart without points
     xlab = "datetime",
     ylab = "Global_reactive_power")

# Close the device
dev.off()

# Clean up the session
rm(dataGraph)
rm(curr)
rm(linesSpecs)