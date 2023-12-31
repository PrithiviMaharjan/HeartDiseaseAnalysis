###### start of the code ###### 

#disabling warnings
options(warn=-1)
#options(warn=0)

# installing libraries
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("repr")
#install.packages("caTools")
#install.packages("caret")
#install.packages("pROC")
#install.packages("plotROC")
#install.packages("corrplot")
#install.packages("cowplot")
#install.packages("glmnet")
#install.packages("magrittr")
#install.packages("readr")
#install.packages("tidyverse")
#install.packages("GGally")
#install.packages("skimr")
#install.packages("rattle")
#install.packages("gridExtra")
#install.packages("grid")
#install.packages("doParallel")
#install.packages("igraph")
#install.packages("e1071")



# including libraries
library(ggplot2)
library(dplyr)
library(repr)
library(caTools)
library(caret)
library(pROC)
library(plotROC)
library(corrplot)
library(cowplot)
library(glmnet)
library(magrittr)
library(readr)
library(tidyverse)
library(GGally)
library(skimr)
library(rattle)
library(gridExtra)
library(grid)
library(doParallel)
library(igraph)
library(e1071)

# reading heart data
hd_df <- read.csv("heart.csv", row.names("in"), sep=",",header=TRUE)
head(hd_df)

# checking missing values
head(is.na(hd_df))
sum(is.na(hd_df))

#shuffling the original data
shuff_df <- hd_df[sample(nrow(hd_df)),]
head(shuff_df)

#checking dimensions
dim(hd_df)
str(hd_df)

# No. of rows
nrow(hd_df)

# No. of columns
ncol(hd_df)

# Names of the Columns
names(hd_df)

# Copy the data collection into a new data frame for multiple observation cloning
nd_df <- cbind(hd_df)
cd_df <- cbind(hd_df)
svmD_df <- cbind(hd_df)
head(nd_df)
head(cd_df)
head(svmD_df)

## Renaming variables
hd_df$sex_var = as.factor(ifelse(hd_df$sex == 1, 'Male', 'Female'))

hd_df$cp_var = as.factor(ifelse(hd_df$cp == 1,'1-Typical Angina',
                                         ifelse(hd_df$cp == 2,'2-Atypical Angina',
                                                ifelse(hd_df$cp == 3,'3-Non-Anginal','0-Asymptomatic'))))

hd_df$fbs_var = as.factor(ifelse(hd_df$fbs==1,'Festing blood sugar over 120mg/dl','Festing blood sugar under 120mg/dl'))

hd_df$restecg_var = as.factor(ifelse(hd_df$restecg == 0, 'Normal',
                                              ifelse(hd_df$restecg == 1,'Having St-t wave abnormality','Showing probable 
                                                     or definite left ventricular hypertrophy by Estes criteria')))

hd_df$exang_var = as.factor(ifelse(hd_df$exang == 1,'Have exercise induced agina','No exercise induced agina'))

hd_df$slop_var = as.factor(ifelse(hd_df$slope == 1,'Unsloping',
                                           ifelse(hd_df$slope == 2,'Flat','Downsloping')))

hd_df$thal_var = as.factor(hd_df$thal)

hd_df$target_var = as.factor(ifelse(hd_df$target == 1, 'Heart Disease Caused', 'Not Caused Disease'))

nd_df$target = as.factor(ifelse(nd_df$target == 1, 'Yes', 'No'))

head(nd_df,5)

View(nd_df)

summary(nd_df)

colnames(hd_df)


##### Hypothesis Testing ######

# Age and dependent variable goal co-relation
cor(hd_df$age,hd_df$target)
# Chi square test
chisq.test(hd_df$age,hd_df$target)

# Sex and dependent variable goal co-relation
cor(as.numeric(hd_df$sex),hd_df$target)
# Chi square test
chisq.test(hd_df$sex,hd_df$target)
 
# Co-relationship between chest pain and variable aim based
cor(hd_df$cp,hd_df$target)
# Chi square test
chisq.test(hd_df$cp,hd_df$target)

# Co-relationship between resting blood pressure and targeted variable dependent
cor(hd_df$trestbps,hd_df$target)
# Chi square test
chisq.test(hd_df$trestbps,hd_df$target)

# Cholesterol and dependent variable goal co-relation
cor(hd_df$chol,hd_df$target)
# Chi square test
chisq.test(hd_df$chol,hd_df$target)

# Fasting Blood Sugar and dependent variable targeted co-relation
cor(hd_df$fbs,hd_df$target)
# Chi square test
chisq.test(hd_df$fbs,hd_df$target)

# Resting electrocardiographic calculation co-relationship with dependent variable aim
cor(hd_df$restecg,hd_df$target)
# Chi square test
chisq.test(hd_df$restecg,hd_df$target)

# Maximum heart rate and dependent variable targeted co-relation
cor(hd_df$thalach,hd_df$target)
# Chi square test
chisq.test(hd_df$thalach,hd_df$target)

# Exercise-induced angina and dependent variable targeted co-relationship
cor(hd_df$exang,hd_df$target)
# Chi square test
chisq.test(hd_df$exang,hd_df$target)

# ST depression and dependent variable targeted co-relation
cor(hd_df$oldpeak,hd_df$target)
# Chi square test
chisq.test(hd_df$oldpeak,hd_df$target)

# Co-relation between the peak exercise slope and the dependent variable goal variable
cor(hd_df$slope,hd_df$target)
# Chi square test
chisq.test(hd_df$slope,hd_df$target)

# Co-relation between the number of large vessels and the indicator targeted dependent variable
cor(hd_df$ca,hd_df$target)
# Chi square test
chisq.test(hd_df$ca,hd_df$target)

# Thalassemia and dependent variable targeted co-relation
cor(hd_df$thal,hd_df$target)
#Chi square test
chisq.test(hd_df$thal,hd_df$target)

# Overall review of data fields
summary(hd_df)



# Setting the Height of the Graph 
options(repr.plot.width=5, repr.plot.height=3)

# Analysis caused by Heart Disease
round(table(hd_df$target))

pie(table(hd_df$target),
    labels=(paste(c("Not Caused Disease","Caused Heat Disease ")," ",
                  round(table(hd_df$target)/sum(table(hd_df$target))*100),"%",sep=" ")),
    main="Percentage of Heat Disease")

# Analyzing Age
summary(hd_df$age)

# Age Boxplot
boxplot(hd_df$age,horizontal=TRUE,col="red",main="Boxplot of Age")

sd(hd_df$age)

# Variance Age Review
var(hd_df$age)

# Co-relationship between age and intended dependent variable
cor(hd_df$age,hd_df$target)

# Chi square test to see how age and destination co-relate
chisq.test(hd_df$age,hd_df$target)

# Age Histogram
hist(hd_df$age,labels=TRUE,main="Histogram of Age",
     xlab="Age",ylab="Frequency",col="red")

# Age Boxplot
boxplot(hd_df$age,horizontal=TRUE,col="red",main="Boxplot of Age")

# Scatter graph with flat age-to-target curve
ggplot(hd_df,aes(x=age,y=target))+geom_point()+geom_smooth(color="yellow") +
  scale_x_continuous(name="Age")+scale_y_continuous(name="Target") +
  ggtitle("Scatter plot between age and target")

# Study of sex
ggplot(hd_df) + geom_bar(aes(x = hd_df$sex_var,fill=as.factor(hd_df$sex_var)))+ xlab("Sex")+ylab("Count")+labs(fill="Index")

# Piechart Sex Plot
pie(table(hd_df$sex),labels=(paste(c("Female","Male")," ",
                            round(table(hd_df$sex)/sum(table(hd_df$sex))*100),
                            "%",sep=" ")),
                            main="Percentage of Sex")

# Gender Vs Target's Barplot
ggplot(hd_df) + 
  geom_bar(aes(x = hd_df$sex_var,fill=as.factor(hd_df$sex_var)))+
  xlab("Sex")+ylab("Count")+labs(fill="Index") +
  facet_grid(cols=vars(hd_df$target_var))

# Scatter and Smooth with Sex Group between age and goal
ggplot(hd_df,aes(x=age,y=target))+geom_point(aes(shape=sex_var,color=sex_var))+
  geom_smooth()+scale_x_continuous(name="Age")+
  scale_y_continuous(name="Target: Heart Attack Probability")+
  ggtitle("Scatter and Smooth Between Age and Target with Sex Category")

# Chest Diagnosis of Pain
ggplot(hd_df) +
  geom_bar(aes(x = hd_df$cp_var,fill=as.factor(hd_df$cp_var)))+
  xlab("Sex")+ylab("Count")+labs(fill="Index")

# Age and goal scatter plot for Chest Pain group
ggplot(hd_df,aes(x=age,y=target))+
  geom_point(aes(shape=cp_var,color=cp_var))+geom_smooth()+
  scale_x_continuous(name="Age")+
  scale_y_continuous(name="Probability of Heart Attack")+
  ggtitle("Age and target with Chest Pain category")


##### Cholestrol Analysis #####
summary(hd_df$chol)

boxplot(hd_df$chol~as.factor(hd_df$sex_var),
        col=rainbow(2),main="Cholesterol Descriptive Study of Sex",
        xlab="Sex",ylab="Cholesterol")

hist(hd_df$chol, 
     main="Cholesterol Histogram",
     xlab="Cholesterol",ylab="Frequency", col=rainbow(7),labels=TRUE)

hd_df$sex=as.factor(hd_df$sex)

ggplot(hd_df,aes(x=chol,y=target))+
  geom_point(aes(shape=sex_var,color=sex_var))+
  geom_smooth()+
  ggtitle("Smooth curve between Cholesterol and Sex Factor Destination")+
  scale_x_continuous(name="Cholesterol Level")+ 
  scale_y_continuous(name="Target")

#### Rest Blood Pressure Analysis ####
summary(hd_df$trestbps)

cor(hd_df$trestbps,hd_df$age)

boxplot(hd_df$trestbps,
        col="pink",
        main="RBP Descriptive Research",
        horizontal=TRUE)

hist(hd_df$trestbps,col=rainbow(7),
     main="RBP histogram",
     xlab="Rest Blood Pressure Class",
     ylab="Frequency",
     labels=TRUE)

ggplot(hd_df,aes(x=trestbps,y=target))+
  geom_point(shape=6)+geom_smooth()+
  scale_x_continuous(name="Rest Blood Pressure")+
  scale_y_continuous(name="Target")+
  ggtitle("Smooth curve between Target and RBP")


#### Maximum Heart Rate ####
summary(hd_df$thalach)

boxplot(hd_df$thalach~as.factor(hd_df$sex_var),
        main="Boxplot of Thalac with Category of Sex",
        xlab="Sex",
        ylab="Maximum Heart Rate",
        col=rainbow(2))

# Chi square test to see if age is associated with heart rate
chisq.test(hd_df$age,hd_df$thalach)

# How age affects the heart rate
cor(hd_df$age,hd_df$thalach)

ggplot(hd_df,aes(x=age,y=thalach))+geom_point()+geom_smooth()+
    scale_x_continuous(name="Age")+
    scale_y_continuous(name="Achieved optimum heart rate")+
    ggtitle("Age and Heart Rate Relationship")

ggplot(hd_df,aes(x=thalach,y=target))+geom_point()+geom_smooth()+
  scale_x_continuous(name="Maximum Heart Rate Achieved")+
  scale_y_continuous(name="Prob. of Heart Attack")+
  ggtitle("Heart rate and Heart attack Relationship")



#### Visualizing the data ####
# Sex vs Cholestrol #
ggplot(hd_df)+
  geom_bar(stat="identity",aes(x=as.factor(hd_df$sex_var),
                               y=hd_df$chol, fill=hd_df$sex_var))+
  xlab("Sex")+ylab("cholestrol")+theme(legend.position = "none")

# According to Sex Age Vs Cholestrol #
ggplot(hd_df)+
  geom_bar(stat="identity",aes(x=hd_df$age,
  y=hd_df$chol,fill=as.factor(hd_df$sex_var)))+
  xlab("Age")+ylab("Cholestrol")+labs(fill="Color Coding")

# Age Vs Highest acquired heart rate #
ggplot(hd_df)+
  geom_bar(stat="identity",aes(y=hd_df$thalach,x=hd_df$age))+
  xlab("Age")+ylab("Maximum heart rate avhieved")

# Acquired optimum heart rate versus age by gender. #
ggplot(hd_df)+
  geom_bar(stat="identity",aes(y=hd_df$thalach,x=hd_df$age,
  fill=as.factor(hd_df$sex_var)))+
  xlab("Age")+ylab("Maximum heart rate avhieved")+
  theme(legend.position = "none")+
  facet_grid(cols=vars(hd_df$sex_var))

# Blood sugar fasting Versus Chest pain #
ggplot(hd_df)+
  geom_bar(stat="identity",aes(y=hd_df$fbs,x=hd_df$cp_var))+
  xlab("Chest Pain")+ylab("Fasting Blood Sugar")

# Anigma caused by Age vs Exercise #
ggplot(hd_df)+
  geom_bar(stat="identity",aes(x=hd_df$age,y=hd_df$exang))+
  ylab("Exercise induced anigma")+xlab("Age")

ggplot(hd_df)+
  geom_bar(stat="identity",aes(y=hd_df$exang,
  x=hd_df$age,fill=as.factor(hd_df$exang_var)))+
  xlab("Age")+ylab("Maximum heart rate avhieved")+
  theme(legend.position = "none")+
  facet_grid(cols=vars(hd_df$exang_var))

# Chest pain with age #
ggplot(hd_df)+
  geom_bar(stat="identity",aes(y=hd_df$cp,x=hd_df$age))+
  xlab("Age")+ylab("Chest Pain")

# Age-gendered chest pain wise. #
ggplot(hd_df)+
  geom_bar(stat="identity",aes(y=hd_df$cp,
  x=hd_df$age,fill=as.factor(hd_df$sex_var)))+
  xlab("Age")+ylab("Chest pain")+
  theme(legend.position = "none")+
  facet_grid(cols=vars(hd_df$sex_var))


##### Logistic Regression Model #####
## Data Preparation ##
# Data splitting of teaching and research sets
set.seed(123)
sample=sample.split(nd_df$target,SplitRatio=0.80)
train_set=subset(nd_df,sample==TRUE)
test_set=subset(nd_df,sample==FALSE)

## Logistic Regression Model ##
model=glm(target~.,train_set,family=binomial())
summary(model)

## Re-verifying Model ##
newModel=glm(target~sex+cp+thalach+oldpeak+ca,train_set,family=binomial())
summary(newModel)

## Prediction ##
# Predict the target with the data-sets of tests
pred=predict(newModel,test_set,type="response")
predNew=as.data.frame(pred)
categorise=function(x){
  return(ifelse(x>0.5,1,0))
}
predNew=apply(predNew,2,categorise)
head(predNew,10)

## Model Evaluation¶ ##
levels(test_set$target) <- list("0" = "No", "1" = "Yes")
str(test_set)
confusionMatrix(as.factor(test_set$target),as.factor(predNew))

## Training and Evaluating Models ##
# optimization #
nd_df$target = as.factor(ifelse(nd_df$target == 1, 'Yes', 'No'))

y<-c('target')
set.seed(121)
trainIndx <- createDataPartition(nd_df$target,p=.7, list=FALSE)
train     <- nd_df[trainIndx,]
trainX    <- model.matrix(as.formula(paste0(y," ~.")), train)[,-1]
trainY    <- nd_df[trainIndx,y]
valid     <- nd_df[-trainIndx,]
validX    <- model.matrix(as.formula(paste0(y," ~.")), valid)[,-1]
validY    <- nd_df[-trainIndx,y]

ftControl <- trainControl(method = "repeatedcv",
                          number = 10,
                          classProbs = TRUE,
                          summaryFunction = twoClassSummary,
                          allowParallel = TRUE)


#### Classification - Decision trees ####
cd_df$sex = as.factor(ifelse(cd_df$sex == 1, 'Male', 'Female'))

cd_df$cp = as.factor(ifelse(cd_df$cp == 1,'1-Typical angina',
                                     ifelse(cd_df$cp == 2,'2-Atypical angina',
                                            ifelse(cd_df$cp == 3,'3-Non-anginal','0-Asymptomatic'))))

cd_df$fbs = as.factor(ifelse(cd_df$fbs==1,'Festing blood sugar over 120mg/dl','Festing blood sugar under 120mg/dl'))

cd_df$restecg = as.factor(ifelse(cd_df$restecg == 0, 'Normal',
                                          ifelse(cd_df$restecg == 1,'Having St-t wave abnormality','Showing probable or definite left ventricular hypertrophy by Estes criteria')))

cd_df$exang = as.factor(ifelse(cd_df$exang == 1,'Have exercise induced agina','No exercise induced agina'))

cd_df$slop = as.factor(ifelse(cd_df$slope == 1,'Unsloping',
                                       ifelse(cd_df$slope == 2,'Flat','Downsloping')))

cd_df$thal = as.factor(cd_df$thal)

cd_df$target = as.factor(ifelse(cd_df$target == 1, 'Heart Disease Caused', 'Not Caused Disease'))

# Data splitting of teaching and research sets
set.seed(123)
sample=sample.split(cd_df$target,SplitRatio=0.80)
newTrain_set=subset(cd_df,sample==TRUE)
newTest_set=subset(cd_df,sample==FALSE)

set.seed(1, sample.kind="Rounding") 
fit_rpart<- train(target~ sex+cp+fbs+restecg+exang, data = newTrain_set, 
                  method = "rpart",preProcess = c("center", "scale"),
                  trControl = trainControl(method="cv", number = 10, p = 0.8),
                  tuneGrid = data.frame(cp = seq(0,0.1,0.01)))

#### Re-setting the broader plot scale for view clustering
options(repr.plot.width=5, repr.plot.height=3)
fancyRpartPlot(fit_rpart$finalModel)


##### SVM(Support Vector Machine) #####
# Splitting the details into the train set and the test set
svmD_df$target = as.factor(ifelse(svmD_df$target == 1, 'Yes', 'No'))
set.seed(127) 
split = sample.split(svmD_df$target, SplitRatio = 0.80)
trainNew = subset(svmD_df, split == TRUE)
testNew = subset(svmD_df, split == FALSE)
# Fitting SVM to the Training set
x <- subset(testNew, select=-target)
y <- testNew$target
svm_model<-svm(target ~ ., data = trainNew , method = "class")
summary(svm_model)
pred <- predict(svm_model,x)
pred

testNew$target_predict <- predict(svm_model,newdata=testNew,type="class")
table(testNew$target_predict)
table(pred,y)

svm_tune <- tune(svm, train.x=x, train.y=y, 
                 kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))

## Creating Confusion Matrix
cm = table(testNew$target,testNew$target_predict)
confusionMatrix(cm)

# Anova Test
# one way
annova_res <-aov(trestbps~chol, data = nd_df)
summary(annova_res)
boxplot(nd_df$trestbps~nd_df$chol,xlab = "cholesterol", ylab = "bps")

#two way
par(mfrow = c(1,2))
boxplot(nd_df$trestbps~nd_df$chol,subset = (nd_df$sex == 1),xlab =
          "cholesterol", ylab = "trestbps")
boxplot(nd_df$trestbps~nd_df$chol,subset = (nd_df$sex == 0),xlab =
          "cholesterol", ylab = "trestbps")
annova_twoway <- aov(trestbps~chol*oldpeak, data = nd_df)
summary(annova_twoway)
###### end of the code ###### 

