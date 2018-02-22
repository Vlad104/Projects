import requests, json

req = 'http://127.0.0.1:42000/getstat'
response = requests.get(req)
answer = json.loads(response.text)
num = len(answer['result'])
name = []
temp = []
sols = []
for i in list(range(num)):
    name.append(answer['result'][i]['name'])
    temp.append(answer['result'][i]['temperature'])
    sols.append(answer['result'][i]['speed_sps'])
    print(name[i] + '_' + str(i) + ' | Temp = ' + str(temp[i]) + ' |  ' + str(sols[i]) + ' Sols/s')

