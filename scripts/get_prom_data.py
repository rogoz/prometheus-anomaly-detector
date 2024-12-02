#!/usr/bin/env python3

import requests
import copy
import pandas as pd


def prometheus_to_pandas(prom_URL, prom_query, resample_interval):
    r = requests.get(prom_URL, params={'query': prom_query})
    data = r.json()
    metric_list = []
    for i in data['data']['result']:
        for j in i['values']:
            data_dict = copy.deepcopy(i['metric'])
            data_dict['ds'] = j[0]
            data_dict['y'] = j[1]
            metric_list.append(data_dict)

    df_metric = pd.DataFrame(metric_list)
    df1 = df_metric[['ds', 'y']]
    df1['ds'] = pd.to_datetime(df1['ds'], unit='s').dt.floor('S')
    #df1 = df1.set_index('ds')
    df1["y"] = df1["y"].values.astype(float)
    #print(df1)
    df1 = df1.set_index('ds')
    df1 = df1.resample(resample_interval).mean()
    df1 = df1.reset_index()
    return df1
