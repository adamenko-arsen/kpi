if __name__ == '__main__':
    print(f'File {__file__} can be used only as a library')
    exit(1)

from random import uniform, randint
from typing import List, Dict

class Entity:
    def __init__(self, *, gens=[]):
        self.gens = gens

    @property
    def Gens(self: List[int]):
        return self.gens

    @property
    def GensCount(self) -> int:
        return len(self.gens)

    def Copy(self) -> 'Entity':
        return Entity(gens = self.gens[:])

    def __repr__(self):
        return self._to_string()

    def __str__(self):
        return self._to_string()

    def _to_string(self):
        return ''.join('_#'[gen] for gen in self.gens)

    def _gens_count(self) -> int:
        return len(self.gens)
