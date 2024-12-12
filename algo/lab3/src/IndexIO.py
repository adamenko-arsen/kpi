import FileMapper
import ZTStrUtils

import math

_get_iters_count = 0

class IndexIO:
    keySize = 12
    pkeySize = 4
    recordSize = 16
    recsPerBlock = 64
    blockSize = 1024

    def __init__(self, filename, load_factor=0.75):
        self.fm = FileMapper.FileMapper(filename, cache_size=1024)

        self.filename = filename
        self.load_factor = load_factor

    def Get(self, key) -> bytes | None:
        global _get_iters_count
        _get_iters_count = 0

        search_data = self._get_info_by_key(key)

        if search_data == None:
            return None

        records = search_data['records']
        index = search_data['record_index']

        return records[index]['pkey']

    def Add(self, key, pkey):
        pkey = ZTStrUtils.GetToStrZTPadded(pkey, self.pkeySize)

        if self._get_info_by_key(key) != None:
            return

        if self._blocks_count() == 0:
            new_block = [{'key': key, 'pkey': pkey}]
            self._set_block(0, new_block)

            return

        low = 0
        high = self._blocks_count() - 1

        for _ in range(64):
            med = (low + high) // 2

            if med < 0:
                med = 0
                break

            if med >= self._blocks_count():
                med = self._blocks_count() - 1
                break

            block = self._get_block(med)
            bmm = self._get_block_minmax(block)

            if key < bmm['min']:
                high = med - 1
            elif     bmm['max'] < key:
                low  = med + 1
            else:
                break

        if med != self._blocks_count() - 1:
            if len(block) + 1 <= self.recsPerBlock:
                block += [{'key': key, 'pkey': pkey}]
                block.sort(key = lambda x: x['key'])

                self._set_block(med, block)

                return

            block += [{'key': key, 'pkey': pkey}]
            block.sort(key = lambda x: x['key'])

            tmp_filename = self.filename + '.tmp'

            with open(tmp_filename, 'wb') as tmp_file:
                for bi in range(self._blocks_count()):
                    if bi == med:
                        iter_recs = block
                    else:
                        iter_recs = self._get_block(bi)

                    for r in iter_recs:
                        key = ZTStrUtils.GetToStrZTPadded(r['key'], self.keySize)
                        pkey = r['pkey']

                        pair = key + pkey

                        tmp_file.write(pair)

                self.fm.WipeData()

            with open(tmp_filename, 'rb') as tmp_file:
                bid = 0
                records = []

                while (raw_record := tmp_file.read(self.recordSize)):
                    key = ZTStrUtils.GetFromBytesZT(raw_record[:self.keySize])
                    pkey = raw_record[self.keySize:]

                    if not self._is_load_factor_keep(len(records) + 1):
                        self._set_block(bid, records)

                        records = []
                        bid += 1

                    records += [{'key': key, 'pkey': pkey}]

                if records:
                    self._set_block(bid, records)
            
            with open(tmp_filename, 'wb'): pass

            return

        if med == self._blocks_count() - 1:
            if self._is_load_factor_keep(len(block) + 1):
                block += [{'key': key, 'pkey': pkey}]
                block.sort(key = lambda x: x['key'])

                self._set_block(med, block)

                return

            new_block = [{'key': key, 'pkey': pkey}]
            self._set_block(med + 1, new_block)

            return

    def Remove(self, key):
        search_data = self._get_info_by_key(key)

        if search_data == None:
            return

        records = search_data['records']
        block = search_data['block_index']

        new_records = []

        for r in records:
            if r['key'] == key:
                continue

            new_records += [r]

        if len(new_records) != 0:
            return

        if block == self._blocks_count() - 1 and len(new_records) == 0:
            self._pop_block()
            return

        next_block = block + 1
        while next_block < self._blocks_count():
            next_records = self._get_block(next_block)

            first_part_len = math.ceil(len(next_records) / 2)

            first_part = next_records[:first_part_len]
            second_part = next_records[first_part_len:]

            self._set_block(block, first_part)
            self._set_block(next_block, second_part)

            next_block += 1
            block += 1

            if len(second_part) != 0:
                break

        if len(second_part) == 0:
            self._pop_block()

    def Wipe(self):
        self.fm.WipeData()

    def Sync(self):
        self.fm._write_cache()

    def _is_load_factor_keep(self, new_count):
        return new_count / self.recsPerBlock < self.load_factor

    def _get_info_by_key(self, key):
        global _get_iters_count

        if self._blocks_count() == 0:
            return None

        low = 0
        high = self._blocks_count() - 1

        for _ in range(64):
            _get_iters_count += 1

            med = (low + high) // 2

            if not (0 <= med < self._blocks_count()):
                return None

            block = self._get_block(med)
            bmm = self._get_block_minmax(block)

            if key < bmm['min']:
                high = med - 1
            elif     bmm['max'] < key:
                low  = med + 1
            else:
                break

        index = self._get_key_index_in_block(block, key)

        if index == None:
            return None
        
        return {
            'records': block,
            'block_index': med,
            'record_index': index
        }

    def _get_block_minmax(self, records):
        keys = [r['key'] for r in records]

        return {'min': min(keys), 'max': max(keys)}

    def _get_key_index_in_block(self, records, key):
        for i, v in enumerate(records):
            if v['key'] == key:
                return i

        return None

    # return only non null keys and their pkeys
    def _get_block(self, index):
        if not (0 <= index < self._blocks_count()):
            return None

        data = self.fm.ReadMany(self.blockSize * index, self.blockSize)

        records = []

        for i in range(self.recsPerBlock):
            key = ZTStrUtils.GetFromBytesZT(data[i * self.recordSize:i * self.recordSize + self.keySize])
            pkey = data[i * self.recordSize + self.keySize:i * self.recordSize + self.keySize + self.pkeySize]

            if key == bytes():
                continue

            records += [{'key': key, 'pkey': pkey}]

        return records

    def _set_block(self, index, records):
        for i, v in enumerate(records):
            key = ZTStrUtils.GetToStrZTPadded(v['key'], self.keySize)
            pkey = v['pkey']

            pair = key + pkey

            self.fm.WriteMany(index * self.blockSize + i * self.recordSize, pair)

        for i in range(len(records), self.recsPerBlock):
            self.fm.WriteMany(index * self.blockSize + i * self.recordSize, bytes(16))

    def _pop_block(self):
        count = self._blocks_count()

        if not (count >= 1):
            return

        self.fm.Shrink((count - 1) * self.blockSize)

    def _blocks_count(self):
        return self.fm.Size() // self.blockSize
