local C, RegEnt = Ambi.General.Global.Colors, Ambi.RegEntity

-- ---------------------------------------------------------------------------------------------------------------------------------------
local SWEP = {}
SWEP.Primary = {}
SWEP.Secondary = {}

SWEP.Class          = 'stick_base'
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Base           = 'weapon_base'
SWEP.Category       = 'DarkRP'
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = true
SWEP.PrintName      = 'StunStick'                   
SWEP.Author         = 'Ambi'
SWEP.Instructions   = 'ПКМ - Арестовать\nЛКМ — Поменять на Unarrest'
SWEP.ViewModelFOV   = 55
SWEP.Slot           = 0    
SWEP.SlotPos        = 1
SWEP.DrawCrosshair  = true
SWEP.Weight         = 5 
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModel      = 'models/weapons/c_stunstick.mdl'
SWEP.WorldModel     = 'models/weapons/w_stunbaton.mdl'
SWEP.AnimPrefix = "stunstick"

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = ''

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = true
SWEP.Secondary.Ammo        = ''

SWEP.UseHands = false

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    -- Bool 0 = IronsightsPredicted
    -- Bool 1 = Reloading
    self:NetworkVar("Bool", 2, "SeqIdling")
    -- Float 0 = IronsightsTime
    -- Float 1 = LastPrimaryAttack
    -- Float 2 = ReloadEndTime
    -- Float 3 = BurstTime
    self:NetworkVar("Float", 4, "SeqIdleTime")
    self:NetworkVar("Float", 5, "HoldTypeChangeTime")
end

local stunstickMaterials
function SWEP:Initialize()
    self:SetHoldType("normal")

    self.stickRange = 90

    if SERVER then return end

    stunstickMaterials = stunstickMaterials or {}

    local materialName = "darkrp/" .. self:GetClass()
    if stunstickMaterials[materialName] then return end

    CreateMaterial(materialName, "VertexLitGeneric", {
        ["$basetexture"] = "models/debug/debugwhite",
        ["$surfaceprop"] = "metal",
        ["$envmap"] = "env_cubemap",
        ["$envmaptint"] = "[ .5 .5 .5 ]",
        ["$selfillum"] = 0,
        ["$model"] = 1
    }):SetVector("$color2", self.StickColor:ToVector())

    stunstickMaterials[materialName] = true
end

function SWEP:Deploy()
    BaseClass.Deploy(self)
    if SERVER then
        self:SetMaterial("!darkrp/" .. self:GetClass())
    end

    local vm = self:GetOwner():GetViewModel()
    if not IsValid(vm) then return true end

    vm:SendViewModelMatchingSequence(vm:LookupSequence("idle01"))

    return true
end

function SWEP:PreDrawViewModel(vm)
    for i = 9, 15 do
        vm:SetSubMaterial(i, "!darkrp/" .. self:GetClass())
    end
end

function SWEP:ViewModelDrawn(vm)
    if not IsValid(vm) then return end
    vm:SetSubMaterial() -- clear sub-materials
end

function SWEP:ResetStick()
    if not IsValid(self:GetOwner()) then return end
    if SERVER then
        self:SetMaterial() -- clear material
    end
    self:SetSeqIdling(false)
    self:SetSeqIdleTime(0)
    self:SetHoldTypeChangeTime(0)
end

function SWEP:Holster()
    BaseClass.Holster(self)
    self:ResetStick()
    return true
end

function SWEP:Think()
    if self:GetSeqIdling() then
        self:SetSeqIdling(false)

        if not IsValid(self:GetOwner()) then return end
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
        self:EmitSound(self.Sound)

        local vm = self:GetOwner():GetViewModel()
        if not IsValid(vm) then return end
        vm:SendViewModelMatchingSequence(vm:LookupSequence("attackch"))
        vm:SetPlaybackRate(1 + 1 / 3)
        local duration = vm:SequenceDuration() / vm:GetPlaybackRate()
        local time = CurTime() + duration
        self:SetSeqIdleTime(time)
        self:SetNextPrimaryFire(time)
    end
    if self:GetSeqIdleTime() ~= 0 and CurTime() >= self:GetSeqIdleTime() then
        self:SetSeqIdleTime(0)

        if not IsValid(self:GetOwner()) then return end
        local vm = self:GetOwner():GetViewModel()
        if not IsValid(vm) then return end
        vm:SendViewModelMatchingSequence(vm:LookupSequence("idle01"))
    end
    if self:GetHoldTypeChangeTime() ~= 0 and CurTime() >= self:GetHoldTypeChangeTime() then
        self:SetHoldTypeChangeTime(0)
        self:SetHoldType("normal")
    end
end

function SWEP:PrimaryAttack()
    self:SetHoldType("melee")
    self:SetHoldTypeChangeTime(CurTime() + 0.3)

    self:SetNextPrimaryFire(CurTime() + 0.51) -- Actual delay is set later.

    local vm = self:GetOwner():GetViewModel()
    if IsValid(vm) then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("idle01"))
        self:SetSeqIdling(true)
    end
end

function SWEP:SecondaryAttack()
    -- Do nothing
end

function SWEP:Reload()
    -- Do nothing
end

RegEnt.Register( SWEP.Class, 'weapons', SWEP )