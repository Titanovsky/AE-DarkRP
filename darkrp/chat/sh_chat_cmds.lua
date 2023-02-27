if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local C = Ambi.General.Global.Colors
local Add = Ambi.ChatCommands.AddCommand
local CFG_CMDS = Ambi.DarkRP.Config.chat_create_commands

-- ============================================================================= --
local TYPE = 'DarkRP | Communication'

if CFG_CMDS[ '/me' ] then
    Add( 'me', TYPE, 'Действие от первого лица', 0.25, function( ePly, tArgs ) 
        if not Ambi.DarkRP.Config.chat_create_commands[ '/me' ] then return end

        local text = ''

        for i, v in ipairs( tArgs ) do
            if ( i == 1 ) then continue end

            text = text..' '..v
        end
        
		if ePly.gimp then
			return
		end
        for _, ply in ipairs( ents.FindInSphere( ePly:GetPos(), Ambi.DarkRP.Config.chat_max_length ) ) do
            if ply:IsPlayer() then ply:ChatSend( Ambi.DarkRP.Config.chat_commands_color_me, ePly:Nick()..text ) end
        end
    end )
end

if CFG_CMDS[ '/try' ] then
    Add( 'try', TYPE, 'Действие, которое может завершится Удачно/Неудачно', 0.25, function( ePly, tArgs ) 
        if not Ambi.DarkRP.Config.chat_create_commands[ '/try' ] then return end

        local text = ''

        for i, v in ipairs( tArgs ) do
            if ( i == 1 ) then continue end

            text = text..' '..v
        end
        
		if ePly.gimp then
			return
		end
        local result = math.random( 0, 1 )
        local color, posttext = ( result == 1 ) and C.AMBI_GREEN or C.AMBI_RED, ( result == 1 ) and 'Удачно' or 'Неудачно'
        for _, ply in ipairs( ents.FindInSphere( ePly:GetPos(), Ambi.DarkRP.Config.chat_max_length ) ) do
            if ply:IsPlayer() then ply:ChatSend( Ambi.DarkRP.Config.chat_commands_color_try, ePly:Nick()..text..' ', color, '['..posttext..']' ) end
        end
    end )
end

if CFG_CMDS[ '/do' ] then
    Add( 'do', TYPE, 'Действие от третьего лица', 0.25, function( ePly, tArgs ) 
        if not Ambi.DarkRP.Config.chat_create_commands[ '/do' ] then return end

        local text = ''

        for i, v in ipairs( tArgs ) do
            if ( i == 1 ) then continue end

            text = text..' '..v
        end
        
		if ePly.gimp then
			return
		end
        for _, ply in ipairs( ents.FindInSphere( ePly:GetPos(), Ambi.DarkRP.Config.chat_max_length ) ) do
            if ply:IsPlayer() then ply:ChatSend( Ambi.DarkRP.Config.chat_commands_color_do, text..' ['..ePly:Nick()..']' ) end
        end
    end )
end

if CFG_CMDS[ '/ooc' ] then
    Add( 'ooc', TYPE, 'Глобальный Неигровой Чат', 0.25, function( ePly, tArgs ) 
        if not Ambi.DarkRP.Config.chat_create_commands[ '/ooc' ] then return end

        local text = ''

        for i, v in ipairs( tArgs ) do
            if ( i == 1 ) then continue end

            text = text..' '..v
        end

		if ePly.gimp then
			return
		end
        for _, ply in ipairs( player.GetAll() ) do
            ply:ChatSend( C.AMBI_RED, '[OOC] ', Ambi.DarkRP.Config.chat_commands_color_ooc, '['..ePly:Nick()..']'..text )
        end
    end )
end

if CFG_CMDS[ '//' ] then
    Add( '/', TYPE, 'Глобальный Неигровой Чат', 0.25, function( ePly, tArgs ) 
        if not Ambi.DarkRP.Config.chat_create_commands[ '//' ] then return end

        local text = ''

        for i, v in ipairs( tArgs ) do
            if ( i == 1 ) then continue end

            text = text..' '..v
        end
		
		if ePly.gimp then
			return
		end
        for _, ply in ipairs( player.GetAll() ) do

            ply:ChatSend( C.AMBI_RED, '[OOC] ', Ambi.DarkRP.Config.chat_commands_color_ooc, '['..ePly:Nick()..']'..text )
        end
    end )
end

local function Whisper( ePly, tArgs )
    local text = ''

    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        text = text..' '..v
    end
    
		if ePly.gimp then
			return
		end
    for _, ply in ipairs( ents.FindInSphere( ePly:GetPos(), Ambi.DarkRP.Config.chat_max_length_whisper ) ) do
        if ply:IsPlayer() then ply:ChatSend( Ambi.DarkRP.Config.chat_commands_color_whisper, Ambi.DarkRP.Config.chat_title_whisper..' ['..ePly:Nick()..']'..text ) end
    end
end

if CFG_CMDS[ '/w' ] then
    Add( 'w', TYPE, 'Сказать шёпотом', 0.15, Whisper )
end

if CFG_CMDS[ '/whisper' ] then
    Add( 'whisper', TYPE, 'Сказать шёпотом', 0.15, Whisper )
end

local function Scream( ePly, tArgs )
    local text = ''

    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        text = text..' '..v
    end
    
		if ePly.gimp then
			return
		end
    for _, ply in ipairs( ents.FindInSphere( ePly:GetPos(), Ambi.DarkRP.Config.chat_max_length_scream ) ) do
        if ply:IsPlayer() then ply:ChatSend( Ambi.DarkRP.Config.chat_commands_color_scream, Ambi.DarkRP.Config.chat_title_scream..' ['..ePly:Nick()..']'..text ) end
    end
end

if CFG_CMDS[ '/s' ] then
    Add( 's', TYPE, 'Крикнуть', 0.15, Scream )
end

if CFG_CMDS[ '/s' ] then
    Add( 's', TYPE, 'Крикнуть', 0.15, Scream )
end