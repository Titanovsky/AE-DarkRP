local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local DB = SQL.CreateTable( 'darkrp2_permajobs', 'SteamID, Class' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.SetFirstJob', function( ePly )
    local class = Ambi.DarkRP.Config.jobs_class
    if not Ambi.DarkRP.GetJob( class ) then ePly:Kick( '[DarkRP] Не создана дефолтная профессия: '..class ) return end

    timer.Simple( 0.02, function()
        if not IsValid( ePly ) then return end
        if ePly:IsBot() then 
            ePly:SetJob( Ambi.DarkRP.Config.jobs_class, true ) 
            return 
        end

        if Ambi.DarkRP.Config.jobs_permanent_enable then 
            local class = SQL.Select( DB, 'Class', 'SteamID', ePly:SteamID() )

            if class then ePly:SetJob( class ) else ePly:SetJob( Ambi.DarkRP.Config.jobs_class, true ) end
        else
            ePly:SetJob( Ambi.DarkRP.Config.jobs_class, true )
        end

        hook.Call( '[Ambi.DarkRP.SetFirstJob]', nil, ePly )

        timer.Simple( 1, function()
            if not IsValid( ePly ) then return end

            if ePly:GetJobTable().is_fake then ePly:SetJob( Ambi.DarkRP.Config.jobs_class, true ) end
        end )
    end )
end )

hook.Add( 'PlayerSpawn', 'Ambi.DarkRP.SetJobStats', function( ePly )
    timer.Simple( 0.03, function()
        if not IsValid( ePly ) then return end

        ePly:SetJobFeatures()

        if ePly:IsArrested() then return end

        local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
        if not job then return end

        if job.spawns then
            local spawn = table.Random( job.spawns )
            if spawn then
                if spawn.pos then ePly:SetPos( spawn.pos ) end
                if spawn.ang then ePly:SetEyeAngles( spawn.ang ) end
            end

            -- timer.Simple( 0.1, function() --! probably bug with spawn
            --     if ePly:GetPos() != spawn.pos then ePly:SetPos( spawn.pos ) end
            -- end )
        end

        if Ambi.DarkRP.Config.positions_enable then
            local positions = Ambi.DarkRP.GetJobPositions( ePly:Job() )
            if not positions then return end

            local current_map_positions = {}
            for i, v in ipairs( positions ) do
                if ( v.map == game.GetMap() ) then
                    current_map_positions[ #current_map_positions + 1 ] = v
                end
            end

            if ( #current_map_positions == 0 ) then return end
            
            local position = table.Random( current_map_positions )
            ePly:SetPos( position.pos )
            ePly:SetEyeAngles( position.ang )
        end
    end )
end )

hook.Add( 'PlayerChangedTeam', 'Ambi.DarkRP.SetPlayerJob', function( ePly )
    ePly.job_model = nil

    if not Ambi.DarkRP.Config.jobs_respawn then 
        ePly:StripWeapons()
        ePly:StripAmmo()

        ePly:SetJobFeatures()
    end
end )

hook.Add( 'PlayerSay', 'Ambi.DarkRP.SetJob', function( ePly, sText ) 
    if not Ambi.DarkRP.Config.jobs_change_on_chat_command then return end

    local class = Ambi.DarkRP.jobs_commands[ sText ]
    if not class then return end

    local job = Ambi.DarkRP.GetJob( class )
    if not job then return end

    if ( job.can_join_command == false ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя вступить в эту работу через команду!' ) return '' end
    if ( hook.Call( '[Ambi.DarkRP.CanChangeJobByCommand]', nil, ePly, class, job ) == false ) then return '' end

    ePly:SetJob( class )

    hook.Call( '[Ambi.DarkRP.ChangedJobByCommand]', nil, ePly, class, job )

    if Ambi.DarkRP.Config.jobs_change_on_chat_command_hide then return '' end
end )

hook.Add( 'GetFallDamage', 'Ambi.DarkRP.JobFallDamage', function( ePly, nSpeed )
    local fall_damage = ePly:GetJobTable().fall_damage
    if fall_damage then return fall_damage end
end )

hook.Add( 'PlayerSpawn', 'Ambi.DarkRP.GiveJobWeapons', function( ePly )
    timer.Simple( 0.1, function()
        if not IsValid( ePly ) or not ePly:Alive() then return end

        local weapons = ePly:GetJob()[ 'weapons' ]
        if not weapons or ( #weapons == 0 ) then return end
        if ( hook.Call( '[Ambi.DarkRP.CanGiveJobWeapons]', nil, ePly, weapons ) == false ) then return end

        for _, class in ipairs( weapons ) do
            ePly:Give( class )
        end

        hook.Call( '[Ambi.DarkRP.GaveJobWeapons]', nil, ePly, weapons )
    end )
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'EntityTakeDamage', 'Ambi.DarkRP.JobDamage', function( eObj, dmgInfo )
    local attacker = dmgInfo:GetAttacker()
    if not IsValid( attacker ) or not attacker:IsPlayer() then return end

    local damage = attacker:GetJobTable().damage
    if damage then dmgInfo:SetDamage( damage ) end

    local add_damage = attacker:GetJobTable().add_damage
    if add_damage then dmgInfo:SetDamage( dmgInfo:GetDamage() + add_damage ) end

    local multiply_damage = attacker:GetJobTable().multiply_damage
    if multiply_damage then dmgInfo:SetDamage( dmgInfo:GetDamage() * multiply_damage ) end

    if not eObj:IsPlayer() then return end
    
    local job = eObj:GetJobTable()
    if not job then return end

    local damage = job.take_damage
    if damage then dmgInfo:SetDamage( damage ) end

    local add_damage = job.take_add_damage
    if add_damage then dmgInfo:SetDamage( dmgInfo:GetDamage() + add_damage ) end

    local multiply_damage = job.take_multiply_damage
    if multiply_damage then dmgInfo:SetDamage( dmgInfo:GetDamage() * multiply_damage ) end
end )

hook.Add( 'PlayerDeath', 'Ambi.DarkRP.DemoteJobAfterDeath', function( ePly ) 
    local job = ePly:GetJobTable()

    if job and job.demote_after_death then ePly:SetJob( Ambi.DarkRP.Config.jobs_class, true, false ) end
end )

hook.Add( '[Ambi.DarkRP.CanBuyDoor]', 'Ambi.DarkRP.RestrictCanBuyDoorForJobs', function( ePly, eDoor ) 
    local job = ePly:GetJobTable()
    if not job then return end

    if ( job.can_buy_door == false ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваша работа не имеет право покупать двери!' ) return false end

    local count = 0
    for door, _ in pairs( ePly.doors ) do
        count = count + 1
    end

    if job.doors_max and ( count >= job.doors_max ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы достигли максимум дверей для работы!' ) return false end
end )

hook.Add( '[Ambi.DarkRP.CanArrest]', 'Ambi.DarkRP.PropertyForJobs', function( ePolice, ePly ) 
    local job = ePly:GetJobTable()
    if not job then return end

    if ( job.can_arrest == false ) then 
        if IsValid( ePolice ) then ePolice:ChatSend( C.ERROR, '• ', C.ABS_WHITE, 'Вы не сможете арестовать игрока из-за его работы!' ) end

        return false 
    end
end )

hook.Add( '[Ambi.DarkRP.CanWanted]', 'Ambi.DarkRP.PropertyForJobs', function( ePolice, ePly ) 
    local job = ePly:GetJobTable()
    if not job then return end

    if ( job.can_wanted == false ) then 
        if IsValid( ePolice ) then ePolice:ChatSend( C.ERROR, '• ', C.ABS_WHITE, 'Вы не сможете подать в розыск игрока из-за его работы!' ) end
        
        return false 
    end
end )

hook.Add( '[Ambi.DarkRP.CanWarrant]', 'Ambi.DarkRP.PropertyForJobs', function( ePolice, ePly ) 
    local job = ePly:GetJobTable()
    if not job then return end

    if ( job.can_warrant == false ) then 
        if IsValid( ePolice ) then ePolice:ChatSend( C.ERROR, '• ', C.ABS_WHITE, 'Вы не сможете взять ордер на обыск игрока из-за его работы!' ) end
        
        return false 
    end
end )

hook.Add( 'PlayerCanPickupWeapon', 'Ambi.DarkRP.PropertyForJobs', function( ePly )
    local job = ePly:GetJobTable()
    if not job then return end

    if ( job.can_pickup_weapons == false ) and not ePly.workaround_can_pickup_weapon  and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( '[Ambi.DarkRP.CanBuyShopItem]', 'Ambi.DarkRP.PropertyForJobs', function( ePly ) 
    local job = ePly:GetJobTable()
    if not job then return end

    if ( job.can_buy_shop_item == false ) then ePly:ChatSend( C.ERROR, '• ', C.ABS_WHITE, 'Ваша работа не позволяет покупать предметы!' ) return false end
end )

hook.Add( '[Ambi.DarkRP.CanSellShopItem]', 'Ambi.DarkRP.PropertyForJobs', function( ePly ) 
    local job = ePly:GetJobTable()
    if not job then return end

    if ( job.can_sell_shop_item == false ) then ePly:ChatSend( C.ERROR, '• ', C.ABS_WHITE, 'Ваша работа не позволяет продавать предметы!' ) return false end
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Old (DarkRP)
hook.Add( 'PlayerSpawn', 'Ambi.DarkRP.JobCustomField', function( ePly )
    timer.Simple( 0, function()
        if not IsValid( ePly ) then return end

        local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
        if not job then return end

        local Action = job.PlayerSpawn
        if Action then
            return Action( ePly )
        end
    end )
end )

hook.Add( 'CanPlayerSuicide', 'Ambi.DarkRP.JobCustomField', function( ePly )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.CanPlayerSuicide
    if Action then
        return Action( ePly )
    end
end )

hook.Add( 'PlayerCanPickupWeapon', 'Ambi.DarkRP.JobCustomField', function( ePly, eWeapon )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.PlayerCanPickupWeapon
    if Action then
        return Action( ePly, eWeapon )
    end
end )

hook.Add( 'PlayerDeath', 'Ambi.DarkRP.JobCustomField', function( ePly, eWeapon, eAttacker )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.PlayerDeath
    if Action then
        return Action( ePly, eWeapon, eAttacker )
    end
end )

hook.Add( 'PlayerLoadout', 'Ambi.DarkRP.JobCustomField', function( ePly )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.PlayerLoadout
    if Action then
        return Action( ePly )
    end
end )

hook.Add( 'PlayerSelectSpawn', 'Ambi.DarkRP.JobCustomField', function( ePly, bTransition )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.PlayerSelectSpawn
    if Action then
        Action( ePly, bTransition )
    end
end )

hook.Add( 'PlayerSetModel', 'Ambi.DarkRP.JobCustomField', function( ePly )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.PlayerSetModel
    if Action then
        return Action( ePly )
    end
end )

hook.Add( 'ShowHelp', 'Ambi.DarkRP.JobCustomField', function( ePly ) -- F1
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.ShowHelp
    if Action then
        Action( ePly )
    end
end )

hook.Add( 'ShowTeam', 'Ambi.DarkRP.JobCustomField', function( ePly ) -- F2
    if not job then return end

    local Action = job.ShowTeam
    if Action then
        Action( ePly )
    end
end )

hook.Add( 'ShowSpare1', 'Ambi.DarkRP.JobCustomField', function( ePly ) -- F3
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.ShowSpare1
    if Action then
        Action( ePly )
    end
end )

hook.Add( 'ShowSpare2', 'Ambi.DarkRP.JobCustomField', function( ePly ) -- F4
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.ShowSpare2
    if Action then
        Action( ePly )
    end
end )

hook.Add( 'PlayerChangedTeam', 'Ambi.DarkRP.JobCustomField', function( ePly, nOldTeam, nNewTeam )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.PlayerChangedTeam
    if Action then
        Action( ePly, nOldTeam, nNewTeam )
    end
end )

-- New

local hook_name = 'PlayerSwitchFlashlight'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, bEnabled )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, bEnabled )
    end
end )

local hook_name = 'CanPlayerEnterVehicle'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, bEnabled, nRole )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, eVehicle, nRole )
    end
end )

local hook_name = 'CanPlayerUnfreeze'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, eObj, physObj )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, eObj, physObj )
    end
end )

local hook_name = 'PlayerCanHearPlayersVoice'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( eListener, eTalker )
    local job = Ambi.DarkRP.GetJob( eListener:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        local can_hear, voice_3d = Action( eListener, eTalker )

        return can_hear, voice_3d
    end
end )

local hook_name = 'PlayerSay'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sText, bTeamChat )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sText, bTeamChat )
    end
end )

local hook_name = 'PlayerShouldTakeDamage'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, eAttacker )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, eAttacker )
    end
end )

local hook_name = 'PlayerShouldTaunt'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, nAct )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, nAct )
    end
end )

local hook_name = 'PlayerSpray'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly )
    end
end )

local hook_name = 'PlayerSwitchWeapon'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, wepOld, wepNew )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, wepOld, wepNew )
    end
end )

local hook_name = 'PlayerGiveSWEP'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sWeapon, tSWEP )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sWeapon, tSWEP )
    end
end )

hook.Add( 'PlayerSpawnProp', 'Ambi.DarkRP.JobCustomField', function( ePly, sObj )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job.PlayerSpawnProp
    if Action then
        return Action( ePly, sObj )
    end
end )

local hook_name = 'PlayerSpawnEffect'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sModel )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sModel )
    end
end )

local hook_name = 'PlayerSpawnNPC'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sNPC, sWeapon )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sNPC, sWeapon )
    end
end )

local hook_name = 'PlayerSpawnObject'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sModel, nSkin )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sModel, nSkin )
    end
end )

local hook_name = 'PlayerSpawnRagdoll'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sModel )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sModel )
    end
end )

local hook_name = 'PlayerSpawnSENT'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sClass )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sClass )
    end
end )

local hook_name = 'PlayerSpawnSWEP'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sWeapon, tWeapon )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sWeapon, tWeapon )
    end
end )

local hook_name = 'PlayerSpawnVehicle'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sModel, sName, tVehicle )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sModel, sName, tVehicle )
    end
end )

local hook_name = 'CanTool'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, tTrace, sTool, tTool, nMouseButton )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, tTrace, sTool, tTool, nMouseButton )
    end
end )

local hook_name = 'CanProperty'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, sProperty, eObj )
    local job = Ambi.DarkRP.GetJob( ePly:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, sProperty, eObj )
    end
end )

local hook_name = 'PlayerCanSeePlayersChat'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( sText, bTeamOnly, eListener, eSpeaker )
    local job = Ambi.DarkRP.GetJob( eListener:GetJob() )
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( sText, bTeamOnly, eListener, eSpeaker )
    end
end )

local hook_name = 'CanUndo'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, tUndo )
    local job = ePly:GetJobTable()
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, tUndo )
    end
end )

local hook_name = 'CanPlayerUnfreeze'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, eObj, physObj )
    local job = ePly:GetJobTable()
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, eObj, physObj )
    end
end )

local hook_name = 'CanExitVehicle'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( eVehicle, ePly )
    local job = ePly:GetJobTable()
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( eVehicle, ePly )
    end
end )

local hook_name = 'PlayerUse'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, eObj )
    local job = ePly:GetJobTable()
    if not job then return end

    local Action = job[ hook_name ]
    if Action then
        return Action( ePly, eObj )
    end
end )

local hook_name = 'SetupMove'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, cmoveInfo, cuserCommand )
    local job = ePly:GetJobTable()
    if job then
        local Action = job[ hook_name ]
        
        if Action then
            Action( ePly, cmoveInfo, cuserCommand )
        end
    end
end )

local hook_name = 'PlayerButtonDown'
hook.Add( hook_name, 'Ambi.DarkRP.JobCustomField', function( ePly, nButton )
    local job = ePly:GetJobTable()
    if job then
        local Action = job[ hook_name ]
        
        if Action then
            Action( ePly, nButton )
        end
    end
end )