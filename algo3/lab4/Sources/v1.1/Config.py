if __name__ == '__main__':
    print(f'File {__file__} can be used only as a library')
    exit(1)

import Entity
import Evolutor

from random import randint, choice

def LocallyOptimize(entity: Entity.Entity, items: list[Entity.Entity], capacity: int):
    fitness_func = Evolutor.Helper.Fitness

    new_entity = entity.Copy()

    min_weight_item = None
    min_weight_item_index = None

    for iid, item in enumerate(items):
        if not entity.Gens[iid] and (not min_weight_item or item.Weight < min_weight_item.Weight):
            min_weight_item = item
            min_weight_item_index = iid

    new_entity.Gens[min_weight_item_index] = 1

    if fitness_func(new_entity, items, capacity) > fitness_func(entity, items, capacity):
        return new_entity

    return entity

GENERATIONS_COUNT = 600

CAPACITY     = 250
ITEMS_COUNT  = 100
VALUE_RANGE  = {'min': 2, 'max': 20}
WEIGHT_RANGE = {'min': 1, 'max': 10}

ENTITIES_COUNT  = 100
MUTATION_CHANCE = 0.05
