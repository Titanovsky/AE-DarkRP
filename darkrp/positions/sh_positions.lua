if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local C = Ambi.General.Global.Colors
local Add = Ambi.ChatCommands.AddCommand
local TYPE = 'DarkRP | Positions'

-- ------------------------------------------------------------------------------------------------------
-- Spawns --
Add( Ambi.DarkRP.Config.positions_jobs_add_command, TYPE, Ambi.DarkRP.Config.positions_jobs_add_description, 0.25, function( ePly, tArgs ) 
    if not ePly:IsSuperAdmin() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не суперадмин!' ) return end
    if not Ambi.DarkRP.Config.positions_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Перма Позиций - отключены!' ) return end

    local class = tArgs[ 2 ]
    if not string.IsValid( class ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Неправильно указан класс работы!' ) return end

    local pos, ang = ePly:GetPos(), ePly:EyeAngles()

    local job = Ambi.DarkRP.GetJob( class )
    if not job then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Работы с классом ', C.ERROR, class , C.ABS_WHITE, ' не существует!' ) return end

    Ambi.DarkRP.AddJobPosition( class, pos, ang )
    ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы добавили новый спавн для ', C.AMBI_GREEN, job.name )
end )

Add( Ambi.DarkRP.Config.positions_jobs_remove_command, TYPE, Ambi.DarkRP.Config.positions_jobs_remove_description, 0.25, function( ePly, tArgs ) 
    if not ePly:IsSuperAdmin() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не суперадмин!' ) return end
    if not Ambi.DarkRP.Config.positions_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Перма Позиций - отключены!' ) return end

    local class = tArgs[ 2 ]
    if not string.IsValid( class ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Неправильно указан класс работы!' ) return end

    local job = Ambi.DarkRP.GetJob( class )
    if not job then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Работы с классом ', C.ERROR, class , C.ABS_WHITE, ' не существует!' ) return end

    local map = game.GetMap()
    local positions = Ambi.DarkRP.GetJobPositions( class ) or {}
    local count = 0
    for i, v in ipairs( positions ) do
        Ambi.DarkRP.RemoveJobPosition( class, v.pos, map )
        count = i
    end
    
    ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы удалили все ', C.ERROR, tostring( count ), C.ABS_WHITE, ' спавнов у ', C.AMBI_GREEN, job.name )
end )

Add( Ambi.DarkRP.Config.positions_jobs_get_command, TYPE, Ambi.DarkRP.Config.positions_jobs_get_description, 0.25, function( ePly, tArgs ) 
    if not ePly:IsSuperAdmin() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не суперадмин!' ) return end
    if not Ambi.DarkRP.Config.positions_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Перма Позиций - отключены!' ) return end

    local class = tArgs[ 2 ]
    if not string.IsValid( class ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Неправильно указан класс работы!' ) return end

    local job = Ambi.DarkRP.GetJob( class )
    if not job then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Работы с классом ', C.ERROR, class , C.ABS_WHITE, ' не существует!' ) return end

    ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Cпавны '..job.name..':' )
    local positions = Ambi.DarkRP.GetJobPositions( class ) or {} 
    for i, v in ipairs( positions ) do
        local pos = tostring( math.floor( v.pos.x )..', '..math.floor( v.pos.y )..', '..math.floor( v.pos.z ) )
        local ang = tostring( math.floor( v.ang[ 1 ] )..', '..math.floor( v.ang[ 2 ] )..', '..math.floor( v.ang[ 3 ] ) )
        
        ePly:ChatSend( C.AMBI_GREEN, '['..i..']', C.ABS_WHITE, ' [', C.AMBI_GREEN, pos, C.ABS_WHITE, '] [', C.AMBI_GREEN, ang, C.ABS_WHITE, '] [', C.AMBI_GREEN, v.map, C.ABS_WHITE, ']' )
    end
end )

-- Jail --

Add( Ambi.DarkRP.Config.positions_jail_add_command, TYPE, Ambi.DarkRP.Config.positions_jail_add_description, 0.25, function( ePly, tArgs ) 
    if not ePly:IsSuperAdmin() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не суперадмин!' ) return end
    if not Ambi.DarkRP.Config.positions_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Перма Позиций - отключены!' ) return end

    local pos, ang, map = ePly:GetPos(), ePly:EyeAngles(), game.GetMap()

    Ambi.DarkRP.AddJailPosition( pos, ang, map )
    ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы добавили новую точку тюрьмы' )
end )

Add( Ambi.DarkRP.Config.positions_jail_remove_command, TYPE, Ambi.DarkRP.Config.positions_jail_remove_description, 0.25, function( ePly, tArgs ) 
    if not ePly:IsSuperAdmin() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не суперадмин!' ) return end
    if not Ambi.DarkRP.Config.positions_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Перма Позиций - отключены!' ) return end

    local map = game.GetMap()
    local positions = Ambi.DarkRP.GetJailPositions( map ) or {}
    local count = 0
    for i, v in ipairs( positions ) do
        Ambi.DarkRP.RemoveJailPosition( v.pos, map )
        count = i
    end
    
    ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы удалили все ', C.ERROR, tostring( count ), C.ABS_WHITE, ' точки тюрьмы' )
end )

Add( Ambi.DarkRP.Config.positions_jail_get_command, TYPE, Ambi.DarkRP.Config.positions_jail_get_description, 0.25, function( ePly, tArgs ) 
    if not ePly:IsSuperAdmin() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не суперадмин!' ) return end
    if not Ambi.DarkRP.Config.positions_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Перма Позиций - отключены!' ) return end

    ePly:ChatSend( C.RU_RED, '•  ', C.ABS_WHITE, 'Точки Тюрьмы '..game.GetMap()..':' )
    local positions = Ambi.DarkRP.GetJailPositions( game.GetMap() ) or {} 
    for i, v in ipairs( positions ) do
        local pos = tostring( math.floor( v.pos.x )..', '..math.floor( v.pos.y )..', '..math.floor( v.pos.z ) )
        local ang = tostring( math.floor( v.ang[ 1 ] )..', '..math.floor( v.ang[ 2 ] )..', '..math.floor( v.ang[ 3 ] ) )
        
        ePly:ChatSend( C.RU_RED, '['..i..']', C.ABS_WHITE, ' [', C.RU_RED, pos, C.ABS_WHITE, '] [', C.RU_RED, ang, C.ABS_WHITE, '] [', C.RU_RED, v.map, C.ABS_WHITE, ']' )
    end
end )