from random import choice, randint
from time import time
from math import log

def round_rel(x):
    p = -int(log(x, 10))
    m = 10**(p + 4)
    
    return int(x * m) / m

def gc(G, C):
    c = 0
    
    for v in G:
        for w in G:
            if w in G[v] and C[v] == C[w]:
                c += 1

    return c // 2

def cnfv(G, C, v, c):
    r = 0
    
    for nb in G[v]:
        r += 1 if C[nb] == c else 0

    return r

def mxсnfvs(G, C):
    R = []
    V = []
    m = 0
    
    for v in G:
        ccnfv = cnfv(G, C, v, C[v])

        if ccnfv > m:
            m = ccnfv

            R.clear()
            V.clear()
    
        if ccnfv >= m:
            R += [ccnfv]
            V += [v]

    return V

def rndc(c):
    return randint(0, c - 1)

def rndv(G):
    return choice(list(G.keys()))

def rgc(G, c):
    return {v: rndc(c) for v in G}

def hill_climb(G, c, r, w):
    ic = 0
    dec = 0
    ist = None

    bC = None
    mc = float('inf')

    for _ in range(r):
        blC = rgc(G, c)
        mlc = gc(G, blC)

        if not ist:
            ist = blC

        wc = 0
        impr = True

        while impr:
            impr = False

            bV = mxсnfvs(G, blC)

            for bv in bV:
                if not (wc < w):
                    break

                bc = blC[bv]
    
                for c_ in range(c):
                    ic += 1

                    if not (c_ != bc):
                        continue
    
                    dcC = blC.copy()
                    dcC[bv] = c_
                    dcc = gc(G, dcC)

                    if dcc < mlc:
                        blC = dcC
                        mlc = dcc
                        
                        impr = True
                    else:
                        dec += 1

                    if mlc == 0:
                        break

                wc += 1

        if mlc < mc:
            bC  = blC
            mc = mlc

        if mc == 0:
            break

    return bC, mc, ic, dec, ist

graph = {
       0: {1, 4, 5}
    ,  1: {0, 2, 5, 6, 7}
    ,  2: {1, 3, 7}
    ,  3: {2, 7, 8}
    ,  4: {0, 5, 9, 10}
    ,  5: {0, 1, 4, 6, 10, 11}
    ,  6: {1, 5, 7, 11, 12, 13}
    ,  7: {1, 2, 3, 6, 8, 13}
    ,  8: {3, 7, 13, 18}
    ,  9: {4, 10, 14}
    , 10: {4, 5, 9, 11,14, 15}
    , 11: {5, 6, 10, 12, 15}
    , 12: {6, 11, 13, 15, 17}
    , 13: {6, 7, 8, 12, 17, 18}
    , 14: {9, 10, 15, 16}
    , 15: {10, 11, 12, 14, 16}
    , 16: {12, 14, 15, 17}
    , 17: {12, 13, 16, 18}
    , 18: {8, 13, 17}
}

for _ in range(20):
    st = time()
    
    C, c, i, de, ist = hill_climb(graph, 4, 10, 100)
    
    et = time()
    
    if False:
        print(f'Done time:  {round_rel(et - st)}')
        
        print(f'Conflicts:  {c}')
        print(f'Iterations: {i}')
        print(f'Dead ends:  {de}')
        print(f'Init state: {ist}')
        
        print(f'Red:        {" ".join(str(v) for v in C if C[v] == 0)}')
        print(f'Yellow:     {" ".join(str(v) for v in C if C[v] == 1)}')
        print(f'Green:      {" ".join(str(v) for v in C if C[v] == 2)}')
        print(f'Blue:       {" ".join(str(v) for v in C if C[v] == 3)}')
    else:
        print(f'{" ".join(str(ist[v]) for v in ist)}\t{i}\t{de}\t1\t1')
