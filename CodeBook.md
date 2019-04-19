---
title: "CodeBook for Getting and Cleaning Data Course"
author: "Diego Mora"
date: "4/18/2019"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Original Files

Test data:
        X_test.txt: data for the test group
        y_test.txt: labels for the activities
        subject_test.txt: id of the subject

Train data:
        X_train.txt: data for the train group
        y_train.txt: labels for the activities
        subject_train.txt: id of the subject
        
## Original Variables

Each data set have this variables

------------------------------------------------------------------------
File                     Variable                  Description
----------------------- -------------------- ---------------------------
X_test/train.txt          V1:V561             Measures for each feature
                                              for the test group

y_test/train.txt            V1                Id for the activities

subject_test/train.txt      V1                Id for the subjects

------------------------------------------------------------------------

## Transformations

As you can see we have 3 pairs of data (measures, Id's of activities, Id's of subjects).

First transformation is bind this pairs
Second is bind the columns of this 3 data frames

So, finally you get a unique data frame with subjects id's, activities Id's and all the measures of the 563 variables for each observation

#### Then I just extract the subjects, activities and the features for mean and std measures

        - For the "label" variable (that is the Id's of the activities), I rename each observation with the info of activity_labels.txt file
        - For each of the measures varibles names (66 of them after the extraction) I  rename them with the info of features_info.txt
        - Also I lower case all the column names.
        
#### Finally I decided to gather all the info of the features in one column, so the result is a data frame with the subjects, activities, type of measures (features) and the values

        - for this resulting data frame I group it by subject and type of measure
        - Then I create a new tidy data frame that summarize with the mean of each type of measure for each activity and also for each subjet.
        
The result have the followinf dimensions

---------------------------------
Feature                    Result
------------------------ --------
Number of observations      11880

Number of variables             4
---------------------------------

# Tidy Data Set summary table

----------------------------------------------------------------------------
Label   Variable              Class         # unique  Missing  Description  
                                              values                        
------- --------------------- ----------- ---------- --------- -------------
        **[subject]**         integer             30  0.00 %    Id of Sub           

        **[activity]**        factor               6  0.00 %    Activity            

        **[typemeasure]**     character           66  0.00 %    Features            

        **[mean(measure)]**   numeric          11520  0.00 %    Mean             
----------------------------------------------------------------------------

Report generation information:

 *  Created by DIEGO MORA.

 *  Report creation time: Thu Apr 18 2019