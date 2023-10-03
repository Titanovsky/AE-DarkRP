local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

local COLOR_CONTEXT = Color( 255, 255, 255, 200 )
local COLOR_LAWS = Color( 0, 0, 0, 240 )

local icons_donate = {
    'icon16/star.png',
    'icon16/lightning.png',
    'icon16/heart.png',
    'icon16/male.png',
    'icon16/ruby.png',
    'icon16/world.png',
    'icon16/cake.png',
    'icon16/pill_add.png',
    'icon16/wand.png',
    'icon16/rainbow.png',
    'icon16/rosette.png'
}

local text_pin = {
    '❖',
    '✩',
    '✪',
    '✿',
    '(͡° ͜ʖ ͡°)'
}

local icons = {
    ['shop'] = 'icon16/star.png',
    ['sellalldoors'] = 'icon16/door_open.png',
    ['ammo'] = 'icon16/bullet_black.png',
    ['advert'] = 'icon16/eye.png',
    ['money'] = 'icon16/money_delete.png',
    ['change_money'] = 'icon16/money.png',
    ['lockdown_open'] = 'icon16/bell_add.png',
    ['lockdown_close'] = 'icon16/bell_delete.png',
    ['dropweapon'] = 'icon16/arrow_down.png'
}

local pnl
local pnl2
function Ambi.DarkRP.OpenContextMenu()
    if ( LocalPlayer():Alive() == false ) then return end
    if ValidPanel( pnl ) then return pnl:Remove() end
    if ValidPanel( pnl2 ) then return pnl2:Remove() end

    if Ambi.DarkRP.Config.goverment_enable and Ambi.DarkRP.Config.goverment_laws_enable and Ambi.DarkRP.Config.cmenu_show_laws then
        local frame = GUI.DrawFrame( nil, 400, 256, W - 400 - 4, 32, '', false, false, false, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 8 )

            for i = 1, 9 do
                local law = Ambi.DarkRP.laws[ i ]
                local text = string.IsValid( law ) and i..'. '..law or ''

                Draw.SimpleText( 4, ( i - 1 ) * 28, text, UI.SafeFont( '28 Oswald Light' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
            end
        end )

        pnl2 = frame
    end

    amb_context_menu = vgui.Create( 'DMenu' )
    amb_context_menu.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, COLOR_CONTEXT )
    end

    amb_context_menu.OnRemove = function()
        if ValidPanel( pnl2 ) then pnl2:Remove() end
    end
    
    pnl = amb_context_menu

    if LocalPlayer():IsMayor() then
        local is_lockdown = GetConVar( 'ambi_darkrp_lockdown' ):GetBool()

        if Ambi.DarkRP.Config.cmenu_show_lockdown then
            local lockdown = amb_context_menu:AddOption( is_lockdown and 'Ком. Час [Выкл]' or 'Ком. Час [Вкл]', function()
                if is_lockdown then
                    if not GetConVar( 'ambi_darkrp_lockdown' ):GetBool() then return end

                    RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_lockdown_command )
                else 
                    Ambi.DarkRP.OpenBoxMenu( 'Причина', 'Включить', '', function( sReason )
                        if GetConVar( 'ambi_darkrp_lockdown' ):GetBool() then return end

                        RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_lockdown_command..' '..sReason )
                    end )
                end
            end )
            lockdown:SetImage( is_lockdown and icons.lockdown_close or icons.lockdown_open )
            lockdown:SetFont( '18 Ambi' )
        end

        if Ambi.DarkRP.Config.cmenu_show_laws then
            local sub_setlaw, ed = amb_context_menu:AddSubMenu( 'Изменить Законы' )
            ed:SetImage( 'icon16/book.png' )
            for i, law in ipairs( Ambi.DarkRP.Laws() ) do
                local setlaw = sub_setlaw:AddOption( '['..i..'] '..law, function()
                    Ambi.DarkRP.OpenBoxMenu( 'Закон '..i, 'Изменить', "", function( sLaw ) 
                        RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_laws_set_command..' '..i..' '..sLaw )
                    end )
                end )
                setlaw:SetImage( 'icon16/bullet_go.png' )
            end
            ed:SetFont( '18 Ambi' )

            local clearlaws = amb_context_menu:AddOption( 'Очистить Законы', function()
                RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_laws_clear_command )
            end )
            clearlaws:SetImage( 'icon16/book_addresses.png' )
            clearlaws:SetFont( '18 Ambi' )
        end

        if Ambi.DarkRP.Config.cmenu_show_license then
            local givelicense = amb_context_menu:AddOption( 'Выдать Лицензию на Оружие', function()
                RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_license_gun_command )
            end )
            givelicense:SetImage( 'icon16/page_add.png' )
            givelicense:SetFont( '18 Ambi' )

            local removelicense = amb_context_menu:AddOption( 'Отобрать Лицензию на Оружие', function()
                RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_license_gun_remove_command )
            end )
            removelicense:SetImage( 'icon16/page_delete.png' )
            removelicense:SetFont( '18 Ambi' )

            local checklicense = amb_context_menu:AddOption( 'Проверить Лицензию на Оружие', function()
                RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.goverment_license_gun_check_command )
            end )
            checklicense:SetImage( 'icon16/page_error.png' )
            checklicense:SetFont( '18 Ambi' )
        end
    end

    amb_context_menu:AddSpacer()

    if Ambi.DarkRP.Config.cmenu_show_donate then
        local delay = 0
        local pin = table.Random( text_pin )
        local donate = amb_context_menu:AddOption( pin..' Магазин '..pin, function() 
            RunConsoleCommand( 'say', '/donate' )
            surface.PlaySound( 'ui/buttonclick.wav' )
        end )
        donate:SetImage( icons.shop )
        donate:SetFont( UI.SafeFont( '22 Ambi' ) )
        donate.Think = function()
            donate:SetTextColor( HSVToColor(  ( CurTime() * 22 ) % 360, 1, 1 ) )
            if ( CurTime() > delay ) then
                delay = CurTime() + 1.25
                donate:SetImage( table.Random( icons_donate ) )
            end
        end
        donate.OnCursorEntered = function()
            surface.PlaySound( 'ui/buttonrollover.wav' )
        end
        amb_context_menu:AddSpacer()
    end

    if LocalPlayer():IsPolice() then
        if Ambi.DarkRP.Config.cmenu_show_wanted then
            local sub_wanted, ed = amb_context_menu:AddSubMenu( 'Розыск' )
            ed:SetImage( "icon16/group_edit.png" )
            for _, ply in ipairs( player.GetAll() ) do
                if ( LocalPlayer() == ply ) or ply:IsArrested() or ( ply:Alive() == false ) then continue end

                local wanted = sub_wanted:AddOption( ply:Nick(), function()
                    if not IsValid( ply ) then return end
                    if not Ambi.DarkRP.Config.police_system_enable then return end
                    if not Ambi.DarkRP.Config.police_system_wanted_enable then return end
                    if not LocalPlayer():IsPolice() then return end

                    if ply:IsWanted() then
                        net.Start( 'ambi_darkrp_police_wanted' )
                            net.WriteEntity( ply )
                            net.WriteString( '' )
                        net.SendToServer()
                    else
                        Ambi.DarkRP.OpenBoxMenu( "Причина", "Объявить", "", function( sReason ) 
                            if not LocalPlayer():IsPolice() then return end
                            if not Ambi.DarkRP.Config.police_system_enable then return end
                            if not Ambi.DarkRP.Config.police_system_wanted_enable then return end
                            if not IsValid( ply ) then return end
                            if ( utf8.len( sReason ) > 32 ) then return end
                            if ply:IsWanted() or ply:IsArrested() then return end

                            net.Start( 'ambi_darkrp_police_wanted' )
                                net.WriteEntity( ply )
                                net.WriteString( sReason )
                            net.SendToServer()
                        end )
                    end
                end )
                wanted:SetImage( ply:IsWanted() and 'icon16/user_delete.png' or 'icon16/user_add.png' )
            end
            ed:SetFont( UI.SafeFont( '18 Ambi' ) )
        end

        if Ambi.DarkRP.Config.cmenu_show_warrant then
            local sub, ed = amb_context_menu:AddSubMenu( 'Ордер на Обыск' )
            ed:SetImage( 'icon16/group_edit.png' )
            for _, ply in ipairs( player.GetAll() ) do
                --if ( LocalPlayer() == ply ) then continue end

                local warrant = sub:AddOption( ply:Nick(), function()
                    local delay = LocalPlayer():GetDelay( 'AmbiDarkRPWarrantDelay' )
                    if not delay then LocalPlayer():SetDelay( 'AmbiDarkRPWarrantDelay', Ambi.DarkRP.Config.police_system_warrant_delay + 1 ) else chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: '..tostring( delay ) ) return end

                    if ply:HasWarrant() then
                        if not LocalPlayer():IsPolice() then return end
                        if not Ambi.DarkRP.Config.police_system_enable then return end
                        if not Ambi.DarkRP.Config.police_system_warrant_enable then return end
                        if not IsValid( ply ) then return end

                        net.Start( 'ambi_darkrp_police_warrant' )
                            net.WriteEntity( ply )
                            net.WriteString( '' )
                        net.SendToServer()
                    else
                        Ambi.DarkRP.OpenBoxMenu( "Причина", "Объявить", "", function( sReason ) 
                            if not LocalPlayer():IsPolice() then return end
                            if not Ambi.DarkRP.Config.police_system_enable then return end
                            if not Ambi.DarkRP.Config.police_system_warrant_enable then return end
                            if not IsValid( ply ) then return end
                            if ( utf8.len( sReason ) > 32 ) then return end

                            net.Start( 'ambi_darkrp_police_warrant' )
                                net.WriteEntity( ply )
                                net.WriteString( sReason )
                            net.SendToServer()
                        end )
                    end
                end )
                warrant:SetImage( ply:HasWarrant() and 'icon16/user_delete.png' or 'icon16/user_add.png' )
            end
            ed:SetFont( UI.SafeFont( '18 Ambi' ) )
        end

        amb_context_menu:AddSpacer()
    end

    if Ambi.DarkRP.Config.doors_sell_all_doors_can and Ambi.DarkRP.Config.cmenu_show_sellalldoors then
        local sellalldoors = amb_context_menu:AddOption( 'Продать Все Двери', function() 
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.doors_sell_all_command ) 
        end )
        sellalldoors:SetImage( icons.sellalldoors )
        sellalldoors:SetFont( UI.SafeFont( '18 Ambi' ) )
    end

    if Ambi.DarkRP.Config.buy_auto_ammo_enable and Ambi.DarkRP.Config.cmenu_show_buyautoammo then
        local ammo = amb_context_menu:AddOption( 'Купить Патроны', function() 
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.buy_auto_ammo_command )
        end ) 
        ammo:SetImage( icons.ammo )
        ammo:SetFont( UI.SafeFont( '18 Ambi' ) )
    end

    if Ambi.DarkRP.Config.advert_enable and Ambi.DarkRP.Config.cmenu_show_advert then
        local advert = amb_context_menu:AddOption( 'Подать Рекламу', function() 
            Ambi.DarkRP.OpenBoxMenu( 'Реклама', 'Подать', '', function( str ) RunConsoleCommand( 'say', '/advert '..str ) end )
        end )
        advert:SetImage( icons.advert )
        advert:SetFont( UI.SafeFont( '18 Ambi' ) )
    end

    amb_context_menu:AddSpacer()

    if Ambi.DarkRP.Config.cmenu_show_demote then 
        local sub_demote, ed = amb_context_menu:AddSubMenu( 'Уволить' )
        ed:SetImage( 'icon16/user_delete.png' )
        local demote_front = sub_demote:AddOption( 'Игрок Напротив', function()
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.jobs_demote_command )
        end )
        demote_front:SetImage( 'icon16/user.png' )
        for _, ply in pairs( player.GetAll() ) do
            if ( LocalPlayer() == ply ) then continue end
            if ( ply:Job() == Ambi.DarkRP.Config.jobs_class ) then continue end

            local demote = sub_demote:AddOption( ply:Nick(), function()
                if not IsValid( ply ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Игрок вышел с сервера!' ) return end
                if ( ply:Job() == Ambi.DarkRP.Config.jobs_class ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Игрок в стандартной работе, его нельзя уволить!' ) return end
                if not LocalPlayer():GetDelay( 'AmbiDarkRPDemote' ) then LocalPlayer():SetDelay( 'AmbiDarkRPDemote', 1 ) else return end

                net.Start( 'ambi_darkrp_demote_player' )
                    net.WriteEntity( ply )
                net.SendToServer()
            end )
            demote:SetImage( 'icon16/bullet_delete.png' )
        end
        ed:SetFont( UI.SafeFont( '18 Ambi' ) )
    end

    amb_context_menu:AddSpacer()

    if Ambi.DarkRP.Config.cmenu_show_givemoney then
        local givemoney = amb_context_menu:AddOption( 'Передать Деньги', function() 
            if ( LocalPlayer():GetMoney() <= 0 ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'У вас нет денег!' ) return end

            local ply = LocalPlayer():GetEyeTrace().Entity
            if not IsValid( ply ) or not ply:IsPlayer() then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя передать деньги!' ) return end
            if ( LocalPlayer():Distance( ply ) > Ambi.DarkRP.Config.money_give_distance ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя передать деньги на таком расстояний!' ) return end

            Ambi.DarkRP.OpenBoxMenu( 'Сумма', 'Передать', '', function( summ ) RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.money_give_command..' '..summ ) end )
        end )
        givemoney:SetImage( icons.money )
        givemoney:SetFont( UI.SafeFont( '18 Ambi' ) )
    end

    if Ambi.DarkRP.Config.cmenu_show_dropmoney then
        local dropmoney = amb_context_menu:AddOption( 'Выкинуть Деньги', function() 
            if ( LocalPlayer():GetMoney() <= 0 ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'У вас нет денег!' ) return end

            Ambi.DarkRP.OpenBoxMenu( 'Сумма', 'Выкинуть', '', function( summ ) RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.money_drop_command..' '..summ ) end )
        end )
        dropmoney:SetImage( icons.change_money )
        dropmoney:SetFont( UI.SafeFont( '18 Ambi' ) )
    end

    amb_context_menu:AddSpacer()

    if Ambi.DarkRP.Config.cmenu_show_dropgun then
        local dropgun = amb_context_menu:AddOption( 'Выкинуть оружие', function() 
            RunConsoleCommand( 'say', '/'..Ambi.DarkRP.Config.weapon_drop_command )
        end )
        dropgun:SetImage( icons.dropweapon )
        dropgun:SetFont( UI.SafeFont( '18 Ambi' ) )
    end

    amb_context_menu:Open()
    amb_context_menu:SetPos( W / 2 - amb_context_menu:GetWide() / 2, H - amb_context_menu:GetTall() - 8 )
end

function Ambi.DarkRP.OpenBoxMenu( sTitle, sBtn, sText, func )
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
    amb_context_framebox_te:SetText( sText )
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

--
hook.Add( 'OnContextMenuOpen', 'Ambi.DarkRP.OpenContexMenu', function()
    if not Ambi.DarkRP.Config.cmenu_enable then return end
    
    timer.Simple( 0, function() Ambi.DarkRP.OpenContextMenu() end )
end )

hook.Add( 'OnContextMenuClose', 'Ambi.DarkRP.CloseContexMenu', function()
    if not Ambi.DarkRP.Config.cmenu_enable then return end
    
    if ValidPanel( pnl2 ) then pnl2:Remove() end
end )
