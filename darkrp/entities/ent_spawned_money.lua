local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'spawned_money'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Money'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false
ENT.IsSpawnedMoney = true

ENT.Stats = {
    type = 'Entity',
    module = 'DarkRP',
    date = '19.03.2022 0:16'
}

function ENT:GetMoney()
    return self.nw_Money or 0
end

function ENT:Getamount() -- for compatibility
    return self:GetMoney()
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw = Ambi.Packages.Out( '@d' )
    local DISTANCE = 300
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if self.nw_Money and ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= DISTANCE ) then
            cam.Start3D2D( self:GetPos() + self:GetAngles():Up() * 1 + self:GetAngles():Right() * 0, self:GetAngles(), 0.1)
                Draw.SimpleText( 0, 0, self.nw_Money..Ambi.DarkRP.Config.money_currency_symbol, '22 Ambi', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            cam.End3D2D()
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, Ambi.DarkRP.Config.money_drop_entity_model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 100 )
    self:SetMaxHealth( 100 )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if ( hook.Call( '[Ambi.DarkRP.PlayerCanPickupMoney]', nil, ePly, self, self:GetMoney() ) == false ) then return end 

    hook.Call( '[Ambi.DarkRP.PlayerPickedupMoney]', nil, ePly, self, self:GetMoney() )
    
    ePly:AddMoney( self:GetMoney() )
    self:Remove()
end

function ENT:SetMoney( nMoney )
    if ( nMoney < 0 ) then nMoney = 0 end

    local money = math.floor( nMoney )

    self.nw_Money = money
end

function ENT:Setamount( nMoney ) -- for compatibility
    self:SetMoney( nMoney )
end

Ents.Register( ENT.Class, 'ents', ENT )