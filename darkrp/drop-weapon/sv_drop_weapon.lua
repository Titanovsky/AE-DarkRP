local C, Gen =  Ambi.General.Global.Colors, Ambi.General
local PLAYER = FindMetaTable( 'Player' )
local GetFrontPos = Ambi.General.Utility.GetFrontPos
local MAX_POS = 44

-- ---------------------------------------------------------------------------------------------------------------------------------
function PLAYER:DropActiveWeapon()
    local weapon = self:GetActiveWeapon()
    if not IsValid( weapon ) then return end
    if weapon.cannot_drop then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Это оружие нельзя дюпать!' ) return end

    local class = weapon:GetClass()
    if Ambi.DarkRP.Config.weapon_drop_blocked[ class ] then return end

    if timer.Exists( 'AmbiDarkRPBlockDropWeapon:'..self:SteamID() ) then self:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Пожалуйста, подождите!' ) return end
    timer.Create( 'AmbiDarkRPBlockDropWeapon:'..self:SteamID(), Ambi.DarkRP.Config.weapon_drop_delay, 1, function() end )

    if ( hook.Call( '[Ambi.DarkRP.CanDropWeapon]', nil, self, class, weapon ) == false ) then return end
    
    local pos, ang = GetFrontPos( self, MAX_POS ), self:EyeAngles()
    local ammo = self:GetAmmoCount( weapon:GetPrimaryAmmoType() ) + weapon:Clip1()

    local ent = ents.Create( 'spawned_weapon' )
    ent:SetPos( pos )
    ent:SetAngles( ang )
    ent:SetInfo( class, weapon:GetModel(), ammo )
    ent:Spawn()

    local weapon = self:GetWeapon( class )

    self:SetAmmo( -ammo, weapon:GetPrimaryAmmoType() )
    self:StripWeapon( class )

    if Ambi.DarkRP.Config.weapon_drop_has_owner then 
        if ent.CPPISetOwner then ent:CPPISetOwner( self ) end -- integration with FPP
    end

    hook.Call( '[Ambi.DarkRP.DroppedWeapon]', nil, self, ent, weapon )

    return true
end