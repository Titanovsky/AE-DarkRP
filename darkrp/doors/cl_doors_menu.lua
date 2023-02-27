local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

local function OpenDoorAdminMenu( vguiFrame, eDoor )
    local frame = GUI.DrawFrame( nil, W / 6, H / 2, 0, 0, nil, true, false, false, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.PANEL )
    end )

    local x, y = vguiFrame:GetPos()
    frame:SetPos( x + vguiFrame:GetWide() + 12, y )

    vguiFrame.OnRemove = function( self )
        if ValidPanel( frame ) then frame:Remove() end
    end

    local panel = GUI.DrawScrollPanel( frame, frame:GetWide() - 8, frame:GetTall() - 8, 4, 4 )

    local set_free = GUI.DrawButton( panel, panel:GetWide(), panel:GetTall() / 4, 0, 0, nil, nil, nil, function( self )
        net.Start( 'ambi_darkrp_set_free_door' )
            net.WriteEntity( eDoor )
        net.SendToServer()

        vguiFrame:Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color )
        Draw.Text( w / 2, h / 2, 'Освободить', UI.SafeFont( '32 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    set_free.color = C.PANEL
    GUI.OnCursor( set_free, function()
        set_free.color = ColorAlpha( C.ABS_WHITE, 5 )
    end, function()
        set_free.color = C.PANEL
    end )

    local y = set_free:GetTall() + 4
    local set_block = GUI.DrawButton( panel, panel:GetWide(), panel:GetTall() / 4, 0, y, nil, nil, nil, function( self )
        net.Start( 'ambi_darkrp_set_block_door' )
            net.WriteEntity( eDoor )
        net.SendToServer()

        vguiFrame:Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color )
        Draw.Text( w / 2, h / 2, 'Заблокировать', UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    set_block.color = C.PANEL
    GUI.OnCursor( set_block, function()
        set_block.color = ColorAlpha( C.ABS_WHITE, 5 )
    end, function()
        set_block.color = C.PANEL
    end )

    local y = set_free:GetTall() + 4 + set_block:GetTall() + 4
    local set_category = GUI.DrawButton( panel, panel:GetWide(), panel:GetTall() / 4, 0, y, nil, nil, nil, function( self )
        local menu = vgui.Create( 'DMenu', frame )
        menu:SetPos( self:GetPos() )
        menu.Paint = function( self, w, h ) Draw.Box( w, h, 0, 0, C.ABS_WHITE ) end

        for category, _ in pairs( Ambi.DarkRP.doors_categories ) do
            local button = menu:AddOption( category, function() 
                net.Start( 'ambi_darkrp_set_category_door' )
                    net.WriteString( category )
                    net.WriteEntity( eDoor )
                net.SendToServer()
            end )
        end
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color )
        Draw.Text( w / 2, h / 2, 'Назначить Категорию', UI.SafeFont( '24 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    set_category.color = C.PANEL
    GUI.OnCursor( set_category, function()
        set_category.color = ColorAlpha( C.ABS_WHITE, 5 )
    end, function()
        set_category.color = C.PANEL
    end )

    local y = set_free:GetTall() + 4 + set_block:GetTall() + 4 + set_category:GetTall() + 4
    local set_category = GUI.DrawButton( panel, panel:GetWide(), panel:GetTall() / 4 - 4 * 3, 0, y, nil, nil, nil, function( self )
        net.Start( 'ambi_darkrp_get_info_door' )
            net.WriteEntity( eDoor )
        net.SendToServer()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color )
        Draw.Text( w / 2, h / 2, 'Информация', UI.SafeFont( '36 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    set_category.color = C.PANEL
    GUI.OnCursor( set_category, function()
        set_category.color = ColorAlpha( C.ABS_WHITE, 5 )
    end, function()
        set_category.color = C.PANEL
    end )
end

local function OpenDoorFullMenu( vguiFrame, eDoor )
    local change_title = GUI.DrawButton( vguiFrame, vguiFrame:GetWide(), vguiFrame:GetTall() / 3, 0, 0, nil, nil, nil, function( self )
        vguiFrame:Clear()

        local title = GUI.DrawTextEntry( vguiFrame, vguiFrame:GetWide() - 8, 64, 4, 12, UI.SafeFont( '36 Arial' ), C.AMBI_BLACK, nil, C.AMBI_GRAY, 'Введите название', false, false )
        local change = GUI.DrawButton( vguiFrame, vguiFrame:GetWide(), vguiFrame:GetTall() / 6, 0, vguiFrame:GetTall() - ( vguiFrame:GetTall() / 6 ), nil, nil, nil, function( self )
            local title = title:GetValue()
            if not string.IsValid( title ) then title = LocalPlayer():Nick() end
            if ( utf8.len( title ) > 28 ) then return end

            net.Start( 'ambi_darkrp_change_title_door' )
                net.WriteString( title )
                net.WriteEntity( eDoor )
            net.SendToServer()

            vguiFrame:GetParent():Remove()
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, self.color )
            Draw.Text( w / 2, h / 2, 'Изменить', UI.SafeFont( '32 Arial' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
        end )
        change.color = C.PANEL
        GUI.OnCursor( change, function()
            change.color = ColorAlpha( C.ABS_WHITE, 5 )
        end, function()
            change.color = C.PANEL
        end )

    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color )
        Draw.Text( w / 2, h / 2, 'Изменить Название', UI.SafeFont( '24 Arial' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    change_title.color = C.PANEL
    GUI.OnCursor( change_title, function()
        change_title.color = ColorAlpha( C.ABS_WHITE, 5 )
    end, function()
        change_title.color = C.PANEL
    end )

    local menu
    local y = change_title:GetTall() + 4
    local add_coowner = GUI.DrawButton( vguiFrame, vguiFrame:GetWide(), vguiFrame:GetTall() / 3, 0, y, nil, nil, nil, function( self )
        if ValidPanel( menu ) then menu:Remove() end

        menu = vgui.Create( 'DMenu', vguiFrame )
        menu:SetPos( self:GetPos() )
        menu.Paint = function( self, w, h ) Draw.Box( w, h, 0, 0, C.ABS_WHITE ) end

        for _, ply in ipairs( player.GetAll() ) do
            if ( ply == LocalPlayer() ) then continue end

            local button = menu:AddOption( ply:Nick(), function() 
                net.Start( 'ambi_darkrp_set_coowner_door' )
                    net.WriteEntity( ply )
                    net.WriteEntity( eDoor )
                net.SendToServer()
            end )
        end
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color )
        Draw.Text( w / 2, h / 2, 'Добавить/Удалить Со-Владельца', UI.SafeFont( '22 Arial' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    add_coowner.color = C.PANEL
    GUI.OnCursor( add_coowner, function()
        add_coowner.color = ColorAlpha( C.ABS_WHITE, 5 )
    end, function()
        add_coowner.color = C.PANEL
    end )

    local y = change_title:GetTall() + add_coowner:GetTall() + 8
    local sell = GUI.DrawButton( vguiFrame, vguiFrame:GetWide(), vguiFrame:GetTall() / 3 - 8, 0, y, nil, nil, nil, function( self )
        net.Start( 'ambi_darkrp_sell_door' )
        net.SendToServer()

        vguiFrame:GetParent():Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color )
        Draw.Text( w / 2, h / 2, 'Продать', UI.SafeFont( '32 Arial' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    sell.color = C.PANEL
    GUI.OnCursor( sell, function()
        sell.color = ColorAlpha( C.ABS_WHITE, 5 )
    end, function()
        sell.color = C.PANEL
    end )
end

local function OpenDoorBuyMenu( vguiFrame, eDoor, nFlag )
    -- 1: Buy
    -- 2: Sell

    local button = GUI.DrawButton( vguiFrame, vguiFrame:GetWide(), vguiFrame:GetTall(), 0, 0, nil, nil, nil, function( self )
        if ( nFlag == 1 ) then
            net.Start( 'ambi_darkrp_buy_door' )
            net.SendToServer()
        elseif ( nFlag == 2 ) then
            net.Start( 'ambi_darkrp_sell_door' )
            net.SendToServer()
        end

        vguiFrame:GetParent():Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color )
        Draw.Text( w / 2, h / 2, ( nFlag == 1 ) and 'Купить' or 'Продать', UI.SafeFont( '52 Arial' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    button.color = C.PANEL

    GUI.OnCursor( button, function()
        button.color = ColorAlpha( C.ABS_WHITE, 5 )
    end, function()
        button.color = C.PANEL
    end )
end

local function OpenDoorMenu( nFlag, eDoor, nFlagBuyMenu )
    -- nFlag:
    -- 1: OpenDoorBuyMenu
    -- 2: OpenDoorFullMenu

    if not nFlag then return end
    if not IsValid( eDoor ) or not Ambi.DarkRP.Config.doors_classes[ eDoor:GetClass() ] then return end

    local frame = GUI.DrawFrame( nil, W / 4, H / 1.4, 0, 0, 'Дверь №'..eDoor:EntIndex(), true, true, true, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.PANEL )
        --Draw.Text( 4, 1, occupaited_slots..'/'..LocalPlayer():GetSlots(), '24 Arial', C.ABS_WHITE, nil, 1, C.ABS_BLACK )
    end )
    frame:Center()
    frame.OnKeyCodePressed = function( self, nKey )
        if ( nKey == KEY_SPACE ) then self:Remove() end
    end

    local panel = GUI.DrawScrollPanel( frame, frame:GetWide() - 8, frame:GetTall() - 32, 4, 32 - 4 )
    if ( nFlag == 1 ) then OpenDoorBuyMenu( panel, eDoor, nFlagBuyMenu )
    elseif ( nFlag == 2 ) then OpenDoorFullMenu( panel, eDoor )
    else frame:Remove()
    end

    return frame
end

net.Receive( 'ambi_darkrp_buy_door_request', function()
    local door = LocalPlayer():GetEyeTrace().Entity
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end
    if ( LocalPlayer():GetPos():Distance( door:GetPos() ) > 78 ) then return end

    local menu = OpenDoorMenu( 1, door, 1 )

    if LocalPlayer():IsSuperAdmin() then
        OpenDoorAdminMenu( menu, door )
    end
end )

net.Receive( 'ambi_darkrp_sell_door_request', function()
    local door = LocalPlayer():GetEyeTrace().Entity
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end
    if ( LocalPlayer():GetPos():Distance( door:GetPos() ) > 78 ) then return end

    local menu = OpenDoorMenu( 1, door, 2 )

    if LocalPlayer():IsSuperAdmin() then
        OpenDoorAdminMenu( menu, door )
    end
end )

net.Receive( 'ambi_darkrp_controll_menu_door_request', function()
    local door = LocalPlayer():GetEyeTrace().Entity
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end
    if ( LocalPlayer():GetPos():Distance( door:GetPos() ) > 78 ) then return end

    local menu = OpenDoorMenu( 2, door )

    if LocalPlayer():IsSuperAdmin() then
        OpenDoorAdminMenu( menu, door )
    end
end )