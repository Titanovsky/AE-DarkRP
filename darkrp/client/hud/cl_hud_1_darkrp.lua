if not Ambi.MultiHUD then return end

local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
local Add = Ambi.MultiHUD.Add

local W, H = ScrW(), ScrH()
local COLOR_BACK = Color( 0, 0, 0, 240 )
local COLOR_MONEY = Color( 57, 158, 64 )
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
}

-- ---------------------------------------------------------------------------------------------------------------------------------------
Add( 1, 'DarkRP HUD', 'Ambi', function()
    if not Ambi.DarkRP.Config.hud_enable then return end

    -- DarkRP
    local margin_x = 0
    local job = LocalPlayer():GetJobTable()

    local job_text = job.name
    local offset_x = Draw.GetTextSizeX( UI.SafeFont( '46 Ambi' ), job_text ) + 6
    Draw.Material( 64, 64, 4 - 1, H - 64 - 110 - 1, CL.Material( 'hud1_darkrp_job' ), C.BLACK )
    Draw.Material( 64, 64, 4, H - 64 - 110, CL.Material( 'hud1_darkrp_job' ), job.color )
    Draw.SimpleText( 78, H - 104, job.name, UI.SafeFont( '46 Ambi' ), C.ABS_WHITE, 'bottom-left', 1, C.ABS_BLACK )

    if LocalPlayer():HasLicenseGun() then
        Draw.Material( 28, 28, 78 + offset_x - 1, H - 28 - 110 - 1, CL.Material( 'hud1_darkrp_license' ), C.BLACK )
        Draw.Material( 28, 28, 78 + offset_x, H - 28 - 110, CL.Material( 'hud1_darkrp_license' ), LocalPlayer():HasRealLicenseGun() and C.AU_YELLOW or C.AMBI_BLOOD )
        offset_x = offset_x + 32
    end

    if LocalPlayer():IsWanted() then
        Draw.Material( 28, 28, 78 + offset_x - 1, H - 28 - 110 - 1, CL.Material( 'hud1_darkrp_wanted' ), C.BLACK )
        Draw.Material( 28, 28, 78 + offset_x, H - 28 - 110, CL.Material( 'hud1_darkrp_wanted' ), C.AU_YELLOW )
    end

    local money_text = string.Comma( LocalPlayer():GetMoney() )..Ambi.DarkRP.Config.money_currency_symbol
    local offset_x = Draw.GetTextSizeX( UI.SafeFont( '32 Bebas Neue Cyrillic' ), money_text ) + 6
    Draw.Material( 24, 24, 60 - 1, H - 24 - 150 - 1, CL.Material( 'hud1_darkrp_wallet' ), C.BLACK )
    Draw.Material( 24, 24, 60, H - 24 - 150, CL.Material( 'hud1_darkrp_wallet' ), C.AU_GREEN )
    Draw.SimpleText( 90, H - 144, money_text, UI.SafeFont( '32 Bebas Neue Cyrillic' ), COLOR_MONEY, 'bottom-left', 1, C.ABS_BLACK )
    Draw.SimpleText( 90 + offset_x, H - 144, '+'..job.salary..Ambi.DarkRP.Config.money_currency_symbol, UI.SafeFont( '22 Bebas Neue Cyrillic' ), C.AMBI_SALAT, 'bottom-left', 1, C.ABS_BLACK )

    if Ambi.DarkRP.IsLockdown() then
        Draw.SimpleText( 4, 0, '• Комендантский Час!', UI.SafeFont( '36 Ambi' ), C.AMBI_RED, 'top-left', 1, C.ABS_BLACK )
    end

    -- Health
    local hp, max = LocalPlayer():Health(), LocalPlayer():GetMaxHealth() 
    local color = ( hp <= 30 ) and ColorAlpha( C.AMBI_RED, 200 + math.sin( 360 + CurTime() * 10 ) * 160 ) or C.RED

    local w = ( hp > max ) and 120 or ( 120 / max ) * hp

    Draw.Material( 84, 84 - 14, 18 - 2, H - ( 84 - 14 ) - 10, CL.Material( 'hud1_hp' ), C.BLACK )
    Draw.Material( 84, 84 - 14, 18, H - ( 84 - 14 ) - 10, CL.Material( 'hud1_hp' ), color )

    local color = ( hp <= 30 ) and ColorAlpha( C.AMBI_RED, 200 + math.sin( 360 + CurTime() * 10 ) * 160 ) or C.AMBI_RED
    Draw.Box( 120, 22, 4 - 2, H - 106, COLOR_BACK, 8 )
    Draw.Box( w - 4, 22 - 4, 4, H - 106 + 2, color, 8 )

    Draw.SimpleText( 62, H - 81, hp, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'bottom-center', 1, C.ABS_BLACK )

    margin_x = 80

    -- Armor
    local value, max = LocalPlayer():Armor(), LocalPlayer():GetMaxArmor() 
    if ( value > 0 ) then
        margin_x = margin_x * 1.86
        local w = ( value > max ) and 120 or ( 120 / max ) * value

        Draw.Material( 76, 76, 4 + margin_x - 2, H - 76 - 4 + 1, CL.Material( 'hud1_armor' ), C.BLACK )
        Draw.Material( 76, 76, 4 + margin_x, H - 76 - 4, CL.Material( 'hud1_armor' ), C.BLUE )

        Draw.Box( 120, 22, margin_x - 2 - 16, H - 106, COLOR_BACK, 8 )
        Draw.Box( w - 4, 22 - 4, margin_x - 16, H - 104, C.BLUE, 8 )

        Draw.SimpleText( margin_x + 44, H - 81, value, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'bottom-center', 1, C.ABS_BLACK )
    end

    if Ambi.DarkRP.Config.hunger_enable then
        margin_x = margin_x * 1.86

        local value, max = LocalPlayer():GetSatiety(), LocalPlayer():GetMaxSatiety() 
        local w = ( value > max ) and 120 or ( 120 / max ) * value

        Draw.Material( 76, 76, 4 + margin_x - 2, H - 76 - 4 + 1, CL.Material( 'hud1_darkrp_hungry' ), C.BLACK )
        Draw.Material( 76, 76, 4 + margin_x, H - 76 - 4, CL.Material( 'hud1_darkrp_hungry' ), C.AU_SOFT_ORANGE )

        Draw.Box( 120, 22, margin_x - 2 - 16, H - 106, COLOR_BACK, 8 )
        Draw.Box( w - 4, 22 - 4, margin_x - 16, H - 104, C.AU_SOFT_ORANGE, 8 )

        Draw.SimpleText( margin_x + 44, H - 81, value, UI.SafeFont( '28 Ambi' ), C.ABS_WHITE, 'bottom-center', 1, C.ABS_BLACK )
    end

    -- Ammunition
    local wep = LocalPlayer():GetActiveWeapon()
    if IsValid( wep ) and not BLOCK_WEAPONS[ wep:GetClass() ] then 
        if ( wep:GetClass() == 'gmod_camera' ) then return end

        Draw.Material( 64, 64, W - 64 - 80 - 1, H - 64 - 60 + 1, CL.Material( 'hud1_ammunition' ), C.BLACK )
        Draw.Material( 64, 64, W - 64 - 80, H - 64 - 60, CL.Material( 'hud1_ammunition' ), C.GREEN )

        local clip1, ammo1, ammo2 = wep:Clip1(), LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() ), LocalPlayer():GetAmmoCount( wep:GetSecondaryAmmoType() )
        local ammo = clip1..'/'..ammo1
        if ammo2 and ( ammo2 > 0 ) then 
            ammo = '('..ammo2..') '..clip1..'/'..ammo1
        end

        local color = ( ammo1 == 0 and clip1 == 0 ) and C.AMBI_GRAY or C.WHITE
        Draw.SimpleText( W - 102, H - 38, wep:GetClass(), UI.SafeFont( '23 Arial' ), color, 'bottom-center', 1, C.ABS_BLACK )
        Draw.SimpleText( W - 102, H - 2, ammo, UI.SafeFont( '38 Ambi' ), color, 'bottom-center', 1, C.ABS_BLACK )
    end
end )