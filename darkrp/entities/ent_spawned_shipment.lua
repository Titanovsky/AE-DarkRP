local RegEnt, C = Ambi.RegEntity, Ambi.General.Global.Colors

-- ---------------------------------------------------------------------------------------------------------------------------------------
local ENT = {}

ENT.Class       = 'spawned_shipment'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Коробка'
ENT.Author		= 'Ambi'
ENT.Category	= 'DarkRP'
ENT.Spawnable   =  true
ENT.IsSpawnedShipment = true

ENT.Stats = {
    type = 'Entity',
    module = 'DarkRP',
    date = '23.04.2022 23:51'
}

function ENT:SetupDataTables()
    self:NetworkVar("Int",0,"contents")
    self:NetworkVar("Int",1,"count")
    self:NetworkVar("Float", 0, "gunspawn")
    self:NetworkVar("Entity", 1, "gunModel")
end

RegEnt.Register( ENT.Class, 'ents', ENT )

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

    return RegEnt.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEnt.Initialize( self, 'models/Items/item_item_crate.mdl' )
    RegEnt.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( Ambi.DarkRP.Config.shipment_health )
    self:SetMaxHealth( Ambi.DarkRP.Config.shipment_health )

    self.contents = self:EntIndex()
end

function ENT:OnRemove()
    CustomShipments[ self:Getcontents() ] = nil
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
    if ( hook.Call( '[Ambi.DarkRP.PlayerCanOpenShipment]', nil, ePly, self, info ) == false ) then return end

    local ent
    if info.is_weapon then
        ent = ents.Create( 'spawned_weapon' )
        ent:SetInfo( info.ent, info.model )
    else
        ent = ents.Create( info.ent )
    end

    ent:SetPos( self:GetPos() + Vector( 0, 0, 50 ) )
    ent:Spawn()
    ent:Activate()

    self.nw_Count = self.nw_Count - 1

    hook.Call( '[Ambi.DarkRP.PlayerOpenedShipment]', nil, ePly, self, info, ent )
    
    if ( self.nw_Count <= 0 ) then 
        hook.Call( '[Ambi.DarkRP.ShipmentRemoved]', nil, ePly, self, info, ent )

        self:Remove() 
    else
        timer.Create( 'AmbiDarkRPShipmentDelay['..self:EntIndex()..']', Ambi.DarkRP.Config.shipment_delay, 1, function() end )
    end
end

-- for Compatibility ---------------------------------------------------------------------------------------
function ENT:StartSpawning()
    self.locked = true

    timer.Simple(0, function() self.locked = true end) -- when spawning through pocket it might be unlocked
    timer.Simple(GAMEMODE.Config.shipmentspawntime, function() if IsValid(self) then self.locked = false end end)
end

function ENT:SetContents(s, c)
    self:Setcontents(s)
    self:Setcount(c)
end

local function calculateAmmo(class, shipment)
    local clip1, ammoadd = shipment.clip1, shipment.ammoadd

    local defaultClip, clipSize = 0, 0
    local wep_tbl = weapons.Get(class)
    if wep_tbl and istable(wep_tbl.Primary) then
        defaultClip = wep_tbl.Primary.DefaultClip or -1
        clipSize = wep_tbl.Primary.ClipSize or -1
    end
    ammoadd = ammoadd or defaultClip

    if not clip1 then
        clip1 = clipSize
    end
    return ammoadd, clip1
end

function ENT:SpawnItem()
    timer.Remove(self:EntIndex() .. "crate")
    self.sparking = false
    local count = self:Getcount()
    if count <= 1 then self:Remove() end
    local contents = self:Getcontents()

    local weapon = ents.Create("spawned_weapon")

    local weaponAng = self:GetAngles()
    local weaponPos = self:GetAngles():Up() * 40 + weaponAng:Up() * (math.sin(CurTime() * 3) * 8)
    weaponAng:RotateAroundAxis(weaponAng:Up(), (CurTime() * 180) % 360)

    if not CustomShipments[contents] then
        weapon:Remove()
        self:Remove()
        return
    end

    weapon:SetWeaponClass( self.nw_ent )
    weapon:SetModel( self.nw_Model )

    weapon.ammoadd, weapon.clip1 = calculateAmmo(class, self)
    weapon.clip2 = self.clip2
    weapon:SetPos(self:GetPos() + weaponPos)
    weapon:SetAngles(weaponAng)
    weapon.nodupe = true

    weapon:SetInfo( self.nw_ent, self.nw_Model, self.nw_Count )
    weapon:Spawn()
    
    count = count - 1
    
    self:Setcount(count)
    self.locked = false
    self.USED = nil
end

function ENT:Destruct()
    if self.Destructed then return end
    self.Destructed = true

    self:Remove()
end

RegEnt.Register( ENT.Class, 'ents', ENT )