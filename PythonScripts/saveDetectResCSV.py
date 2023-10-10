#!/usr/bin/env python
# coding: utf-8

import csv
import sys

sumPositive = int(sys.argv[2])+int(sys.argv[3])+int(sys.argv[4])
data= [sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], str(sumPositive)]

with open('/home/simona/SAMPLE/GPU/YoloMokymas/detectResults.csv', 'a') as file:
    writer = csv.writer(file, delimiter = ';')
    writer.writerow(data)

