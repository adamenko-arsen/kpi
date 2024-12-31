import Config
import Evolutor
import Entity
import Item
import Drawer

from random import randint
from typing import Callable, Dict, List

def MakeExperiment(
    *,
    items: List[Item.Item],
    mutation_chance: float,
    crossover: Callable[[Entity.Entity, Entity.Entity], List[Entity.Entity]],
    local_optimizer: Callable[[Entity.Entity, List[Item.Item], int], Entity.Entity]
) -> List[int]:
    entities = []

    for eid in range(Config.ENTITIES_COUNT):
        entities += [Entity.Entity(
            gens = [eid == iid for iid in range(Config.ITEMS_COUNT)]
        )]

    evolutor = Evolutor.Evolutor()

    evolutor.SetItems(items)
    evolutor.SetEntities(entities)

    evolutor.SetCapacity(Config.CAPACITY)
    evolutor.SetMutationChance(mutation_chance)
    evolutor.SetCrossover(crossover)
    evolutor.SetLocalOptimization(local_optimizer)

    best_values = []

    stability_length = 0
    stability_value = -1

    while True:
        evolutor.StepEvolution()

        best_values += [Evolutor.Helper.Fitness(evolutor.BestEntity, items, Config.CAPACITY)]

        if best_values[-1] > stability_value:
            stability_value = best_values[-1]
            stability_length = 0
        else:
            if not (stability_length <= Config.STABILITY_THRESHOLD_VALUE):
                break
            else:
                stability_length += 1

    return best_values

def PrintBestStat(conf_name: str, results: Dict[str, List[int]]):
    print(f'Best statistic for configurable parameter <{conf_name}>:')

    index = 1
    for var in results:
        print(f'{index: >3}: version = <{var: >16}>, best result = <{results[var][-1]: >5}>')
        index += 1

def main():
    items = []
    entities = []

    Config.SetItems(items)

    for _ in range(Config.ITEMS_COUNT):
        items += [Item.Item(
            weight = randint(Config.WEIGHT_RANGE['min'], Config.WEIGHT_RANGE['max']),
            value  = randint(Config.VALUE_RANGE ['min'], Config.VALUE_RANGE ['max'])
        )]

    results_of_mutations  = {}
    results_of_crossovers = {}
    results_of_local_optimizers = {}

    for mutation_chance in Config.MUTATION_CHANCES:
        best_values = MakeExperiment(
            items = items,
            mutation_chance = Config.MUTATION_CHANCES[mutation_chance],
            crossover = Config.CROSSOVERS['Half'],
            local_optimizer = Config.LOCAL_OPTIMIZERS['AddLightest']
        )

        results_of_mutations[mutation_chance] = best_values

    best_mutation = max(
        [
            {'var': k, 'max': results_of_mutations[k][-1]}
            for k in results_of_mutations
        ],
        key = lambda x: x['max']
    )['var']

    for crossover in Config.CROSSOVERS:
        best_values = MakeExperiment(
            items = items,
            mutation_chance = Config.MUTATION_CHANCES[best_mutation],
            crossover = Config.CROSSOVERS[crossover],
            local_optimizer = Config.LOCAL_OPTIMIZERS['AddLightest']
        )

        results_of_crossovers[crossover] = best_values

    best_crossover = max(
        [
            {'var': k, 'max': results_of_crossovers[k][-1]}
            for k in results_of_crossovers
        ],
        key = lambda x: x['max']
    )['var']

    for local_optimizer in Config.LOCAL_OPTIMIZERS:
        best_values = MakeExperiment(
            items = items,
            mutation_chance = Config.MUTATION_CHANCES[best_mutation],
            crossover = Config.CROSSOVERS[best_crossover],
            local_optimizer = Config.LOCAL_OPTIMIZERS[local_optimizer]
        )

        results_of_local_optimizers[local_optimizer] = best_values

    best_local_optimizer = max(
        [
            {'var': k, 'max': results_of_local_optimizers[k][-1]}
            for k in results_of_local_optimizers
        ],
        key = lambda x: x['max']
    )['var']

    PrintBestStat('mutation chance', results_of_mutations)
    print()
    PrintBestStat('crossover method', results_of_crossovers)
    print()
    PrintBestStat('local optimizer', results_of_local_optimizers)

    print('Best combination of variants of parameters:')
    print(f'| Mutation:        <{best_mutation}>')
    print(f'| Crossover:       <{best_crossover}>')
    print(f'| Local optimizer: <{best_local_optimizer}>')

    drawer = Drawer.Drawer()

    drawer.AddNewComparison(
        'mutation chance',
        results_of_mutations,
        [
            'purple',
            'navy',
            'darkgreen',
            'olive',
            'darkorange',
            'darkred'
        ]
    )
    drawer.AddNewComparison(
        'crossover method',
        results_of_crossovers,
        [
            'darkred',
            'olive',
            'darkgreen',
            'navy'
        ]
    )
    drawer.AddNewComparison(
        'local optimizer',
        results_of_local_optimizers,
        [
            'navy',
            'darkgreen'
        ]
    )

    drawer.Draw()

if __name__ == '__main__':
    main()
else:
    print(f'File {__file__} can be used only as an executable')
    exit(1)
