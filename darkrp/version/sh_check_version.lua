local VERSION = '2.1'

Ambi.General.CheckVersion( 'DarkRP', VERSION, 'https://raw.githubusercontent.com/Titanovsky/AE-DarkRP/main/VERSION.md', 60 * 60, function( sBody ) 
    if SERVER then
        print( '\n' )
        for i = 1, 6 do
            print( '[DarkRP] Обновите версию до '..sBody )
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
