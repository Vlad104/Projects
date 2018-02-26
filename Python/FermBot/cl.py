commands = []
seria = 'M'
for i in list(range(10)):
    commands.append(['%s%d'%(seria.upper(),i), '%s%d%d'%(seria.upper(),i//10,i%10),
                    '%s%d'%(seria.lower(),i), '%s%d%d'%(seria.lower(),i//10,i%10)])
