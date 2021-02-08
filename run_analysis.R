## load dplyr package
library(dplyr)
## First set working directory
setwd("/Users/lee_saxton/Documents/Data Science Specialisation/03 Getting And Cleaning Data/Week 4/Week 4 Course Project/")
## Next check for data directory and create it if necessary
if (!file.exists("data")) {
  dir.create("data")
}
## Download zipped data file
fileurl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile="./data/smartphone.zip", method="curl")
## Unzip data set
unzip("./data/smartphone.zip")
## Next, read the data and assign to data frames
## First we read the feature names and activity labels
features <-read.table("UCI HAR Dataset/features.txt", col.names = c("n","feature"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
## Now read test and train datasets
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
## Now read train datasets
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
## Merge subject, training and test datasets, we want to merge rows
subject_merge <- rbind(subject_train, subject_test)
x_merge <- rbind(x_train, x_test)
y_merge <- rbind(y_train, y_test)
## Now merge all into one table, this time using cbind
merge_all <- cbind(subject_merge, y_merge, x_merge)
## Select columns to keep
## First update columns of merge_all with names in features
## Then create a list of column names to keep using grepl and the or  option (pipe)
colnames(merge_all) <- c("subject", "code", features[,2])
keepcols <- grepl("subject|code|mean|std", colnames(merge_all))
## Use keepcols vector to select columns to keep from merge_all
merge_all_keep <- merge_all[,keepcols]
## Now start to assign meaningful names
## First update "code" with real activity name
## Match value in code header to real activity in activities vector
merge_all_keep$code <- activities[merge_all_keep$code,2]
## Now update column names using gsub
## First remove () and -  characters
names(merge_all_keep)<-gsub("[\\(\\)-]", "",names(merge_all_keep))
## Now update Acc, Gyro, Mag, mean, std, freq, angle, gravity
names(merge_all_keep)<-gsub("code", "Activity", names(merge_all_keep))
names(merge_all_keep)<-gsub("subject", "Subject", names(merge_all_keep))
names(merge_all_keep)<-gsub("Acc", "Accelerometer", names(merge_all_keep))
names(merge_all_keep)<-gsub("Gyro", "Gyroscope", names(merge_all_keep))
names(merge_all_keep)<-gsub("Mag", "Magnitude", names(merge_all_keep))
names(merge_all_keep)<-gsub("mean", "Mean", names(merge_all_keep))
names(merge_all_keep)<-gsub("std", "StandardDeviation", names(merge_all_keep), ignore.case = TRUE)
names(merge_all_keep)<-gsub("freq", "Frequency", names(merge_all_keep), ignore.case = TRUE)
names(merge_all_keep)<-gsub("angle", "Angle", names(merge_all_keep))
names(merge_all_keep)<-gsub("gravity", "Gravity", names(merge_all_keep))
## Where column name begins with t replace t with Time
## WHere column name begins with f replace f with Frequency
names(merge_all_keep)<-gsub("^t", "Time", names(merge_all_keep))
names(merge_all_keep)<-gsub("^f", "Frequency", names(merge_all_keep))
## There is a typo with bodybody, replace this with body
names(merge_all_keep)<-gsub("BodyBody", "Body", names(merge_all_keep))
## Our final tidy dataset in merge_all_keep
## We now need to create a summary with the average of each variable for each activity 
## and each subject. We will us groupby function for this
final_mean <- merge_all_keep %>% group_by (Subject, Activity) %>%
  summarise_all(funs(mean))
## Delete intermediate datasets
rm("activities", "features", "merge_all", "subject_merge", "subject_test", "subject_train", "x_merge", "x_train","x_test", "y_merge", "y_train","y_test", "fileurl", "keepcols")

