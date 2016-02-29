#####################################
###########
########### Courser final assestment
###########
#####################################


install.packages("data.table")
library(data.table)

#Download the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Data.zip", method = "curl")
unzip("Data.zip")


#Read the data
testSubject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
testX<-read.table("./UCI HAR Dataset/test/X_test.txt")
testY<-read.table("./UCI HAR Dataset/test/y_test.txt")


trainSubject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
trainX<-read.table("./UCI HAR Dataset/train/X_train.txt")
trainY<-read.table("./UCI HAR Dataset/train/y_train.txt")

labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
features<-read.table("./UCI HAR Dataset/features.txt")

#Change the colName of the data
colnames(testX)<-features$V2
colnames(trainX)<-features$V2
colnames(testSubject)<-"subject"
colnames(trainSubject)<-"subject"
colnames(testY)<-"activity"
colnames(trainY)<-"activity"

#Merges the training and the test sets to create one data set.
CompleteXdataset<-rbind(testX,trainX)

#Extracts only the measurements on the mean and standard deviation for each measurement.
extract_mean_std_features <- grep("mean|std", features[,2])
MeanStdInfo <- CompleteXdataset[, extract_mean_std_features]

#Uses descriptive activity names to name the activities in the data set
testY[, 1] <- labels[testY[, 1], 2]
trainY[, 1] <- labels[trainY[, 1], 2]

#Merge all data
CompleteFinalData<-cbind(MeanStdInfo, rbind(testY,trainY),rbind(testSubject,trainSubject))

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject
DataTable <- data.table(CompleteFinalData)
tidy_dataset<-DT[,lapply(.SD,mean),by="activity,subject"]


#Write the tidy data in a file
write.table(tidy_dataset, file = "./tidy_dataset.txt", row.names=FALSE)
