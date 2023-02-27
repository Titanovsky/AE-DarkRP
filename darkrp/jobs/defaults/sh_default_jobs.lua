if not Ambi.DarkRP.Config.jobs_create_defaults then return end

local Gen, C = Ambi.Packages.Out( 'general, colors' )
local Add = Ambi.DarkRP.AddJobTable

local MODELS_CITIZEN = {
    'models/player/Group01/male_07.mdl',
    'models/player/Group01/male_02.mdl',
    'models/player/Group01/male_01.mdl', 
    'models/player/Group01/male_03.mdl', 
    'models/player/Group01/male_04.mdl', 
    'models/player/Group01/male_05.mdl', 
    'models/player/Group01/male_06.mdl', 
    'models/player/Group01/male_08.mdl',
    'models/player/Group01/male_09.mdl',

    'models/player/Group01/female_01.mdl',
    'models/player/Group01/female_02.mdl',
    'models/player/Group01/female_03.mdl',
    'models/player/Group01/female_04.mdl',
    'models/player/Group01/female_05.mdl',
    'models/player/Group01/female_06.mdl'
}

local MODELS_MEDICS = {
    'models/player/Group03m/male_07.mdl',
    'models/player/Group03m/male_02.mdl', 
    'models/player/Group03m/male_01.mdl',
    'models/player/Group03m/male_03.mdl', 
    'models/player/Group03m/male_04.mdl', 
    'models/player/Group03m/male_05.mdl', 
    'models/player/Group03m/male_06.mdl', 
    'models/player/Group03m/male_08.mdl', 
    'models/player/Group03m/male_09.mdl', 

    'models/player/Group03m/female_01.mdl', 
    'models/player/Group03m/female_02.mdl', 
    'models/player/Group03m/female_03.mdl', 
    'models/player/Group03m/female_04.mdl', 
    'models/player/Group03m/female_05.mdl',
    'models/player/Group03m/female_06.mdl', 
}

local MODELS_GANGSTERS = {
    'models/player/Group03/male_07.mdl',
    'models/player/Group03/male_02.mdl',
    'models/player/Group03/male_01.mdl', 
    'models/player/Group03/male_03.mdl', 
    'models/player/Group03/male_04.mdl', 
    'models/player/Group03/male_05.mdl', 
    'models/player/Group03/male_06.mdl', 
    'models/player/Group03/male_08.mdl',
    'models/player/Group03/male_09.mdl',

    'models/player/Group03/female_01.mdl',
    'models/player/Group03/female_02.mdl',
    'models/player/Group03/female_03.mdl',
    'models/player/Group03/female_04.mdl',
    'models/player/Group03/female_05.mdl',
    'models/player/Group03/female_06.mdl'
}

local MODELS_SWAT = {
    'models/player/swat.mdl',
    'models/player/urban.mdl',
    'models/player/gasmask.mdl',
    'models/player/riot.mdl',
}

local WEAPONS_POLICE = {
    'arrest_stick',
    'unarrest_stick',
    'stunstick',
    'weapon_pistol',
}

local WEAPONS_SWAT = {
    'arrest_stick',
    'unarrest_stick',
    'stunstick',
    'door_ram',
    'weapon_pistol',
    'weapon_smg1',
}

local WEAPONS_SHERIFF = {
    'arrest_stick',
    'unarrest_stick',
    'stunstick',
    'door_ram',
    'weapon_357',
    'weapon_smg1',
    'weapon_shotgun',
}

local WEAPONS_MAYOR = {
    'unarrest_stick',
    'stunstick',
}

local WEAPONS_MEDIC = {
    'med_kit'
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
Add{ class = 'TEAM_CITIZEN',
    name = 'Житель', 
    command = 'citizen', 
    models = MODELS_CITIZEN,
    max = 0,
    category = 'Жители', 
    color = C.AMBI_GREEN,
}

Add{ class = 'TEAM_MEDIC',
    name = 'Врач', 
    command = 'medic', 
    max = 4,
    category = 'Жители', 
    models = MODELS_MEDICS,
    weapons = WEAPONS_MEDIC,
    demote = true,
    color = C.RU_PINK,
}

Add{ class = 'TEAM_POLICE',
    name = 'Полицейский', 
    command = 'police', 
    category = 'Полиция', 
    description = 'Сотрудник правопорядка', 
    color = C.AMBI_BLUE, 
    police = true,
    weapons = WEAPONS_POLICE, 
    demote = true,
    vote = true,
    models = { 'models/player/police.mdl', 'models/player/police_fem.mdl' } 
}

Add{ class = 'TEAM_SWAT',
    name = 'Спецназ', 
    command = 'swat', 
    category = 'Полиция', 
    description = 'Отряд Специального Назначения, подчиняется Шерифу', 
    from = 'TEAM_POLICE',
    color = C.AMBI_BLUE, 
    police = true,
    weapons = WEAPONS_SWAT, 
    demote = true,
    models = MODELS_SWAT,
}

Add{ class = 'TEAM_SHERIFF',
    name = 'Шериф', 
    command = 'sheriff', 
    category = 'Полиция', 
    description = 'Шериф города. Полностью руководит Полицейским Участком', 
    color = C.AMBI_HARD_BLUE, 
    police = true,
    weapons = WEAPONS_SHERIFF, 
    max = 1,
    vote = true,
    demote = true,
    models = { 'models/player/barney.mdl' },
}

Add{ class = 'TEAM_GUNDEALER',
    name = 'Продавец Оружия', 
    command = 'gundealer', 
    category = 'Жители', 
    description = 'Житель города, но имеющий право продавать оружие', 
    color = C.AMBI_CARROT, 
    max = 4,
    demote = true,
    models = { 'models/player/monk.mdl' },
}

Add{ class = 'TEAM_BUSINESSMAN',
    name = 'Предприниматель', 
    command = 'businessman', 
    category = 'Жители', 
    description = 'Житель города, способный покупать больше дверей', 
    color = C.AMBI_SALAT, 
    max = 4,
    doors_max = 10,
    models = { 'models/player/magnusson.mdl' },
}

Add{ class = 'TEAM_GANGSTER', 
    name = 'Бандит', 
    command = 'gangster', 
    category = 'Криминал', 
    description = 'Самый низкоранговый бандит. Нарушает закон в одиночку, либо с группой', 
    color = C.FLAT_GRAY, 
    weapons = { 'lockpick' },
    models = MODELS_GANGSTERS,
}

Add{ class = 'TEAM_MAYOR', 
    name = 'Мэр', 
    command = 'mayor', 
    category = 'Мэрия', 
    description = 'Администратор города: управляет полицией', 
    color = C.FLAT_DARK_RED, 
    max = 1, 
    demote_after_death = true, 
    mayor = true,
    weapons = WEAPONS_MAYOR,
    vote = true,
    models = { 'models/player/breen.mdl', 'models/player/mossman_arctic.mdl' },
}