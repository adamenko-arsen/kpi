import IndexIO

idx_io = IndexIO.IndexIO('test.bin', blockSize=1024)

if 0:
    for i in range(1024):
        idx_io._set_record(i, bytes([0]) * 12, bytes([0]) * 4)

    for i in range(512):
        idx_io._set_record(i, f'{i:0>4}'.encode('ascii'), f'{i:0>3}'.encode('ascii'))

if 1:
    for i in range(256):
        idx_io._set_record(i, bytes([0]) * 12, bytes([0]) * 4)

    for i in range(4):
        idx_io._set_record(i * 64, f'{i * 64:0>4}'.encode('ascii'), f'{i * 64:0>3}'.encode('ascii'))
