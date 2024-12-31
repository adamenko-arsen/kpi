import os

def IntToRaw(value, intSize):
    return value.to_bytes(intSize, byteorder='little', signed=True)

def RawToInt(raw):
    return int.from_bytes(raw, byteorder='little', signed=True)

def GetFileSize(fileName):
    return os.path.getsize(fileName)

def CreateIntArrayFile(fileName, length, intSize):
    with open(fileName, 'wb') as file:
        for i in range(length):
            file.write(IntToRaw(0, intSize))

class RWIntArrayFile:
    def __init__(self, fileName, length, intSize, *, blockSize=4096):
        if not (0 <= blockSize and (blockSize & (blockSize - 1) == 0)):
            raise ValueError('a block size has to be a power of 2')

        self.fileName = fileName
        self.length = length
        self.intSize = intSize
        self.blockSize = blockSize
        self.blockSizeMask = blockSize - 1
        self.blockSizeBitShift = blockSize.bit_length() - 1
        self.blockSizeMulIntSize = self.intSize << self.blockSizeBitShift
        self.cache = bytearray(blockSize * intSize)
        self.cache_start_index = -1
        self.cache_size = 0
        self.file = None
        self._open_file()

    def _open_file(self):
        try:
            self.file = open(self.fileName, 'r+b')
        except IOError as e:
            print(f"Error opening file: {e}")
            raise

    def _load_block(self, block_index):
        try:
            self.file.seek(block_index * self.blockSizeMulIntSize)
            read_size = self.blockSizeMulIntSize
            bytes_read = self.file.read(read_size)
            self.cache_size = len(bytes_read)
            self.cache[:self.cache_size] = bytes_read
            self.cache_start_index = block_index
        except IOError as e:
            print(f"Error loading block: {e}")
            raise

    def _flush_cache(self):
        if self.cache_start_index == -1:
            return

        try:
            self.file.seek(self.cache_start_index * self.blockSizeMulIntSize)
            self.file.write(self.cache[:self.cache_size])
            self.file.flush()
            self.cache_start_index = -1
            self.cache_size = 0
        except IOError as e:
            print(f"Error flushing cache: {e}")
            raise

    def _get_cache_offset(self, index):
        return (index & self.blockSizeMask) * self.intSize

    def GetInt(self, index):
        block_index = index >> self.blockSizeBitShift
        offset = self._get_cache_offset(index)

        if self.cache_start_index != block_index:
            self._flush_cache()
            self._load_block(block_index)

        rawInt = self.cache[offset:offset + self.intSize]
        return RawToInt(rawInt)

    def SetInt(self, index, value):
        block_index = index >> self.blockSizeBitShift
        offset = self._get_cache_offset(index)

        if self.cache_start_index != block_index:
            self._flush_cache()
            self._load_block(block_index)

        rawIntBytes = bytes(IntToRaw(value, self.intSize))

        self.cache[offset:offset + self.intSize] = rawIntBytes

    def Length(self):
        return self.length

    def IntSize(self):
        return self.intSize

    def FlushCache(self):
        self._flush_cache()

    def __enter__(self):
        self._open_file()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self._flush_cache()
        self.file.close()

    def __del__(self):
        if self.file:
            self._flush_cache()
            self.file.close()


def MergeAt(m, l, r, chk, m_idx, l_beg, l_sz, r_beg, r_sz):
    l_idx = l_beg
    r_idx = r_beg

    while (l_idx < l_sz and l_idx - l_beg < chk) and (r_idx < r_sz and r_idx - r_beg < chk):
        l_val = l.GetInt(l_idx)
        r_val = r.GetInt(r_idx)

        if l_val <= r_val:
            m.SetInt(m_idx, l_val)
            l_idx += 1
        else:
            m.SetInt(m_idx, r_val)
            r_idx += 1

        m_idx += 1

    while l_idx < l_sz and l_idx - l_beg < chk:
        m.SetInt(m_idx, l.GetInt(l_idx))
        l_idx += 1
        m_idx += 1

    while r_idx < r_sz and r_idx - r_beg < chk:
        m.SetInt(m_idx, r.GetInt(r_idx))
        r_idx += 1
        m_idx += 1

def SortAtScale(m, l, r, c):
    s = m.Length()

    ls = 0
    rs = 0

    for i in range(s):
        lrChoice = (i // c) & 1

        blockOffset = i // (2 * c) * c
        index = i % c

        [l, r][lrChoice].SetInt(
              blockOffset + index
            , m.GetInt(i)
        )

        if lrChoice == 0:
            ls += 1
        else:
            rs += 1

    m_idx = 0
    lr_idx = 0

    while m_idx < s:
        MergeAt(
            m, l, r,
            c,
            m_idx,
            lr_idx, ls,
            lr_idx, rs
        )

        m_idx += 2 * c
        lr_idx += c

def DirectMergeSort(m, l, r):
    s = m.Length()

    c = 1
    while c < s:
        SortAtScale(m, l, r, c)

        c *= 2

def main():
    BlockSize = 1024 * 2 ** 10

    IntSize = 8
    Length = GetFileSize('A.qwa') // IntSize

    CreateIntArrayFile('B.qwa', Length, IntSize)
    CreateIntArrayFile('C.qwa', Length, IntSize)

    mainFile  = RWIntArrayFile('A.qwa', Length, IntSize, blockSize = BlockSize)
    leftFile  = RWIntArrayFile('B.qwa', Length, IntSize, blockSize = BlockSize)
    rightFile = RWIntArrayFile('C.qwa', Length, IntSize, blockSize = BlockSize)

    DirectMergeSort(mainFile, leftFile, rightFile)

    mainFile.FlushCache()
    leftFile.FlushCache()
    rightFile.FlushCache()

if __name__ == '__main__':
    main()
