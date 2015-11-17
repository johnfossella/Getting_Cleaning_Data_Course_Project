# install.library("tidyr")
library(dplyr)
library(data.table)
library(tidyr)

# Downloaded and unzipped the files and placed them into a wd on my desktop
setwd("~/Desktop/Classproject/UCI HAR Dataset")
fPath <- "~/Desktop/Classproject/UCI HAR Dataset"

# GOAL 1: Merges the training and the test sets to create one data set.
dSubjectTrain <- tbl_df(read.table(file.path(fPath, "train", "subject_train.txt")))
dSubjectTrain <- tbl_df(read.table(file.path(fPath, "train", "subject_train.txt")))
dSubjectTest  <- tbl_df(read.table(file.path(fPath, "test" , "subject_test.txt" )))
dActivityTrain <- tbl_df(read.table(file.path(fPath, "train", "Y_train.txt")))
dActivityTest  <- tbl_df(read.table(file.path(fPath, "test" , "Y_test.txt" )))
dTrain <- tbl_df(read.table(file.path(fPath, "train", "X_train.txt" )))
dTest  <- tbl_df(read.table(file.path(fPath, "test" , "X_test.txt" )))

# Merge (bind) the activity and subject tables
all_Subjects <- rbind(dSubjectTrain, dSubjectTest)
setnames(all_Subjects, "V1", "subject")
all_Activity<- rbind(dActivityTrain, dActivityTest)
setnames(all_Activity, "V1", "activityNum")

# Bind training and test files
dataTable <- rbind(dTrain, dTest)

# Naming variables by feature.txt
dataFeatures <- tbl_df(read.table(file.path(fPath, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName

# Putting labels on columns for activity measurements
activityLabels<- tbl_df(read.table(file.path(fPath, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

# Final merge
alldataSubjAct<- cbind(all_Subjects, all_Activity)
dataTable <- cbind(alldataSubjAct, dataTable)


# GOAL 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTable<- subset(dataTable,select=dataFeaturesMeanStd)


# GOAL 3: Uses descriptive activity names to name the activities in the data set
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean)
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

# GOAL 4: Appropriately labels the data set with descriptive variable names. 
# Body = body move. Gravity = gravity. Acc = accelerometer. Gyro = gyro. Jerk = sudden jerks. Mag = amplitude.

# Add appropriate labels
names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))


# GOAL 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(dataTable, "TidyData.txt", row.name=FALSE)


