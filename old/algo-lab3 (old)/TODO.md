# TODO list

1. Implement IndexIO.Add()
  1. Add to end if new key is bigger than any key before and last block is not load out by load factor
  2. Add to next to end if new key is bigger than any key before and last block is load out by load factor
  3. Copy records to other file with a new one and back if not last block is filled out
2. Replace RecordIO direct file operations with FileMapper
3. Write a GUI wrapper
