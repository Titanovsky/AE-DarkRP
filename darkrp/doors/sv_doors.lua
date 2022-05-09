local SQL, C= Ambi.SQL, Ambi.General.Global.Colors
local DB = SQL.CreateTable( 'darkrp_alt_doors', 'Door, Map, IsBlock, Category' )

--------------------------------------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.SetDoorFree( eDoor ) -- Сделать двери возможность покупать, освободить её ото всех
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end
    if SQL.Select( DB, 'Map', 'Door', eDoor:EntIndex() ) then SQL.Delete( DB, 'Door', eDoor:EntIndex() ) end

    Ambi.DarkRP.RemoveDoorOwners( eDoor )

    eDoor.nw_IsBlocked = false
    eDoor.nw_Category = ''
end

function Ambi.DarkRP.SetDoorBlockOwn( eDoor ) -- Запретить владеть вообще кому-либо дверью
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end
    
    local index = tostring( eDoor:EntIndex() )
    SQL.Get( DB, 'Door', 'Door', index, function()
        SQL.Update( DB, 'IsBlock', 'true', 'Door', index )
    end, function()
        SQL.Insert( DB, 'Door, Map, IsBlock, Category', '%s, %s, %s, %s', index, game.GetMap(), 'true', '' )
    end )

    Ambi.DarkRP.RemoveDoorOwners( eDoor )
    eDoor.nw_IsBlocked = true
end

function Ambi.DarkRP.SetDoorOwners( eDoor, tPlayers )
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end
    if eDoor.nw_IsBlocked then return end
    if not tPlayers then return end

    for _, ply in ipairs( tPlayers ) do 
        if not ply:IsPlayer() then return end

        ply.doors[ eDoor ] = true
    end
    if not tPlayers then return end -- После проверки на наличие игроков, таблица может опустеть и уничтожится сборщиком мусора

    eDoor.owners = tPlayers
    eDoor.nw_IsOwned = true

    if not eDoor.first_owner then
        eDoor.first_owner = tPlayers[ 1 ]

        eDoor.nw_Title = eDoor.first_owner:Nick()
    end
end

function Ambi.DarkRP.SetDoorCategory( eDoor, sCategory ) -- Все работы в данной категорий смогут закрывать/открывать дверь
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end
    if eDoor.nw_IsBlocked then return end
    if not sCategory then return end
    if not Ambi.DarkRP.doors_categories[ sCategory ] then return end

    Ambi.DarkRP.RemoveDoorOwners( eDoor )
    
    local index = eDoor:EntIndex()
    SQL.Get( DB, 'Door', 'Door', index, function()
        SQL.Update( DB, 'Category', sCategory, 'Door', index )
    end, function()
        SQL.Insert( DB, 'Door, Map, IsBlock, Category', '%i, %s, %s, %s', index, game.GetMap(), 'false', sCategory )
    end )

    eDoor.nw_Title = sCategory
    eDoor.nw_Category = sCategory
end

function Ambi.DarkRP.AddDoorOwner( eDoor, ePly )
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end
    if eDoor.nw_IsBlocked then return end

    local owners = eDoor.owners or {}
    if ( #owners == 0 ) then 
        Ambi.DarkRP.SetDoorOwners( eDoor, { ePly } )
    else
        eDoor.owners[ #eDoor.owners + 1 ] = ePly
        ePly.doors[ eDoor ] = true
    end
end

function Ambi.DarkRP.RemoveDoorOwner( eDoor, ePly )
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end
    if ( eDoor.first_owner == ePly ) then Ambi.DarkRP.RemoveDoorOwners( eDoor ) return end

    local count = 0
    local num_ply = 0
    for i, ply in ipairs( eDoor.owners ) do
        if ( ply == ePly ) then num_ply = i end

        count = count + 1
    end

    if ( count == 1 ) then Ambi.DarkRP.RemoveDoorOwners( eDoor ) return end

    for i = num_ply, #eDoor.owners do
        local next_owner = eDoor.owners[ i + 1 ]
        if not next_owner then break end

        eDoor.owners[ i ] = next_owner
    end

    ePly.doors[ eDoor ] = nil

    eDoor.owners[ #eDoor.owners ] = nil
    if not eDoor.owners then eDoor.owners = {} end -- таблица всегда должна быть
end

function Ambi.DarkRP.RemoveDoorOwners( eDoor )
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end
    if SQL.Select( DB, 'Map', 'Door', eDoor:EntIndex() ) then SQL.Delete( DB, 'Door', eDoor:EntIndex() ) end

    for i, ply in ipairs( eDoor.owners ) do
        ply.doors[ eDoor ] = nil
    end 

    eDoor.first_owner = nil
    eDoor.owners = {}
    eDoor.nw_IsOwned = false
    eDoor.nw_Title = 'Дверь №'..eDoor:EntIndex()

    eDoor:Fire( 'Unlock', '1' )
end

function Ambi.DarkRP.CheckDoorOwner( eDoor, ePly )
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end
    local category = eDoor.nw_Category

    if string.IsValid( category ) then
        local jobs = Ambi.DarkRP.doors_categories[ category ]
        for _, job in ipairs( jobs ) do
            if ( job == ePly:GetJob() ) then return true end
        end
    end
    
    local owners = eDoor.owners or {}

    for _, owner in ipairs( owners ) do
        if ( owner == ePly ) then return ePly end
    end
end

--------------------------------------------------------------------------------------------------------------------------------------
local PLAYER = FindMetaTable( 'Player' )

function PLAYER:SellDoors()
    local count = 0
    for door, _ in pairs( self.doors ) do
        count = count + 1

        if ( door.first_owner == self ) then self:AddMoney( Ambi.DarkRP.Config.doors_cost_sell ) end

        Ambi.DarkRP.RemoveDoorOwner( door, self )
    end

    if ( count > 0 ) then 
        self:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вы продали ', C.AMBI, tostring( count ), C.ABS_WHITE, ' дверей и получили ', C.AMBI_GREEN, tostring( Ambi.DarkRP.Config.doors_cost_sell * count )..Ambi.DarkRP.Config.money_currency_symbol ) 
    end
end

--------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'InitPostEntity', 'Ambi.DarkRP.DoorsInit', function() 
    timer.Simple( 1, function()
        local doors = SQL.SelectAll( DB )
        
        for _, door in ipairs( ents.GetAll() ) do
            if Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then
                door.owners = {}
                if not doors then continue end

                for _, v in ipairs( doors ) do
                    if ( v.Map != game.GetMap() ) then continue end
                    if ( tonumber( v.Door ) != door:EntIndex() ) then continue end

                    if tobool( v.IsBlock ) then
                        door.nw_IsBlocked = true
                    end

                    if string.IsValid( v.Category ) then
                        if Ambi.DarkRP.doors_categories[ v.Category ] then
                            door.nw_Category = v.Category
                        else
                            SQL.Delete( DB, 'Door', door:EntIndex() )
                            print( '[DarkRP] Category is '..v.Category..' already not exists, the door '..door:EntIndex()..' are free!' )
                        end
                    end
                end
            end
        end
    end )
end )

local function BuyDoor( ePly )
    local door = ePly:GetEyeTrace().Entity
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end
    if ( ePly:GetPos():Distance( door:GetPos() ) > 78 ) then return end

    if door.nw_IsOwned then return end
    if door.nw_IsBlocked then return end

    if ( hook.Call( '[Ambi.DarkRP.CanBuyDoor]', nil, ePly, door ) == false ) then return end

    local cost = Ambi.DarkRP.Config.doors_cost_buy
    if not ePly:CanSpendMoney( cost ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Не хватает денег!' ) return end

    local count = 0
    for door, _ in pairs( ePly.doors ) do
        count = count + 1
    end
    
    local max = ePly:GetJobTable().doors_max or Ambi.DarkRP.Config.doors_max
    if ( count >= max ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы достигли максимум дверей!' ) return end

    ePly:AddMoney( -cost )
    ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы приобрели дверь!' )
    Ambi.DarkRP.AddDoorOwner( door, ePly )

    hook.Call( '[Ambi.DarkRP.BoughtDoor]', nil, ePly, door )
end

local function SellDoor( ePly )
    local door = ePly:GetEyeTrace().Entity
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end
    if ( ePly:GetPos():Distance( door:GetPos() ) > 78 ) then return end

    if ( hook.Call( '[Ambi.DarkRP.CanSellDoor]', nil, ePly, door ) == false ) then return end

    if string.IsValid( door.nw_Category ) then return end
    if door.nw_IsBlocked then return end

    local phrase = 'отдали ключи от двери!'
    if ( door.first_owner == ePly ) then 
        ePly:AddMoney( Ambi.DarkRP.Config.doors_cost_sell ) 
        phrase = 'продали дверь!'
    end

    ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы '..phrase )
    Ambi.DarkRP.RemoveDoorOwner( door, ePly )

    hook.Call( '[Ambi.DarkRP.SoldDoor]', nil, ePly, door )
end

hook.Add( 'ShowTeam', 'Ambi.DarkRP.BuySellDoors', function( ePly ) 
    if timer.Exists( 'AmbiDarkRPStopFloodBuySellDoors:'..ePly:SteamID() ) then return end
    timer.Create( 'AmbiDarkRPStopFloodBuySellDoors:'..ePly:SteamID(), 0.55, 1, function() end )

    local door = ePly:GetEyeTrace().Entity
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end
    if ( ePly:GetPos():Distance( door:GetPos() ) > 78 ) then return end

    if Ambi.DarkRP.CheckDoorOwner( door, ePly ) then
        SellDoor( ePly )
    else
        BuyDoor( ePly )
    end
end )

hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.SetDoorsTable', function( ePly ) 
    ePly.doors = {}
end )

hook.Add( 'PlayerDisconnected', 'Ambi.DarkRP.SellDoors', function( ePly ) 
    for door, _ in pairs( ePly.doors ) do
        if not IsValid( door ) then continue end

        Ambi.DarkRP.RemoveDoorOwner( door, ePly )
    end
end )


--------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_darkrp_buy_door_request' )
net.AddString( 'ambi_darkrp_sell_door_request' )
net.AddString( 'ambi_darkrp_controll_menu_door_request' )

net.AddString( 'ambi_darkrp_buy_door' )
net.Receive( 'ambi_darkrp_buy_door', function( _, ePly ) 
    BuyDoor( ePly )
end )

net.AddString( 'ambi_darkrp_sell_door' )
net.Receive( 'ambi_darkrp_sell_door', function( _, ePly ) 
    SellDoor( ePly )
end )

net.AddString( 'ambi_darkrp_set_coowner_door' )
net.Receive( 'ambi_darkrp_set_coowner_door', function( _, ePly ) 
    local coowner, door = net.ReadEntity(), net.ReadEntity()
    if not IsValid( coowner ) or not coowner:IsPlayer() or ( coowner == ePly ) then return end
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end
    if ( door.first_owner != ePly ) then return end

    if coowner.doors[ door ] then 
        ePly:ChatPrint( 'Вы удалили Со-Владельца!' )
        Ambi.DarkRP.RemoveDoorOwner( door, coowner )
    else
        ePly:ChatPrint( 'Вы добавили Со-Владельца' )
        Ambi.DarkRP.AddDoorOwner( door, coowner )
    end
end )

net.AddString( 'ambi_darkrp_change_title_door' )
net.Receive( 'ambi_darkrp_change_title_door', function( _, ePly ) 
    local title, door = net.ReadString(), net.ReadEntity()
    if not string.IsValid( title ) or ( utf8.len( title ) > 28 ) then return end
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end
    if ( door.first_owner != ePly ) then return end

    door.nw_Title = title
end )

net.AddString( 'ambi_darkrp_set_free_door' )
net.Receive( 'ambi_darkrp_set_free_door', function( _, ePly ) 
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Попытка, обычного игрока, освободить дверь' ) return end

    local door = net.ReadEntity()
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end

    Ambi.DarkRP.SetDoorFree( door )
end )

net.AddString( 'ambi_darkrp_set_block_door' )
net.Receive( 'ambi_darkrp_set_block_door', function( _, ePly ) 
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Попытка, обычного игрока, (-за/раз)блокировать дверь' ) return end

    local door = net.ReadEntity()
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end

    if door.nw_IsBlocked then ePly:ChatPrint( 'Дверь уже заблокирована' ) return end

    Ambi.DarkRP.SetDoorBlockOwn( door )
end )

net.AddString( 'ambi_darkrp_set_category_door' )
net.Receive( 'ambi_darkrp_set_category_door', function( _, ePly ) 
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Попытка, обычного игрока, назначить для двери категорию' ) return end

    local category = net.ReadString()
    if not Ambi.DarkRP.GetDoorCategory( category ) then return end

    local door = net.ReadEntity()
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end

    Ambi.DarkRP.SetDoorCategory( door, category )
end )

net.AddString( 'ambi_darkrp_get_info_door' )
net.Receive( 'ambi_darkrp_get_info_door', function( _, ePly ) 
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Попытка, обычного игрока, узнать инфу о двери' ) return end

    local door = net.ReadEntity()

    ePly:ChatSend( C.AMBI_RED, '\n==================' )
    ePly:ChatSend( C.ABS_WHITE, 'Дверь: ', C.AMBI_RED, tostring( door ) )
    ePly:ChatSend( C.ABS_WHITE, 'Владельцы: ' )
    for i, ply in ipairs( door.owners ) do
        ePly:ChatSend( C.AMBI_RED, i..'. ', C.ABS_WHITE, ply:Nick() )
    end
    ePly:ChatSend( C.AMBI_RED, '==================\n' )
end )