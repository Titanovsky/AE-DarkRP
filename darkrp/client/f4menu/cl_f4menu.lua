local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local CacheURL = Ambi.Cache.CacheURL
local W, H = ScrW(), ScrH()
local COLOR_LINE, COLOR_BLUE = ColorAlpha( C.ABS_BLACK, 150 ), Color( 0, 145, 255 )
local save_page

function Ambi.DarkRP.OpenF4Menu()
    if not Ambi.DarkRP.Config.f4menu_enable then return end

    local ambi_market_banner = Material( Ambi.Cache.GetCacheFile( 'ambi_market_banner.png' ) )
    if ambi_market_banner:IsError() then Ambi.Cache.CacheURL( 'ambi_market_banner.png', 'https://i.ibb.co/Q8h58p2/ambi-market-banner1.png', 12 ) end

    local w, h = W / 1.6, H / 1.6
    local frame = GUI.DrawFrame( nil, w, h, W / 2 - w / 2, H / 2 - h / 2, '', true, false, false, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 8 )
        Draw.Box( w, 2, 0, 22, COLOR_LINE, 8 )
    end )
    frame.OnKeyCodePressed = function( self, nKey )
        if ( nKey == KEY_F4 ) then self:Remove() end
    end
    frame.OnRemove = function( self )
        timer.Create( 'AmbiDarkRPF4Menu', 0.25, 1, function() end )
    end
    frame:Center()

    local top_header_ambi_market = GUI.DrawButton( frame, frame:GetWide() / 4, 22, 0, 0, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        gui.OpenURL( 'https://vk.com/@ambi_market-guide-how-to-create-darkrp' ) -- Заменить на статью про DarkRP
    end, function( self, w, h ) 
        Draw.Box( w - 2, h, 0, 0, self.color, 8, 'top-left' )
        Draw.Box( 2, h, w - 2, 0, COLOR_LINE, 8 )

        Draw.SimpleText( w / 2, h / 2, self.text, UI.SafeFont( '32 Oswald Light' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    top_header_ambi_market.color = C.AMBI_BLACK
    top_header_ambi_market.text = ''
    GUI.OnCursor( top_header_ambi_market, function()
        top_header_ambi_market.color = ColorAlpha( C.ABS_WHITE, 20 )
        top_header_ambi_market.text = 'DarkRP'
    end, function() 
        top_header_ambi_market.color = C.AMBI_BLACK
        top_header_ambi_market.text = ''
    end )

    local top_header_ambi = GUI.DrawButton( frame, frame:GetWide() - top_header_ambi_market:GetWide() + 2, 22, top_header_ambi_market:GetWide(), 0, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        gui.OpenURL( 'https://vk.com/ambi_team' )
    end, function( self, w, h ) 
        Draw.SimpleText( w / 2, 2, GetHostName(), UI.SafeFont( '20 Ambi' ), C.ABS_WHITE, 'top-center', 1, C.ABS_BLACK )
    end )
    top_header_ambi:SetCursor( 'arrow' )

    local pages = GUI.DrawScrollPanel( frame, frame:GetWide() / 4, frame:GetTall() - 24, 0, 24, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 8, 'bottom-left' )
        Draw.Box( 2, h, w - 2, 0, COLOR_LINE, 8 )
    end )

    local main = GUI.DrawScrollPanel( frame, frame:GetWide() - pages:GetWide(), frame:GetTall() - 24, pages:GetWide(), 24, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_WHITE, 8, 'bottom-right' )
    end )

    local buttons = {}
    for i = 1, 5 do
        local page = GUI.DrawButton( pages, pages:GetWide(), pages:GetTall() / 5, 0, ( i - 1 ) * ( pages:GetTall() / 5 ), nil, nil, nil, function( self ) 
            if not self.Action then return end

            main:Clear()
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )
            self.Action( self )
            save_page = i
        end, function( self, w, h ) 
            if ( i != 1 ) then Draw.Box( w, 2, 0, 0, COLOR_LINE ) end
            Draw.SimpleText( w / 2, h / 2, self.text, UI.SafeFont( '38 Ambi' ), self.color, 'center', 1, C.ABS_BLACK )
        end )
        page.text = ''
        page.color = C.ABS_WHITE
        GUI.OnCursor( page, function()
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 75, .1 ) 
            page.color = ( i % 2 == 0 ) and C.AMBI_BLUE or C.AMBI
        end, function() 
            page.color = C.ABS_WHITE
        end )

        buttons[ i ] = page
    end

    local home = buttons[ 1 ]
    if Ambi.DarkRP.Config.f4menu_show_home then
        home.text = Ambi.DarkRP.Config.f4menu_header_home
        home.Action = function()
            local panel = GUI.DrawPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h ) 
                Draw.SimpleText( 136, 4, LocalPlayer():Nick(), UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
                Draw.SimpleText( 136, 28 * 1, LocalPlayer():JobName(), UI.SafeFont( '26 Ambi' ), LocalPlayer():TeamColor(), 'top-left', 1, C.ABS_BLACK )
                Draw.SimpleText( 136, 28 * 2, LocalPlayer():GetMoney()..Ambi.DarkRP.Config.money_currency_symbol, UI.SafeFont( '26 Nexa Script Light' ), C.AMBI_GREEN, 'top-left', 1, C.ABS_BLACK )

                Draw.Box( w, 2, 0, 128, C.AMBI_BLACK )
                Draw.Box( 2, 128, 128, 0, C.AMBI_BLACK )
            end )

            GUI.DrawAvatar( panel, 128, 128, 0, 0, 128 )

            local banner = GUI.DrawButton( panel, 144, 94, panel:GetWide() - 144 - 4, panel:GetTall() - 94 - 4, nil, nil, nil, function()
                gui.OpenURL( 'https://vk.com/ambi_market' )
            end, function( self, w, h ) 
                Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 8 )
                Draw.Box( w - 4, h - 4, 2, 2, self.color, 8 )
                Draw.Material( w, h, 0, 0, ambi_market_banner )
            end )
            banner.color = C.AMBI_WHITE
            banner:SetTooltip( 'Ambi Market — место, где можно Создать DarkRP и Заказать Отличные Скрипты :)' )

            GUI.OnCursor( banner, function()
                banner.color = COLOR_BLUE

                LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
            end, function() 
                banner.color = C.AMBI_WHITE
            end )
        end
    end

    local jobs = buttons[ 2 ]
    if Ambi.DarkRP.Config.f4menu_show_jobs then
        jobs.text = Ambi.DarkRP.Config.f4menu_header_jobs
        jobs.Action = function()
            local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
            end )

            local i = -1
            for class, job in SortedPairsByMemberValue( Ambi.DarkRP.GetJobs(), 'category' ) do
                if not job then continue end
                if not Ambi.DarkRP.Config.f4menu_show_restrict_items_and_jobs then
                    local class = job.from 
                    if class then
                        if isstring( class ) then
                            if ( LocalPlayer():Job() != class ) then continue end
                        elseif isnumber( class ) then
                            if ( LocalPlayer():Team() != class ) then continue end
                        end
                    end
                end

                i = i + 1

                local count_workers = #team.GetPlayers( job.index )

                local job_panel = GUI.DrawButton( panel, panel:GetWide(), 64, 0, 64 * i, nil, nil, nil, function()
                    LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

                    if ( LocalPlayer():Job() == class ) then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя поменять работу на свою же работу!' ) return frame:Remove() end
                    
                    if ( #job.models == 1 ) then
                        if timer.Exists( 'BlockF4MenuSetJob' ) then return end
                        timer.Create( 'BlockF4MenuSetJob', 1.25, 1, function() end )

                        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

                        net.Start( 'ambi_darkrp_f4menu_set_job' )
                            net.WriteString( class )
                            net.WriteUInt( 1, 10 )
                        net.SendToServer()

                        frame:Remove()
                    else
                        panel:Clear()

                        local i = -1
                        for index, model in ipairs( job.models ) do
                            local name = string.Explode( '/', model )
                            name = name[ #name ]

                            name = string.Explode( '.', name )
                            name = name[ 1 ]

                            i = i + 1
                            local job_model = GUI.DrawButton( panel, panel:GetWide(), 64, 0, 64 * i, nil, nil, nil, function()
                                if timer.Exists( 'BlockF4MenuSetJob' ) then return end
                                timer.Create( 'BlockF4MenuSetJob', 1.25, 1, function() end )

                                LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

                                net.Start( 'ambi_darkrp_f4menu_set_job' )
                                    net.WriteString( class )
                                    net.WriteUInt( index, 10 )
                                net.SendToServer()

                                frame:Remove()
                            end, function( self, w, h ) 
                                Draw.Box( w, h, 0, 0, self.col )
                                Draw.SimpleText( 68, h / 2, name, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
                            end )
                            job_model.col = C.AMBI_WHITE

                            GUI.OnCursor( job_model, function()
                                job_model.col = ColorAlpha( C.ABS_BLACK, 100 )

                                LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
                            end, function() 
                                job_model.col = C.AMBI_WHITE
                            end )

                            GUI.DrawModel( job_model, 64, 64, 0, 0, model )
                        end
                    end
                end, function( self, w, h ) 
                    Draw.Box( w, h, 0, 0, self.col )
                    Draw.SimpleText( 68, 4, job.name, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
                    Draw.Box( w, 4, 0, h - 4, C.AMBI_RED )

                    if job.max and ( job.max >= 1 ) then 
                        Draw.SimpleText( w - 18, h / 2, count_workers..'/'..job.max, UI.SafeFont( '18 Ambi' ), count_workers >= job.max and C.AMBI_RED or C.ABS_BLACK, 'center-right' ) 
                    end
                end )
                job_panel.col = C.AMBI_WHITE
                job_panel:SetTooltip( job.description )

                GUI.OnCursor( job_panel, function()
                    job_panel.col = ColorAlpha( job.color, 100 )

                    LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
                end, function() 
                    job_panel.col = C.AMBI_WHITE
                end )
                
                GUI.DrawModel( job_panel, 64, 64, 0, 0, job.models[ 1 ] )

                local line = GUI.DrawPanel( job_panel, job_panel:GetWide(), 8, 0, job_panel:GetTall() - 8, function( self, w, h ) 
                    Draw.Box( w, h, 0, 0, job.color )
                end )
            end
        end
    end

    local shop = buttons[ 3 ]
    if Ambi.DarkRP.Config.f4menu_show_shop then
        shop.text = Ambi.DarkRP.Config.f4menu_header_shop
        shop.Action = function()
            local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
            end )

            local i = -1
            for class, item in SortedPairsByMemberValue( Ambi.DarkRP.GetShop(), 'category' ) do
                if not item then continue end
                if not Ambi.DarkRP.Config.f4menu_show_restrict_items_and_jobs then
                    if item.allowed then
                        local can

                        for _, job in ipairs( item.allowed ) do
                            if isnumber( job ) and ( LocalPlayer():Team() == job ) then can = true break 
                            elseif isstring( job ) and ( LocalPlayer():GetJob() == job ) then can = true break 
                            end
                        end

                        if not can then continue end
                    end
                end

                i = i + 1

                local price = item.GetPrice and item.GetPrice( LocalPlayer(), item ) or item.price

                local item_panel = GUI.DrawButton( panel, panel:GetWide(), 64, 0, 64 * i, nil, nil, nil, function()
                    LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )
                    
                    if timer.Exists( 'BlockF4MenuBuyItem' ) then return end
                    timer.Create( 'BlockF4MenuBuyItem', 1, 1, function() end )

                    LocalPlayer():ConCommand( 'say /'..Ambi.DarkRP.Config.shop_buy_command..' '..class )
                end, function( self, w, h ) 
                    Draw.Box( w, h, 0, 0, self.col )
                    Draw.SimpleText( 68, 4, item.name, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'top-left', 1, C.ABS_BLACK )
                    Draw.SimpleText( 68, 4 + 28, price..Ambi.DarkRP.Config.money_currency_symbol, UI.SafeFont( '24 Nexa Script Light' ), LocalPlayer():GetMoney() >= price and C.AMBI_GREEN or C.AMBI_RED, 'top-left', 1, C.ABS_BLACK )
                    Draw.Box( w, 2, 0, h - 2, C.AMBI_BLACK )
                end )
                item_panel.col = C.AMBI_WHITE
                item_panel:SetTooltip( item.description )

                GUI.OnCursor( item_panel, function()
                    item_panel.col = ColorAlpha( C.ABS_WHITE, 50 )

                    LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
                end, function() 
                    item_panel.col = C.AMBI_WHITE
                end )
                
                GUI.DrawModel( item_panel, 64, 64, 0, 0, item.model )

                local line = GUI.DrawPanel( item_panel, item_panel:GetWide(), 8, 0, item_panel:GetTall() - 8, function( self, w, h ) 
                    --Draw.Box( w, h, 0, 0, item.color )
                end )
            end
        end
    end

    local settings = buttons[ 4 ]
    if Ambi.DarkRP.Config.f4menu_show_settings then
        settings.text = Ambi.DarkRP.Config.f4menu_header_settings
        settings.Action = function()
            local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h )
                Draw.Text( w / 2 - 84, h / 2, 'Скачайте модуль ', UI.SafeFont( '36 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK ) 
                Draw.Text( w / 2 + 104, h / 2 + 2, 'Ambi Opti', UI.SafeFont( '36 Ambi' ), C.AMBI_BLUE, 'center', 1, C.ABS_BLACK ) 
            end )

            local button = GUI.DrawButton( panel, panel:GetWide(), panel:GetTall(), 0, 0, nil, nil, nil, function()
                gui.OpenURL( 'https://github.com/Titanovsky/AE-Opti' )
            end, function( self, w, h ) 
            end )
        end
    end

    local cmd_list = {}
    cmd_list[ 'Продать Все Двери' ] = Ambi.DarkRP.Config.doors_sell_all_command
    cmd_list[ 'Купить Патроны' ] = Ambi.DarkRP.Config.buy_auto_ammo_command
    cmd_list[ 'Выкинуть Оружие' ] = Ambi.DarkRP.Config.weapon_drop_command
    cmd_list[ 'Вкл/Выкл Комендантский Час' ] = Ambi.DarkRP.Config.goverment_lockdown_command

    local commands = buttons[ 5 ]
    if Ambi.DarkRP.Config.f4menu_show_commands then
        commands.text = Ambi.DarkRP.Config.f4menu_header_commands
        commands.Action = function()
            local panel = GUI.DrawScrollPanel( main, main:GetWide(), main:GetTall(), 0, 0, function( self, w, h ) 
            end )

            local i = -1
            for name, command in pairs( cmd_list ) do
                if not command then continue end
                if ( command == Ambi.DarkRP.Config.goverment_lockdown_command ) and not LocalPlayer():IsMayor() then continue end

                local command = '/'..command

                i = i + 1
                
                local tw = Draw.GetTextSizeX( UI.SafeFont( '22 Ambi' ), name ) + 24
                local panel = GUI.DrawButton( panel, panel:GetWide(), 34, 0, 34 * i, nil, nil, nil, function()
                    LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )
                    
                    LocalPlayer():ConCommand( 'say '..command )
                end, function( self, w, h ) 
                    Draw.Box( w, h, 0, 0, self.col )
                    Draw.SimpleText( w / 2, h / 2, name, UI.SafeFont( '22 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
                    Draw.Box( tw, 2, w / 2 - tw / 2, h - 2, C.AMBI_BLACK )
                end )
                panel.col = C.AMBI_WHITE
                panel:SetTooltip( command )

                GUI.OnCursor( panel, function()
                    panel.col = ColorAlpha( C.ABS_BLACK, 100 )

                    LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 25, .1 ) 
                end, function() 
                    panel.col = C.AMBI_WHITE
                end )
            end
        end
    end

    if Ambi.DarkRP.Config.f4menu_show_home and not save_page then home.Action() else buttons[ save_page ].Action() end
end
concommand.Add( 'ambi_darkrp_f4menu_open', Ambi.DarkRP.OpenF4Menu )

hook.Add( 'PlayerButtonDown', 'Ambi.DarkRP.OpenF4Menu', function( _, nButton ) 
    if timer.Exists( 'AmbiDarkRPF4Menu' ) then return end

    if input.IsKeyDown( KEY_F4 ) then
        timer.Create( 'AmbiDarkRPF4Menu', 0.25, 1, function() end )

        Ambi.DarkRP.OpenF4Menu()
    end
end )