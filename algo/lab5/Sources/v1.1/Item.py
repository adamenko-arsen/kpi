if __name__ == '__main__':
    print(f'File {__file__} can be used only as a library')
    exit(1)

class Item:
    def __init__(self, *, weight: int, value: int):
        self.weight = weight
        self.value = value

    @property
    def Weight(self) -> int:
        return self.weight

    @property
    def Value(self) -> int:
        return self.value

    @property
    def Efficiency(self) -> float:
        return self.value / self.weight
