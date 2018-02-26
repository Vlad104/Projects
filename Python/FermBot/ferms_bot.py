from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
import requests, json
#import sys

class Telegram_Bot_Monitor:
    def __init__(self,seria,flist,token,commands):
        self.ser = seria
        self.flist = flist
        self.token = token
        self.commands = commands

    def monitor_data(self,iferm):
        req = 'http://127.0.0.%d:42000/getstat' %(iferm)
        response = requests.get(req)
        answer = json.loads(response.text)
        num = len(answer['result'])
        res = []
        for i in list(range(num)):
            gpuid = answer['result'][i]['gpuid']
            temp = answer['result'][i]['temperature']
            sols = answer['result'][i]['speed_sps']
            res.append(str(gpuid) + ' | Temp = ' + str(temp) + ' | ' + str(sols) + ' Sols/s')
        return res

    def start(self, bot, update):
        txt = 'Для получения информации о ферме введите ее название. Возможные вариации: M1, M01, m1 и m01'
        update.message.reply_text(txt)

    def echo(self, bot, update):
        update.message.reply_text(update.message.text)

    def info(self, bot, update):
        for i in list(range(len(self.flist))):
            if msg in commands[i]:
                print(self.flist)
                update.message.reply_text('Miner %s%d:\n'%(self.ser,self.flist[i]) + '\n'.join(self.monitor_data(self.flist[i])))
                return
        update.message.reply_text('Нет ответа')
        

if __name__ == '__main__':
    #if len(sys.argv) < 3:
    #    print("Мало параметров. Нужно задать серию и номер. Пример: *.py М 1")
    #    sys.exit
    
    #seria = sys.argv[1]
    #miner = int(sys.argv[2])
    seria = 'M'
    token = '544839673:AAEBidGDfZuk3qMtyo8EjY5H7i9pGhBdD6Q'
    commands = []
    flist = [1,3,4,5,6,7,8,11]
    for i in list(flist):
        commands.append(['%s%d'%(seria.upper(),i), '%s%d%d'%(seria.upper(),i//10,i%10),
                       '%s%d'%(seria.lower(),i), '%s%d%d'%(seria.lower(),i//10,i%10)])
        
    tbot = Telegram_Bot_Monitor(seria, flist, token,commands)
    
    updater = Updater(token) # создаём основной объект для управления ботом

    updater.dispatcher.add_handler(CommandHandler('start', tbot.start))
    updater.dispatcher.add_handler(CommandHandler('echo', tbot.echo))
    updater.dispatcher.add_handler(MessageHandler(Filters.text, tbot.info))

    updater.start_polling() # запускаем бота
    updater.idle()




