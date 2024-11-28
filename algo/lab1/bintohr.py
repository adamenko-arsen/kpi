import json
import sys

def RawToInt(raw):
    return int.from_bytes(raw, byteorder='little', signed=True)

intSize = 8

ints = []

with open(sys.argv[1], 'rb') as file:
    while True:
        chunk = file.read(intSize)

        if not chunk:
            break

        if not (len(chunk) == intSize):
            raise IOError()

        ints.append(RawToInt(chunk))

with open(sys.argv[2], 'w') as file:
    json.dump(ints, file, indent = 3)
