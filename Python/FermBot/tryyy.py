import pandas as pd

filename = 'C:\\Users\\user\\Desktop\\OpenHardwareMonitor\\OpenHardwareMonitorLog-2018-02-21.csv'

data = pd.read_csv(filename)

data_col = data['/intelcpu/0/temperature/0']
temp = data_col[len(data_col)-1]

print(temp)
