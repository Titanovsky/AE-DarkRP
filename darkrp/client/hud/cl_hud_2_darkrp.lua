if not Ambi.MultiHUD then return end

local C, GUI, Draw, UI, Lang = Ambi.Packages.Out( '@d, language' )
local Add = Ambi.MultiHUD.Add

local W, H = ScrW(), ScrH()
local W_PANELS = 200
local COLOR_PANEL = Color( 20, 20, 20, 200 )
local COLOR_BLOOD = Color( 137, 3 ,3 ,209 )
local COLOR_DARK_BLUE = Color( 56, 70 ,123 ,209)
local COLOR_SATIETY = ColorAlpha( C.AU_SOFT_ORANGE, 50 )
local BLOCK_WEAPONS = {
    [ 'weapon_physcannon' ] = true,
    [ 'weapon_bugbait' ] = true,
    [ 'weapon_crowbar' ] = true,
    [ 'weapon_stunstick' ] = true,
    [ 'weapon_fists' ] = true,
    [ 'weapon_physgun' ] = true,
    [ 'gmod_tool' ] = true,
    [ 'keys' ] = true,
    [ 'lockpick' ] = true,
    [ 'stunstick' ] = true,
    [ 'arrest_stick' ] = true,
    [ 'unarrest_stick' ] = true,
    [ 'weaponchecker' ] = true,
    [ 'keypadchecker' ] = true,
    [ 'gmod_camera' ] = true,
}

local MAT_LICENSE_GUN = Material( 'icon16/page_white_text.png' )
local MAT_WANTED = Material( 'icon16/star.png' )

-- --------------------------------------------------------------------------------------------------------------------------------------------
UI.AddFont( 'AmbiMinHUD', { font = 'Franklin Gothic Demi', size = 48, extended = true, weight = 100 } )
UI.AddFont( 'AmbiMinHUDAmmo', { font = 'Franklin Gothic Demi', size = 64, extended = true } )
UI.AddFont( 'AmbiMinHUDHealth', { font = 'Franklin Gothic Demi', size = 32, extended = true } )

-- --------------------------------------------------------------------------------------------------------------------------------------------
Add( 2, 'Minimalistic HUD', 'Ambi', function()
    if not Ambi.DarkRP.Config.hud_enable then return end
    if not LocalPlayer():Alive() then return end

    local offset_y = 10
    
    -- Nick
    local nick = LocalPlayer():Nick()
    local w_nick = Draw.GetTextSizeX( 'AmbiMinHUD', nick ) + 8
    Draw.Box( w_nick, 36, 10, H - 36 - offset_y, COLOR_PANEL, 4 )
    Draw.SimpleText( 14, H - 4, nick, 'AmbiMinHUD', C.WHITE, 'bottom-left', 1, C.ABS_BLACK )

    -- Money
    if ( LocalPlayer():GetMoney() > 0 ) then
        local text = string.Comma( LocalPlayer():GetMoney()..Ambi.DarkRP.Config.money_currency_symbol )
        local W_PANELS = Draw.GetTextSizeX( 'AmbiMinHUDHealth', text )

        Draw.Box( W_PANELS + 8, 36, 10 + w_nick + 4, H - 36 - offset_y, COLOR_PANEL, 4 )
        Draw.SimpleText( 14 + w_nick + 4, H - offset_y, text, 'AmbiMinHUDHealth', C.GREEN, 'bottom-left', 1, C.ABS_BLACK )
    end 

    offset_y = offset_y + 36 + 4

    -- Job
    local text = LocalPlayer():GetJobName()
    local w = Draw.GetTextSizeX( 'AmbiMinHUD', text ) + 8
    Draw.Box( w, 36, 10, H - 36 - offset_y, COLOR_PANEL, 4 )
    Draw.SimpleText( 14, H - offset_y + 4, text, 'AmbiMinHUD', LocalPlayer():GetJobColor(), 'bottom-left', 1, C.ABS_BLACK )

    if LocalPlayer():HasLicenseGun() then
        Draw.Material( 32, 32, w + 10, H - offset_y - 32, MAT_LICENSE_GUN, LocalPlayer():HasRealLicenseGun() and C.AU_YELLOW or C.AMBI_BLOOD )
    end

    if LocalPlayer():IsWanted() then
        Draw.Material( 32, 32, w + 44, H - offset_y - 32, MAT_WANTED )
    end
    
    if Ambi.DarkRP.IsLockdown() then
        Draw.SimpleText( 4, 0, '• Комендантский Час!', UI.SafeFont( '36 Ambi' ), C.AMBI_RED, 'top-left', 1, C.ABS_BLACK )
    end

    -- Health
    if LocalPlayer():Alive() then
        offset_y = offset_y + 36 + 4

        local hp, max = LocalPlayer():Health(), LocalPlayer():GetMaxHealth()
        local w = ( hp > max ) and W_PANELS or ( W_PANELS / max ) * hp
        local color = ( hp <= ( max / 3 ) ) and ColorAlpha( COLOR_BLOOD, 200 + math.sin( 360 + CurTime() * 16 ) * 160 ) or COLOR_BLOOD
        local color2 = ( hp <= ( max / 3 ) ) and ColorAlpha( C.RED, 200 + math.sin( 360 + CurTime() * 16 ) * 160 ) or C.RED

        Draw.Box( W_PANELS + 8, 36, 10, H - 36 - offset_y, COLOR_PANEL, 4 )
        Draw.Box( W_PANELS, 36 - 8, 10 + 4, H - 36 - offset_y + 4, color, 4 )
        Draw.Box( w, 36 - 8, 10 + 4, H - 36 - offset_y + 4, color2, 4 )

        local armor, max_arm = LocalPlayer():Armor(), LocalPlayer():GetMaxArmor()
        if ( armor > 0 ) then
            local w = ( armor > max_arm ) and W_PANELS or ( W_PANELS / max_arm ) * armor

            Draw.Box( w, 14 - 8, 10 + 4, H - 14 - offset_y + 4 , C.BLUE, 4 )
            Draw.SimpleText( 32, H - offset_y - 10, armor, UI.SafeFont( '24 Ambi' ), C.ABS_WHITE, 'bottom-center', 1, C.ABS_BLACK )
        end

        Draw.SimpleText( 120, H - offset_y, hp, 'AmbiMinHUDHealth', C.ABS_WHITE, 'bottom-center', 1, C.ABS_BLACK )
    end

    local value, max = LocalPlayer():GetSatiety(), LocalPlayer():GetMaxSatiety()
    if Ambi.DarkRP.Config.hunger_enable then
        offset_y = offset_y + 36 + 4
        local w = ( value > max ) and W_PANELS or ( W_PANELS / max ) * value

        Draw.Box( W_PANELS + 8, 36, 10, H - 36 - offset_y, COLOR_PANEL, 4 )
        Draw.Box( W_PANELS, 36 - 8, 10 + 4, H - 36 - offset_y + 4, COLOR_SATIETY, 4 )
        Draw.Box( w, 36 - 8, 10 + 4, H - 36 - offset_y + 4, C.AU_SOFT_ORANGE, 4 )
        Draw.SimpleText( 120, H - offset_y, value, 'AmbiMinHUDHealth', C.ABS_WHITE, 'bottom-center', 1, C.ABS_BLACK )
    end

    local wep = LocalPlayer():GetActiveWeapon()
    if IsValid( wep ) and not BLOCK_WEAPONS[ wep:GetClass() ] then 
        local clip1, ammo1, ammo2 = wep:Clip1(), LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() ), LocalPlayer():GetAmmoCount( wep:GetSecondaryAmmoType() )
        local ammo = clip1..' / '..ammo1
        if ammo2 and ( ammo2 > 0 ) then 
            ammo = '('..ammo2..') '..clip1..' / '..ammo1
        end

        local color = ( ammo1 == 0 and clip1 == 0 ) and C.AMBI_GRAY or C.WHITE
        Draw.SimpleText( W - 4, H - 1, ammo, 'AmbiMinHUDAmmo', color, 'bottom-right', 1, C.ABS_BLACK )
    end
end )