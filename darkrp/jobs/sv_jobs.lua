local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local DB = SQL.CreateTable( 'darkrp2_permajobs', 'SteamID, Class' )
local PLAYER = FindMetaTable( 'Player' )

function PLAYER:SetJob( sClass, bForce, bRespawn )
    if not sClass then sClass = Ambi.DarkRP.Config.jobs_class end
    
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job or not job.index then return end

    if not bForce then 
        if ( hook.Call( '[Ambi.DarkRP.CanChangeJob]', nil, self, sClass, bForce, job ) == false ) then return end --todo old, should remove
        if ( hook.Call( '[Ambi.DarkRP.CanSetJob]', nil, self, sClass, bForce, job ) == false ) then return end -- new
        if timer.Exists( 'AmbiDarkRPJobDelay:'..self:SteamID() ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: ', C.ERROR, tostring( math.Round( timer.TimeLeft( 'AmbiDarkRPJobDelay:'..self:SteamID() ) ) ) , C.ABS_WHITE, ' секунд' )  return false end
        if self:GetBlockJob( sClass ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Работа ', C.ERROR, job.name, C.ABS_WHITE, ' заблокирована для Вас!' )  return false end

        if job.check then
            for _, tab in ipairs( job.check ) do
                local key = tab[ 1 ] or 'none'
                local value = tab[ 2 ] or 0
                local reason = tab[ 3 ] or 'Вы не подходите под '..key

                if isnumber( value ) then
                    if ( self[ key ] == nil ) or ( self[ key ] < value ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, reason ) return false end
                else
                    if ( self[ key ] == nil ) or not ( self[ key ] == value ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, reason ) return false end
                end
            end
        end

        if job.vip and not Ambi.DarkRP.Config.jobs_vip_ranks[ self:GetUserGroup() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваш ранг не подходит под VIP!' ) return false end
        if job.premium and not Ambi.DarkRP.Config.jobs_premium_ranks[ self:GetUserGroup() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваш ранг не подходит под Premium!' ) return false end

        if job.admin then
            if ( job.admin == 1 ) and not self:IsAdmin() then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Доступно только для админских ранов!' ) return false
            elseif ( job.admin == 2 ) and not self:IsSuperAdmin() then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваша работа не подходит под список доступных для суперадминов работ!' ) return false
            end
        end

        if job.block_admin and self:IsAdmin() then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Недоступно для админских рангов!' ) return false end
        if job.block_user and self:IsUserGroup( 'user' ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Недоступно для обычного игрока!' ) return false end

        if job.from then
            local class = job.from

            if isstring( class ) then
                if ( self:Job() != class ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Для ', C.ERROR, job.name, C.ABS_WHITE, ' Вам нужна работа ', C.ERROR, Ambi.DarkRP.GetJob( class ).name ) return false end
            elseif isnumber( class ) then
                if ( self:Team() != class ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Для ', C.ERROR, job.name, C.ABS_WHITE, ' Вам нужна работа ', C.ERROR, team.GetName( class ) ) return false end
            end
        end

        if job.from_jobs then
            local can = false

            for _, class in ipairs( job.from_jobs ) do
                if ( self:Job() == class ) then can = true break end
            end
            
            if not can then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваша работа не подходит под список доступных для перехода работ!' ) return false end
        end

        if job.CustomCheck and ( job.CustomCheck( self, job ) == false ) then
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

        if job.whitelist_ranks then
            if not job.whitelist_ranks[ self:GetUserGroup() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не подходите под Whitelist Ranks!' ) return false end
        end

        if job.whitelist_nicks then
            if not job.whitelist_nicks[ self:Nick() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не подходите под Whitelist Nick!' ) return false end
        end

        if job.whitelist_steamid then
            if not job.whitelist_steamid[ self:SteamID() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не подходите под Whitelist SteamID!' ) return false end
        end

        if job.whitelist_steamid64 then
            if not job.whitelist_steamid64[ self:SteamID64() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не подходите под Whitelist SteamID64!' ) return false end
        end

        if job.whitelist_models then
            if not job.whitelist_models[ self:GetModel() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не подходите под Whitelist Models!' ) return false end
        end

        if job.whitelist_colors then
            if not job.whitelist_colors[ self:GetColor() ] then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не подходите под Whitelist Colors!' ) return false end
        end

        if job.has_weapon and not self:HasWeapon( job.has_weapon ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'У вас нет оружия: ', C.ERROR, job.has_weapon ) return false end
        if job.has_weapons then
            local can = false

            for _, class in ipairs( job.has_weapons ) do
                if self:HasWeapon( class ) then can = true break end
            end
            
            if not can then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'У Вас нет необходимого оружия для вступления на работу!' )  return false end
        end
        
        if job.money then
            local money = self:GetMoney()
            if ( money < job.money ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'У Вас не хватает денег ', C.ERROR, job.money..Ambi.DarkRP.Config.money_currency_symbol ) return false end

            self:AddMoney( -job.money )
            self:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы потратили ', C.AMBI_GREEN, job.money..Ambi.DarkRP.Config.money_currency_symbol )
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

    local old_class = self:GetJob()

    self:SetTeam( job.index )
    -- self:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Ваша профессия: ', job.color, job.name ) -- debug

    local delay = Ambi.DarkRP.Config.jobs_delay
    timer.Create( 'AmbiDarkRPJobDelay:'..self:SteamID(), delay, 1, function() end )

    if Ambi.DarkRP.Config.jobs_respawn and ( bRespawn != false ) then 
        self:StripWeapons()
        self:StripAmmo()
        self:Spawn() 
    else
        self:SetJobFeatures()
    end

    if Ambi.DarkRP.Config.jobs_permanent_enable and Ambi.DarkRP.Config.jobs_permanent_with_set_job and not Ambi.DarkRP.Config.jobs_permanent_exceptions[ sClass ] then
        local sid = self:SteamID()
        if not SQL.Select( DB, 'SteamID', 'SteamID', sid ) then SQL.Insert( DB, 'SteamID, Class', '%s, %s', sid, sClass ) return end

        SQL.Update( DB, 'Class', sClass, 'SteamID', sid )

        hook.Call( '[Ambi.DarkRP.SetPermaJob]', nil, self, sClass, bForce, old_class, job )
    end

    hook.Call( '[Ambi.DarkRP.SetJob]', nil, self, sClass, bForce, old_class, job )

    return true
end

Ambi.DarkRP.players_block_jobs = Ambi.DarkRP.players_block_jobs or {}

function PLAYER:BlockJob( sClass, nTime )
    if not sClass or ( sClass == Ambi.DarkRP.Config.jobs_class ) then return end
    
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job or not job.index then return end
    if ( hook.Call( '[Ambi.DarkRP.CanBlockJob]', nil, self, sClass, nTime, job ) == false ) then return end

    local sid = self:SteamID()
    if not Ambi.DarkRP.players_block_jobs[ sid ] then Ambi.DarkRP.players_block_jobs[ sid ] = {} end

    Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] = true

    hook.Call( '[Ambi.DarkRP.BlockedJob]', nil, self, sClass, nTime, job )

    if nTime and ( nTime > 0 ) then
        timer.Simple( nTime, function()
            if IsValid( self ) then 
                self:UnBlockJob( sClass ) 
            else
                Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] = nil

                hook.Call( '[Ambi.DarkRP.UnBlockedJobForOfflinePlayer]', nil, sid, sClass, nTime )
            end
        end )
    end
end

function PLAYER:UnBlockJob( sClass )
    if not sClass or ( sClass == Ambi.DarkRP.Config.jobs_class ) then return end
    
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job or not job.index then return end
    if ( hook.Call( '[Ambi.DarkRP.CanUnBlockJob]', nil, self, sClass, nTime, job ) == false ) then return end

    local sid = self:SteamID()
    if Ambi.DarkRP.players_block_jobs[ sid ] and Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] then Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] = nil end

    hook.Call( '[Ambi.DarkRP.UnBlockedJob]', nil, self, sClass, job )
end
    
function PLAYER:GetBlockJob( sClass )
    if not sClass or ( sClass == Ambi.DarkRP.Config.jobs_class ) then return end
    
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job or not job.index then return end

    local sid = self:SteamID()
    if Ambi.DarkRP.players_block_jobs[ sid ] then return Ambi.DarkRP.players_block_jobs[ sid ][ sClass ] end

    return false
end

function PLAYER:SetJobHands()
    -- thanks to Enhanced Player Selector
    local model_name = player_manager.TranslateToPlayerModelName( self:GetModel() ) -- string name of model
    local hands_info = player_manager.TranslatePlayerHands( model_name ) -- table: model, skin, body
    local hands = self:GetHands() -- entity

    if ( hook.Call( '[Ambi.DarkRP.CanSetJobHands]', nil, self, model_name, hands_info, hands ) == false ) then return end

    if IsValid( hands ) and hands_info and istable( hands_info ) then
        self.workaround_can_pickup_weapon = true --! for job.can_pickup_weapons

        hands:SetModel( hands_info.model )
        hands:SetSkin( hands_info.skin )
        hands:SetBodyGroups( hands_info.body )

        hook.Call( '[Ambi.DarkRP.SetJobHands]', nil, self, model_name, hands_info, hands )

        self.workaround_can_pickup_weapon = nil
    end
end

function PLAYER:SetJobFeatures()
    local job = Ambi.DarkRP.GetJob( self:GetJob() )
    if not job then return end
    if ( hook.Call( '[Ambi.DarkRP.CanSetJobFeatures]', nil, self, job ) == false ) then return end

    if Ambi.DarkRP.Config.jobs_set_color then 
        if job.color_model then
            self:SetColor( job.color_model )
        else
            local color = job.color
            local vector_from_color = Vector( color.r / 255, color.g / 255, color.b / 255 )
            self:SetPlayerColor( vector_from_color ) 
            self:SetColor( C.ABS_WHITE )
        end
    end

    if self.job_model then
        self:SetModel( self.job_model )
    elseif Ambi.DarkRP.Config.jobs_random_models then
        self:SetModel( table.Random( job.models ) )
    else
        self:SetModel( job.models[ 1 ] )
    end

    if job.material then self:SetMaterial( job.material ) end

    if job.model_scale then self:SetModelScale( job.model_scale ) else self:SetModelScale( Ambi.DarkRP.Config.player_base_scale ) end

    if job.bodygroups then
        for id, value in pairs( job.bodygroups ) do
            self:SetBodygroup( id, value )
        end
    end

    if job.skin then self:SetSkin( job.skin ) else self:SetSkin( Ambi.DarkRP.Config.player_base_skin ) end

    if job.health or job.hp then self:SetHealth( job.health or job.hp ) end
    if job.max_health or job.max_hp then self:SetMaxHealth( job.max_health or job.max_hp ) end
    if job.armor then self:SetArmor( job.armor ) end
    if job.max_armor then self:SetMaxArmor( job.max_armor ) end

    if job.walkspeed then self:SetWalkSpeed( job.walkspeed ) end
    if job.runspeed then self:SetRunSpeed( job.runspeed ) end
    if job.maxspeed then self:SetMaxSpeed( job.maxspeed ) end 
    if job.duckspeed then self:SetDuckSpeed( job.duckspeed ) end 
    if job.unduckspeed then self:SetUnDuckSpeed( job.unduckspeed ) end
    if job.crouchedspeed then self:SetCrouchedWalkSpeed( job.crouchedspeed ) end
    if job.ladderclimbspeed then self:SetLadderClimbSpeed( job.ladderclimbspeed ) end
    if job.slowwalkspeed then self:SetSlowWalkSpeed( job.slowwalkspeed ) end
    if job.jumppower then self:SetJumpPower( job.jumppower ) end

    if job.license then self:GiveRealLicenseGun() end
    if job.fake_license then self:GiveFakeLicenseGun() end
    if job.god then self:GodEnable() else self:GodDisable() end

    if job.ammo then
        for ammo, count in pairs( job.ammo ) do self:GiveAmmo( count, ammo, true ) end
    end

    if job.delay then timer.Create( 'AmbiDarkRPJobDelay:'..self:SteamID(), job.delay, 1, function() end ) end
    if job.block then self:BlockJob( self:GetJob(), job.block ) end

    self:SetJobHands()
    self:GiveWeaponsJob()

    hook.Call( '[Ambi.DarkRP.SetJobFeatures]', nil, self, job )
end

function PLAYER:GiveWeaponsJob()
    local job = Ambi.DarkRP.GetJob( self:GetJob() )
    if not job then return end

    local weps = job.weapons
    if not weps then return end
    if ( hook.Call( '[Ambi.DarkRP.CanGiveWeaponsJob]', nil, self, weps, job ) == false ) then return end

    self.workaround_can_pickup_weapon = true --! for job.can_pickup_weapons

    self:StripWeapons()

    for _, class in ipairs( weps ) do 
        self:Give( class, not Ambi.DarkRP.Config.jobs_default_ammo ) 
        self:GetWeapon( class ).cannot_drop = true
    end

    hook.Call( '[Ambi.DarkRP.PlayerLoadout]', nil, self, weps ) -- old
    hook.Call( '[Ambi.DarkRP.GaveWeaponsJob]', nil, self, weps, job ) -- new

    self.workaround_can_pickup_weapon = nil
end

function PLAYER:DemoteJob( bForce, eCaller )
    if not bForce then
        if not self:CanDemoteJob( eCaller ) then return false end

        return false
    end

    self:SetJob( Ambi.DarkRP.Config.jobs_class, true, false )

    hook.Call( '[Ambi.DarkRP.PlayerDemoted]', nil, eCaller, self, bForce ) -- old
    hook.Call( '[Ambi.DarkRP.DemotedJob]', nil, eCaller, self, bForce ) -- new

    return true
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:teamChange( anyID, bForce ) --* for compatiblity
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

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_darkrp_demote_player' )
net.Receive( 'ambi_darkrp_demote_player', function( _, ePly )
    if not ePly:GetDelay( 'AmbiDarkRPDemote' ) then ePly:SetDelay( 'AmbiDarkRPDemote', Ambi.DarkRP.Config.jobs_demote_delay ) else ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: ', C.ERROR, tostring( math.floor( timer.TimeLeft( 'AmbiDarkRPDemote['..ePly:SteamID()..']' ) ) ), C.ABS_WHITE, ' секунд' ) return end

    if not Ambi.DarkRP.Config.jobs_demote_enable then ePly:Kick( '[DarkRP] Попытка уволить игрока, когда система отключена!' ) return end
    if not Ambi.DarkRP.CanStartVote() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Сейчас нельзя сделать голосование!' ) return end

    local demoter = net.ReadEntity()
    if not IsValid( demoter ) or not demoter:IsPlayer() then ePly:Kick( '[DarkRP] Попытка уволить НЕ игрока!' ) return end
    if not Ambi.DarkRP.Config.jobs_demote_can_similar_job and ( ePly:Job() == demoter:Job() ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя уволить игрока с такой же работой, как у Вас!' ) return end
    if not ePly:CanDemoteJob( demoter, '' ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данного игрока нельзя уволить!' ) return end

    Ambi.DarkRP.StartVote( ePly:Nick()..' желает уволить '..demoter:Nick(), function() 
        if IsValid( demoter ) and IsValid( ePly ) then  
            ePly:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вы уволили ', C.AMBI, demoter:Nick(), C.ABS_WHITE,' с работы ', C.AMBI_BLUE, demoter:TeamName() )

            demoter:DemoteJob( true, ePly )
            demoter:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вас уволил ', C.AMBI, ePly:Nick() )
        end
    end, function() 
        if IsValid( ePly ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Голосование на увольнения провалилось!' ) end
    end, ePly )
end )