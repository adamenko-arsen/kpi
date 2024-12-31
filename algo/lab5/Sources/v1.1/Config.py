if __name__ == '__main__':
    print(f'File {__file__} can be used only as a library')
    exit(1)

import Item
import Entity
import Evolutor

from random import randint, choice, uniform
from typing import Dict

PHI = (1 + 5**0.5) / 2

def MutatorA(self, chance: float) -> Dict:
    if uniform(0, 1) < chance:
        index = randint(0, self._gens_count() - 1)
        gens = self.gens

        gens[index] = 1 - gens[index]

        return {'is_mut': True}

    return {'is_mut': False}

def MutatorB(self, chance: float) -> Dict:
    if uniform(0, 1) < chance:
        index_1 = randint(0, self._gens_count() - 1)
        index_2 = randint(0, self._gens_count() - 1)

        gens = self.gens

        gens[index_1], gens[index_2] = gens[index_2], gens[index_1]

        return {'is_mut': True}

    return {'is_mut': False}

def MutatorC(self, chance: float) -> Dict:
    if uniform(0, 1) < chance:
        index_1 = randint(0, self._gens_count() - 1)
        index_2 = randint(0, self._gens_count() - 1)

        gens = self.gens

        gens[index_1], gens[index_2] = 1 - gens[index_2], 1 - gens[index_1]

        return {'is_mut': True}

    return {'is_mut': False}

def CrossoverA(parent_a: Entity.Entity, parent_b: Entity.Entity) -> list[Entity.Entity]:
    separate_point = parent_a.GensCount // 2

    parent_a_fp_gens  = parent_a.Gens[:separate_point]
    parent_a_sp_gens  = parent_a.Gens[separate_point:]

    parent_b_fp_gens = parent_b.Gens[:separate_point]
    parent_b_sp_gens = parent_b.Gens[separate_point:]

    childs = []

    childs += [Entity.Entity(gens = parent_a_fp_gens + parent_b_sp_gens)]
    childs += [Entity.Entity(gens = parent_a_sp_gens + parent_b_fp_gens)]

    return childs

def CrossoverB(parent_a: Entity.Entity, parent_b: Entity.Entity) -> list[Entity.Entity]:
    gens_count = parent_a.GensCount

    separate_point = int(gens_count / PHI)

    if uniform(0, 1) < 0.5:
        separate_point = gens_count - separate_point

    parent_a_fp_gens  = parent_a.Gens[:separate_point]
    parent_a_sp_gens  = parent_a.Gens[separate_point:]

    parent_b_fp_gens = parent_b.Gens[:separate_point]
    parent_b_sp_gens = parent_b.Gens[separate_point:]

    childs = []

    childs += [Entity.Entity(gens = parent_a_fp_gens + parent_b_sp_gens)]
    childs += [Entity.Entity(gens = parent_a_sp_gens + parent_b_fp_gens)]

    return childs

def CrossoverC(parent_a: Entity.Entity, parent_b: Entity.Entity) -> list[Entity.Entity]:
    separate_point_a = parent_a.GensCount // 3
    separate_point_b = separate_point_a * 2

    parent_a_p1_gens  = parent_a.Gens[                :separate_point_a]
    parent_a_p2_gens  = parent_a.Gens[separate_point_a:separate_point_b]
    parent_a_p3_gens  = parent_a.Gens[separate_point_b:                ]

    parent_b_p1_gens  = parent_b.Gens[                :separate_point_a]
    parent_b_p2_gens  = parent_b.Gens[separate_point_a:separate_point_b]
    parent_b_p3_gens  = parent_b.Gens[separate_point_b:                ]

    childs = []

    childs += [Entity.Entity(gens = parent_a_p1_gens + parent_b_p2_gens + parent_a_p3_gens)]
    childs += [Entity.Entity(gens = parent_b_p1_gens + parent_a_p2_gens + parent_b_p3_gens)]

    return childs

def CrossoverD(parent_a: Entity.Entity, parent_b: Entity.Entity) -> list[Entity.Entity]:
    separate_point_a = parent_a.GensCount // 4
    separate_point_b = separate_point_a * 2
    separate_point_c = separate_point_a * 3

    parent_a_p1_gens  = parent_a.Gens[                :separate_point_a]
    parent_a_p2_gens  = parent_a.Gens[separate_point_a:separate_point_b]
    parent_a_p3_gens  = parent_a.Gens[separate_point_b:separate_point_c]
    parent_a_p4_gens  = parent_a.Gens[separate_point_c:                ]

    parent_b_p1_gens  = parent_b.Gens[                :separate_point_a]
    parent_b_p2_gens  = parent_b.Gens[separate_point_a:separate_point_b]
    parent_b_p3_gens  = parent_b.Gens[separate_point_b:separate_point_c]
    parent_b_p4_gens  = parent_b.Gens[separate_point_c:                ]

    childs = []

    childs += [Entity.Entity(gens = parent_a_p1_gens + parent_b_p2_gens + parent_a_p3_gens + parent_b_p4_gens)]
    childs += [Entity.Entity(gens = parent_b_p1_gens + parent_a_p2_gens + parent_b_p3_gens + parent_a_p4_gens)]

    return childs

def LocalOptimizerA(entity: Entity.Entity, items: list[Entity.Entity], capacity: int) -> Entity.Entity:
    fitness_func = Evolutor.Helper.Fitness

    new_entity = entity.Copy()

    min_weight_item = None
    min_weight_item_index = None

    for iid, item in enumerate(items):
        if not entity.Gens[iid] and (not min_weight_item or item.Weight < min_weight_item.Weight):
            min_weight_item = item
            min_weight_item_index = iid

    new_entity.Gens[min_weight_item_index] = 1

    if fitness_func(new_entity, items, capacity) >= fitness_func(entity, items, capacity):
        return new_entity

    return entity

_best_eff_items = None

def LocalOptimizerB(entity: Entity.Entity, items: list[Entity.Entity], capacity: int) -> Entity.Entity:
    global _best_eff_items

    fitness_func = Evolutor.Helper.Fitness

    gens_count = entity.GensCount
    new_entity = entity.Copy()
    new_weight = fitness_func(new_entity, items, capacity)

    for _ in range(min(6, gens_count)):
        rem_idx = randint(0, gens_count - 1)

        if entity.Gens[rem_idx] == 1:
            entity.Gens[rem_idx] = 0
            new_weight -= items[rem_idx].Weight

    adds_count = 0
    for item_info in _best_eff_items[min(24, gens_count):]:
        item = item_info['item']
        index = item_info['index']

        if adds_count < 8:
            break

        if entity.Gens[index] == 0 and new_weight + item.Weight <= capacity:
            entity.Gens[index] = 1
            new_weight += item.Weight

            adds_count += 1

    if fitness_func(new_entity, items, capacity) >= fitness_func(entity, items, capacity):
        return new_entity

    return entity

def SetItems(items: list[Item.Item]):
    global _best_eff_items

    _best_eff_items = sorted(
        [
            [{
                'index': i,
                'item': item
            }]
            for i, item in enumerate(items)
        ],
        key = lambda ii: ii['item'].Efficiency
    )

STABILITY_THRESHOLD_VALUE = 100

CAPACITY        = 500
ITEMS_COUNT     = 100
VALUE_RANGE     = {'min': 2, 'max': 30}
WEIGHT_RANGE    = {'min': 1, 'max': 20}
ENTITIES_COUNT  = 100

MUTATION_CHANCE  = 0.05
MUTATORS = {
    'Flip':     MutatorA,
    'Swap':     MutatorB,
    'FlipSwap': MutatorC
}
CROSSOVERS       = {
    'Half':      CrossoverA,
    'Moreless':  CrossoverB,
    'ThreeAsym': CrossoverC,
    'Four':      CrossoverD
}
LOCAL_OPTIMIZERS = {
    'AddLightest': LocalOptimizerA,
    'RemSevAddSevEff': LocalOptimizerB
}
