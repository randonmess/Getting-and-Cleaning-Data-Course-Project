## load dplyr package
library(dplyr)

## download and unzip raw data if it doesn't exist
if (!file.exists("rawdata.zip")) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL,"rawdata.zip", method = "curl")
}

if (!file.exists("UCI HAR Dataset")) {
  unzip("rawdata.zip")
}

## read raw data files
## the column names of xtest and xtrain correspond to each feature's observations
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","features"))
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt" , col.names = "subject")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$features, check.names = FALSE)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt" , col.names = "subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$features, check.names = FALSE)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## merge training and test sets
xdata <- rbind(xtrain,xtest)
ylabels <- rbind(ytrain,ytest)
subects <- rbind(subjecttrain,subjecttest)
mergeddata <- cbind(subects,ylabels,xdata)

## extract columns for mean and std
tidydata <- select(mergeddata, subject, code, contains("mean"), contains("std"))

## change activity code to activity name
tidydata <- mutate(tidydata, code = activitylabels[code,2]) %>% rename(activity = code)

## appropriately label data with descriptive names
names(tidydata) <- gsub("^t","Time", names(tidydata))
names(tidydata) <- gsub("^f","Frequency", names(tidydata))
names(tidydata) <- gsub("Acc","Accelerometer", names(tidydata))
names(tidydata) <- gsub("Gyro","Gyroscope", names(tidydata))
names(tidydata) <- gsub("Mag","Magnitude", names(tidydata))
names(tidydata) <- gsub("gravity","Gravity", names(tidydata))
names(tidydata) <- gsub("mean\\(\\)","Mean", names(tidydata))
names(tidydata) <- gsub("meanFreq\\(\\)","MeanFrequency", names(tidydata))
names(tidydata) <- gsub("std\\(\\)","STD", names(tidydata))
names(tidydata) <- gsub("tBody","TimeBody", names(tidydata))
names(tidydata) <- gsub("BodyBody","Body", names(tidydata))

## return dataframe with mean of each variable by subject and activity
meandata <- tidydata %>% group_by(subject,activity) %>% summarise_all(mean)

