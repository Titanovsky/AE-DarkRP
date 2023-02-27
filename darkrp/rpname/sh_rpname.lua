local PLAYER = FindMetaTable( 'Player' )

-- ---------------------------------------------------------------------------------------------------------------------------------
local _Name = PLAYER.Name --! DON'T RESAVE THIS FILE ON WORKING SERVER
function PLAYER:Name()
    return self.nw_RPName or _Name( self )
end

local _Nick = PLAYER.Nick --! DON'T RESAVE THIS FILE ON WORKING SERVER
function PLAYER:Nick()
    return self.nw_RPName or _Nick( self )
end

function PLAYER:OriginalNick()
    return _Nick( self )
end

-- ---------------------------------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.FilterRPName( sRPName, ePly, fOnSuccess, fOnFail )
    local name = sRPName
    local success = true

    name = string.ToSafe( name )

    if ( name ~= sRPName ) then
        success = false
    end

    if ( utf8.len( name ) < 1 ) then 
        success = false

        name = ePly and 'P '..ePly:OwnerSteamID64() or 'None'
    end

    if success then
        if fOnSuccess then fOnSuccess( ePly, name, sRPName ) end
    else
        if fOnFail then fOnFail( ePly, name, sRPName ) end
    end

    return name
end