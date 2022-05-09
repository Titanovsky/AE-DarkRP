local C, RegEnt = Ambi.General.Global.Colors, Ambi.RegEntity

local SWEP = {}
SWEP.Class          = 'stunstick'
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
SWEP.darkrp_colorized = { color = C.AMBI_BLUE, material = 'models/debug/debugwhite' }

SWEP.Primary = {}
SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = ''

SWEP.Secondary = {}
SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = true
SWEP.Secondary.Ammo        = ''

SWEP.UseHands=true

function SWEP:Initialize()
    self:SetWeaponHoldType( 'melee' )
    self:SetMaterial( self.darkrp_colorized.material )
    self:SetColor( self.darkrp_colorized.color )
end 

function SWEP:Deploy()
    return true
end

function SWEP:PrimaryAttack()
    local owner = self.Owner

    self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:SetNextPrimaryFire(CurTime()+1)
    self:SetNextSecondaryFire(CurTime()+1)

    if CLIENT then self:EmitSound( 'Weapon_Crowbar.Single' ) end

    local trace={ 
        start=self.Owner:GetShootPos(),
        endpos=self.Owner:GetShootPos()+self.Owner:GetAimVector()*50,
	    mins=Vector(-5,-5,-5),
		maxs=Vector(5,5,5),
        filter=self.Owner
    }
					   
    local tr=util.TraceHull(trace)
    if tr.Hit then
        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    end

    -- local ef= EffectData()
	-- ef:SetOrigin(tr.HitPos)
	-- ef:SetNormal(tr.HitNormal)
	-- util.Effect("StunstickImpact",ef)

    if SERVER then
        local ply = tr.Entity
        if not IsValid( ply ) or not ply:IsPlayer() then return end

        ply:SetVelocity( owner:GetAimVector() * 300 )
        ply:TakeDamage( 4, owner, self )
        owner:EmitSound( 'Weapon_StunStick.Melee_Hit' )

        ply:ScreenFade(SCREENFADE.IN, C.AMBI_WHITE, 0.75, 0)
    end
end


function SWEP:SecondaryAttack()
    local owner = self.Owner

    self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:SetNextPrimaryFire(CurTime()+1)
    self:SetNextSecondaryFire(CurTime()+1)

    if CLIENT then self:EmitSound( 'Weapon_Crowbar.Single' ) end

    local trace={ 
        start=self.Owner:GetShootPos(),
        endpos=self.Owner:GetShootPos()+self.Owner:GetAimVector()*50,
	    mins=Vector(-5,-5,-5),
		maxs=Vector(5,5,5),
        filter=self.Owner
    }
					   
    local tr=util.TraceHull(trace)
    if tr.Hit then
        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    end

    if SERVER then
        local ply = tr.Entity
        if not IsValid( ply ) or not ply:IsPlayer() then return end

        ply:SetVelocity( owner:GetAimVector() * 500 )
        ply:TakeDamage( 8, owner, self )
        owner:EmitSound( 'Weapon_StunStick.Melee_Hit' )
    end
end

RegEnt.Register( SWEP.Class, 'weapons', SWEP )