from time import time
from math import log

def round_rel(x):
    p = -int(log(x, 10))
    m = 10**(p + 4)

    return int(x * m) / m

def rv(G, C, c, v):
    c = set(range(c))

    for nb in G[v]:
        c -= {C[nb]}

    return len(c)

def mrvsci(G, C, c):
    R = []
    V = []
    m = float('inf')

    for v in G:
        if not (C[v] == None):
            continue

        crv = rv(G, C, c, v)

        if crv < m:
            m = crv

            R = []
            V = []

        if crv <= m:
            R += [crv]
            V += [v]

    return V, R

def vs(G, C, v, c):
    for neighbor in G[v]:
        if C[neighbor] == c:
            return False

    return True

iters = 0
deads = 0

def backtracking_impl(G, C, c, i, *, d = 0):
    global iters, deads

    if not (len([None for v in C if C[v] == None]) >= 1):
        return True

    if d != 0:
        bV, bR = mrvsci(G, C, c)
    else:
        bV, bR = [i], [1]

    iters += len(bV)

    for i, bv in enumerate(bV):
        if not (bR[i] >= 1):
            continue

        for c_ in range(c):
            if not vs(G, C, bv, c_):
                continue

            C[bv] = c_

            if backtracking_impl(G, C, c, None, d = d + 1):
                return True
            else:
                deads += 1

            C[bv] = None

    return False

def backtracking(G, c, i):
    C = {v: None for v in G}
    
    if backtracking_impl(G, C, c, i):
        return C
    else:
        return None

graph = {
      0: {1, 2}
    , 1: {0, 2}
    , 2: {0, 1}
}

iters = 0
deads = 0

start_time = time()

result = backtracking(graph, 4, 0)

end_time = time()

print(f'Done for {round_rel(end_time - start_time)} secs')

if result:
    print(f'Painted graph: {result}')
    print(f'Iters count:   {iters}')
    print(f'Deads count:   {deads}')
else:
    print('Cannot paint the graph')
