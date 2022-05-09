if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local C = Ambi.General.Global.Colors
local Add = Ambi.ChatCommands.AddCommand

-- ============================================================================= --
local TYPE = 'DarkRP | Communication'

Add( 'broadcast', TYPE, 'Подать объявление', 1, function( ePly, tArgs )
    if not Ambi.DarkRP.Config.broadcast_enable then return end
    if timer.Exists( 'DarkRPBroadcastDelay' ) then ePly:ChatSend( C.AMBI_ERROR, '•  ', C.ABS_WHITE, 'Временно нельзя подать объявление!' ) return end
    if not ePly:IsMayor() then return end

    local text = ''
    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        text = text..' '..v
    end
    
    if Ambi.DarkRP.Config.broadcast_out_in_chat then
        for _, ply in ipairs( player.GetAll() ) do
            ply:ChatSend( Ambi.DarkRP.Config.broadcast_color_header, Ambi.DarkRP.Config.broadcast_header..' ', Ambi.DarkRP.Config.broadcast_color_text, text )
        end
    end

    if Ambi.DarkRP.Config.broadcast_out_in_notify then
        -- TODO
    end

    timer.Create( 'DarkRPBroadcastDelay', Ambi.DarkRP.Config.broadcast_delay, 1, function() end )

    print( '[DarkRP] '..ePly:Nick()..' подал государственное объявление: '..text )
end )