library(spotifyr)
library(tidyverse)
library(knitr)
library(class)
library(caret)
library(MASS)
library(caTools)

urlfile<-'https://raw.githubusercontent.com/Muhammadzaryab22/Artistrecommender/main/mldataframest.csv'
mldataframest<-read.csv(urlfile)

urlfile2 <- 'https://raw.githubusercontent.com/Muhammadzaryab22/Artistrecommender/main/datalabel.csv'
data_label_target <- read.csv(urlfile2)
data_label_target <- as.factor(data_label_target$data_label_target)

urlfile3 <- "https://raw.githubusercontent.com/Muhammadzaryab22/Artistrecommender/main/mldataframe.csv"
mldataframe <- read.csv(urlfile3)


## Splitting data
set.seed(123)
split <- sample.split(mldataframest, SplitRatio= 0.80)
train <- subset(mldataframest, split== 'TRUE') %>% dplyr::select(keymode, tempo, popularitymean)
test <- subset(mldataframest, split== 'FALSE') %>% na.omit() %>% dplyr::select(keymode, tempo, popularitymean) %>% na.omit()


## Creating separate df for target variable
set.seed(123)
train_label <- mldataframe[split,] %>% dplyr::select(key_mode, tempo, popularitymean)
test_label <- subset(mldataframe, split=='FALSE') %>% dplyr::select(key_mode, tempo, popularitymean)

set.seed(123)
train_label_target <- mldataframe[split, 1]
test_label_target <- mldataframe[!split, 1]

data_label_target <- as.factor(mldataframe[,1])

## finding number of obs to set K value
NROW(train)


### The function shows that the most accuracy was obtained with K=1 with 57.20% accuracy.

## Now lets create again the confusion matrix using k=1
set.seed(123)
knnn1 <- knn(train = mldataframest, test = test, cl= data_label_target, k=1)
ACC.1 <- 100 * sum(test_label_target == knnn1)/NROW(test_label_target)
ACC.1

confusionMatrix(table(knnn1, test_label_target))
