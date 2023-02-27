if not Ambi.ChatCommands.AddCommand then return end

local Add = Ambi.ChatCommands.AddCommand

Add( Ambi.DarkRP.Config.rpname_command, 'DarkRP', Ambi.DarkRP.Config.rpname_description, 1, function( ePly, tArgs ) 
    local name = ''
    for i, arg in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        local mark = ( i == 2 ) and '' or ' '

        name = name..mark..arg
    end

    ePly:SetRPName( name )

    if ( ePly.nw_RPName == name ) then ePly:ChatPrint( 'Вы изменили имя на '..name ) end
    
    return true
end )