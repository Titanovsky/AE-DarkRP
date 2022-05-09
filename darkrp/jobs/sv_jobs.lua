local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local DB = SQL.CreateTable( 'darkrp_alt_permajobs', 'SteamID, Class' )
local PLAYER = FindMetaTable( 'Player' )

function PLAYER:SetJob( sClass, bForce, bRespawn )
    if not sClass then sClass = Ambi.DarkRP.Config.jobs_class end
    
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job or not job.index then return end

    if not bForce then 
        if Ambi.DarkRP.Config.jobs_compatibility and ( hook.Call( 'playerCanChangeTeam', nil, self, job.id, bForce ) == false ) then return end -- 
        if ( hook.Call( '[Ambi.DarkRP.CanChangeJob]', nil, self, sClass, bForce ) == false ) then return end
        if timer.Exists( 'AmbiDarkRPJobDelay:'..self:SteamID() ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: ', C.ERROR, tostring( math.Round( timer.TimeLeft( 'AmbiDarkRPJobDelay:'..self:SteamID() ) ) ) , C.ABS_WHITE, ' секунд' )  return false end
        if self:GetBlockJob( sClass ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Работа ', C.ERROR, job.name, C.ABS_WHITE, ' заблокирована для Вас!' )  return false end
        if job.admin then
            if ( job.admin == 1 ) and not self:IsAdmin() then return false
            elseif ( job.admin == 2 ) and not self:IsSuperAdmin() then return false
            end
        end
        if job.from then
            local class = job.from

            if isstring( class ) then
                if ( self:Job() != class ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Для ', C.ERROR, job.name, C.ABS_WHITE, ' Вам нужна работа ', C.ERROR, Ambi.DarkRP.GetJob( class ).name ) return false end
            elseif isnumber( class ) then
                if ( self:Team() != class ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Для ', C.ERROR, job.name, C.ABS_WHITE, ' Вам нужна работа ', C.ERROR, team.GetName( class ) ) return false end
            end
        end
        if job.CustomCheck and ( job.CustomCheck( self ) == false ) then
            if job.CustomCheckFailMsg then 
                self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, job.CustomCheckFailMsg( self, job ) ) 
            else 
                self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Недоступно!' ) 
            end

            return false 
        end
        if job.max and ( job.max != 0 ) then
            local max = job.max

            local count = 0
            for i, ply in ipairs( player.GetAll() ) do
                if ( ply:GetJob() == sClass ) then count = count + 1 end
            end

            if ( max > 0 ) and ( max < 1 ) then
                if ( ( count + 1 ) / #player.GetAll() > max ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Максимальный процент игроков с этой работы ', C.ERROR, '('..tostring( max * 100 )..'%)', C.ABS_WHITE, ' достигнут!' ) return false end
            else
                if ( count >= max ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Максимальное количество игроков с этой работы ', C.ERROR, '('..max..')', C.ABS_WHITE, ' достигнуто!' )  return false end
            end
        end
        if job.map and ( job.map != game.GetMap() ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данная работа доступна на карте ', C.ERROR, job.map ) return false end
        if job.maps then
            local can = false
            for _, map in ipairs( job.maps ) do
                if ( map == game.GetMap() ) then can = true break end
            end

            if not can then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данная работа не доступна на этой карте!' ) return false end
        end
        if job.whitelist then
            if not job.whitelist[ self:SteamID() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не подходите под Whitelist!' ) return false end
        end
        if job.vote and Ambi.DarkRP.Config.vote_enable and ( #player.GetAll() > 1 ) or job.RequiresVote and ( job.RequiresVote( self, job ) != false ) then -- job.vote Всегда должна быть в последней проверки из-за специфики Ply:SetJob( class, true )
            if job.CanStartVote and ( job.CanStartVote( self ) == false ) then return false end
            if not Ambi.DarkRP.CanStartVote() then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Максимум голосований достигнут, попробуйте позже!' ) return false end

            timer.Create( 'AmbiDarkRPJobDelay:'..self:SteamID(), Ambi.DarkRP.Config.jobs_delay, 1, function() end )

            Ambi.DarkRP.StartVote( self:Name()..' хочет стать '..job.name, function()
                if IsValid( self ) then self:SetJob( sClass, true ) end
            end, function() 
                if IsValid( self ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'К сожалению, Вы не победили в голосований!' )  end
            end )

            return false
        end
    end

    self:SetTeam( job.index )
    self:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Ваша профессия: ', job.color, job.name )
    timer.Create( 'AmbiDarkRPJobDelay:'..self:SteamID(), Ambi.DarkRP.Config.jobs_delay, 1, function() end )

    if Ambi.DarkRP.Config.jobs_respawn and ( bRespawn != false ) then 
        self:StripWeapons()
        self:StripAmmo()
        self:Spawn() 
    else
        self:SetJobFeatures()
    end

    if Ambi.DarkRP.Config.jobs_permanent_with_set_job and not Ambi.DarkRP.Config.jobs_permanent_exceptions[ sClass ] then
        local sid = self:SteamID()
        if not SQL.Select( DB, 'SteamID', 'SteamID', sid ) then SQL.Insert( DB, 'SteamID, Class', '%s, %s', sid, sClass ) return end

        SQL.Update( DB, 'Class', sClass, 'SteamID', sid )
    end

    return true
end

function PLAYER:SetPermaJob( sClass, bForce )
    if not Ambi.DarkRP.Config.jobs_permanent_enable then return end
    if Ambi.DarkRP.Config.jobs_permanent_exceptions[ sClass ] then return end

    self:SetJob( sClass, bForce )

    if ( self:GetJob() == sClass ) then
        local sid = self:SteamID()
        if not SQL.Select( DB, 'SteamID', 'SteamID', sid ) then SQL.Insert( DB, 'SteamID, Class', '%s, %s', sid, sClass ) return end

        SQL.Update( DB, 'Class', sClass, 'SteamID', sid )
        self:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Работа сохранена!' )
    end
end

Ambi.DarkRP.players_block_jobs = Ambi.DarkRP.players_block_jobs or {}

function PLAYER:BlockJob( sClass, nTime )
    if not sClass or ( sClass == Ambi.DarkRP.Config.jobs_class ) then return end
    
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job or not job.index then return end

    local sid = self:SteamID()
    if not Ambi.DarkRP.players_block_jobs[ sid ] then Ambi.DarkRP.players_block_jobs[ sid ] = {} end

    Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] = true

    if nTime and ( nTime > 0 ) then
        timer.Simple( nTime, function()
            if IsValid( self ) then self:UnBlockJob( sClass ) end
        end )
    end
end

function PLAYER:UnBlockJob( sClass )
    if not sClass or ( sClass == Ambi.DarkRP.Config.jobs_class ) then return end
    
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job or not job.index then return end

    local sid = self:SteamID()
    if Ambi.DarkRP.players_block_jobs[ sid ] and Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] then Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] = nil end
end
    
function PLAYER:GetBlockJob( sClass )
    if not sClass or ( sClass == Ambi.DarkRP.Config.jobs_class ) then return end
    
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job or not job.index then return end

    local sid = self:SteamID()
    if Ambi.DarkRP.players_block_jobs[ sid ] then return Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] end

    return false
end

function PLAYER:SetJobFeatures()
    if not IsValid( self ) then return end

    local job = Ambi.DarkRP.GetJob( self:GetJob() )
    if not job then return end

    if Ambi.DarkRP.Config.jobs_set_color then 
        local color = job.color
        local color_model =  Vector( color.r / 255, color.g / 255, color.b / 255 )
        self:SetPlayerColor( color_model ) 
    end

    if self.job_model then
        self:SetModel( self.job_model )
    elseif Ambi.DarkRP.Config.jobs_random_models then
        self:SetModel( table.Random( job.models ) )
    else
        self:SetModel( job.models[ 1 ] )
    end

    if job.model_scale then
        self:SetModelScale( job.model_scale )
    end

    if job.health or job.hp then self:SetHealth( job.health or job.hp ) end
    if job.max_health or job.max_hp then self:SetMaxHealth( job.max_health or job.max_hp ) end
    if job.armor then self:SetArmor( job.armor ) end
    if job.max_armor then self:SetMaxArmor( job.max_armor ) end
    if job.walkspeed then self:SetWalkSpeed( job.walkspeed ) end
    if job.runspeed then self:SetRunSpeed( job.runspeed ) end
    if job.jumpower then self:SetJumpPower( job.jumpower ) end
    if job.license then self:GiveRealLicenseGun() end
    if job.god then self:GodEnable() end

    if job.ammo then
        for ammo, count in pairs( job.ammo ) do self:GiveAmmo( count, ammo, true ) end
    end

    self:GiveWeaponsJob()
end

function PLAYER:GiveWeaponsJob()
    local job = Ambi.DarkRP.GetJob( self:GetJob() )
    if not job then return end

    local weps = job.weapons
    if not weps then return end

    self:StripWeapons()

    for _, class in ipairs( weps ) do 
        self:Give( class, not Ambi.DarkRP.Config.jobs_default_ammo ) 
        self:GetWeapon( class ).cannot_drop = true
    end

    if Ambi.DarkRP.Config.player_base_enable then
        for _, class in ipairs( Ambi.DarkRP.Config.player_base_weapons ) do 
            self:Give( class ) 
            self:GetWeapon( class ).cannot_drop = true
        end
    end
end

function PLAYER:DemoteJob( bForce, ePly )
    if not bForce then
        if not self:CanDemoteJob( ePly ) then return false end

        return false
    end

    self:SetJob( Ambi.DarkRP.Config.jobs_class, true, false )

    hook.Call( '[Ambi.DarkRP.PlayerDemoted]', nil, ePly, self, bForce )

    return true
end

-- ================= Compatibility ==================================================================== --
function PLAYER:teamChange( anyID, bForce )
    if not Ambi.DarkRP.Config.jobs_compatibility then return end
    if not anyID then return end

    if isnumber( anyID ) then
        for class, job in pairs( Ambi.DarkRP.GetJobs() ) do
            if ( job.index == anyID ) then return self:SetJob( class, bForce ) end
        end
    else
        return self:SetJob( anyID, bForce )
    end
end

-- ================= Nets ============================================================================ --
net.AddString( 'ambi_darkrp_demote_player' )
net.Receive( 'ambi_darkrp_demote_player', function( _, ePly )
    if not ePly:GetDelay( 'AmbiDarkRPDemote' ) then ePly:SetDelay( 'AmbiDarkRPDemote', Ambi.DarkRP.Config.jobs_demote_delay ) else ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: ', C.ERROR, tostring( math.floor( timer.TimeLeft( 'AmbiDarkRPDemote['..ePly:SteamID()..']' ) ) ), C.ABS_WHITE, ' секунд' ) return end

    if not Ambi.DarkRP.Config.jobs_demote_enable then ePly:Kick( '[DarkRP] Попытка уволить игрока, когда система отключена!' ) return end
    if not Ambi.DarkRP.CanStartVote() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Сейчас нельзя сделать голосование!' ) return end

    local demoter = net.ReadEntity()
    if not IsValid( demoter ) or not demoter:IsPlayer() then ePly:Kick( '[DarkRP] Попытка уволить НЕ игрока!' ) return end
    if not Ambi.DarkRP.Config.jobs_demote_can_similar_job and ( ePly:Job() == demoter:Job() ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя уволить игрока с такой же работой, как у Вас!' ) return end
    if not demoter:CanDemoteJob( ePly, '' ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данного игрока нельзя уволить!' ) return end

    Ambi.DarkRP.StartVote( ePly:Nick()..' желает уволить '..demoter:Nick(), function() 
        if IsValid( demoter ) and IsValid( ePly ) then  
            ePly:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вы уволили ', C.AMBI, demoter:Nick(), C.ABS_WHITE,' с работы ', C.AMBI_BLUE, demoter:TeamName() )

            demoter:DemoteJob( true, ePly )
            demoter:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вас уволил ', C.AMBI, ePly:Nick() )
        end
    end, function() 
        if IsValid( ePly ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Голосование на увольнения провалилось!' ) end
    end )
end )