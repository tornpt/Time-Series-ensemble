
import numpy as np
import matplotlib.pyplot as plt
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor

import pandas as pd

xl = pd.ExcelFile(r"C:\Users\windows\Desktop\Building N Consumption-python.xlsx")
print(xl.sheet_names)
df1 = xl.parse('Sheet1')
print(df1.ConsumptionW)
df2=df1
df1=df1.drop('Time',1)

split=int(df1.ConsumptionW.size*0.8)

x = df1.values[:split]
y = df1.ConsumptionW[:split]
x_test=df1.values[split:] 
y_test=df1.ConsumptionW[split:]
m = np.median(y_test[y_test > 0])

y_test[y_test==0]=m


#---adaboost
adaboostR2 = AdaBoostRegressor(DecisionTreeRegressor(max_depth=6),
                          n_estimators=300, random_state=rng)

adaboostR2.fit(x,y)

pred=adaboostR2.predict(x_test)

plt.figure()
plt.scatter(df2.Time.values[split:], y_test, c="k", label="training samples")
plt.plot(df2.Time.values[split:], pred, c="g", label="n_estimators=300", linewidth=2)
plt.xlabel("time")
plt.ylabel("load")
plt.title("Boosted Decision Tree Regression")
plt.legend()
plt.show()

def mean_absolute_percentage_error(y_true, y_pred): 
    y_true, y_pred = np.array(y_true), np.array(y_pred)
    return np.mean(np.abs((y_true - y_pred) / y_true)) * 100


def sq_mean_absolute_percentage_error(y_true, y_pred): 
    y_true, y_pred = np.array(y_true), np.array(y_pred)
    return  np.mean(np.abs((y_true-y_pred)/(np.abs(y_true)+np.abs(y_pred))))*200

mean_absolute_percentage_error(y_test,pred)

sq_mean_absolute_percentage_error(y_test,pred)


#-----Random Forests --------
from sklearn.ensemble import RandomForestRegressor

rf = RandomForestRegressor(n_estimators = 1000, random_state = 42)

rf.fit(x,y)

pred<-rf.predict(x_test)
mean_absolute_percentage_error(y_test,pred)

from sklearn.metrics import mean_squared_error
from math import sqrt
mse = mean_squared_error(y_test, pred)
rmse = sqrt(mse)
print('RMSE: %f' % rmse)

#----------------------Boosting--------------
from sklearn.ensemble import GradientBoostingRegressor

params = {'n_estimators': 500, 'max_depth': 4, 'min_samples_split': 2,
          'learning_rate': 0.01, 'loss': 'ls'}
clf = GradientBoostingRegressor(**params)

clf.fit(x,y)

pred=clf.predict(x_test)