local C, GUI, Draw = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

net.Receive( 'ambi_darkrp_police_send_info', function() 
    if not Ambi.DarkRP.Config.police_system_arrest_send_info then return end

    hook.Remove( 'HUDPaint', 'Ambi.DarkRP.PoliceInfo' )

    local text, reason = net.ReadString(), net.ReadString()

    hook.Add( 'HUDPaint', 'Ambi.DarkRP.PoliceInfo', function()
        Draw.SimpleText( W / 2, 68, text, '32 Ambi', C.ABS_WHITE, 'top-center', 1, C.ABS_BLACK )
        Draw.SimpleText( W / 2, 68 + 32, reason, '28 Ambi', C.ABS_WHITE, 'top-center', 1, C.ABS_BLACK )
    end )

    timer.Create( 'AmbiDarkRPRemovePoliceInfo', 4.55, 1, function() 
        hook.Remove( 'HUDPaint', 'Ambi.DarkRP.PoliceInfo' )
    end )
end )

net.Receive( 'ambi_darkrp_police_arrest_show_time', function() 
    if not Ambi.DarkRP.Config.police_system_arrest_show_time then return end

    local time = net.ReadString()
    time = tonumber( time )
    
    hook.Add( 'HUDPaint', 'Ambi.DarkRP.ShowArrestTime', function()
        Draw.SimpleText( W / 2, 16, tostring( math.floor( timer.TimeLeft( 'AmbiDarkRPRemoveArrestTime' ) + 0.55 ) ), '44 Ambi', C.ABS_WHITE, 'top-center', 1, C.ABS_BLACK )
    end )

    timer.Create( 'AmbiDarkRPRemoveArrestTime', time + 1, 1, function() 
        hook.Remove( 'HUDPaint', 'Ambi.DarkRP.ShowArrestTime' )
    end )
end )

net.Receive( 'ambi_darkrp_police_arrest_remove_time', function() 
    hook.Remove( 'HUDPaint', 'Ambi.DarkRP.ShowArrestTime' )
end )