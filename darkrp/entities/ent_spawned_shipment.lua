local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'spawned_shipment'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Коробка'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'DarkRP',
    date = '23.04.2022 23:51'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw = Ambi.Packages.Out( '@d' )
    local DISTANCE = 300
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if self.nw_Count and ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= DISTANCE ) then
            cam.Start3D2D( self:GetPos() + self:GetAngles():Up() * 24.1, self:GetAngles(), 0.1)
                Draw.Box( 220, 40, -200 / 2, -40 / 2, C.AMBI_RED, 4 )
                Draw.SimpleText( 4, 0, self.nw_Title, '16 Ambi', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )

                Draw.Box( 80, 60, -30, 40, C.AMBI_RED, 4 )
                Draw.SimpleText( 10, 70, self.nw_Count, '32 Ambi', C.ABS_WHITE, 'center', 1, C.ABS_BLACK )
            cam.End3D2D()
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, 'models/Items/item_item_crate.mdl' )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( Ambi.DarkRP.Config.shipment_health )
    self:SetMaxHealth( Ambi.DarkRP.Config.shipment_health )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:SetInfo( sTitle, sObj, nCount, sModel, bWeapon )
    sTitle = sTitle or sObj
    nCount = nCount or 1
    sModel = sModel or ''

    self.nw_Title = sTitle
    self.nw_Count = nCount
    self.nw_Model = sModel
    self.ent = sObj
    self.is_weapon = bWeapon
end

function ENT:GetInfo()
    if not self.nw_Title then return end

    return {
        title = self.nw_Title,
        count = self.nw_Count,
        model = self.nw_Model,
        is_weapon = self.is_weapon,
        ent = self.ent
    }
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not Ambi.DarkRP.Config.shipment_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Коробок - отключена!' ) return end
    if timer.Exists( 'AmbiDarkRPShipmentDelay['..self:EntIndex()..']' ) then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: ', C.ERROR, tostring( math.floor( timer.TimeLeft( 'AmbiDarkRPShipmentDelay['..self:EntIndex()..']' ) + 1 ) ), C.ABS_WHITE, ' секунд' ) return end
  
    local info = self:GetInfo()
    if not info then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'В коробке ничего нет' ) return end

    local ent
    if info.is_weapon then
        ent = ents.Create( 'spawned_weapon' )
        ent:SetInfo( info.ent, info.model )
    else
        ent = ents.Create( info.ent )
    end

    ent:SetPos( self:GetPos() + Vector( 0, 0, 50 ) )
    --ent:SetAngles( weaponAng )
    ent:Spawn()
    ent:Activate()

    self.nw_Count = self.nw_Count - 1
    
    if ( self.nw_Count <= 0 ) then 
        self:Remove() 
    else
        timer.Create( 'AmbiDarkRPShipmentDelay['..self:EntIndex()..']', Ambi.DarkRP.Config.shipment_delay, 1, function() end )
    end
end

Ents.Register( ENT.Class, 'ents', ENT )