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
dataRead$DateDate <- as.Date(dataRead$Date, 
                             format="%d/%m/%Y")

# Subset the data to only keep
minDate <- as.Date("2007-02-01")
maxDate <- as.Date("2007-02-02")

dataGraph <- dataRead[dataRead$DateDate <= maxDate &
                      dataRead$DateDate >= minDate,]

# Clear loaded dataset, we don't need it anymore
rm(dataRead)
rm(minDate)
rm(maxDate)

# Initialize device
png(filename = "plot1.png",
    width    = 480,
    height   = 480)

# Draw the plot
hist(x    = dataGraph$Global_active_power,
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency",
     main = "Global Active Power",
     col  = "OrangeRed2"
    )

# Close the device
dev.off()

# Clean up the session
rm(dataGraph)