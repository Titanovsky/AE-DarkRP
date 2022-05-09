local C = Ambi.Packages.Out( 'colors' )

hook.Add( 'PlayerSpawn', 'Ambi.DarkRP.GiveAdminGuns', function( ePly ) 
    if not Ambi.DarkRP.Config.admin_give_guns then return end
    if not Ambi.DarkRP.Config.admin_usergroups[ ePly:GetUserGroup() ] then return end
    if ePly:IsArrested() then return end

    timer.Simple( 0.25, function()
        if not IsValid( ePly ) then return end
        
        for _, class in ipairs( Ambi.DarkRP.Config.admin_guns ) do ePly:Give( class ) end
        if Ambi.DarkRP.Config.admin_give_guns_log then ePly:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вам выдалось ', C.AMBI_SOFT_PURPLE, 'Админское Оружие' ) end
    end )
end )