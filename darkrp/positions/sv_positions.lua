local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local PLAYER = FindMetaTable( 'Player' )

-- --------------------------------------------------------------------------------------------------
local DB = SQL.CreateTable( 'darkrp_alt_positions_jobs', 'Class, Pos, Angle, Map' )

function Ambi.DarkRP.AddJobPosition( sClass, vPos, aAng, sMap )
    local new_pos = tostring( math.floor( vPos.x )..' '..math.floor( vPos.y )..' '..math.floor( vPos.z ) )
    local new_ang = tostring( math.floor( aAng[ 1 ] )..' '..math.floor( aAng[ 2 ] )..' '..math.floor( aAng[ 3 ] ) )
    
    SQL.Insert( DB, 'Class, Pos, Angle, Map', '%s, %s, %s, %s', sClass, new_pos, new_ang, sMap or game.GetMap() )
end

function Ambi.DarkRP.RemoveJobPosition( sClass, vPos, sMap )
    sMap = sMap or game.GetMap()

    local new_pos = tostring( math.floor( vPos.x )..' '..math.floor( vPos.y )..' '..math.floor( vPos.z ) )
    new_pos = '\''..new_pos..'\''
    sClass = '\''..sClass..'\''
    sMap = '\''..sMap..'\''

    sql.Query( "DELETE FROM `"..DB.."` WHERE Class="..sClass.." AND Pos="..new_pos.." AND Map="..sMap )
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

-- --------------------------------------------------------------------------------------------------
local DB = SQL.CreateTable( 'darkrp_alt_positions_jail', 'Pos, Angle, Map' )

function Ambi.DarkRP.AddJailPosition( vPos, aAng, sMap )
    sMap = sMap or game.GetMap()

    local new_pos = tostring( math.floor( vPos.x )..' '..math.floor( vPos.y )..' '..math.floor( vPos.z ) )
    local new_ang = tostring( math.floor( aAng[ 1 ] )..' '..math.floor( aAng[ 2 ] )..' '..math.floor( aAng[ 3 ] ) )
    
    SQL.Insert( DB, 'Pos, Angle, Map', '%s, %s, %s', new_pos, new_ang, sMap )
end

function Ambi.DarkRP.RemoveJailPosition( vPos, sMap )
    sMap = sMap or game.GetMap()

    local new_pos = tostring( math.floor( vPos.x )..' '..math.floor( vPos.y )..' '..math.floor( vPos.z ) )
    new_pos = '\''..new_pos..'\''
    sMap = '\''..sMap..'\''

    sql.Query( "DELETE FROM `"..DB.."` WHERE Pos="..new_pos.." AND Map="..sMap )
end

function Ambi.DarkRP.GetJailPositions( sMap )
    sMap = sMap or game.GetMap()

    local positions = {}
    local tab = SQL.SelectAll( DB )
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