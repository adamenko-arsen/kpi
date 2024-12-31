if __name__ == '__main__':
    print(f'File {__file__} can be used only as a library')
    exit(1)

import Entity
import Item

import math
from typing import List, Callable, Optional
from random import choice, randint

class Helper:
    @staticmethod
    def Weight(entity: Entity.Entity, items: List[Item.Item]) -> int:
        return sum(
            item.Weight if (entity.Gens[iid] == 1) else 0

            for iid, item in enumerate(items)
        )

    @staticmethod
    def Value(entity: Entity.Entity, items: List[Item.Item]) -> int:
        return sum(
            item.Value if (entity.Gens[iid] == 1) else 0

            for iid, item in enumerate(items)
        )

    @staticmethod
    def Fitness(entity: Entity.Entity, items: List[Item.Item], capacity: int) -> int:
        return \
            Helper.Value(entity, items) \
            if Helper.Weight(entity, items) <= capacity \
            else -1

    @staticmethod
    def TryGetMutatedAndImprove(
        child_a: Entity.Entity,
        child_b: Entity.Entity,
        items: List[Item.Item],
        capacity: float,
        mutate_chance: float
    ) -> Optional[Entity.Entity]:
        child_a_mut_info = child_a.GetMutated(mutate_chance)
        child_b_mut_info = child_b.GetMutated(mutate_chance)

        if not (child_a_mut_info['is_mut'] or child_b_mut_info['is_mut']):
            return {'is_mut_useful': False, 'entity': None}

        child_a_mut = child_a_mut_info['entity']
        child_b_mut = child_b_mut_info['entity']

        # choose best
        child_a_fitness = Helper.Fitness(child_a, items, capacity)
        child_b_fitness = Helper.Fitness(child_b, items, capacity)

        child_a_mut_fitness = Helper.Fitness(child_a_mut, items, capacity)
        child_b_mut_fitness = Helper.Fitness(child_b_mut, items, capacity)

        is_mutation_useless = True

        if child_a_mut_fitness >= child_a_fitness:
            child_a_better = child_a_mut
            is_mutation_useless = False
        else:
            child_a_better = child_a

        if child_b_mut_fitness >= child_b_fitness:
            child_b_better = child_b_mut
            is_mutation_useless = False
        else:
            child_b_better = child_b

        # mutation is useless
        if is_mutation_useless:
            return {'is_mut_useful': False, 'entity': None}

        child_a_better_fitness = Helper.Fitness(child_a_better, items, capacity)
        child_b_better_fitness = Helper.Fitness(child_b_better, items, capacity)

        if child_a_better_fitness > child_b_better_fitness:
            best_child = child_a_better
        if child_b_better_fitness > child_a_better_fitness:
            best_child = child_b_better
        else:
            best_child = choice([child_a_better, child_b_better])

        return {'is_mut_useful': True, 'entity': best_child}

    @staticmethod
    def GetWithBestFitness(
            child_a: Entity.Entity,
            child_b: Entity.Entity,
            items: List[Item.Item],
            capacity: int
    ) -> Entity.Entity:
        child_a_fitness = Helper.Fitness(child_a, items, capacity)
        child_b_fitness = Helper.Fitness(child_b, items, capacity)

        if child_a_fitness > child_b_fitness:
            return child_a
        elif child_b_fitness > child_a_fitness:
            return child_b
        else:
            return choice([child_a, child_b])

    @staticmethod
    def ChooseTwoParents(entities, items, capacity):
        parent_a = None

        for entity in entities:
            if not (parent_a != entity):
                continue

            if not parent_a or Helper.Fitness(entity, items, capacity) > Helper.Fitness(parent_a, items, capacity):
                parent_a = entity

        parent_b = choice(entities)

        while parent_a == parent_b:
            parent_b = choice(entities)

        return [parent_a, parent_b]

class Evolutor:
    def __init__(self):
        self.items = []
        self.entities = []
        self.best_entity = None

    def SetItems(self, items: List[Item.Item]):
        self.items = items

    def SetEntities(self, entities: List[Entity.Entity]):
        self.entities = entities

    def SetCapacity(self, capacity: int):
        self.capacity = capacity

    def SetMutationChance(self, chance: float):
        self.mutation_chance = chance

    def SetCrossover(self, crossover: Callable[[Entity.Entity, List[Item.Item], int], Entity.Entity]):
        self.crossover = crossover

    def SetLocalOptimization(self, local_optimizer: Callable[[Entity.Entity], None]):
        self.local_optimizer = local_optimizer

    @property
    def BestEntity(self):
        return self.best_entity

    def StepEvolution(self):
        entities      = self.entities
        items         = self.items
        capacity      = self.capacity
        mutate_chance = self.mutation_chance

        # choose a parent
        parents = Helper.ChooseTwoParents(entities, items, capacity)

        parent_a = parents[0]
        parent_b = parents[1]

        # bear childs
        childs = self.crossover(parent_a, parent_b)

        child_a = childs[0]
        child_b = childs[1]

        # it is always removed and nothing changes
        if not (child_a != -1 or child_b != -1):
            return

        # mutate
        mut_child_info = Helper.TryGetMutatedAndImprove(
            child_a, child_b,
            items, capacity, mutate_chance
        )

        if mut_child_info['is_mut_useful']:
            mut_child = mut_child_info['entity']
            best_child = mut_child
        else:
            best_candidate = Helper.GetWithBestFitness(child_a, child_b, items, capacity)

            best_child = self.local_optimizer(best_candidate, items, capacity)

        if not self.best_entity \
                or Helper.Fitness(best_child, items, capacity) \
                    > \
                Helper.Fitness(self.best_entity, items, capacity):
            self.best_entity = best_child

        # add to population and remove worst
        entities += [best_child]

        if True:
            worst_index   = None
            worst_fitness = math.inf

            for eid, entity in enumerate(entities):
                if (fitness := Helper.Fitness(entity, items, capacity)) < worst_fitness:
                    worst_fitness = fitness
                    worst_index = eid

            if worst_index != None:
                del entities[worst_index]

