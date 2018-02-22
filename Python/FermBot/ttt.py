from threading import Timer

ser = 'M'
miner = 1;
command_list = ['%s%d'%(ser,miner), '%s%d%d'%(ser,miner//10,miner%10),
                '%s%d'%(ser,miner), '%s%d%d'%(ser,miner//10,miner%10),
                '%s%d'%(ser,miner), '%s%d%d'%(ser,miner//10,miner%10)]
delay
def tt():
    print(command_list)
    Timer(delay, tt).start()
    
Timer(delay, tt).start()
