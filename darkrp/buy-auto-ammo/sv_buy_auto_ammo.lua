local C = Ambi.Packages.Out( 'colors' )
local PLAYER = FindMetaTable( 'Player' )

function PLAYER:BuyAutoAmmo( nAmmo )
    nAmmo = nAmmo or 1

    local cost = nAmmo * Ambi.DarkRP.Config.buy_auto_ammo_cost
    if ( self:GetMoney() < cost ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Не хватает '..tostring( cost )..Ambi.DarkRP.Config.money_currency_symbol..' на покупку патронов' ) return end

    local wep = self:GetActiveWeapon()
    if not IsValid( wep ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нет оружия!' ) return end

    local ammo = wep:GetPrimaryAmmoType()
    if ( ammo <= 0 ) then return end

    self:GiveAmmo( Ambi.DarkRP.Config.buy_auto_ammo_count, ammo )
    self:AddMoney( -cost )
end

-- ----------------------------------------------------------------------------------------------
net.AddString( 'ambi_darkrp_buy_auto_ammo' )
net.Receive( 'ambi_darkrp_buy_auto_ammo', function( _, ePly )
    if not Ambi.DarkRP.Config.buy_auto_ammo_enable then ePly:Kick( '[DarkRP] Попытка купить авто патроны, когда сама система отключена' ) return end
    if not ePly:GetDelay( 'AmbiDarkRPBuyAutoAmmo' ) then ePly:SetDelay( 'AmbiDarkRPBuyAutoAmmo', Ambi.DarkRP.Config.buy_auto_ammo_delay ) else ePly:Kick( '[DarkRP] Попытка купить автоматические патроны в обход задержки' ) return end

    local ammo = net.ReadUInt( 10 )
    if not ammo then return end

    ePly:BuyAutoAmmo( ammo )
end )