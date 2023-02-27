-- Полная информация по созданию предметов в магазин --> https://titanovskyteam.gitbook.io/darkrp/getting-started/create-shop

if not Ambi.DarkRP then return end

local C = Ambi.Packages.Out( 'colors' )
local AddItem = Ambi.DarkRP.AddShopItem
local SimpleAddItem = Ambi.DarkRP.SimpleAddItem

-- ----------------------------------------------------------------------------------------------------------------------------
AddItem( 'money_printer', { 
    name = 'Денежный Принтер', 
    ent = 'money_printer',
    model = 'models/props_c17/consolebox01a.mdl',
    category = 'Денежный Принтер',
    price = 2000,
    max = 4,
    order = 100,
} )

-- SimpleAddShopItem( sClass, sName, sCategory, sDescription, sClassEntity, sModel, nMax, nPrice, nDelay, tOther )
-- SimpleAddShopItem( 'money_printer', 'Денежный Принтер', 'Денежные Принтеры', 'Описание', 'money_printer', 'models/props_c17/consolebox01a.mdl', 4, 2000 )