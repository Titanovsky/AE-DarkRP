-- Полная информация по созданию предметов в магазин --> https://titanovskyteam.gitbook.io/darkrp/getting-started/create-shop

if not Ambi.DarkRP then return end

local C = Ambi.Packages.Out( 'colors' )
local AddItem = Ambi.DarkRP.AddShopItem

-- ----------------------------------------------------------------------------------------------------------------------------
-- AddItem( 'money_printer', { 
--     name = 'Денежный Принтер', 
--     ent = 'money_printer',
--     model = 'models/props_c17/consolebox01a.mdl',
--     category = 'Денежный Принтер',
--     price = 2000,
--     max = 4,
--     order = 100,
-- } )