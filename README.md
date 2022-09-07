Steps in run_analysis.R
=======================

1. Download and unzip the data. The data is sent to the working directory.

2. Load the main data sets using the read.table function. The data sets are assigned to separate objects: "training_set" and "test_set".

3. Load the column names and apply them to both data sets. The column names are first assigned to the object "features" before being applied to both data sets.

4. Extract the mean and standard deviation for each measurement by subsetting each data set.

5. Load the activity ids and labels for both data sets, and then add those labels to the data sets. The activity ids are added first using cbind, and then the activity labels are applied using left_join. The data sets are then reorganized so that the activities appear in the first columns, and those columns are given descriptive names.

6. Load the subjects for both data sets, and then add the subjects to the data sets. The subjects are added using cbind. The data sets are then reorganized so that the subjects appear in the first column, and that column is given a descriptive name.  

7. Merge the two data sets using rbind, forming the full_data_set.

8. Create an independent tidy data set with the average of each variable for each activity and each subject. The tidy_data_set was created using melt and dcast to reshape the data and compute the mean for each variable.

9. Write the final tidy_data_set as a text file.
