# Some notes on the variables contained in the script.

## These tables contain the raw data from subject, testing and training data.
> dSubjectTrain <- tbl_df(read.table(file.path(fPath, "train", "subject_train.txt")))
> dSubjectTrain <- tbl_df(read.table(file.path(fPath, "train", "subject_train.txt")))
> dSubjectTest  <- tbl_df(read.table(file.path(fPath, "test" , "subject_test.txt" )))
> dActivityTrain <- tbl_df(read.table(file.path(fPath, "train", "Y_train.txt")))
> dActivityTest  <- tbl_df(read.table(file.path(fPath, "test" , "Y_test.txt" )))
> dTrain <- tbl_df(read.table(file.path(fPath, "train", "X_train.txt" )))
> dTest  <- tbl_df(read.table(file.path(fPath, "test" , "X_test.txt" )))

## The merged activity and subject tables
> all_Subjects <- rbind(dSubjectTrain, dSubjectTest)
> setnames(all_Subjects, "V1", "subject")
> all_Activity<- rbind(dActivityTrain, dActivityTest)
> setnames(all_Activity, "V1", "activityNum")

## The bound training and test files
> dataTable <- rbind(dTrain, dTest)

## The variables here are named according to features provided in the original data. Mainly they relate to different aspects of the gyroscope measurements and different dimensions of accelleration when the body is in motion.
> dataFeatures <- tbl_df(read.table(file.path(fPath, "features.txt")))
> setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
> colnames(dataTable) <- dataFeatures$featureName
> activityLabels<- tbl_df(read.table(file.path(fPath, "activity_labels.txt")))
> setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))
> alldataSubjAct<- cbind(alldataSubject, alldataActivity)
> dataTable <- cbind(alldataSubjAct, dataTable)

## The measurements of mean and standard deviation for each measurement. 
> dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)
> dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
> dataTable<- subset(dataTable,select=dataFeaturesMeanStd)

## Descriptive activity names
> dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
> dataTable$activityName <- as.character(dataTable$activityName)
> dataTable$activityName <- as.character(dataTable$activityName)
> dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean)
> dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

## Specific labels related to motion of the: Body = body move. Gravity = gravity. Acc = accelerometer. Gyro = gyro. Jerk = sudden jerks. Mag = amplitude.
> names(dataTable)<-gsub("std()", "SD", names(dataTable))
> names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
> names(dataTable)<-gsub("^t", "time", names(dataTable))
> names(dataTable)<-gsub("^f", "frequency", names(dataTable))
> names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
> names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
> names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
> names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))

##  Tidy data set 
> write.table(dataTable, "TidyData.txt", row.name=FALSE)


