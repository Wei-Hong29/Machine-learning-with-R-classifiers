
rm(list = ls())


#setwd('C:/Users/User/Downloads/proj1')

library(tree)
library(e1071)
library(adabag)
library(randomForest)
library(ROCR)
library(neuralnet)

options(digits = 4)
DS <- read.csv("Defects.csv")




#NOTE: not everything in this R script is shown in the report

################       1.Data exploration     ######################


#calculate ratui of of defect-prone to not-defect-prone 
numberofdefects = DS[(DS$defects == TRUE),]
numberofnondefects = DS[(DS$defects == FALSE),]

ratioofdefectstonondefects = nrow(numberofdefects) / nrow(numberofnondefects)
ratioofdefectstonondefects

#see summary of dataset
summary(DS)

#use unique to see what value defect column may take
unique(DS$defects)


#use unique to see all unique data for each columns, to see if theres any ingisht to gain
#use head to see first few row, to see if theres any notable patterns
apply(DS,2,unique)


head(DS)

x<-DS$loc
y<-DS$lOCode + DS$lOBlank
t.test(x,y)
#found that [DS$loc == DS$lOCode + DS$IOBlank], so will be excluding DS$loc since its redundant to include it in our analysis


################       2.Pre-processing      ######################
#we are making a pre-processed dataset that does not include [DS$loc] for use in our analysis
DSpreprocessed = DS[,2:22]

#encode defects column as factor for analysis
DSpreprocessed$defects = as.factor(DSpreprocessed$defects)

################       Question 3      ######################
#separate into training and test dataset
set.seed(28055322) #random seed
train.row = sample(1:nrow(DSpreprocessed), 0.7*nrow(DSpreprocessed))
iris.train = DSpreprocessed[train.row,]
iris.test = DSpreprocessed[-train.row,]





################       4. and 5. Making and training classifiers, followed by testing    ######################



#build tree with traning data, with defect as target, and others as predictors
#and calculate its accuracy
dtreefit <- tree(defects ~. ,data = iris.train)
treepredict <- predict(dtreefit, iris.test, type = "class")

v <- table(observed = iris.test$defects , predicted = treepredict)
v
accuracy <- (v[1] + v[4])/(sum(v))
accuracy

#unused:
#cvdtreefit <- cv.tree(dtreefit, FUN = prune.misclass)
#cvtreepredict <- predict(cvdtreefit, iris.test, type = "class")
#table(observed = iris.test$defects , predicted = treepredict)








#build Naive Bayes classifier, and calculate accuracy
dbayesfit <- naiveBayes(defects ~. ,data = iris.train)
bayespredict <- predict(dbayesfit, iris.test)

v <- table(observed = iris.test$defects , predicted = bayespredict)
v
accuracy <- (v[1] + v[4])/(sum(v))
accuracy







#build classifier via bagging, and calculate accuracy
dbagfit <- bagging(defects ~. ,data = iris.train, mfinal = 10)
bagpredict <- predict.bagging(dbagfit, newdata = iris.test)

v <- table(observed = iris.test$defects , predicted = bagpredict$class)
v
accuracy <- (v[1] + v[4])/(sum(v))
accuracy






#build classifier via boosting, and calculate accuracy
dboostfit <- boosting(defects ~. ,data = iris.train, mfinal = 100)
boostpredict <- predict.boosting(dboostfit, newdata = iris.test)

v <- table(observed = iris.test$defects , predicted = boostpredict$class)
v
accuracy <- (v[1] + v[4])/(sum(v))
accuracy






#build random forest classifier, and calculate accuracy
drandomforestfit <- randomForest(defects ~. ,data = iris.train)
randomforestpredict <- predict(drandomforestfit, newdata = iris.test)

v <- table(observed = iris.test$defects , predicted = randomforestpredict)
v
accuracy <- (v[1] + v[4])/(sum(v))
accuracy


















################       6. Assessing classifier performance      ######################

#get confidence level for all classfiers
conf.tree.predict <- predict(dtreefit, iris.test)
conf.bayes.predict <- predict(dbayesfit, iris.test, type = "raw")
conf.bag.predict<- bagpredict$prob
conf.boosting.predict<- boostpredict$prob
conf.randomforest.predict <- predict(drandomforestfit, iris.test, type = "prob")



#plot ROCR for all classifier
prediction.tree <- prediction(conf.tree.predict[,2], iris.test$defects)
perf.tree <- performance(prediction.tree, "tpr", "fpr")
plot(perf.tree,col = "blue")


prediction.bayes <- prediction(conf.bayes.predict[,2], iris.test$defects)
perf.bayes <- performance(prediction.bayes, "tpr", "fpr")
plot(perf.bayes,add = TRUE, col = "green")



prediction.bag <- prediction(conf.bag.predict[,2], iris.test$defects)
perf.bag <- performance(prediction.bag, "tpr", "fpr")
plot(perf.bag,add = TRUE, col = "red")



prediction.boosting <- prediction(conf.boosting.predict[,2], iris.test$defects)
perf.boosting <- performance(prediction.boosting, "tpr", "fpr")
plot(perf.boosting,add = TRUE, col = "purple")



prediction.forest <- prediction(conf.randomforest.predict[,2], iris.test$defects)
perf.forest <- performance(prediction.forest, "tpr", "fpr")
plot(perf.forest,add = TRUE, col = "black")


#calculate AUC and print
auctree <- performance(prediction.forest,"auc")
print(as.numeric(auctree@y.values))

aucbayes <- performance(prediction.bayes,"auc")
print(as.numeric(aucbayes@y.values))

aucbag <- performance(prediction.bag,"auc")
print(as.numeric(aucbag@y.values))

aucboosting <- performance(prediction.boosting,"auc")
print(as.numeric(aucboosting@y.values))

aucforest <- performance(prediction.forest,"auc")
print(as.numeric(aucforest@y.values))

















################       7. Classifier performance assessment      ######################

#for question 7, please refer the pdf report for the table, and the answer to the question





################       8.Determining most important variables      ######################

#get root node, which gives the most imformation gain, which is the most important for a tree classifier
dtreefit


#print summary and importance data, to determine most important variables for each classifier
summary(dtreefit)
dbagfit$importance
dboostfit$importance
drandomforestfit$importance











#save random seed
x<- .Random.seed




################       9. Modified tree with only important variables, and its performance       ######################




set.seed(x)



#make a decision tree, with omitted variables
new.treefit <- tree(defects ~ lOCodeAndComment + l + lOComment + lOCode + uniq_Op + i + n + v + lOBlank + uniq_Opnd + branchCount, data = iris.train)
new.treepredict <- predict(new.treefit, iris.test,type = "class")


#calculate accuracy and print

v <- table(observed = iris.test$defects , predicted = new.treepredict)
v
accuracy <- (v[1] + v[4])/(sum(v))
accuracy

#plot ROCR 
new.conf.tree.predict <- predict(new.treefit, iris.test)
new.prediction.tree <- prediction(new.conf.tree.predict[,2], iris.test$defects)
new.perf.tree <- performance(new.prediction.tree, "tpr", "fpr")
plot(new.perf.tree,col = "blue", main = "Decision tree with omitted variables")

#calculate AUC and print
new.auctree <- performance(new.prediction.tree,"auc")
print(as.numeric(new.auctree@y.values))




y <- .Random.seed







################       10. Neural network classifier and its performance      ######################
set.seed(y)

#make indicators for neutralnet
iris.test$thedefects <- iris.test$defects == TRUE
iris.test$thenondefects <- iris.test$defects == FALSE
iris.train$thedefects <- iris.train$defects == TRUE
iris.train$thenondefects <- iris.train$defects == FALSE

#make neural network classifier, and check accuracy, using 3 most important variables from each classifier in question 8
nnfit = neuralnet(thedefects + thenondefects~ lOComment + l +lOCodeAndComment + i + lOBlank + uniq_Opnd, iris.train , hidden=2, threshold = 0.01)

#does not need the target attribute for predicting
nnpredict <- compute(nnfit, iris.test[,1:20])
round.nnpredict <- round(nnpredict$net.result,0)

df.round.nnpredict <- as.data.frame(as.table(round.nnpredict))

s.df.round.nnpredict <-df.round.nnpredict[!df.round.nnpredict$Freq==0,]
s.df.round.nnpredict$FREQ = NULL
colnames(s.df.round.nnpredict) = c("Obs", "defects")
s.df.round.nnpredict = s.df.round.nnpredict[order(s.df.round.nnpredict$Obs),]
#calculate accuracy and print

v <- table(observed = iris.test$thedefects , predicted = s.df.round.nnpredict$defects)
v
accuracy <- (v[2] + v[3])/(sum(v))
accuracy







################       Summary can be found in the report      ######################
