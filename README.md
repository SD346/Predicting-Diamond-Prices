# **Predicting Diamond Prices**

## [**Business Problem** ](#business-problem)

## [**Dataset** ](#-dataset)

- [Structure of Dataset ](#structure-of-dataset)

- [Dummy Variables ](#dummy-variables)

- [Missing Values ](#missing-values)

- [Normalization ](#normalization)
## [**EDA** ](#eda)
- [Package ](#package)
## [**Model Building** ](#model-building)

- [Splitting ](#splitting)

- [Vanilla Model (Model – 1) ](#vanilla-model-model-–-1)

- [Model -2 ](#model--2)

- [VIF/AV Plots ](#vifav-plots)

- [Model - 3](#model---3)

- [Model Deletion Diagnostics ](#model-deletion-diagnostics)

- [Model – 4 ](#model-–-4)

- [Model - 5 ](#-model---5)

- [Step AIC ](#step-aic)

- [Model - 6 ](#model---6)

## [**Predictions** ](#predictions)
- [RMSE ](#rmse)

## **Business Problem**

Dataset consists of **53,940 observations** and **27 variables** of various diamonds.

Our task is to predict the price of a diamond by using Multivariate Regression Technique.

## **Dataset**
---

### Structure of Dataset
---

The dataset has 3 categorical features (**Cut Quality**, **Diamond color** and **Clarity**)

### Dummy Variables
---

In order to perform Multiple Linear regression, we needed to convert these variables into dummy variables and then add those dummy variables in the dataset excluding the categorical features.

### Missing Values
---

We then check for **Missing values** but there is **none**.

### Normalization
---

Data is then normalized and then prepared for further analysis.

## **EDA**
---

EDA is done and is presented in a different report.

### Package
---

We have used dlookr package from R for the EDA part which provides us with the correlation and the information about normality between the features.

## **Model Building**
---

After the pre-processing and EDA, we proceed for Model building

### Splitting
---

Initially the data is splitted into Train (80%) and Test (20%).

Model that we are going to use is **Multiple Linear Regression** as the target variable is continuous and there are multiple input variables.

### Vanilla Model (Model – 1)
---

We build the initial model and get R2 value as 0.9194 which indicates that the model is very good and most of the features are significant except y,z and clarity WS1

![](RackMultipart20220831-1-rtclc8_html_ea1736c828e3454d.png)

### Model -2
---

Removing those variables and building the 2nd model we get the same R2 value as 0.9194

All the features are significant

### VIF/AV Plots
---

Now we check for the VIF and find that there is a collinearity issue within features.

![](RackMultipart20220831-1-rtclc8_html_cbb84013e223a9fa.png)

After doing analysis with VIF and AV Plots, we find that X has highest VIF value and can be deleted.

### Model - 3
---

Building the model after this provided R2 value as 0.9158

### Model Deletion Diagnostics
---

Since the R2 value has decreased, we decide to retain the features and try dropping influential observations from the model

![](RackMultipart20220831-1-rtclc8_html_ee88a80b97da3a50.png)

![](RackMultipart20220831-1-rtclc8_html_5add8e37697ad370.png)

We have identified 3 influential observations - 24068, 27631 and 27416 based on Cook Distance and Hat Values.

Since the observation is from Test data which is obtained after splitting the original dataset, hence we remove a range of observations from 15000 to 25000 and thus we have removed these observations.

### Model – 4
---

We build a new model and now obtained R2 as 0.9194

![](RackMultipart20220831-1-rtclc8_html_7ff4dbde26f97e1c.png)

We can see that the influential observations are deleted but there are some insignificant features also so removing those features and making the final model

### Model - 5
---

The final model has a R2 value of 0.9158

### Step AIC
---

Now we run a stepAIC function to check the Akaike Information Criterion of a particular model.

The lower the AIC value, the better is the model.

![](RackMultipart20220831-1-rtclc8_html_151606597ab676be.png)

![](RackMultipart20220831-1-rtclc8_html_904eb4034503bf00.png)

We find that the final model without cutPremium feature is the better model as it is an insignificant feature.

### Model - 6
---

Building the improved model

The R2 value is 0.9158

## **Predictions**
---

We perform the predictions on the test data and then calculate the RMSE of the model.

### RMSE
---

RMSE value is 0.0623

                                    **--- End of Report ---**