import random
import math
import matplotlib.pyplot as plt
#-------------------------RANSAC Parameter------------------------
threshold = 3
N = 10
m = 2
#-------------------------Model Parameter------------------------
# model = ax+by+c (linear function)
a = 0
b = -1
c = 0

def getMin(list):
    min =list[0]
    for i in range(len(list)):
        if min > list[i]:
            min = list[i]
    return min

def getMax(list):
    max =list[0]
    for i in range(len(list)):
        if max < list[i]:
            max = list[i]
    return max

def getRandomSample(set, data_size):
    # print('--------------getSample Read--------------------------')
    while len(set) != m:
        ran = random.randint(0,data_size-1)
        set.add(ran)

def getModel(x,y,sample):
    global a
    global c
    if x[sample[1]]-x[sample[0]] ==0:
        return True
    a = (float)(y[sample[1]]-y[sample[0]]) / (float)(x[sample[1]]-x[sample[0]])
    c = -a*x[sample[0]] +y[sample[0]]
 
    return False


def getInlier(model_a, model_b, model_c, x, y):
    num=0
    for i in range(len(x)):
        dist = abs(model_a * x[i] + model_b * y[i] + model_c) / math.sqrt(model_a*model_a + model_b * model_b)
        if dist < threshold:
            num = num+1
    return num

re_a, re_b, re_c = 0,0,0
def RANSAC(x,y):
    global re_a, re_b, re_c
    re_a, re_b, re_c, max = 0,0,0,0
    if len(x) == 0:
        return 0,0,0,0

    for i in range(N):
        sample = set([])
        getRandomSample(sample,len(x))
        isZero = getModel(x, y, list(sample))
        if isZero:
            max=max
        else:
            num = getInlier(a, b, c, x, y)
            if num > max:
                max=num
                re_a=a
                re_b=b
                re_c=c
    return re_a, re_b, re_c, max