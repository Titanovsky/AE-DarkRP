local RegEnt = Ambi.Packages.Out( 'regentity' )
-- https://github.com/FPtje/DarkRP/blob/master/entities/entities/darkrp_cheque

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'darkrp_cheque'
ENT.Type	    = 'anim'

ENT.PrintName	= 'UNUSUDED'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.IsDarkRPCheque = true

ENT.Stats = {
    module = 'DarkRP',
    date = '14.02.2023 12:30'
}

ENT.IsDarkRPCheque = true

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")
    self:NetworkVar("Entity", 1, "recipient")
    self:NetworkVar("Int", 0, "amount")
end

RegEnt.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local Draw = Ambi.Packages.Out( 'draw' )

    ENT.TextColors = {
        OtherToSelf = Color(0, 255, 0, 255),
        SelfToSelf = Color(255, 255, 0, 255),
        SelfToOther = Color(0, 0, 255, 255),
        OtherToOther = Color(255, 0, 0, 255)
    }

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return RegEnt.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEnt.Initialize( self, 'models/props_c17/consolebox01a.mdl' )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self.nodupe = true
end

function ENT:onPlayerDisconnected(ply)
end

RegEnt.Register( ENT.Class, 'ents', ENT )