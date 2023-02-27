local RegEnt = Ambi.Packages.Out( 'regentity' )
-- https://github.com/FPtje/DarkRP/blob/master/entities/entities/lab_base

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'lab_base'
ENT.Type	    = 'anim'

ENT.PrintName	= 'UNUSUDED'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.CanSetPrice = true

-- These are variables that should be set in entities that base from this
ENT.model = ""
ENT.initialPrice = 0
ENT.labPhrase = ""
ENT.itemPhrase = ""
ENT.noIncome = false
ENT.camMul = -30
ENT.blastRadius = 200
ENT.blastDamage = 200

ENT.Stats = {
    module = 'DarkRP',
    date = '14.02.2023 12:30'
}

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "price")
    self:NetworkVar("Entity", 1, "owning_ent")
end

RegEnt.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local Draw = Ambi.Packages.Out( 'draw' )

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return RegEnt.Register( ENT.Class, 'ents', ENT )
end 

ENT.Once = false

function ENT:Initialize()
    RegEnt.Initialize( self, 'models/props_c17/consolebox01a.mdl' )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self.sparking = false
    self.damage = 100
    self:Setprice(math.Clamp(self.initialPrice, (GAMEMODE.Config.pricemin ~= 0 and GAMEMODE.Config.pricemin) or self.initialPrice, (GAMEMODE.Config.pricecap ~= 0 and GAMEMODE.Config.pricecap) or self.initialPrice))
end

function ENT:Setprice( nPrice )
end

function ENT:Destruct()
end

function ENT:SalePrice(activator)
end

function ENT:canUse(owner, activator)
    return true
end

function ENT:createItem(activator)
    -- Implement this function
end

RegEnt.Register( ENT.Class, 'ents', ENT )