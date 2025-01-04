from random import randint
from copy import deepcopy
import tkinter as tk

categories = [
    '1', '2', '3', '4', '5', '6',
    'S3', 'S4',
    'S23',
    'L4', 'L5',
    'Y',
    'C'
]

def eval_score(dices, category):
    counts = {d: 0 for d in range(1, 6 + 1)}

    for d in dices.values():
        counts[d] += 1

    if category == '1':
        return counts[1] * 1

    elif category == '2':
        return counts[2] * 2

    elif category == '3':
        return counts[3] * 3

    elif category == '4':
        return counts[4] * 4

    elif category == '5':
        return counts[5] * 5

    elif category == '6':
        return counts[6] * 6

    elif category == 'S3':
        return sum(dices) if max(counts.values()) >= 3 else 0

    elif category == 'S4':
        return sum(dices) if max(counts.values()) >= 4 else 0

    elif category == 'S23':
        return 25 if sorted(counts.values(), reverse=True)[:2] == [3, 2] else 0

    elif category == 'L4':
        straights = [
            {1, 2, 3, 4},
            {2, 3, 4, 5},
            {3, 4, 5, 6}
        ]
        return 30 if any(s <= set(dices.values()) for s in straights) else 0

    elif category == 'L5':
        straights = [
            {1, 2, 3, 4, 5},
            {2, 3, 4, 5, 6}
        ]
        return 40 if any(s <= set(dices.values()) for s in straights) else 0

    elif category == 'Y':
        return 50 if max(counts.values()) == 5 else 0

    elif category == 'C':
        return sum(dices.values())

    return 0

cats_usage = {
    c: False for c in categories
}
dices = {
    1: 1,
    2: 2,
    3: 3,
    4: 3,
    5: 3
}

def gen_keeps():
    keeps = []

    for i in range(32):
        bins = list(map(int, f'{bin(i):0<7}'[2:][::-1]))

        keeps += [{i + 1: bins[i] for i in range(0, 5)}]

    return keeps

def gen_keep():
    return {i: bool(randint(0, 1)) for i in range(1, 5 + 1)}

def gen_rolled(dices, keep):
    new_dices = deepcopy(dices)

    for k in dices:
        if not keep[k]:
            new_dices[k] = randint(1, 6)

    return new_dices

def eval_randomly(dices, cats_usage, deepness, start_keep):
    cats_usage = deepcopy(cats_usage)

    for iter_ in range(deepness):
        if all(cats_usage.values()):
            if iter_ == 0:
                return {'score': 0, 'cat': 'C'}

            return max_score_info

        scores_info = [{'score': eval_score(dices, cat), 'cat': cat} for cat in categories if not cats_usage[cat]]

        max_score_info = max(scores_info, key=lambda si: si['score'])

        cats_usage[max_score_info['cat']] = True

        if iter_ == 0:
            new_keep = start_keep
        else:
            new_keep = gen_keep()

        dices = gen_rolled(dices, new_keep)

    return max_score_info

def best_move(dices, cats_usage, rolls):
    reses = {}
    trials = 2000
    for keep in gen_keeps():
        key = ''.join([str(int(d)) for d in keep.values()])
        reses[key] = 0

        for _ in range(trials):
            reses[key] += eval_randomly(dices, cats_usage, rolls - 1, keep)['score']

        reses[key] /= trials

    fmt_move = max(reses, key=lambda k: reses[k])

    return {i + 1: v for i, v in enumerate(map(int, fmt_move))}

no_keep = {i + 1: False for i in range(5)}
start_dices = {i + 1: i + 1 for i in range(5)}

def bot_make_turn():
    global bot_cats_label
    global bot_cats_scores
    global bot_cats_usage
    global no_keep
    global start_dices
    global bot_dices_label
    global bot_move_label
    global is_game_end

    if is_game_end:
        return

    dices = gen_rolled(start_dices, no_keep)

    for i in range(3):
        if i == 2:
            break

        move = best_move(dices, bot_cats_usage, 3 - i)

        calced_keep = move

        dices = gen_rolled(dices, calced_keep)

        bot_dices_label.config(text = 'Bot Dices: ' + ' '.join(str(i) for i in dices.values()))

    best_cat = None
    best_cat_score = -1
    for cat in categories:
        cur_score = eval_score(dices, cat)

        if cur_score > best_cat_score and not bot_cats_usage[cat]:
            best_cat_score = cur_score
            best_cat = cat

    bot_cats_usage[best_cat] = True
    bot_cats_scores[best_cat] = best_cat_score
    bot_cats_label.config(text = 'Bot: ' + ' '.join(str(i) for i in bot_cats_scores.values()))
    bot_dices_label.config(text = 'Bot Dices: ' + ' '.join(str(i) for i in dices.values()))
    bot_move_label.config(text = 'Bot Move: ' + best_cat)

    #print(bot_cats_scores)
    #print(dices)

    end_game()

def roll_event():
    global you_roll_n
    global you_dices
    global input_keep_entry
    global dices_label
    global is_game_end

    if is_game_end:
        return

    if you_roll_n >= 3:
        return

    keep_fmt = input_keep_entry.get()

    keep = {i + 1: False for i in range(5)}

    for v in map(int, keep_fmt.split()):
        keep[v] = True

    you_dices = gen_rolled(you_dices, keep)

    dices_label.config(text = 'Dices: ' + ' '.join(str(i) for i in you_dices.values()))

    you_roll_n += 1

def use_cat_event():
    global you_roll_n
    global you_dices
    global you_cats_usage
    global you_cats_label
    global you_cats_scores
    global input_cat_entry
    global is_game_end

    if is_game_end:
        return

    end_game()

    if you_roll_n == 0:
        return

    cat = input_cat_entry.get()

    if you_cats_usage[cat]:
        return

    you_cats_scores[cat] = eval_score(you_dices, cat)
    you_cats_label.config(text = 'You: ' + ' '.join(str(i) for i in you_cats_scores.values()))
    you_cats_usage[cat] = True

    you_roll_n = 0

    bot_make_turn()

    end_game()

def end_game():
    global win_label
    global you_cats_usage
    global bot_cats_usage
    global you_cats_scores
    global bot_cats_scores
    global is_game_end

    if not (all(you_cats_usage.values()) and all(bot_cats_usage.values())):
        return

    you_scores = sum((0 if not isinstance(you_cats_scores[k], int) else you_cats_scores[k]) for k in you_cats_scores)
    bot_scores = sum((0 if not isinstance(bot_cats_scores[k], int) else bot_cats_scores[k]) for k in bot_cats_scores)

    #print(you_scores)
    #print(bot_scores)

    if you_scores > bot_scores:
        text = 'You wins!'
    elif bot_scores > you_scores:
        text = 'Bot wins!'
    else:
        text = 'Tie!'

    win_label.config(text = text)

    is_game_end = True

you_roll_n = 0
you_dices = deepcopy(dices)

is_game_end = False

you_cats_usage = {
    c: False for c in categories
}
you_cats_scores = {
    c: 'x' for c in categories
}
bot_cats_usage = {
    c: False for c in categories
}
bot_cats_scores = {
    c: 'x' for c in categories
}

win = tk.Tk()

title_label = tk.Label(
    win,
    text = 'Simulator of melalchoholic Yathzee high-definition very realistic simulator'
)

cats_label = tk.Label(
    win,
    text = 'Categories: 1 2 3 4 5 S3 S4 S23 L4 L5 Y C'
)

you_cats_label = tk.Label(
    win,
    text = 'You: x x x x x x x x x x x'
)

bot_cats_label = tk.Label(
    win,
    text = 'Bot: x x x x x x x x x x x'
)

bot_dices_label = tk.Label(
    win,
    text = 'Bot Dices: x x x x x'
)

dices_label = tk.Label(
    win,
    text = 'Dices: x x x x x'
)

bot_move_label = tk.Label(
    win,
    text = 'Bot Move: <no>'
)

input_cat_entry = tk.Entry(
    win,
    bg = 'lightgreen'
)

input_keep_entry = tk.Entry(
    win,
    bg = 'yellow'
)

roll_button = tk.Button(
    win,
    text = 'Roll',
    command = roll_event
)

use_cat_button = tk.Button(
    win,
    text = 'Use',
    command = use_cat_event
)

win_label = tk.Label(
    win,
    text = 'Game continues...'
)

title_label     .grid(row= 0, column=0, rowspan=1, columnspan=2)
cats_label      .grid(row= 1, column=0, rowspan=1, columnspan=2)
you_cats_label  .grid(row= 2, column=0, rowspan=1, columnspan=2)
bot_cats_label  .grid(row= 3, column=0, rowspan=1, columnspan=2)
bot_dices_label .grid(row= 4, column=0, rowspan=1, columnspan=2)
bot_move_label  .grid(row= 5, column=0, rowspan=1, columnspan=2)
dices_label     .grid(row= 6, column=0, rowspan=1, columnspan=2)
input_cat_entry .grid(row= 7, column=0, rowspan=1, columnspan=2)
input_keep_entry.grid(row= 8, column=0, rowspan=1, columnspan=2)

roll_button     .grid(row= 9, column=0, rowspan=1, columnspan=1)
use_cat_button  .grid(row= 9, column=1, rowspan=1, columnspan=1)

win_label       .grid(row=10, column=0, rowspan=1, columnspan=2)

win.mainloop()

