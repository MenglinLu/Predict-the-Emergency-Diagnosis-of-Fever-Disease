# -*- coding: utf-8 -*-
"""
Created on Sun Mar 18 03:18:38 2018

@author: lenovo
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm
from sklearn.metrics import roc_curve, auc
from sklearn import cross_validation
import xlrd
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn import neighbors
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LogisticRegression
from sklearn import tree
from sklearn.ensemble import GradientBoostingClassifier

data=xlrd.open_workbook('C:\\Users\\lenovo\\Desktop\\datathon\\data_raw.xlsx')
table1=data.sheets()[0];
table2=data.sheets()[1];
train_data=[]
for i in range(table1.nrows):
    a=table1.row_values(i)
    train_data.append(a)
train_data=np.array(train_data)
train_result=table2.col_values(0)
ddata={'llable':train_result}
frame=pd.DataFrame(ddata)
frame=frame.drop_duplicates(['llable'])
train_result=np.array(train_result)
lw=2
random_state=np.random.RandomState(0)
plt.figure(figsize=(10,10))
plt.plot([0,1], [0,1], color='navy', lw=lw, linestyle='--')
roc_auc=0;
P1=0;
R1=0;
F1=0;

for inn in range(1):

    x_train,x_test,y_train,y_test=cross_validation.train_test_split(train_data,train_result,test_size=0.2,random_state=0)

    clf2=svm.SVC(kernel='linear', probability=True, random_state=random_state);

    clf1=RandomForestClassifier(n_estimators=250).fit(x_train,y_train);

    clf3=neighbors.KNeighborsClassifier().fit(x_train,y_train);

    clf4=MultinomialNB(alpha=0.01).fit(x_train,y_train);
    
    clf5=LogisticRegression(penalty='l2').fit(x_train,y_train)
    
    clf6=tree.DecisionTreeClassifier().fit(x_train,y_train)
    
    clf7=GradientBoostingClassifier(n_estimators=200).fit(x_train,y_train)

    y_score1=[];
    y_score3=[];
    y_score4=[];
    y_score5=[];
    y_score6=[];
    y_score7=[];
#
    predict_prob_y1=clf1.predict_proba(x_test)
    predict_prob_y3=clf3.predict_proba(x_test)
    predict_prob_y4=clf4.predict_proba(x_test)
    predict_prob_y5=clf5.predict_proba(x_test)
    predict_prob_y6=clf6.predict_proba(x_test)
    predict_prob_y7=clf7.predict_proba(x_test)

    for i in range(len(predict_prob_y1)):
        y_score1.append(predict_prob_y1[i][1]);
    for i in range(len(predict_prob_y3)):
        y_score3.append(predict_prob_y3[i][1]);
    for i in range(len(predict_prob_y4)):
        y_score4.append(predict_prob_y4[i][1]);
    for i in range(len(predict_prob_y5)):
        y_score5.append(predict_prob_y5[i][1]);
    for i in range(len(predict_prob_y6)):
        y_score6.append(predict_prob_y6[i][1]);
    for i in range(len(predict_prob_y7)):
        y_score7.append(predict_prob_y7[i][1]);

        
        
    y_score2=clf2.fit(x_train,y_train).decision_function(x_test)
    fpr1,tpr1,threshold1=roc_curve(y_test,y_score1)
    fpr2,tpr2,threshold2=roc_curve(y_test,y_score2)
    fpr3,tpr3,threshold3=roc_curve(y_test,y_score3)
    fpr4,tpr4,threshold4=roc_curve(y_test,y_score4)
    fpr5,tpr5,threshold5=roc_curve(y_test,y_score5)
    fpr6,tpr6,threshold6=roc_curve(y_test,y_score6)
    fpr7,tpr7,threshold7=roc_curve(y_test,y_score7)

#    roc_auc=roc_auc+auc(fpr,tpr);
    plt.plot(fpr1,tpr1,color='red', lw=2,label='Random Forest')
    plt.plot(fpr2,tpr2,color='green', lw=2, label='SVM')
    plt.plot(fpr3,tpr3,color='yellow', lw=2, label='KNN')
    plt.plot(fpr4,tpr4,color='darkorange', lw=2, label='Naive Bayes')
    plt.plot(fpr5,tpr5,color='blue', lw=2, label='LogisticRegression')
    plt.plot(fpr6,tpr6,color='purple', lw=2, label='DecisionTree')
    plt.plot(fpr7,tpr7,color='pink', lw=2, label='GradientBoosting')
    
    
    
#    y_pre=clf.predict(x_test)
#
#    y_true = y_test;
#
#    tp1=0.0;
#    tp2=0.0;
#    fp1=0.0;
#    fp2=0.0;
#    tn1=0.0;
#    tn2=0.0;
#    fn1=0.0;
#    fn2=0.0;
#    for i in range(len(y_true)):
#        tp1=tp1+(y_true[i]==0.0)*(y_pre[i]==0.0);
#        fp1=fp1+(y_pre[i]==0.0)*(y_true[i]!=0.0);
#        tn1=tn1+(y_pre[i]!=0.0)*(y_true[i]!=0.0);
#        fn1=fn1+(y_pre[i]!=0.0)*(y_true[i]==0.0);
#        tp2=tp2+(y_true[i]==1.0)*(y_pre[i]==1.0);
#        fp2=fp2+(y_pre[i]==1.0)*(y_true[i]!=1.0);
#        tn2=tn2+(y_pre[i]!=1.0)*(y_true[i]!=1.0);
#        fn2=fn2+(y_pre[i]!=1.0)*(y_true[i]==1.0);
#    pre1=tp1/(tp1+fp1)
#    rcc1=tp1/(tp1+fn1)
#    f11=2*pre1*rcc1/(pre1+rcc1)
#    pre2=tp2/(tp2+fp2)
#    rcc2=tp2/(tp2+fn2)
#    f12=2*pre2*rcc2/(pre2+rcc2)
#
#    P1=P1+(pre1+pre2)/2;
#    R1=R1+(rcc1+rcc2)/2;
#    F1=F1+(f11+f12)/2;
roc_auc=roc_auc/1;
#P1=P1/10;
#R1=R1/10;
#F1=F1/10;
plt.xlim([0.0,1.0])
plt.ylim([0.0,1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver operating characteristic example')
plt.legend(loc="lower right")
plt.show()