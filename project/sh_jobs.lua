-- Полная информация по созданию работ --> https://titanovskyteam.gitbook.io/darkrp/getting-started/create-jobs

if not Ambi.DarkRP then return end

local C = Ambi.Packages.Out( 'colors' )
local AddJob = Ambi.DarkRP.AddJob

-- ----------------------------------------------------------------------------------------------------------------------------
-- AddJob( 'TEAM_EXAMPLE', { 
--     name = 'Название Работы', 
--     command = 'job1', 
--     models = { 'models/player/Group03m/male_07.mdl' },
--     max = 0,
--     category = 'Категория', 
-- } )