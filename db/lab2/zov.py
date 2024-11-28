from random import randint, choice

zrada = ['net', 'da', 'vosmozno', 'konechno ze', 'ne znayu', 'slehka', 'kak vsegda', 'zlo', 'zrada', 'ganba']

names = ['anton', 'bohdan', 'lena', 'denys', 'bodya', 'loleps', 'mia', 'arsen', 'katya', 'sveta', 'jo', 'joster', 'jonodan', 'vladimir', 'nick', 'vova', 'artem', 'danya', 'daniil', 'emma']

family = ['hutsan', 'loleps', 'jojo', 'putin', 'zelenskiy', 'poroshenko', 'lenyaua', 'grishenko', 'borisov']

rank = ['general', 'huilo', 'pidor', 'radovoy', 'commander', 'admin', 'putin', 'admiral', 'denchik', 'da', 'net', 'hrin yoho zna']

q = "'"

for _ in range(100):
    print(f'({q + choice(family) + " " + choice(names) + " " + choice(names) + q}, {q + str(randint(2000, 2007)) + "-01-01" + q}, {q + choice(rank) + q}, {q + choice(zrada) + q}),')
