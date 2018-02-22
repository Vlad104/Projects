from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
import requests, json

ser = 'M'
miner = 1;
command_list = ['%s%d'%(ser,miner), '%s%d%d'%(ser,miner//10,miner%10),
                '%s%d'%(ser,miner), '%s%d%d'%(ser,miner//10,miner%10),
                '%s%d'%(ser,miner), '%s%d%d'%(ser,miner//10,miner%10)]

req = 'http://127.0.0.%d:42000/getstat' %(miner)
delay = 10

def monitor():    
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
        res.append(str(gpuid[i]) + ' | Temp = ' + str(temp[i]) + ' |  ' + str(sols[i]) + ' Sols/s')
    return res

telegram_token = '544839673:AAEBidGDfZuk3qMtyo8EjY5H7i9pGhBdD6Q'
 
def start(bot, update):
    txt = 'Комманды для %s%:\n' %(ser,miner)
    txt += '/help - вызов списка команд:\n'
    txt += '\n'.join(command_list)
    update.message.reply_text(txt)

def help(bot, update):
    txt = 'Комманды для %s%:\n' %(ser,miner)
    txt += '\n'.join(command_list)
    update.message.reply_text(txt)

def echo(bot, update):
    msg = update.message.text
    if msg in command_list:
        update.message.reply_text('Miner %s%d:\n'%(ser,miner) + '\n'.join(monitor()))
    else:
        update.message.reply_text('Эхо: ' + msg)
        

# создаём основной объект для управления ботом
updater = Updater(telegram_token)

updater.dispatcher.add_handler(CommandHandler('start', start))
updater.dispatcher.add_handler(CommandHandler('help', start))
updater.dispatcher.add_handler(MessageHandler(Filters.text, echo))

# запускаем бота
updater.start_polling()
updater.idle()




