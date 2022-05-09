--------------------------------------------------------------------------------------------------------
local C = Ambi.General.Global.Colors

--------------------------------------------------------------------------------------------------------
if CLIENT then
    concommand.Add( 'ambi_darkrp_'..Ambi.DarkRP.Config.money_drop_command, function( ePly, _, tArgs )
        if not Ambi.DarkRP.Config.money_drop_can then return end

        local amount = tArgs[ 1 ]
        if not amount then return end
        
        amount = tonumber( amount )

        net.Start( 'ambi_darkrp_concommand_dropmoney' )
            net.WriteUInt( amount, 24 )
        net.SendToServer()
    end )

    concommand.Add( 'ambi_darkrp_'..Ambi.DarkRP.Config.money_give_command, function( ePly, _, tArgs ) 
        if not Ambi.DarkRP.Config.money_give_can then return end

        local amount = tArgs[ 1 ]
        if not amount then return end
        
        amount = tonumber( amount )

        net.Start( 'ambi_darkrp_concommand_givemoney' )
            net.WriteUInt( amount, 24 )
        net.SendToServer()
    end )
else
    local msg = net.AddString( 'ambi_darkrp_concommand_dropmoney' )
    net.Receive( msg, function( _, ePly )
        if not Ambi.DarkRP.Config.money_drop_can then ePly:Kick( '[DarkRP] Попытка неправильного dropmoney (Обход возможности)' ) return end

        local amount = net.ReadUInt( 24 )
        if not amount then ePly:Kick( '[DarkRP] Попытка неправильного dropmoney (Неправильное значение)' ) return end

        ePly:DropMoney( amount )
    end )

    local msg = net.AddString( 'ambi_darkrp_concommand_givemoney' )
    net.Receive( msg, function( _, ePly )
        if not Ambi.DarkRP.Config.money_give_can then ePly:Kick( '[DarkRP] Попытка неправильного givemoney (Обход возможности)' ) return end

        local amount = net.ReadUInt( 24 )
        if not amount then ePly:Kick( '[DarkRP] Попытка неправильного givemoney (Неправильное значение)' ) return end

        ePly:TransferMoney( amount )
    end )
end



--------------------------------------------------------------------------------------------------------
if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local Add = Ambi.ChatCommands.AddCommand
local TYPE = 'DarkRP | Money'

Add( Ambi.DarkRP.Config.money_drop_command, TYPE, Ambi.DarkRP.Config.money_drop_description, 0.15, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.money_drop_can then return end

    local amount = tArgs[ 2 ]
    if not amount then return end
    
    amount = tonumber( amount )
    if ( amount < 1 ) then return end
    
    ePly:DropMoney( amount )
end )

Add( Ambi.DarkRP.Config.money_give_command, TYPE, Ambi.DarkRP.Config.money_give_description, 0.15, function( ePly, tArgs ) 
    if not Ambi.DarkRP.Config.money_give_can then return end

    local amount = tArgs[ 2 ]
    if not amount then return end
    
    amount = tonumber( amount )
    if ( amount < 1 ) then return end
    
    ePly:TransferMoney( amount )
end )