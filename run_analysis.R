library(dplyr)
run_analysis <- function() {
    # read labels
    feature_labels <- read.table("./UCI HAR Dataset/features.txt", sep="", header=F)
    activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep="", header=F)
    
    # read and label 'train' data set
    train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
    train_activities <- read.table("./UCI HAR Dataset/train/y_train.txt", sep="")
    train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")
    names(train) <- feature_labels[,2]
    train_df <- tbl_df(train)
    train_df <- mutate(train_df, "activity" = train_activities[,1], "subject" = train_subjects[,1])
    
    # read and label 'test' set
    test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
    test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt", sep="")
    test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")
    names(test) <- feature_labels[,2]
    test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt", sep="")
    test_df <- tbl_df(test)
    test_df <- mutate(test_df, "activity" = test_activities[,1], "subject" = test_subjects[,1])
    
    # merge the data sets and label the activities
    merged_df <- rbind(train_df, test_df)
    merged_df$activity <- factor(merged_df$activity, labels=activity_labels[,2])
    
    # Finally select only columns containing mean or std data
    filtered <- select(merged_df,subject,activity,contains("mean"),contains("std"))
    
    # ddply(df, .(contains("mean)),summarize,avg=)
    filtered
}
