local C = Ambi.General.Global.Colors
local PLAYER = FindMetaTable( 'Player' )

-- -------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.IsLockdown()
    return GetConVar( 'ambi_darkrp_lockdown' ):GetBool()
end

-- -------------------------------------------------------------------------------------------------------
function PLAYER:HasLicenseGun()
    return self.nw_LicenseGun or self.nw_FakeLicenseGun
end

function PLAYER:HasRealLicenseGun()
    return self.nw_LicenseGun
end

function PLAYER:HasFakeLicenseGun()
    return self.nw_FakeLicenseGun
end

-- -------------------------------------------------------------------------------------------------------
function PLAYER:IsMayor()
    return self:GetJobTable().mayor
end

-- -------------------------------------------------------------------------------------------------------
Ambi.DarkRP.laws = Ambi.DarkRP.laws or {}
Ambi.DarkRP.laws = Ambi.DarkRP.Config.goverment_laws_default

function Ambi.DarkRP.Laws()
    return Ambi.DarkRP.laws
end