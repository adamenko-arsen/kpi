def GetToStrZT(bytes_, size):
    ln = len(bytes_)

    if not (ln < size - 1):
        return bytes_[:size]

    return bytes_ + bytes([0])

def GetToStrZTPadded(bytes_, size):
    ln = len(bytes_)

    if not (ln <= size):
        return bytes_[:size]

    return bytes_ + bytes([0]) * (size - ln)

def GetFromBytesZT(bytes_):
    for i, c in enumerate(bytes_):
        if c == 0:
            break

    return bytes_[:i]
