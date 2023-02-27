local RegEnt = Ambi.Packages.Out( 'regentity' )
-- https://github.com/FPtje/DarkRP/blob/master/entities/entities/letter

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'letter'
ENT.Type	    = 'anim'

ENT.PrintName	= 'UNUSUDED'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Stats = {
    module = 'DarkRP',
    date = '14.02.2023 12:30'
}

function ENT:SetupDataTables()
    self:NetworkVar("Entity",1,"owning_ent")
    self:NetworkVar("Entity",2,"signed")
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

function ENT:SignLetter(ply)
end

function ENT:onPlayerDisconnected(ply)
    if self:Getowning_ent() == ply then
        self:Remove()
    end
end

RegEnt.Register( ENT.Class, 'ents', ENT )