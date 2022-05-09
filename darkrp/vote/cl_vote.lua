local C, GUI, Draw, Gen = Ambi.Packages.Out( '@d, gen' )
local W, H = ScrW(), ScrH()
local COLOR_GREEN2, COLOR_RED2 = ColorAlpha( C.AMBI_GREEN, 100 ), ColorAlpha( C.AMBI_RED, 100 )
Ambi.DarkRP.votes = Ambi.DarkRP.votes or {}

-- -------------------------------------------------------------------------------------------------------------------------
local function GetLenTable( tTable )
    local j = 0
    for i, _ in pairs( tTable ) do
        j = j + 1
        if ( i != j ) then return j - 1 end
    end

    return #tTable
end

local active_vote_menu -- Для того, чтобы F1 и F2 срабатывали на одну панель, а не на все
local function Choice( nID, bChoice )
    LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

    net.Start( 'ambi_darkrp_start_choice' )
        net.WriteUInt( nID, 5 )
        net.WriteBool( bChoice )
    net.SendToServer()

    timer.Remove( 'AmbiDarkRPVote['..nID..']' )
    Ambi.DarkRP.votes[ nID ] = nil

    timer.Simple( 0.1, function()
        for i, vote in pairs( Ambi.DarkRP.votes ) do
            active_vote_menu = vote
        end
    end )
end

function Ambi.DarkRP.StartVote( nID, sTitle )
    if ( nID > Ambi.DarkRP.Config.vote_max ) then Gen.Error( 'DarkRP', 'StartVote | New vote cannot to start, maximum has been reached' ) return end

    LocalPlayer():EmitSound( 'Town.d1_town_02_elevbell1', 100, 100 )

    local tx = Draw.GetTextSizeX( '20 Ambi', sTitle )
    local fw, fh = tx + 14, 40
    local offset_y = fh * ( nID - 1 )

    local frame = GUI.DrawFrame( nil, fw, fh, 2, ( 2 * nID ) + 1 * offset_y, '', false, false, false, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.ABS_BLACK )
        Draw.Box( w - 4, h - 4, 2, 2, C.AMBI_BLACK )
        
        Draw.SimpleText( w / 2, 0, sTitle, '20 Ambi', C.ABS_WHITE, 'top-center', 1, C.ABS_BLACK )
        Draw.SimpleText( w / 2, h - 2, tostring( math.floor( timer.TimeLeft( 'AmbiDarkRPVote['..nID..']' ) + 1 ) ), 'DebugFixed', C.AMBI_GRAY, 'bottom-center', 1, C.ABS_BLACK )
    end )
    frame:SetKeyboardInputEnabled( true )
    frame.Think = function( self, nKey )
        if active_vote_menu and ( active_vote_menu == self ) then
            if input.IsKeyDown( KEY_F1 ) then self:Remove() Choice( nID, true ) return end
            if input.IsKeyDown( KEY_F2 ) then self:Remove() Choice( nID, false ) return end
        end
    end

    Ambi.DarkRP.votes[ nID ] = frame
    active_vote_menu = frame

    local yw, yh = 50, 16
    local yes = GUI.DrawButton( frame, yw, yh, 2, frame:GetTall() - yh - 2, nil, nil, nil, function()
        Choice( nID, true )

        frame:Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_GREEN2 )
        Draw.Box( w - 4, h - 4, 2, 2, self.color )

        Draw.SimpleText( w / 2, h / 2, 'Да', '16 Arial', C.FLAT_GREEN, 'center', 1, C.ABS_BLACK )
    end )
    yes.color = C.AMBI_GREEN
    GUI.OnCursor( yes, function()
        yes.color = COLOR_GREEN2

        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
    end, function() 
        yes.color = C.AMBI_GREEN
    end )

    local yw = 50
    local no = GUI.DrawButton( frame, yw, yh, frame:GetWide() - yw - 2, frame:GetTall() - yh - 2, nil, nil, nil, function()
        Choice( nID, false )

        frame:Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_RED2 )
        Draw.Box( w - 4, h - 4, 2, 2, self.color )

        Draw.SimpleText( w / 2, h / 2, 'Нет', '16 Arial', C.RU_RED, 'center', 1, C.ABS_BLACK )
    end )
    no.color = C.AMBI_RED
    GUI.OnCursor( no, function()
        no.color = COLOR_RED2

        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
    end, function() 
        no.color = C.AMBI_RED
    end )

    timer.Create( 'AmbiDarkRPVote['..nID..']', Ambi.DarkRP.Config.vote_time - 0.1, 1, function() 
        Ambi.DarkRP.votes[ nID ] = nil
        
        if ValidPanel( frame ) then 
            frame:Remove() 
        end
    end )
end

-- -------------------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_darkrp_start_vote', function()
    local id, title = net.ReadUInt( 5 ), net.ReadString()

    Ambi.DarkRP.votes[ id ] = title
    Ambi.DarkRP.StartVote( id, title )
end )

-- -------------------------------------------------------------------------------------------------------------------------
local CursorToggle = false
local mouse_x, mouse_y = W / 2, H / 2
hook.Add( 'PlayerButtonDown', 'Ambi.DarkRP.OpenF3Cursor', function( _, nButton ) 
    if not Ambi.DarkRP.Config.vote_f3_open_cursor then return end
    if timer.Exists( 'AmbiDarkRPF4Menu' ) then return end

    if input.IsKeyDown( KEY_F3 ) then
        timer.Create( 'AmbiDarkRPF4Menu', 0.25, 1, function() end )

        CursorToggle = not CursorToggle

        if CursorToggle then
            gui.SetMousePos( mouse_x, mouse_y )
        end

        gui.EnableScreenClicker( CursorToggle )
    end
end )