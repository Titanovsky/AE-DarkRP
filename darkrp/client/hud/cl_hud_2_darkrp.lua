local C, GUI, Draw = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()
local HUD = Ambi.Base.HUD
local COLOR_PANEL = Color( 20, 20, 20, 200 )

local BLOCK_GUNS = {
    [ 'weapon_physcannon' ] = true,
    [ 'weapon_bugbait' ] = true,
    [ 'weapon_crowbar' ] = true,
    [ 'weapon_stunstick' ] = true,
    [ 'gmod_camera' ] = true,
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

HUD.Add( 2, 'Minimalistic DarkRP HUD', 'Ambi', function()
    if not Ambi.DarkRP.Config.hud_enable then return end
    
    surface.SetFont( '28 Ambi' )
    local xchar_nick, _ = surface.GetTextSize( LocalPlayer():Nick() )

    draw.RoundedBox( 4, 4, H-36, xchar_nick+20, 32, COLOR_PANEL )
    draw.SimpleTextOutlined( LocalPlayer():Nick(), '28 Ambi Bold', 8, H-34, C.ABS_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )

    local text = LocalPlayer():TeamName()
    local xw = Draw.GetTextSizeX( '28 Ambi', text )
    Draw.Box( xw + 8, 32, 4, H - 36 * 2, COLOR_PANEL, 4 )
    Draw.SimpleText( 8, H - 35 * 2, text, '28 Ambi', LocalPlayer():TeamColor(), 'top-left', 1, C.ABS_BLACK )

    local text = LocalPlayer():GetMoney()..Ambi.DarkRP.Config.money_currency_symbol
    local xw = Draw.GetTextSizeX( '28 Ambi', text )
    Draw.Box( xw + 8, 32, 4, H - 36 * 3, COLOR_PANEL, 4 )
    Draw.SimpleText( 8, H - 35 * 3, text, '28 Ambi', C.AMBI_GREEN, 'top-left', 1, C.ABS_BLACK )

    local health = LocalPlayer():Health()
    if ( health > 0 ) then
        local xw_hp = Draw.GetTextSizeX( '28 Ambi', LocalPlayer():Health() )

        draw.RoundedBox( 4, 4, H - 36 * 4, xw_hp+4, 32, COLOR_PANEL )
        draw.SimpleTextOutlined( LocalPlayer():Health(), '28 Ambi', 6, H - 35 * 4, C.FLAT_RED, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )

        local armor = LocalPlayer():Armor()
        if ( armor > 0 ) then
            local _xw = Draw.GetTextSizeX( '28 Ambi', armor )

            Draw.Box( _xw + 8, 32, 4 + xw_hp + 8, H - 36 * 4, COLOR_PANEL, 4 )
            Draw.SimpleText( 8 + xw_hp + 8, H - 35 * 4, armor, '28 Ambi', C.AMBI_BLUE, 'top-left', 1, C.ABS_BLACK )
        end
    end

    if GetConVar( 'ambi_darkrp_lockdown' ):GetBool() then
        Draw.SimpleText( 4, 4, '• Комендантский Час!', '28 Ambi', C.AMBI_RED, 'top-left', 1, C.ABS_BLACK )
    end

    local wep = LocalPlayer():GetActiveWeapon()
    if not IsValid( wep ) then return end
    if BLOCK_GUNS[ wep:GetClass() ] then return end

    local clip1, ammo1, ammo2 = wep:Clip1(), LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() ), LocalPlayer():GetAmmoCount( wep:GetSecondaryAmmoType() )
    local ammo = clip1..' / '..ammo1
    local x = Draw.GetTextSizeX( '46 Ambi', ammo ) + 14
    if ammo2 and ( ammo2 > 0 ) then 
        ammo = '('..ammo2..') '..clip1..' / '..ammo1
        x = Draw.GetTextSizeX( '46 Ambi', ammo ) + 10
    end

    draw.RoundedBox( 4, W - x, H - 40 - 4, x - 4, 40, COLOR_PANEL )
    draw.SimpleTextOutlined( ammo, '46 Ambi', W - 8, H - 41 - 4, C.AMBI_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
end )