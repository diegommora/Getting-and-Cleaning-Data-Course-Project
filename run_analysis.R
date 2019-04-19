## Download the zip folder

wd <- getwd()
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,paste(wd,"/files.zip",sep=""))
unzip("files.zip",exdir = paste(wd,"/files",sep=""))
maindir <- "./files/UCI HAR Dataset"
testdir <- "./files/UCI HAR Dataset/test"
traindir <- "./files/UCI HAR Dataset/train"

## 1. Merges the training and the test sets to create one data set.

## Read the files for data, labels and subjet for each dataset (train and test)
traindata <- read.table(paste(traindir,"/X_train.txt",sep=""))
testdata <- read.table(paste(testdir,"/X_test.txt",sep=""))

trainlabels <- read.table(paste(traindir,"/y_train.txt",sep=""),col.names = "label")
testlabels <- read.table(paste(testdir,"/y_test.txt",sep=""),col.names = "label")

trainsubject <- read.table(paste(traindir,"/subject_train.txt",sep=""),col.names = "subject")
testsubject <- read.table(paste(testdir,"/subject_test.txt",sep=""),col.names = "subject")
## Bind rows for create a single data, labels and subject dataset
totaldata <- rbind(testdata,traindata)
totallabels <- rbind(testlabels,trainlabels)
totalsubject <- rbind(testsubject,trainsubject)
## Bind columns for create a single dataset
my_df <- cbind(totalsubject,totallabels,totaldata)

## 2. Extracts only the measurements on the mean and standard deviation for each 
##    observation.

## Read the features.txt
features <- read.table(paste(maindir,"/features.txt",sep=""))
## find the features of means and std in features.txt
selection <- grep("mean\\(\\)|std",features$V2)
selectfeat <- features[selection,1]
selectcols <- paste("V",selectfeat,sep="")
extract_df <- select(my_df, c("subject","label",selectcols))

## 3. Uses descriptive activity names to name the activities in the data set

## Read the activity_labels.txt
activitynames <- read.table(paste(maindir,"/activity_labels.txt",sep=""),
                            col.names = c("label", "activity"))
extract_df <- inner_join(extract_df,activitynames)
extract_df <- extract_df[,-2]

## 4. Appropriately labels the data set with descriptive variable names.
featurenames <- features[selection,2]
columnnames <- mutate(tbl_df(selectcols),features=featurenames)
oldcolumns <- names(extract_df)
setnames(extract_df,old = oldcolumns,
         new = c("subject",as.character(columnnames$features) ,"activity"))

## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

tidy_df <- gather(extract_df, typemeasure, measure, -(c("subject", "activity")))
tidy_df <- group_by(tidy_df,subject,activity,typemeasure)
tidy_df$measure <- mean(tidy_df$measure)

write.table(tidy_df,file="tidy_df.txt",row.name=FALSE)