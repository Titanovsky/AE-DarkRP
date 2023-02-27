Ambi.General.CheckVersion( 'DarkRP', Ambi.DarkRP.Meta.Version, 'https://raw.githubusercontent.com/Titanovsky/AE-DarkRP/main/VERSION.md', 60 * 60, function( sBody ) 
    if SERVER then
        print( '\n' )
        for i = 1, 6 do
            print( '[DarkRP] Обновите версию: '..sBody )
            print( 'https://github.com/Titanovsky/AE-DarkRP' )
            print( '\n' )
        end
        print( '\n' )
    else
        chat.PlaySound( 'buttons/button4.wav' )
        chat.AddText( '\nУстаревшая версия DarkRP!' ) 
        chat.AddText( 'Пожалуйста, попросите Администратора обновить версию' ) 
        chat.AddText( 'Скачать: https://github.com/Titanovsky/AE-DarkRP\n' ) 
    end
end )