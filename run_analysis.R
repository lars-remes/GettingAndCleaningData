## Function for reading and processing UCI HAR dataset

## This R script does the following:
##  * Merges the raw training and the test sets to create one data set.
##  * Merges activity and subject ids to data set
##  * A ppropriately labels the data set with descriptive variable names.
##  * Converts activity ids to factor variable and labels activities
##  * Extracts only the measurements on the mean (mean()) and standard 
##    deviation (std()) for each measurement.
##  * From the data set created by previous steps, creates a second, 
##    independent tidy data set with the average of each var$
##  * Writes the second data set to disk with file name getdata-007-means.txt
##
## The script assumes raw data is located in the working directory in 
## subdirectory "UCI HAR dataset". Thus, to use the script you need only 
## extract (unzip) the data set from course project page and run the script.

library(dplyr)
run_analysis <- function() {
    # read labels
    feature_labels <- read.table("./UCI HAR Dataset/features.txt", 
                                 sep="", 
                                 header=F)
    activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                                 sep="", 
                                 header=F)
    
    # read and label 'train' data set
    train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
    train_activities <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                                   sep="")
    train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                                 sep="")
    names(train) <- feature_labels[,2]
    train_df <- tbl_df(train)
    train_df <- mutate(train_df, 
                       "activity" = train_activities[,1], 
                       "subject" = train_subjects[,1])
    
    # read and label 'test' set
    test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
    test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                                  sep="")
    test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                                sep="")
    names(test) <- feature_labels[,2]
    test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                                  sep="")
    test_df <- tbl_df(test)
    test_df <- mutate(test_df, "activity" = test_activities[,1], 
                      "subject" = test_subjects[,1])
    
    # merge the data sets and label the activities
    merged_df <- rbind(train_df, test_df)
    merged_df$activity <- factor(merged_df$activity, labels=activity_labels[,2])
    
    # Finally select only columns containing mean or std data
    filtered <- select(merged_df, subject, activity, 
                       contains("mean()"),
                       contains("std()"))
    
    # Now step 5: 
    # we need to average each variable for each subject/activity combination
    # We do this using aggregate and grouping by subject and activity.
    # This gives us 30 subject * 6 activities = 180 observations with 88 variables.
    res <- aggregate(filtered[,-c(1,2)], 
                     list(subject = filtered$subject, 
                          activity = filtered$activity), mean)
    write.table(res,file="getdata-007-means.txt")
    res
}
