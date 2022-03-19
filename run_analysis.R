# 1. Merge the training and the test sets to create one data set.
require(readr)

Xtrain <- read_table(file = "UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
ytrain <- read_table(file = "UCI HAR Dataset/train/y_train.txt", col_names = FALSE)

subject_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt", sep = "", stringsAsFactors = FALSE)
#subjectstrain <- read_delim("UCI HAR Dataset/train/subject_train.txt", col_names = FALSE, delim = '')
Xtest <- read_table(file = "UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
ytest <- read_table(file = "UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
# fixed limits don't work with subject_train files (it only reads the first character)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "", stringsAsFactors = FALSE)

merged <- rbind(cbind(ytrain, subject_train, Xtrain), cbind(ytest, subject_test, Xtest))
rm(Xtrain, ytrain, subject_train, Xtest, ytest, subject_test)

# 4. Appropriately label the data set with descriptive variable names.
require(stringr)
features <- read_delim(file = "UCI HAR Dataset/features.txt", col_names = FALSE, delim = ' ')
names(merged) <- c("activity", "subject", features$X2)
# there are duplicated features names...
# names(merged)[duplicated(names(merged))]

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
# in order to escape parenthesis in the regexp requires double backslash:
mean_std_features <- c(TRUE, TRUE, str_detect(string = features$X2, pattern = "mean\\(\\)|std\\(\\)"))
df <- subset(x = merged, select = mean_std_features)
rm(merged)

# 3. Use descriptive activity names to name the activities in the data set.
activities <- read_delim(file = "UCI HAR Dataset/activity_labels.txt", col_names = FALSE, delim = ' ')
df$activity <- factor(x = df$activity, levels = 1:6, labels = activities$X2)

# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
require(dplyr)
tidy <- df %>% group_by(activity, subject) %>% summarise_each(funs(mean))

# Save data set as a txt file created with write.table() using row.name=FALSE (do not cut and paste a dataset directly into the text box, as this may cause errors saving your submission)
write.table(x = tidy, file = "tidyDataSet.txt", row.names = FALSE)
