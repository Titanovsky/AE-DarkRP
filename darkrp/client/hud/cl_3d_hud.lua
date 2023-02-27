local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()
local LICENSE = Material( 'icon16/page.png' )
local WANTED = Material( 'icon16/exclamation.png' )

hook.Add( 'PostDrawTranslucentRenderables', 'Ambi.DarkRP.3DHud', function()
    for i, ePly in ipairs( player.GetAll() ) do
        if not Ambi.DarkRP.Config.hud_3d_enable then continue end
        if not IsValid( ePly ) then continue end
        if ( LocalPlayer():GetPos():Distance( ePly:GetPos() ) > 500 ) then continue end
        if ( ePly == LocalPlayer() ) then continue end
        if not ePly:Alive() then continue end

        local _,max = ePly:GetRotatedAABB( ePly:OBBMins(), ePly:OBBMaxs() )
        local rot = ( ePly:GetPos() - EyePos() ):Angle().yaw - 90
        local head_bone = ePly:LookupBone( 'ValveBiped.Bip01_Head1' ) or 1
        local head = (ePly:GetBonePosition( head_bone ) and ePly:GetBonePosition( head_bone ) + Vector( 0, 0, 14 ) or nil ) or ePly:LocalToWorld( ePly:OBBCenter() ) + Vector( 0, 0, 24 )
        
        cam.Start3D2D( head, Angle( 0, rot, 90 ), 0.1 )
            if Ambi.DarkRP.Config.hud_3d_show_name then Draw.SimpleText( 4, 6, ePly:Name(), UI.SafeFont( '32 Ambi' ), C.ABS_WHITE, 'center', 1, C.ABS_BLACK ) end
--            if Ambi.DarkRP.Config.hud_3d_show_job then Draw.SimpleText( 4, 30, ePly:JobName(), '24 Ambi', ePly:TeamColor(), 'center', 1, C.ABS_BLACK ) end

            local hp, max = ( ePly:Health() >= 100 ) and 100 or ePly:Health()
            if Ambi.DarkRP.Config.hud_3d_show_health and ( ePly:Health() > 0 ) then 
                Draw.Box( hp, 8, -46, 46, C.AMBI_RED ) 
            end

            local armor, max = ( ePly:Armor() >= 100 ) and 100 or ePly:Armor(), ePly:GetMaxArmor()
            if Ambi.DarkRP.Config.hud_3d_show_armor and ( ePly:Armor() > 0 ) then 
                Draw.Box( armor, 4, -46, 52, C.AMBI_BLUE ) 
            end

--            if Ambi.DarkRP.Config.goverment_license_gun_show_3d and ePly:HasLicenseGun() then Draw.Material( 16, 16, 0, -24, LICENSE ) end
--            if Ambi.DarkRP.Config.police_system_wanted_show_3d and ePly:IsWanted() then Draw.Material( 16, 16, 24, -24, WANTED ) end
        cam.End3D2D()
    end
end )