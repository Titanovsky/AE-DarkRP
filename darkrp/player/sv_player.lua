local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local _player_payday_delay = Ambi.DarkRP.Config.player_payday_delay 

function Ambi.DarkRP.StartPayday()
    if not Ambi.DarkRP.Config.player_payday_enable then return end

    for _, ply in ipairs( player.GetAll() ) do
        if not ply.nw_Money then continue end --! this is a native property, because it don't change money before assigning saved money value

        local salary = ply:GetJobTable().salary
        if ( hook.Call( '[Ambi.DarkRP.CanGetPaydaySalary]', nil, ply, salary ) == false ) then continue end

        ply:AddMoney( salary )

        if Ambi.DarkRP.Config.player_payday_log then
            ply:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы получили зарплату: ', C.AMBI_GREEN, salary..Ambi.DarkRP.Config.money_currency_symbol )
        end

        hook.Call( '[Ambi.DarkRP.GetPaydaySalary]', nil, ply, salary )
    end

    if ( _player_payday_delay ~= Ambi.DarkRP.Config.player_payday_enable ) then 
        _player_payday_delay = Ambi.DarkRP.Config.player_payday_delay
        timer.Create( 'AmbiDarkRPPayDay', Ambi.DarkRP.Config.player_payday_delay, 0, Ambi.DarkRP.StartPayday ) 
    end
end
timer.Create( 'AmbiDarkRPPayDay', Ambi.DarkRP.Config.player_payday_delay, 0, Ambi.DarkRP.StartPayday )

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerLoadout', 'Ambi.DarkRP.GiveBaseWeapons', function( ePly )
    if not Ambi.DarkRP.Config.player_base_give then return end

    timer.Simple( 0.1, function()
        if not IsValid( ePly ) then return end

        for _, class in ipairs( Ambi.DarkRP.Config.player_base_weapons ) do
            ePly:Give( class )
        end
    end )
    
    return false
end )

hook.Add( 'PlayerSpawn', 'Ambi.DarkRP.GiveBaseStats', function( ePly ) 
    timer.Simple( 0, function()
        if not IsValid( ePly ) then return end

        ePly:SetHealth( Ambi.DarkRP.Config.player_base_health )
        ePly:SetMaxHealth( Ambi.DarkRP.Config.player_base_max_health )
        ePly:SetArmor( Ambi.DarkRP.Config.player_base_armor )
        ePly:SetMaxArmor( Ambi.DarkRP.Config.player_base_max_armor )
        ePly:SetWalkSpeed( Ambi.DarkRP.Config.player_base_walkspeed )
        ePly:SetRunSpeed( Ambi.DarkRP.Config.player_base_runspeed )
        ePly:SetJumpPower( Ambi.DarkRP.Config.player_base_jump_power )
        ePly:SetMaxSpeed( Ambi.DarkRP.Config.player_base_maxspeed )
        ePly:SetDuckSpeed( Ambi.DarkRP.Config.player_base_duckspeed )
        ePly:SetUnDuckSpeed( Ambi.DarkRP.Config.player_base_unduckspeed )
        ePly:SetCrouchedWalkSpeed( Ambi.DarkRP.Config.player_base_crouchedspeed )
        ePly:SetLadderClimbSpeed( Ambi.DarkRP.Config.player_base_ladderclimbspeed )
        ePly:SetSlowWalkSpeed( Ambi.DarkRP.Config.player_base_slowwalkspeed )
        ePly:SetModelScale( Ambi.DarkRP.Config.player_base_scale )
        ePly:SetMaterial( Ambi.DarkRP.Config.player_base_material )
        ePly:SetSkin( Ambi.DarkRP.Config.player_base_skin ) 
    end )
end )

hook.Add( 'GetFallDamage', 'Ambi.DarkRP.GetFallDamage', function( ePly, nSpeed )
    if not Ambi.DarkRP.Config.player_fall_damage_enable then return end
    
    return nSpeed / Ambi.DarkRP.Config.player_fall_damage_divided_by
end )