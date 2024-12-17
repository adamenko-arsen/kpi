import random
import matplotlib.pyplot as plt

CAPACITY = 250 # 250
VALUE_RANGE = {'min': 2, 'max': 20}
WEIGHT_RANGE = {'min': 1, 'max': 10}

ITEMS_COUNT = 100
POPULATION_COUNT = 100
CROSSOVER_VALUE = 50
MUTATION_CHANCE = 0.05
GENERATIONS_COUNT = 400

def GeneratePopulation() -> list[list[int]]:
    population = []

    for item_id in range(POPULATION_COUNT):
        population += [
            [
                int(item_id == gen_id)
                for gen_id in range(ITEMS_COUNT)
            ]
        ]

    return population

def Crossover(p1: list[int], p2: list[int]) -> list[int]:
    point = CROSSOVER_VALUE

    c = p1[:point] + p2[point:]

    return c

def Weight(ind: list[int]) -> int:
    global items

    weight = sum(
        items[i]['weight'] for i in range(ITEMS_COUNT) if ind[i]
    )

    return weight

def Value(ind):
    return sum(items[i]['value'] for i in range(ITEMS_COUNT) if ind[i])

def Fitness(ind):
    return Value(ind) if Weight(ind) <= CAPACITY else -1

def Mutate(ind: list[int]) -> tuple[list[int], bool]:
    ind = ind[:]

    if random.random() < MUTATION_CHANCE:
        idx = random.randint(0, ITEMS_COUNT - 1)
        ind[idx] = 1 - ind[idx]

        return ind, True
    
    return ind, False

def LocallyOptimize(ind: list[int]) -> None:
    old_weight = Weight(ind)

    worst_indexer = len(items_end_worst) - 1
    while not (old_weight < CAPACITY):
        if worst_indexer < 0:
            break

        item_data = items_end_worst[worst_indexer]
        index = item_data['index']

        if ind[index] == 1:
            old_weight -= item_data['weight']
            ind[index] = 0
        
        worst_indexer -= 1

    for _ in range(random.randint(0, 10)):
        ind[random.randint(0, ITEMS_COUNT - 1)] = 0

    old_weight = Weight(ind)

    appends = 0
    for item in items_from_best:
        if appends > 10:
            break

        index = item['index']

        if old_weight + item['weight'] <= CAPACITY and ind[index] == 0:
            ind[index] = 1
            old_weight += item['weight']
            appends += 1

def SolveKnapsack() -> dict:
    average_values = []
    worst_values = []
    best_values = []

    best_ind = {'value': -1, 'ind': None}

    population = GeneratePopulation()

    for _ in range(GENERATIONS_COUNT):
        # mate
        p1, p2 = None, None

        select_iters = 0
        while p1 == p2:
            if select_iters > 10:
                break

            p1 = sorted(population, key=lambda x: Fitness(x))[-1]
            p2 = random.choice(population)

            select_iters += 1

        c = Crossover(p1, p2)
        c_mut, is_mut = Mutate(c)

        best_c = c
        if Value(c_mut) > Value(c):
            best_c = c_mut
        else:
            is_mut = False

        if not is_mut:
            LocallyOptimize(best_c)

        population += [best_c]

        population.sort(key=lambda x: Fitness(x), reverse=True)
        population.pop()

        values = list(map(Value, population))

        average_values += [sum(values) / len(population)]
        worst_values += [min(values)]
        best_values += [max(values)]

        may_new_best_ind = (sorted(population, key=lambda x: Value(x)))[-1]
        may_new_best_ind_value = Value(may_new_best_ind)

        if may_new_best_ind_value > best_ind['value']:
            best_ind['value'] = may_new_best_ind_value
            best_ind['ind'] = may_new_best_ind[:]

    return {
        'best_value': best_ind['value'],
        'best_gens': best_ind['ind'],
        'average_values': average_values,
        'worst_values': worst_values,
        'best_values': best_values
    }

items = [
    {
        'value': random.randint(
            VALUE_RANGE['min'],
            VALUE_RANGE['max']
        ),
        'weight': random.randint(
            WEIGHT_RANGE['min'],
            WEIGHT_RANGE['max']
        )
    }
    for _ in range(ITEMS_COUNT)
]

items_indexes = [
    {
        'value': item['value'] / item['weight'],
        'index': i,
        'weight': item['weight']
    }
    for i, item in enumerate(items)
]

items_from_best = items_indexes[:]
items_from_best.sort(key=lambda x: x['value'], reverse=True)

items_end_worst = items_indexes[:]
items_end_worst.sort(key=lambda x: x['value'], reverse=True)

# generate result
results = SolveKnapsack()

print(f'Best value: {results["best_value"]}')
print(f'Best gens:  {results["best_gens"]}')
print(f'Values ranges:')

for i in range(0, GENERATIONS_COUNT, 100):
    print(f'{i},{results["worst_values"][i]},{results["average_values"][i]},{results["best_values"][i]}')

# output results
fig, axs = plt.subplots(2, 2, figsize=(10, 8))

ax = axs[(0, 0)]
ax.grid(color='#777', which='major')
ax.minorticks_on()
ax.grid(color='#aaa', which='minor')

ax.plot(
    range(GENERATIONS_COUNT),
    results['best_values'],
    color = '#077',
    label = 'Best value'
)
ax.plot(
    range(GENERATIONS_COUNT),
    results['average_values'],
    color = '#770',
    label = 'Average value'
)
ax.plot(
    range(GENERATIONS_COUNT),
    results['worst_values'],
    color = '#700',
    label = 'Worst value'
)
ax.legend()

ax = axs[(0, 1)]

ax.grid(color='#777', which='major')
ax.minorticks_on()
ax.grid(color='#aaa', which='minor')

ax.plot(
    range(GENERATIONS_COUNT),
    [r / 900 for r in results['best_values']],
    color = 'black',
    label = 'Effectiveness'
)
ax.legend()

plt.show()
