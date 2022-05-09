local PLAYER = FindMetaTable( 'Player' )
local ENTITY = FindMetaTable( 'Entity' )

DarkRP = DarkRP or {}

DarkRPEntities = DarkRPEntities or {}
CustomShipments = CustomShipments or {}
FoodItems = FoodItems or {}

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:getDarkRPVar( sVar )
    if ( sVar == 'money' ) then return self:GetMoney()
    elseif ( sVar == 'wanted' ) then return self:IsWanted()
    elseif ( sVar == 'warrant' ) then return self:HasWarrant()
    elseif ( sVar == 'salary' ) then return self:GetJobTable().salary
    elseif ( sVar == 'rpname' ) then return self:Nick()
    elseif ( sVar == 'Energy' ) then return nil
    elseif ( sVar == 'job' ) then return self:TeamName()
    elseif ( sVar == 'HasGunlicense' ) then return self:HasLicenseGun()
    elseif ( sVar == 'wantedReason' ) then return ''
    elseif ( sVar == 'AFKDemoted' ) then return false
    elseif ( sVar == 'Arrested' ) then return self:IsArrested()
    elseif ( sVar == 'AFK' ) then return false
    elseif ( sVar == 'agenda' ) then return ''
    end
end
PLAYER.GetDarkRPVar = PLAYER.getDarkRPVar

function PLAYER:setDarkRPVar( sVar, anyVal )
    local oldval = self:GetDarkRPVar( sVar )

    if ( sVar == 'money' ) then return self:SetMoney( anyVal )
    elseif ( sVar == 'wanted' ) then return self:SetWanted( anyVal )
    elseif ( sVar == 'warrant' ) then return self:SetWarrant( anyVal )
    elseif ( sVar == 'HasGunlicense' ) then return self:HasLicenseGun()
    elseif ( sVar == 'wantedReason' ) then return ''
    elseif ( sVar == 'AFKDemoted' ) then return false
    elseif ( sVar == 'AFK' ) then return false
    elseif ( sVar == 'agenda' ) then return ''
    end

    hook.Call( 'DarkRPVarChanged', nil, self, sVar, oldval, anyVal )
end
PLAYER.SetDarkRPVar = PLAYER.setDarkRPVar
PLAYER.setSelfDarkRPVar = PLAYER.setDarkRPVar

function PLAYER:getAgendaTable()
    return {}
end

function PLAYER:isArrested()
    return self:IsArrested()
end

function PLAYER:isWanted()
    return self:IsWanted()
end

function PLAYER:getWantedReason()
    return 'Совершение Преступления'
end

function PLAYER:isCP()
    return self:IsPolice()
end

function PLAYER:isMayor()
    return self:IsMayor()
end

function PLAYER:isChief()
    return self:IsPolice()
end

function PLAYER:warrant( ePolice, sReason )
    return Ambi.DarkRP.WarrantPlayer( self, ePolice, sReason )
end

function PLAYER:unWarrant( ePolice )
    self.nw_HasWarrant = false
end

function PLAYER:wanted( ePolice, sReason, nTime )
    return Ambi.DarkRP.WantedPlayer( self, ePolice, sReason, nTime )
end

function PLAYER:unWanted( ePolice )
    return Ambi.DarkRP.UnWantedPlayer( self )
end

function PLAYER:arrest( nTime, ePolice )
    return Ambi.DarkRP.ArrestPlayer( self, ePolice, '', nTime )
end

function PLAYER:unArrest( ePolice )
    return Ambi.DarkRP.UnArrestPlayer( self, ePolice )
end

function PLAYER:canAfford( nPrice )
    if not nPrice then return false end

    return self:GetMoney() >= nPrice
end

function PLAYER:addMoney( nMoney )
    return self:AddMoney( nMoney )
end

function PLAYER:getJobTable() return self:GetJobTable() end

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
function ENTITY:Setowning_ent( ePly )
    ePly:SetShopBuyer( self )
end

function ENTITY:Getowning_ent()
    return self:GetShopBuyer()
end

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
function DarkRP.getCategories()
    local tab = {}

    tab.jobs = {}
    for i, v in pairs( Ambi.DarkRP.GetJobs() ) do
        tab.jobs[ v.category ] = {
            name = v.category,
            categorises = 'jobs',
            startExpanded = true,
            color = v.color,
            canSee = function( ply ) return true end,
            sortOrder = 100,
            members = tab.jobs[ v.category ] and tab.jobs[ v.category ].members or {}
        }

        tab.jobs[ v.category ].members[ v.index ] = v
    end

    tab.entities = {}
    tab.shipments = {}
    tab.weapons = {}
    for i, v in pairs( Ambi.DarkRP.GetShop() ) do
        if v.shipment then 
            tab.shipments[ v.category ] = {
                name = v.category,
                categorises = 'shipments',
                startExpanded = true,
                color = Color( 228, 191, 80),
                canSee = function( ply ) return true end,
                sortOrder = 100,
                members = tab.shipments[ v.category ] and tab.shipments[ v.category ].members or {}
            }

            tab.shipments[ v.category ].members[ i ] = v
        elseif v.weapons then 
            tab.weapons[ v.category ] = {
                name = v.category,
                categorises = 'weapons',
                startExpanded = true,
                color = Color( 216, 216, 216),
                canSee = function( ply ) return true end,
                sortOrder = 100,
                members = tab.weapons[ v.category ] and tab.weapons[ v.category ].members or {}
            }

            tab.weapons[ v.category ].members[ i ] = v
        else 
            tab.entities[ v.category ] = {
                name = v.category,
                categorises = 'entities',
                startExpanded = true,
                color = Color( 216, 216, 216),
                canSee = function( ply ) return true end,
                sortOrder = 100,
            }
        end
    end

    tab.vehicles = {}
    tab.ammo = {}

    return tab
end

function DarkRP.createCategory() return end

function DarkRP.AddDoorGroup( sName, ... )
    local tab = { ... }

    local jobs = {}
    for i, v in ipairs( tab ) do
        if Ambi.DarkRP.GetJobByIndex( v ) then jobs[ #jobs + 1 ] = v.class end
    end

    if ( #jobs == 0 ) then return end

    Ambi.DarkRP.AddDoorCategory( sName, jobs )
end

function DarkRP.createEntity( sName, tItem )
    if not Ambi.DarkRP.compatibility_shop then return end
    if not sName or not tItem then return end

    local tab = table.Merge( tItem, { name = sName } )

    return Ambi.DarkRP.AddShopItem( sName, tItem )
end

function DarkRP.formatMoney( nMoney )
    return tostring( nMoney )..Ambi.DarkRP.Config.money_currency_symbol
end

function DarkRP.notify(ply, msgtype, len, msg)
    if not IsValid( ply ) then print( msg ) return end

    ply:ChatPrint( msg )
end

function DarkRP.notifyAll(msgtype, len, msg)
    for _, v in ipairs( player.GetAll() ) do
        v:ChatPrint( msg )
    end
end

function DarkRP.printMessageAll(msgtype, msg)
    for _, v in ipairs( player.GetAll() ) do
        v:ChatPrint( msg )
    end
end

function DarkRP.printConsoleMessage(ply, msg)
    if ply:EntIndex() == 0 then
        print(msg)
    else
        ply:PrintMessage(HUD_PRINTCONSOLE, msg)
    end
end

function DarkRP.talkToRange(ply, PlayerName, Message, size)
    local ents = ents.FindInSphere(ply:EyePos(), size)
    local col = team.GetColor(ply:Team())
    local filter = {}

    for _, v in ipairs(ents) do
        if v:IsPlayer() and not v:IsBot() and (v == ply or hook.Run("PlayerCanSeePlayersChat", PlayerName .. ": " .. Message, false, v, ply) ~= false) then
            v:ChatPrint( Message )
        end
    end

end

function DarkRP.talkToPerson(receiver, col1, text1, col2, text2, sender)
    if not IsValid(receiver) then return end
    if receiver:IsBot() then return end
    local concatenatedText = (text1 or "") .. ": " .. (text2 or "")

    if sender == receiver or hook.Run("PlayerCanSeePlayersChat", concatenatedText, false, receiver, sender) ~= false then
        sender:ChatPrint( concatenatedText )
    end
end

function DarkRP.isEmpty(vector, ignore)
    ignore = ignore or {}

    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(ents.FindInSphere(vector, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not table.HasValue(ignore, v) then
            b = false
            break
        end
    end

    return a and b
end

function DarkRP.placeEntity(ent, tr, ply)
    if IsValid(ply) then
        local ang = ply:EyeAngles()
        ang.pitch = 0
        ang.yaw = ang.yaw + 180
        ang.roll = 0
        ent:SetAngles(ang)
    end

    local vFlushPoint = tr.HitPos - (tr.HitNormal * 512)
    vFlushPoint = ent:NearestPoint(vFlushPoint)
    vFlushPoint = ent:GetPos() - vFlushPoint
    vFlushPoint = tr.HitPos + vFlushPoint
    ent:SetPos(vFlushPoint)
end

function DarkRP.findEmptyPos(pos, ignore, distance, step, area)
    if DarkRP.isEmpty(pos, ignore) and DarkRP.isEmpty(pos + area, ignore) then
        return pos
    end

    for j = step, distance, step do
        for i = -1, 1, 2 do -- alternate in direction
            local k = j * i

            -- Look North/South
            if DarkRP.isEmpty(pos + Vector(k, 0, 0), ignore) and DarkRP.isEmpty(pos + Vector(k, 0, 0) + area, ignore) then
                return pos + Vector(k, 0, 0)
            end

            -- Look East/West
            if DarkRP.isEmpty(pos + Vector(0, k, 0), ignore) and DarkRP.isEmpty(pos + Vector(0, k, 0) + area, ignore) then
                return pos + Vector(0, k, 0)
            end

            -- Look Up/Down
            if DarkRP.isEmpty(pos + Vector(0, 0, k), ignore) and DarkRP.isEmpty(pos + Vector(0, 0, k) + area, ignore) then
                return pos + Vector(0, 0, k)
            end
        end
    end

    return pos
end

function DarkRP.lockdown()
    Ambi.DarkRP.SetLockdown( true )
end

function DarkRP.unLockdown()
    Ambi.DarkRP.SetLockdown( false )
end

function DarkRP.resetLaws()
    Ambi.DarkRP.ClearLaws()
end

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( '[Ambi.DarkRP.SetLaw]', 'Ambi.DarkRP.Compatibility', function( ePly, nID, sText, sOldText )
    if ( sText == '' ) then hook.Call( 'removeLaw', nil, nID, sText, ePly ) else hook.Call( 'addLaw', nil, nID, sText, ePly ) end
end )

hook.Add( '[Ambi.DarkRP.ClearLaws]', 'Ambi.DarkRP.Compatibility', function( ePlу )
    hook.Call( 'resetLaws', nil, ePly )
end )

hook.Add( '[Ambi.DarkRP.CanWarrant]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget, sReason )
    if ( hook.Call( 'canRequestWarrant', nil, eTarget, ePly, sReason ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUnWarrant]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget )
    if ( hook.Call( 'canRemoveWarrant', nil, eTarget, ePly ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanWanted]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget, sReason )
    if ( hook.Call( 'canWanted', nil, eTarget, ePly, sReason ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUnWanted]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget )
    if ( hook.Call( 'canUnwant', nil, eTarget, ePly ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.BoughtDoor]', 'Ambi.DarkRP.Compatibility', function( ePly, eDoor )
    hook.Call( 'playerBoughtDoor', nil, ePly, eDoor, Ambi.DarkRP.Config.doors_cost_buy )
end )

hook.Add( '[Ambi.DarkRP.CanBuyDoor]', 'Ambi.DarkRP.Compatibility', function( ePly, eDoor )
    if ( hook.Call( 'playerBuyDoor', nil, ePly, eDoor ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanBuyShopItem]', 'Ambi.DarkRP.Compatibility', function( ePly, sClass, bForce ) 
    local item = Ambi.DarkRP.GetShopItem( sClass )

    if item.shipment then
        if ( hook.Call( 'canBuyShipment', nil, ePly, item ) == false ) then return false end
    elseif item.weapon then
        if ( hook.Call( 'canBuyPistol', nil, ePly, item ) == false ) then return false end
    else
        if ( hook.Call( 'canBuyCustomEntity', nil, ePly, item ) == false ) then return false end
    end
end )

hook.Add( '[Ambi.DarkRP.CanArrest]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice, sReason, nTime )
    local can, msg = hook.Call( 'canArrest', nil, ePolice, ePly )

    if ( can == false ) then ePolice:ChatPrint( msg or '' ) return false end
end )

hook.Add( '[Ambi.DarkRP.CanUnArrest]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice )
    if not IsValid( ePolice ) then return end

    local can, msg = hook.Call( 'canUnarrest', nil, ePolice, ePly )

    if ( can == false ) then ePolice:ChatPrint( msg or '' ) return false end
end )

hook.Add( '[Ambi.DarkRP.CanDoorRam]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj )
    if ( hook.Call( 'canDoorRam', nil, ePly, ePly:GetEyeTrace(), eObj ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.OnDoorRamUsed]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj )
    if ( hook.Call( 'onDoorRamUsed', nil, true, ePly, ePly:GetEyeTrace() ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanDropWeapon]', 'Ambi.DarkRP.Compatibility', function( ePly, sClass, eWeapon )
    if ( hook.Call( 'canDropWeapon', nil, ePly, eWeapon ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUseKeysLock]', 'Ambi.DarkRP.Compatibility', function( ePly, eDoor )
    if ( hook.Call( 'canKeysLock', nil, ePly, eDoor ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUseKeysUnLock]', 'Ambi.DarkRP.Compatibility', function( ePly, eDoor )
    if ( hook.Call( 'canKeysUnlock', nil, ePly, eDoor ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUseLockpick]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj )
    if ( hook.Call( 'canLockpick', nil, ePly, eObj, ePly:GetEyeTrace() ) == false ) then return false end
end )

hook.Add( 'InitPostEntity', 'Ambi.DarkRP.Compatibility', function() 
    hook.Call( 'DarkRPDBInitialized' )
    hook.Call( 'DarkRPStartedLoading' )
    hook.Call( 'DarkRPFinishedLoading' )
end )

hook.Add( '[Ambi.DarkRP.Advert]', 'Ambi.DarkRP.Compatibility', function( ePly, sText )
    hook.Call( 'playerAdverted', nil, ePly, sText )
end )

hook.Add( '[Ambi.DarkRP.PlayerArrested]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice, sReason, nTime )
    hook.Call( 'playerArrested', nil, ePly, nTime, ePolice )
end )

hook.Add( '[Ambi.DarkRP.BuyShopItem]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj, sClass, bForce, tItem )
    if tItem.shipment then hook.Call( 'playerBoughtShipment', nil, ePly, tItem, eObj, tItem.price )
    elseif tItem.weapon then hook.Call( 'playerBoughtPistol', nil, ePly, tItem, eObj, tItem.price )
    else hook.Call( 'playerBoughtCustomEntity', nil, ePly, tItem, eObj, tItem.price )
    end
end )

hook.Add( '[Ambi.DarkRP.DroppedWeapon]', 'Ambi.DarkRP.Compatibility', function( ePly, eWeapon, tWeapon ) 
    hook.Call( 'onDarkRPWeaponDropped', nil, ePly, eWeapon, tWeapon )
end )

hook.Add( '[Ambi.DarkRP.DroppedMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj ) 
    hook.Call( 'playerDroppedMoney', nil, ePly, eObj.nw_Money, eObj )
end )

hook.Add( '[Ambi.DarkRP.TransferedMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget, nCount ) 
    hook.Call( 'playerGaveMoney', nil, ePly, eTarget, nCount )
end )

hook.Add( '[Ambi.DarkRP.PlayerPickupMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, eMoney, nMoney ) 
    hook.Call( 'playerPickedUpMoney', nil, ePly, nMoney, eMoney )
end )

hook.Add( '[Ambi.DarkRP.PlayerPickupWeapon]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj ) 
    hook.Call( 'PlayerPickupDarkRPWeapon', nil, ePly, eObj )
end )

hook.Add( '[Ambi.DarkRP.CanSellDoor]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj ) 
    if not Ambi.DarkRP.compatibility_doors then return end

    local can, msg = hook.Call( 'playerSellDoor', nil, ePly, eObj )

    if ( can == false ) then ePly:ChatPrint( msg ) return end
end )

hook.Add( '[Ambi.DarkRP.PlayerUnArrested]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice ) 
    hook.Call( 'playerUnArrested', nil, ePly, ePolice )
end )

hook.Add( '[Ambi.DarkRP.PlayerUnWanted]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice ) 
    hook.Call( 'playerUnWanted', nil, ePly, ePolice )
end )

hook.Add( '[Ambi.DarkRP.PlayerUnWarranted]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice ) 
    hook.Call( 'playerUnWarranted', nil, ePly, ePolice )
end )

hook.Add( '[Ambi.DarkRP.SetMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, nMoney, nOldMoney )
    hook.Call( 'playerWalletChanged', nil, ePly, nMoney, nOldMoney )
end )

hook.Add( '[Ambi.DarkRP.PlayerWanted]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice, sReason )
    hook.Call( 'playerWanted', nil, ePly, ePolice, sReason )
end )

hook.Add( '[Ambi.DarkRP.PlayerWarrant]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice, sReason )
    hook.Call( 'playerWarranted', nil, ePly, ePolice, sReason )
end )

hook.Add( '[Ambi.DarkRP.AddedShopItem]', 'Ambi.DarkRP.Compatibility', function( sClass, tItem )
    if not tItem.shipment then 
        local index = #DarkRPEntities + 1
        for i, v in ipairs( DarkRPEntities ) do
            if ( v.class == sClass ) then index = i break end
        end

        tItem.class = sClass
        DarkRPEntities[ index ] = tItem 
    else
        CustomShipments[ sClass ] = tItem 
    end
end )

hook.Add( '[Ambi.DarkRP.RemovedShopItem]', 'Ambi.DarkRP.Compatibility', function( sClass, tItem )
    if not tItem.shipment then 
        local index = #DarkRPEntities + 1
        for i, v in ipairs( DarkRPEntities ) do
            if ( v.class == sClass ) then index = i break end
        end
        
        DarkRPEntities[ index ] = {} 
    else 
        CustomShipments[ sClass ] = nil 
    end
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
GAMEMODE = GAMEMODE or {}
GAMEMODE.Config = GAMEMODE.Config or {}
GM = GM or {}
setmetatable( GM, { __index = GAMEMODE } )

GAMEMODE.Config.voice3D = Ambi.DarkRP.Config.chat_voice_3d
GAMEMODE.Config.AdminsCopWeapons = true
GAMEMODE.Config.allowActs = true
GAMEMODE.Config.allowjobswitch = true
GAMEMODE.Config.allowrpnames = false
GAMEMODE.Config.allowsprays = false
GAMEMODE.Config.allowvehicleowning = false
GAMEMODE.Config.allowvnocollide = true
GAMEMODE.Config.alltalk = Ambi.DarkRP.Config.chat_restrict_enable
GAMEMODE.Config.antimultirun = false
GAMEMODE.Config.autovehiclelock = false
GAMEMODE.Config.babygod = false
GAMEMODE.Config.canforcedooropen = false
GAMEMODE.Config.chatsounds = false
GAMEMODE.Config.chiefjailpos = false
GAMEMODE.Config.cit_propertytax = false
GAMEMODE.Config.copscanunfreeze = false
GAMEMODE.Config.copscanunweld = false
GAMEMODE.Config.cpcanarrestcp = Ambi.DarkRP.Config.police_system_arrest_can_other_police
GAMEMODE.Config.currencyLeft = true
GAMEMODE.Config.customjobs = Ambi.DarkRP.Config.jobs_can_change_name
GAMEMODE.Config.customspawns = true
GAMEMODE.Config.deathblack = false
GAMEMODE.Config.showdeaths = true
GAMEMODE.Config.deadtalk = true
GAMEMODE.Config.deadvoice = false
GAMEMODE.Config.deathpov = false
GAMEMODE.Config.decalcleaner = false
GAMEMODE.Config.disallowClientsideScripts = false
GAMEMODE.Config.doorwarrants = true
GAMEMODE.Config.dropmoneyondeath = false
GAMEMODE.Config.droppocketarrest = false
GAMEMODE.Config.droppocketdeath = false
GAMEMODE.Config.dropweapondeath = false
GAMEMODE.Config.dropspawnedweapons = false
GAMEMODE.Config.dynamicvoice = false
GAMEMODE.Config.earthquakes = false
GAMEMODE.Config.enablebuypistol = false
GAMEMODE.Config.enforceplayermodel = true
GAMEMODE.Config.globalshow = Ambi.DarkRP.Config.hud_3d_enable
GAMEMODE.Config.ironshoot = false
GAMEMODE.Config.showjob = Ambi.DarkRP.Config.hud_3d_show_job
GAMEMODE.Config.letters = false
GAMEMODE.Config.license = false
GAMEMODE.Config.lockdown = true
GAMEMODE.Config.lockpickfading = true
GAMEMODE.Config.logging = true
GAMEMODE.Config.lottery = false
GAMEMODE.Config.showname = Ambi.DarkRP.Config.hud_3d_show_name
GAMEMODE.Config.showhealth = Ambi.DarkRP.Config.hud_3d_show_health
GAMEMODE.Config.needwantedforarrest = Ambi.DarkRP.Config.police_system_arrest_only_wanted
GAMEMODE.Config.noguns = false
GAMEMODE.Config.norespawn = not Ambi.DarkRP.Config.jobs_respawn
GAMEMODE.Config.instantjob = false
GAMEMODE.Config.npcarrest = false
GAMEMODE.Config.ooc = true
GAMEMODE.Config.propertytax = false
GAMEMODE.Config.proppaying = false
GAMEMODE.Config.propspawning = true
GAMEMODE.Config.removeclassitems = true
GAMEMODE.Config.removeondisconnect = false
GAMEMODE.Config.respawninjail = true
GAMEMODE.Config.restrictallteams = false
GAMEMODE.Config.restrictbuypistol = false
GAMEMODE.Config.restrictdrop = false
GAMEMODE.Config.revokeLicenseOnJobChange = false
GAMEMODE.Config.shouldResetLaws = false
GAMEMODE.Config.strictsuicide = Ambi.DarkRP.Config.restrict_can_suicide
GAMEMODE.Config.telefromjail = false
GAMEMODE.Config.teletojail = false
GAMEMODE.Config.unlockdoorsonstart = false
GAMEMODE.Config.voiceradius = Ambi.DarkRP.Config.chat_voice_local_enable
GAMEMODE.Config.wallettax = false
GAMEMODE.Config.wantedrespawn = false
GAMEMODE.Config.wantedsuicide = false
GAMEMODE.Config.realisticfalldamage = false
GAMEMODE.Config.printeroverheat = false
GAMEMODE.Config.weaponCheckerHideDefault = true
GAMEMODE.Config.weaponCheckerHideNoLicense = false

GAMEMODE.Config.adminnpcs                     = Ambi.DarkRP.Config.restrict_spawn_npcs
GAMEMODE.Config.adminsents                    = Ambi.DarkRP.Config.restrict_spawn_entities
GAMEMODE.Config.adminvehicles                 = Ambi.DarkRP.Config.restrict_spawn_vehicles
GAMEMODE.Config.adminweapons                  = Ambi.DarkRP.Config.restrict_spawn_weapons
GAMEMODE.Config.arrestspeed                   = 120
GAMEMODE.Config.babygodtime                   = 5
GAMEMODE.Config.chatsoundsdelay               = 5
GAMEMODE.Config.deathfee                      = 30
GAMEMODE.Config.decaltimer                    = 120
GAMEMODE.Config.demotetime                    = Ambi.DarkRP.Config.jobs_demote_delay
GAMEMODE.Config.doorcost                      = Ambi.DarkRP.Config.doors_cost_buy
GAMEMODE.Config.entremovedelay                = 0
GAMEMODE.Config.gunlabweapon                  = "weapon_p2282"
GAMEMODE.Config.jailtimer                     = Ambi.DarkRP.Config.police_system_arrest_time
GAMEMODE.Config.lockdowndelay                 = 120
GAMEMODE.Config.maxadvertbillboards           = 0
GAMEMODE.Config.maxCheques                    = 0
GAMEMODE.Config.maxdoors                      = Ambi.DarkRP.Config.doors_max
GAMEMODE.Config.maxdrugs                      = 0
GAMEMODE.Config.maxfoods                      = 2
GAMEMODE.Config.maxfooditems                  = 20
GAMEMODE.Config.maxlawboards                  = 0
GAMEMODE.Config.maxletters                    = 0
GAMEMODE.Config.maxlotterycost                = 0
GAMEMODE.Config.maxvehicles                   = 0
GAMEMODE.Config.microwavefoodcost             = 30
GAMEMODE.Config.minlotterycost                = 30
GAMEMODE.Config.moneyRemoveTime               = 600
GAMEMODE.Config.mprintamount                  = 250
GAMEMODE.Config.normalsalary                  = 45
GAMEMODE.Config.npckillpay                    = 10
GAMEMODE.Config.paydelay                      = Ambi.DarkRP.Config.player_payday_delay
GAMEMODE.Config.pocketitems                   = 0
GAMEMODE.Config.pricecap                      = 500
GAMEMODE.Config.pricemin                      = 50
GAMEMODE.Config.propcost                      = 0
GAMEMODE.Config.quakechance                   = 4000
GAMEMODE.Config.respawntime                   = 1
GAMEMODE.Config.changejobtime                 = 10
GAMEMODE.Config.runspeed                      = 240
GAMEMODE.Config.runspeedcp                    = 255
GAMEMODE.Config.searchtime                    = 30
GAMEMODE.Config.ShipmentSpamTime              = 3
GAMEMODE.Config.shipmentspawntime             = 10
GAMEMODE.Config.startinghealth                = 100
GAMEMODE.Config.startingmoney                 = 500
GAMEMODE.Config.stunstickdamage               = 1000
GAMEMODE.Config.vehiclecost                   = 40
GAMEMODE.Config.wallettaxmax                  = 5
GAMEMODE.Config.wallettaxmin                  = 1
GAMEMODE.Config.wallettaxtime                 = 600
GAMEMODE.Config.wantedtime                    = 120
GAMEMODE.Config.walkspeed                     = 160
GAMEMODE.Config.falldamagedamper              = 15
GAMEMODE.Config.falldamageamount              = 10
GAMEMODE.Config.printeroverheatchance         = 22
GAMEMODE.Config.printerreward                 = 950

GAMEMODE.Config.talkDistance    = Ambi.DarkRP.Config.chat_max_length
GAMEMODE.Config.whisperDistance = Ambi.DarkRP.Config.chat_max_length_whisper
GAMEMODE.Config.yellDistance    = Ambi.DarkRP.Config.chat_max_length_scream
GAMEMODE.Config.meDistance      = Ambi.DarkRP.Config.chat_max_length
GAMEMODE.Config.voiceDistance   = Ambi.DarkRP.Config.chat_voice_max_length

GAMEMODE.Config.MoneyClass = Ambi.DarkRP.Config.money_drop_entity_class
GAMEMODE.Config.moneyModel = Ambi.DarkRP.Config.money_drop_entity_model
GAMEMODE.Config.lockdownsound = Ambi.DarkRP.Config.goverment_lockdown_sound
GAMEMODE.Config.DarkRPSkin = "DarkRP"
GAMEMODE.Config.currency = Ambi.DarkRP.Config.money_currency_symbol
GAMEMODE.Config.chatCommandPrefix = "/"
GAMEMODE.Config.F1MenuHelpPage = 'https://github.com/Titanovsky/AE-DarkRP'
GAMEMODE.Config.F1MenuHelpPageTitle = 'DarkRP'
GAMEMODE.Config.notificationSound = "buttons/lightswitch2.wav"

GAMEMODE.Config.DefaultPlayerGroups = {
    [ 'STEAM_0:1:95303327' ] = 'superadmin',
}

GAMEMODE.Config.DisabledCustomModules = {
    ["hudreplacement"] = false,
    ["extraf4tab"] = false,
}

-- The list of weapons that players are not allowed to drop. Items set to true are not allowed to be dropped.
GAMEMODE.Config.DisallowDrop = Ambi.DarkRP.Config.weapon_drop_blocked

-- The list of weapons people spawn with.
GAMEMODE.Config.DefaultWeapons = Ambi.DarkRP.Config.player_base_weapons

GAMEMODE.Config.CategoryOverride = {
    jobs = {
        ["Citizen"]                             = "Citizens",
        ["Hobo"]                                = "Citizens",
        ["Gun Dealer"]                          = "Citizens",
        ["Medic"]                               = "Citizens",
        ["Civil Protection"]                    = "Civil Protection",
        ["Gangster"]                            = "Gangsters",
        ["Mob boss"]                            = "Gangsters",
        ["Civil Protection Chief"]              = "Civil Protection",
        ["Mayor"]                               = "Civil Protection",
    },
    entities = {
        ["Drug lab"]                            = "Other",
        ["Money printer"]                       = "Other",
        ["Gun lab"]                             = "Other",

    },
    shipments = {
        ["AK47"]                                = "Rifles",
        ["MP5"]                                 = "Rifles",
        ["M4"]                                  = "Rifles",
        ["Mac 10"]                              = "Other",
        ["Pump shotgun"]                        = "Shotguns",
        ["Sniper rifle"]                        = "Snipers",

    },
    weapons = {
        ["Desert eagle"]                        = "Pistols",
        ["Fiveseven"]                           = "Pistols",
        ["Glock"]                               = "Pistols",
        ["P228"]                                = "Pistols",
    },
    vehicles = {}, -- There are no default vehicles.
    ammo = {
        ["Pistol ammo"]                         = "Other",
        ["Shotgun ammo"]                        = "Other",
        ["Rifle ammo"]                          = "Other",
    },
}

GAMEMODE.Config.AdminWeapons = {
    "weapon_keypadchecker",
}

GAMEMODE.Config.DefaultLaws = {
    "Do not attack other citizens except in self-defence.",
    "Do not steal or break into people's homes.",
    "Money printers/drugs are illegal.",
}

GAMEMODE.Config.PocketBlacklist = {
    ["fadmin_jail"] = true,
    ["meteor"] = true,
    ["door"] = true,
    ["func_"] = true,
    ["player"] = true,
    ["beam"] = true,
    ["worldspawn"] = true,
    ["env_"] = true,
    ["path_"] = true,
    ["prop_physics"] = true,
    ["money_printer"] = true,
    ["gunlab"] = true,
    ["prop_dynamic"] = true,
    ["prop_vehicle_prisoner_pod"] = true,
    ["keypad_wire"] = true,
    ["gmod_button"] = true,
    ["gmod_rtcameraprop"] = true,
    ["gmod_cameraprop"] = true,
    ["gmod_dynamite"] = true,
    ["gmod_thruster"] = true,
    ["gmod_light"] = true,
    ["gmod_lamp"] = true,
    ["gmod_emitter"] = true,
}

GAMEMODE.Config.noStripWeapons = {
}

GAMEMODE.Config.preventClassItemRemoval = {
    ["gunlab"] = false,
    ["microwave"] = false,
    ["spawned_shipment"] = false,
}

GAMEMODE.Config.allowedProperties = Ambi.DarkRP.Config.restrict_properties

GAMEMODE.Config.hideNonBuyable = false
GAMEMODE.Config.hideTeamUnbuyable = false

GAMEMODE.Config.afkdemotetime = 600
GAMEMODE.Config.AFKDelay = 300

GAMEMODE.Config.minHitPrice = 200
GAMEMODE.Config.maxHitPrice = 50000
GAMEMODE.Config.minHitDistance = 150
GAMEMODE.Config.hudText = "I am a hitman.\nPress E on me to request a hit!"
GAMEMODE.Config.hitmanText = "Hit\naccepted!"
GAMEMODE.Config.hitTargetCooldown = 120
GAMEMODE.Config.hitCustomerCooldown = 240

GAMEMODE.Config.hungerspeed = 2
GAMEMODE.Config.starverate = 3
