if __name__ == '__main__':
    print(f'The python file {__file__} can be used only as a library')
    exit(1)

inf = 9999

def GetMax(S: State, h: int, m, a: float = -inf, b: float = inf):
    global iters
    iters += 1

    if h == 0:
        return S.value()

    if m == '-':
        min_ = inf
        for ci in S.children():
            c = ci['child']
            cv = GetMax(c, h - 1, '+', a, b)

            min_ = min(min_, cv)
            b = min(b, cv)

            if not (a < b):
                break

        return min_

    if m == '+':
        max_ = -inf
        for ci in S.children():
            c = ci['child']
            cv = GetMax(c, h - 1, '-', a, b)

            c = ci['child']
            cv = GetMax(c, h - 1, '+', a, b)

            max_ = max(max_, cv)
            a = max(a, cv)

            if not (a < b):
                break

        return max_

def rand(x, y):
    return (137*x + 345*y + 456) % 100

def FindBestMove(S, h):
    mx = -inf
    mv = None

    for child_info in S.children():
        if (may_new_mx := GetMax(child_info['child'], h - 1, '-')) > mx:
            mx = may_new_mx
            mv = child_info['move']

    return {'best_value': mx, 'best_move': mv}

class State:
    def __init__(self, state):
        self.state = state

    def value(self):
        return rand(self.state, 0)

    def children(self):
        for i in range(2):
            yield {'move': i, 'child': State(rand(self.state + i, 1))}

    def __repr__(self):
        return f'N[s={self.state}, v={self.value()}]'

print(FindBestMove(State(1), 8))
print(iters)
