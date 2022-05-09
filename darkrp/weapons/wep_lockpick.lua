local C, RegEnt = Ambi.General.Global.Colors, Ambi.RegEntity

local SWEP = {}
SWEP.Class          = 'lockpick'
SWEP.Base           = 'weapon_base'
SWEP.Category       = 'DarkRP'
SWEP.Spawnable      = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly      = true
SWEP.PrintName      = 'Lockpick'                   
SWEP.Author         = 'Ambi'
SWEP.Instructions   = 'ПКМ - Взломать замок двери или кейпад'
SWEP.Slot           = 0    
SWEP.SlotPos        = 1
SWEP.DrawCrosshair  = true
SWEP.Weight         = 5 
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV   = 62
SWEP.ViewModel      = 'models/weapons/c_crowbar.mdl'
SWEP.WorldModel     = 'models/weapons/w_crowbar.mdl'
SWEP.AnimPrefix     = 'rpg'

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
    self:SetHoldType( 'normal' )
end

function SWEP:Deploy()
    return true
end

local ANGEL = Angle(-25, -15, 0)
function SWEP:PrimaryAttack()
    local owner = self.Owner

    self:SetNextPrimaryFire( CurTime() + 0.25 )

    if SERVER then
        if not Ambi.DarkRP.Config.lockpick_enable then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Система Взлома - отключена!' ) return end

        local entity = owner:GetEyeTrace().Entity
        if not IsValid( entity ) then return end
        if entity:IsDoor() and not Ambi.DarkRP.Config.lockpick_can_doors then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Двери нельзя взламывать!' ) return end
        if entity:IsKeypad() and not Ambi.DarkRP.Config.lockpick_can_keypad then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Кейпады нельзя взламывать!' ) return end
        if entity:IsFadingDoor() and not Ambi.DarkRP.Config.lockpick_can_fading_doors then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Fading Door нельзя взламывать!' ) return end
        if not owner:CheckDistance( entity, 94 ) then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подойдите ближе!' ) return end
        if not entity:CanBeUsedByLockpick() then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Нельзя взломать!' ) return end

        local delay_ply = owner:GetDelay( 'AmbiDarkRPLockpick' )
        if delay_ply then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Подождите: '..tostring( delay_ply ) ) return end

        if ( hook.Call( '[Ambi.DarkRP.CanUseLockpick]', nil, owner, entity ) == false ) then return end

        local delay_entity = math.floor( timer.TimeLeft( 'AmbiDarkRPLockpickDelayEntity['..entity:EntIndex()..']' ) )
        if timer.Exists( 'AmbiDarkRPLockpickDelayEntity['..entity:EntIndex()..']' ) then owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Эту дверь можно взломать через '..tostring( delay_entity )..' секунд' ) return end

        owner:SetDelay( 'AmbiDarkRPLockpick', Ambi.DarkRP.Config.lockpick_delay_player )

        local chance = math.random( 1, 100 )
        local normal_chance = Ambi.DarkRP.Config.lockpick_chance 
        if ( chance > normal_chance ) then 
            owner:EmitSound( 'physics/wood/wood_box_footstep4.wav' )
            owner:ChatSend( C.ERROR, '•  ', C.ABS_WHITE, 'Взлом не удался ['..chance..'/'..normal_chance..']' ) 
            return 
        end

        timer.Create( 'AmbiDarkRPLockpickDelayEntity['..entity:EntIndex()..']', Ambi.DarkRP.Config.lockpick_delay_entity, 1, function() end )

        owner:ChatSend( C.AMBI_BLACK, '•  ', C.ABS_WHITE, 'Взлом удался ['..chance..'/'..normal_chance..']' )

        hook.Call( 'lockpickStarted', nil, owner, entity, owner:GetEyeTrace() )

        if entity:IsDoor() then
            entity:Fire( 'Unlock' )
            entity:Fire( 'Open' )
        elseif entity:IsFadingDoor() then
            ent:fadeActivate()
        elseif entity:IsKeypad() then
            --
        end
    end
end

function SWEP:SecondaryAttack()
    return true
end

RegEnt.Register( SWEP.Class, 'weapons', SWEP )