local Gen = Ambi.General
local PLAYER, C = FindMetaTable( 'Player' ), Ambi.General.Global.Colors

Ambi.DarkRP.jobs = Ambi.DarkRP.jobs or {}

-- ================= Player =========================================================================== --
function PLAYER:GetJob()
    for class, job in pairs( Ambi.DarkRP.GetJobs() ) do
        if ( job.index == self:Team() ) then return class end
    end

    return ''
end

function PLAYER:GetJobTable()
    return Ambi.DarkRP.GetJob( self:Job() )
end

function PLAYER:Job()
    return self:GetJob()
end

function PLAYER:JobIndex()
    return self:GetJobTable().index
end

function PLAYER:JobID()
    return self:JobIndex()
end

function PLAYER:IsJob( sClass )
    return ( self:GetJob() == sClass )
end

function PLAYER:GetJobName()
    return self.nw_JobName or team.GetName( self:Team() )
end

function PLAYER:JobName()
    return self.nw_JobName or team.GetName( self:Team() )
end

function PLAYER:TeamName()
    return self.nw_JobName or team.GetName( self:Team() )
end

function PLAYER:CanDemoteJob( ePly, sReason )
    local job = self:GetJobTable()
    if not job then return false end
    if ( job.demote == false ) then return false end
    if ( self:GetJob() == Ambi.DarkRP.Config.jobs_class ) then return false end
    if ( hook.Call( '[Ambi.DarkRP.CanDemote]', nil, ePly, self, sReason ) == false ) then return false end

    return true
end

-- ================= Core ============================================================================= --
local function FillEmptyProperties( tJob )
    local default = Ambi.DarkRP.Config.jobs_default

    tJob.name           = tJob.name or default.name
    tJob.command        = tJob.command or default.command
    tJob.category       = tJob.category or default.category
    tJob.description    = tJob.description or default.description
    tJob.max            = tJob.max or default.max
    tJob.salary         = tJob.salary or default.salary
    tJob.admin          = tJob.admin or default.admin
    tJob.vote           = tJob.vote or default.vote
    tJob.color          = tJob.color or default.color
    tJob.weapons        = tJob.weapons or default.weapons
    tJob.models         = ( tJob.models or tJob.model ) or default.models
    tJob.license        = ( tJob.license or tJob.hasLicense ) or default.license
    tJob.demote         = tJob.demote or default.demote
    tJob.order          = ( tJob.order or tJob.sortOrder ) or default.order

    return tJob 
end

local function CheckProperties( tJob )
    if not tJob then Gen.Error( 'DarkRP', 'This is job is not valid!' ) return false
    elseif not tJob.name then Gen.Error( 'DarkRP', 'Job name is not selected!' ) return false
    elseif not tJob.command then Gen.Error( 'DarkRP', 'Job command is not selected!' ) return false
    elseif not tJob.category then Gen.Error( 'DarkRP', 'Job category is not selected!' ) return false
    elseif not tJob.description then Gen.Error( 'DarkRP', 'Job description is not selected!' ) return false
    elseif not tJob.max then Gen.Error( 'DarkRP', 'Job max is not selected!' ) return false
    elseif not tJob.salary then Gen.Error( 'DarkRP', 'Job salary is not selected!' ) return false
    elseif not tJob.admin then Gen.Error( 'DarkRP', 'Job admin is not selected!' ) return false
    elseif not tJob.order then Gen.Error( 'DarkRP', 'Job order is not selected!' ) return false
    elseif ( tJob.vote == nil ) then Gen.Error( 'DarkRP', 'Job vote is not selected!' ) return false
    elseif ( tJob.license == nil ) then Gen.Error( 'DarkRP', 'Job license is not selected!' ) return false
    elseif ( tJob.demote == nil ) then Gen.Error( 'DarkRP', 'Job demote is not selected!' ) return false
    elseif not tJob.color then Gen.Error( 'DarkRP', 'Job color is not selected!' ) return false
    elseif not tJob.weapons then Gen.Error( 'DarkRP', 'Job weapons is not selected!' ) return false
    elseif not tJob.models then Gen.Error( 'DarkRP', 'Job models is not selected!' ) return false
    end

    if tJob.model then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "model", only: "models"' ) 
        tJob.model = nil
    end

    if tJob.canDemote then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "canDemote", only: "demote"' ) 
        tJob.demote = tJob.canDemote
        tJob.canDemote = nil
    end

    if tJob.candemote then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "candemote", only: "demote"' ) 
        tJob.demote = tJob.candemote
        tJob.candemote = nil
    end

    if tJob.NeedToChangeFrom then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "NeedToChangeFrom", only: "from"' ) 
        tJob.from = tJob.NeedToChangeFrom
        tJob.NeedToChangeFrom = nil
    end

    if tJob.hasLicense then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "hasLicense", only: "license"' ) 
        tJob.license = tJob.hasLicense
        tJob.hasLicense = nil
    end

    if tJob.sortOrder then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "sortOrder", only: "order"' ) 
        tJob.order = tJob.sortOrder
        tJob.sortOrder = nil
    end

    if tJob.customCheck then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "customCheck", only: "CustomCheck"' ) 
        tJob.CustomCheck = tJob.customCheck
        tJob.customCheck = nil
    end

    if tJob.canStartVote then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "canStartVote", only: "CanStartVote"' ) 
        tJob.CanStartVote = tJob.canStartVote
        tJob.canStartVote = nil
    end

    if tJob.canStartVoteReason then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "canStartVoteReason", only: "CanStartVoteReason"' ) 
        tJob.CanStartVoteReason = tJob.canStartVoteReason
        tJob.canStartVoteReason = nil
    end

    if tJob.modelScale then 
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "modelScale", only: "model_scale"' ) 
        tJob.model_scale = tJob.modelScale
        tJob.modelScale = nil
    end

    if tJob.OnPlayerChangedTeam then
        Gen.Warning( 'DarkRP', 'Ambi DarkRP don\'t support name "OnPlayerChangedTeam", only: "PlayerChangedTeam"' ) 
        tJob.PlayerChangedTeam = tJob.OnPlayerChangedTeam
        tJob.OnPlayerChangedTeam = nil
    end

    if tJob.CustomCheckFailMsg and isstring( tJob.CustomCheckFailMsg ) then 
        Gen.Warning( 'DarkRP', 'tJob.CustomCheckFailMsg it was a string, now it converting to function' ) 
        
        local msg = tJob.CustomCheckFailMsg
        tJob.CustomCheckFailMsg = function( ePly, tJob ) return msg end
    end

    if isstring( tJob.weapons ) then 
        Gen.Warning( 'DarkRP', 'tJob.weapons it was a string, now it converting to table' ) 
        local weapon = tJob.weapons

        tJob.weapons = { weapon }
    end

    if isstring( tJob.models ) then 
        Gen.Warning( 'DarkRP', 'tJob.models it was a string, now it converting to table' ) 
        local model = tJob.models

        tJob.models = { model }
    end

    return true
end

local compatibility_keys = {
    [ 'sortOrder' ] = 'order',
    [ 'canDemote' ] = 'demote',
    [ 'candemote' ] = 'demote',
    [ 'hasLicense' ] = 'license',
    [ 'model' ] = 'models',
    [ 'team' ] = 'index',
    [ 'NeedToChangeFrom' ] = 'from',
    [ 'customCheck' ] = 'CustomCheck',
    [ 'canStartVote' ] = 'CanStartVote',
    [ 'canStartVoteReason' ] = 'CanStartVoteReason',
    [ 'OnPlayerChangedTeam' ] = 'PlayerChangedTeam',
}
local function SetCompatibilityWithDarkRPOld( tJob )
    setmetatable( tJob, {
        __index = function( self, anyKey )
            local comp_key = compatibility_keys[ anyKey ]
            if comp_key then return tJob[ comp_key ] end
        end
    } )
end

function Ambi.DarkRP.AddJob( sClass, tJob )
    if not sClass or not tJob then Gen.Error( 'DarkRP', 'AddJob | Not selected sClass or tJob!' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanAddJob]', nil, sClass, tJob ) == false ) then return end
    
    local job = FillEmptyProperties( tJob )
    if not CheckProperties( job ) then Gen.Error( 'DarkRP', 'AddJob | CheckProperties the job == false' ) return end
    SetCompatibilityWithDarkRPOld( tJob )

    local count = 0
    for _, v in pairs( team.GetAllTeams() ) do count = count + 1 end

    local len = count + 9 + 1 -- чтобы не было 1, 2, 3 и 4
    local index = nil
    for id, team in pairs( Ambi.DarkRP.jobs ) do
        if ( sClass == id ) and team.index then index = team.index end
    end
    if not index then 
        team.SetUp( len, job.name, job.color ) 
        index = len
    end

    job.index = index
    job.Name = job.name
    job.Color = job.color
    job.class = sClass

    Ambi.DarkRP.jobs[ sClass ] = job
    table.Merge( team.GetAllTeams()[ index ], job )

    if Ambi.ChatCommands then 
        Ambi.ChatCommands.AddCommand( job.command, 'DarkRP | Jobs', 'Получить работу: '..job.name, 1, function( ePly, tArgs ) 
            if not Ambi.DarkRP.Config.jobs_change_on_chat_command then return end

            return ePly:SetJob( sClass )
        end )
    end

    _G[ sClass ] = index
    
    print( '[DarkRP] Created job: '..sClass..' ['..index..']' )

    hook.Call( '[Ambi.DarkRP.AddedJob]', nil, sClass, tJob )

    return index
end

function Ambi.DarkRP.RemoveJob( sClass )
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job then return end

    local index = job.index

    Ambi.ChatCommands.RemoveCommand( job.command )

    Ambi.DarkRP.jobs[ sClass ] = nil
    _G[ sClass ] = nil
    team.GetAllTeams()[ index ] = nil

    print( '[DarkRP] Removed job: '..sClass..' ['..index..']' )

    hook.Call( '[Ambi.DarkRP.RemovedJob]', nil, sClass, job )
end

function Ambi.DarkRP.GetJobs()
    return Ambi.DarkRP.jobs
end

function Ambi.DarkRP.GetJobByIndex( nID )
    for _, v in pairs( Ambi.DarkRP.GetJobs() ) do
        if ( v.index == nID ) then return v end
    end
end

function Ambi.DarkRP.GetJob( anyClass )
    if not anyClass then return end

    return isnumber( anyClass ) and Ambi.DarkRP.GetJobByIndex( anyClass ) or Ambi.DarkRP.jobs[ anyClass ]
end

function Ambi.DarkRP.PrintJobs()
    local jobs = Ambi.DarkRP.jobs

    print('\n')
    for class, job in SortedPairsByMemberValue( jobs, 'index' ) do
        MsgC( C.ABS_WHITE, job.index..':  ', job.color, job.name, C.ABS_WHITE, ' — '..job.description )
    end
    print('\n')
end

function Ambi.DarkRP.GetJobPlayersCount( sClass )
    if not Ambi.DarkRP.GetJob( sClass ) then return 0 end

    local count = 0 
    for _, v in ipairs( player.GetAll() ) do 
        if v:IsJob( sClass ) then count = count + 1 end
    end

    return count
end

-- ================= Defaults ========================================================================= --
if not Ambi.DarkRP.Config.jobs_create_defaults then return end

local Add = Ambi.DarkRP.AddJob

local MODELS_CITIZEN = {
    'models/player/Group01/male_07.mdl',
    'models/player/Group01/male_02.mdl',
    'models/player/Group01/male_01.mdl', 
    'models/player/Group01/male_03.mdl', 
    'models/player/Group01/male_04.mdl', 
    'models/player/Group01/male_05.mdl', 
    'models/player/Group01/male_06.mdl', 
    'models/player/Group01/male_08.mdl',
    'models/player/Group01/male_09.mdl',

    'models/player/Group01/female_01.mdl',
    'models/player/Group01/female_02.mdl',
    'models/player/Group01/female_03.mdl',
    'models/player/Group01/female_04.mdl',
    'models/player/Group01/female_05.mdl',
    'models/player/Group01/female_06.mdl'
}

local MODELS_MEDICS = {
    'models/player/Group03m/male_07.mdl',
    'models/player/Group03m/male_02.mdl', 
    'models/player/Group03m/male_01.mdl',
    'models/player/Group03m/male_03.mdl', 
    'models/player/Group03m/male_04.mdl', 
    'models/player/Group03m/male_05.mdl', 
    'models/player/Group03m/male_06.mdl', 
    'models/player/Group03m/male_08.mdl', 
    'models/player/Group03m/male_09.mdl', 

    'models/player/Group03m/female_01.mdl', 
    'models/player/Group03m/female_02.mdl', 
    'models/player/Group03m/female_03.mdl', 
    'models/player/Group03m/female_04.mdl', 
    'models/player/Group03m/female_05.mdl',
    'models/player/Group03m/female_06.mdl', 
}

local MODELS_GANGSTERS = {
    'models/player/Group03/male_07.mdl',
    'models/player/Group03/male_02.mdl',
    'models/player/Group03/male_01.mdl', 
    'models/player/Group03/male_03.mdl', 
    'models/player/Group03/male_04.mdl', 
    'models/player/Group03/male_05.mdl', 
    'models/player/Group03/male_06.mdl', 
    'models/player/Group03/male_08.mdl',
    'models/player/Group03/male_09.mdl',

    'models/player/Group03/female_01.mdl',
    'models/player/Group03/female_02.mdl',
    'models/player/Group03/female_03.mdl',
    'models/player/Group03/female_04.mdl',
    'models/player/Group03/female_05.mdl',
    'models/player/Group03/female_06.mdl'
}

local MODELS_SWAT = {
    'models/player/swat.mdl',
    'models/player/urban.mdl',
    'models/player/gasmask.mdl',
    'models/player/riot.mdl',
}

local WEAPONS_POLICE = {
    'arrest_stick',
    'unarrest_stick',
    'stunstick',
    'weapon_pistol',
}

local WEAPONS_SWAT = {
    'arrest_stick',
    'unarrest_stick',
    'stunstick',
    'door_ram',
    'weapon_pistol',
    'weapon_smg1',
}

local WEAPONS_SHERIFF = {
    'arrest_stick',
    'unarrest_stick',
    'stunstick',
    'door_ram',
    'weapon_357',
    'weapon_smg1',
    'weapon_shotgun',
}

local WEAPONS_MAYOR = {
    'unarrest_stick',
    'stunstick',
}

local WEAPONS_MEDIC = {
    'med_kit'
}

hook.Add( 'InitPostEntity', 'Ambi.DarkRP.AddDefaultsJobs', function()
    Add( 'TEAM_CITIZEN', { 
        name = 'Житель', 
        command = 'citizen', 
        models = MODELS_CITIZEN,
        max = 0,
        category = 'Жители', 
        color = C.AMBI_GREEN,
    } )

    Add( 'TEAM_MEDIC', { 
        name = 'Врач', 
        command = 'medic', 
        max = 4,
        category = 'Жители', 
        models = MODELS_MEDICS,
        weapons = WEAPONS_MEDIC,
        demote = true,
        color = C.RU_PINK,
    } )

    Ambi.DarkRP.AddJob( 'TEAM_POLICE', { 
        name = 'Полицейский', 
        command = 'police', 
        category = 'Полиция', 
        description = 'Сотрудник правопорядка', 
        color = C.AMBI_BLUE, 
        police = true,
        weapons = WEAPONS_POLICE, 
        demote = true,
        vote = true,
        models = { 'models/player/police.mdl', 'models/player/police_fem.mdl' } 
    } )

    Ambi.DarkRP.AddJob( 'TEAM_SWAT', { 
        name = 'Спецназ', 
        command = 'swat', 
        category = 'Полиция', 
        description = 'Отряд Специального Назначения, подчиняется Шерифу', 
        from = 'TEAM_POLICE',
        color = C.AMBI_BLUE, 
        police = true,
        weapons = WEAPONS_SWAT, 
        demote = true,
        models = MODELS_SWAT,
    } )

    Ambi.DarkRP.AddJob( 'TEAM_SHERIFF', { 
        name = 'Шериф', 
        command = 'sheriff', 
        category = 'Полиция', 
        description = 'Шериф города. Полностью руководит Полицейским Участком', 
        color = C.AMBI_HARD_BLUE, 
        police = true,
        weapons = WEAPONS_SHERIFF, 
        max = 1,
        vote = true,
        demote = true,
        models = { 'models/player/barney.mdl' },
    } )

    Ambi.DarkRP.AddJob( 'TEAM_GUNDEALER', { 
        name = 'Продавец Оружия', 
        command = 'gundealer', 
        category = 'Жители', 
        description = 'Житель города, но имеющий право продавать оружие', 
        color = C.AMBI_CARROT, 
        max = 4,
        demote = true,
        models = { 'models/player/monk.mdl' },
    } )

    Ambi.DarkRP.AddJob( 'TEAM_BUSINESSMAN', { 
        name = 'Предприниматель', 
        command = 'businessman', 
        category = 'Жители', 
        description = 'Житель города, способный покупать больше дверей', 
        color = C.AMBI_SALAT, 
        max = 4,
        doors_max = 10,
        models = { 'models/player/magnusson.mdl' },
    } )

    Ambi.DarkRP.AddJob( 'TEAM_GANGSTER', { 
        name = 'Бандит', 
        command = 'gangster', 
        category = 'Криминал', 
        description = 'Самый низкоранговый бандит. Нарушает закон в одиночку, либо с группой', 
        color = C.FLAT_GRAY, 
        weapons = { 'lockpick' },
        models = MODELS_GANGSTERS,
    } )

    Ambi.DarkRP.AddJob( 'TEAM_MAYOR', { 
        name = 'Мэр', 
        command = 'mayor', 
        category = 'Мэрия', 
        description = 'Администратор города: управляет полицией', 
        color = C.FLAT_DARK_RED, 
        max = 1, 
        demote_after_death = true, 
        mayor = true,
        weapons = WEAPONS_MAYOR,
        vote = true,
        models = { 'models/player/breen.mdl', 'models/player/mossman_arctic.mdl' },
    } )
end )