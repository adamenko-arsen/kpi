import Config
import Evolutor
import Entity
import Item
import Drawer

from random import randint

def main():
    items = []
    entities = []

    for _ in range(Config.ITEMS_COUNT):
        items += [Item.Item(
            weight = randint(Config.WEIGHT_RANGE['min'], Config.WEIGHT_RANGE['max']),
            value  = randint(Config.VALUE_RANGE ['min'], Config.VALUE_RANGE ['max'])
        )]

    for eid in range(Config.ENTITIES_COUNT):
        entities += [Entity.Entity(
            gens = [eid == iid for iid in range(Config.ITEMS_COUNT)]
        )]

    evolutor = Evolutor.Evolutor()

    evolutor.SetItems(items)
    evolutor.SetEntities(entities)

    evolutor.SetCapacity(Config.CAPACITY)
    evolutor.SetMutationChance(Config.MUTATION_CHANCE)
    evolutor.SetLocalOptimization(Config.LocallyOptimize)

    best_values = []

    for _ in range(Config.GENERATIONS_COUNT):
        evolutor.StepEvolution()

        best_values += [Evolutor.Helper.Fitness(evolutor.BestEntity, items, Config.CAPACITY)]

    print(f'Best entity value: {Evolutor.Helper.Fitness(evolutor.BestEntity, items, Config.CAPACITY)}')
    print(f'Best weight: {Evolutor.Helper.Weight(evolutor.BestEntity, items)}')

    tick_rate = 10
    for iter_, value in enumerate(best_values[::tick_rate]):
        print(f'{iter_ * tick_rate + 1},{value}')

    drawer = Drawer.Drawer()
    drawer.SetBestValues(best_values)
    drawer.Draw()

if __name__ == '__main__':
    main()
else:
    print(f'File {__file__} can be used only as an executable')
    exit(1)
