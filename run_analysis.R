# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Read feature names without the first column
features <- read.table('./data/UCI HAR Dataset/features.txt',colClasses = c("NULL","character"))

# Read required training and testing datasets
X_train <- read.table('./data/UCI HAR Dataset/train/X_train.txt', col.names=features$V2)
Y_train <- read.table('./data/UCI HAR Dataset/train/y_train.txt', col.names='Label')
subject_train <- read.table('./data/UCI HAR Dataset/train/subject_train.txt', col.names='Subject')
X_test <- read.table('./data/UCI HAR Dataset/test/X_test.txt', col.names=features$V2)
Y_test <- read.table('./data/UCI HAR Dataset/test/y_test.txt', col.names='Label')
subject_test <- read.table('./data/UCI HAR Dataset/test/subject_test.txt', col.names='Subject')

# Use cbind to merge columns of X, Y, and subject labels for both train and test
train <- cbind(X_train, Y_train, subject_train)
test <- cbind(X_test, Y_test, subject_test)

# Merges the training and the test sets to create one data set.
# Use rbind to merge training and testing sets together
MergedData <- rbind(train, test)

# Give activities their descriptive labels
# Appropriately labels the data set with descriptive variable names.
MergedData$Activity[MergedData$Label == 1] = 'WALKING'
MergedData$Activity[MergedData$Label == 2] = 'WALKING_UPSTAIRS'
MergedData$Activity[MergedData$Label == 3] = 'WALKING_DOWNSTAIRS'
MergedData$Activity[MergedData$Label == 4] = 'SITTING'
MergedData$Activity[MergedData$Label == 5] = 'STANDING'
MergedData$Activity[MergedData$Label == 6] = 'LYING'

# Extracts only the measurements on the mean and standard deviation for each measurement.
# extract required columns (means and std. devs.) along with the subject and activity labels
SubjActivityData <- cbind( MergedData[ , grep('mean()', names(MergedData)) ],
                  MergedData[ , grep('std()', names(MergedData)) ],
                  'Subject'=MergedData$Subject,
                  'Activity'=MergedData$Activity)


# Create data frame that stores only the means of each variable by subject
# and activity
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Tidy Data Group by subject and activity
TidyData <-SubjActivityData %>%
  group_by(Subject, Activity) %>%
  summarise(across(.cols = everything(), .fns =  mean))

# Write the summary table to a .txt file
write.table(TidyData, file = './data/TidyData.txt', row.names=FALSE)
