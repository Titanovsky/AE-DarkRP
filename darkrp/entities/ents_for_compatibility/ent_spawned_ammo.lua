local RegEnt = Ambi.Packages.Out( 'regentity' )
-- https://github.com/FPtje/DarkRP/blob/master/entities/entities/spawned_ammp

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'spawned_ammo'
ENT.Type	    = 'anim'

ENT.PrintName	= 'UNUSUDED'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.IsSpawnedAmmo = true

ENT.Stats = {
    module = 'DarkRP',
    date = '14.02.2023 13:20'
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
    RegEnt.Initialize( self, 'models/props_c17/consolebox01a.mdl' )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:Use(activator, caller)
    local canUse, reason = hook.Call("canDarkRPUse", nil, activator, self, caller)
    if canUse == false then
        if reason then DarkRP.notify(activator, 1, 4, reason) end
        return
    end

    hook.Call("playerPickedUpAmmo", nil, activator, self.amountGiven, self.ammoType, self)

    activator:GiveAmmo(self.amountGiven, self.ammoType)
    self:Remove()
end

function ENT:StartTouch(ent)
    -- the .USED var is also used in other mods for the same purpose
    if ent.IsSpawnedAmmo ~= true or
        self.ammoType ~= ent.ammoType or
        self.hasMerged or ent.hasMerged then return end

    ent.hasMerged = true
    ent.USED = true

    local selfAmount, entAmount = self.amountGiven, ent.amountGiven
    local totalAmount = selfAmount + entAmount
    self.amountGiven = totalAmount

    ent:Remove()
end

RegEnt.Register( ENT.Class, 'ents', ENT )