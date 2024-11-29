import os

class FileMapper:
    def __init__(self, filename, cache_size=1024):
        self.file = open(filename, 'r+b')

        self.cache_valid = False
        self.cache_start = -1
        self.cache_end = -1
        self.cache_data = bytearray(cache_size)
        self.cache_size = cache_size

        self.file.seek(0, os.SEEK_END)
        self.length = self.file.tell()

    def _load_cache(self, index):
        self._write_cache()

        cache_size = self.cache_size

        aligned_index = self._aligned_index(index)

        self.cache_start = aligned_index
        self.cache_end = aligned_index + cache_size

        size_for_read = min(self.length, self.cache_end) - self.cache_start
        self.file.seek(aligned_index, os.SEEK_SET)
        read_data = self.file.read(size_for_read)

        for i in range(self.cache_size):
            self.cache_data[i] = 0

        for i, c in enumerate(read_data):
            self.cache_data[i] = c

        self.cache_valid = True

    def _write_cache(self):
        if not self.cache_valid:
            return

        self.file.seek(self.cache_start, os.SEEK_SET)
        self.file.write(
            self.cache_data[:min(self.cache_end, self.length) - self.cache_start]
        )

    def _aligned_index(self, index):
        return index // self.cache_size * self.cache_size

    def WriteByte(self, index, value):
        self.length = max(self.length, index + 1)

        if not (self.cache_valid and self.cache_start <= index < self.cache_end):
            self._load_cache(index)

        self.cache_data[index - self._aligned_index(index)] = value

    def ReadByte(self, index):
        if not (
                    self.cache_valid
                and self.cache_start <= index
                and (index < self.cache_end and index < self.length)
            ):
            self._load_cache(index)

        return self.cache_data[index - self._aligned_index(index)]

    def WriteMany(self, index, data):
        for offset, char in enumerate(data):
            self.WriteByte(index + offset, char)
    
    def ReadMany(self, index, size):
        data = bytearray(size)

        for data_index in range(size):
            data[data_index] = self.ReadByte(index + data_index)

        return data

    def Size(self):
        return self.length

    def __del__(self):
        if self.cache_valid:
            self._write_cache()

        self.file.close()
