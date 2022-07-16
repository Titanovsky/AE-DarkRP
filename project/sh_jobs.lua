-- Полная информация по созданию работ --> https://titanovskyteam.gitbook.io/darkrp/getting-started/create-jobs

if not Ambi.DarkRP then return end

local C = Ambi.Packages.Out( 'colors' )
local AddJob = Ambi.DarkRP.AddJob
local SimpleAddJob = Ambi.DarkRP.SimpleAddJob

-- ----------------------------------------------------------------------------------------------------------------------------
AddJob( 'TEAM_CITIZEN', { 
    name = 'Житель', 
    command = 'citizen', 
    models = { 'models/player/Group03m/male_07.mdl' },
    max = 0,
    category = 'Категория', 
} )

-- SimpleAddJob( sClass, sName, sCommand, sCategory, sDescription, nMax, nSalary, bVote, bLicense, bDemote, cColor, tModels, tWeapons, tOther )
-- SimpleAddJob( 'TEAM_EXAMPLE', 'Название', 'job1', 'Категория', 'Описание', 0, false, false, true, Color( 255, 0, 0 ), { 'models/player/Group03m/male_07.mdl' } )