# list all the files

ref_path <- file.path(getwd() , "UCI HAR Dataset")
files<-list.files(ref_path, recursive=TRUE)
files

# Read data from the files into the variables

# Read the Activity files

TestDataActivity  <- read.table(file.path(ref_path, "test" , "Y_test.txt" ),header = FALSE)
TrainDataActivity <- read.table(file.path(ref_path, "train", "Y_train.txt"),header = FALSE)

# Read the Subject files

TestDataSubject  <- read.table(file.path(ref_path, "test" , "subject_test.txt"),header = FALSE)
TrainDataSubject <- read.table(file.path(ref_path, "train", "subject_train.txt"),header = FALSE)

# Read Fearures files

TestDataFeatures  <- read.table(file.path(ref_path, "test" , "X_test.txt" ),header = FALSE)
TrainDataFeatures <- read.table(file.path(ref_path, "train", "X_train.txt"),header = FALSE)

# Look at the properties of the above varibles

str(TestDataActivity)

str(TrainDataActivity)

str(TestDataSubject)

str(TrainDataSubject)

str(TestDataFeatures)

str(TrainDataFeatures)

# Merges the training and the test sets to create one data set

# Concatenate the data tables by rows

D_Subject <- rbind(TrainDataSubject, TestDataSubject)
D_Activity<- rbind(TrainDataActivity, TestDataActivity)
D_Features<- rbind(TrainDataFeatures, TestDataFeatures)

# set names to variables

names(D_Subject)<-c("subject")
names(D_Activity)<- c("activity")
dataFeaturesNames <- read.table(file.path(ref_path, "features.txt"),head=FALSE)
names(D_Features)<- dataFeaturesNames$V2

# Merge columns to get the data frame Data for all data

D_Combine <- cbind(D_Subject, D_Activity)
Data <- cbind(D_Features, D_Combine)

# Extracts only the measurements on the mean and standard deviation for each measurement

# Subset Name of Features by measurements on the mean and standard deviation

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

# Subset the data frame Data by seleted names of Features

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

# Check the structures of the data frame Data

str(Data)

# Uses descriptive activity names to name the activities in the data set

# Read descriptive activity names from "activity_labels.txt"

ActivityLabels <- read.table(file.path(ref_path, "activity_labels.txt"),header = FALSE)

# facorize Variale activity in the data frame Data using descriptive activity names and check

head(Data$activity,30)

# Appropriately labels the data set with descriptive variable names

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

# Creates a second,independent tidy data set and ouput it

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
