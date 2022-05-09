--------------------------------------------------------------------------------------------------------
local C = Ambi.General.Global.Colors

--------------------------------------------------------------------------------------------------------
if CLIENT then
    concommand.Add( 'ambi_darkrp_'..Ambi.DarkRP.Config.weapon_drop_command, function( ePly, _, tArgs )
        if not Ambi.DarkRP.Config.weapon_drop_enable then return end

        net.Start( 'ambi_darkrp_concommand_dropweapon' )
        net.SendToServer()
    end )
else
    local msg = net.AddString( 'ambi_darkrp_concommand_dropweapon' )
    net.Receive( msg, function( _, ePly )
        if not Ambi.DarkRP.Config.weapon_drop_enable then ePly:Kick( '[DarkRP] Попытка неправильного dropweapon (Обход возможности)' ) return end

        ePly:DropActiveWeapon()
    end )
end

--------------------------------------------------------------------------------------------------------
if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local Add = Ambi.ChatCommands.AddCommand
local TYPE = 'DarkRP | Drop Weapon'

Add( Ambi.DarkRP.Config.weapon_drop_command, TYPE, Ambi.DarkRP.Config.weapon_drop_description, 0.25, function( ePly, tArgs ) 
    ePly:DropActiveWeapon()
end )