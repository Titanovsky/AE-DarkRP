local C, SQL, Gen = Ambi.General.Global.Colors, Ambi.SQL, Ambi.General
local DB = SQL.CreateTable( 'darkrp_alt_money', 'SteamID, Money' )
local PLAYER = FindMetaTable( 'Player' )
local MAX_MONEY = 999999999999
local MIN_MONEY = 0
local GetFrontPos = Ambi.General.Utility.GetFrontPos
local MAX_POS = 44

-- ---------------------------------------------------------------------------------------------------------------------------------
function PLAYER:SetMoney( nMoney )
    if not self.nw_Money then return end
    if not nMoney or not isnumber( nMoney ) then Gen.Error( 'DarkRP', 'SetMoney | nMoney is not valid number' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanSetMoney]', nil, self, nMoney ) == false ) then return end

    if ( nMoney < MIN_MONEY ) then nMoney = MIN_MONEY end
    if ( nMoney > MAX_MONEY ) then nMoney = MAX_MONEY end

    nMoney = math.floor( nMoney )

    local old_money = self.nw_Money

    self.nw_Money = nMoney
    SQL.Update( DB, 'Money', nMoney, 'SteamID', self:SteamID() )

    hook.Call( '[Ambi.DarkRP.SetMoney]', nil, self, nMoney, old_money )
end

function PLAYER:AddMoney( nMoney )
    if not nMoney or not isnumber( nMoney ) then Gen.Error( 'DarkRP', 'AddMoney | nMoney is not valid number' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanAddMoney]', nil, self, nMoney ) == false ) then return end

    self:SetMoney( nMoney + self:GetMoney() )

    hook.Call( '[Ambi.DarkRP.AddMoney]', nil, self, nMoney )
end

function PLAYER:DropMoney( nMoney )
    if not nMoney or not isnumber( nMoney ) then Gen.Error( 'DarkRP', 'DropMoney | nMoney is not valid number' ) return end

    if timer.Exists( 'AmbiDarkRPBlockDropMoney:'..self:SteamID() ) then self:ChatSend( C.ERROR, '[•] ', C.ABS_WHITE, 'Пожалуйста, подождите!' ) return end
    timer.Create( 'AmbiDarkRPBlockDropMoney:'..self:SteamID(), Ambi.DarkRP.Config.money_drop_delay, 1, function() end )

    if ( nMoney < 1 ) then self:ChatPrint( 'Можно передать минимум 1' ) return end
    if not self:CanSpendMoney( nMoney ) then self:ChatPrint( 'У вас недостаточно средств!' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanDropMoney]', nil, self, nMoney ) == false ) then return end
    
    local pos, ang = GetFrontPos( self, MAX_POS ), self:EyeAngles()
    local ent = ents.Create( Ambi.DarkRP.Config.money_drop_entity_class )
    ent:SetPos( pos )
    ent:SetAngles( ang )
    ent:Spawn()
    ent.nw_Money = nMoney

    --if ent.CPPISetOwner then ent:CPPISetOwner( self ) end -- integration with FPP

    self:AddMoney( -nMoney )
    if Ambi.DarkRP.Config.money_drop_log_chat then self:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вы выкинули: ', C.AMBI_GREEN, nMoney..Ambi.DarkRP.Config.money_currency_symbol ) end

    hook.Call( '[Ambi.DarkRP.DroppedMoney]', nil, self, ent )

    return true
end

function PLAYER:TransferMoney( nMoney ) -- в командах он обычно !givemoney или /givemoney
    if not nMoney or not isnumber( nMoney ) then Gen.Error( 'DarkRP', 'Transfer | nMoney is not valid number' ) return end

    if timer.Exists( 'AmbiDarkRPBlockTransferMoney:'..self:SteamID() ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Пожалуйста, подождите!' ) return end
    timer.Create( 'AmbiDarkRPBlockTransferMoney:'..self:SteamID(), Ambi.DarkRP.Config.money_give_delay, 1, function() end )

    local receiver_player = self:GetEyeTrace().Entity
    if not IsValid( receiver_player ) or not receiver_player:IsPlayer() then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не смотрите на игрока!' ) return end
    if ( self:GetPos():Distance( receiver_player:GetPos() ) > Ambi.DarkRP.Config.money_give_distance ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Игрок слишком далеко!' ) return end

    if ( nMoney < 1 ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Минимум - 1' ) return end
    if ( nMoney > Ambi.DarkRP.Config.money_give_max_count ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Максимум: '..Ambi.DarkRP.Config.money_give_max_count ) return end
    if not self:CanSpendMoney( nMoney ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Недостаточно средств!' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanTransferMoney]', nil, self, nMoney, receiver_player ) == false ) then return end

    self:AddMoney( -nMoney )
    receiver_player:AddMoney( nMoney )

    if Ambi.DarkRP.Config.money_give_log_chat then
        self:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вы отдали ', C.AMBI_GREEN, nMoney..Ambi.DarkRP.Config.money_currency_symbol, C.ABS_WHITE, ' игроку ', C.AMBI_BLUE, receiver_player:Nick() )
        receiver_player:ChatSend( C.AMBI, '•  ', C.ABS_WHITE, 'Вы получили ', C.AMBI_GREEN, nMoney..Ambi.DarkRP.Config.money_currency_symbol, C.ABS_WHITE, ' от игрока ', C.AMBI_BLUE, self:Nick() )
    end

    hook.Call( '[Ambi.DarkRP.TransferedMoney]', nil, self, nMoney, receiver_player, nMoney )

    return true
end

-- ---------------------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.InitialMoneyBalance', function( ePly ) 
    timer.Simple( 0, function()
        if IsValid( ePly ) then
            if ePly:IsBot() then ePly.nw_Money = 0 return end

            local sid = ePly:SteamID()
            local balance = SQL.Select( DB, 'Money', 'SteamID', sid ) 
            if not balance then 
                balance = Ambi.DarkRP.Config.money_start

                SQL.Insert( DB, 'SteamID, Money', '%s, %i', sid, balance ) 
            else
                balance = tonumber( balance )
            end

            ePly.nw_Money = balance
        end
    end )
end )