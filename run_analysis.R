
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#MAXROWS<-10 #used for creating a smaller set during debugging/building the script
MAXROWS<-10000 #enough for this dataset

#bind both measurement sets to one dataframe
DF<-rbind(read.table("UCI HAR Dataset/train/X_train.txt",stringsAsFactors = FALSE,header = F,nrows=MAXROWS)
          ,read.table("UCI HAR Dataset/test/X_test.txt",stringsAsFactors = FALSE,header = F,nrows=MAXROWS))
#read column names
names<-read.table("UCI HAR Dataset/features.txt",as.is = T)[,2]

#get only the columns needed
#mean() are the columns wanted, for example '...meanFreq()' gets now filtered out
means=grep("mean()",fixed=T,names)
stds<-grep("std",names)
neededCols<-sort(c(means,stds))
#change the names
colnames(DF)<-names
#finally drop unneeded columsn
DF<-DF[,neededCols]

#clean up the resulting column names
colnames(DF)<-gsub("()","",colnames(DF),fixed = T)
colnames(DF)<-gsub("-","",colnames(DF),fixed = T)
colnames(DF)<-gsub("mean","Mean",colnames(DF),fixed = T)
colnames(DF)<-gsub("std","Std",colnames(DF),fixed = T)
colnames(DF)<-gsub("Acc","Acceleration",colnames(DF),fixed = T)
colnames(DF)<-gsub("Mag","Magnitude",colnames(DF),fixed = T)
colnames(DF)<-gsub("Gyro","Gyroscope",colnames(DF),fixed = T)
#add "Mean of to the names, so it's there for the final tidy table
colnames(DF)<-sub("^t","MeanOfTimeDomain",colnames(DF))
colnames(DF)<-sub("^f","MeanOfFrequencyDomain",colnames(DF))

#read activity names and recorded activities
activities=read.table("UCI HAR Dataset/activity_labels.txt")
act_train=read.table("UCI HAR Dataset/train/y_train.txt",stringsAsFactors = F,header = F,nrows=MAXROWS)
act_test=read.table("UCI HAR Dataset/test/y_test.txt",stringsAsFactors = F,header = F,nrows=MAXROWS)
#combine the train and test dbs
bact=rbind(act_train,act_test)
#map values in DF to strings, add as first column to DF
DF<-cbind(activities[bact[,],2],DF)
colnames(DF)[1]="Activity"

#read the subject data
sub_train=read.table("UCI HAR Dataset/train/subject_train.txt",stringsAsFactors = F,header = F,nrows=MAXROWS)
sub_test=read.table("UCI HAR Dataset/test/subject_test.txt",stringsAsFactors = F,header = F,nrows=MAXROWS)
#combine the train and test dbs
bsub=rbind(sub_train,sub_test)

#add subject column to DF
DF<-cbind(bsub,DF)
colnames(DF)[1]="SubjectNumber"

#calculate means by each subject and activity to output tidy data
DFTidy<-aggregate(.~SubjectNumber+Activity,data=DF,mean)


#output 
write.table(DFTidy,file = "tidytable.txt")
