local PLAYER = FindMetaTable( 'Player' )
local ENTITY = FindMetaTable( 'Entity' )

DarkRP = DarkRP or {}

DarkRP.doorData = DarkRP.doorData or {}
DarkRP.hooks = DarkRP.hooks or {}
DarkRP.disabledDefaults = DarkRP.disabledDefaults or {}
DarkRP.disabledDefaults["modules"] = {
    ["afk"]              = true, -- true
    ["chatsounds"]       = true, -- true
    ["events"]           = true, -- true
    ["fpp"]              = false,
    ["hitmenu"]          = true, -- true
    ["hud"]              = not Ambi.DarkRP.Config.hud_enable,
    ["hungermod"]        = not Ambi.DarkRP.Config.hunger_enable,
    ["playerscale"]      = true, -- true
    ["sleep"]            = true, -- true
}
DarkRP.disabledDefaults["agendas"]          = {}
DarkRP.disabledDefaults["ammo"]             = {}
DarkRP.disabledDefaults["demotegroups"]     = {}
DarkRP.disabledDefaults["doorgroups"]       = {}
DarkRP.disabledDefaults["entities"]         = {}
DarkRP.disabledDefaults["food"]             = {}
DarkRP.disabledDefaults["groupchat"]        = {}
DarkRP.disabledDefaults["hitmen"]           = {}
DarkRP.disabledDefaults["jobs"]             = {}
DarkRP.disabledDefaults["shipments"]        = {}
DarkRP.disabledDefaults["vehicles"]         = {}
DarkRP.disabledDefaults["workarounds"]      = {}

RPExtraTeams = RPExtraTeams or {}
DarkRPEntities = DarkRPEntities or {}
CustomShipments = CustomShipments or {}
FoodItems = FoodItems or {}

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:getDarkRPVar( sVar )
    if not sVar then return 0 end

    if ( sVar == 'money' ) then return self:GetMoney()
    elseif ( sVar == 'wanted' ) then return self:IsWanted()
    elseif ( sVar == 'warrant' ) then return self:HasWarrant()
    elseif ( sVar == 'salary' ) then return self:GetJobTable().salary
    elseif ( sVar == 'rpname' ) then return self:Nick()
    elseif ( sVar == 'Energy' ) then return self:GetSatiety()
    elseif ( sVar == 'job' ) then return self:TeamName()
    elseif ( sVar == 'HasGunlicense' ) then return self:HasLicenseGun()
    elseif ( sVar == 'wantedReason' ) then return ''
    elseif ( sVar == 'AFKDemoted' ) then return false
    elseif ( sVar == 'Arrested' ) then return self:IsArrested()
    elseif ( sVar == 'AFK' ) then return false
    elseif ( sVar == 'agenda' ) then return ''
    end

    return 1
end
PLAYER.GetDarkRPVar = PLAYER.getDarkRPVar

function PLAYER:setDarkRPVar( sVar, anyVal )
    local oldval = self:GetDarkRPVar( sVar )

    if ( sVar == 'money' ) then return self:SetMoney( anyVal )
    elseif ( sVar == 'wanted' ) then return self:SetWanted( anyVal )
    elseif ( sVar == 'warrant' ) then return self:SetWarrant( anyVal )
    elseif ( sVar == 'Energy' ) then return self:SetSatiety( anyVal )
    elseif ( sVar == 'rpname' ) then return self:SetRPName( anyVal )
    elseif ( sVar == 'HasGunlicense' ) then return self:HasLicenseGun()
    elseif ( sVar == 'wantedReason' ) then return ''
    elseif ( sVar == 'AFKDemoted' ) then return false
    elseif ( sVar == 'AFK' ) then return false
    elseif ( sVar == 'agenda' ) then return ''
    end

    hook.Call( 'DarkRPVarChanged', nil, self, sVar, oldval, anyVal )

    return anyVal
end
PLAYER.SetDarkRPVar = PLAYER.setDarkRPVar
PLAYER.setSelfDarkRPVar = PLAYER.setDarkRPVar

function PLAYER:changeTeam( nTeam, bForce )
    return self:SetJob( Ambi.DarkRP.GetJobByIndex( nTeam ) and Ambi.DarkRP.GetJobByIndex( nTeam ).class or nil, bForce )
end

PLAYER.updateJob = function() 
end

function PLAYER:teamBan( nTeam, nTime )
    return self:BlockJob( Ambi.DarkRP.GetJobByIndex( nTeam ) and Ambi.DarkRP.GetJobByIndex( nTeam ).class or nil, nTime )
end

function PLAYER:teamUnBan( nTeam )
    return self:UnBlockJob( Ambi.DarkRP.GetJobByIndex( nTeam ) and Ambi.DarkRP.GetJobByIndex( nTeam ).class or nil )
end

function PLAYER:teamBanTimeLeft() 
    return 0 
end

function PLAYER:changeAllowed() 
    return true 
end

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
    return Ambi.DarkRP.Warrant( self, ePolice, sReason )
end

function PLAYER:unWarrant( ePolice )
    self.nw_HasWarrant = false
end

function PLAYER:wanted( ePolice, sReason, nTime )
    return Ambi.DarkRP.Wanted( self, ePolice, sReason, nTime )
end

function PLAYER:unWanted( ePolice )
    return Ambi.DarkRP.UnWanted( self )
end

function PLAYER:arrest( nTime, ePolice )
    return Ambi.DarkRP.Arrest( self, ePolice, '', nTime )
end

function PLAYER:unArrest( ePolice )
    return Ambi.DarkRP.UnArrest( self, ePolice )
end

function PLAYER:canAfford( nPrice )
    if not nPrice then return false end

    return self:GetMoney() >= nPrice
end

function PLAYER:addMoney( nMoney )
    return self:AddMoney( nMoney )
end

function PLAYER:getJobTable() 
    return self:GetJobTable() 
end

function PLAYER:sendDoorData()
    return true
end

function PLAYER:canKeysLock(ent)
    local canLock = hook.Run("canKeysLock", self, ent)

    if canLock ~= nil then return canLock end
    return canLockUnlock(self, ent)
end

function PLAYER:canKeysUnlock(ent)
    local canUnlock = hook.Run("canKeysUnlock", self, ent)

    if canUnlock ~= nil then return canUnlock end
    return canLockUnlock(self, ent)
end

function PLAYER:keysUnOwnAll()
    for entIndex, ent in pairs(self.Ownedz or {}) do
        if not IsValid(ent) or not ent:isKeysOwnable() then self.Ownedz[entIndex] = nil continue end
        if ent:isMasterOwner(self) then
            ent:Fire("unlock", "", 0.6)
        end
        ent:keysUnOwn(self)
    end

    for _, ply in ipairs(player.GetAll()) do
        if ply == self then continue end

        for _, ent in pairs(ply.Ownedz or {}) do
            if IsValid(ent) and ent:isKeysAllowedToOwn(self) then
                ent:removeKeysAllowedToOwn(self)
            end
        end
    end

    self.OwnedNumz = 0
end

function PLAYER:doPropertyTax()
    if not GAMEMODE.Config.propertytax then return end
    if self:isCP() and GAMEMODE.Config.cit_propertytax then return end

    local taxables = {}

    for entIndex, ent in pairs(self.Ownedz or {}) do
        if not IsValid(ent) or not ent:isKeysOwnable() then self.Ownedz[entIndex] = nil continue end
        local isAllowed = hook.Call("canTaxEntity", nil, self, ent)
        if isAllowed == false then continue end

        table.insert(taxables, ent)
    end

    -- co-owned doors
    for _, ply in ipairs(player.GetAll()) do
        if ply == self then continue end

        for _, ent in pairs(ply.Ownedz or {}) do
            if not IsValid(ent) or not ent:isKeysOwnedBy(self) then continue end

            local isAllowed = hook.Call("canTaxEntity", nil, self, ent)
            if isAllowed == false then continue end

            table.insert(taxables, ent)
        end
    end

    local numowned = #taxables

    if numowned <= 0 then return end

    local price = 10
    local tax = price * numowned + math.random(-5, 5)

    local shouldTax, taxOverride = hook.Call("canPropertyTax", nil, self, tax)

    if shouldTax == false then return end

    tax = taxOverride or tax
    if tax == 0 then return end

    local canAfford = self:canAfford(tax)

    if canAfford then
        self:addMoney(-tax)
        DarkRP.notify(self, 0, 5, DarkRP.getPhrase("property_tax", DarkRP.formatMoney(tax)))
    else
        --taxesUnOwnAll(self, taxables)
        DarkRP.notify(self, 1, 8, DarkRP.getPhrase("property_tax_cant_afford"))
    end

    hook.Call("onPropertyTax", nil, self, tax, canAfford)
end

function PLAYER:initiateTax()
    local taxtime = GAMEMODE.Config.wallettaxtime
    local uid = self:SteamID64() -- so we can destroy the timer if the player leaves
    timer.Create("rp_tax_" .. uid, taxtime or 600, 0, function()
        if not IsValid(self) then
            timer.Remove("rp_tax_" .. uid)

            return
        end

        if not GAMEMODE.Config.wallettax then
            return -- Don't remove the hook in case it's turned on afterwards.
        end

        local money = self:getDarkRPVar("money")
        local mintax = GAMEMODE.Config.wallettaxmin / 100
        local maxtax = GAMEMODE.Config.wallettaxmax / 100 -- convert to decimals for percentage calculations
        local startMoney = GAMEMODE.Config.startingmoney


        -- Variate the taxes between twice the starting money ($1000 by default) and 200 - 2 times the starting money (100.000 by default)
        local tax = (money - (startMoney * 2)) / (startMoney * 198)
        tax = math.Min(maxtax, mintax + (maxtax - mintax) * tax)

        local taxAmount = tax * money

        local shouldTax, amount = hook.Call("canTax", GAMEMODE, self, taxAmount)

        if shouldTax == false then return end

        taxAmount = amount or taxAmount
        taxAmount = math.Max(0, taxAmount)

        self:addMoney(-taxAmount)
        DarkRP.notify(self, 3, 7, DarkRP.getPhrase("taxday", math.Round(taxAmount / money * 100, 3)))

        hook.Call("onPaidTax", DarkRP.hooks, self, tax, money)
    end)
end

function PLAYER:restorePlayerData()
    --
end

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
function ENTITY:Setowning_ent( ePly )
    ePly:SetShopBuyer( self )
end

function ENTITY:Getowning_ent()
    return self:GetShopBuyer()
end

function ENTITY:isDoor()
    return Ambi.DarkRP.Config.doors_classes[ self:GetClass() ]
end

local function GetTeamsForDoor( sCategory )
    if not sCategory then return nil end
    
    local category = Ambi.DarkRP.GetDoorCategory( sCategory )
    if not category then return nil end

    local teams = {}

    for _, job in ipairs( category ) do
        teams[ Ambi.DarkRP.GetJob( job ).index ] = true
    end

    return teams
end

local function GetAllowedToOwnForDoor( eDoor )
    if CLIENT then return nil end

    local players = {}

    for _, ply in ipairs( eDoor.owners ) do
        players[ ply:UserID() ] = true
    end

    return players
end

function ENTITY:getDoorData()
    if SERVER then
        if not self:isKeysOwnable() then return {} end

        return { 
            nonOwnable = self.nw_IsBlocked and true or nil,
            owner = self.nw_IsOwned and self.nw_Owner:UserID() or nil, 
            teamOwn = GetTeamsForDoor( self.nw_Category ),
            title = self.nw_Title,
            allowedToOwn = GetAllowedToOwnForDoor( self ),
            extraOwners = GetAllowedToOwnForDoor( self ),
        }
    else
        return { 
            nonOwnable = self.nw_IsBlocked and true or nil,
            owner = ( self.nw_IsOwned and IsEntity( self.nw_Owner ) ) and self.nw_Owner:UserID() or nil, 
            teamOwn = GetTeamsForDoor( self.nw_Category ),
        }
    end
end

function ENTITY:doorIndex()
    return self:CreatedByMap() and self:MapCreationID() or nil
end

function ENTITY:isLocked()
    return nil -- https://github.com/FPtje/DarkRP/blob/233c953cb723de7981e5d689b2e6c4168e0272c5/gamemode/modules/doorsystem/sv_doors.lua#L22
end

function ENTITY:keysLock()
    self:Fire("lock", "", 0)
    if isfunction(self.Lock) then self:Lock(true) end -- SCars
    if IsValid(self.EntOwner) and self.EntOwner ~= self then return self.EntOwner:keysLock() end -- SCars

    hook.Call("onKeysLocked", nil, self)
end

function ENTITY:keysUnLock()
    self:Fire("unlock", "", 0)
    if isfunction(self.UnLock) then self:UnLock(true) end -- SCars
    if IsValid(self.EntOwner) and self.EntOwner ~= self then return self.EntOwner:keysUnLock() end -- SCars

    hook.Call("onKeysUnlocked", nil, self)
end

function ENTITY:keysOwn(ply)
    if self:isKeysAllowedToOwn(ply) then
        self:addKeysDoorOwner(ply)
        return
    end

    local Owner = self:CPPIGetOwner()

    -- Increase vehicle count
    if self:IsVehicle() then
        if IsValid(ply) then
            ply.Vehicles = ply.Vehicles or 0
            ply.Vehicles = ply.Vehicles + 1

            self.SID = ply.SID
        end

        -- Decrease vehicle count of the original owner
        if IsValid(Owner) and Owner ~= ply then
            Owner.Vehicles = Owner.Vehicles or 1
            Owner.Vehicles = Owner.Vehicles - 1
        end
    end

    if self:IsVehicle() then
        self:CPPISetOwner(ply)
    end

    if not self:isKeysOwned() and not self:isKeysOwnedBy(ply) then
        local doorData = self:getDoorData()
        doorData.owner = ply:UserID()
        DarkRP.updateDoorData(self, "owner")
    end

    ply.OwnedNumz = ply.OwnedNumz or 0
    if ply.OwnedNumz == 0 and GAMEMODE.Config.propertytax then
        timer.Create(ply:SteamID64() .. "propertytax", 270, 0, function() ply.doPropertyTax(ply) end)
    end

    ply.OwnedNumz = ply.OwnedNumz + 1

    ply.Ownedz[self:EntIndex()] = self
end

function ENTITY:keysUnOwn(ply)
    if not ply then
        ply = self:getDoorOwner()

        if not IsValid(ply) then return end
    end

    if self:isMasterOwner(ply) then
        local doorData = self:getDoorData()
        self:removeAllKeysExtraOwners()
        self:setKeysTitle(nil)
        doorData.owner = nil
        DarkRP.updateDoorData(self, "owner")
    else
        self:removeKeysDoorOwner(ply)
    end

    ply.Ownedz[self:EntIndex()] = nil
    ply.OwnedNumz = math.Clamp((ply.OwnedNumz or 1) - 1, 0, math.huge)
end

function ENTITY:drawOwnableInfo()
    local doorDrawing = hook.Call("HUDDrawDoorData", nil, self)
    if doorDrawing == true then return end
end

function ENTITY:setKeysNonOwnable(ownable)
    self:getDoorData().nonOwnable = ownable or nil
    DarkRP.updateDoorData(self, "nonOwnable")
end

function ENTITY:setKeysTitle(title)
    self:getDoorData().title = title ~= "" and title or nil
    DarkRP.updateDoorData(self, "title")
end

function ENTITY:setDoorGroup(group)
    self:getDoorData().groupOwn = group
    DarkRP.updateDoorData(self, "groupOwn")
end

function ENTITY:addKeysDoorTeam(t)
    local doorData = self:getDoorData()
    doorData.teamOwn = doorData.teamOwn or {}
    doorData.teamOwn[t] = true

    DarkRP.updateDoorData(self, "teamOwn")
end

function ENTITY:removeKeysDoorTeam(t)
    local doorData = self:getDoorData()
    doorData.teamOwn = doorData.teamOwn or {}
    doorData.teamOwn[t] = nil

    if fn.Null(doorData.teamOwn) then
        doorData.teamOwn = nil
    end

    DarkRP.updateDoorData(self, "teamOwn")
end

function ENTITY:removeAllKeysDoorTeams()
    local doorData = self:getDoorData()
    doorData.teamOwn = nil

    DarkRP.updateDoorData(self, "teamOwn")
end

function ENTITY:addKeysAllowedToOwn(ply)
    local doorData = self:getDoorData()
    doorData.allowedToOwn = doorData.allowedToOwn or {}
    doorData.allowedToOwn[ply:UserID()] = true

    DarkRP.updateDoorData(self, "allowedToOwn")
end

function ENTITY:removeKeysAllowedToOwn(ply)
    local doorData = self:getDoorData()
    doorData.allowedToOwn = doorData.allowedToOwn or {}
    doorData.allowedToOwn[ply:UserID()] = nil

    DarkRP.updateDoorData(self, "allowedToOwn")
end

function ENTITY:removeAllKeysAllowedToOwn()
    local doorData = self:getDoorData()
    doorData.allowedToOwn = nil

    DarkRP.updateDoorData(self, "allowedToOwn")
end

function ENTITY:addKeysDoorOwner(ply)
    local doorData = self:getDoorData()
    doorData.extraOwners = doorData.extraOwners or {}
    doorData.extraOwners[ply:UserID()] = true

    DarkRP.updateDoorData(self, "extraOwners")

    self:removeKeysAllowedToOwn(ply)
end

function ENTITY:removeKeysDoorOwner(ply)
    local doorData = self:getDoorData()
    doorData.extraOwners = doorData.extraOwners or {}
    doorData.extraOwners[ply:UserID()] = nil

    DarkRP.updateDoorData(self, "extraOwners")
end

function ENTITY:removeAllKeysExtraOwners()
    local doorData = self:getDoorData()
    doorData.extraOwners = nil

    DarkRP.updateDoorData(self, "extraOwners")
end

function ENTITY:removeDoorData()
end

function ENTITY:isKeysOwnable()
    if not IsValid(self) then return false end

    local class = self:GetClass()

    if self:isDoor() or ( GAMEMODE.Config.allowvehicleowning and self:IsVehicle() and (not IsValid(self:GetParent()) or not self:GetParent():IsVehicle())) then
        return true
    end

    return false
end

function ENTITY:isKeysOwned()
    if IsValid(self:getDoorOwner()) then return true end

    return false
end

function ENTITY:getDoorOwner()
    return doorData.first_owner
end

function ENTITY:isMasterOwner(ply)
    return ply == self:getDoorOwner()
end

function ENTITY:isKeysOwnedBy(ply)
    if self:isMasterOwner(ply) then return true end

    local coOwners = self:getKeysCoOwners()
    return coOwners and coOwners[ply:UserID()] or false
end

function ENTITY:isKeysAllowedToOwn(ply)
    local doorData = self:getDoorData()
    if not doorData then return false end

    return doorData.allowedToOwn and doorData.allowedToOwn[ply:UserID()] or false
end

function ENTITY:getKeysNonOwnable()
    return self.nw_IsBlocked
end

function ENTITY:getKeysTitle()
    return self.nw_Title
end

function ENTITY:getKeysDoorGroup()
    local doorData = self:getDoorData()
    if not doorData then return nil end

    return doorData.groupOwn
end

function ENTITY:getKeysDoorTeams()
    local doorData = self:getDoorData()
    if not doorData or table.IsEmpty(doorData.teamOwn or {}) then return nil end

    return doorData.teamOwn
end

function ENTITY:getKeysAllowedToOwn()
    local doorData = self:getDoorData()
    if not doorData then return nil end

    return doorData.allowedToOwn
end

function ENTITY:getKeysCoOwners()
    local doorData = self:getDoorData()
    if not doorData then return nil end

    return doorData.extraOwners
end

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
function DarkRP.createJob( sName, tJob )
    if not Ambi.DarkRP.compatibility_jobs then return end
    if not sName or not tJob then return end

    local tab = table.Merge( tJob, { name = sName } )

    return Ambi.DarkRP.AddJob( sName, tJob )
end

function DarkRP.getDoorVars()
    return {}
end

function DarkRP.writeNetDoorVar()
end

function DarkRP.updateDoorData(door, member)
end

function DarkRP.getDoorVarsByName()
    return {}
end

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

function DarkRP.createCategory( sCategory ) 
    return sCategory
end

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

function DarkRP.getPhrase( sText )
    return sText or ''
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

function DarkRP.getLaws()
    return Ambi.DarkRP.GetLaws()
end

function DarkRP.deLocalise( text )
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

function DarkRP.initDatabase()
    hook.Call("DarkRPDBInitialized")

    return true
end

function DarkRP.storeRPName(ply, name)
    if not IsValid( ply ) then return end
    if not name or string.len(name) < 2 then return end
    hook.Call("onPlayerChangedName", nil, ply, ply:getDarkRPVar("rpname"), name)
    ply:setDarkRPVar("rpname", name)
end

function DarkRP.retrieveRPNames(name, callback)
    local tab = sql.Query( "SELECT COUNT(*) AS count FROM darkrp2_rpname WHERE RPName = " .. sql.SQLStr(name) .. ";" )
    local count = tab and tonumber( tab.count ) or 0
    local taken = count > 0

    if callback then callback( taken ) end
end

function DarkRP.offlinePlayerData(steamid, callback, failed) 
    -- https://github.com/FPtje/DarkRP/blob/deb882d58f6ea92a60c73bb22fdda5e80cd96125/gamemode/modules/base/sv_data.lua#L311
    if failed then failed() end
end

function DarkRP.retrievePlayerData(ply, callback, failed, attempts, err)
    -- https://github.com/FPtje/DarkRP/blob/deb882d58f6ea92a60c73bb22fdda5e80cd96125/gamemode/modules/base/sv_data.lua#L364
end

function DarkRP.createPlayerData(ply, name, wallet, salary)
    --
end

function DarkRP.storeMoney(ply, amount)
    if not isnumber(amount) or amount < 0 or amount >= 1 / 0 then return end
    --
end

function DarkRP.storeSalary(ply, amount)
    ply:setSelfDarkRPVar("salary", math.floor(amount))

    return amount
end

function DarkRP.retrieveSalary(ply, callback)
    local val =
        ply:getJobTable() and ply:getJobTable().salary or
        RPExtraTeams[GAMEMODE.DefaultTeam].salary or
        (GM or GAMEMODE).Config.normalsalary

    if callback then callback(val) end

    return val
end

function DarkRP.hookStub( tTab )
    --? print in console?
end

function DarkRP.stub( tTab )
    --? print in console?
end

function DarkRP.errorNoHalt( sError )
    Ambi.General.Error( 'DarkRP', sError )
end

function DarkRP.error( sError )
    Ambi.General.Error( 'DarkRP', sError )
end

DarkRP.chatCommands = DarkRP.chatCommands or {}

function DarkRP.defineChatCommand( sCommand, fFunc, nDelay )
    if not Ambi.ChatCommands then return end

    Ambi.ChatCommands.Add( sCommand, 'DarkRP | Compatibility', 'Reg for Compatiblity', nDelay, fFunc )
end

function DarkRP.definePrivilegedChatCommand( sCommand, sText, fFunc )
    if not Ambi.ChatCommands then return end

    Ambi.ChatCommands.Add( sCommand, 'DarkRP | Compatibility', sText, 1, function( ePly, tArgs )
        if not ePly:IsSuperAdmin() then return end

        fFunc( ePly, tArgs )
    end )
end

function DarkRP.declareChatCommand( tTab )
    if not tTab.command then return end
    tTab.description = tTab.description or ''

    tTab.command = string.lower( tTab.command )

    DarkRP.chatCommands[tTab.command] = DarkRP.chatCommands[tTab.command] or tTab

    for k, v in pairs(tTab) do
        DarkRP.chatCommands[tTab.command][k] = v
    end
end

function DarkRP.removeChatCommand(command)
    DarkRP.chatCommands[string.lower(command)] = nil
end

function DarkRP.chatCommandAlias(command, ...)
    local name
    for k, v in pairs{...} do
        name = string.lower(v)

        DarkRP.chatCommands[name] = {command = name}
        setmetatable(DarkRP.chatCommands[name], {
            __index = DarkRP.chatCommands[command]
        })
    end
end

function DarkRP.getChatCommand(command)
    return DarkRP.chatCommands[string.lower(command)]
end

function DarkRP.getChatCommands()
    return DarkRP.chatCommands
end

function DarkRP.getSortedChatCommands()
    return DarkRP.chatCommands
end
