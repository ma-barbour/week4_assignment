library(tidyverse)
library(reshape2)
setwd("~/Coursera Stuff/datasciencecoursera")

# Download and unzip the data

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "assignment_data.zip", method = "curl")
unzip("assignment_data.zip")

# Load the main data sets

training_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Load the column names and apply them to both data sets

features <- read.table("./UCI HAR Dataset/features.txt")[,2]
names(training_set) <- features
names(test_set) <- features

# Extract only the mean and standard deviation for each measurement

training_set <- training_set[,grepl("mean|std", features)]
test_set <- test_set[,grepl("mean|std", features)]

# Load the activity ids for both data sets

training_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Load the activity labels

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Add the activity labels to both data sets

training_set <- cbind(training_set, training_labels)
training_set <- left_join(training_set, activity_labels, by = "V1")
training_set <- select(training_set, 80, 81, 1:79) %>%
  rename(Activity_ID = V1, Activity = V2)
test_set <- cbind(test_set, test_labels)
test_set <- left_join(test_set, activity_labels, by = "V1")
test_set <- select(test_set, 80, 81, 1:79) %>%
  rename(Activity_ID = V1, Activity = V2)

# Load the subjects

test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
training_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Add the subjects to both data sets

training_set <- cbind(training_set, training_subjects)
training_set <- select(training_set, 82, 1:81) %>%
  rename(Subject = V1)
test_set <- cbind(test_set, test_subjects)
test_set <- select(test_set, 82, 1:81) %>%
  rename(Subject = V1)

# Merge the data sets

full_data_set <- rbind(training_set, test_set)

# Create an independent tidy data set with the average of each variable for each activity and each subject (using melt and dcast functions)

id_labels <- c("Subject", "Activity_ID", "Activity")
data_labels <- setdiff(colnames(full_data_set), id_labels)
molten_data <- melt(full_data_set, id = id_labels, measure.vars = data_labels)
tidy_data_set <- dcast(molten_data, Subject + Activity ~ variable, mean)

# Write the final tidy_data_set as a text file

write.table(tidy_data_set, file = "./tidy_data_set.txt", row.name=FALSE)