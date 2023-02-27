Ambi.DarkRP.jobs = Ambi.DarkRP.jobs or {}
Ambi.DarkRP.jobs_commands = Ambi.DarkRP.jobs_commands or {}

local Gen, C = Ambi.Packages.Out( 'general, colors' )
local PLAYER = FindMetaTable( 'Player' )

local DEFAULT_JOB = {
    class = 'default',
    command = '',
    name = '...',
    category = 'Other',
    description = 'Not a job!',
    max = 0,
    salary = 0,
    vote = 0,
    admin = 0,
    color = Color( 0, 0, 0 ),
    weapons = {},
    models = 'models/player/kleiner.mdl',
    license = false,
    demote = false,
    order = 0,
    index = 1001,
    is_fake = true
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:GetJob()
    for class, job in pairs( Ambi.DarkRP.GetJobs() ) do
        if ( job.index == self:Team() ) then return class end
    end

    return '' -- for correct key of table
end

function PLAYER:GetJobTable()
    return Ambi.DarkRP.GetJob( self:Job() ) or DEFAULT_JOB
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

function PLAYER:GetJobColor()
    return self:GetJobTable().color
end

function PLAYER:JobName()
    return self.nw_JobName or team.GetName( self:Team() )
end

function PLAYER:JobColor()
    return self:GetJobColor()
end

function PLAYER:TeamName()
    return self.nw_JobName or team.GetName( self:Team() )
end

function PLAYER:CanDemoteJob( eCaller, sReason )
    local job = self:GetJobTable()
    if not job then return false end
    if ( job.demote == false ) then return false end
    if ( self:GetJob() == Ambi.DarkRP.Config.jobs_class ) then return false end
    if ( hook.Call( '[Ambi.DarkRP.CanDemote]', nil, eCaller, self, sReason ) == false ) then return false end -- old
    if ( hook.Call( '[Ambi.DarkRP.CanDemoteJob]', nil, eCaller, self, sReason ) == false ) then return false end -- new

    return true
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
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

    hook.Call( '[Ambi.DarkRP.PostFillEmptyPropertiesJobs]', nil, tJob )

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

    if ( hook.Call( '[Ambi.DarkRP.CheckPropertiesJobs]', nil, tJob ) == false ) then return false end

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
    if ( hook.Call( '[Ambi.DarkRP.CanSetCompatibilityWithDarkRPOldJobs]', nil, tJob ) == false ) then return end

    setmetatable( tJob, {
        __index = function( self, anyKey )
            local comp_key = compatibility_keys[ anyKey ]
            if comp_key then return tJob[ comp_key ] end
        end
    } )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.AddJob( sClass, tJob )
    if not sClass or not tJob then Gen.Error( 'DarkRP', 'AddJob | Didn\'t select sClass or tJob!' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanAddJob]', nil, sClass, tJob ) == false ) then return end
    
    local job = FillEmptyProperties( tJob )
    if not CheckProperties( job ) then Gen.Error( 'DarkRP', 'AddJob | CheckProperties the job == false' ) return end
    SetCompatibilityWithDarkRPOld( tJob )

    local word = Ambi.DarkRP.GetJob( sClass ) and 'Updated' or 'Created'

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
    team.GetAllTeams()[ index ] = job

    for k, class in pairs( Ambi.DarkRP.jobs_commands ) do
        if ( class == sClass ) then Ambi.DarkRP.jobs_commands[ k ] = nil break end
    end
    
    Ambi.DarkRP.jobs_commands[ '/'..job.command ] = sClass 

    _G[ sClass ] = index
    
    print( '[DarkRP] '..word..' job: '..sClass..' ['..index..']' )

    hook.Call( '[Ambi.DarkRP.AddedJob]', nil, sClass, job )

    return index
end

function Ambi.DarkRP.RemoveJob( sClass )
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job then Gen.Error( 'DarkRP', 'RemoveJob | Didn\'t select sClass' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanRemoveJob]', nil, sClass, job ) == false ) then return end

    local index = job.index

    Ambi.DarkRP.jobs_commands[ '/'..job.command ] = nil

    Ambi.DarkRP.jobs[ sClass ] = nil
    _G[ sClass ] = nil
    team.GetAllTeams()[ index ] = nil

    print( '[DarkRP] Removed job: '..sClass..' ['..index..']' )

    hook.Call( '[Ambi.DarkRP.RemovedJob]', nil, sClass, job )
end

function Ambi.DarkRP.SimpleAddJob( sClass, sName, sCommand, sCategory, sDescription, nMax, nSalary, bVote, bLicense, bDemote, cColor, tModels, tWeapons, tOther )
    if not sClass then Gen.Error( 'DarkRP', 'SimpleAddJob | Didn\'t select sClass' ) return end
    
    local tab = {
        name = sName,
        command = sCommand,
        category = sCategory,
        description = sDescription,
        max = nMax,
        salary = nSalary,
        vote = bVote,
        license = bLicense,
        demote = bDemote,
        color = cColor,
        models = tModels,
        weapons = tWeapons,
    }

    if tOther then
        for key, value in pairs( tOther ) do
            tab[ key ] = value
        end
    end

    return Ambi.DarkRP.AddJob( sClass, tab )
end

function Ambi.DarkRP.AddJobTable( tJob )
    if not tJob or not istable( tJob ) then Gen.Error( 'DarkRP', 'AddJobTable | Didn\'t select tJob or it\'s not a table' )  return end

    local class = tJob.class
    if not class then Gen.Error( 'DarkRP', 'AddJobTable | Didn\'t have class in a table' )  return end

    return Ambi.DarkRP.AddJob( class, tJob )
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