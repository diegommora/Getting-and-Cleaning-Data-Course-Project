---
title: "README for the run_analysis.R script"
author: "Diego Mora"
date: "4/17/2019"
output: html_document
---

## Reading the data

Download the .Zip file from the provided url and then unzip it

```{r}
## Download the zip folder

wd <- getwd()
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,paste(wd,"/files.zip",sep=""))
unzip("files.zip",exdir = paste(wd,"/files",sep=""))
```

Paths for the important information:

```{r}
maindir <- "./files/UCI HAR Dataset"
testdir <- "./files/UCI HAR Dataset/test"
traindir <- "./files/UCI HAR Dataset/train"
```

As you can see in the README.txt file that is on the .zip, the important info that you need to read is the one of the measures (X_test/train.txt), the subjects ids for each observation (subjects_test/train.txt) and the labels of the activities of each observation (y_test/train.txt)

## 1. Merges the training and the test sets to create one data set.

```{r}
traindata <- read.table(paste(traindir,"/X_train.txt",sep=""))
testdata <- read.table(paste(testdir,"/X_test.txt",sep=""))

trainlabels <- read.table(paste(traindir,"/y_train.txt",sep=""),col.names = "label")
testlabels <- read.table(paste(testdir,"/y_test.txt",sep=""),col.names = "label")

trainsubject <- read.table(paste(traindir,"/subject_train.txt",sep=""),col.names = "subject")
testsubject <- read.table(paste(testdir,"/subject_test.txt",sep=""),col.names = "subject")
```

Then you can Bind this pairs of data and finally construct a unique Dataset

```{r}
totaldata <- rbind(testdata,traindata)
totallabels <- rbind(testlabels,trainlabels)
totalsubject <- rbind(testsubject,trainsubject)
## Bind columns for create a single dataset
my_df <- cbind(totalsubject,totallabels,totaldata)
```
## 2. Extracts only the measurements on the mean and standard deviation for each observation.

Using the information contained in the features.txt file extract the rows of that file that contain the string "mean()" or "std". this rows correspond to the features of mean and standard deviation.

```{r}
## Read the features.txt
features <- read.table(paste(maindir,"/features.txt",sep=""))
## find the features of means and std in features.txt
selection <- grep("mean\\(\\)|std",features$V2)
selectfeat <- features[selection,1]
selectcols <- paste("V",selectfeat,sep="")
extract_df <- select(my_df, c("subject","label",selectcols))
```

## 3. Uses descriptive activity names to name the activities in the data set

With the info contained in the activity_labels.txt file you can join in with the dataset and have a new column with the proper names for each activity instead of the Id. I use the inner_join function of the dplyr package:

```{r}
activitynames <- read.table(paste(maindir,"/activity_labels.txt",sep=""),
                            col.names = c("label", "activity"))
extract_df <- inner_join(extract_df,activitynames)
extract_df <- extract_df[,-2]
```

## 4. Appropriately labels the data set with descriptive variable names.

Then using the row numbers for std and mean, you can match them with the columns of the big dataset an rename them, I use the setnames function of the data.table package:

```{r}
featurenames <- features[selection,2]
columnnames <- mutate(tbl_df(selectcols),features=featurenames)
oldcolumns <- names(extract_df)
setnames(extract_df,old = oldcolumns,
         new = c("subject",as.character(columnnames$features) ,"activity"))
```
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

To create the tidy dataframe I want to use 3 function, first I gather the columns of the features and create a new one "typemeasure" colum with them, in that new column I gather all the other columns except the subjects and activities. Then I group this new data set by the subject and type of measure. Finally I summarize with the means of the measures.

```{r}
tidy_df <- gather(extract_df, typemeasure, measure, -(c("subject", "activity")))
tidy_df <- group_by(tidy_df,subject,typemeasure)
tidy_df <- summarize(tidy_df, mean(measure))
```


----------------------------------------------------------------------------

Report generation information:

 *  Created by DIEGO MORA.

 *  Report creation time: Thu Apr 18 2019
