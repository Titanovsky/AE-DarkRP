-- Полная информация по созданию категорий для дверей --> https://titanovskyteam.gitbook.io/darkrp/getting-started/create-door-category

if not Ambi.DarkRP then return end

local AddCategory = Ambi.DarkRP.AddDoorCategory

-- ----------------------------------------------------------------------------------------------------------------------------
-- AddCategory( 'Мэрия', { 'TEAM_MAYOR' } )
-- AddCategory( 'Полицейский Участок', { 'TEAM_POLICE', 'TEAM_SHERIFF', 'TEAM_SWAT', 'TEAM_MAYOR' } )
-- AddCategory( 'Тюрьма', { 'TEAM_SHERIFF', 'TEAM_MAYOR' } )