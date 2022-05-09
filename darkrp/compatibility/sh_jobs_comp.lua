RPExtraTeams = RPExtraTeams or {}
local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
function PLAYER:changeTeam( nTeam, bForce )
    return self:SetJob( Ambi.DarkRP.GetJobByIndex( nTeam ).class, bForce )
end

PLAYER.updateJob = function() end

function PLAYER:teamBan( nTeam, nTime )
    return self:BlockJob( Ambi.DarkRP.GetJobByIndex( nTeam ).class, nTime )
end

function PLAYER:teamUnBan( nTeam )
    return self:UnBlockJob( Ambi.DarkRP.GetJobByIndex( nTeam ).class )
end

function PLAYER:teamBanTimeLeft() return 0 end
function PLAYER:changeAllowed() return true end

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PostGamemodeLoaded', 'Ambi.DarkRP.SetStandartTeamToJobs', function()
    timer.Simple( 1, function()
        for i, v in ipairs( team.GetAllTeams() ) do
            v.description = v.description or '' -- Описание должно быть всегда при созданой профе
        end
    end )
end )

hook.Add( '[Ambi.DarkRP.AddedJob]', 'Ambi.DarkRP.CompatibilityJobs', function( sClass, tJob ) 
    if not Ambi.DarkRP.compatibility_jobs then return end

    RPExtraTeams[ tJob.index ] = tJob
end )

hook.Add( '[Ambi.DarkRP.RemovedJob]', 'Ambi.DarkRP.CompatibilityJobs', function( sClass, tJob ) 
    if not Ambi.DarkRP.compatibility_jobs then return end

    RPExtraTeams[ tJob.index ] = nil
end )

hook.Add( '[Ambi.DarkRP.CanDemote]', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, eTarget ) 
    if not Ambi.DarkRP.compatibility_jobs then return end

    if ( hook.Call( 'canDemote', nil, ePly, eTarget, '' ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.PlayerDemoted]', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, eTarget, bForce ) 
    if not Ambi.DarkRP.compatibility_jobs then return end

    if ( hook.Call( 'onPlayerDemoted', nil, ePly, eTarget, '' ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanChangeJob]', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, sClass, bForce ) 
    if Ambi.DarkRP.compatibility_jobs then
        local can, reason = hook.Call( 'playerCanChangeTeam', nil, ePly, Ambi.DarkRP.GetJob( sClass ).index, bForce )
        if ( can == false ) then ePly:ChatPrint( reason or '' ) return false end

        local can, reason, _ = hook.Call( 'canChangeJob', nil, ePly, Ambi.DarkRP.GetJob( sClass ).command )
        if ( can == false ) then ePly:ChatPrint( reason or '' ) return false end
    end
end )

hook.Add( 'PlayerSay', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, sText ) 
    if not Ambi.DarkRP.compatibility_jobs then return end

    if string.StartWith( sText, '/vote' ) then 
        local text = string.Trim( sText )
        text = string.sub( text, 6, #text )

        ePly:Say( '/'..text )

        return ''
    end
end )

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
function DarkRP.createJob( sName, tJob )
    if not Ambi.DarkRP.compatibility_jobs then return end
    if not sName or not tJob then return end

    local tab = table.Merge( tJob, { name = sName } )

    return Ambi.DarkRP.AddJob( sName, tJob )
end
