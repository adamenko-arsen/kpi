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

    def Mutate(self, chance: float) -> Dict:
        if uniform(0, 1) < chance:
            index = randint(0, self._gens_count() - 1)
            gens = self.gens

            gens[index] = 1 - gens[index]

            return {'is_mut': True}

        return {'is_mut': False}

    def GetMutated(self, chance: float) -> tuple[bool, 'Entity']:
        if uniform(0, 1) < chance:
            index = randint(0, self._gens_count() - 1)

            new_gens = gens = self.gens[:]
            new_gens[index] = 1 - new_gens[index]

            return {'is_mut': True, 'entity': Entity(gens = new_gens)}

        return {'is_mut': False, 'entity': Entity(gens = self.gens[:])}

    def __repr__(self):
        return self._to_string()

    def __str__(self):
        return self._to_string()

    def _to_string(self):
        return ''.join('_#'[gen] for gen in self.gens)

    def _gens_count(self) -> int:
        return len(self.gens)
