local C = Ambi.General.Global.Colors
local PLAYER = FindMetaTable( 'Player' )
local ENTITY = FindMetaTable( 'Entity' )
local MAX_POS = 44

-- ================= Entity =========================================================================== --
function ENTITY:SetShopBuyer( ePly )
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end
    if not self:GetShopClass() then return end

    if self:GetShopBuyer() then
        local items = Ambi.DarkRP.players_shop_items[ self:GetShopBuyerSteamID() ]

        if items[ self ] then Ambi.DarkRP.players_shop_items[ self:GetShopBuyerSteamID() ][ self ] = nil end
    end

    Ambi.DarkRP.players_shop_items[ ePly:SteamID() ][ self ] = self:GetShopClass()

    self.nw_Buyer = ePly
    self.nw_BuyerSteamID = ePly:SteamID()
    self.nw_BuyerName = ePly:Nick()

    return ePly
end

function ENTITY:SetBuyer( ePly )
    return self:SetShopBuyer()
end

-- ================= Player =========================================================================== --
Ambi.DarkRP.players_shop_items = Ambi.DarkRP.players_shop_items or {}

function PLAYER:BuyShopItem( sClass, bForce )
    sClass = sClass or ''

    local class = string.lower( sClass )

    local item = Ambi.DarkRP.GetShopItem( class )
    if not item then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Такого предмета в магазине не существует!' ) return false end
    local price = item.GetPrice and item.GetPrice( self, item.price ) or item.price

    if not bForce then
        if ( hook.Call( '[Ambi.DarkRP.CanBuyShopItem]', nil, self, sClass, bForce ) == false ) then return false end

        if not Ambi.DarkRP.Config.shop_enable then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Магазина - отключена!' ) return false end
        if not Ambi.DarkRP.Config.shop_buy_enable then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Возможность покупать - отключена!' ) return false end

        if item.CustomCheck and ( item.CustomCheck( self ) == false ) then
            local msg = item.CustomCheckFailMsg and item.CustomCheckFailMsg( self, item ) or 'Недоступно!'
            self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, msg ) 

            return false 
        end

        local max = item.GetMax and item.GetMax( self ) or item.max
        if ( self:GetCountShopItem( class ) >= max ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Достигнут максимум ', C.ERROR, '('..max..')' ) return false end

        if item.allowed then
            local can = false

            for _, job in ipairs( item.allowed ) do
                if isnumber( job ) and ( self:Team() == job ) then can = true break 
                elseif isstring( job ) and ( self:GetJob() == job ) then can = true break 
                end
            end

            if ( can == false ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваша работа не имеет право покупать данный предмет!' ) return false end
        end

        if ( self:GetMoney() < price ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вам не хватает: ', C.ERROR, tostring( price - self:GetMoney() )..Ambi.DarkRP.Config.money_currency_symbol ) return false end
        if not self:GetDelay( 'AmbiDarkRPShop['..class..']' ) then self:SetDelay( 'AmbiDarkRPShop['..class..']', item.delay ) else self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: ', C.ERROR, tostring( math.floor( timer.TimeLeft( 'AmbiDarkRPShop['..class..']['..self:SteamID()..']' ) + 1 ) ), C.ABS_WHITE, ' секунд' ) return false end
    end

    self:AddMoney( -price )
    self:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы купили '..item.name..' за ', C.AMBI_GREEN, price..Ambi.DarkRP.Config.money_currency_symbol )

    local ent
    if item.weapon then
        local class = isbool( item.weapon ) and item.ent or item.weapon -- workaround if item.weapons is bool and has item.ent

        self:Give( class, item.ammo and true or false )

        ent = self:GetWeapon( class )

        if item.ammo then self:GiveAmmo( item.ammo, ent:GetPrimaryAmmoType(), true ) end

        self:SelectWeapon( ent )
    elseif item.ent then
        local pos, ang = Ambi.General.Utility.GetFrontPos( self, MAX_POS ), self:EyeAngles()

        ent = Ambi.DarkRP.SpawnShopEntity( sClass, self, pos, ang )
        
        local shipment = item.shipment
        if shipment then 
            local title, class, count, model = shipment.title or shipment.class, shipment.class or 'item_battery', shipment.count or 1, shipment.model or 'models/items/battery.mdl'
            ent:SetInfo( title, class, count, model, shipment.is_weapon ) 
        end
    end

    if item.Spawned then item.Spawned( self, ent ) end

    hook.Call( '[Ambi.DarkRP.BuyShopItem]', nil, self, ent, sClass, bForce, item )

    return ent
end

function PLAYER:RemoveShopItem( eObj, bNotRemove )
    if not IsValid( eObj ) then return end
    if not self:GetShopItem( eObj ) then return end

    Ambi.DarkRP.players_shop_items[ self:SteamID() ][ eObj ] = nil

    if not bNotRemove then 
        eObj.nw_BuyerSteamID = nil -- Чтобы в EntityRemoved не искался
        eObj:Remove() 
    end
end

function PLAYER:SellShopItem( eObj )
    if not Ambi.DarkRP.Config.shop_enable then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Магазина - отключена!' ) return end
    if not Ambi.DarkRP.Config.shop_sell_enable then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Возможность продавать - отключена!' ) return end

    if not IsValid( eObj ) then return end
    if ( eObj:GetShopBuyer() != self ) then return end

    local class = eObj:GetShopClass()
    local item = Ambi.DarkRP.GetShopItem( class )
    if not item then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Такого предмета в магазине не существует!' ) return end

    if ( hook.Call( '[Ambi.DarkRP.CanSellShopItem]', nil, self, eObj, class, item ) == false ) then return end

    self:RemoveShopItem( eObj )

    local return_money = ( item.price == 0 ) and 0 or math.floor( item.price / 2 )

    self:AddMoney( return_money )
    self:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы продали '..item.name..' за ', C.AMBI_GREEN, return_money..Ambi.DarkRP.Config.money_currency_symbol )

    hook.Call( '[Ambi.DarkRP.SellShopItem]', nil, self, eObj, class, item )
end

function PLAYER:GetShopItem( eObj )
    if not IsValid( eObj ) then return end

    return Ambi.DarkRP.players_shop_items[ self:SteamID() ][ eObj ]
end

function PLAYER:GetShopItems()
    return Ambi.DarkRP.players_shop_items[ self:SteamID() ]
end

function PLAYER:GetCountShopItem( sClass )
    local count = 0
    for ent, class in pairs( self:GetShopItems() ) do
        if ( class == sClass ) then count = count + 1 end
    end

    return count
end

-- ================= Core ============================================================================= --
function Ambi.DarkRP.SpawnShopEntity( sClass, ePly, vPos, aAng ) 
    if ( hook.Call( '[Ambi.DarkRP.CanSpawnShopEntity]', nil, sClass, ePly, vPos, aAng ) == false ) then return end

    local item = Ambi.DarkRP.GetShopItem( sClass )
    if not item then return end

    local ent = ents.Create( item.ent )
    ent:SetPos( vPos )
    ent:SetAngles( aAng )
    ent:Spawn()
    ent:Activate()
    ent.nw_ShopClass = sClass

    if IsValid( ePly ) then ent:SetShopBuyer( ePly ) end

    hook.Call( '[Ambi.DarkRP.SpawnedShopEntity]', nil, ent, sClass, ePly, vPos, aAng )

    return ent
end

-- ================= Hooks ============================================================================ --
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.AddShopTable', function( ePly ) 
    if not IsValid( ePly ) then return end

    if not Ambi.DarkRP.players_shop_items[ ePly:SteamID() ] then 
        Ambi.DarkRP.players_shop_items[ ePly:SteamID() ] = {} 
    else
        for ent, _ in pairs( Ambi.DarkRP.players_shop_items[ ePly:SteamID() ] ) do
            ent.nw_Buyer = ePly
            ent.nw_BuyerName = ePly:Nick()
        end
    end
end )

hook.Add( 'PlayerDisconnected', 'Ambi.DarkRP.SetShopEntities', function( ePly ) 
    local items = Ambi.DarkRP.players_shop_items[ ePly:SteamID() ]
    if not item then return end

    for ent, _ in pairs( items ) do
        ent.nw_BuyerName = ePly:Nick()..' [Вышел]'
    end
end )

hook.Add( 'EntityRemoved', 'Ambi.DarkRP.RemoveInShopTable', function( eObj ) 
    local buyer_steamid = eObj.nw_BuyerSteamID
    if not buyer_steamid then return end

    Ambi.DarkRP.players_shop_items[ buyer_steamid ][ eObj ] = nil
end )

hook.Add( 'PlayerSay', 'Ambi.DarkRP.BuyEntity', function( ePly, sText ) 
    local class = Ambi.DarkRP.shop_commands[ sText ]
    if not class then return end

    ePly:BuyShopItem( class )
end )

-- ================= Nets ============================================================================= --
