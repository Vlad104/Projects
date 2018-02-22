from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
import requests, json
import sys

class Telegram_Bot_Monitor:
    def __init__(self,seria,miner,token,commands):
        self.ser = seria
        self.miner = miner
        self.token = token

        self.req = 'http://127.0.0.%d:42000/getstat' %(self.miner)
        self.commands = commands

    def monitor_data(self):    
        response = requests.get(req)
        answer = json.loads(response.text)
        num = len(answer['result'])
        gpuid = []
        temp = []
        sols = []
        res = []
        for i in list(range(num)):
            gpuid.append(answer['result'][i]['gpuid'])
            temp.append(answer['result'][i]['temperature'])
            sols.append(answer['result'][i]['speed_sps'])
            res.append(str(gpuid[i]) + ' | Temp = ' + str(temp[i]) + ' | ' + str(sols[i]) + ' Sols/s')
        return res

    def start(self, bot, update):
        txt = 'Комманды для %s%:\n' %(ser,miner)
        txt += '/help - вызов списка команд:\n'
        txt += '\n'.join(commands)
        update.message.reply_text(txt)

    def help(self, bot, update):
        txt = 'Комманды для %s%:\n' %(ser,miner)
        txt += '\n'.join(commands)
        update.message.reply_text(txt)

    def echo(self, bot, update):
        msg = update.message.text
        if msg in commands:
            update.message.reply_text('Miner %s%d:\n'%(self.ser,self.miner) + '\n'.join(self.monitor_data(self)))
        else:
            update.message.reply_text('Эхо: ' + msg)
        

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Мало параметров. Нужно задать серию и номер. Пример: *.py М 1")
        sys.exit
    
    seria = sys.argv[1]
    miner = int(sys.argv[2])
    token = '544839673:AAEBidGDfZuk3qMtyo8EjY5H7i9pGhBdD6Q'
    
    commands = ['%s%d'%(seria.upper(),miner), '%s%d%d'%(seria.upper(),miner//10,miner%10),
                    '%s%d'%(seria.lower(),miner), '%s%d%d'%(seria.lower(),miner//10,miner%10)]

    tbot = Telegram_Bot_Monitor(seria, miner, token, commands)
    
    updater = Updater(token) # создаём основной объект для управления ботом

    updater.dispatcher.add_handler(CommandHandler('start', tbot.start))
    updater.dispatcher.add_handler(CommandHandler('help', tbot.start))
    updater.dispatcher.add_handler(MessageHandler(Filters.text, tbot.echo))

    updater.start_polling() # запускаем бота
    updater.idle()




