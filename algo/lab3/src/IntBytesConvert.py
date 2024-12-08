def UintToBytes(i: int, size: int):
    return i.to_bytes(size, byteorder='little', signed=False)

def BytesToUint(b: bytes):
    return int.from_bytes(b, byteorder='little', signed=False)
