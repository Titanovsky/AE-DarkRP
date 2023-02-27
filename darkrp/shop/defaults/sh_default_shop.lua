if not Ambi.DarkRP.Config.shop_create_defaults then return end

local C, Gen = Ambi.General.Global.Colors, Ambi.General
local Add = Ambi.DarkRP.AddShopItem

-- -----------------------------------------------------------------------------------------------------------------------------------
Add( 'money_printer', { 
    name = 'Денежный Принтер', 
    ent = 'money_printer',
    model = 'models/props_c17/consolebox01a.mdl',
    category = 'Денежный Принтер',
    price = 2000,
    max = 4,
    order = 100,
} )

Add( 'darkrp_repair_kit', { 
    name = 'Рем. Комплект', 
    ent = 'darkrp_repair_kit',
    model = 'models/items/battery.mdl',
    category = 'Денежный Принтер',
    description = 'Ремонтирует денежный принтер',
    price = 500,
    max = 2,
    order = 100,
} )

-- -----------------------------------------------------------------------------------------------------------------------------------
Add( 'weapon_pistol', { 
    name = 'Pistol', 
    weapon = 'weapon_pistol',
    model = 'models/weapons/w_pistol.mdl',
    category = 'Оружие',
    description = 'Pistol',
    price = 1000,
    ammo = 128,
    allowed = { 'TEAM_GUNDEALER' },
} )

Add( 'ship_pistol', { 
    name = 'Pistol (Коробка)', 
    ent = 'spawned_shipment',
    model = 'models/items/item_item_crate.mdl',
    category = 'Коробки',
    description = 'Коробка',
    price = 8500,
    shipment = {
        title = 'Pistol',
        class = 'weapon_pistol',
        count = 10,
        model = 'models/weapons/w_pistol.mdl',
        is_weapon = true,
    },
    allowed = { 'TEAM_GUNDEALER' },
} )

Add( 'weapon_smg', { 
    name = 'SMG', 
    weapon = 'weapon_smg1',
    model = 'models/weapons/w_smg1.mdl',
    category = 'Оружие',
    description = 'SMG',
    price = 3000,
    ammo = 200,
    allowed = { 'TEAM_GUNDEALER' },
} )

Add( 'ship_smg', { 
    name = 'SMG (Коробка)', 
    ent = 'spawned_shipment',
    model = 'models/items/item_item_crate.mdl',
    category = 'Коробки',
    description = 'Коробка',
    price = 22000,
    shipment = {
        title = 'SMG',
        class = 'weapon_smg1',
        count = 10,
        model = 'models/weapons/w_smg1.mdl',
        is_weapon = true,
    },
    allowed = { 'TEAM_GUNDEALER' },
} )

Add( 'weapon_shotgun', { 
    name = 'Shotgun', 
    weapon = 'weapon_shotgun',
    model = 'models/weapons/w_shotgun.mdl',
    category = 'Оружие',
    description = 'Shotgun',
    price = 3500,
    ammo = 20,
    allowed = { 'TEAM_GUNDEALER' },
} )

Add( 'ship_shotgun', { 
    name = 'Shotgun (Коробка)', 
    ent = 'spawned_shipment',
    model = 'models/items/item_item_crate.mdl',
    category = 'Коробки',
    description = 'Коробка',
    price = 28000,
    shipment = {
        title = 'Shotgun',
        class = 'weapon_shotgun',
        count = 10,
        model = 'models/weapons/w_shotgun.mdl',
        is_weapon = true,
    },
    allowed = { 'TEAM_GUNDEALER' },
} )