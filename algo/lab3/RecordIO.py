import ZTStrUtils

import os

class RecordIO:
    recordSize = 128

    def __init__(self, filename):
        self.file = open(filename, 'r+b')

    def Add(self, data):
        end = self.getFileSize()

        self.file.write(bytes(self.recordSize))
        self.file.seek(end, os.SEEK_SET)
        self.file.write((data + '\x00').encode('ascii'))

        return end // self.recordSize

    def Get(self, id_):
        if not (id_ <= self.getFileSize() // self.recordSize):
            return None

        self.file.seek(self.recordSize * id_, os.SEEK_SET)

        return ZTStrUtils.GetFromBytesZT(self.file.read(128)).decode('ascii')

    def Set(self, id_, data):
        if not (id_ <= self.getFileSize() // self.recordSize):
            return None

        self.file.seek(self.recordSize * id_, os.SEEK_SET)
        self.file.write(
            (data[:self.recordSize - 1] + '\x00')
                .encode('ascii')
        )

    def Wipe(self):
        self.file.seek(0, os.SEEK_SET)
        self.file.truncate()

    def Sync(self):
        pass

    def getFileSize(self):
        self.file.seek(0, os.SEEK_END)
        return self.file.tell()
