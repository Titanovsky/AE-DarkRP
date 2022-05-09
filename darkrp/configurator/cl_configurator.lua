local C, GUI, Draw = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()
local COLOR_PANEL = Color( 38, 38, 38)
local COLOR_PANEL2 = Color( 72, 72, 84 )
local old_panel

local removed_jobs = {}

-- ----------------------------------------------------------------------------------------------------------------------------------------
local function OpenBoxMenu( sTitle, sBtn, sText, func )
    local amb_context_framebox = vgui.Create( 'DFrame' )
    amb_context_framebox:SetTitle( sTitle )
    amb_context_framebox:ShowCloseButton( true )
    amb_context_framebox:MakePopup()
    amb_context_framebox:SetSize( 250, 100 )
    amb_context_framebox:Center()
    amb_context_framebox:SetKeyboardInputEnabled( true )
    amb_context_framebox:SetMouseInputEnabled( true )
    amb_context_framebox.Paint = function( self, w, h )
        draw.RoundedBox ( 0, 0, 0, w, h, C.ABS_WHITE )
        draw.RoundedBox ( 0, 1, 1, w-2, h-2, C.ABS_BLACK )
    end
 
    local amb_context_framebox_te = vgui.Create( 'DTextEntry', amb_context_framebox )
    amb_context_framebox_te:SetPos( 25, 25 )
    amb_context_framebox_te:SetSize( 210, 30 )
    amb_context_framebox_te:SetMultiline( false )
    amb_context_framebox_te:SetAllowNonAsciiCharacters( true )
    amb_context_framebox_te:SetText( tostring( sText ) )
    amb_context_framebox_te:SetEnterAllowed( true )
 
    local amb_context_framebox_btn = vgui.Create( 'DButton', amb_context_framebox )
    amb_context_framebox_btn:SetText( sBtn )
    amb_context_framebox_btn:SetSize( 110, 20 )
    amb_context_framebox_btn:SetPos( 75, 70 )
    amb_context_framebox_btn.DoClick = function()
        func( amb_context_framebox_te:GetValue() )
        amb_context_framebox:Remove()
    end

    amb_context_framebox.Think = function( self )
        if input.IsKeyDown( KEY_ENTER ) then
            func( amb_context_framebox_te:GetValue() )
            self:Remove()
        end
    end
end

local function OpenCreateVariable( vguiPanel, vguiPanel2, tTable, fAdd )
    local frame = GUI.DrawFrame( vguiPanel, 400, 400, 0, 0, '', true, true, true, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_WHITE, 4 )

        --Draw.SimpleText( w - 8, 16, 'Configurator', '32 Oswald Light', C.ABS_WHITE, 'top-right', 1, C.ABS_BLACK )
    end )
    frame:Center()

    local panel = GUI.DrawScrollPanel( frame, frame:GetWide() - 8, frame:GetTall() - 32 - 4, 4, 32, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL, 4 )
    end )

    local index = GUI.DrawTextEntry( panel, panel:GetWide() - 8, 26, 4, 4, '24 Ambi', nil, nil, C.AMBI_GRAY, 'Введите Index' )

    local canvas = GUI.DrawScrollPanel( panel, panel:GetWide(), 200, 0, panel:GetTall() - 200, function( self, w, h ) 
        --Draw.Box( w, h, 0, 0, C.AMBI_BLUE, 4 )
    end )

    local menu = GUI.DrawComboBox( panel, 200, 32, panel:GetWide() / 2 - 200 / 2, index:GetTall() + 24 + 4, '26 Ambi', '', function( _, _, sValue )
        canvas:Clear()

        if ( sValue == 'Строка' ) then
            local te = GUI.DrawTextEntry( canvas, canvas:GetWide() - 8, 60, 4, 4, '24 Ambi', nil, nil, C.AMBI_GRAY, 'Введите строку', true )

            local button = GUI.DrawButton( canvas, 128, 36, canvas:GetWide() / 2 - 128 / 2, canvas:GetTall() - 36 - 4, nil, nil, nil, function( self ) 
                if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

                local index = tostring( index:GetValue() )
                if string.find( index, '^%d' ) then index = tonumber( index ) end

                local value = tostring( te:GetValue() )
        
                frame:Remove()
        
                if fAdd then fAdd( tTable, index, value ) end
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
        
                Draw.SimpleText( w / 2, h / 2, 'Создать', '36 Open Sans Condensed', C.AMBI_GREEN, 'center', 1, C.ABS_BLACK )
            end )
        elseif ( sValue == 'Число' ) then
            local te = GUI.DrawTextEntry( canvas, canvas:GetWide() - 24, 24, 12, 4, '24 Ambi', nil, nil, C.AMBI_GRAY, 'Введите число', false, true )

            local button = GUI.DrawButton( canvas, 128, 36, canvas:GetWide() / 2 - 128 / 2, canvas:GetTall() - 36 - 4, nil, nil, nil, function( self ) 
                if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

                local index = tostring( index:GetValue() )
                if string.find( index, '^%d' ) then index = tonumber( index ) end

                local value = tonumber( te:GetValue() )
        
                frame:Remove()
        
                if fAdd then fAdd( tTable, index, value ) end
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
        
                Draw.SimpleText( w / 2, h / 2, 'Создать', '36 Open Sans Condensed', C.AMBI_GREEN, 'center', 1, C.ABS_BLACK )
            end )
        elseif ( sValue == 'Булевое Значение' ) then
            local button = GUI.DrawButton( canvas, 128, 36, canvas:GetWide() / 2 - 128 / 2, canvas:GetTall() - 36 - 4, nil, nil, nil, function( self ) 
                if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

                local index = tostring( index:GetValue() )
                if string.find( index, '^%d' ) then index = tonumber( index ) end

                local value = false
        
                frame:Remove()
        
                if fAdd then fAdd( tTable, index, value ) end
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
        
                Draw.SimpleText( w / 2, h / 2, 'false', '36 Open Sans Condensed', C.RU_RED, 'center', 1, C.ABS_BLACK )
            end )

            local button = GUI.DrawButton( canvas, 128, 36, canvas:GetWide() / 2 - 128 / 2, canvas:GetTall() - 36 - 4 - button:GetTall() - 4, nil, nil, nil, function( self ) 
                if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

                local index = tostring( index:GetValue() )
                if string.find( index, '^%d' ) then index = tonumber( index ) end

                local value = true
        
                frame:Remove()
        
                if fAdd then fAdd( tTable, index, value ) end
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
        
                Draw.SimpleText( w / 2, h / 2, 'true', '36 Open Sans Condensed', C.AMBI_GREEN, 'center', 1, C.ABS_BLACK )
            end )
        elseif ( sValue == 'Таблица' ) then
            local button = GUI.DrawButton( canvas, 128, 48, canvas:GetWide() / 2 - 128 / 2, canvas:GetTall() / 2 - 48 / 2, nil, nil, nil, function( self ) 
                if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

                local index = tostring( index:GetValue() )
                if string.find( index, '^%d' ) then index = tonumber( index ) end

                local value = {}
        
                frame:Remove()
        
                if fAdd then fAdd( tTable, index, value ) end
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
        
                Draw.SimpleText( w / 2, h / 2, 'Создать', '36 Open Sans Condensed', C.AMBI_GREEN, 'center', 1, C.ABS_BLACK )
            end )
        elseif ( sValue == 'Color' ) then
            local r = GUI.DrawTextEntry( canvas, 46, 24, canvas:GetWide() / 2 - 46 / 2, 4, '18 Ambi', nil, nil, C.AMBI_GRAY, 'R', false, true )

            local offset = 4 + r:GetTall() + 4
            local g = GUI.DrawTextEntry( canvas, 46, 24, canvas:GetWide() / 2 - 46 / 2, offset, '18 Ambi', nil, nil, C.AMBI_GRAY, 'G', false, true )

            offset = offset + g:GetTall() + 4
            local b = GUI.DrawTextEntry( canvas, 46, 24, canvas:GetWide() / 2 - 46 / 2, offset, '18 Ambi', nil, nil, C.AMBI_GRAY, 'B', false, true )

            offset = offset + b:GetTall() + 4
            local a = GUI.DrawTextEntry( canvas, 46, 24, canvas:GetWide() / 2 - 46 / 2, offset, '18 Ambi', nil, nil, C.AMBI_GRAY, 'A', false, true )

            local button = GUI.DrawButton( canvas, 128, 36, canvas:GetWide() / 2 - 128 / 2, canvas:GetTall() - 36 - 4, nil, nil, nil, function( self ) 
                if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

                local index = tostring( index:GetValue() )
                if string.find( index, '^%d' ) then index = tonumber( index ) end

                local r = tonumber( r:GetValue() or 0 )
                local g = tonumber( g:GetValue() or 0 )
                local b = tonumber( b:GetValue() or 0 )
                local a = tonumber( a:GetValue() or 255 )

                local value = Color( r, g, b, a )
        
                frame:Remove()
        
                if fAdd then fAdd( tTable, index, value ) end
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
        
                Draw.SimpleText( w / 2, h / 2, 'Создать', '36 Open Sans Condensed', C.AMBI_GREEN, 'center', 1, C.ABS_BLACK )
            end )
        elseif ( sValue == 'Vector' ) then
            local x = GUI.DrawTextEntry( canvas, 132, 24, canvas:GetWide() / 2 - 132 / 2, 4, '18 Ambi', nil, nil, C.AMBI_GRAY, 'X', false, true )

            local offset = 4 + x:GetTall() + 4
            local y = GUI.DrawTextEntry( canvas, 132, 24, canvas:GetWide() / 2 - 132 / 2, offset, '18 Ambi', nil, nil, C.AMBI_GRAY, 'Y', false, true )

            offset = offset + y:GetTall() + 4
            local z = GUI.DrawTextEntry( canvas, 132, 24, canvas:GetWide() / 2 - 132 / 2, offset, '18 Ambi', nil, nil, C.AMBI_GRAY, 'Z', false, true )

            local button = GUI.DrawButton( canvas, 128, 36, canvas:GetWide() / 2 - 128 / 2, canvas:GetTall() - 36 - 4, nil, nil, nil, function( self ) 
                if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

                local index = tostring( index:GetValue() )
                if string.find( index, '^%d' ) then index = tonumber( index ) end

                local x = x:GetValue() and tonumber( x:GetValue() ) or 1
                local y = y:GetValue() and tonumber( y:GetValue() ) or 1
                local z = z:GetValue() and tonumber( z:GetValue() ) or 1

                local value = Vector(3123, -43, -12334 )
        
                frame:Remove()
        
                if fAdd then fAdd( tTable, index, value ) end
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
        
                Draw.SimpleText( w / 2, h / 2, 'Создать', '36 Open Sans Condensed', C.AMBI_GREEN, 'center', 1, C.ABS_BLACK )
            end )
        elseif ( sValue == 'Angle' ) then
            local x = GUI.DrawTextEntry( canvas, 132, 24, canvas:GetWide() / 2 - 132 / 2, 4, '18 Ambi', nil, nil, C.AMBI_GRAY, 'Pitch', false, true )

            local offset = 4 + x:GetTall() + 4
            local y = GUI.DrawTextEntry( canvas, 132, 24, canvas:GetWide() / 2 - 132 / 2, offset, '18 Ambi', nil, nil, C.AMBI_GRAY, 'Yaw', false, true )

            offset = offset + y:GetTall() + 4
            local z = GUI.DrawTextEntry( canvas, 132, 24, canvas:GetWide() / 2 - 132 / 2, offset, '18 Ambi', nil, nil, C.AMBI_GRAY, 'Roll', false, true )

            local button = GUI.DrawButton( canvas, 128, 36, canvas:GetWide() / 2 - 128 / 2, canvas:GetTall() - 36 - 4, nil, nil, nil, function( self ) 
                if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

                local index = tostring( index:GetValue() )
                if string.find( index, '^%d' ) then index = tonumber( index ) end

                local x = x:GetValue() and tonumber( x:GetValue() ) or 1
                local y = y:GetValue() and tonumber( y:GetValue() ) or 1
                local z = z:GetValue() and tonumber( z:GetValue() ) or 1

                local value = Angle( x, y, z )
        
                frame:Remove()
        
                if fAdd then fAdd( tTable, index, value ) end
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
        
                Draw.SimpleText( w / 2, h / 2, 'Создать', '36 Open Sans Condensed', C.AMBI_GREEN, 'center', 1, C.ABS_BLACK )
            end )
        end
    end )
    menu:AddChoice( 'Строка' )
    menu:AddChoice( 'Число' )
    menu:AddChoice( 'Булевое Значение' )
    menu:AddChoice( 'Таблица' )
    menu:AddChoice( 'Color' ) 
    menu:AddChoice( 'Angle' )
    menu:AddChoice( 'Vector' )
end

local function GetColor( anyValue )
    local color = C.DLIB_NUMBER
    if ( anyValue == 'Таблица' ) then color = C.AMBI_GRAY
    elseif IsVector( anyValue ) then color = C.AMBI_PURPLE
    elseif IsAngle( anyValue ) then color = C.DLIB_URL
    elseif IsColor( anyValue ) then color = C.AMBI_SOFT_YELLOW
    elseif ( anyValue == true ) then color = C.AMBI_GREEN
    elseif ( anyValue == false ) then color = C.RU_RED
    elseif IsNumber( anyValue ) then color = C.RU_SOFT_BLUE
    end

    return color
end

local function OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
    local panel = GUI.DrawScrollPanel( vguiPanel, vguiPanel:GetWide(), vguiPanel:GetTall(), 0, 0, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL, 4 )
    end )

    local button = GUI.DrawButton( panel, 64, 26, 4, 4, nil, nil, nil, function( self ) 
        panel:Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )

        Draw.SimpleText( w / 2, h / 2, '<<', '36 Open Sans Condensed', C.AMBI_SOFT_BLUE, 'center', 1, C.ABS_BLACK )
    end )

    local i = 0
    for index, value in pairs( tTable ) do
        if IsTable( value ) then
            if not ( IsColor( value ) or IsVector( value ) or IsAngle( value ) ) then value = 'Таблица' end
        end

        i = i + 1

        local color = GetColor( value )
        local text = index..'  =  '
        local x = Draw.GetTextSizeX( '26 Ambi', text )

        local button = GUI.DrawButton( panel, panel:GetWide() - 8 - 26 - 4, 36, 4 + 26 + 4, i * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
            if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

            local old_value = value

            if ( value == 'Таблица' ) then
                OpenTable( vguiPanel, tTable[ index ], fSet, fAdd, fRemove )
            elseif ( value == true ) then
                local value = false
                color = GetColor( value )

                if fSet then fSet( tTable, index, value ) end

                panel:Remove()

                OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
            elseif ( value == false ) then
                local value = true
                color = GetColor( value )

                if fSet then fSet( tTable, index, value ) end

                panel:Remove()

                OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
            elseif IsNumber( value ) then 
                OpenBoxMenu( 'Введие Number', 'Изменить', tostring( value ), function( sText ) 
                    local value = ToNumber( sText )
                    color = GetColor( value )

                    if fSet then fSet( tTable, index, value ) end

                    panel:Remove()

                    OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
                end ) 
            elseif IsVector( value ) then 
                OpenBoxMenu( 'Введите Vector', 'Изменить', tostring( value ), function( sText ) 
                    local tab = string.Explode( ' ', sText )

                    value = Vector( tonumber( tab[ 1 ] ), tonumber( tab[ 2 ] ), tonumber( tab[ 3 ] ) )
                    color = GetColor( value )

                    if fSet then fSet( tTable, index, value ) end

                    panel:Remove()

                    OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
                end ) 
            elseif IsAngle( value ) then 
                OpenBoxMenu( 'Введите Angle', 'Изменить', tostring( value ), function( sText ) 
                    local tab = string.Explode( ' ', sText )

                    value = Angle( tonumber( tab[ 1 ] ), tonumber( tab[ 2 ] ), tonumber( tab[ 3 ] ) )
                    color = GetColor( value )

                    if fSet then fSet( tTable, index, value ) end

                    panel:Remove()

                    OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
                end ) 
            elseif IsColor( value ) then 
                OpenBoxMenu( 'Введите Vector', 'Изменить', tostring( value ), function( sText ) 
                    local tab = string.Explode( ' ', sText )

                    value = Color( tonumber( tab[ 1 ] ), tonumber( tab[ 2 ] ), tonumber( tab[ 3 ] ) )
                    color = GetColor( value )

                    if fSet then fSet( tTable, index, value ) end

                    panel:Remove()

                    OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
                end ) 
            else
                OpenBoxMenu( 'Введие Строку', 'Изменить', value, function( sText ) 
                    local value = sText
                    color = GetColor( value )

                    if fSet then fSet( tTable, index, value ) end

                    panel:Remove()

                    OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
                end ) 
            end
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
    
            Draw.SimpleText( 4, h / 2, text, '26 Ambi', C.ABS_WHITE, 'center-left', 1, C.ABS_BLACK )
            Draw.SimpleText( 4 + x, h / 2, tostring( value ), '26 Ambi', color, 'center-left', 1, C.ABS_BLACK )
        end )
        button:SetTooltip( tostring( value ) )

        local remove = GUI.DrawButton( panel, 26, 36, 4, i * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
            if fRemove then 
                fRemove( tTable, index, value ) 
                    
                panel:Remove()

                OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
            end
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL2, 4 )
    
            Draw.SimpleText( w / 2 - 1, h / 2, '❌', '20 Open Sans Condensed', C.AMBI_RED, 'center', 1, C.ABS_BLACK )
        end )
    end

    local add = GUI.DrawButton( panel, panel:GetWide() - 8, 36, 4, ( i + 1 ) * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
        OpenCreateVariable( vguiPanel, panel, tTable, function( _, anyIndex, anyValue )
            if fAdd then fAdd( tTable, anyIndex, anyValue ) end

            panel:Remove()

            OpenTable( vguiPanel, tTable, fSet, fAdd, fRemove )
        end )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )

        Draw.SimpleText( w / 2, h / 2, '(+)', '36 Open Sans Condensed', C.AMBI_GREEN, 'center', 1, C.ABS_BLACK )
    end )
end

local function OpenConfig( vguiPanel )
    vguiPanel:Clear()

    local panel = GUI.DrawScrollPanel( vguiPanel, vguiPanel:GetWide(), vguiPanel:GetTall(), 0, 0, function( self, w, h ) 
        --Draw.Box( w, h, 0, 0, COLOR_PANEL, 4 )
    end )

    local button = GUI.DrawButton( panel, 128, 36, 4, 4, nil, nil, nil, function( self ) 
        if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end

        vguiPanel:GetParent():Remove()

        net.Start( 'ambi_darkrp_configurator_clear_config' ) 
        net.SendToServer()

        chat.AddText( C.AMBI_SOFT_BLUE, 'Вы очистили конфиг (Вернули стандартные значения)'  )
        LocalPlayer():EmitSound( 'buttons/button17.wav' )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )

        Draw.SimpleText( w / 2, h / 2, 'Clear Config', '36 Open Sans Condensed', C.AMBI_SOFT_BLUE, 'center', 1, C.ABS_BLACK )
    end )

    local i = 0
    for config, value in SortedPairs( Ambi.DarkRP.Config ) do
        if IsTable( value ) then
            if not ( IsColor( value ) or IsVector( value ) or IsAngle( value ) ) then value = 'Таблица' end
        end

        i = i + 1

        local color = GetColor( value )
        local text = config..'  =  '
        local x = Draw.GetTextSizeX( '26 Ambi', text )
        local button = GUI.DrawButton( panel, panel:GetWide() - 8, 36, 4, i * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
            if not LocalPlayer():IsSuperAdmin() then vguiPanel:GetParent():Remove() return end
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

            local old_value = value

            if ( value == 'Таблица' ) then
                OpenTable( vguiPanel, Ambi.DarkRP.Config[ config ], function( tTable, anyIndex, anyValue )
                    tTable[ anyIndex ] = anyValue

                    net.Start( 'ambi_darkrp_configurator_set_config_table' )
                        net.WriteTable( Ambi.DarkRP.Config )
                    net.SendToServer()

                    chat.AddText( C.AMBI, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                    LocalPlayer():EmitSound( 'buttons/button9.wav' )
                end, function( tTable, anyIndex, anyValue )
                    tTable[ anyIndex ] = anyValue

                    net.Start( 'ambi_darkrp_configurator_set_config_table' )
                        net.WriteTable( Ambi.DarkRP.Config )
                    net.SendToServer()

                    chat.AddText( C.AMBI_GREEN, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                    LocalPlayer():EmitSound( 'buttons/button9.wav' )
                end, function( tTable, anyIndex, anyValue ) 
                    if isnumber( anyIndex ) then 
                        table.remove( tTable, anyIndex )
                    else
                        tTable[ anyIndex ] = nil
                    end

                    net.Start( 'ambi_darkrp_configurator_set_config_table' )
                        net.WriteTable( Ambi.DarkRP.Config )
                    net.SendToServer()

                    chat.AddText( C.RU_RED, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                    LocalPlayer():EmitSound( 'buttons/button9.wav' )
                end )
            elseif ( value == true ) then
                value = false
                color = GetColor( value )

                Ambi.DarkRP.Config[ config ] = value

                net.Start( 'ambi_darkrp_configurator_set_config' )
                    net.WriteString( config )
                    net.WriteTable( { value = value } )
                net.SendToServer()

                self:SetTooltip( tostring( value ) )
                chat.AddText( C.AMBI, config, C.ABS_WHITE, ':  '..tostring( old_value )..' >> '..tostring( value )  )
            elseif ( value == false ) then
                value = true
                color = GetColor( value )

                Ambi.DarkRP.Config[ config ] = value

                net.Start( 'ambi_darkrp_configurator_set_config' )
                    net.WriteString( config )
                    net.WriteTable( { value = value } )
                net.SendToServer()

                self:SetTooltip( tostring( value ) )
                chat.AddText( C.AMBI, config, C.ABS_WHITE, ':  '..tostring( old_value )..' >> '..tostring( value )  )
            elseif IsNumber( value ) then 
                OpenBoxMenu( 'Введие Number', 'Изменить', tostring( value ), function( sText ) 
                    value = ToNumber( sText )
                    color = GetColor( value )

                    Ambi.DarkRP.Config[ config ] = value

                    net.Start( 'ambi_darkrp_configurator_set_config' )
                        net.WriteString( config )
                        net.WriteTable( { value = value } )
                    net.SendToServer()

                    self:SetTooltip( tostring( value ) )
                    chat.AddText( C.AMBI, config, C.ABS_WHITE, ':  '..tostring( old_value )..' >> '..tostring( value )  )
                end )
            elseif IsVector( value ) then 
                OpenBoxMenu( 'Изменить Vector', 'Изменить', tostring( value ), function( sText ) 
                    local tab = string.Explode( ' ', sText )

                    value = Vector( tonumber( tab[ 1 ] ), tonumber( tab[ 2 ] ), tonumber( tab[ 3 ] ) )
                    color = GetColor( value )

                    Ambi.DarkRP.Config[ config ] = value

                    net.Start( 'ambi_darkrp_configurator_set_config' )
                        net.WriteString( config )
                        net.WriteTable( { value = value } )
                    net.SendToServer()

                    self:SetTooltip( tostring( value ) )
                    chat.AddText( C.AMBI, config, C.ABS_WHITE, ':  '..tostring( old_value )..' >> '..tostring( value )  )
                end )
            elseif IsAngle( value ) then 
                OpenBoxMenu( 'Изменить Angle', 'Изменить', tostring( value ), function( sText ) 
                    local tab = string.Explode( ' ', sText )

                    value = Angle( tonumber( tab[ 1 ] ), tonumber( tab[ 2 ] ), tonumber( tab[ 3 ] ) )
                    color = GetColor( value )

                    Ambi.DarkRP.Config[ config ] = value

                    net.Start( 'ambi_darkrp_configurator_set_config' )
                        net.WriteString( config )
                        net.WriteTable( { value = value } )
                    net.SendToServer()

                    self:SetTooltip( tostring( value ) )
                    chat.AddText( C.AMBI, config, C.ABS_WHITE, ':  '..tostring( old_value )..' >> '..tostring( value )  )
                end )
            elseif IsColor( value ) then 
                OpenBoxMenu( 'Изменить Color', 'Изменить', tostring( value ), function( sText ) 
                    local tab = string.Explode( ' ', sText )

                    value = Color( tonumber( tab[ 1 ] ), tonumber( tab[ 2 ] ), tonumber( tab[ 3 ] ) )
                    color = GetColor( value )

                    Ambi.DarkRP.Config[ config ] = value

                    net.Start( 'ambi_darkrp_configurator_set_config' )
                        net.WriteString( config )
                        net.WriteTable( { value = value } )
                    net.SendToServer()

                    self:SetTooltip( tostring( value ) )
                    chat.AddText( C.AMBI, config, C.ABS_WHITE, ':  '..tostring( old_value )..' >> '..tostring( value )  )
                end )
            else
                OpenBoxMenu( 'Введие Строку', 'Изменить', value, function( sText ) 
                    value = sText
                    color = GetColor( value )

                    Ambi.DarkRP.Config[ config ] = value

                    net.Start( 'ambi_darkrp_configurator_set_config' )
                        net.WriteString( config )
                        net.WriteTable( { value = value } )
                    net.SendToServer()

                    self:SetTooltip( tostring( value ) )
                    chat.AddText( C.AMBI, config, C.ABS_WHITE, ':  '..tostring( old_value )..' >> '..tostring( value )  )
                end ) 
            end
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL2, 8 )
    
            Draw.SimpleText( 4, h / 2, text, '26 Ambi', C.ABS_WHITE, 'center-left', 1, C.ABS_BLACK )
            Draw.SimpleText( 4 + x, h / 2, tostring( value ), '26 Ambi', color, 'center-left', 1, C.ABS_BLACK )
        end )
        button:SetTooltip( tostring( value ) )
    end
end

local function OpenJobs( vguiPanel )
    vguiPanel:Clear()

    local panel = GUI.DrawScrollPanel( vguiPanel, vguiPanel:GetWide(), vguiPanel:GetTall(), 0, 0, function( self, w, h ) 
    end )

    local i = -1
    for class, job in SortedPairsByMemberValue( Ambi.DarkRP.GetJobs(), 'index' ) do
        i = i + 1

        local button = GUI.DrawButton( panel, panel:GetWide() - 8 - 26 - 4, 36, 4 + 26 + 2, i * ( 36 + 4 ) + 4, nil, nil, nil, function() 
            OpenTable( vguiPanel, Ambi.DarkRP.GetJob( class ), function( tTable, anyIndex, anyValue )
                tTable[ anyIndex ] = anyValue

                net.Start( 'ambi_darkrp_configurator_change_jobs' )
                    net.WriteTable( Ambi.DarkRP.jobs )
                net.SendToServer()

                chat.AddText( C.AMBI, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end, function( tTable, anyIndex, anyValue )
                tTable[ anyIndex ] = anyValue

                net.Start( 'ambi_darkrp_configurator_change_jobs' )
                    net.WriteTable( Ambi.DarkRP.jobs )
                net.SendToServer()

                chat.AddText( C.AMBI_GREEN, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end, function( tTable, anyIndex, anyValue ) 
                if isnumber( anyIndex ) then 
                    table.remove( tTable, anyIndex )
                else
                    tTable[ anyIndex ] = nil
                end

                net.Start( 'ambi_darkrp_configurator_change_jobs' )
                    net.WriteTable( Ambi.DarkRP.jobs )
                net.SendToServer()

                chat.AddText( C.RU_RED, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.AU_GREY, 4 )

            Draw.SimpleText( 4, 4, '['..job.index..'] '..job.name, '26 Arial', C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
        end )

        if ( class == Ambi.DarkRP.Config.jobs_class ) then continue end

        local remove = GUI.DrawButton( panel, 26, 36, 4, i * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
            Ambi.DarkRP.RemoveJob( class )

            net.Start( 'ambi_darkrp_configurator_change_jobs' )
                net.WriteTable( Ambi.DarkRP.GetJobs() )
            net.SendToServer()
                
            panel:Remove()

            OpenJobs( vguiPanel )

            chat.AddText( C.ABS_WHITE, 'Работа ', C.AMBI_RED, job.name, C.ABS_WHITE, ' удалена!'  )
            LocalPlayer():EmitSound( 'buttons/button8.wav' )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL2, 4 )
    
            Draw.SimpleText( w / 2 - 1, h / 2, '❌', '20 Open Sans Condensed', C.AMBI_RED, 'center', 1, C.ABS_BLACK )
        end )
    end

    local add = GUI.DrawButton( panel, panel:GetWide() - 8, 36, 4, ( i + 1 ) * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
        OpenBoxMenu( 'Назовите Класс', 'Создать', '', function( sValue ) 
            if Ambi.DarkRP.jobs[ sValue ] then LocalPlayer():EmitSound( 'buttons/button4.wav' ) return end

            Ambi.DarkRP.AddJob( sValue, Ambi.DarkRP.Config.jobs_default )

            net.Start( 'ambi_darkrp_configurator_change_jobs' )
                net.WriteTable( Ambi.DarkRP.GetJobs() )
            net.SendToServer()

            panel:Remove()

            OpenJobs( vguiPanel )

            chat.AddText( C.ABS_WHITE, 'Создана работа ', C.AMBI_GREEN, sValue  )
            LocalPlayer():EmitSound( 'buttons/button9.wav' )
        end )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AU_GREEN, 4 )

        Draw.SimpleText( w / 2, h / 2, '+', '40 Open Sans Condensed', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
end

local function OpenShop( vguiPanel )
    vguiPanel:Clear()

    local panel = GUI.DrawScrollPanel( vguiPanel, vguiPanel:GetWide(), vguiPanel:GetTall(), 0, 0, function( self, w, h ) 
    end )

    local i = -1
    for class, item in SortedPairsByMemberValue( Ambi.DarkRP.GetShop(), 'category' ) do
        i = i + 1

        local button = GUI.DrawButton( panel, panel:GetWide() - 8 - 26 - 4, 36, 4 + 26 + 2, i * ( 36 + 4 ) + 4, nil, nil, nil, function() 
            OpenTable( vguiPanel, Ambi.DarkRP.shop[ class ], function( tTable, anyIndex, anyValue )
                tTable[ anyIndex ] = anyValue

                net.Start( 'ambi_darkrp_configurator_send_changed_shop' )
                    net.WriteTable( Ambi.DarkRP.shop )
                net.SendToServer()

                chat.AddText( C.AMBI, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end, function( tTable, anyIndex, anyValue )
                tTable[ anyIndex ] = anyValue

                net.Start( 'ambi_darkrp_configurator_send_changed_shop' )
                    net.WriteTable( Ambi.DarkRP.shop )
                net.SendToServer()

                chat.AddText( C.AMBI_GREEN, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end, function( tTable, anyIndex, anyValue ) 
                if isnumber( anyIndex ) then 
                    table.remove( tTable, anyIndex )
                else
                    tTable[ anyIndex ] = nil
                end

                net.Start( 'ambi_darkrp_configurator_send_changed_shop' )
                    net.WriteTable( Ambi.DarkRP.shop )
                net.SendToServer()

                chat.AddText( C.RU_RED, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.UK_BLACK, 4 )

            Draw.SimpleText( 4, 4, class, '26 Arial', C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
        end )

        local remove = GUI.DrawButton( panel, 26, 36, 4, i * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
            Ambi.DarkRP.RemoveShopItem( class )

            net.Start( 'ambi_darkrp_configurator_send_changed_shop' )
                net.WriteTable( Ambi.DarkRP.GetShop() )
            net.SendToServer()
                
            panel:Remove()

            OpenShop( vguiPanel )

            chat.AddText( C.ABS_WHITE, 'Предмет в магазине ', C.AMBI_RED, class, C.ABS_WHITE, ' удален!'  )
            LocalPlayer():EmitSound( 'buttons/button8.wav' )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL2, 4 )
    
            Draw.SimpleText( w / 2 - 1, h / 2, '❌', '20 Open Sans Condensed', C.AMBI_RED, 'center', 1, C.ABS_BLACK )
        end )
    end

    local add = GUI.DrawButton( panel, panel:GetWide() - 8, 36, 4, ( i + 1 ) * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
        OpenBoxMenu( 'Назовите Класс', 'Создать', '', function( sValue ) 
            if Ambi.DarkRP.shop[ sValue ] then LocalPlayer():EmitSound( 'buttons/button4.wav' ) return end

            Ambi.DarkRP.AddShopItem( sValue, Ambi.DarkRP.Config.shop_default )

            net.Start( 'ambi_darkrp_configurator_send_changed_shop' )
                net.WriteTable( Ambi.DarkRP.GetShop() )
            net.SendToServer()

            panel:Remove()

            OpenShop( vguiPanel )

            chat.AddText( C.ABS_WHITE, 'Создан предмет в магазине ', C.AMBI_GREEN, sValue  )
            LocalPlayer():EmitSound( 'buttons/button9.wav' )
        end )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AU_GREEN, 4 )

        Draw.SimpleText( w / 2, h / 2, '+', '40 Open Sans Condensed', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
end

local function OpenDoors( vguiPanel )
    vguiPanel:Clear()

    local panel = GUI.DrawScrollPanel( vguiPanel, vguiPanel:GetWide(), vguiPanel:GetTall(), 0, 0, function( self, w, h ) 
    end )

    local i = -1
    for category, jobs in SortedPairs( Ambi.DarkRP.GetDoorCategories() ) do
        i = i + 1

        local button = GUI.DrawButton( panel, panel:GetWide() - 8 - 26 - 4, 36, 4 + 26 + 2, i * ( 36 + 4 ) + 4, nil, nil, nil, function() 
            OpenTable( vguiPanel, Ambi.DarkRP.doors_categories[ category ], function( tTable, anyIndex, anyValue )
                tTable[ anyIndex ] = anyValue

                net.Start( 'ambi_darkrp_configurator_change_door_categories' )
                    net.WriteTable( Ambi.DarkRP.GetDoorCategories() )
                net.SendToServer()

                chat.AddText( C.AMBI, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end, function( tTable, anyIndex, anyValue )
                tTable[ anyIndex ] = anyValue

                net.Start( 'ambi_darkrp_configurator_change_door_categories' )
                    net.WriteTable( Ambi.DarkRP.GetDoorCategories() )
                net.SendToServer()

                chat.AddText( C.AMBI_GREEN, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end, function( tTable, anyIndex, anyValue ) 
                if isnumber( anyIndex ) then 
                    table.remove( tTable, anyIndex )
                else
                    tTable[ anyIndex ] = nil
                end

                net.Start( 'ambi_darkrp_configurator_change_door_categories' )
                    net.WriteTable( Ambi.DarkRP.GetDoorCategories() )
                net.SendToServer()

                chat.AddText( C.RU_RED, '['..tostring( anyIndex )..']', C.ABS_WHITE, '  '..tostring( anyValue )  )
                LocalPlayer():EmitSound( 'buttons/button9.wav' )
            end )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.RU_PURPLE, 4 )

            Draw.SimpleText( 4, 4, category, '26 Arial', C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
        end )

        local remove = GUI.DrawButton( panel, 26, 36, 4, i * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
            Ambi.DarkRP.RemoveDoorCategory( category )

            net.Start( 'ambi_darkrp_configurator_change_door_categories' )
                net.WriteTable( Ambi.DarkRP.GetDoorCategories() )
            net.SendToServer()
                
            panel:Remove()

            OpenDoors( vguiPanel )

            chat.AddText( C.ABS_WHITE, 'Категория дверей ', C.AMBI_RED, category, C.ABS_WHITE, ' удалена!'  )
            LocalPlayer():EmitSound( 'buttons/button8.wav' )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, COLOR_PANEL2, 4 )
    
            Draw.SimpleText( w / 2 - 1, h / 2, '❌', '20 Open Sans Condensed', C.AMBI_RED, 'center', 1, C.ABS_BLACK )
        end )
    end

    local add = GUI.DrawButton( panel, panel:GetWide() - 8, 36, 4, ( i + 1 ) * ( 36 + 4 ) + 4, nil, nil, nil, function( self ) 
        OpenBoxMenu( 'Назовите Категорию', 'Создать', '', function( sValue ) 
            Ambi.DarkRP.doors_categories[ sValue ] = { 'TEAM_EXAMPLE' }

            net.Start( 'ambi_darkrp_configurator_change_door_categories' )
                net.WriteTable( Ambi.DarkRP.GetDoorCategories() )
            net.SendToServer()

            panel:Remove()

            OpenDoors( vguiPanel )

            chat.AddText( C.ABS_WHITE, 'Создана категория ', C.AMBI, sValue  )
            LocalPlayer():EmitSound( 'buttons/button9.wav' )
        end )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AU_GREEN, 4 )

        Draw.SimpleText( w / 2, h / 2, '+', '40 Open Sans Condensed', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
end

-- ----------------------------------------------------------------------------------------------------------------------------------------
local save_page

function Ambi.DarkRP.OpenConfigurator()
    if not Ambi.DarkRP.configurator_enable then return end
    if not LocalPlayer():IsSuperAdmin() then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не Супер Админ!' ) return end
    if ValidPanel( old_panel ) then old_panel:Remove() return end

    local frame = GUI.DrawFrame( nil, W / 1.2, H / 1.2, 0, 0, '', true, true, true, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 4 )

        Draw.SimpleText( w - 8, 16, 'Configurator', '32 Oswald Light', C.ABS_WHITE, 'top-right', 1, C.ABS_BLACK )
    end )
    frame:Center()

    local header = GUI.DrawPanel( frame, frame:GetWide() - 102, 40, 4, 4, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL, 4 )
    end )

    local panel = GUI.DrawScrollPanel( frame, frame:GetWide() - 8, frame:GetTall() - header:GetTall() - 8 - 4, 4, 4 + header:GetTall() + 4, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL, 4 )
    end )

    local config = GUI.DrawButton( header, 120, 40 - 8, 4, 4, nil, nil, nil, function() OpenConfig( panel ) save_page = OpenConfig end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_RED, 4 )

        Draw.SimpleText( w / 2, h / 2, 'Config', '28 Ambi', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )

    local x = 4 + config:GetWide() + 4
    local job = GUI.DrawButton( header, 120, 40 - 8, x, 4, nil, nil, nil, function() OpenJobs( panel ) save_page = OpenJobs end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_BLUE, 4 )

        Draw.SimpleText( w / 2, h / 2, 'Jobs', '28 Ambi', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end ) 

    local x = x + job:GetWide() + 4
    local shop = GUI.DrawButton( header, 120, 40 - 8, x, 4, nil, nil, nil, function() OpenShop( panel ) save_page = OpenShop end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_GREEN, 4 )

        Draw.SimpleText( w / 2, h / 2, 'Shop', '28 Ambi', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )

    local x = x + shop:GetWide() + 4
    local door = GUI.DrawButton( header, 120, 40 - 8, x, 4, nil, nil, nil, function() OpenDoors( panel ) save_page = OpenDoors end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_PURPLE, 4 )

        Draw.SimpleText( w / 2, h / 2, 'Doors', '28 Ambi', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )

    if save_page then
        save_page( panel )
    else
        OpenConfig( panel )
    end

    old_panel = frame
end
concommand.Add( 'ambi_darkrp_configurator', Ambi.DarkRP.OpenConfigurator )

-- ----------------------------------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_darkrp_configurator_set_config_send_new_players', function() 
    local config = net.ReadTable()

    for i, v in pairs( config ) do Ambi.DarkRP.Config[ i ] = v end
end )

net.Receive( 'ambi_darkrp_configurator_send_changed_jobs', function() 
    local changed_jobs = net.ReadTable()

    local change = false
    for i, v in pairs( changed_jobs ) do
        if v then change = true break end
    end
    if not change then return end

    Ambi.DarkRP.jobs = changed_jobs
end )

net.Receive( 'ambi_darkrp_configurator_send_changed_door_categories', function() 
    local changed_categories = net.ReadTable()

    local change = false
    for i, v in pairs( changed_categories ) do
        if v then change = true break end
    end
    if not change then return end

    Ambi.DarkRP.doors_categories = changed_categories
end )