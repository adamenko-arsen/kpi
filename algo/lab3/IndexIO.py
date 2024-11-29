import FileMapper
import ZTStrUtils

import math

def FitTo(bytes_, size):
    ln = len(bytes_)

    if not (ln < size):
        return bytes_[:size]

    return bytes_ + bytes([0]) * (size - ln)

def MaxRecordsWhenAppending(recordsCount, loadFactor):
    return math.ceil(recordsCount / loadFactor)

def DistributeTwoBlocksCounts(recordsCount):
    first = math.ceil(recordsCount / 2)
    second = recordsCount - first

    return {'first': first, 'second': second}

class IndexIO:
    indexSize = 12
    idSize = 4
    recordSize = 16

    def __init__(self, filename, blockSize):
        # TODO
        self.fm = FileMapper.FileMapper(filename, cache_size=1)
        self.rpb = blockSize // self.recordSize

    def Get(self, key):
        index = self._get_index_by_key(key)

        return self._get_record(index)['id'] if index != None else None

    def Remove(self, key):
        index = self._get_index_by_key(key)

        if not (index != None):
            return

        block_index = self._get_block_index_by_record_index(index)
        block_index_range = self._get_block_index_range(block_index)

        for i in range(index, block_index_range['end']):
            new_record = self._get_record(i + 1)

            key = new_record['key']
            id_ = new_record['id']

            self._set_record(i, key, id_)

        # since it is moved lefter, remove an existance mark
        self._set_record(block_index_range['end'], bytes([]), bytes([]))

        self._redistribute_after_remove(block_index)

    def Add(self, index, id_):
        pass

    # get record index by key

    def _get_index_by_key(self, key):
        l = 0
        h = self._get_all_blocks_index_range()['end']

        for _ in range(10):
            m = (l + h) // 2

            mvr = self._get_block_value_range(m)

            if key < mvr['min']:
                h = m - 1
            elif     mvr['max'] < key:
                l = m + 1
            else:
                if mvr['min'] <= key <= mvr['max']:
                    break
                else:
                    return None

        block_range = self._get_block_index_range(m)

        l = block_range['start']
        h = block_range['end']

        for _ in range(6):
            m = (l + h) // 2

            mv = self._get_record(m)['key']

            if key < mv:
                h = m - 1
            elif     mv < key:
                l = m + 1
            else:
                if mv == key:
                    return m
                else:
                    return None

    # basic record input/output

    def _get_record(self, index):
        record = self.fm.ReadMany(index * self.recordSize, self.recordSize)

        return {
            'key': ZTStrUtils.GetFromBytesZT(record[:self.indexSize]),
            'id':  record[self.indexSize:]
        }

    def _set_record(self, index, key, id_):
        self.fm.WriteMany(
            index * self.recordSize,
            FitTo(key, self.indexSize) + FitTo(id_, self.idSize)
        )

    # is record/block used

    def _is_record_used(self, index):
        key = self._get_record(index)['key']

        return key != bytes()

    def _is_block_used(self, index):
        key = self._get_record(
            self._get_block_index_range(index)['start']
        )['key']

        return key != bytes()

    # block records/all blocks ranges

    def _get_block_index_by_record_index(self, index):
        return index // self.rpb * self.rpb

    def _get_record_index_by_block(self, index):
        return index * self.rpb

    def _get_block_value_range(self, index):
        range_ = self._get_block_index_range(index)

        return {
            'min': self._get_record(range_['start'])['key'],
            'max': self._get_record(range_['end'  ])['key']
        }

    def _get_block_index_range(self, index):
        start = index * self.rpb

        l = start
        h = start + self.rpb - 1

        if h == -1:
            return {'start': 0, 'end': -1}

        while True:
            if l in (h - 1, h):
                break

            m = (l + h) // 2

            if not self._is_record_used(m):
                h = m - 1
            else:
                l = m

        end = h if self._is_record_used(h) else (l if self._is_record_used(l) else -1)

        return {'start': start, 'end': end}

    def _get_block_records_count(self, index):
        range_ = self._get_block_index_range(index)

        return range_['end'] - range_['start'] + 1

    def _get_all_blocks_index_range(self):
        l = 0
        h = self.fm.Size() // (self.recordSize * self.rpb) - 1

        if h == -1:
            return {'start': 0, 'end': -1}

        while True:
            if l in (h - 1, h):
                break

            m = (l + h) // 2

            if not self._is_block_used(m):
                h = m - 1
            else:
                l = m

        end = h if self._is_block_used(h) else l

        return {'start': 0, 'end': end}

    def _blocks_count(self):
        end_index = self._get_all_blocks_index_range['end']

        return end_index + 1

    # advanced operations

    def _redistribute_after_remove(self, index):
        all_blocks_range = self._get_all_blocks_index_range()

        if not (index < all_blocks_range['end']):
            print('It is end')
            return

        if not (self._get_block_records_count(index) == 0):
            print('More zero')
            return

        next_block_index = index + 1
        while next_block_index <= all_blocks_range['end']:
            print('Iter')

            next_block_range = self._get_block_index_range(next_block_index)
            next_block_records = []

            for i in range(next_block_range['start'], next_block_range['end'] + 1):
                record = self._get_record(i)

                key = record['key']
                id_ = record['id']

                next_block_records += [{'key': key, 'id': id_}]
            
            two_blocks_records_count = DistributeTwoBlocksCounts(len(next_block_records))

            block_new_length = two_blocks_records_count['first']
            next_block_new_length = two_blocks_records_count['second']

            block_record_index = self._get_record_index_by_block(index)
            next_block_record_index = self._get_record_index_by_block(next_block_index)

            for i in range(64):
                self._set_record(next_block_record_index + i, bytes([]), bytes([]))

            i = 0
            for j in range(block_new_length):
                record = next_block_records[i]
                self._set_record(block_record_index + j, record['key'], record['id'])

                i += 1

            for j in range(next_block_new_length):
                record = next_block_records[i]
                self._set_record(next_block_record_index + j, record['key'], record['id'])

                i += 1

            next_block_index += 1
            index += 1

    def _balance_blocks(self, block_1, block_2):
        pass
