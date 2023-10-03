local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

local COLOR_PANEL = Color( 0, 0, 0, 220 )
local COLOR_TAB = Color(78,77,77)

local NUMBERS_STR = {
    [ '0' ] = 0,
    [ '1' ] = 1,
    [ '2' ] = 2,
    [ '3' ] = 3,
    [ '4' ] = 4,
    [ '5' ] = 5,
    [ '6' ] = 6,
    [ '7' ] = 7,
    [ '8' ] = 8,
    [ '9' ] = 9,
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
local function IsNumber( sStr )
    for i = 1, #sStr do
        if not NUMBERS_STR[ sStr[ i ] ] then return false end
    end

    return true
end

local function OpenTable( tTab, canvas, vguiPanelModels )
    local frame = GUI.DrawPanel( canvas, 600, 400, canvas:GetWide() / 2 - 600 / 2, 36, function( self, w, h )
        Draw.Box( w, h, 0, 0, COLOR_TAB )
    end )

    local close = GUI.DrawButton( frame, 32, 32, 4, 4, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        frame:Remove()
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_RED )
    
        Draw.SimpleText( w / 2, h / 2, 'x', UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )

    local panels = GUI.DrawScrollPanel( frame, frame:GetWide(), frame:GetTall(), 0, 40, function( self, w, h )
        -- Draw.Box( w, h, 0, 0, C.AMBI_GREEN ) -- debug
    end )

    local tall = 0
    local i = 1
    for k, v in pairs( tTab ) do
        local panel = GUI.DrawPanel( panels, panels:GetWide() - 40, 40, 0, ( 40 + 4 ) * ( i - 1 ), function( self, w, h )
            -- Draw.Box( w, h, 0, 0, C.AMBI_RED ) -- debug
        end )

        local remove = GUI.DrawButton( panels, panels:GetWide() - panel:GetWide(), 40, panels:GetWide() - ( panels:GetWide() - panel:GetWide() ), ( 40 + 4 ) * ( i - 1 ), nil, nil, nil, function()
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

            tTab[ k ] = nil

            if vguiPanelModels then
                for i = 1, #vguiPanelModels.models do
                    vguiPanelModels.models[ i ]:Remove()
                end

                local i = 0
                for _, model in pairs( tTab ) do
                    local mdl = GUI.DrawModel( vguiPanelModels, 64, 64, ( 64 + 4 ) * i, 0, model )

                    i = i + 1

                    vguiPanelModels.models[ i ] = mdl
                end
            end

            PrintTable( tTab )
     
            frame:Remove()
            OpenTable( tTab, canvas )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.AMBI_RED )
        
            Draw.SimpleText( w / 2, h / 2, '-', UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
        end )

        local te_key = GUI.DrawTextEntry( panel, panel:GetWide() * 0.4, panel:GetTall(), 0, 0, UI.SafeFont( '24 Ambi' ), nil, tostring( k ), C.AMBI_GRAY, tostring( k ), false ) -- ? the last argument is "Multiline" bad works with Enter, how to fix
        te_key.OnLoseFocus = function( self )
            local new_key = self:GetValue() or ''

            if NUMBERS_STR[ new_key[ 1 ] ] then
                new_key = tonumber( new_key )
            end
            
            tTab[ new_key ] = v
            tTab[ k ] = nil

            if vguiPanelModels then
                for i = 1, #vguiPanelModels.models do
                    vguiPanelModels.models[ i ]:Remove()
                end

                local i = 0
                for _, model in pairs( tTab ) do
                    local mdl = GUI.DrawModel( vguiPanelModels, 64, 64, ( 64 + 4 ) * i, 0, model )

                    i = i + 1

                    vguiPanelModels.models[ i ] = mdl
                end
            end

            k = new_key

            surface.PlaySound( 'Click17' )
        end
        te_key.OnEnter = te_key.OnLoseFocus

        local te_value = GUI.DrawTextEntry( panel, panel:GetWide() - te_key:GetWide() - 4, panel:GetTall(), te_key:GetWide() + 4, 0, UI.SafeFont( '24 Ambi' ), nil, tostring( v ), C.AMBI_GRAY, tostring( v ), false ) -- ? the last argument is "Multiline" bad works with Enter, how to fix
        te_value.OnLoseFocus = function( self )
            local new_value = self:GetValue() or ''

            if IsNumber( new_value ) then
                new_value = tonumber( new_value )
            end

            tTab[ k ] = new_value

            if vguiPanelModels then
                for i = 1, #vguiPanelModels.models do
                    vguiPanelModels.models[ i ]:Remove()
                end

                local i = 0
                for _, model in pairs( tTab ) do
                    local mdl = GUI.DrawModel( vguiPanelModels, 64, 64, ( 64 + 4 ) * i, 0, model )

                    i = i + 1

                    vguiPanelModels.models[ i ] = mdl
                end
            end

            v = new_value

            surface.PlaySound( 'Click18' )
        end
        te_value.OnEnter = te_key.OnLoseFocus

        i = i + 1

        tall = tall + panel:GetTall() + 4
    end

    local add = GUI.DrawButton( panels, panels:GetWide(), 32, 0, tall, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        tTab[ #tTab + 1 ] = 'value'

        frame:Remove()
        OpenTable( tTab, canvas )

        PrintTable( tTab )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_GREEN )
    
        Draw.SimpleText( w / 2, h / 2, '+', UI.SafeFont( '32 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
end

local function DrawText( tJob, k, panel )
    local entry = GUI.DrawTextEntry( panel, panel:GetWide(), panel:GetTall(), 0, 0, UI.SafeFont( '32 Ambi' ), nil, tostring( tJob[ k ] ), C.AMBI_GRAY, tostring( tJob[ k ] ), false ) -- ? the last argument is "Multiline" bad works with Enter, how to fix
    entry.OnLoseFocus = function( self )
        tJob[ k ] = self:GetValue() 
    end
    entry.OnEnter = entry.OnLoseFocus
end

local function DrawNumber( tJob, k, panel )
    local entry = GUI.DrawTextEntry( panel, panel:GetWide(), panel:GetTall(), 0, 0, UI.SafeFont( '32 Ambi' ), nil, tostring( tJob[ k ] ), C.AMBI_GRAY, tostring( tJob[ k ] ), false, true ) -- ? the last argument is "Multiline" bad works with Enter, how to fix
    entry.OnLoseFocus = function( self )
        local val = self:GetValue()
        if not string.IsValid( val ) then return end
        if not IsNumber( val ) then return end

        tJob[ k ] = tonumber( self:GetValue() )
    end
    entry.OnEnter = entry.OnLoseFocus
end

local function DrawColor( tJob, k, panel )
    local value = tJob[ k ]
    local entry = GUI.DrawTextEntry( panel, panel:GetWide() - 120, panel:GetTall(), 0, 0, UI.SafeFont( '32 Ambi' ), nil, tostring( tJob[ k ] ), C.AMBI_GRAY, tostring( tJob[ k ] ), false ) -- ? the last argument is "Multiline" bad works with Enter, how to fix
    entry.OnLoseFocus = function( self )
        local tab_value = string.Explode( ' ', self:GetValue() )
        value = Color( tonumber( tab_value[ 1 ] or 255 ), tonumber( tab_value[ 2 ] or 255 ), tonumber( tab_value[ 3 ] or 255 ), tonumber( tab_value[ 4 ] or 255 ) )

        tJob[ k ] = value 
    end
    entry.OnEnter = entry.OnLoseFocus  

    local block = GUI.DrawPanel( panel, 120, panel:GetTall(), entry:GetWide(), 0, function( self, w, h )
        Draw.Box( w, h, 0, 0, value )
    end )
end

local function DrawBool( tJob, k, panel )
    local btn = GUI.DrawButton( panel, panel:GetWide(), panel:GetTall(), 0, 0, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        tJob[ k ] = not tJob[ k ]
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.COLOR_PANEL )
    
        Draw.SimpleText( w/ 2, h / 2, tostring( tJob[ k ] ), UI.SafeFont( '26 Ambi' ), tJob[ k ] and C.GREEN or C.RED, 'center-left', 1, C.ABS_BLACK )
    end )
end

local function DrawModels( tJob, k, panel )
    panel.models = {}

    local i = 0
    for _, model in pairs( tJob[ k ] ) do
        local mdl = GUI.DrawModel( panel, 64, 64, ( 64 + 4 ) * i, 0, model )

        i = i + 1

        panel.models[ i ] = mdl
    end

    local btn = GUI.DrawButton( panel, panel:GetWide(), panel:GetTall(), 0, 0, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        OpenTable( tJob[ k ], panel.canvas, panel )
    end, function( self, w, h ) 
    end )
end

local function DrawTab( tJob, k, panel )
    local btn = GUI.DrawButton( panel, panel:GetWide(), panel:GetTall(), 0, 0, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        OpenTable( tJob[ k ], panel.canvas )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, COLOR_PANEL )
    
        Draw.SimpleText( w / 2, h / 2, tostring( k ), UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
end

local KEYS = {
    [ 'class' ] = { header = 'Класс', Draw = DrawText },
    [ 'name' ] = { header = 'Название', Draw = DrawText },
    [ 'description' ] = { header = 'Описание', Draw = DrawText },
    [ 'color' ] = { header = 'Цвет', Draw = DrawColor },
    [ 'models' ] = { header = 'Модели', Draw = DrawModels },
    [ 'weapons' ] = { header = 'Оружия', Draw = DrawTab },
    [ 'max' ] = { header = 'Максимум', Draw = DrawNumber },
    [ 'salary' ] = { header = 'Зарплата', Draw = DrawNumber },
    [ 'admin' ] = { header = 'Админ Уровень', Draw = DrawNumber },
    [ 'order' ] = { header = 'Order', Draw = DrawNumber },
    [ 'license' ] = { header = 'Лицензия', Draw = DrawBool },
    [ 'demote' ] = { header = 'Можно уволить?', Draw = DrawBool },
    [ 'vote' ] = { header = 'Голосование?', Draw = DrawBool },
}

local function ShowMakeJob( canvas, tJob, bShowMakeJob )
    canvas:Clear()

    local panels = GUI.DrawScrollPanel( canvas, canvas:GetWide() - 8, canvas:GetTall() - 4, 4, 4, function( self, w, h )
        -- Draw.Box( w, h, 0, 0, C.AMBI_GREEN ) -- debug
    end )

    local tall = 0

    local i = 0
    for k, v in pairs( tJob ) do
        local tab = KEYS[ k ]
        if not tab then continue end

        if not bShowMakeJob and ( k == 'class' ) then continue end

        local main = GUI.DrawPanel( panels, panels:GetWide(), 64, 0, i * ( 64 + 4 ), function( self, w, h ) 
            -- Draw.Box( w, h, 0, 0, C.AMBI_RED ) -- debug
        end )

        local name = GUI.DrawPanel( main, main:GetWide() * .26, main:GetTall(), 0, 0, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.COLOR_PANEL )
    
            Draw.SimpleText( 4, h / 2, tab.header, UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'center-left', 1, C.ABS_BLACK )
        end )

        local panel = GUI.DrawPanel( main, main:GetWide() - name:GetWide() - 4, main:GetTall(), name:GetWide() + 4, 0, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.COLOR_PANEL )
        end )
        panel.canvas = canvas

        tab.Draw( tJob, k, panel )

        i = i + 1

        tall = i * ( 64 + 4 )
    end

    local make_update = GUI.DrawButton( panels, panels:GetWide(), 64, 0, tall, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        local job = table.Copy( tJob )
        for k, v in pairs( job ) do
            if isfunction( v ) or IsEntity( v ) then job[ k ] = nil end -- remove functiones & entities for send to clients (network can't work with function)
        end
        job.command = job.class

        net.Start( 'ambi_darkrp_job_maker_create' )
            net.WriteString( tJob.class )
            net.WriteTable( job )
        net.SendToServer()

        canvas:Clear()
    end, function( self, w, h ) 
        local color = bShowMakeJob and ( Ambi.DarkRP.GetJob( tJob.class ) and C.AMBI_RED or C.AMBI_GREEN ) or C.AMBI_BLUE
        Draw.Box( w, h, 0, 0, color )
        Draw.SimpleText( w / 2, h / 2, bShowMakeJob and 'Создать' or 'Обновить', UI.SafeFont( '32 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
end

local function ShowJobs( canvas )
    canvas:Clear()

    local i = 0
    for class, job in pairs( Ambi.DarkRP.jobs ) do
        if not job.created_by_maker then continue end

        local btn = GUI.DrawButton( canvas, canvas:GetWide() - 8, 64, 4, 4 + i * ( 64 + 4 ), nil, nil, nil, function()
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

            ShowMakeJob( canvas, job )
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, self.color )
    
            Draw.SimpleText( 68, h / 2, job.name, UI.SafeFont( '32 Ambi' ), C.ABS_WHITE, 'center-left', 1, C.ABS_BLACK )
        end )
        btn.color = COLOR_PANEL
        GUI.OnCursor( btn, function()
            btn.color = ColorAlpha( C.ABS_BLACK, 180 )
        end, function() 
            btn.color = COLOR_PANEL
        end )

        local remove = GUI.DrawButton( btn, 80, btn:GetTall(), btn:GetWide() - 80, 0, nil, nil, nil, function()
            LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )
    
            net.Start( 'ambi_darkrp_job_maker_remove' )
                net.WriteString( class )
            net.SendToServer()
    
            canvas:Clear()
        end, function( self, w, h ) 
            Draw.Box( w, h, 0, 0, C.RED )
            Draw.SimpleText( w / 2, h / 2, 'Удалить', UI.SafeFont( '26 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
        end )

        GUI.DrawModel( btn, 64, 64, 0, 0, job.models[ 1 ] )

        i = i + 1
    end
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.OpenJobMaker()
    if not Ambi.DarkRP.Config.jobs_maker_enable then chat.AddText( C.ERROR, '• ', C.ABS_WHITE, 'Система Job Maker отключена!' ) return end
    if not Ambi.DarkRP.Config.jobs_maker_usergroups[ LocalPlayer():GetUserGroup() ] then chat.AddText( C.ERROR, '• ', C.ABS_WHITE, 'У вас нет прав для Job Maker' )  return end

    local frame = GUI.DrawFrame( nil, W / 1.4, H / 1.4, 0, 0, '', true, true, true, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, C.AMBI_BLACK, 8 )
        Draw.Box( w, 32, 0, 0, C.AMBI )
    end )
    frame:Center()

    canvas = nil

    local button_top_make = GUI.DrawButton( frame, 24, 24, 4, 4, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        local job = table.Copy( Ambi.DarkRP.Config.jobs_default )
        job.class = 'team_example'

        ShowMakeJob( canvas, job, true )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color, 8 )

        Draw.SimpleText( w / 2, h / 2, '+', UI.SafeFont( '32 Ambi' ), C.ABS_GREEN, 'center', 1, C.ABS_BLACK )
    end )
    button_top_make.color = C.AMBI_BLACK
    GUI.OnCursor( button_top_make, function()
        button_top_make.color = ColorAlpha( C.ABS_BLACK, 200 )
    end, function() 
        button_top_make.color = C.AMBI_BLACK
    end )

    local button_top_jobs = GUI.DrawButton( frame, 80, 24, 4 + button_top_make:GetWide() + 4, 4, nil, nil, nil, function()
        LocalPlayer():EmitSound( 'buttons/button15.wav', nil, 135, .1 )

        ShowJobs( canvas )
    end, function( self, w, h ) 
        Draw.Box( w, h, 0, 0, self.color, 8 )

        Draw.SimpleText( w / 2, h / 2, 'Работы', UI.SafeFont( '24 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
    end )
    button_top_jobs.color = C.AMBI_BLACK
    GUI.OnCursor( button_top_jobs, function()
        button_top_jobs.color = ColorAlpha( C.ABS_BLACK, 200 )
    end, function() 
        button_top_jobs.color = C.AMBI_BLACK
    end )

    canvas = GUI.DrawScrollPanel( frame, frame:GetWide(), frame:GetTall() - 32, 0, 32, function( self, w, h )
        -- Draw.Box( w, h, 0, 0, C.AMBI_RED ) -- debug
    end )

    ShowJobs( canvas )
end
concommand.Add( 'ambi_darkrp_job_maker', Ambi.DarkRP.OpenJobMaker )

function Ambi.DarkRP.IsJobByMaker( sClass )
    local job = Ambi.DarkRP.GetJob( sClass or '' ) 
    if not job then return end

    return job.created_by_maker
end

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_darkrp_job_maker_sync', function() 
    local class, tab = net.ReadString(), net.ReadTable()

    local job = Ambi.DarkRP.GetJob( class )
    if job then
        for k, v in pairs( tab ) do
            job[ k ] = v
        end

        print( '[DarkRP] Changed the job: '..class..' by Job Maker' )
    else
        Ambi.DarkRP.AddJob( class, tab ) 
    end

    print( '[DarkRP] Job Maker: Sync '..class )
end )

net.Receive( 'ambi_darkrp_job_maker_remove_sync', function()
    local class = net.ReadString()

    Ambi.DarkRP.RemoveJob( class )
end  )