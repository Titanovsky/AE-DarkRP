local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'money_printer'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Денежный Принтер'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  Ambi.DarkRP.Config.money_printer_enable

ENT.Stats = {
    type = 'Entity',
    module = 'DarkRP',
    model = 'models/hunter/blocks/cube05x075x025.mdl',
    date = '11.04.2022 11:08'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local Draw = Ambi.Packages.Out( 'draw' )
    
    local DISTANCE = 600
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= DISTANCE ) then
            local pos = self:GetPos()
	        local ang = self:GetAngles()
            ang:RotateAroundAxis( ang:Up(), 90)

            cam.Start3D2D( pos + ang:Up() * 6, ang, 0.15 )
                Draw.Box( 210, 130, -105, -65, C.ABS_BLACK, 4 )
                Draw.Box( 200, 120, -100, -60, C.AMBI_BLACK, 4 )
                Draw.SimpleText( 2, -36, 'Состояние: '..self:Health(), '24 Arial', C.AMBI_WHITE, 'center', 1, C.ABS_BLACK )
                Draw.SimpleText( 2, -4, tostring( self.nw_Money )..Ambi.DarkRP.Config.money_currency_symbol, '42 Open Sans Condensed', C.FLAT_GREEN, 'center', 1, C.ABS_BLACK )
                
                if self.nw_BuyerName then
                    Draw.SimpleText( -98, 58, self.nw_BuyerName, '20 Open Sans Condensed', C.AMBI_WHITE, 'bottom-left', 1, C.ABS_BLACK )
                end
            cam.End3D2D()
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

local COLOR = Color( 145, 145, 145, 255 )
function ENT:Initialize()
    Ents.Initialize( self, ENT.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 100 )
    self:SetMaxHealth( 100 )
    self:SetMaterial( 'models/debug/debugwhite' )
    self:SetColor( COLOR )

    self.nw_Money = 0

    self:GenerateMoney()

    local index = self:EntIndex()
    timer.Create( 'DarkRPCheckTime:'..index, 1, 0, function() 
        if not IsValid( self ) then timer.Remove( 'DarkRPCheckTime:'..index ) return end

        self.nw_Time = math.floor( timer.TimeLeft( 'DarkRPGenerateMoney:'..index ) )
    end )
end

function ENT:GenerateMoney()
    if not Ambi.DarkRP.Config.money_printer_enable then return end

    timer.Create( 'DarkRPGenerateMoney:'..self:EntIndex(), Ambi.DarkRP.Config.money_printer_delay, 1, function() 
        if not IsValid( self ) then return end

        self.nw_Money = self.nw_Money + Ambi.DarkRP.Config.money_printer_amount
        self:TakeDamage( Ambi.DarkRP.Config.money_printer_damage, self )

        self:GenerateMoney()
    end )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:Touch( eObj )
    local hp, new_hp = self:Health(), Ambi.DarkRP.Config.money_printer_repair
    if IsValid( eObj ) and ( eObj:GetClass() == Ambi.DarkRP.Config.money_printer_repair_class ) and ( hp <= Ambi.DarkRP.Config.money_printer_health - new_hp ) then
        eObj:Remove()
        self:SetHealth( hp + new_hp )
    end
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not Ambi.DarkRP.Config.money_printer_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Денежные Принтеры - Отключены!' ) return end
    if ( self.nw_Money <= 0 ) then return end
    
    ePly:AddMoney( self.nw_Money )
    self.nw_Money = 0
end

Ents.Register( ENT.Class, 'ents', ENT )