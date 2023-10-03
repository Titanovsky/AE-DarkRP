local PLAYER = FindMetaTable( 'Player' )
local C, SQL = Ambi.General.Global.Colors, Ambi.SQL
local DB = SQL.CreateTable( 'darkrp2_rpname', 'SteamID, RPName' )

-- ---------------------------------------------------------------------------------------------------------------------------------
function PLAYER:SetRPName( sRPName )
    if not sRPName then return end
    if not self.nw_RPName then return end
    
    local old_name = self:Nick()

    if ( hook.Call( '[Ambi.DarkRP.CanSetRPName]', nil, self, sRPName, old_name ) == false ) then return end

    if Ambi.DarkRP.Config.rpname_protect then 
        sRPName = Ambi.DarkRP.FilterRPName( sRPName, self, nil, function() self:ChatSend( C.RED, '•  ', C.ABS_WHITE, 'Ваш ник не прошёл проверку и был отфильтрован!' ) end ) 
    end
    
    self.nw_RPName = hook.Call( '[Ambi.DarkRP.GetRPName]', nil, self, sRPName, old_name ) or sRPName
	
    local sid = self:SteamID()

    if not self:IsBot() then
        SQL.Update( DB, 'RPName', sRPName, 'SteamID', sid ) 
    end

    hook.Call( '[Ambi.DarkRP.SetRPName]', nil, self, sRPName, old_name )
end

hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.SetRPName', function( ePly )
    if not Ambi.DarkRP.Config.rpname_enable then return end
    if ePly:IsBot() then ePly.nw_RPName = ePly:Nick() return end

    timer.Simple( 0.1, function()
        if not IsValid( ePly ) then return end

        local sid = ePly:SteamID()
        local nick = ePly:Nick()

		local rpname = SQL.Select( DB, 'RPName', 'SteamID', sid )	
        
        ePly.nw_RPName = rpname or nick

        if not rpname then
            local random_name = table.Random( Ambi.DarkRP.Config.rpname_random_names ) --! can be trouble without a variable
            rpname = Ambi.DarkRP.Config.rpname_give_random_name and random_name or nick

            SQL.Insert( DB, 'SteamID, RPName', '%s, %s', sid, rpname ) 
    
            hook.Call( '[Ambi.DarkRP.PlayerRPNameTableCreated]', nil, ePly, rpname, nick )

            ePly:SetRPName( rpname )
        end

        hook.Call( '[Ambi.DarkRP.PlayerRPNameTableInit]', nil, ePly, rpname, nick )
    end )
end )