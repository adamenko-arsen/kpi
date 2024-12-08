import ZTStrUtils
import FileMapper

import os

class RecordIO:
    recordSize = 128

    def __init__(self, filename):
        self.file = FileMapper.FileMapper(filename, cache_size=1024)

    def Add(self, data):
        end = self.file.Size()

        self.file.WriteMany(end, ZTStrUtils.GetToStrZTPadded(data.encode('ascii'), 128))

        return end // self.recordSize

    def Get(self, id_):
        if not (id_ <= self.file.Size() // self.recordSize):
            return None

        return ZTStrUtils.GetFromBytesZT \
        (
            self.file.ReadMany(self.recordSize * id_, self.recordSize)
        ) \
            .decode('ascii')

    def Set(self, id_, data):
        if not (id_ <= self.file.Size() // self.recordSize):
            return None

        self.file.WriteMany(
            self.recordSize * id_,
            (data[:self.recordSize - 1] + '\x00')
                .encode('ascii')
        )

    def Wipe(self):
        self.file.WipeData()

    def Sync(self):
        self.file._write_cache()
