require(readr)

Xtrain <- read_table(file = "UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
ytrain <- read_table(file = "UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
subject_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt", sep = "", stringsAsFactors = FALSE)

Xtest <- read_table(file = "UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
ytest <- read_table(file = "UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "", stringsAsFactors = FALSE)

merged <- rbind(cbind(ytrain, subject_train, Xtrain), cbind(ytest, subject_test, Xtest))
rm(Xtrain, ytrain, subject_train, Xtest, ytest, subject_test)


require(stringr)
features <- read_delim(file = "UCI HAR Dataset/features.txt", col_names = FALSE, delim = ' ')
names(merged) <- c("activity", "subject", features$X2)



mean_std_features <- c(TRUE, TRUE, str_detect(string = features$X2, pattern = "mean\\(\\)|std\\(\\)"))
df <- subset(x = merged, select = mean_std_features)
rm(merged)


activities <- read_delim(file = "UCI HAR Dataset/activity_labels.txt", col_names = FALSE, delim = ' ')
df$activity <- factor(x = df$activity, levels = 1:6, labels = activities$X2)


require(dplyr)
tidy <- df %>% group_by(activity, subject) %>% summarise_each(funs(mean))


write.table(x = tidy, file = "tidyDataSet.txt", row.names = FALSE)
