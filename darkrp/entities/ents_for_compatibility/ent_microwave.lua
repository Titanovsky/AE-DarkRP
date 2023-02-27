local RegEnt = Ambi.Packages.Out( 'regentity' )
-- https://github.com/FPtje/DarkRP/blob/master/entities/entities/microwave

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'microwave'
ENT.Type	    = 'anim'
ENT.Base        = 'lab_base'

ENT.PrintName	= 'UNUSUDED'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Stats = {
    module = 'DarkRP',
    date = '14.02.2023 12:30'
}

function ENT:initVars()
    self.model = "models/props/cs_office/microwave.mdl"
    self.initialPrice = GAMEMODE.Config.microwavefoodcost
    self.labPhrase = 'microwave'
    self.itemPhrase = 'food'
end

RegEnt.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local Draw = Ambi.Packages.Out( 'draw' )

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return RegEnt.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEnt.Initialize( self, 'models/props_c17/consolebox01a.mdl' )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

ENT.SpawnOffset = Vector(0, 0, 23)

function ENT:canUse(activator)
    if activator.maxFoods and activator.maxFoods >= GAMEMODE.Config.maxfoods then
        DarkRP.notify(activator, 1, 3, DarkRP.getPhrase("limit", self.itemPhrase))
        return false
    end
    return true
end

function ENT:createItem(activator)
    local foodPos = self:GetPos() + self.SpawnOffset
    local food = ents.Create("food")
    food:SetPos(foodPos)
    food:Setowning_ent(activator)
    food.nodupe = true
    food:Spawn()
    if not activator.maxFoods then
        activator.maxFoods = 0
    end
    activator.maxFoods = activator.maxFoods + 1
end

RegEnt.Register( ENT.Class, 'ents', ENT )