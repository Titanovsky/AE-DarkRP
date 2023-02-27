Ambi.DarkRP.job_temp_created_by_maker = Ambi.DarkRP.job_temp_created_by_maker or {}

local C, JSON = Ambi.Packages.Out( 'colors, json' )

file.CreateDir( 'ambi/darkrp/jobs' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function Kick( ePly, sReason )
    if not Ambi.DarkRP.Config.jobs_maker_kick_cheaters then return end

    ePly:Kick( '[DarkRP] '..sReason )
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function SyncJob( sClass, tJob, ePly )
    net.Start( 'ambi_darkrp_job_maker_sync' )
        net.WriteString( sClass )
        net.WriteTable( tJob )
    if ePly then net.Send( ePly ) else net.Broadcast() end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.JobMakerSync', function( ePly )
    if not Ambi.DarkRP.Config.jobs_maker_enable then return end

    timer.Simple( Ambi.DarkRP.Config.jobs_maker_delay, function()
        for class, job in pairs( Ambi.DarkRP.job_temp_created_by_maker ) do -- for Temp jobs
            SyncJob( class, job, ePly )
        end

        for _, name in ipairs( file.Find( 'ambi/darkrp/jobs/*', 'DATA' ) ) do -- for Saved jobs
            local job = JSON.Out( file.Read( 'ambi/darkrp/jobs/'..name, 'DATA' ) )
            local class = string.Explode( '.', name )[ 1 ]

            SyncJob( class, job, ePly )
        end
    end )
end )

hook.Add( 'PostGamemodeLoaded', 'Ambi.DarkRP.SetJobsByJobMaker', function() 
    if not Ambi.DarkRP.Config.jobs_maker_enable then return end

    print( '[DarkRP] Making saved jobs from ambi/darkrp/jobs...' )
    for _, name in ipairs( file.Find( 'ambi/darkrp/jobs/*', 'DATA' ) ) do 
        local job = JSON.Out( file.Read( 'ambi/darkrp/jobs/'..name, 'DATA' ) )
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

    print( '[DarkRP] Start the make/update job with Job Maker: '..class )

    local job = Ambi.DarkRP.GetJob( class )
    if job and not job.created_by_maker then
        tab.created_by_maker = nil

        for k, v in pairs( tab ) do
            job[ k ] = v -- update for job
        end

        print( '[DarkRP] Updated the non-saved job: '..class )

        for k, v in pairs( job ) do
            if isfunction( v ) then job[ k ] = nil end -- remove functiones for send to clients (network can't to work with function)
        end

        Ambi.DarkRP.job_temp_created_by_maker[ class ] = job
    else
        local json = JSON.In( tab ) 
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