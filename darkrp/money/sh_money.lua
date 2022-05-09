local PLAYER = FindMetaTable( 'Player' )

function PLAYER:GetMoney()
    return self.nw_Money or 0
end

function PLAYER:CanSpendMoney( nMoney, fAction )
    if ( self.nw_Money >= nMoney ) then
        
        if fAction then fAction( self ) end

        return true 
    end

    return false
end