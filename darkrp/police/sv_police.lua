local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local PLAYER = FindMetaTable( 'Player' )

-- --------------------------------------------------------------------------------------------------
net.AddString( 'ambi_darkrp_police_send_info' )
net.AddString( 'ambi_darkrp_police_arrest_show_time' )
net.AddString( 'ambi_darkrp_police_arrest_remove_time' )

function Ambi.DarkRP.Arrest( ePly, ePolice, sReason, nTime )
    nTime = nTime or Ambi.DarkRP.Config.police_system_arrest_time
    
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end
    if ePly:IsArrested() then return end
    if ( hook.Call( '[Ambi.DarkRP.CanArrest]', nil, ePolice, ePly, sReason, nTime ) == false ) then return end
 
    ePly.nw_IsArrested = true

    timer.Create( 'AmbiDarkRPArrest['..ePly:SteamID()..']', nTime, 1, function() 
        if not IsValid( ePly ) then return end
        if not ePly:IsArrested() then return end

        Ambi.DarkRP.UnArrest( ePly, ePolice )
    end )

    net.Start( 'ambi_darkrp_police_send_info' )
        if IsValid( ePolice ) then 
            net.WriteString( ePolice:Nick()..' арестовал '..ePly:Nick()..' на '..nTime..' секунд' ) 
        else 
            net.WriteString( ePly:Nick()..' арестован на '..nTime..' секунд' ) 
        end
        net.WriteString( sReason and 'Причина: '..sReason or '' )
    net.Broadcast()

    net.Start( 'ambi_darkrp_police_arrest_show_time' )
        net.WriteString( tostring( nTime ) )
    net.Send( ePly )

    ePly:StripWeapons()

    ePly.old_jail_walkspeed = ePly:GetWalkSpeed()
    ePly:SetWalkSpeed( ePly.old_jail_walkspeed / 2 )

    ePly.old_jail_runspeed = ePly:GetRunSpeed()
    ePly:SetRunSpeed( ePly.old_jail_runspeed / 2 )

    if Ambi.DarkRP.Config.police_system_arrest_spawn_in_jail then
        ePly:Spawn()
    end

    hook.Call( '[Ambi.DarkRP.PlayerArrested]', nil, ePly, ePolice, sReason, nTime )

    return true
end

function Ambi.DarkRP.UnArrest( ePly, ePolice )
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end
    if not ePly.nw_IsArrested then return end

    if ( hook.Call( '[Ambi.DarkRP.CanUnArrest]', nil, ePolice, ePly ) == false ) then return end

    timer.Remove( 'AmbiDarkRPArrest['..ePly:SteamID()..']' )

    ePly.nw_IsArrested = false

    ePly:SetWalkSpeed( ePly.old_jail_walkspeed or 0 )
    ePly:SetRunSpeed( ePly.old_jail_runspeed or 0 )
    ePly:Spawn()
    ePly:PlaySound( 'buttons/button15.wav' )

    net.Start( 'ambi_darkrp_police_arrest_remove_time' )
    net.Send( ePly )

    hook.Call( '[Ambi.DarkRP.PlayerUnArrested]', nil, ePly, ePolice )

    return true
end

-- --------------------------------------------------------------------------------------------------
function Ambi.DarkRP.Wanted( ePly, ePolice, sReason, nTime )
    nTime = nTime or Ambi.DarkRP.Config.police_system_wanted_time
    sReason = sReason or Ambi.DarkRP.Config.police_system_wanted_reason
    
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end
    if ePly:IsArrested() then return end
    if ( hook.Call( '[Ambi.DarkRP.CanWanted]', nil, ePolice, ePly, sReason, nTime ) == false ) then return end

    ePly.nw_IsWanted = true

    net.Start( 'ambi_darkrp_police_send_info' )
        if IsValid( ePolice ) then 
            net.WriteString( ePolice:Nick()..' подал в розыск '..ePly:Nick() ) 
        else 
            net.WriteString( ePly:Nick()..' в розыске!' ) 
        end
        net.WriteString( sReason and 'Причина: '..sReason or '' )
    net.Broadcast()

    if ( nTime > 0 ) then 
        timer.Create( 'Wanted_Player:'..ePly:GetSteamID(), nTime, 1, function() 
            if IsValid( ePly ) then Ambi.DarkRP.UnWanted( ePly ) end
        end )
    end

    hook.Call( '[Ambi.DarkRP.PlayerWanted]', nil, ePly, ePolice, sReason, nTime )

    return true
end

function Ambi.DarkRP.UnWanted( ePly, ePolice )
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end
    if not ePly.nw_IsWanted then return end
    if ( hook.Call( '[Ambi.DarkRP.CanUnWanted]', nil, ePolice, ePly ) == false ) then return end

    ePly.nw_IsWanted = false

    net.Start( 'ambi_darkrp_police_send_info' )
        net.WriteString( ePly:Nick()..' больше не розыскивается!' ) 
        net.WriteString( '' )
    net.Broadcast()

    timer.Remove( 'Wanted_Player:'..ePly:GetSteamID() )

    hook.Call( '[Ambi.DarkRP.PlayerUnWanted]', nil, ePly, ePolice )

    return true
end

function Ambi.DarkRP.Warrant( ePly, ePolice, sText )
    if not IsValid( ePly ) or not ePly:IsPlayer() then return end
    if ePly:HasWarrant() then return end
    if ( hook.Call( '[Ambi.DarkRP.CanWarrant]', nil, ePolice, ePly, sText ) == false ) then return end

    sText = sText or Ambi.DarkRP.Config.police_system_warrant_reason

    ePly.nw_HasWarrant = true

    net.Start( 'ambi_darkrp_police_send_info' )
        net.WriteString( 'Подан Ордер на Обыск у '..ePly:Nick() ) 
        net.WriteString( sText )
    net.Broadcast()

    timer.Create( 'AmbiDarkRPWarrant['..ePly:SteamID()..']', Ambi.DarkRP.Config.police_system_warrant_time, 1, function()
        if IsValid( ePly ) then Ambi.DarkRP.UnWarrant( ePly, ePly ) end
    end )

    hook.Call( '[Ambi.DarkRP.PlayerWarrant]', nil, ePly, ePolice, sReason )

    return true
end

function Ambi.DarkRP.UnWarrant( ePly, ePolice )
    if ( hook.Call( '[Ambi.DarkRP.CanUnWarrant]', nil, ePolice, ePly ) == false ) then return end

    ePly.nw_HasWarrant = false

    timer.Remove( 'AmbiDarkRPWarrant['..ePly:SteamID()..']' )

    hook.Call( '[Ambi.DarkRP.PlayerUnWarranted]', nil, ePly, ePolice )
end

-- --------------------------------------------------------------------------------------------------
hook.Add( 'PlayerSpawn', 'Ambi.DarkRP.ArrestedPlayer', function( ePly )
    if not Ambi.DarkRP.Config.police_system_arrest_spawn_in_jail then return end

    timer.Simple( 0, function()
        if not IsValid( ePly ) then return end
        if not ePly:IsArrested() then return end

        ePly:StripWeapons()

        ePly:SetWalkSpeed( ePly.old_jail_walkspeed / 2 )
        ePly:SetRunSpeed( ePly.old_jail_runspeed / 2 )

        local position = Ambi.DarkRP.GetJailPositions( game.GetMap() )
        if not position then return end

        position = table.Random( position )
        if not position then return end
        if not position.pos or not position.ang then return end

        ePly:SetPos( position.pos )
        ePly:SetEyeAngles( position.ang )
    end )
end )

hook.Add( 'PlayerCanPickupWeapon', 'Ambi.DarkRP.RestrictArrestedPlayer', function( ePly )
    if ePly:IsArrested() then return false end
end )

hook.Add( '[Ambi.DarkRP.CanBuyDoor]', 'Ambi.DarkRP.RestrictArrestedPlayer', function( ePly )
    if ePly:IsArrested() then return false end
end )

hook.Add( 'PlayerDeath', 'Ambi.DarkRP.RemoveWantedAndWarrant', function( ePly )
    if Ambi.DarkRP.Config.police_system_wanted_remove_after_death and ePly:IsWanted() then Ambi.DarkRP.UnWanted( ePly, ePly ) end
    if Ambi.DarkRP.Config.police_system_warrant_remove_after_death and ePly:HasWarrant() then Ambi.DarkRP.UnWarrant( ePly, ePly ) end
end )

-- --------------------------------------------------------------------------------------------------
net.AddString( 'ambi_darkrp_police_wanted' )
net.Receive( 'ambi_darkrp_police_wanted', function( _, ePly ) 
    if not Ambi.DarkRP.Config.police_system_enable then ePly:Kick( '[DarkRP] Попытка подать в розыск игрока, когда система отключена!' ) return end
    if not Ambi.DarkRP.Config.police_system_wanted_enable then ePly:Kick( '[DarkRP] Попытка подать в розыск игрока, когда возможность Розыска отключена!' ) return end

    local job = ePly:GetJobTable()
    if not ePly:IsPolice() then ePly:Kick( '[DarkRP] Попытка подать в розыск игрока, не будучи в полицейской работе!' ) return end
    if not ePly:GetDelay( 'AmbiDarkRPWantedDelay' ) then ePly:SetDelay( 'AmbiDarkRPWantedDelay', Ambi.DarkRP.Config.police_system_wanted_delay ) else return end

    local ply, text = net.ReadEntity(), net.ReadString()
    if not IsValid( ply ) or not ply:IsPlayer() then return end
    if ( utf8.len( text ) > 32 ) then text = '' end

    if ply:IsWanted() then 
        Ambi.DarkRP.UnWanted( ply, ePly )

        ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы сняли с розыск игрока '..ply:Nick() )
        ply:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Игрок ', C.AMBI_BLUE, ePly:Nick(), C.ABS_WHITE, ' снял вас с розыск!' )
    else
        Ambi.DarkRP.Wanted( ply, ePly, text, Ambi.DarkRP.Config.police_system_wanted_time )

        ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы подали в розыск игрока '..ply:Nick() )
        ply:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Игрок ', C.AMBI_BLUE, ePly:Nick(), C.ABS_WHITE, ' подал вас в розыск!' )
    end
end )

net.AddString( 'ambi_darkrp_police_warrant' )
net.Receive( 'ambi_darkrp_police_warrant', function( _, ePly ) 
    if not Ambi.DarkRP.Config.police_system_enable then ePly:Kick( '[DarkRP] Попытка подать Ордер на Обыск игрока, когда система отключена!' ) return end
    if not Ambi.DarkRP.Config.police_system_warrant_enable then ePly:Kick( '[DarkRP] Попытка подать Ордер на Обыск игрока, когда возможность Ордера отключена!' ) return end

    if not ePly:GetDelay( 'AmbiDarkRPWarrantDelay' ) then ePly:SetDelay( 'AmbiDarkRPWarrantDelay', Ambi.DarkRP.Config.police_system_warrant_delay ) else ePly:Kick( '[DarkRP] Ордер на Обыск, обходя таймер' ) return end

    if not ePly:IsPolice() then ePly:Kick( '[DarkRP] Попытка подать Ордер на Обыск игрока, не будучи в полицейской работе!' ) return end

    local ply, text = net.ReadEntity(), net.ReadString()
    if not IsValid( ply ) or not ply:IsPlayer() then return end

    if not ply:HasWarrant() then 
        if ( utf8.len( text ) > 32 ) then text = '' end

        Ambi.DarkRP.Warrant( ply, ePly, text )

        ply:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Игрок ', C.AMBI_BLUE, ePly:Nick(), C.ABS_WHITE, ' подал на вас Ордер на Обыск!' )
        ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы подали Ордер на Обыск на игрока ', C.AMBI_BLUE, ePly:Nick() )
    else
        Ambi.DarkRP.UnWarrant( ply, ePly, text )

        ply:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Игрок ', C.AMBI_BLUE, ePly:Nick(), C.ABS_WHITE, ' снял у вас Ордер на Обыск!' )
        ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы сняли Ордер на Обыск у игрока ', C.AMBI_BLUE, ePly:Nick() )
    end
end )