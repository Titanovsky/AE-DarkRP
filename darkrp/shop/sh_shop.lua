local C, Gen = Ambi.General.Global.Colors, Ambi.General
local PLAYER = FindMetaTable( 'Player' )
local ENTITY = FindMetaTable( 'Entity' )

Ambi.DarkRP.shop = Ambi.DarkRP.shop or {}
Ambi.DarkRP.shop_commands = Ambi.DarkRP.shop_commands or {}

-- ---------------------------------------------------------------------------------------------------------------------------------------
function ENTITY:GetShopBuyer()
    return self.nw_Buyer
end

function ENTITY:GetBuyer()
    return self:GetShopBuyer()
end

function ENTITY:GetShopBuyerSteamID()
    return self.nw_BuyerSteamID
end

function ENTITY:GetBuyerSteamID()
    return self:GetShopBuyerSteamID()
end

function ENTITY:GetShopClass()
    return self.nw_ShopClass
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function FillEmptyProperties( sClass, tItem )
    local default = Ambi.DarkRP.Config.shop_default

    tItem.name          = tItem.name or default.name
    tItem.description   = tItem.description or default.description
    tItem.ent           = tItem.ent or default.ent
    tItem.model         = tItem.model or default.model
    tItem.price         = tItem.price or default.price
    tItem.category      = tItem.category or default.category
    tItem.delay         = tItem.delay or default.delay
    tItem.max           = tItem.max or default.max
    tItem.order         = ( tItem.order or tItem.sortOrder ) or default.order
    tItem.cmd           = tItem.cmd or 'buy'..sClass

    return tItem 
end

local function CheckProperties( tItem )
    if not tItem then Gen.Error( 'DarkRP', 'This is shop item is not valid!' ) return false
    elseif not tItem.name then Gen.Error( 'DarkRP', 'Item name is not selected!' ) return false
    elseif not tItem.cmd then Gen.Error( 'DarkRP', 'Item cmd is not selected!' ) return false
    elseif not tItem.category then Gen.Error( 'DarkRP', 'Item category is not selected!' ) return false
    elseif not tItem.description then Gen.Error( 'DarkRP', 'Item description is not selected!' ) return false
    elseif not tItem.max then Gen.Error( 'DarkRP', 'Item max is not selected!' ) return false
    elseif not tItem.order then Gen.Error( 'DarkRP', 'Item order is not selected!' ) return false
    elseif not tItem.model then Gen.Error( 'DarkRP', 'Item models is not selected!' ) return false
    elseif not tItem.price then Gen.Error( 'DarkRP', 'Item price is not selected!' ) return false
    elseif not tItem.ent then Gen.Error( 'DarkRP', 'Item ent is not selected!' ) return false
    elseif not tItem.delay then Gen.Error( 'DarkRP', 'Item delay is not selected!' ) return false
    end

    if tItem.sortOrder then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "sortOrder", only: "order"' ) 
        tItem.order = tItem.sortOrder
        tItem.sortOrder = nil
    end

    if tItem.getPrice then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "getPrice", only: "GetPrice"' ) 
        tItem.GetPrice = tItem.getPrice
        tItem.getPrice = nil
    end

    if tItem.getMax then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "getMax", only: "GetMax"' ) 
        tItem.GetMax = tItem.getMax
        tItem.getMax = nil
    end

    if tItem.customCheck then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "customCheck", only: "CustomCheck"' ) 
        tItem.CustomCheck = tItem.customCheck
        tItem.customCheck = nil
    end

    if tItem.CustomCheckFailMsg and isstring( tItem.CustomCheckFailMsg ) then 
        Gen.Warning( 'DarkRP', 'tItem.CustomCheckFailMsg it was a string, now it converting to function' ) 
        
        local msg = tItem.CustomCheckFailMsg
        tItem.CustomCheckFailMsg = function( ePly, tJob ) return msg end
    end

    return true
end

function Ambi.DarkRP.AddShopItem( sClass, tItem )
    if not sClass or not tItem then Gen.Error( 'DarkRP', 'AddShopItem | Not selected sClass or tItem!' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanAddShopItem]', nil, sClass, tItem ) == false ) then return end
    
    local item = FillEmptyProperties( sClass, tItem )
    if not CheckProperties( tItem ) then Gen.Error( 'DarkRP', 'AddShopItem | CheckProperties the item == false' ) return end
    
    Ambi.DarkRP.shop[ sClass ] = tItem

    for k, class in pairs( Ambi.DarkRP.shop_commands ) do
        if ( class == sClass ) then Ambi.DarkRP.shop_commands[ k ] = nil break end
    end
    
    Ambi.DarkRP.shop_commands[ '/'..item.cmd ] = sClass 

    print( '[DarkRP] Created shop item: '..sClass )

    hook.Call( '[Ambi.DarkRP.AddedShopItem]', nil, sClass, item )

    return tItem
end

function Ambi.DarkRP.RemoveShopItem( sClass )
    if not sClass then return end

    local old_item = Ambi.DarkRP.shop[ sClass ]

    Ambi.DarkRP.shop[ sClass ] = nil

    print( '[DarkRP] Removed shop item: '..sClass )

    hook.Call( '[Ambi.DarkRP.RemovedShopItem]', nil, sClass, old_item )
end

function Ambi.DarkRP.SimpleAddShopItem( sClass, sName, sCategory, sDescription, sClassEntity, sModel, nMax, nPrice, nDelay, tOther )
    if not sClass then return end

    local tab = {
        name = sName,
        category = sCategory,
        description = sDescription,
        ent = sClassEntity,
        model = sModel,
        max = nMax,
        price = nPrice,
        delay = nDelay
    }

    if tOther then
        for key, value in pairs( tOther ) do
            tab[ key ] = value
        end
    end

    return Ambi.DarkRP.AddShopItem( sClass, tab )
end

function Ambi.DarkRP.AddShipmentFromShopWeapon( sClass, sName, sCategory, sDescription, nCount, nPrice, tOther )
    local item = Ambi.DarkRP.GetShopItem( sClass )
    if not item then return end
    if not item.weapon then return end

    local class_weapon = isbool( item.weapon ) and item.ent or item.weapon

    local tab = { 
        name = sName, 
        ent = 'spawned_shipment',
        model = 'models/items/item_item_crate.mdl',
        category = sCategory,
        description = sDescription,
        price = nPrice,
        shipment = {
            title = sName,
            class = class_weapon,
            count = nCount,
            model = item.model,
            is_weapon = true,
        }
    }

    for k, v in pairs( tOther or {} ) do tab[ k ] = v end

    return Ambi.DarkRP.AddShopItem( 'shipment_'..sClass, tab )
end

function Ambi.DarkRP.GetShopItem( sClass )
    return Ambi.DarkRP.shop[ sClass or '' ]
end

function Ambi.DarkRP.GetShop()
    return Ambi.DarkRP.shop
end