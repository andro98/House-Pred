#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 14 23:13:45 2021

@author: andrew
"""

import pandas as pd
import numpy as np


dataset = pd.read_csv('data.csv')
dataset.drop(columns=['date', 'street', 'city', 'statezip', 'country', 'view', 
                      'waterfront', 'condition', 'yr_renovated', 'sqft_lot', 'sqft_above',
                      'sqft_basement', 'yr_built', 'floors'], inplace=True)
dataset = dataset.astype({"bathrooms": int, "bedrooms": int})
dataset = dataset[dataset.price > 300000]

dataset.head()


X = dataset.iloc[:, 1:].values
y = dataset.iloc[:, 0].values

# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.33, random_state = 42)

# Training the Multiple Linear Regression model on the Training set
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(X_train, y_train)

# Predicting the Test set results
y_pred = regressor.predict(X_test)
np.set_printoptions(precision=2)
print(np.concatenate((y_pred.reshape(len(y_pred),1), y_test.reshape(len(y_test),1)),1))

from sklearn import metrics
print('Mean Absolute Error:', metrics.mean_absolute_error(y_test, y_pred))
print('Mean Squared Error:', metrics.mean_squared_error(y_test, y_pred))
print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(y_test, y_pred)))


import coremltools
from sklearn.utils import shuffle
from sklearn.feature_extraction import DictVectorizer
from sklearn.tree import DecisionTreeClassifier
from sklearn.pipeline import Pipeline

coreml_model = coremltools.converters.sklearn.convert(regressor, ["bedrooms", "bathrooms", "sqft_living"], "price")
coreml_model.author = 'Andrew Maher'
coreml_model.license = 'Unknown'
coreml_model.short_description = 'House Price Predictor'
#coreml_model.input_description['input'] = 'Bedrooms Int, Bathrooms Int, Sqft Living Float'
#coreml_model.output_description['output'] = 'House Price'
coreml_model.save('HousePredictor.mlmodel')