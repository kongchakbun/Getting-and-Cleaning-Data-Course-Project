
# load the package of "downloader"
library(downloader)

# set the URL for catching the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "

# download zip file
download(fileUrl, dest = "./data/Human_activity.zip", mode = "wb")

# unzip the file
unzip("./data/Human_activity.zip")

# read the file of activity_labels.txt
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# read the file of features.txt
features <- read.table("./UCI HAR Dataset/features.txt")

# read the file of subject_test.txt
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read the data sets of X_test.txt and y_test.txt
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

# read the file of subject_train.txt
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read the file of X_train.txt and y_train.txt
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# load the package of "dplyr"
library(dplyr)

# change the column names of the X_test and X_train according to the features.txt
colnames(X_test) <- features$V2
colnames(X_train) <- features$V2

# change the column name of subject_test and subject_train to "subject"
names(subject_test) <- "subject"
names(subject_train) <- "subject"

# change the column name of y_train and y_test to "label"
names(y_train) <- "label"
names(y_test) <- "label"

# combine the columnes of subject_test, X_test and y_test
humanActivityTest <- cbind(subject_test, X_test, y_test)

# combine the columnes of subject_train, X_train and y_train
humanActivityTrain <- cbind(subject_train, X_train, y_train)

# combine the rows of test an train data sets
humanActivity <- rbind(humanActivityTest, humanActivityTrain)
# part 1 of the project was completed.


# select the colume related to subject, mean, standard deviation and label
humanActivityMeanStd <- humanActivity[ , grep("subject|mean()-|std|label", colnames(humanActivity))]
# part 2 of the project was completed.

# change the column name of the V1 of the activity_labels.txt to "label"
names(activity_labels) <- c("label", "V2")

# merge the data sets of humanActvityMeanStd and the activity_label based on "label" 
mergeDesc <- merge(humanActivityMeanStd, activity_labels, by = "label")

# remove the column of "label" in merged file
mergeDesc <- select(mergeDesc, -1)

# rename the column name related to activity
firstTidyDataSet <- rename(activity = V2, mergeDesc)
# part 3 of the project was completed.

# group the first tidy data set by subject and actvity
groupActivity <- group_by(firstTidyDataSet, subject, activity)

# summarize the data set with the average of each variable 
secondTidyDataSet <- summarize_all(groupActivity, funs(mean))
# part 4 of the project was completed.

# save the tidy data set in the file of "tidydata.txt"
write.table(secondTidyDataSet, file="tidydata.txt", row.names = FALSE)





