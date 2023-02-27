local RegEnt = Ambi.Packages.Out( 'regentity' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'food' -- for compatibility: https://github.com/FPtje/DarkRP/blob/master/entities/entities/food
ENT.Type	    = 'anim'

ENT.PrintName	= 'Еда'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  true
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Stats = {
    module = 'DarkRP',
    date = '09.02.2023 10:27'
}

RegEnt.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local Draw = Ambi.Packages.Out( 'draw' )

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return RegEnt.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEnt.Initialize( self, Ambi.DarkRP.Config.hunger_food_model )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 25 )
    self:SetFood( Ambi.DarkRP.Config.hunger_food_default_value )

    self.damage = self:GetHealth() -- for compatibility: https://github.com/FPtje/DarkRP/blob/master/entities/entities/food/init.lua#L17
end

function ENT:SetFood( nValue )
    self.food = nValue

    self.FoodEnergy = nValue -- for compatibility
    self.foodItem = self -- for compatibility and idk what is it
end

function ENT:GetFood()
    return self.food
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not Ambi.DarkRP.Config.hunger_enable then ePly:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Голода (сытости) отключена!' ) return end
    if ( hook.Call( '[Ambi.DarkRP.CanUseFood]', nil, ePly, self ) == false ) then return end

    local satiety, max = ePly:GetSatiety(), ePly:GetMaxSatiety()
    if Ambi.DarkRP.Config.hunger_food_can_use_on_full_satiety and ( satiety >= max ) then return end

    hook.Call( '[Ambi.DarkRP.PlayerAteFood]', nil, ePly, self )

    ePly:SetSatiety( math.min( satiety + self:GetFood(), max ) )
    self:Remove()
end

RegEnt.Register( ENT.Class, 'ents', ENT )