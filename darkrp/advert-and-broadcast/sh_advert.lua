if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local C = Ambi.General.Global.Colors
local Add = Ambi.ChatCommands.AddCommand

-- ============================================================================= --
local TYPE = 'DarkRP | Communication'

Add( 'advert', TYPE, 'Подать объявление', 1, function( ePly, tArgs )
    if not Ambi.DarkRP.Config.advert_enable then return end
    if timer.Exists( 'DarkRPAdvertDelay' ) then ePly:ChatSend( C.AMBI_ERROR, 'Временно нельзя подать объявление!' ) return end
    local text = ''

    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        text = text..' '..v
    end
    
    if Ambi.DarkRP.Config.advert_out_in_chat then
        for _, ply in ipairs( player.GetAll() ) do
            ply:ChatSend( Ambi.DarkRP.Config.advert_color_header, Ambi.DarkRP.Config.advert_header..' ['..ePly:Nick()..']', Ambi.DarkRP.Config.advert_color_text, text )
        end
    end

    if Ambi.DarkRP.Config.advert_out_in_notify then
        -- TODO
    end

    timer.Create( 'DarkRPAdvertDelay', Ambi.DarkRP.Config.advert_delay, 1, function() end )

    print( '[DarkRP] '..ePly:Nick()..' подал объявление: '..text )

    hook.Call( '[Ambi.DarkRP.Advert]', nil, ePly, text )
end )