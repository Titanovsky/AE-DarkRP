hook.Add( 'PreDrawViewModel', 'Ambi.DarkRP.SetWeaponColor', function( eViewmodel, ePly, eWeapon ) 
    if not ( ePly == LocalPlayer() ) then return end

    if eWeapon.darkrp_colorized then 
        eViewmodel:SetMaterial( eWeapon.darkrp_colorized.material )
        eViewmodel:SetColor( eWeapon.darkrp_colorized.color )
        
        ePly.can_change = true
    else
        if ePly.can_change then
            eViewmodel:SetMaterial()
            eViewmodel:SetColor()

            ePly.can_change = false
        end
    end
end )