if __name__ == '__main__':
    print(f'File {__file__} can be used only as a library')
    exit(1)

import matplotlib.pyplot as plt

# TODO
class Drawer:
    def __init__(self):
        pass

    def SetBestValues(self, best_values: list[int]):
        self.best_values = best_values

    def Draw(self):
        plt.plot(
            range(len(self.best_values)),
            self.best_values,
            label = 'Цінність рішення',
            color = 'black',
            linewidth = 2
        )
        plt.grid(which = 'major', color = '#777')

        plt.grid(which = 'minor', color = '#aaa')
        plt.minorticks_on()

        plt.legend()
        plt.show()
