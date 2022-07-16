local C, RegEnt = Ambi.General.Global.Colors, Ambi.RegEntity

local SWEP = {}
SWEP.Class          = 'arrest_stick'
SWEP.Base           = 'weapon_base'
SWEP.Category       = 'DarkRP'
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = true
SWEP.PrintName      = 'Arrest'                   
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
SWEP.darkrp_colorized = { color = C.AMBI_RED, material = 'models/debug/debugwhite' }

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
        if not owner:GetDelay( 'AmbiDarkRpDelayArrest' ) then owner:SetDelay( 'AmbiDarkRpDelayArrest' ) else owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите!' ) return end

        local ply = tr.Entity
        if not IsValid( ply ) or not ply:IsPlayer() then return end

        if not Ambi.DarkRP.Config.police_system_enable then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Полицейская Система - отключена!' ) return end
        if not Ambi.DarkRP.Config.police_system_arrest_enable then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Отключена возможность арестовать игрока!' ) return end

        if Ambi.DarkRP.Config.police_system_arrest_can_only_police and not owner:GetJobTable().police then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Ваша работа не имеет право арестовать!' ) return end
        if Ambi.DarkRP.Config.police_system_arrest_can_other_police and ply:IsPolice() then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данного игрока нельзя арестовать!' ) return end
        if Ambi.DarkRP.Config.police_system_arrest_only_wanted and not ply:IsWanted() then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Можно арестовать только тех, кто в розыске!' ) return end

        if ply:IsArrested() then ply:Spawn() return end

        self:EmitSound( 'Weapon_Stunstick.Melee_Hit' )

        Ambi.DarkRP.Arrest( ply, owner, '', Ambi.DarkRP.Config.police_system_arrest_time )

        owner:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вы арестовали ', C.AMBI_BLUE, ply:Nick() )
        ply:ChatSend( C.AMBI_BLUE, '•  ', C.ABS_WHITE, 'Вас арестовал ', C.AMBI_BLUE, owner:Nick() )
    end
end

function SWEP:SecondaryAttack()
    if not SERVER then return end

    local owner = self.Owner
    if owner:HasWeapon( 'unarrest_stick' ) then
        owner:SelectWeapon( 'unarrest_stick' )
    end
end

RegEnt.Register( SWEP.Class, 'weapons', SWEP )