local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'darkrp_repair_kit'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Ремонтный Комплект'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'DarkRP',
    model = 'models/Items/battery.mdl',
    date = '11.04.2022 11:19'
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
    Ents.Initialize( self, ENT.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 30 )
    self:SetMaxHealth( 30 )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

Ents.Register( ENT.Class, 'ents', ENT )