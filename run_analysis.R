library(dplyr)
run_analysis <- function() {
    X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
    X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
    X_train_df <- tbl_df(X_train)
    X_test_df <- tbl_df(X_test)
    df <- rbind(X_train_df, X_test_df)
    labels <- read.table("./UCI HAR Dataset/features.txt", sep="", header=F)
    names(df) <- labels[,2]
    select(df,contains("mean"),contains("B"))
    X
}