local RegEnt, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'spawned_weapon'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Money'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false
ENT.IsSpawnedWeapon = true -- for compatibility

ENT.Stats = {
    type = 'Entity',
    module = 'DarkRP',
    date = '19.03.2022 0:24'
}

function ENT:GetClassWeapon()
    return self.nw_ClassWeapon or 'none'
end

function ENT:GetAmount()
    return self.nw_Amount
end

function ENT:Getamount()
    return self:GetAmount() -- for compatibility
end

function ENT:GetWeaponClass()
    return self:GetClassWeapon() -- for compatibility
end

RegEnt.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return RegEnt.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEnt.Initialize( self )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( Ambi.DarkRP.Config.weapon_drop_health )
    self:SetMaxHealth( Ambi.DarkRP.Config.weapon_drop_health )

    self.amount = 1
end

function ENT:OnTakeDamage( damageInfo )
    if ( Ambi.DarkRP.Config.weapon_drop_can_destroy == false ) then return end

    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:SetInfo( sClass, sModel, nAmmo, nAmount )
    self.nw_ClassWeapon = sClass
    self.nw_Amount = nAmount or 1
    self.ammo = nAmmo or 1
    if sModel then self:SetModel( sModel ) end

    -- for compatibility -----------------------------------------
    self.weaponclass = sClass
    self.clip1 = 0
    self.clip2 = 0
    self.ammoadd = nAmmo
    --------------------------------------------------------------
end

function ENT:SetAmmo( nAmmo )
    if ( nAmmo <= 0 ) then self:Remove() return end

    self.ammo = nAmmo or 1

    self.clip1 = 0 -- for compatibility
    self.clip2 = 0 -- for compatibility
    self.ammoadd = nAmmo -- for compatibility
end

function ENT:SetClassWeapon( sClass )
    self.nw_ClassWeapon = sClass
    self.weaponclass = sClass -- for compatibility
end

function ENT:SetAmount( nAmount )
    self.nw_Amount = nAmount
    self.amount = nAmount -- for compatibility
end

function ENT:SetWeaponClass( sClass ) -- for compatibility
    return self:SetClassWeapon( sClass )
end

function ENT:Setamount( nAmount ) -- for compatibility
    return self:SetAmount( nAmount )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not self.nw_ClassWeapon then return end
    if ( hook.Call( 'PlayerCanPickupWeapon', nil, ePly, self, self.nw_ClassWeapon, self.ammo, self.nw_Amount ) == false ) then return end
    
    local weapon = ePly:Give( self.nw_ClassWeapon, self.ammo and true or false )

    local amount = self:GetAmount()
    
    local ammo = self.ammo
    if ammo then
        ePly:GiveAmmo( self.ammo, ePly:GetWeapon( self.nw_ClassWeapon ):GetPrimaryAmmoType() ) --! не реализовано умножение на amount, так как каждая копия не сохраняет за собой патроны
    end

    hook.Call( '[Ambi.DarkRP.PlayerPickedupWeapon]', nil, ePly, weapon, self, self.nw_ClassWeapon, self.ammo, self.nw_Amount )

    local minus_amount = amount - 1
    if ( minus_amount > 0 ) then
        self:SetAmount( minus_amount )
    else
        self:Remove()
    end
end

-- for Compatibility ---------------------------------------------------------------------------------------
function ENT:DecreaseAmount()
    self:SetAmount( self:GetAmount() - 1 )
end

function ENT:GivePlayerAmmo(ply, weapon, playerHadWeapon)
    local primaryAmmoType = weapon:GetPrimaryAmmoType()
    local secondaryAmmoType = weapon:GetSecondaryAmmoType()
    local clip1, clip2 = self.clip1, self.clip2

    if playerHadWeapon then
        if clip2 and clip2 > 0 and weapon:Clip2() ~= -1 then
            weapon:SetClip2(weapon:Clip2() + clip2)
            clip2 = 0
        end
    else
        if clip1 and clip1 ~= -1 and weapon:Clip1() ~= -1 then
            weapon:SetClip1(clip1)
            clip1 = 0
        end
        if clip2 and clip2 ~= -1 and weapon:Clip2() ~= -1 then
            weapon:SetClip2(self.clip2)
            clip2 = 0
        end
    end

    if primaryAmmoType > 0 then
        local primAmmo = ply:GetAmmoCount(primaryAmmoType)
        primAmmo = primAmmo + (self.ammoadd or 0) + (clip1 or 0) -- Gets rid of any ammo given during weapon pickup
        ply:SetAmmo(primAmmo, primaryAmmoType)
    end

    if secondaryAmmoType > 0 then
        local secAmmo = ply:GetAmmoCount(secondaryAmmoType) + (clip2 or 0)
        ply:SetAmmo(secAmmo, secondaryAmmoType)
    end
end

RegEnt.Register( ENT.Class, 'ents', ENT )