local C = Ambi.General.Global.Colors

--------------------------------------------------------------------------------------------------------
if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local Add = Ambi.ChatCommands.AddCommand
local TYPE = 'DarkRP | Goverment'

Add( Ambi.DarkRP.Config.goverment_lockdown_command, TYPE, Ambi.DarkRP.Config.goverment_lockdown_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.goverment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Государства - отключена!' ) return end
    if not Ambi.DarkRP.Config.goverment_lockdown_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя Вкл/Выкл Ком. Час!' ) return end
    if not ePly:IsMayor() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не мэр!' ) return end

    local bool = not Ambi.DarkRP.IsLockdown()
    if bool and timer.Exists( 'AmbiDarkRPLockdownDelay' ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: ', C.ERROR, tostring( math.floor( timer.TimeLeft( 'AmbiDarkRPLockdownDelay' ) ) ), C.ABS_WHITE, ' секунд' ) return end
    timer.Create( 'AmbiDarkRPLockdownDelay', Ambi.DarkRP.Config.goverment_lockdown_delay, 1, function() end )

    Ambi.DarkRP.SetLockdown( bool )

    local time = Ambi.DarkRP.Config.goverment_lockdown_time
    if bool and ( time > 0 ) then 
        timer.Create( 'AmbiDarkRPLockdown', time, 1, function() 
            Ambi.DarkRP.SetLockdown( false )

            if Ambi.DarkRP.Config.goverment_lockdown_log then Ambi.UI.Chat.SendAll( C.ERROR, '•  '..'Комендантский Час окончен!' ) end
        end ) 
    end
    if not bool then timer.Remove( 'AmbiDarkRPLockdown' ) end

    if not Ambi.DarkRP.Config.goverment_lockdown_log then return end

    if bool then
        local reason = ''
        for i, v in ipairs( tArgs ) do
            if ( i == 1 ) then continue end

            if ( i == 2 ) then reason = reason..v else reason = reason..' '..v end
        end
        if ( utf8.len( reason ) > 32 ) then reason = '' end

        Ambi.UI.Chat.SendAll( C.ERROR, '•  '..'Начался Комендантский Час. Причина: '..reason )

        hook.Call( 'lockdownStarted', nil, ePly )
    else
        Ambi.UI.Chat.SendAll( C.ERROR, '•  '..'Комендантский Час окончен!' )

        hook.Call( 'lockdownEnded', nil, ePly )
    end
end )

--------------------------------------------------------------------------------------------------------
Add( Ambi.DarkRP.Config.goverment_license_gun_command, TYPE, Ambi.DarkRP.Config.goverment_license_gun_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.goverment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Государства - отключена!' ) return end
    if not Ambi.DarkRP.Config.goverment_license_gun_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя Выдавать/Отбирать Лицензий на Оружие!' ) return end
    if not ePly:IsMayor() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не мэр!' ) return end
    
    local ply = ePly:GetEyeTrace().Entity
    if not IsValid( ply ) or not ply:IsPlayer() then return end
    if ply:HasRealLicenseGun() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данный игрок уже имеет реальную Лицензию на Оружие!' ) return end
    if not ePly:CheckDistance( ply, Ambi.DarkRP.Config.goverment_license_gun_distance ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы далеко!' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanGiveLicenseGun]', nil, ePly, ply ) == false ) then return end

    ply:GiveRealLicenseGun()

    ply:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Игрок ', C.AMBI_BLUE, ePly:Nick(), C.ABS_WHITE, ' выдал Вам Лицензию на Оружие' )
    ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы выдали игроку ', C.AMBI_BLUE, ply:Nick(), C.ABS_WHITE, ' Лицензию на Оружие' )
end )

Add( Ambi.DarkRP.Config.goverment_license_gun_remove_command, TYPE, Ambi.DarkRP.Config.goverment_license_gun_remove_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.goverment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Государства - отключена!' ) return end
    if not Ambi.DarkRP.Config.goverment_license_gun_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя Выдавать/Отбирать Лицензий на Оружие!' ) return end
    if not ePly:IsMayor() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не мэр!' ) return end
    
    local ply = ePly:GetEyeTrace().Entity
    if not IsValid( ply ) or not ply:IsPlayer() then return end
    if not ply:HasLicenseGun() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'У данного игрока нет лицензий!' ) return end
    if not ePly:CheckDistance( ply, Ambi.DarkRP.Config.goverment_license_gun_distance ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы далеко!' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanRemoveLicenseGun]', nil, ePly, ply ) == false ) then return end

    ply:RemoveRealLicenseGun()
    ply:RemoveFakeLicenseGun()

    ply:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Игрок ', C.AMBI_BLUE, ePly:Nick(), C.ABS_WHITE, ' отобрал у Вас Лицензию на Оружие' )
    ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы отобрали у игрока ', C.AMBI_BLUE, ply:Nick(), C.ABS_WHITE, ' Лицензию на Оружие' )
end )

Add( Ambi.DarkRP.Config.goverment_license_gun_show_command, TYPE, Ambi.DarkRP.Config.goverment_license_gun_show_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.goverment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Государства - отключена!' ) return end
    if not Ambi.DarkRP.Config.goverment_license_gun_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя Выдавать/Отбирать Лицензий на Оружие!' ) return end
    if not ePly:HasLicenseGun() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'У вас нет Лицензий на Оружие!' ) return end
    
    local ply = ePly:GetEyeTrace().Entity
    if not IsValid( ply ) or not ply:IsPlayer() then return end
    if not ePly:CheckDistance( ply, Ambi.DarkRP.Config.goverment_license_gun_distance ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы далеко!' ) return end

    ply:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Игрок ', C.AMBI_GREEN, ePly:Nick(), C.ABS_WHITE, ' показал Вам Лицензию на Оружие!' )
end )

Add( Ambi.DarkRP.Config.goverment_license_gun_check_command, TYPE, Ambi.DarkRP.Config.goverment_license_gun_check_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.goverment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Государства - отключена!' ) return end
    if not ePly:IsMayor() or not ePly:IsPolice() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не имеет право проверять Лицензию на Оружие!' ) return end
    
    local ply = ePly:GetEyeTrace().Entity
    if not IsValid( ply ) or not ply:IsPlayer() then return end
    if not ePly:CheckDistance( ply, Ambi.DarkRP.Config.goverment_license_gun_distance ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы далеко!' ) return end

    if ply:HasFakeLicenseGun() then
        ePly:ChatSend( C.AMBI_RED, '•  ', C.ABS_WHITE, 'У игрока ', C.AMBI_RED, ply:Nick(), C.ABS_WHITE, ' есть Фальшивая Лицензия на Оружие' )
    end

    if ply:HasRealLicenseGun() then
        ePly:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'У игрока ', C.AMBI_GREEN, ply:Nick(), C.ABS_WHITE, ' есть Настоящая Лицензия на Оружие' )
    else
        ePly:ChatSend( C.AMBI_RED, '•  ', C.ABS_WHITE, 'У игрока ', C.AMBI_RED, ply:Nick(), C.ABS_WHITE, ' нет Настоящей Лицензий на Оружие' )
    end
end )

--------------------------------------------------------------------------------------------------------
Add( Ambi.DarkRP.Config.goverment_laws_show_command, TYPE, Ambi.DarkRP.Config.goverment_laws_show_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.goverment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Государства - отключена!' ) return end
    if not Ambi.DarkRP.Config.goverment_laws_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Законы отключены!' ) return end
    
    local laws = Ambi.DarkRP.Laws()
    for i = 1, 9 do
        local law = laws[ i ]
        if string.IsValid( law ) then ePly:ChatSend( C.AMBI_BLUE, '['..i..'] ', C.ABS_WHITE, law ) end
    end
end )

Add( Ambi.DarkRP.Config.goverment_laws_set_command, TYPE, Ambi.DarkRP.Config.goverment_laws_set_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.goverment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Государства - отключена!' ) return end
    if not Ambi.DarkRP.Config.goverment_laws_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Законы отключены!' ) return end
    if not ePly:IsMayor() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не мэр!' ) return end

    local id = tArgs[ 2 ]
    if not string.IsValid( id ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Неправильно указан номер закона (от 1 до 9 )' ) return end

    id = tonumber( id )
    if not id then return end

    local law = Ambi.DarkRP.Laws()[ id ]
    if not law then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нет закона с таким номером!' ) return end

    local text = ''
    for i, v in ipairs( tArgs ) do
        if ( i == 1 ) or ( i == 2 ) then continue end

        text = text..' '..v
    end
    
    Ambi.DarkRP.SetLaw( tonumber( id ), text )

    ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы изменили ', C.AMBI_BLUE, id, C.ABS_WHITE, ' закон' )

    hook.Call( '[Ambi.DarkRP.SetLaw]', nil, ePly, id, text, law )
end )

Add( Ambi.DarkRP.Config.goverment_laws_clear_command, TYPE, Ambi.DarkRP.Config.goverment_laws_clear_description, 1, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.goverment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Государства - отключена!' ) return end
    if not Ambi.DarkRP.Config.goverment_laws_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Законы отключены!' ) return end
    if not ePly:IsMayor() then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не мэр!' ) return end

    Ambi.DarkRP.ClearLaws()

    ePly:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы очистили законы!' )

    hook.Call( '[Ambi.DarkRP.ClearLaws]', nil, ePly )
end )