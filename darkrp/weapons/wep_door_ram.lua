local C, RegEnt = Ambi.General.Global.Colors, Ambi.RegEntity

local SWEP = {}
SWEP.Class          = 'door_ram'
SWEP.Base           = 'weapon_base'
SWEP.Category       = 'DarkRP'
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = true
SWEP.PrintName      = 'Door Ram'                   
SWEP.Author         = 'Ambi'
SWEP.Instructions   = 'ПКМ - Арестовать\nЛКМ — Поменять на Unarrest'
SWEP.Slot           = 0    
SWEP.SlotPos        = 1
SWEP.DrawCrosshair  = true
SWEP.Weight         = 5 
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV   = 62
SWEP.ViewModel      = 'models/weapons/c_rpg.mdl'
SWEP.WorldModel     = 'models/weapons/w_rocket_launcher.mdl'
SWEP.AnimPrefix     = 'rpg'
SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary = {}
SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = ''

SWEP.Secondary = {}
SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = ''

SWEP.UseHands=true

function SWEP:Initialize()
    self:SetHoldType("rpg")
end

function SWEP:Deploy()
    return true
end

local ANGEL = Angle(-25, -15, 0)
function SWEP:PrimaryAttack()
    local owner = self.Owner

    self:SetNextPrimaryFire( CurTime() + 1 )

    if SERVER then
        if not Ambi.DarkRP.Config.police_system_warrant_enable then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Ордера на Обыск - отключена!' ) return end
        if not owner:IsPolice() then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Вы не полицейский!' ) return end

        local door = owner:GetEyeTrace().Entity
        if not IsValid( door ) or not Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Данный объект, не дверь!' ) return end
        if not owner:CheckDistance( door, 94 ) then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подойдите ближе!' ) return end

        if not door.first_owner then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Хозяина этой двери нет!' ) return end
        if Ambi.DarkRP.Config.police_system_warrant_only_can_door_ram and not door.first_owner:HasWarrant() then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подайте Ордер на Обыск на хозяина этой двери!' ) return end

        if ( hook.Call( '[Ambi.DarkRP.CanDoorRam]', nil, owner, door ) == false ) then return end

        local delay = owner:GetDelay( 'AmbiDarkRPDoorRam' )
        if not delay then owner:SetDelay( 'AmbiDarkRPDoorRam', Ambi.DarkRP.Config.police_system_warrant_delay_door_ram ) else owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: '..tostring( delay ) ) return end
        
        door:Fire( 'Unlock' )
        door:Fire( 'Open' )

        owner:EmitSound( self.Sound )
        owner:ViewPunch( ANGEL )

        hook.Call( '[Ambi.DarkRP.OnDoorRamUsed]', nil, owner, door )
    end
end

function SWEP:SecondaryAttack()
    --return true
end

RegEnt.Register( SWEP.Class, 'weapons', SWEP )