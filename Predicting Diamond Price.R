diamonds <- read.csv(choose.files())
View(diamonds)
str(diamonds)

diamonds <- diamonds[,-1] ##Removing the S.No. from the dataset
View(diamonds)
str(diamonds)
summary(diamonds)
attach(diamonds)

##To check missing values and find the percentage and sum of missing values
sum(is.na(diamonds))
mean(is.na(diamonds))

##No Missing values

##To check the correlation among the features of the dataset
pairs(diamonds)

### Scatter plot matrix along with Correlation Coefficients
panel.cor<-function(x,y,digits=2,prefix="",cex.cor)
{
  usr<- par("usr"); on.exit(par(usr))
  par(usr=c(0,1,0,1))
  r=(cor(x,y))
  txt<- format(c(r,0.123456789),digits=digits)[1]
  txt<- paste(prefix,txt,sep="")
  if(missing(cex.cor)) cex<-0.4/strwidth(txt)
  text(0.5,0.5,txt,cex=cex)
}

pairs(diamonds,upper.panel = panel.cor,main="Scatter plot matrix with Correlation coefficients")


install.packages("dummies")
library(dummies)

##Creating dummy variables and dropping the categorical features and binding the dummy variables with the dataset

a <-dummy(cut)
b <-dummy(color)
c <-dummy(clarity)

diamonds_fixed <- cbind(diamonds,a,b,c)
diamonds_combined <- diamonds_fixed[,-(2:4)]

##Normalizing the data  
normalize<-function(x){
  return ( (x-min(x))/(max(x)-min(x)))
}
diamonds_norm<-as.data.frame(lapply(diamonds_combined,FUN=normalize))

attach(diamonds_norm)

install.packages("dlookr")
install.packages("caret")
library(dlookr)
library(caret)

#Using the dlookr package and finding out the relation between the features
describe(diamonds_norm)
tibble1 <- describe(diamonds_norm)
tibble1

##Checking the features if they are following normal distribution using Shapiro-Wilk normality test
normality(diamonds_norm)
tibble2 <- normality(diamonds_norm)
tibble2

##Finding out the correlation between the features
correlate(diamonds_norm)
tibble3 <-correlate(diamonds_norm)
plot_correlate(diamonds_norm)
## We find out that there is a strong positive correlation between Carat and Diamond Price which indicates that 
## higher the carat value, higher is the diamond price

#Preparing the EDA report
eda_report(diamonds_norm, price, output_format = "html", output_file = "EDA.html")

##Building the model using Multiple Linear Regression as the target variable is continuous and there are multiple input variables.

library(car)


#Splitting the data into 80% traindata and 20% testdata
part <- sample(nrow(diamonds_norm),nrow(diamonds_norm)*0.8,replace = FALSE)
train <- diamonds_norm[part,]
test <- diamonds_norm[-part,]

#Building model with traindata
set.seed(123) ##this function is used to get consistent results or to get better reproducibility

mymodel<-lm(price~.,data = train)
summary(mymodel)

##R-squared value is 0.9194 which indicates that the model is very good and most of the features are significant except y,z and clarityWS1

##Let's check the model again by dropping these variables.

mymodel1<-lm(price~carat+depth+table+x+cutFair+cutGood+cutIdeal+cutPremium+
              colorD+colorE+colorF+colorG+colorH+colorI+clarityI1+clarityIF+
              claritySI1+claritySI2+clarityVS1+clarityVS2, data = train)

summary(mymodel1)

##R-squared value is 0.9194

plot(mymodel1)
residualPlots(mymodel1)

vif(mymodel1) ## VIF function indicates whether there is a collinearity with the target variable and the feature
## If VIF is greater than 20 we can that the regression equation is having multiple collinearity issue
##To resolve we need to remove the features having high collinear values

## Added Variable plot to check correlation b/n variables and o/p variable
avPlots(mymodel1,id.n=2,id.cex=0.7)

#We find that the feature X has highest VIF value and can be deleted
mymodel2 <- lm(price~carat+depth+table+cutFair+cutGood+cutIdeal+cutPremium+
                 colorD+colorE+colorF+colorG+colorH+colorI+clarityI1+clarityIF+
                 claritySI1+claritySI2+clarityVS1+clarityVS2, data = train)

summary(mymodel2)

##R-squared value is 0.9158

# It is Better to delete influential observations rather than deleting entire column
# Deletion Diagnostics for identifying influential observations
set.seed(123)
influence.measures(mymodel)
library(car)
## plotting Influential measures 
windows()
influenceIndexPlot(mymodel,id.n=3) # index plots for infuence measures
influencePlot(mymodel,id.n=3) # A user friendly representation of the above

##According to the plots we find that the Cook Distance and hat values are the highest for observation 24068, 27631 and 27416

# Regression after deleting the influential observations
newmodel<-lm(price~.,data = train[-c(15000:25000),]) ##Removing a range of observations to delete the influential observations
summary(newmodel)

##R-squared value is 0.9194

influenceIndexPlot(newmodel,id.n=3)
influencePlot(newmodel,id.n=3)

##We can see that the influential observations are deleted but there are some insignificant features also. 
## Removing those features and making the final model

finalmodel <- lm(price~carat+depth+table+cutFair+cutGood+cutIdeal+cutPremium+
                 colorD+colorE+colorF+colorG+colorH+colorI+clarityI1+clarityIF+
                 claritySI1+claritySI2+clarityVS1+clarityVS2, data = train[-c(15000:25000),])

summary(finalmodel)

##R-squared value is 0.9158

library(MASS)
stepAIC(finalmodel) ##Implementing the AIC function to check for the lowest AIC values
## We find that the final model without cutPremium is the better model as it is an insignificant feature.
## Hence building the improved model

improvedmodel <- lm(price~carat+depth+table+cutFair+cutGood+cutIdeal+
                   colorD+colorE+colorF+colorG+colorH+colorI+clarityI1+clarityIF+
                   claritySI1+claritySI2+clarityVS1+clarityVS2, data = train[-c(15000:25000),])

summary(improvedmodel)

##R-squared value is 0.9158

##Predicting on test data
predictions <- predict(improvedmodel, test)

library(ModelMetrics)

##Calculating RMSE
rmse(test$price, predictions)
##RMSE value is 0.0623
