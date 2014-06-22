# Source of data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Objective : Merges the training and the test sets to create one data set.
# Student: Vinay Bagare

# Question 1 Merges the training and the test sets to create one data set
# getwd()
#?paste
# X data 
baseDir <- "/Users/bagare/Documents/Vindoc/R/UCIHARDataset"
x_file1 <- read.table(paste(baseDir,"/train/X_train.txt",sep=""))
x_file2 <- read.table(paste(baseDir,"/test/X_test.txt",sep=""))
X <- rbind(x_file1, x_file2)

# Y data 
baseDir <- "/Users/bagare/Documents/Vindoc/R/UCIHARDataset"
y_file1 <- read.table(paste(baseDir,"/train/y_train.txt",sep=""))
y_file2 <- read.table(paste(baseDir,"/test/y_test.txt",sep=""))
Y <- rbind(y_file1, y_file2)

# Question 2 Extracts only the measurements on the mean and standard deviation for each measurement
baseDir <- "/Users/bagare/Documents/Vindoc/R/UCIHARDataset"
#?grep
features <- read.table(paste(baseDir,"/features.txt",sep=""))
tail(features)
features
extractFeatures <- features[, 2]
IdxGoodFeatures <- grep("-mean\\(\\)|-std\\(\\)", extractFeatures)
X1 <- X[, as.vector(IdxGoodFeatures)]
names(X1) <- features[IdxGoodFeatures, 2]
names(X1) <- gsub("\\(|\\)", "", names(X1))
#?tolower
names(X1) <- tolower(names(X1)) 
X1

# Question 3 - Uses descriptive activity names to name the activities in the data set
baseDir <- "/Users/bagare/Documents/Vindoc/R/UCIHARDataset"
activities <- read.table(paste(baseDir,"/activity_labels.txt",sep=""))
activities
library(stringi)
activities[, 2] = stri_trans_totitle(gsub("_", " ", as.character(activities[, 2])))

Y1 <- Y
Y1[,1] = activities[Y1[,1], 2]
names(Y1) <- "activity"
colnames(Y1)
Y1 


# Question 4 - Appropriately labels the data set with descriptive variable names. 
cat("\014")
# total cols 66 + 1 
# NCOL(head(X))
# NCOL(head(Y))
BIND_ALL <- cbind(X,Y1)
head(BIND_ALL)
sub_all <- append(as.vector(sub_x), colnames(Y1))
sub_all
colnames(BIND_ALL) <- sub_all
cleaned <- BIND_ALL
write.table(cleaned, "./data/cleanedMergedData.txt")

# Question 5 - Creates a second, 
#              independent tidy data set with the average of each variable 
#              for each activity and each subject. 

S <- unique(colnames(BIND_ALL))
numSubjects = length(unique(S))
numSubjects
numActivities = length(activities[,1])
numActivities
numCols = dim(BIND_ALL)[2]
numCols
Result = BIND_ALL[1:(numSubjects*numActivities), ]
Result
rowCount = 1
for (i in 1:numSubjects) {
  for (a in 1:numActivities) {
    Result[rowCount, 1] = uniqueSubjects[i]
    Result[rowCount, 2] = activities[a, 2]
    tmp <- cleaned[cleaned$subject==i & cleaned$activity==activities[a, 2], ]
    Result[rowCount, 3:numCols] <- colMeans(tmp[, 3:numCols])
    rowCount = rowCount+1
  }
}

write.table(Result, "./data/DS_Question5.txt")
