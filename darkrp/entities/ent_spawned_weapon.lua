local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'spawned_weapon'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Money'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false

ENT.Stats = {
    type = 'Entity',
    module = 'DarkRP',
    date = '19.03.2022 0:24'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( Ambi.DarkRP.Config.weapon_drop_health )
    self:SetMaxHealth( Ambi.DarkRP.Config.weapon_drop_health )
end

function ENT:OnTakeDamage( damageInfo )
    if ( Ambi.DarkRP.Config.weapon_drop_can_destroy == false ) then return end

    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:SetInfo( sClass, sModel, nCount )
    self.nw_ClassWeapon = sClass
    self:SetModel( sModel ) 
    self.ammo = nCount
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not self.nw_ClassWeapon then return end
    if ( hook.Call( 'PlayerCanPickupWeapon', nil, ePly, self, self.nw_ClassWeapon, self.ammo ) == false ) then return end
    
    ePly:Give( self.nw_ClassWeapon, self.ammo and true or false )

    hook.Call( '[Ambi.DarkRP.PlayerPickupWeapon]', nil, ePly, self )

    local ammo = self.ammo
    if ammo then
        ePly:GiveAmmo( self.ammo, ePly:GetWeapon( self.nw_ClassWeapon ):GetPrimaryAmmoType() )
    end

    self:Remove()
end

Ents.Register( ENT.Class, 'ents', ENT )