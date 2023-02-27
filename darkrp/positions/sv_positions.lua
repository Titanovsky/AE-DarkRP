local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local PLAYER = FindMetaTable( 'Player' )

local DB = SQL.CreateTable( 'darkrp2_positions_jobs', 'Class, Pos, Angle, Map' )
local DB_JAILS = SQL.CreateTable( 'darkrp2_positions_jail', 'Pos, Angle, Map' )

-- ---------------------------------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.AddJobPosition( sClass, vPos, aAng, sMap )
    local new_pos = tostring( math.floor( vPos.x )..' '..math.floor( vPos.y )..' '..math.floor( vPos.z ) )
    local new_ang = tostring( math.floor( aAng[ 1 ] )..' '..math.floor( aAng[ 2 ] )..' '..math.floor( aAng[ 3 ] ) )
    local map = sMap or game.GetMap()
    if ( hook.Call( '[Ambi.DarkRP.CanAddJobPosition]', nil, sClass, vPos, aAng, map ) == false ) then return false end

    SQL.Insert( DB, 'Class, Pos, Angle, Map', '%s, %s, %s, %s', sClass, new_pos, new_ang, map )

    hook.Call( '[Ambi.DarkRP.AddedJobPosition]', nil, sClass, vPos, aAng, map )
end

function Ambi.DarkRP.RemoveJobPosition( sClass, vPos, sMap )
    sMap = sMap or game.GetMap()
    if ( hook.Call( '[Ambi.DarkRP.CanRemoveJobPosition]', nil, sClass, vPos, sMap ) == false ) then return false end

    local new_pos = tostring( math.floor( vPos.x )..' '..math.floor( vPos.y )..' '..math.floor( vPos.z ) )
    new_pos = '\''..new_pos..'\''
    sClass = '\''..sClass..'\''
    sMap = '\''..sMap..'\''

    sql.Query( "DELETE FROM `"..DB.."` WHERE Class="..sClass.." AND Pos="..new_pos.." AND Map="..sMap )

    hook.Call( '[Ambi.DarkRP.RemovedJobPosition]', nil, sClass, vPos, sMap )
end

function Ambi.DarkRP.GetJobPositions( sClass )
    local job = Ambi.DarkRP.GetJob( sClass )
    if not job then return end

    local positions = {}
    local tab = SQL.SelectAll( DB )
    if not tab then return end

    for i, v in ipairs( tab ) do
        if ( v.Class != sClass ) then continue end

        local pos = string.Explode( ' ', v.Pos )
        pos = Vector( pos[ 1 ], pos[ 2 ], pos[ 3 ] )

        local ang = string.Explode( ' ', v.Angle )
        ang = Angle( ang[ 1 ], ang[ 2 ], ang[ 3 ] )

        positions[ #positions + 1 ] = { pos = pos, ang = ang, map = v.Map }
    end

    return positions
end

function Ambi.DarkRP.AddJailPosition( vPos, aAng, sMap )
    sMap = sMap or game.GetMap()
    if ( hook.Call( '[Ambi.DarkRP.CanAddJailPosition]', nil, vPos, aAng, sMap ) == false ) then return false end

    local new_pos = tostring( math.floor( vPos.x )..' '..math.floor( vPos.y )..' '..math.floor( vPos.z ) )
    local new_ang = tostring( math.floor( aAng[ 1 ] )..' '..math.floor( aAng[ 2 ] )..' '..math.floor( aAng[ 3 ] ) )
    
    SQL.Insert( DB_JAILS, 'Pos, Angle, Map', '%s, %s, %s', new_pos, new_ang, sMap )

    hook.Call( '[Ambi.DarkRP.AddedJailPosition]', nil, vPos, aAng, sMap )
end

function Ambi.DarkRP.RemoveJailPosition( vPos, sMap )
    sMap = sMap or game.GetMap()
    if ( hook.Call( '[Ambi.DarkRP.CanRemoveJailPosition]', nil, vPos, sMap ) == false ) then return false end

    local new_pos = tostring( math.floor( vPos.x )..' '..math.floor( vPos.y )..' '..math.floor( vPos.z ) )
    new_pos = '\''..new_pos..'\''
    sMap = '\''..sMap..'\''

    sql.Query( "DELETE FROM `"..DB_JAILS.."` WHERE Pos="..new_pos.." AND Map="..sMap )

    hook.Call( '[Ambi.DarkRP.RemovedJailPosition]', nil, vPos, sMap )
end

function Ambi.DarkRP.GetJailPositions( sMap )
    sMap = sMap or game.GetMap()

    local positions = {}
    local tab = SQL.SelectAll( DB_JAILS )
    if not tab then return end

    for i, v in ipairs( tab ) do
        if ( v.Map != sMap ) then continue end

        local pos = string.Explode( ' ', v.Pos )
        pos = Vector( pos[ 1 ], pos[ 2 ], pos[ 3 ] )

        local ang = string.Explode( ' ', v.Angle )
        ang = Angle( ang[ 1 ], ang[ 2 ], ang[ 3 ] )

        positions[ i ] = { pos = pos, ang = ang, map = sMap }
    end

    return positions
end