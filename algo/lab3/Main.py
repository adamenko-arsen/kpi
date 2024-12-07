import tkinter as tk
import IndexIO
import RecordIO
import IntBytesConvert

if __name__ == '__main__':
    load_factor = 0.7

    db_path = 'db'

    idx_filename = 'index.bin'
    rec_filename = 'record.bin'

    idx_io = None
    rec_io = None

def clrmsg_btn_handler():
    global messages_console

    messages_console.delete(1.0, tk.END)

def messages_add_line(line):
    global messages_console

    messages_console.insert(tk.END, line + '\n')

def load_db_btn_handler():
    global db_name_entry
    global db_in_use_value

    global db_path, idx_io, rec_io

    db_path = db_name_entry.get()

    db_in_use_value.config(text=db_path + '/*')

    idx_io = IndexIO.IndexIO(db_path + '/' + idx_filename)
    rec_io = RecordIO.RecordIO(db_path + '/' + rec_filename)

    messages_add_line(f'Було завантажено БД по шляху {db_path}')

def wipe_db_btn_handler():
    global idx_io, rec_io

    if not (idx_io != None):
        messages_add_line('Немає індексного файлу')
        return
    
    if not (rec_io != None):
        messages_add_line('Немає записного файлу')
        return

    idx_io.Wipe()
    rec_io.Wipe()

    messages_add_line('БД була повністю очищена')

def win_on_exit():
    global idx_io, rec_io

    if idx_io != None:
        idx_io.Sync()
    
    if rec_io != None:
        rec_io.Sync()

    win.destroy()

def get_btn_handler():
    global idx_io, rec_io
    global key_value_entry

    if not (idx_io != None):
        messages_add_line('Немає індексного файлу')
        return
    
    if not (rec_io != None):
        messages_add_line('Немає записного файлу')
        return

    key = key_value_entry.get()
    raw_id_info = idx_io.Get(key.encode('ascii'))

    if not (raw_id_info != None):
        messages_add_line(f'Немає такого ключа як <{key}>')
        return

    iters = raw_id_info['iters']
    id_ = IntBytesConvert.BytesToUint(raw_id_info['id'])

    messages_add_line(f'По ключу <{key}> було отримано значення <{rec_io.Get(id_)}> за <{iters}> ітерацій')

def add_btn_handler():
    global idx_io, rec_io
    global key_value_entry
    global content_value_value

    if not (idx_io != None):
        messages_add_line('Немає індексного файлу')
        return
    
    if not (rec_io != None):
        messages_add_line('Немає записного файлу')
        return

    key  = key_value_entry.get()
    raw_key = key.encode('ascii')

    if not (idx_io.Get(raw_key) == None):
        messages_add_line(f'Такий ключ як <{key}> вже існує')
        return

    data = content_value_value.get()

    id_ = rec_io.Add(data)

    raw_id = IntBytesConvert.UintToBytes(id_, 4)

    idx_io.Add(raw_key, raw_id)

    messages_add_line(f'Пара ключ-значення <{key}>/<{data}> були додані')

def remove_btn_handler():
    global idx_io, rec_io
    global key_value_entry

    if not (idx_io != None):
        messages_add_line('Немає індексного файлу')
        return
    
    if not (rec_io != None):
        messages_add_line('Немає записного файлу')
        return

    key  = key_value_entry.get()
    raw_key = key.encode('ascii')

    if not (idx_io.Get(raw_key) != None):
        messages_add_line(f'Такий ключ як <{key}> не існує')
        return

    idx_io.Remove(raw_key)

    messages_add_line(f'Ключ <{key}> та його значення було видалено')

def add_10000_btn_handler():
    global idx_io, rec_io

    if not (idx_io != None):
        messages_add_line('Немає індексного файлу')
        return
    
    if not (rec_io != None):
        messages_add_line('Немає записного файлу')
        return

    messages_add_line('Початок процесу зарахування 10000 абітурієнтів')

    for i in range(10000):
        key  = f'{i:0>6}'.encode('ascii')
        id_  = IntBytesConvert.UintToBytes(i, 4)
        data = str(i) + '=' + hex(i)

        idx_io.Add(key, id_)
        rec_io.Add(data)

    messages_add_line('Було зараховано 10000 абітурієнтів')

if __name__ == '__main__':
    win = tk.Tk()
    win.title('Лабораторна робота №3')

    win_padding = tk.Frame(win, padx=8, pady=8)
    win_padding.grid(row=0, column=0, sticky='nsew')

    win.protocol("WM_DELETE_WINDOW", win_on_exit)

    title_label = tk.Label(
        win_padding,
        text='Система управління базами даних',
        justify='center'
    )
    title_label.grid(row=0, column=0, columnspan=3, sticky='nsew')

    load_db_btn = tk.Button(
        win_padding,
        text='Обрати БД',
        justify='center',
        command=load_db_btn_handler
    )
    load_db_btn.grid(row=1, column=0, sticky='nsew')

    db_name_entry = tk.Entry(
        win_padding,
        justify='center'
    )
    db_name_entry.grid(row=1, column=1, sticky='nsew')

    db_in_use_desc = tk.Label(
        win_padding,
        text='Шляюх до БД:',
        justify='center'
    )
    db_in_use_desc.grid(row=2, column=0, sticky='nsew')

    db_in_use_value = tk.Label(
        win_padding,
        text='<БД не відкрита>',
        justify='center'
    )
    db_in_use_value.grid(row=2, column=1, sticky='nsew')

    # Massive operations

    wipe_db_btn = tk.Button(
        win_padding,
        text='Стерти всю БД',
        justify='center',
        command=wipe_db_btn_handler
    )
    wipe_db_btn.grid(row=3, column=0, sticky='nsew')

    add_10000_btn = tk.Button(
        win_padding,
        text='Зарахувати 10000 абітурів',
        justify='center',
        command=add_10000_btn_handler
    )
    add_10000_btn.grid(row=4, column=0, sticky='nsew')

    # Inputs

    key_value_desc = tk.Label(
        win_padding,
        text='Ключ:',
        justify='center'
    )
    key_value_desc.grid(row=5, column=0, sticky='nsew')

    key_value_entry = tk.Entry(
        win_padding,
        justify='center'
    )
    key_value_entry.grid(row=5, column=1, sticky='nsew')

    # ---

    content_value_desc = tk.Label(
        win_padding,
        text='Дані:',
        justify='center'
    )
    content_value_desc.grid(row=6, column=0, sticky='nsew')

    content_value_value = tk.Entry(
        win_padding,
        justify='center'
    )
    content_value_value.grid(row=6, column=1, sticky='nsew')

    # Manipluate DB

    get_btn = tk.Button(
        win_padding,
        text='Отримати',
        justify='center',
        command=get_btn_handler
    )
    get_btn.grid(row=7, column=0, sticky='nsew')

    add_btn = tk.Button(
        win_padding,
        text='Додати',
        justify='center',
        command=add_btn_handler
    )
    add_btn.grid(row=8, column=0, sticky='nsew')

    remove_btn = tk.Button(
        win_padding,
        text='Видалити',
        justify='center',
        command=remove_btn_handler
    )
    remove_btn.grid(row=9, column=0, sticky='nsew')

    clrmsg_btn = tk.Button(
        win_padding,
        text='Очистити повідомлення',
        justify='center',
        command=clrmsg_btn_handler
    )
    clrmsg_btn.grid(row=10, column=0, sticky='nsew')

    # Messages

    messages_console = tk.Text(
        win_padding
    )
    messages_console.grid(row=1, column=2, rowspan=10, sticky='nsew')

    tk.mainloop()
