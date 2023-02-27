local C, RegEnt = Ambi.General.Global.Colors, Ambi.RegEntity

local SWEP = {}
SWEP.Class          = 'unarrest_stick'
SWEP.Base           = 'weapon_base'
SWEP.Category       = 'DarkRP'
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = true
SWEP.PrintName      = 'UnArrest'                   
SWEP.Author         = 'Ambi'
SWEP.Instructions   = 'ПКМ - Освободить\nЛКМ — Поменять на Arrest'
SWEP.ViewModelFOV   = 55
SWEP.Slot           = 0    
SWEP.SlotPos        = 1
SWEP.DrawCrosshair  = true
SWEP.Weight         = 5 
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModel      = 'models/weapons/c_stunstick.mdl'
SWEP.WorldModel     = 'models/weapons/w_stunbaton.mdl'
SWEP.darkrp_colorized = { color = C.AMBI_GREEN, material = 'models/debug/debugwhite' }

SWEP.StickColor = C.AMBI_GREEN -- for compatibility

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
    self:SetWeaponHoldType( 'Melee' )
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
    self:SetNextSecondaryFire(CurTime()+0.35)

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

        if not Ambi.DarkRP.Config.police_system_enable then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Полицейская Система - отключена!' ) return end
        if not Ambi.DarkRP.Config.police_system_arrest_enable then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Отключена возможность освободить игрока!' ) return end
        if Ambi.DarkRP.Config.police_system_arrest_can_only_police and not owner:GetJobTable().police then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваша работа не имеет право освобождать!' ) return end

        if not ply:IsArrested() then return end

        self:EmitSound( 'Weapon_Stunstick.Melee_Hit' )

        Ambi.DarkRP.UnArrest( ply, owner )

        if not ply:IsArrested() then
            owner:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вы освободили ', C.AMBI_GREEN, ply:Nick() )
            ply:ChatSend( C.AMBI_GREEN, '•  ', C.ABS_WHITE, 'Вас освободил ', C.AMBI_GREEN, owner:Nick() )
        end
    end
end

function SWEP:SecondaryAttack()
    if not SERVER then return end

    local owner = self.Owner
    if owner:HasWeapon( 'arrest_stick' ) then
        owner:SelectWeapon( 'arrest_stick' )
    end
end

RegEnt.Register( SWEP.Class, 'weapons', SWEP )