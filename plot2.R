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

# Initialize device
png(filename = "plot2.png",
    width    = 480,
    height   = 480)

# Draw the plot
plot(x    = dataGraph$DateTime,
     y    = dataGraph$Global_active_power,
     type = "l",       # Line chart without points
     xlab = "",
     ylab = "Global Active Power (kilowatts)"
    )

# Close the device
dev.off()

# Clean up the session
rm(dataGraph)