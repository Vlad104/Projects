import sys
class Ferma:
    def __init__(self,ser,miner):
        self.ser = ser
        self.miner = miner

    def fser(self):
        print(ser)

    def fminer(self):
        print(self.miner)

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Мало параметров. Нужно задать серию и номер. Пример: *.py М 1")
    else:
        ser = sys.argv[1]
        miner = int(sys.argv[2])
    ferm = Ferma(ser,miner)
    ferm.fser()
    #ferm.fminer()
