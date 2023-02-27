local RegEnt = Ambi.Packages.Out( 'regentity' )
-- https://github.com/FPtje/DarkRP/blob/master/entities/entities/darkrp_billboard

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'darkrp_billboard'
ENT.Type	    = 'anim'

ENT.PrintName	= 'UNUSUDED'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  false
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.IsDarkRPBillboard = true -- for compatiblity

ENT.Stats = {
    module = 'DarkRP',
    date = '09.02.2023 10:27'
}

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "TopText", {
        KeyName = "toptext",
        Edit = {
            type = "Generic",
            title = "Top text",
            category = "Text",
            order = 0
        }
    })

    self:NetworkVar("String", 1, "BottomText", {
        KeyName = "bottomtext",
        Edit = {
            type = "Generic",
            title = "Bottom text",
            category = "Text",
            order = 1
        }
    })

    self:NetworkVar("Vector", 0, "BackgroundColor", {
        KeyName = "backgroundcolor",
        Edit = {
            type = "VectorColor",
            title = "Background color",
            category = "Color",
            order = 0
        }
    })

    self:NetworkVar("Vector", 1, "BarColor", {
        KeyName = "barcolor",
        Edit = {
            type = "VectorColor",
            title = "Top bar color",
            category = "Color",
            order = 1
        }
    })
end

RegEnt.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local Draw = Ambi.Packages.Out( 'draw' )

    ENT.DrawPos = Vector(1, -111, 58)

    ENT.Width = 558
    ENT.Height = 290

    ENT.HeaderMargin = 10
    ENT.BodyMargin = 10

    ENT.HeaderFont = "Trebuchet48"
    ENT.BodyFont = "DermaLarge"

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end

    return RegEnt.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEnt.Initialize( self, 'models/props_c17/consolebox01a.mdl' )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:SetDefaults( sText )
end

RegEnt.Register( ENT.Class, 'ents', ENT )