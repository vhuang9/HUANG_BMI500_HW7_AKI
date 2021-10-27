import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.preprocessing import MinMaxScaler
from sklearn import metrics
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE

df = pd.read_csv('patient_aki.csv')   # read in csv table with all queried/extracted features
df = df.dropna()             # drop all na values
df

X = df[['RRT','uo_rt_12hr','uo_rt_24hr','uo_rt_6hr','creat']]     # select which features to include in the clustering model
ytrue = df['aki_stage']                # ground truth staging values

kmeans = KMeans(n_clusters=3,init='k-means++',random_state=20)    # initiate kmeans clustering with 3 classes
kmeans.fit(X)                          # fit the model

ypred = kmeans.predict(X)              # predict values given the trained model

# return all of the classification metrics
print(metrics.accuracy_score(ytrue, ypred))
print(metrics.precision_score(ytrue, ypred,average='weighted'))
print(metrics.recall_score(ytrue, ypred,average='weighted'))

tsne = TSNE()                          # instantiate tSNE plotting
X_embedded = tsne.fit_transform(X)     # fit transform for dimensionality reduction to plot the higher dimensional clustering data

import seaborn as sns                  # plot data
sns.scatterplot(X_embedded[:,0],X_embedded[:,1],hue=ytrue,legend='full',palette='bright')