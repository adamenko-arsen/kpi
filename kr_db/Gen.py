import random

def Sep(c, m):
    return ';' if c == m - 1 else ','

def SepTwoLvls(c1, m1, c2, m2):
    return ';' if c1 == m1 - 1 and c2 == m2 - 1 else ','

def GetDepartmentName():
    c = random.choice
    return c(DEPARTMENT_FIRST_NAMES) + ' ' + c(DEPARTMENT_SECOND_NAMES) + ' of ' + c(DEPARTMENT_THIRD_NAMES)

def GetDepartmentAddress():
    c = random.choice
    d = '0123456789'
    l = 'abcdefghijklmnopqrstuvwxyz'

    match random.choice([0, 1, 2]):
        case 0:
            name = c(l) + c(l) + '-' + c(d) + c(d) + c(d) + c(d)
        case 1:
            name = c(d) + c(l) + c(l) + '/' + c(d) + c(d) + c(l) + c(l)
        case 2:
            name = c(d) + c(d) + ':' + c(l) + c(l) + ':' + c(d) + c(d)

    return 'Str. ' + name

def GetDescription():
    c = random.choice

    l = 'abcdefghijklmnopqrstuvwxyz'

    return c(l).upper() + ''.join(c(l) for _ in range(random.randint(8, 24)))

def GetFIO():
    c = random.choice
    return c(FIRST_NAMES) + ' ' + c(LAST_NAMES) + ' ' + c(EXTRA_NAMES)

def GetPhone():
    c = random.choice
    d = '0123456789'

    return '+380' + ''.join(c(d) for _ in range(9))

def GetEmail():
    c = random.choice
    dom = ['gmail.com', 'ukr.net', 'i.ua']
    dl = '0123456789abcdefghijklmnopqrstuvwxyz'

    return ''.join(c(dl) for _ in range(random.randint(4, 18))) + '@' + c(dom)

def GetCallType():
    type_ = ['bad news', 'good news', 'important', 'casual', 'info', 'warning']

    return random.choice(type_)

def GetRating():
    return random.randint(RATING_RANGE['min'], RATING_RANGE['max'])

def GetDepartmentID():
    return random.randint(1, DEPARTMENTS_COUNT)

def GetCallID():
    return random.randint(1, CALLS_COUNT)

def GetClientID():
    return random.randint(1, CLIENTS_COUNT)

def GetOperatorID():
    return random.randint(1, OPERATORS_COUNT)

def GetRequestID():
    return random.randint(1, REQUESTS_COUNT)

def GetStartDate():
    c = random.choice
    year = [str(i) for i in range(2022, 2024 + 1)]
    month = [f'{i:0>2}' for i in range(1, 12 + 1)]
    day = [f'{i:0>2}' for i in range(1, 28 + 1)]

    return c(day) + '.' + c(month) + '.' + c(year)

def GetDuration():
    return random.randint(CALL_DURATION_RANGE['min'], CALL_DURATION_RANGE['max'])

def GetIsResolvedIncident():
    return 'true' if random.uniform(0, 1) < 0.8 else 'false'

def GetShedule():
    c = random.choice
    return f"'{c(SHIFT_DATE)}', '{c(SHIFT_TYPE)}'"

FIRST_NAMES = [
	'John', 'Ammy', 'Alis', 'Bohdan', 'Emma', 'Mia', 'Ilya', 'Dmytriy', 'Ivan', 'Alex', 'Max', 'Nik', 'Peter', 'Anna', 'Parker', 'Yarik', 'Fil', 'Volodymyr', 'Evgen', 'Veronika', 'Anastasia', 'Egor', 'Vlad', 'Filch', 'Yuriy', 'Danya', 'Denys', 'Kiril', 'Borya', 'Andrii', 'Sergii', 'Vanya', 'Petrov', 'Kozak', 'Michael'
]
LAST_NAMES = [
	'Ivanov', 'Petrov', 'Bolcunov', 'Shevchuk', 'Abramovich', 'Kozel', 'Bucasov', 'Kovtunets', 'Lis', 'Bandura', 'Sokol', 'Flintstone', 'Simpson', 'Havok', 'Yurievich', 'Rurikov', 'Zelev', 'Vesta', 'Braga', 'Popov', 'Urchikov', 'Beredyanov', 'Avenmu', 'Isekai', 'Animeita'
]
EXTRA_NAMES = [
	'Johny', 'Ammi', 'Alisie', 'Bohdan', 'Emmy', 'Miy', 'Ilyavich', 'Dmytriyvich', 'Ivanich', 'Alexa', 'Maxik', 'Nikik', 'Petervich', 'Anny', 'Parky', 'Yarikov', 'Filli', 'Volodymyrovich', 'Evgenich', 'Veronikavna', 'Anastasiavna', 'Egorich', 'Vladik', 'Filchik', 'Yuriyevich', 'Danyachik', 'Denchik', 'Kirush',
	
	'Anatoliyovych', 'Bohdanovych', 'Vasylovych', 'Hennadiyovych', 'Dmytrovych', 'Yevhenovych', 'Ihorovych', 'Kostiantynovych', 'Leonidovych', 'Maxymovych', 'Mykhailovych', 'Oleksandrovych', 'Petrovych', 'Romanivych', 'Serhiyovych', 'Tymofiyovych', 'Fedorovych', 'Yuriyovych', 'Yaroslavovych', 'Viktorovych', 'Artemovych', 'Valentynovych', 'Vladyslavovych', 'Volodymyrovych', 'Olehovych', 'Stepanovych', 'Pavlovych', 'Andriyovych', 'Oleksiyovych', 'Kyrylovych', 'Rostyslavovych', 'Vitaliyovych', 'Borysovych', 'Heorhiyovych', 'Adamovych', 'Denysovych', 'Zakharovych', 'Zinoviyovych', 'Ivanovych', 'Illovych', 'Tarasovych', 'Danylovych', 'Arsenovych', 'Antonovych', 'Arkadiyovych', 'Matviyovych', 'Nazariyovych', 'Myroslavovych', 'Stanislavovych', 'Yakovych'
]

DEPARTMENT_FIRST_NAMES = [
	'Powerful', 'Cool', 'Awesome', 'Nice', 'Sharky', 'Mighty', 'Hotty', 'Extracy', 'Nightly', 'Shiny', 'Hiddy'
]
DEPARTMENT_SECOND_NAMES = [
	'Foxes', 'Birds', 'Flies', 'Bees', 'Mantises', 'Beetles', 'Cats', 'Tigers', 'Club', 'Friends', 'Octoples', 'Magicians'
]
DEPARTMENT_THIRD_NAMES = [
	'Destiny', 'Water', 'Fire', 'Business', 'Pray', 'Happiness', 'Goddamns'
]

DEPARTMENTS_COUNT = 10
OPERATORS_COUNT = DEPARTMENTS_COUNT * 10
CLIENTS_COUNT = OPERATORS_COUNT * 5
CALLS_COUNT = CLIENTS_COUNT * 10

CALL_DURATION_RANGE = {'min': 1, 'max': 3600}
MAX_SCHEDULES_COUNT_PER_OPERATOR = 4

FEEDBACK_CHANCE = 0.8
INCIDENT_CHANCE = 0.3
REQUEST_CHANCE = 0.8
REQUEST_RESULT_CHANCE = 0.7

RATING_RANGE = {'min': 0, 'max': 10}
SHIFT_TYPE = [
    'during_morning',
    'during_afternoon',
    'during_evening',
    'during_night'
]

SHIFT_DATE = [
    'every_monday',
    'every_tuesday',
    'every_wednesday',
    'every_fourday',
    'every_friday',
    'every_saturday',
    'every_sunday'
]

REQUESTS_COUNT = int(CALLS_COUNT * REQUEST_CHANCE)
REQUEST_RESULTS_COUNT = int(CALLS_COUNT * REQUEST_CHANCE * REQUEST_RESULT_CHANCE)
INCIDENTS_COUNT = int(OPERATORS_COUNT * INCIDENT_CHANCE)
FEEDBACKS_COUNT = int(CALLS_COUNT * FEEDBACK_CHANCE)

print(f'insert into Department(Name_, Address_, Description_) values')
for i in range(DEPARTMENTS_COUNT):
    print(f"\t('{GetDepartmentName()}', '{GetDepartmentAddress()}', '{GetDescription()}')" + Sep(i, DEPARTMENTS_COUNT))

print()

print(f'insert into Operator(FIO, Department) values')
for i in range(OPERATORS_COUNT):
    print(f"\t('{GetFIO()}', {GetDepartmentID()})" + Sep(i, OPERATORS_COUNT))

print()

print(f'insert into Client(FIO, Phone, Email) values')
for i in range(CLIENTS_COUNT):
    print(f"\t('{GetFIO()}', '{GetPhone()}', '{GetEmail()}')" + Sep(i, CLIENTS_COUNT))

print()

print(f'insert into Call_(Client, Operator, StartDate, Duration) values')
for i in range(CALLS_COUNT):
    print(f"\t({GetClientID()}, {GetOperatorID()}, '{GetStartDate()}', {GetDuration()})" + Sep(i, CALLS_COUNT))

print()

print(f'insert into CallType(Call_, Type_, Description_) values')
for i in range(CALLS_COUNT):
    print(f"\t({1 + i}, '{GetCallType()}', '{GetDescription()}')" + Sep(i, CALLS_COUNT))

print()

used_calls = set()
print(f'insert into Feedback(Client, Call_, Rating, Comment) values')
for i in range(FEEDBACKS_COUNT):
    call_id = GetCallID()

    while call_id in used_calls:
        call_id = GetCallID()

    used_calls.add(call_id)

    print(f"\t({GetClientID()}, {call_id}, {GetRating()}, '{GetDescription()}')" + Sep(i, FEEDBACKS_COUNT))

print()

print(f'insert into Request(Call_, RequestDate, Notes) values')
for i in range(REQUESTS_COUNT):
    print(f"\t({GetCallID()}, '{GetStartDate()}', '{GetDescription()}')" + Sep(i, REQUESTS_COUNT))

print()

print(f'insert into RequestResult(Request, ResolutionDate, Result) values')
for i in range(REQUEST_RESULTS_COUNT):
    print(f"\t({GetRequestID()}, '{GetStartDate()}', '{GetDescription()}')" + Sep(i, REQUEST_RESULTS_COUNT))

print()

print(f'insert into Shedule(Operator, ShiftDate, ShiftType) values')
for i in range(OPERATORS_COUNT):
    count = random.randint(0, MAX_SCHEDULES_COUNT_PER_OPERATOR + 1)

    sheds = [GetShedule() for _ in range(count)]

    sheds = list(set(sheds))

    if len(sheds) >= 1:
        for j, shed in enumerate(sheds):
            print(f'\t({1 + i}, {shed})' + SepTwoLvls(i, OPERATORS_COUNT, j, len(sheds)))

print()

print(f'insert into Incident(Operator, Date_, Description_, IsResolved) values')
for i in range(INCIDENTS_COUNT):
    print(f"\t({GetOperatorID()}, '{GetStartDate()}', '{GetDescription()}', {GetIsResolvedIncident()})" + Sep(i, INCIDENTS_COUNT))
