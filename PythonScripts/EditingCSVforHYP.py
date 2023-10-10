#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import os

dfToApmokytiModeliaiHYP = pd.read_csv('/home/simona/SAMPLE/GPU/YoloMokymas/ModelsHYP.csv', delimiter =';')
dfToApmokytiModeliaiHYP = dfToApmokytiModeliaiHYP.drop(dfToApmokytiModeliaiHYP.index[1:])
dfToApmokytiModeliaiHYP.to_csv('/home/simona/SAMPLE/GPU/YoloMokymas/ApmokytiModeliaiHYP.csv', mode='a', header=False, index=False, sep=';')

dfToUpdateModelsHYP = pd.read_csv('/home/simona/SAMPLE/GPU/YoloMokymas/ModelsHYP.csv', delimiter =';')
dfToUpdateModelsHYP = dfToUpdateModelsHYP.drop(dfToUpdateModelsHYP.index[0])
dfToUpdateModelsHYP.to_csv('/home/simona/SAMPLE/GPU/YoloMokymas/ModelsHYP.csv', index=False, sep=';')


