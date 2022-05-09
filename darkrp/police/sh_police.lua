local C = Ambi.General.Global.Colors
local PLAYER = FindMetaTable( 'Player' )
--------------------------------------------------------------------------------------------------------

function PLAYER:IsArrested()
    return self.nw_IsArrested
end

function PLAYER:IsWanted()
    return self.nw_IsWanted
end

function PLAYER:HasWarrant()
    return self.nw_HasWarrant
end

function PLAYER:IsPolice()
    return self:GetJobTable().police or self:GetJobTable().mayor
end

function PLAYER:IsCP()
    return self:IsPolice()
end

--------------------------------------------------------------------------------------------------------
if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local Add = Ambi.ChatCommands.AddCommand
local TYPE = 'DarkRP | Police System'

Add( Ambi.DarkRP.Config.police_system_arrest_command, TYPE, Ambi.DarkRP.Config.police_system_arrest_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.police_system_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Полицейская Система - отключена!' ) return end

    local job = ePly:GetJobTable()
    if not job.police then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваша работа не имеет право арестовать через команду!' ) return end

    local ply = ePly:GetEyeTrace().Entity
    if not IsValid( ply ) or not ply:IsPlayer() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не смотрите на игрока!' ) return end
    if ( ePly:Distance( ply ) > Ambi.DarkRP.Config.police_system_arrest_distance ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Игрок слишком далеко!' ) return end
    if Ambi.DarkRP.Config.police_system_arrest_can_other_police and ply:GetJobTable().police then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данного игрока нельзя арестовать!' ) return end

    if ply:IsArrested() then 
        if not Ambi.DarkRP.Config.police_system_arrest_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Отключена возможность арестовать игрока!' ) return end
        if Ambi.DarkRP.Config.police_system_arrest_only_wanted and not ply:IsWanted() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Можно арестовать только тех, кто в розыске!' ) return end

        local description = tArgs[ 2 ]
        if not description then
            description = 'Нарушение закона'
        else
            description = ''

            for i, v in ipairs( tArgs ) do
                if ( i == 1 ) then continue end

                description = v..' '..description
            end
        end

        Ambi.DarkRP.Arrest( ply, ePly, description, Ambi.DarkRP.Config.police_system_arrest_time )

        ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы арестовали ', C.AMBI_BLUE, ply:Nick() )
        ply:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вас арестовал ', C.AMBI_BLUE, ePly:Nick() )
    else
        if not owner:GetDelay( 'AmbiDarkRpDelayArrest' ) then owner:SetDelay( 'AmbiDarkRpDelayArrest' ) else owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите!' ) return end

        Ambi.DarkRP.UnArrest( ply )

        ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы освободили ', C.AMBI_GREEN, ply:Nick() )
        ply:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вас освободил ', C.AMBI_GREEN, ePly:Nick() )
    end
end )

Add( Ambi.DarkRP.Config.police_system_warrant_command, TYPE, Ambi.DarkRP.Config.police_system_warrant_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.police_system_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Полицейская Система - отключена!' ) return end
    if not Ambi.DarkRP.Config.police_system_warrant_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ордер на Обыск - отключён!' ) return end
    if not ePly:IsPolice() then return end

    local door = ePly:GetEyeTrace().Entity
    if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then return end

    local owner = door.first_owner
    if not owner then return end

    local reason = ''
    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        reason = reason..' '..v
    end

    if not owner:HasWarrant() then 
        Ambi.DarkRP.Warrant( owner, ePly, reason )
    else
        Ambi.DarkRP.UnWarrant( owner, ePly, reason )
    end
end )