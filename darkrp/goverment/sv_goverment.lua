local C = Ambi.General.Global.Colors
local PLAYER = FindMetaTable( 'Player' )

-- -------------------------------------------------------------------------------------------------------
local lockdown = CreateConVar( 'ambi_darkrp_lockdown', 0, FCVAR_REPLICATED )

function Ambi.DarkRP.SetLockdown( bStart )
    if ( bStart == nil ) then bStart = false end
    if ( lockdown:GetBool() and bStart ) or ( not lockdown:GetBool() and not bStart ) then return end

    lockdown:SetBool( bStart )

    if bStart and string.IsValid( Ambi.DarkRP.Config.goverment_lockdown_sound ) then
        Ambi.UI.Sound.PlayAll( Ambi.DarkRP.Config.goverment_lockdown_sound )
    end

    if not bStart then
        Ambi.UI.Sound.PlayAll( 'buttons/button9.wav' )
    end

    hook.Call( '[Ambi.DarkRP.SetLockdown]', nil, bStart )
end

-- -------------------------------------------------------------------------------------------------------
function PLAYER:GiveRealLicenseGun()
    self.nw_LicenseGun = true

    hook.Call( '[Ambi.DarkRP.GiveRealLicenseGun]', nil, self )
end

function PLAYER:RemoveRealLicenseGun()
    self.nw_LicenseGun = false

    hook.Call( '[Ambi.DarkRP.RemoveRealLicenseGun]', nil, self )
end

function PLAYER:GiveFakeLicenseGun()
    self.nw_FakeLicenseGun = true

    hook.Call( '[Ambi.DarkRP.GiveFakeLicenseGun]', nil, self )
end

function PLAYER:RemoveFakeLicenseGun()
    self.nw_FakeLicenseGun = false

    hook.Call( '[Ambi.DarkRP.RemoveFakeLicenseGun]', nil, self )
end

function PLAYER:RemoveLicenses()
    self:RemoveRealLicenseGun()
    self:RemoveFakeLicenseGun()
end

hook.Add( 'PlayerDeath', 'Ambi.DarkRP.RemoveLicenseGun', function( ePly ) 
    ePly:RemoveLicenses()
end )

-- -------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_darkrp_goverment_send_laws' )

function Ambi.DarkRP.SetLaw( nID, sText )
    sText = sText or ''

    local laws = Ambi.DarkRP.Laws()
    local law = laws[ nID ]
    if not law then return end

    Ambi.DarkRP.laws[ nID ] = sText

    net.Start( 'ambi_darkrp_goverment_send_laws' )
        net.WriteTable( Ambi.DarkRP.Laws() )
    net.Broadcast()
end

function Ambi.DarkRP.ClearLaws()
    for i = 1, #Ambi.DarkRP.Config.goverment_laws_default do
        Ambi.DarkRP.laws[ i ] = Ambi.DarkRP.Config.goverment_laws_default[ i ]
    end

    net.Start( 'ambi_darkrp_goverment_send_laws' )
        net.WriteTable( Ambi.DarkRP.Laws() )
    net.Broadcast()
end

hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.SendPlayersLaws', function( ePly ) 
    timer.Simple( 1, function()
        if not IsValid( ePly ) then return end

        net.Start( 'ambi_darkrp_goverment_send_laws' )
            net.WriteTable( Ambi.DarkRP.Laws() )
        net.Send( ePly )
    end )
end )