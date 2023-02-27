local PLAYER = FindMetaTable( 'Player' )

function PLAYER:GetSatiety()
    return self.nw_Satiety or 0
end

function PLAYER:GetMaxSatiety()
    return self.nw_MaxSatiety or 0
end