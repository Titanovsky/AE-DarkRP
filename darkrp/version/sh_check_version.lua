local VERSION = '1.0'

local function CheckVersion()
    http.Fetch( 'https://raw.githubusercontent.com/Titanovsky/AE-DarkRP/main/VERSION.md', function( sBody ) 
        sBody = string.Trim( sBody )

        if ( sBody == VERSION ) then
            timer.Create( 'AmbiDarkRPCheckVersion:True', 60 * 60, 0, CheckVersion )
        else
            timer.Create( 'AmbiDarkRPCheckVersion:False', 60 * 5, 0, function()
                if SERVER then
                    print( '\n' )
                    for i = 1, 24 do
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
        end
    end )
end

timer.Simple( 2, function() CheckVersion() end )