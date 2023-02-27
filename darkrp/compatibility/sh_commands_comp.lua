local C = Ambi.Packages.Out( 'colors' )

local function Send( ePly, sCommand )
    ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Используйте команду ', C.ERROR, '/'..sCommand )
    ePly:ChatSend( C.AMBI, '>> ', C.ABS_WHITE, 'https://github.com/Titanovsky/AE-DarkRP' )
end

local function Send2( ePly )
    ePly:ChatSend( C.AMBI, '>> ', C.ABS_WHITE, 'https://github.com/Titanovsky/AE-DarkRP' )
end

hook.Add( 'PlayerSay', 'Ambi.DarkRP.CompatibilityCommands', function( ePly, sText ) 
    if not Ambi.DarkRP.compatibility_commands then return end

    if string.StartWith( sText, '/dropmoney' ) and ( Ambi.DarkRP.Config.money_drop_command != 'dropmoney' ) then Send( ePly, Ambi.DarkRP.Config.money_drop_command )
    elseif ( sText == '/give' ) and ( Ambi.DarkRP.Config.money_give_command != 'give' ) then Send( ePly, Ambi.DarkRP.Config.money_give_command )
    elseif string.StartWith( sText, '/job' ) and ( Ambi.DarkRP.Config.jobs_command != 'job' ) then Send( ePly, Ambi.DarkRP.Config.jobs_command )
    elseif string.StartWith( sText, '/warrant' ) and ( Ambi.DarkRP.Config.police_system_warrant_command != 'warrant' ) then Send( ePly, Ambi.DarkRP.Config.police_system_warrant_command )
    elseif string.StartWith( sText, '/lockdown' ) and ( Ambi.DarkRP.Config.goverment_lockdown_command != 'lockdown' ) then Send( ePly, Ambi.DarkRP.Config.goverment_lockdown_command )
    elseif string.StartWith( sText, '/addlaw' ) and ( Ambi.DarkRP.Config.goverment_laws_set_command != 'addlaw' ) then Send( ePly, Ambi.DarkRP.Config.goverment_laws_set_command )
    elseif string.StartWith( sText, '/removelaw' ) and ( Ambi.DarkRP.Config.goverment_laws_set_command != 'removelaw' ) then Send( ePly, Ambi.DarkRP.Config.goverment_laws_set_command )
    elseif string.StartWith( sText, '/resetlaws' ) and ( Ambi.DarkRP.Config.goverment_laws_clear_command != 'resetlaws' ) then Send( ePly, Ambi.DarkRP.Config.goverment_laws_clear_command )
    elseif string.StartWith( sText, '/givelicense' ) and ( Ambi.DarkRP.Config.goverment_license_gun_command != 'givelicense' ) then Send( ePly, Ambi.DarkRP.Config.goverment_license_gun_command )
    elseif string.StartWith( sText, '/unlockdown' ) then Send( ePly, Ambi.DarkRP.Config.goverment_lockdown_command )
    elseif string.StartWith( sText, '/unwarrant' ) then Send( ePly, Ambi.DarkRP.Config.police_system_warrant_command )
    elseif string.StartWith( sText, '/unwanted' ) then Send( ePly, Ambi.DarkRP.Config.police_system_wanted_command )
    elseif string.StartWith( sText, '/placelaws' ) then Send2( ePly )
    elseif string.StartWith( sText, '/requestlicense' ) then Send2( ePly )
    elseif string.StartWith( sText, '/cheque' ) then Send2( ePly )
    elseif string.StartWith( sText, '/lottery' ) then Send2( ePly )
    elseif string.StartWith( sText, '/agenda' ) then Send2( ePly )
    elseif string.StartWith( sText, '/switchjob' ) then Send2( ePly )
    elseif string.StartWith( sText, '/switchjobs' ) then Send2( ePly )
    elseif string.StartWith( sText, '/jobswitch' ) then Send2( ePly )
    end
end )