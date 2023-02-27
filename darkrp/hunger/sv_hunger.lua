local C, SQL, Gen = Ambi.General.Global.Colors
local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------
function PLAYER:SetSatiety( nValue )
    if not self.nw_Satiety then return end
    if not self.nw_MaxSatiety then return end
    if not nValue or not isnumber( nValue ) then Gen.Error( 'DarkRP', 'SetSatiety | nValue is not valid number' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanSetSatiety]', nil, self, nValue ) == false ) then return end

    nValue = math.floor( nValue )
    if ( nValue > self:GetMaxSatiety() ) then nValue = self:GetMaxSatiety() end
    if ( nValue < 0 ) then nValue = 0 end

    local old_value = self.nw_Satiety

    self.nw_Satiety = nValue

    hook.Call( '[Ambi.DarkRP.SetSatiety]', nil, self, nValue, old_value )
end

function PLAYER:AddSatiety( nValue )
    if not nValue or not isnumber( nValue ) then Gen.Error( 'DarkRP', 'AddSatiety | nValue is not valid number' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanAddSatiety]', nil, self, nValue ) == false ) then return end

    self:SetSatiety( nValue + self:GetSatiety() )

    hook.Call( '[Ambi.DarkRP.AddSatiety]', nil, self, nValue )
end

function PLAYER:SetMaxSatiety( nValue )
    if not nValue or not isnumber( nValue ) then Gen.Error( 'DarkRP', 'SetMaxSatiety | nValue is not valid number' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanSetMaxSatiety]', nil, self, nValue ) == false ) then return end

    self.nw_MaxSatiety = math.floor( nValue )
end

-- ---------------------------------------------------------------------------------------------------------------------------------
local _delay = Ambi.DarkRP.Config.hunger_delay
local function AddHunger()
    if not Ambi.DarkRP.Config.hunger_enable or not Ambi.DarkRP.Config.hunger_remove_health then return end

    for _, ply in ipairs( player.GetHumans() ) do
        if not ply:IsAlive() then continue end
        if not Ambi.DarkRP.Config.hunger_remove_health_for_admins and ply:IsAdmin() or ply:IsSuperAdmin() then continue end

        if ( ply:GetSatiety() == 0 ) and not ( hook.Call( '[Ambi.DarkRP.CanAddHunger]', nil, ply ) == false ) and ply.nw_Satiety then 
            ply:AddHealth( -Ambi.DarkRP.Config.hunger_minus_health, true ) 

            hook.Call( '[Ambi.DarkRP.HungerTakesHealth]', nil, ply )

            continue 
        end

        ply:AddSatiety( -Ambi.DarkRP.Config.hunger_minus_satiety )

        hook.Call( '[Ambi.DarkRP.HungerTakesSatiety]', nil, ply )
    end

    if ( _delay ~= Ambi.DarkRP.Config.hunger_delay ) then 
        _delay = Ambi.DarkRP.Config.hunger_delay
        timer.Create( 'DarkRPSetHunger', _delay, 0, AddHunger ) 
    end
end
timer.Create( 'DarkRPSetHunger', _delay, 0, AddHunger )

-- ---------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerSpawn', 'Ambi.DarkRP.SetSatiety', function( ePly ) 
    timer.Simple( 0, function()
        if not IsValid( ePly ) or ePly:IsBot() then return end

        ePly.nw_Satiety = Ambi.DarkRP.Config.hunger_satiety_default
        ePly.nw_MaxSatiety = Ambi.DarkRP.Config.hunger_satiety_max
    end )
end )