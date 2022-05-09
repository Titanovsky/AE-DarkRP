local C = Ambi.General.Global.Colors

--------------------------------------------------------------------------------------------------------
if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local Add = Ambi.ChatCommands.AddCommand
local TYPE = 'DarkRP | Jobs'

Add( Ambi.DarkRP.Config.jobs_command, TYPE, Ambi.DarkRP.Config.jobs_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.jobs_can_change_name then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Возможность поменять название работы - отключено!' ) return end

    local name = ''
    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) then continue end

        if ( i == 2 ) then name = name..v else name = name..' '..v end
    end

    if not string.IsValid( name ) or ( utf8.len( name ) >= 22 ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя такое название! (Не больше 22 символов)' ) return end

    ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы изменили название своей работы на ', C.AMBI_GREEN, name )
    ePly.nw_JobName = name
end )

Add( Ambi.DarkRP.Config.jobs_demote_command, TYPE, Ambi.DarkRP.Config.jobs_demote_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.CanStartVote() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Сейчас нельзя сделать голосование!' ) return end
    if not Ambi.DarkRP.Config.jobs_demote_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Возможность увольнения игроков - Отключена!' ) return end

    local demoter = ePly:GetEyeTrace().Entity
    if not IsValid( demoter ) or not demoter:IsPlayer() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Напротив нет игрока!' ) return end
    if ( ePly:Distance( demoter ) > Ambi.DarkRP.Config.jobs_demote_distance ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы слишком далеко!' ) return end
    if not Ambi.DarkRP.Config.jobs_demote_can_similar_job and ( ePly:Job() == demoter:Job() ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя уволить игрока с такой же работой, как у Вас!' ) return end
    if not demoter:CanDemoteJob() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данного игрока нельзя уволить!' ) return end

    if not ePly:GetDelay( 'AmbiDarkRPDemote' ) then ePly:SetDelay( 'AmbiDarkRPDemote', Ambi.DarkRP.Config.jobs_demote_delay ) else ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: ', C.ERROR, tostring( math.floor( timer.TimeLeft( 'AmbiDarkRPDemote['..ePly:SteamID()..']' ) ) ), C.ABS_WHITE, ' секунд' ) return end

    Ambi.DarkRP.StartVote( ePly:Nick()..' желает уволить '..demoter:Nick(), function() 
        if IsValid( demoter ) and IsValid( ePly ) then  
            ePly:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вы уволили ', C.AMBI, demoter:Nick(), C.ABS_WHITE,' с работы ', C.AMBI_BLUE, demoter:TeamName() )

            demoter:DemoteJob( true )
            demoter:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вас уволил ', C.AMBI, ePly:Nick() )
        end
    end, function() 
        if IsValid( ePly ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Голосование на увольнение провалилось!' ) end
    end )
end )