**This file describes how to use the R script run_analysis.R**

#Setup
*Set your R working directory point to the directory of the script
*Download an unzip the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to the same directory as the script. You should have folder named "UCI HAR Dataset" (and subfolders) in your working directory
#Use
The script can be sourced without any parameters.
#Inner workings
The script will read in relevant data, format it into a tidy dataframe and output a table with averages of desired measurements aggregated by each subject and activity.
#Output
A table is output as text file ('tidytable.txt'). The file can be read in R  by following command:
*tidytable<-read.table(file = 'tidytable.txt')*

#Codebook
There's a codebook called *codebook.md* for this data set.