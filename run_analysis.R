# This function loads the dplyr library which is required for this assignment.
library(dplyr)

file1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data"))(dir.create("./data"))
  download.file(file1, destfile = "./data/assign.zip")
  assignFile <- "./data/assign.zip"
  unzip(assignFile)

# Creating variables from the UCI HAR Dataset
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")  
x_test <- read.table("UCI HAR Dataset/test/x_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/x_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activities"))

# Merging the information from the UCI HAR Dataset using rbind to combine x, y, and subject
# subfiles.  Then I use cbind to combine x, y, and subject to each other.

x_merge <- rbind(x_test, x_train)                           #  Merges x_test and x_train into x_merge
y_merge <- rbind(y_test, y_train)                           #  Merges y_test and y_train into y_merge
subject_merge <- rbind(subject_test, subject_train)         #  Merges subject_test and subject_train into subject_merge
mergeTable <- cbind(subject_merge, x_merge, y_merge)        #  Merges subject_merge, x_merge, and y_merge into mergeTable

tidyData <- mergeTable %>% select(subject, code, contains("mean"), contains("std"))

tidyData <- activities(code)

names(tidydata)[2] = "activity"
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidytata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))

Output <- tidydata %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Output, "Assignment4.txt", row.name=FALSE)



