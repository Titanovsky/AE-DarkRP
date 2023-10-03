Ambi.DarkRP.job_temp_created_by_maker = Ambi.DarkRP.job_temp_created_by_maker or {}

local C, JSON = Ambi.Packages.Out( 'colors, json' )

file.CreateDir( 'ambi/darkrp/jobs' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function Kick( ePly, sReason )
    if not Ambi.DarkRP.Config.jobs_maker_kick_cheaters then return end

    ePly:Kick( '[DarkRP] '..sReason )
end

local function SyncJob( sClass, tJob, ePly )
    net.Start( 'ambi_darkrp_job_maker_sync' )
        net.WriteString( sClass )
        net.WriteTable( tJob )
    if ePly then net.Send( ePly ) else net.Broadcast() end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.IsJobByMaker( sClass )
    local job = Ambi.DarkRP.GetJob( sClass or '' ) 
    if not job then return end

    return job.created_by_maker
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.JobMakerSync', function( ePly )
    if not Ambi.DarkRP.Config.jobs_maker_enable then return end
    if ePly:IsBot() then return end

    timer.Simple( Ambi.DarkRP.Config.jobs_maker_delay, function()
        for class, job in pairs( Ambi.DarkRP.GetJobs() ) do -- for Temp jobs
            if not job.created_by_maker then continue end
            
            SyncJob( class, job, ePly )
        end
    end )
end )

hook.Add( 'PostGamemodeLoaded', 'Ambi.DarkRP.SetJobsByJobMaker', function() 
    if not Ambi.DarkRP.Config.jobs_maker_enable then return end

    print( '[DarkRP] Making saved jobs from ambi/darkrp/jobs...' )
    for _, name in ipairs( file.Find( 'ambi/darkrp/jobs/*', 'DATA' ) ) do 
        local job = JSON.Deserialize( file.Read( 'ambi/darkrp/jobs/'..name, 'DATA' ) )
        local class = string.Explode( '.', name )[ 1 ]

        Ambi.DarkRP.AddJob( class, job )
    end
    print( '[DarkRP] The process to make saved jobs is end' )
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_darkrp_job_maker_sync' )

net.AddString( 'ambi_darkrp_job_maker_create' )
net.Receive( 'ambi_darkrp_job_maker_create', function( _, ePly ) 
    if not Ambi.DarkRP.Config.jobs_maker_enable then Kick( ePly, 'Попытка воспользоваться отключенным Job Maker' ) return end
    if not Ambi.DarkRP.Config.jobs_maker_usergroups[ ePly:GetUserGroup() ] then Kick( ePly, 'Попытка воспользоваться Job Maker без прав' ) return end

    local class, tab = net.ReadString(), net.ReadTable()
    tab.created_by_maker = true
    tab.class = class

    local job = Ambi.DarkRP.GetJob( class )
    if job and not job.created_by_maker then return end

    print( '[DarkRP] Start the make/update job with Job Maker: '..class )

    if job then
        for k, v in pairs( tab ) do
            job[ k ] = v -- update for job
        end

        print( '[DarkRP] Updated the saved job: '..class )

        for k, v in pairs( job ) do
            if isfunction( v ) or IsEntity( v ) then job[ k ] = nil end -- remove functiones & entities for send to clients (network can't work with function)
        end

        Ambi.DarkRP.job_temp_created_by_maker[ class ] = job
    else
        local json = JSON.Serialize( tab ) 
        file.Write( 'ambi/darkrp/jobs/'..class..'.json', json )

        if not file.Exists( 'ambi/darkrp/jobs/'..class..'.json', 'DATA' ) then 
            ePly:ChatSend( '~RED~ • ~WHITE~ Не получилось создать файл с классом: ~RED~ '..class ) 
            print( '[DarkRP] Failed to make file with name '..class..'.json, maybe wrong name of class!' )

            return 
        end

        if ( file.Size( 'ambi/darkrp/jobs/'..class..'.json', 'DATA' ) <= 0 ) then 
            ePly:ChatSend( '~RED~ • ~WHITE~ Файл был создан, но в ничего не записалось!' ) 
            print( '[DarkRP] File has maked, but it\'s empty!' )
            
            return 
        end

        Ambi.DarkRP.AddJob( class, tab )

        job = tab -- for SyncJob( class, job )

        ePly:ChatSend( '~GREEN~ • ~WHITE~ Файл с классом ~GREEN~ '..class..' ~WHITE~ был записан успешно!' ) 
    end

    print( '[DarkRP] Job maked/updated, save for table or file and ready to sync with clients' )

    SyncJob( class, job )
end )

net.AddString( 'ambi_darkrp_job_maker_remove' )
net.AddString( 'ambi_darkrp_job_maker_remove_sync' )
net.Receive( 'ambi_darkrp_job_maker_remove', function( _, ePly ) 
    if not Ambi.DarkRP.Config.jobs_maker_enable then Kick( ePly, 'Попытка воспользоваться отключенным Job Maker' ) return end
    if not Ambi.DarkRP.Config.jobs_maker_usergroups[ ePly:GetUserGroup() ] then Kick( ePly, 'Попытка воспользоваться Job Maker без прав' ) return end

    local class = net.ReadString()
    local job = Ambi.DarkRP.GetJob( class )
    if not job or not job.created_by_maker then return end

    for _, ply in ipairs( player.GetAll() ) do
        if ( ply:GetJob() ~= class ) then continue end

        ply:SetJob( Ambi.DarkRP.Config.jobs_class, true )
        ply:ChatSend( '~R~ Вашу работу удалили!' )
    end

    local l_class = class:lower()
    if file.Exists( 'ambi/darkrp/jobs/'..l_class..'.json', 'DATA' ) then
        file.Delete( 'ambi/darkrp/jobs/'..l_class..'.json', 'DATA' )
    end

    Ambi.DarkRP.RemoveJob( class )

    print( '[DarkRP] Job removed and sync with clients' )

    net.Start( 'ambi_darkrp_job_maker_remove_sync' )
        net.WriteString( class )
    net.Broadcast()
end )