Ambi.General.CreateModule( 'DarkRP', '2.0.1', 'https://steamcommunity.com/id/titanovsky/' )

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.restrict_can_suicide = false -- Можно умирать через kill?

Ambi.DarkRP.Config.restrict_entities_freeze_on_spawn = true -- Пропы при спавне замораживаются?
Ambi.DarkRP.Config.restrict_entities_nocollide_between = true -- Пропы не будут иметь коллизию с друг другом?
Ambi.DarkRP.Config.restrict_entities_nocollide_on_physgun_use = true -- Проп будет становится без коллизий, когда его берут физганом

-- 0: Доступно всем
-- 1: Доступно особым рангам
-- 2: Доступно только супер админу (консоли)
Ambi.DarkRP.Config.restrict_spawn_props = 0 -- Запреты на спавн Пропов
Ambi.DarkRP.Config.restrict_spawn_ragdolls = 2 -- Запреты на спавн Рэгдоллов
Ambi.DarkRP.Config.restrict_spawn_effects = 2 -- Запреты на спавн Эффектов
Ambi.DarkRP.Config.restrict_spawn_entities = 2 -- Запреты на спавн Энтити
Ambi.DarkRP.Config.restrict_spawn_weapons = 2 -- Запреты на спавн/выдачу Оружия
Ambi.DarkRP.Config.restrict_spawn_npcs = 2 -- Запреты на спавн NPC
Ambi.DarkRP.Config.restrict_spawn_vehicles = 2 -- Запреты на спавн Транспортных Средств
Ambi.DarkRP.Config.restrict_use_properties = 2 -- Запреты на использования функций из С меню (Свойства)
Ambi.DarkRP.Config.restrict_use_tools = 0 -- Запреты на использование Тулгана
Ambi.DarkRP.Config.restrict_use_flashlight = 0 -- Запреты на использование Фонарика
Ambi.DarkRP.Config.restrict_use_noclip = 2 -- Запреты на полёт в NoClip (не путайте с ноуклипом из админок)
Ambi.DarkRP.Config.restrict_use_mass_unfreeze_physgun = 1 -- Запреты на массовый расфриз через R
Ambi.DarkRP.Config.restrict_use_unfreeze_physgun = 1 -- Запреты на расфриз
Ambi.DarkRP.Config.restrict_use_punt_gravgun = 1 -- Запреты на бросок с помощью гравити гана
Ambi.DarkRP.Config.restrict_usergroups = { -- Ранги, на которых не действует запрет
    -- [ 'в кавычках название ранга' ] = true, -- запятую не забывайте!
    [ 'superadmin' ] = true,
    [ 'root' ] = true,
    [ 'owner' ] = true,
}
Ambi.DarkRP.Config.restrict_properties = { -- Свойства, которые будут запрещены в любом случае
    [ 'ignite' ] = true, -- Поджечь
    [ 'kinectcontroll' ] = true, -- Управление с помощью Кинекта, через него можно крашнуть сервер
}
Ambi.DarkRP.Config.restrict_tools = { -- Инструменты, которые будут запрещены в любом случае
    [ 'weld' ] = true,
    [ 'rope' ] = true, 
    [ 'axis' ] = true,
    [ 'ballsocket' ] = true,
    [ 'duplicator' ] = true,
    [ 'balloons' ] = true,
    [ 'dynamite' ] = true,
}

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.chat_restrict_enable = true -- Включить ограничения для чата (Максимальное расстояние, чтобы видеть сообщения от других други)
Ambi.DarkRP.Config.chat_voice_local_enable = true -- Включить ограничения для голосового чата (Максимальное расстояние, чтобы слышать других)
Ambi.DarkRP.Config.chat_max_length = 720 -- Максимальня длина, при которой можно увидеть сообщения (чатовые) других игроков. В юнитах

Ambi.DarkRP.Config.chat_max_length_whisper = 350 -- Максимальня длина, при которой можно увидеть сообщения (чатовые) других игроков, через команду /w. В юнитах
Ambi.DarkRP.Config.chat_max_length_scream = 1000 -- Максимальня длина, при которой можно увидеть сообщения (чатовые) других игроков, через команду /s. В юнитах
Ambi.DarkRP.Config.chat_title_whisper = '[Шёпот]' -- Когда человек сказал шёпотом, перед ником какая фраза будет?
Ambi.DarkRP.Config.chat_title_scream = '[Крик]' -- Когда человек крикнул, перед ником какая фраза будет?

Ambi.DarkRP.Config.chat_voice_max_length = 720 -- Максимальня длина, при которой можно услышать других игроков. В юнитах
Ambi.DarkRP.Config.chat_voice_3d = false -- Войс будет в формате 3D? 

Ambi.DarkRP.Config.chat_commands_color_me = Color( 203, 125, 242) -- Цвет для команды /me
Ambi.DarkRP.Config.chat_commands_color_try = Color( 203, 125, 242) -- Цвет для команды /try
Ambi.DarkRP.Config.chat_commands_color_do = Color( 238, 238, 238) -- Цвет для команды /do
Ambi.DarkRP.Config.chat_commands_color_ooc = Color( 240, 240, 240) -- Цвет для команды /ooc и //
Ambi.DarkRP.Config.chat_commands_color_looc = Color( 255, 255, 255) -- Цвет для команды /looc
Ambi.DarkRP.Config.chat_commands_color_whisper = Color( 220, 220, 220) -- Цвет для команды /w и /whisper
Ambi.DarkRP.Config.chat_commands_color_scream = Color( 162, 230, 153) -- Цвет для команды /s и /scream
Ambi.DarkRP.Config.chat_create_commands = { -- Создать чатовые команды для коммуникаций. Ненужным просто поставить false
    [ '/me' ] = true, -- Действие от первого лица
    [ '/try' ] = true, -- Действие, которое может завершится Удачно/Неудачно (шанс 50 на 50)
    [ '/do' ] = true, -- Действие от третьего лица
    [ '/ooc' ] = true, -- Глобальный Неигровой чат, видят все
    [ '//' ] = true, -- ==> /ooc
    [ '/looc' ] = true, -- Локальный Неигровой чат, длина такая же, как у chat_max_length
    [ '/w' ] = true, -- Тихий чат в малом радиусе (Шёпот)
    [ '/whisper' ] = true, -- ==> /w
    [ '/s' ] = true, -- Громкий чат в большом радиусе (Крик)
    [ '/scream' ] = true, -- ==> /s
}

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.player_base_health = 100 -- Здоровье
Ambi.DarkRP.Config.player_base_max_health = 100 -- Максимальное Здоровье
Ambi.DarkRP.Config.player_base_armor = 0 -- Броня 
Ambi.DarkRP.Config.player_base_max_armor = 255 -- Максимальная Броня 
Ambi.DarkRP.Config.player_base_skin = 0 -- Какой скин будет выдаваться модельки игрока 
Ambi.DarkRP.Config.player_base_scale = 1 -- Размер игрока
Ambi.DarkRP.Config.player_base_material = '' -- Материал на игрока 
Ambi.DarkRP.Config.player_base_walkspeed = 150 -- Скорость ходьбы
Ambi.DarkRP.Config.player_base_runspeed = 300 -- Скорость бега
Ambi.DarkRP.Config.player_base_maxspeed = 150 -- Скорость максимальная
Ambi.DarkRP.Config.player_base_slowwalkspeed = 100 -- Скорость медленного передвижения (alt)
Ambi.DarkRP.Config.player_base_duckspeed = 0.1 -- Скорость приседания (ctrl)
Ambi.DarkRP.Config.player_base_unduckspeed = 0.1 -- Скорость вставания с приседа
Ambi.DarkRP.Config.player_base_crouchedspeed = 0.3 -- Скорость передвижения в приседе (ctrl)
Ambi.DarkRP.Config.player_base_ladderclimbspeed = 200 -- Скорость передвижения по лестнице
Ambi.DarkRP.Config.player_base_jump_power = 200 -- Сила прыжка
Ambi.DarkRP.Config.player_base_give = true -- Включить выдавание игрокам оружия? --![Может конфликтовать с аддонами, где PlayerLoadout]
Ambi.DarkRP.Config.player_base_weapons = {  -- Оружия, которое будет выдаваться при PlayerLoadout
    'weapon_physgun', 
    'weapon_physcannon', 
    'gmod_tool', 
    'keys',
} 

Ambi.DarkRP.Config.player_payday_enable = true -- Включить Систему Получения Зарплаты?
Ambi.DarkRP.Config.player_payday_log = true -- Логгировать в чат о том, что зарплата получена?
Ambi.DarkRP.Config.player_payday_delay = 600 -- Задержка в секундах по выдаче зарплаты 

Ambi.DarkRP.Config.player_fall_damage_enable = true -- Включить систему получения урона от падения?
Ambi.DarkRP.Config.player_fall_damage_divided_by = 14 -- На какое число поделить скорость? Рассчёт урона от падения = Скорость / player_fall_damage_divided_by

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.hunger_enable = true -- Включить/Выключить систему Голода? ( Методы Player:SetSatiety() и Player:SetMaxSatiety() )
Ambi.DarkRP.Config.hunger_satiety_default = 100 -- Уровень сытости игрока при спавне
Ambi.DarkRP.Config.hunger_satiety_max = 100 -- Максимальный уровень сытости игрока при спавне
Ambi.DarkRP.Config.hunger_food_can_use_on_full_satiety = true -- Можно употреблять еду, если игрок полностю сытый?
Ambi.DarkRP.Config.hunger_food_default_value = 25 -- Сколько будет даваться сытости игроку за употребление еды?
Ambi.DarkRP.Config.hunger_food_model = 'models/props_junk/watermelon01.mdl' -- Типичная моделька еды
Ambi.DarkRP.Config.hunger_remove_health = true -- Игроки будут терять здоровье при нулевой сытости?
Ambi.DarkRP.Config.hunger_remove_health_for_admins = false -- Админы и Суперадмины будут терять здоровье при нулевой сытости?
Ambi.DarkRP.Config.hunger_delay = 25 -- Задержка в секундах между вычетом сытости у игрока
Ambi.DarkRP.Config.hunger_minus_satiety = 1 -- Сколько будет вычитаться сытости
Ambi.DarkRP.Config.hunger_minus_health = 2 -- Сколько будет вычитаться здоровья при нулевой сытости

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.rpname_enable = true -- Включить/Выключить систему Игровых Имён? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.rpname_protect = true -- Включить/Выключить фильтрацию имени от запретных и ненужных символов (Ambi.General.Global.Keys.BLACKLIST)
Ambi.DarkRP.Config.rpname_can_use_command = true -- Игроки могут изменить через чатовую команду своё имя?
Ambi.DarkRP.Config.rpname_command = 'rpname' -- Какая команда (чатовая) для того поменять название работы? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.rpname_description = 'Изменить игровое имя' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.rpname_give_random_name = false -- При первом подключений к серверу (когда нет Игрового Имени) оно должно быть выдано?
Ambi.DarkRP.Config.rpname_random_names = { -- Рандомные имена
    'Warren Baffett',
    'Bill Gates',
    'Samuel L. Jackson',
    'Richard Lionheart',
    'Jeff Bezos',
    'Elon Musk',
}  

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.admin_give_guns = true -- Выдать при спавне админских рангам спец. оружия?
Ambi.DarkRP.Config.admin_give_guns_log = false -- Оповещать игрока о том, что ему выдалось админские оружие?
Ambi.DarkRP.Config.admin_guns = { -- Оружия, просто в кавычках класс оружия и в конце запятая
    'weapon_physgun',  
    'gmod_tool', 
    'gmod_camera', 
    'weapon_physcannon' 
}
Ambi.DarkRP.Config.admin_usergroups = { -- Ранги, которые попадают под админы (им будут выдаваться админ оружия)
    [ 'superadmin' ] = true,
    [ 'admin' ] = true,
}

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.jobs_enable = true -- Включить систему Работ?
Ambi.DarkRP.Config.jobs_class = 'TEAM_CITIZEN' -- Класс работы, которая будет даваться при заходе на сервер
Ambi.DarkRP.Config.jobs_respawn = true -- При получений работы респавнить игрока?
Ambi.DarkRP.Config.jobs_default_ammo = true -- При получений оружия у работы, давать стандартное значение патронов (которое указал создатель оружия)?
Ambi.DarkRP.Config.jobs_set_color = true -- При получений работы перекрашивать модель игрока?
Ambi.DarkRP.Config.jobs_random_models = true -- При спавне давать каждый раз случайную модель игроку из списка моделей для его работы?
Ambi.DarkRP.Config.jobs_change_on_chat_command = true -- Можно ли менять профессию через чатовую команду (например: /citizen, /police)
Ambi.DarkRP.Config.jobs_change_on_chat_command_hide = true -- Не отображать чатовые команды для смены профессии после их ввода
Ambi.DarkRP.Config.jobs_can_drop_weapons = false -- Можно выкинуть оружие, которое выдано через работу
Ambi.DarkRP.Config.jobs_delay = 10 -- Задержка появляется после становления на работу. Пока она есть, на другую нельзя встать (Исключение, насильно изменить работу)
Ambi.DarkRP.Config.jobs_can_change_name = true -- Можно ли с помощью команды поменять название работы?
Ambi.DarkRP.Config.jobs_command = 'job' -- Какая команда (чатовая) для того поменять название работы? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.jobs_description = 'Поменять Название Работы' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.jobs_create_defaults = true -- Создать стандартные работы: Гражданин, Полицейский и т.д --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.jobs_default = { -- Стандартные значения для работы, если не присвоены уникальные --![ДАННЫЕ ТАБЛИЦЫ НЕЛЬЗЯ УДАЛЯТЬ]
    name = 'Житель', -- Название профы
    command = 'citizen', -- Чатовая команда --![ДОЛЖНА БЫТЬ УНИКАЛЬНОЙ]
    models = { 'models/player/Group01/male_07.mdl', 'models/player/Group01/female_06.mdl' }, -- Модельки
    max = 0, -- Максимум людей в профе, если 0 то бесконечно
    category = 'Жители',  -- Категория
    color = Color( 59, 188 , 59), -- Цвет
    description = 'Описание отсутствует', -- Описание
    salary = 100, -- Зарплата во время Payday
    admin = 0, -- Админ проверка: 0 - для всех, 1 - для админов, 2 - для супер админов
    vote = false, -- Нужно ли голосование, чтобы стать на работу?
    order = 100, -- По этому числу можно позиционировать профессий, от большего к меньшему (для F4). Аналог: sortOrder
    license = false, -- При спавне будет лицензия? Аналог: hasLicense
    demote = false, -- Можно сделать голосование на увольнение игрока? Аналог: canDemote
    weapons = {}, -- Оружие или Оружия, которые будут выдаваться при спавне
}
Ambi.DarkRP.Config.jobs_vip_ranks = { -- Ранги, которые подходят под параметр vip (смогут взять работу)
    [ 'superadmin' ] = true,
    [ 'admin' ] = true,
    [ 'vip' ] = true,
}
Ambi.DarkRP.Config.jobs_premium_ranks = { -- Ранги, которые подходят под параметр premium (смогут взять работу)
    [ 'superadmin' ] = true,
    [ 'admin' ] = true,
    [ 'premium' ] = true,
}

Ambi.DarkRP.Config.jobs_demote_enable = true -- Включить возможность уволить игрока (Сама техническая функция будет доступна всегда)
Ambi.DarkRP.Config.jobs_demote_can_similar_job = true -- Включить возможность уволить игрока, даже если ты с ним в одной работе
Ambi.DarkRP.Config.jobs_demote_command = 'demote' -- Какая команда (чатовая) для объявления голосования на увольнение игрока? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.jobs_demote_description = 'Уволить Игрока' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.jobs_demote_delay = 10 -- Описание команды
Ambi.DarkRP.Config.jobs_demote_distance = 72 -- Дистанция от игрока, когда на него сработает команда увольнения (через /demote)

Ambi.DarkRP.Config.jobs_permanent_enable = false -- Включить систему Перманентных Работ? (работает, если включена система Работ)
Ambi.DarkRP.Config.jobs_permanent_with_set_job = true -- При смене работы у игрока будет она сохраняться?
Ambi.DarkRP.Config.jobs_permanent_exceptions = { -- Список работ, которые не будут выдаваться навсегда
    -- [ 'в кавычках КЛАСС работы, НЕ НАЗВАНИЕ!!!' ] = true, -- запятую не забудьте!
} 

Ambi.DarkRP.Config.jobs_maker_enable = true -- Включить систему Job Maker? Также будут создаваться сохранённые работы при инициализаций модуля DarkRP --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.jobs_maker_kick_cheaters = true -- Кикать игрока за подозрение в читерстве?
Ambi.DarkRP.Config.jobs_maker_delay = 0 -- Задержка в секунде после инициализаций модуля DarkRP, после которой будут загружатся сохранённые работы и изменения
Ambi.DarkRP.Config.jobs_maker_usergroups = { -- Ранги, которые имеют право вносить Изменения/Добавлять/Удалять в Job Maker
    [ 'superadmin' ] = true,
    [ 'root' ] = true,
    [ 'owner' ] = true,
}

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.shop_enable = true -- Включить Систему Магазина Энтити?
Ambi.DarkRP.Config.shop_create_defaults = true -- Создать стандартные предметы
Ambi.DarkRP.Config.shop_default = { -- Стандартные значения для Предмета, если не присвоены уникальные --![ДАННЫЕ В ТАБЛИЦЕ НЕЛЬЗЯ УДАЛЯТЬ!]
    name = 'Unnamed', -- Название предмета
    description = 'Описание отсутствует', -- Описание
    ent = 'money_printer', -- Класс энтити
    model = 'models/props_c17/consolebox01a.mdl', -- Модель для показа в магазине
    price = 1024, -- Стоимость
    category = 'Other', -- Категория
    delay = 2, -- Задержка в секундах для покупки Предмета этого же класса (Не путайте с классом энтити)
    max = 1, -- Максимум предметов у игрока, если 0 - то бесконечное количество
    order = 100, -- По этому числу можно позиционировать предмет, от большего к меньшему (для F4). Аналог: sortOrder
}

Ambi.DarkRP.Config.shop_buy_enable = true -- Включить возможность Покупки?
Ambi.DarkRP.Config.shop_buy_command = 'buy' -- Команда для Покупки? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.shop_buy_description = 'Купить предмет. Аргумент: Класс Предмета' -- Описание команды Покупки --![НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.shop_sell_enable = true -- Включить возможность Продажи?
Ambi.DarkRP.Config.shop_sell_command = 'sell' -- Команда для Продажи? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.shop_sell_description = 'Продать предмет, для этого смотрите на него.' -- Описание команды Продажи --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.shop_sell_distance = 72 -- Максимальная дистанция от игрока к предмету

Ambi.DarkRP.Config.shop_maker_enable = true -- Включить систему Shop Maker? Также будут создаваться сохранённые работы при инициализаций модуля DarkRP --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.shop_maker_kick_cheaters = true -- Кикать игрока за подозрение в читерстве?
Ambi.DarkRP.Config.shop_maker_delay = 0 -- Задержка в секунде после инициализаций модуля DarkRP, после которой будут загружатся сохранённые работы и изменения
Ambi.DarkRP.Config.shop_maker_usergroups = { -- Ранги, которые имеют право вносить Изменения/Добавлять/Удалять в Shop Maker
    [ 'superadmin' ] = true,
    [ 'root' ] = true,
    [ 'owner' ] = true,
}

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.shipment_enable = true -- Включить Систему Коробок?
Ambi.DarkRP.Config.shipment_health = 100 -- Максимальное Здоровье Коробки
Ambi.DarkRP.Config.shipment_delay = 2 -- Задержка в секундах после взятия

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.advert_enable = true -- Включить Систему Объявлений?
Ambi.DarkRP.Config.advert_header = '[Реклама]' -- Заголовок Объявления
Ambi.DarkRP.Config.advert_color_header = Color( 241, 82, 24) -- Цвет для заголовка в объявлений
Ambi.DarkRP.Config.advert_color_text = Color( 248, 208, 76) -- Цвет для текста в объявлений
Ambi.DarkRP.Config.advert_delay = 5 -- Задержка на подачу объявлений в секундах
Ambi.DarkRP.Config.advert_out_in_chat = true -- Объявления надо выводить в чат?
Ambi.DarkRP.Config.advert_out_in_notify = true -- Объявления надо выводить с помощью Notify системы?
Ambi.DarkRP.Config.advert_sound = '' -- Звук после подачи объявлений (играет у всех, если объявление будет с помощью Notify)

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.broadcast_enable = true -- Включить Систему Государственных Объявлений?
Ambi.DarkRP.Config.broadcast_header = '[Новости]' -- Заголовок Гос. Объявлений
Ambi.DarkRP.Config.broadcast_color_header = Color( 211, 39, 20) -- Цвет для заголовка в объявлений
Ambi.DarkRP.Config.broadcast_color_text = Color( 211, 39, 20) -- Цвет для текста в объявлений
Ambi.DarkRP.Config.broadcast_delay = 5 -- Задержка на подачу гос. объявлений в секундах
Ambi.DarkRP.Config.broadcast_out_in_chat = true -- Гос. Объявления надо выводить в чат?
Ambi.DarkRP.Config.broadcast_out_in_notify = true -- Гос. Объявления надо выводить с помощью Notify системы?
Ambi.DarkRP.Config.broadcast_sound = '' -- Звук после подачи гос. объявлений (играет у всех)

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.doors_enable = true -- Включить Систему Приватизаций Дверей
Ambi.DarkRP.Config.doors_cost_buy = 45 -- Сумма, за которую можно купить дверь
Ambi.DarkRP.Config.doors_cost_sell = 25 -- Сумма, которая вернётся за продажу
Ambi.DarkRP.Config.doors_max = 6 -- Максимальное количество дверей, которых можно приобрести одному игроку
Ambi.DarkRP.Config.doors_classes = { -- Классы энтитей, которые являются дверьми
    [ 'prop_door_rotating' ] = true,
    [ 'func_door_rotating' ] = true,
    [ 'func_door' ] = true,
}

Ambi.DarkRP.Config.doors_draw_info_3d = false -- Показывать инфу на двери, когда игрок подходит к ней
Ambi.DarkRP.Config.doors_draw_info_max_length = 300 -- Максимальное расстояние показа информаций о двери

Ambi.DarkRP.Config.doors_draw_info_2d = true -- Показывать инфу, когда игрок наводится на дверь (2D)
Ambi.DarkRP.Config.doors_draw_info_2d_pos = 'top' -- Позиций для инфы: top, bottom, left, right, center.

Ambi.DarkRP.Config.doors_categories_create_defaults = true -- Добавить дефолтные категорий для дверей, работает с включённым jobs_create_defaults

Ambi.DarkRP.Config.doors_sell_all_doors_can = true -- Включить возможность продать все купленные двери за раз
Ambi.DarkRP.Config.doors_sell_all_command = 'sellalldoors' -- Чатовая Команда для продажи всех купленных дверей --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.doors_sell_all_description = 'Продать все купленные двери за раз' -- Описание чатовой команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.doors_sell_all_delay = 4 -- Задержка в секундах для команды продажи всех купленных дверей (Не самой возможности, а только для команды в чате!) --![НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.doors_text_on_blocked = '' -- Какой текст отображается при заблокированной двери?
Ambi.DarkRP.Config.doors_text_on_free = 'Продаётся ' -- Какой текст отображается при свободной и не купленной двери?
Ambi.DarkRP.Config.doors_text_on_occupaited = 'Занята' -- Какой текст отображается при свободной купленной двери?
Ambi.DarkRP.Config.doors_text_title = 'Дверь №' -- Какой титульник отображается у двери?

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.money_enable = true -- Включить Денежную Систему?
Ambi.DarkRP.Config.money_currency_symbol = '$' -- Символ валюты
Ambi.DarkRP.Config.money_start = 5000 -- Стартовый запас денег

Ambi.DarkRP.Config.money_drop_can = true -- Можно ли выкидывать валюту в виде энтити? Работает только на команды (чат, консоль)
Ambi.DarkRP.Config.money_drop_entity_class = 'spawned_money' -- Валюта дропнется в виде какой энтити?
Ambi.DarkRP.Config.money_drop_entity_model = 'models/props/cs_assault/money.mdl' -- Валюта дропнется с какой моделькой? Работает только с энтити spawned_money
Ambi.DarkRP.Config.money_drop_command = 'dropmoney' -- Какая команда (чатовая) для дропа валюты? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.money_drop_delay = 1 -- Задержка в секундах для дропа валюты 
Ambi.DarkRP.Config.money_drop_description = 'Выбросить денежные средства' -- Описание чатовой команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.money_drop_log_chat = true -- Оповестить в чат о дропе денег игрока

Ambi.DarkRP.Config.money_give_can = true -- Можно ли передать другому игроку валюту? Работает только на команды (чат, консоль)
Ambi.DarkRP.Config.money_give_command = 'givemoney' -- Задержка в секундах между передачами денег --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.money_give_delay = 1 -- Задержка в секундах между передачами денег
Ambi.DarkRP.Config.money_give_description = 'Передать денежные средства игроку напротив' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.money_give_max_count = 9999999 -- Максимальное число денег, которое можно передать за раз
Ambi.DarkRP.Config.money_give_distance = 72 -- Дистанция для передачи денег 
Ambi.DarkRP.Config.money_give_log_chat = true -- Оповестить в чат о передачи денег игрока, который отдал и игрока, который принял

Ambi.DarkRP.Config.money_printer_enable = true -- Будут работать стандартные денежные принтеры?
Ambi.DarkRP.Config.money_printer_delay = 16 -- Задержка производства денег в секундах
Ambi.DarkRP.Config.money_printer_amount = 200 -- Количество денег
Ambi.DarkRP.Config.money_printer_damage = 1 -- Урон, который будет за каждую итерацию производства денег
Ambi.DarkRP.Config.money_printer_health = 500 -- Максимальное количество здоровья Денежного Принтера и его здоровье при спавне
Ambi.DarkRP.Config.money_printer_repair = 50 -- Сколько здоровья восстановит Ремонтный Комплект
Ambi.DarkRP.Config.money_printer_repair_class = 'darkrp_repair_kit' -- Класс энтити, которая починит Денежный Принтер, сама энтити уничтожится

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.weapon_drop_enable = true -- Включить Возможность выкинуть оружие из рук?
Ambi.DarkRP.Config.weapon_drop_command = 'drop' -- Какая команда для дропа оружия? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.weapon_drop_description = 'Выкинуть оружие из рук' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.weapon_drop_delay = 1 -- Задержка в секундах между выбросами оружия? 
Ambi.DarkRP.Config.weapon_drop_can_destroy = true -- Можно ли уничтожить оружие?
Ambi.DarkRP.Config.weapon_drop_health = 100 -- Максимальное количество здоровья для выброшенного оружия?
Ambi.DarkRP.Config.weapon_drop_has_owner = false -- Выброшенное оружие имеет владельца (допустим, если есть FPP) 
Ambi.DarkRP.Config.weapon_drop_blocked = { -- Классы оружия, которые нельзя выбросить
    [ 'weapon_physgun' ] = true, -- 
    [ 'weapon_physcannon' ] = true,
    [ 'weapon_fists' ] = true,
    [ 'gmod_tool' ] = true,
    [ 'gmod_camera' ] = true,
    [ 'keys' ] = true,
}

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.buy_auto_ammo_enable = true -- Включить Система Автоматической покупки патронов?
Ambi.DarkRP.Config.buy_auto_ammo_command = 'buyautoammo' -- Какая команда для покупки патронов? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.buy_auto_ammo_delay = 0.25 -- Задержка в секундах между покупкой патронов? 
Ambi.DarkRP.Config.buy_auto_ammo_description = 'Купить автоматически патроны к оружию' -- Описание команды закупки патронов --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.buy_auto_ammo_cost = 75 -- Типичная цена за покупку патронов
Ambi.DarkRP.Config.buy_auto_ammo_count = 7 -- Типичное количество патронов за одну покупку

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.f4menu_enable = true -- Включить стандартное F4 Меню
Ambi.DarkRP.Config.f4menu_show_home = true -- Будет работать страница Основное? 
Ambi.DarkRP.Config.f4menu_show_jobs = true -- Будет работать страница Работы? 
Ambi.DarkRP.Config.f4menu_show_shop = true -- Будет работать страница Магазина?  
Ambi.DarkRP.Config.f4menu_show_settings = true -- Будет работать страница Настройки? 
Ambi.DarkRP.Config.f4menu_show_commands = true -- Будет работать страница Команды? 
Ambi.DarkRP.Config.f4menu_show_restrict_items_and_jobs = false -- Показывать предметы в магазине и работы, которые не подходят игроку?

Ambi.DarkRP.Config.f4menu_header_home = 'Основное' -- Название для Основное
Ambi.DarkRP.Config.f4menu_header_jobs = 'Работы' -- Название для Работы
Ambi.DarkRP.Config.f4menu_header_shop = 'Магазин' -- Название для Магазин
Ambi.DarkRP.Config.f4menu_header_settings = 'Настройки' -- Название для Настройки
Ambi.DarkRP.Config.f4menu_header_commands = 'Команды' -- Название для Основное

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.hud_enable = true -- Включить стандартные два худа (под номером 1 и 2) DarkRP HUD --![НУЖЕН МОДУЛЬ MultiHUD] [НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.hud_3d_enable = true -- Включить 3D HUD над головой игроков
Ambi.DarkRP.Config.hud_3d_show_name = true -- Показать имя
Ambi.DarkRP.Config.hud_3d_show_job = true -- Показать название работы
Ambi.DarkRP.Config.hud_3d_show_health = true -- Показать Кол-Во Здоровья
Ambi.DarkRP.Config.hud_3d_show_armor = true -- Показать Кол-Во Брони

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.cmenu_enable = true -- Включить DarkRP C-Menu
Ambi.DarkRP.Config.cmenu_show_laws = true -- Показать Законы?
Ambi.DarkRP.Config.cmenu_show_sellalldoors = true -- Показать Продажу Всех Дверей?
Ambi.DarkRP.Config.cmenu_show_buyautoammo = true -- Показать Автоматическую Покупку Патронов?
Ambi.DarkRP.Config.cmenu_show_advert = true -- Показать Подачу Рекламу?
Ambi.DarkRP.Config.cmenu_show_broadcast = true -- Показать Гос. Новости?
Ambi.DarkRP.Config.cmenu_show_demote = true -- Показать Увольнение?
Ambi.DarkRP.Config.cmenu_show_givemoney = true -- Показать Передать Деньги?
Ambi.DarkRP.Config.cmenu_show_dropmoney = true -- Показать Выкинуть Деньги?
Ambi.DarkRP.Config.cmenu_show_dropgun = true -- Показать Выкинуть Деньги?
Ambi.DarkRP.Config.cmenu_show_lockdown = true -- Показать Ком. Час (Вкл/Выкл)?
Ambi.DarkRP.Config.cmenu_show_license = true -- Показать Лицензию (Дать, Отнять, Проверить)?
Ambi.DarkRP.Config.cmenu_show_donate = true -- Показать Донат?
Ambi.DarkRP.Config.cmenu_show_wanted = true -- Показать Розыск?
Ambi.DarkRP.Config.cmenu_show_warrant = true -- Показать Ордер на Обыск?

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.vote_enable = true -- Включить Систему Голосований?
Ambi.DarkRP.Config.vote_time = 10 -- Сколько будет существовать голосование в секундах?
Ambi.DarkRP.Config.vote_max = 5 -- Сколько всего голосований может быть за раз?
Ambi.DarkRP.Config.vote_f3_open_cursor = true -- При нажатий F3, курсор мыши становится свободным? (Для того, чтобы игрок мог нажимать на кнопки голосования и т.д)

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.positions_enable = true -- Включить Сохранённые Позиций? (Не путать с job.spawns, они никак не связаны! Притом тюремные точки будут работать)

Ambi.DarkRP.Config.positions_jobs_add_command = 'addspawn' -- Команда для Создания Спавна Работы? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.positions_jobs_add_description = 'Создать спавн для работы и сохранить, аргумент: Класс работы' -- Описание команды Создания Спавна Работы --![НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.positions_jobs_remove_command = 'removespawn' -- Команда для Удаления Спавнов Работы? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.positions_jobs_remove_description = 'Удалить все сохранённые спавны работы, аргумент: Класс работы' -- Описание команды Удаления Спавнов Работы --![НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.positions_jobs_get_command = 'getspawn' -- Команда для Вывода в Чат Всех Спавнов? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.positions_jobs_get_description = 'Вывести в чат Все Сохранённые Позиций' -- Описание команды Вывода в Чат Всех Спавнов --![НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.positions_jail_add_command = 'addjail' -- Команда для Создания Тюрьмы? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.positions_jail_add_description = 'Добавить Позицию для Арестованных' -- Описание команды Создания Тюрьмы --![НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.positions_jail_remove_command = 'removejail' -- Команда для Удаления Спавнов Работы? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.positions_jail_remove_description = 'Удалить все сохранённые позиций тюрьмы' -- Описание команды Удаления Тюрьмы --![НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.positions_jail_get_command = 'getjail' -- Команда для Вывода в Чат Всех Тюрем? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.positions_jail_get_description = 'Вывести в чат Все Позиций для Тюрьмы' -- Описание команды Вывода в Чат Всех Спавнов --![НУЖЕН РЕСТАРТ]

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.police_system_enable = true -- Включить Полицейскую Систему?

Ambi.DarkRP.Config.police_system_arrest_enable = true -- Можно будет арестовывать/освобождать людей?
Ambi.DarkRP.Config.police_system_arrest_spawn_in_jail = true -- Арестованные люди будут спавнятся в Тюремных Точках?
Ambi.DarkRP.Config.police_system_arrest_can_only_police = false -- Игрока может арестовать только игрок с работой, у которого job.police? (Кроме чатовой команды, она всегда для них)
Ambi.DarkRP.Config.police_system_arrest_can_other_police = true -- Игрок может арестовать игроков с работой, у которых job.police?
Ambi.DarkRP.Config.police_system_arrest_send_info = true -- Объявить сверху экрана, что игрок арестован?
Ambi.DarkRP.Config.police_system_arrest_show_time = true -- Показывать игроку время до освобождения?
Ambi.DarkRP.Config.police_system_arrest_only_wanted = false -- Можно арестовывать только тех, кто в розыске?
Ambi.DarkRP.Config.police_system_arrest_command = 'arrest' -- Команда для Ареста/Освобождения Человека Напротив? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.police_system_arrest_description = 'Арестовать/Освободить человека напротив. Аргумент: Причина ареста' -- Описание команды Ареста --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.police_system_arrest_delay = 2 -- Задержка в секундах между арестами
Ambi.DarkRP.Config.police_system_arrest_distance = 71 -- Дистанция для ареста
Ambi.DarkRP.Config.police_system_arrest_time = 120 -- Сколько тюрьма будет длится в секундах

Ambi.DarkRP.Config.police_system_wanted_enable = true -- Можно будет Людей Подавать в Розыск?
Ambi.DarkRP.Config.police_system_wanted_can_other_police = true -- Игрок может подать в розыск игрока с работой, у которого job.police?
Ambi.DarkRP.Config.police_system_wanted_send_info = true -- Объявить сверху экрана, что игрок в розыске?
Ambi.DarkRP.Config.police_system_wanted_remove_after_death = true -- После смерти розыск снимается?
Ambi.DarkRP.Config.police_system_wanted_command = 'wanted' -- Команда для Ареста/Освобождения Человека в Розыск! --![НУЖЕН РЕСТАРТ] 
Ambi.DarkRP.Config.police_system_wanted_description = 'Объявить в розыск. Без аргументов - тот кто напротив, с аргументами - то ник игрока' -- Описание команды Объявления в Розыск [НУЖЕН РЕСТАРТ] [NEW]
Ambi.DarkRP.Config.police_system_wanted_delay = 10 -- Задержка в секундах между Снятия/Подачи в Розыск
Ambi.DarkRP.Config.police_system_wanted_time = 10 -- Сколько игрок будет в розыске (если 0, то всегда)
Ambi.DarkRP.Config.police_system_wanted_reason = 'Подозрение/Совершение Преступления' -- Стандартная причина подачи в розыск
Ambi.DarkRP.Config.police_system_wanted_show_3d = true -- Показать в 3D Худе, розыскиваемых

Ambi.DarkRP.Config.police_system_warrant_enable = true -- Будет работать система Ордера на Обыск и Выламывание Дверей Полицейскими?
Ambi.DarkRP.Config.police_system_warrant_only_can_door_ram = true -- Полицейские могут выламывать двери только тем, на кого подали Ордер на Обыск?
Ambi.DarkRP.Config.police_system_warrant_remove_after_death = true -- Ордер на Обыск исчезает после мерти
Ambi.DarkRP.Config.police_system_warrant_delay = 10 -- Задержка на Ордер на Обыск?
Ambi.DarkRP.Config.police_system_warrant_time = 30 -- Сколько Ордер будет действовать?
Ambi.DarkRP.Config.police_system_warrant_delay_door_ram = 10 -- Задержка у Полицейского на следующее Выламывание Двери?
Ambi.DarkRP.Config.police_system_warrant_command = 'warrant' -- Команда для Подач Ордера на Обыск на хозяина двери Напротив? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.police_system_warrant_description = 'Подать Ордер на Обыск на хозяина двери. Смотреть нужно на дверь!' -- Описание команды Ордер на Обыск --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.police_system_warrant_reason = 'Подозрение/Совершение Преступления' -- Стандартная причина

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.goverment_enable = true -- Включить Государственную Систему?

Ambi.DarkRP.Config.goverment_lockdown_enable = true -- Можно включать/выключать Комендантский Час?
Ambi.DarkRP.Config.goverment_lockdown_log = true -- Объявить в чате о вкл/выкл Ком. Часа?
Ambi.DarkRP.Config.goverment_lockdown_command = 'lockdown' -- Команда для Вкл/Выкл Ком.Час? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_lockdown_description = 'Вкл/Выкл Ком. Час' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_lockdown_delay = 60 -- Задержка в секундах для старта Ком. Часа?
Ambi.DarkRP.Config.goverment_lockdown_time = 120 -- Время до Окончания Ком. Часа? (Если 0, то пока не выключат)
Ambi.DarkRP.Config.goverment_lockdown_sound = 'npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav' -- Звук при Старте Ком. Часа

Ambi.DarkRP.Config.goverment_license_gun_enable = true -- Включить Лицензию на Оружие?
Ambi.DarkRP.Config.goverment_license_gun_show_3d = true -- Если включён 3D Hud, показывать у игрока Лицензию на Оружие?
Ambi.DarkRP.Config.goverment_license_gun_command = 'givelicense' -- Команда для Выдачи Лицензий на Оружие? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_license_gun_description = 'Выдать Лицензию на Оружие' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_license_gun_distance = 72 -- Дистанция до игрока
Ambi.DarkRP.Config.goverment_license_gun_remove_command = 'removelicense' -- Команда для Отбирания Лицензий на Оружие? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_license_gun_remove_description = 'Отобрать Лицензию на Оружие' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_license_gun_show_command = 'showlicense' -- Команда для Показ Лицензий на Оружие? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_license_gun_show_description = 'Показать Лицензию на Оружие' -- Описание команды --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_license_gun_check_command = 'checklicense' -- Команда для Проверки на Реальную Лицензию на Оружие? --![НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_license_gun_check_description = 'Проверить на настоящую Лицензию на Оружие' -- Описание команды --![НУЖЕН РЕСТАРТ]

Ambi.DarkRP.Config.goverment_laws_enable = true -- Включить Законы?
Ambi.DarkRP.Config.goverment_laws_show_command = 'laws' -- Команда [НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_laws_show_description = 'Вывести в чат все законы' -- Описание команды [НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_laws_set_command = 'setlaw' -- Команда [НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_laws_set_description = 'Изменить Закон. Аргумент: Номер от 1 до 9' -- Описание команды [НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_laws_clear_command = 'clearlaws' -- Команда [НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_laws_clear_description = 'Вернуть стандартные законы' -- Описание команды [НУЖЕН РЕСТАРТ]
Ambi.DarkRP.Config.goverment_laws_default = { -- Всего можно 9 законов
    [ 1 ] = 'Запрещено экслуатация Денежных Принтеров',
    [ 2 ] = 'Запрещено иметь оружие без Лицензий на Оружие',
    [ 3 ] = 'Запрещено производить/использовать Наркотики',
    [ 4 ] = '',
    [ 5 ] = '',
    [ 6 ] = '',
    [ 7 ] = '',
    [ 8 ] = '',
    [ 9 ] = '',
}

--* ====================================================================================================================================================== --
Ambi.DarkRP.Config.lockpick_enable = true -- Включить Lockpick Систему?
Ambi.DarkRP.Config.lockpick_can_doors = true -- Можно взламывать двери?
Ambi.DarkRP.Config.lockpick_can_keypad = true -- Можно взламывать кейпады?
Ambi.DarkRP.Config.lockpick_can_fading_doors = true -- Можно взламывать Fading двери?
Ambi.DarkRP.Config.lockpick_chance = 50 -- Какой шанс успешного взлома из 100 ( 0 - никогда, 100 - всегда )
Ambi.DarkRP.Config.lockpick_delay_player = 5 -- Задержка (секунды) для Игрока после взлома
Ambi.DarkRP.Config.lockpick_delay_entity = 10 -- Задержка (секунды) для Двери/Keypad после успешного взлома
Ambi.DarkRP.Config.lockpick_classes = { -- Таблица с классами энтити, которые можно попытаться взломать
    -- [ 'class' ] = true,
}

--* ====================================================================================================================================================== --
Ambi.DarkRP.compatibility_enable = true -- Включить совместимость со старым DarkRP?
Ambi.DarkRP.compatibility_jobs = true -- Включить совместимость со старым DarkRP у работ?
Ambi.DarkRP.compatibility_doors = true -- Включить совместимость со старым DarkRP у системы дверей?
Ambi.DarkRP.compatibility_shop = true -- Включить совместимость со старым DarkRP у магазина?
Ambi.DarkRP.compatibility_commands = true -- Включить совместимость со старым DarkRP у команд (чатовых, консольных)?