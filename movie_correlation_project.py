#!/usr/bin/env python
# coding: utf-8

# In[45]:


import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib 
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjust the configuration of the plots we willcreate


# In[46]:


# read the data
df = pd.read_csv(r'/Users/derya_ak/Downloads/movies.csv', engine='python')


# In[47]:


# look at the data

df.head()


# In[48]:


# is there any missing data in dataframe

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[50]:


# data types of our columns

df.dtypes


# In[53]:


# change data type of columns

df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')


# In[84]:


df.head()


# In[55]:


# create correct year column

df['yearcorrect'] = df['released'].astype(str).str[0:4]


# In[85]:


df.head()


# In[61]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[62]:


pd.set_option('display.max_rows',None)


# In[ ]:


# budget high correlation
#company high correlation


# In[64]:


# scatter plot with budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('budget vs gross earnings')
plt.xlabel('gross earnings')
plt.ylabel('budget of film')

plt.show()


# In[67]:


# plot budget vs gross using seaborn

sns.regplot(x='budget', y='gross', data=df,scatter_kws={'color': 'green'}, line_kws={'color' : 'blue'})


# In[69]:


# let's start looking ar correlation

df.corr(method='pearson') # pearson,kendall, spearman


# In[ ]:


#high correlation between budget and gross


# In[72]:


correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot = True)

plt.title('correlation matrix for numeric features')
plt.xlabel('movie features')
plt.ylabel('movie features')

plt.show()


# In[86]:


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized.head()


# In[74]:


correlation_matrix = df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot = True)

plt.title('correlation matrix for numeric features')
plt.xlabel('movie features')
plt.ylabel('movie features')

plt.show()


# In[75]:


df_numerized.corr()


# In[76]:


correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[77]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[83]:


high_correlation = sorted_pairs[((sorted_pairs) > 0.5) & ((sorted_pairs) < 0.99)]

high_correlation


# In[ ]:


# votes and budget have the highest correlation to groo earnings

# company has low correlation

