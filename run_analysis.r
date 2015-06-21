# Getting and Cleaning Data Project
# Ruben Flecha

getwd()
setwd("C:/Users/Ruben/Getting_and_Cleaning_Data")

if(!require("reshape2")) install.packages("reshape2")
library(reshape2)

dataBaseDir <- "./UCI HAR Dataset/"
dataTestDir <- "./UCI HAR Dataset/test/"
dataTrainDir <- "UCI HAR Dataset/train/"

activities <- read.table(paste0(dataBaseDir, "activity_labels.txt"), header=FALSE, stringsAsFactors=FALSE)
features <- read.table(paste0(dataBaseDir, "features.txt"), header=FALSE, stringsAsFactors=FALSE)

# Test Data import and prepare
subject_test <- read.table(paste0(dataTestDir, "subject_test.txt"), header=FALSE)
x_test <- read.table(paste0(dataTestDir, "X_test.txt"), header=FALSE)
y_test <- read.table(paste0(dataTestDir, "y_test.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_test$V1, labels = activities$V2))
testData <- cbind(tmp, subject_test, x_test)

# Train Data Import & Prepare
subject_train <- read.table(paste0(dataTrainDir, "subject_train.txt"), header=FALSE)
x_train <- read.table(paste0(dataTrainDir, "X_train.txt"), header=FALSE)
y_train <- read.table(paste0(dataTrainDir, "y_train.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_train$V1, labels = activities$V2))
trainData <- cbind(tmp, subject_train, x_train)

# Tidy Data
tmpTidyData <- rbind(testData, trainData)
names(tmpTidyData) <- c("Activity", "Subject", features[,2])
select <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
tidyData <- tmpTidyData[c("Activity", "Subject", select)]

# Write Tidy Data to file tinyData.txt
write.table(tidyData, file="./tidyData.txt", row.names=FALSE)
message("Writing Tidy Data to disk in tidyData.txt. DONE.")

# Tidy Data Average/Activity. Melt and Cast.
tidyDataMelt <- melt(tidyData, id=c("Activity", "Subject"), measure.vars=select)
tidyDataMean <- dcast(tidyDataMelt, Activity + Subject ~ variable, mean)

# Write Tidy Average Data
write.table(tidyDataMean, file="./tidyAverageData.txt", row.names=FALSE)


