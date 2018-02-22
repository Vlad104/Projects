import sys
class Ferma:
    def __init__(self):
        print('1')

    def ff(self):
        print('2')

if __name__ == '__main__':
    print('3')
    ferm = Ferma()
    print('4')
    ferm.ff()
    for param in sys.argv:
        print (param)
    a = input()
