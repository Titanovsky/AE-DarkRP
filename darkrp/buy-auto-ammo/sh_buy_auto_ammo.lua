--------------------------------------------------------------------------------------------------------
local C = Ambi.General.Global.Colors

--------------------------------------------------------------------------------------------------------
if CLIENT then
    concommand.Add( 'ambi_darkrp_'..Ambi.DarkRP.Config.buy_auto_ammo_command, function( ePly, _, tArgs )
        if not Ambi.DarkRP.Config.buy_auto_ammo_enable then chat.AddText( C.ERROR, '•  ', C.ABS_WHITE, 'Система автоматической закупки патронов - отключена!' ) return end
        if not ePly:GetDelay( 'AmbiDarkRPBuyAutoAmmo' ) then ePly:SetDelay( 'AmbiDarkRPBuyAutoAmmo', Ambi.DarkRP.Config.buy_auto_ammo_delay ) else return end

        local ammo = tArgs[ 2 ]
        if not string.IsValid( ammo ) then ammo = 1 end

        net.Start( 'ambi_darkrp_buy_auto_ammo' )
            net.WriteUInt( tonumber( ammo ), 10 )
        net.SendToServer()
    end )
end

--------------------------------------------------------------------------------------------------------
if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local Add = Ambi.ChatCommands.AddCommand
local TYPE = 'DarkRP | Buy Auto Ammo'

Add( Ambi.DarkRP.Config.buy_auto_ammo_command, TYPE, Ambi.DarkRP.Config.buy_auto_ammo_description, 0.25, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.buy_auto_ammo_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система автоматической закупки патронов - отключена!' ) return end

    local ammo = tArgs[ 2 ]
    if not string.IsValid( ammo ) then ammo = 1 end

    ePly:BuyAutoAmmo( ammo )
end )