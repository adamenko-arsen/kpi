#include <iostream>
#include <fstream>
#include <vector>
#include <cstring>
#include <stdexcept>
#include <cstdint>
#include <filesystem>
#include <cmath>

std::vector<char> IntToRaw(std::int64_t value, std::size_t intSize)
{
    std::vector<char> raw(intSize);

    for (std::size_t i = 0; i < intSize; ++i)
    {
        raw[i] = (value >> (i * 8)) & 0xFF;
    }
    return raw;
}

std::int64_t RawToInt(const std::vector<char>& raw)
{
    std::int64_t value = 0;

    for (std::size_t i = 0; i < raw.size(); ++i)
    {
        value |= (static_cast<int64_t>(static_cast<unsigned char>(raw[i])) << (i * 8));
    }
    return value;
}

std::size_t GetFileSize(const std::string& fileName)
{
    return std::filesystem::file_size(fileName);
}

void CreateIntArrayFile(const std::string& fileName, std::size_t length, std::size_t intSize)
{
    std::ofstream file(fileName, std::ios::binary);
    std::vector<char> zeroBytes(intSize, 0);

    for (std::size_t i = 0; i < length; ++i)
    {
        file.write(zeroBytes.data(), intSize);
    }
}

class RWIntArrayFile
{
private:
    std::string fileName;
    std::size_t length;
    std::size_t intSize;
    std::size_t blockSize;

    std::size_t blockSizeMask;
    std::size_t blockSizeBitShift;
    std::size_t blockSizeMulIntSize;

    std::vector<char> cache;
    int64_t cache_start_index;
    std::size_t cache_size;

    std::ifstream readFile;
    std::ofstream writeFile;

    void CloseReadFile()
    {
        if (readFile.is_open())
        {
            readFile.close();
        }
    }

    void CloseWriteFile()
    {
        if (writeFile.is_open())
        {
            writeFile.close();
        }
    }

    void OpenReadFile() {
        if (!readFile.is_open())
        {
            CloseWriteFile();

            readFile.open(fileName, std::ios::in | std::ios::binary);
            if (!readFile.is_open())
            {
                throw std::runtime_error("Failed to open file for reading");
            }
        }
    }

    void OpenWriteFile() {
        if (!writeFile.is_open())
        {
            CloseReadFile();

            writeFile.open(fileName, std::ios::in | std::ios::out | std::ios::binary);
            if (!writeFile.is_open())
            {
                throw std::runtime_error("Failed to open file for writing");
            }
        }
    }

public:
    RWIntArrayFile(
          const std::string& fileName
        , std::size_t length
        , std::size_t intSize
        , std::size_t blockSize = 4096
    )
        :
              fileName(fileName)
            , length(length)
            , intSize(intSize)
            , blockSize(blockSize)
            , cache(blockSize * intSize)
            , cache_start_index(-1)
            , cache_size(0)
    {
        if (!(blockSize > 0 && (blockSize & (blockSize - 1)) == 0))
        {
            throw std::invalid_argument("Block size must be a power of 2");
        }

        if (! (blockSize / intSize * intSize == blockSize))
        {
            throw std::invalid_argument("Block size has to be divided by the size of integers of an array in a file");
        }

        blockSizeMask = blockSize - 1;
        blockSizeBitShift = static_cast<std::size_t>(std::log2(blockSize));
        blockSizeMulIntSize = intSize << blockSizeBitShift;

        OpenReadFile();
    }

    ~RWIntArrayFile()
    {
        FlushCache();
        CloseReadFile();
        CloseWriteFile();
    }

    void FlushCache()
    {
        if (cache_start_index == -1) return;

        OpenWriteFile();

        writeFile.seekp(cache_start_index * blockSizeMulIntSize, std::ios::beg);
        writeFile.write(cache.data(), cache_size);
        writeFile.flush();

        cache_start_index = -1;
        cache_size = 0;

        CloseWriteFile();
    }

    void LoadBlock(std::size_t block_index)
    {
        OpenReadFile();

        readFile.seekg(block_index * blockSizeMulIntSize, std::ios::beg);
        readFile.read(cache.data(), blockSizeMulIntSize);

        cache_size = readFile.gcount();
        cache_start_index = block_index;

        CloseReadFile();
    }

    std::size_t GetCacheOffset(std::size_t index)
    {
        return (index & blockSizeMask) * intSize;
    }

    std::int64_t GetInt(std::size_t index)
    {
        std::size_t block_index = index >> blockSizeBitShift;
        std::size_t offset = GetCacheOffset(index);

        if (cache_start_index != static_cast<int64_t>(block_index))
        {
            FlushCache();
            LoadBlock(block_index);
        }

        std::vector<char> rawInt(cache.begin() + offset, cache.begin() + offset + intSize);
        return RawToInt(rawInt);
    }

    void SetInt(std::size_t index, int64_t value)
    {
        std::size_t block_index = index >> blockSizeBitShift;
        std::size_t offset = GetCacheOffset(index);

        if (cache_start_index != static_cast<int64_t>(block_index))
        {
            FlushCache();
            LoadBlock(block_index);
        }

        auto rawIntBytes = IntToRaw(value, intSize);
        std::copy(rawIntBytes.begin(), rawIntBytes.end(), cache.begin() + offset);

        cache_start_index = block_index;
    }

    std::size_t Length() const
    {
        return length;
    }

    std::size_t IntSize() const
    {
        return intSize;
    }
};

void MergeAt(RWIntArrayFile& m, RWIntArrayFile& l, RWIntArrayFile& r, std::size_t chk, std::size_t m_idx, std::size_t l_beg, std::size_t l_sz, std::size_t r_beg, std::size_t r_sz)
{
    std::size_t l_idx = l_beg;
    std::size_t r_idx = r_beg;

    while ((l_idx < l_sz && l_idx - l_beg < chk) && (r_idx < r_sz && r_idx - r_beg < chk))
    {
        int64_t l_val = l.GetInt(l_idx);
        int64_t r_val = r.GetInt(r_idx);

        if (l_val <= r_val)
        {
            m.SetInt(m_idx++, l_val);
            l_idx++;
        }
        else
        {
            m.SetInt(m_idx++, r_val);
            r_idx++;
        }
    }

    while (l_idx < l_sz && l_idx - l_beg < chk)
    {
        m.SetInt(m_idx++, l.GetInt(l_idx++));
    }

    while (r_idx < r_sz && r_idx - r_beg < chk)
    {
        m.SetInt(m_idx++, r.GetInt(r_idx++));
    }
}

void SortAtScale(RWIntArrayFile& m, RWIntArrayFile& l, RWIntArrayFile& r, std::size_t c)
{
    std::size_t s = m.Length();

    std::size_t ls = 0;
    std::size_t rs = 0;

    for (std::size_t i = 0; i < s; ++i)
    {
        std::size_t lrChoice = (i / c) & 1;

        std::size_t blockOffset = i / (2 * c) * c;
        std::size_t index = i % c;

        (lrChoice == 0 ? l : r).SetInt(blockOffset + index, m.GetInt(i));

        if (lrChoice == 0) 
        {
            ls++;
        }
        else
        {
            rs++;
        }
    }

    std::size_t m_idx = 0;
    std::size_t lr_idx = 0;

    while (m_idx < s)
    {
        MergeAt(m, l, r, c, m_idx, lr_idx, ls, lr_idx, rs);
        m_idx += 2 * c;
        lr_idx += c;
    }
}

void DirectMergeSort(RWIntArrayFile& m, RWIntArrayFile& l, RWIntArrayFile& r)
{
    std::size_t s = m.Length();
    std::size_t c = 1;
    while (c < s)
    {
        SortAtScale(m, l, r, c);
        c *= 2;
    }
}

int main()
{
    constexpr std::size_t BlockSize = 1 * (1 << 20);
    constexpr std::size_t IntSize = 8;

    std::size_t Length = GetFileSize("A.qwa") / IntSize;

    CreateIntArrayFile("B.qwa", Length, IntSize);
    CreateIntArrayFile("C.qwa", Length, IntSize);

    RWIntArrayFile mainFile("A.qwa", Length, IntSize, BlockSize);
    RWIntArrayFile leftFile("B.qwa", Length, IntSize, BlockSize);
    RWIntArrayFile rightFile("C.qwa", Length, IntSize, BlockSize);

    DirectMergeSort(mainFile, leftFile, rightFile);

    mainFile.FlushCache();
    leftFile.FlushCache();
    rightFile.FlushCache();

    return 0;
}
