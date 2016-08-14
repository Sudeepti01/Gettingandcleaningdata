#########################################################################################################

## Coursera Getting and Cleaning Data Course Project

##Activity Recognition Using Smartphones Dataset

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################

##Set working directory
setwd("C:/Users/HR Login/Music/Desktop/UCI HAR Dataset")

# Read in the train data from files
features     <- read.table('./features.txt',header=FALSE)
activityType <- read.table('./activity_labels.txt',header=FALSE)
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE)
xTrain       <- read.table('./train/x_train.txt',header=FALSE)
yTrain       <- read.table('./train/y_train.txt',header=FALSE)

##Read in test data
subjectTest <- read.table('./test/subject_test.txt',header=FALSE)
xTest     <- read.table('./test/X_test.txt',header=FALSE)
yTest     <- read.table('./test/Y_test.txt',header=FALSE)

##Assign column names
colnames(activityType)  <- c('activity_Id','activity_Type')
colnames(subjectTrain)  <- "subject_Id"
colnames(xTrain)        <- features[,2]
colnames(yTrain)        <- "activity_Id"


# Assign column names to the test data 
colnames(subjectTest) <- "subject_Id"
colnames(xTest)       <- features[,2] 
colnames(yTest)       <- "activity_Id"

##Combine traning data

trainData = cbind(yTrain,subjectTrain,xTrain)

##combine test data

testData <- cbind(yTest,subjectTest,xTest)

#Combine test and train data

finalData <- rbind(trainData,testData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

##save in a vector columns for mean and standard deviation

colNames <- colnames(finalData)

##Logic for collecting only columns with mean and standard deviation

logicalVector <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) | grepl("-std..",colNames))
finalData <- finalData[logicalVector==TRUE]
colnames1 <- colnames(finalData)
logicalVector1 <- grepl("-meanFreq()..", colnames1)
finalData <- finalData[logicalVector1==FALSE]
colnames(finalData)

#Assiging proper activity names and variable namaes

for (i in 1:length(colNames)) 
{
  colNames[i] <- gsub("\\()","",colNames[i])
  colNames[i] <- gsub("-std$","StdDev",colNames[i])
  colNames[i] <- gsub("-mean","Mean",colNames[i])
  colNames[i] <- gsub("^(t)","time",colNames[i])
  colNames[i] <- gsub("^(f)","freq",colNames[i])
  colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] <- gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
}

colnames(finalData) = colNames

# Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

tidydata <- finalData
#Export the dataset
write.table(tidydata, './tidydata.txt',row.names=TRUE,sep='\t')







