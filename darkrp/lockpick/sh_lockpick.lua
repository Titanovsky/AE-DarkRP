local C = Ambi.Packages.Out( 'colors' )
local ENTITY = FindMetaTable( 'Entity' )

function ENTITY:IsKeypad()
    return self:GetClass() == 'keypad' or self:GetClass() == 'wire_keypad'
end

function ENTITY:IsFadingDoor()
    return self.isFadingdoor
end

function ENTITY:CanBeUsedByLockpick()
    if self:IsDoor() then return true end
    if self:IsKeypad() then return true end
    if self:IsFadingDoor() then return true end
    if Ambi.DarkRP.Config.lockpick_classes[ self:GetClass() ] then return true end

    return false
end