import IndexIO

idx_io = IndexIO.IndexIO('test.bin', loadFactor=0.7)

if 0:
    for i in range(1024):
        idx_io._set_record(i, bytes([0]) * 12, bytes([0]) * 4)

    for i in range(512):
        idx_io._set_record(i, f'{i:0>4}'.encode('ascii'), f'{i:0>3}'.encode('ascii'))

if 1:
    for i in range(64 * 4):
        idx_io._set_record(i, bytes([0]) * 12, bytes([0]) * 4)

    for b in range(3):
        for r in range(64):
            w = b * 64 + r
            v = w * 2

            idx_io._set_record(w, f'{v:0>4}'.encode('ascii'), f'{v:0>3}'.encode('ascii'))

idx_io.Add('0001'.encode('ascii'), '001'.encode('ascii'))
idx_io.Add('0003'.encode('ascii'), '001'.encode('ascii'))
