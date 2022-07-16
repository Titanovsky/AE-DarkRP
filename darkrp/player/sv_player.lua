local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local PLAYER = FindMetaTable( 'Player' )
-- --------------------------------------------------------------------------------------------------------

function Ambi.DarkRP.StartPayday()
    if not Ambi.DarkRP.Config.player_payday_enable then return end

    for _, ply in ipairs( player.GetAll() ) do
        if not ply.nw_Money then continue end

        local job = ply:GetJobTable()
        if not job then continue end
        if not job.salary then continue end

        local salary = job.salary

        ply:AddMoney( salary )

        if Ambi.DarkRP.Config.player_payday_log then
            ply:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы получили зарплату: ', C.AMBI_GREEN, salary..Ambi.DarkRP.Config.money_currency_symbol )
        end
    end
end
timer.Create( 'AmbiDarkRPPayDay', Ambi.DarkRP.Config.player_payday_delay, 0, Ambi.DarkRP.StartPayday )

-- --------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerLoadout', 'Ambi.DarkRP.GiveBaseWeapons', function( ePly )
    if not Ambi.DarkRP.Config.player_base_enable then return end
    if not Ambi.DarkRP.Config.player_base_give then return end

    for _, class in ipairs( Ambi.DarkRP.Config.player_base_weapons ) do
        ePly:Give( class )
    end
    
    return false
end )

hook.Add( 'PlayerSpawn', 'Ambi.DarkRP.GiveBaseStats', function( ePly ) 
    if not Ambi.DarkRP.Config.player_base_enable then return end

    timer.Simple( 0, function()
        if not IsValid( ePly ) then return end

        local job = ePly:GetJobTable()
        job = job or {} -- Чтобы не было ошибки

        if not ( job.hp or job.health ) then ePly:SetHealth( Ambi.DarkRP.Config.player_base_health ) end
        if not ( job.max_hp or job.max_health ) then ePly:SetMaxHealth( Ambi.DarkRP.Config.player_base_max_health ) end
        if not job.walkspeed then ePly:SetWalkSpeed( Ambi.DarkRP.Config.player_base_walkspeed ) end
        if not job.runspeed then ePly:SetRunSpeed( Ambi.DarkRP.Config.player_base_runspeed ) end
        if not job.jumppower then ePly:SetJumpPower( Ambi.DarkRP.Config.player_base_jump_power ) end
    end )
end )