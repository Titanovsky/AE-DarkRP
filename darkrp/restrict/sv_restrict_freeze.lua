local MATERIAL, COLLISION_GROUP = 'models/wireframe', COLLISION_GROUP_WORLD
local classes = {
    [ 'prop_physics' ] = true,
    [ 'prop_dynamic' ] = true,
}

-- ---------------------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.AddRestrictEntityFreeze( sClass )
    if not sClass then return end

    classes[ sClass ] = true

    hook.Add( '[Ambi.DarkRP.AddedRestrictEntityFreeze]', nil, sClass )
end

function Ambi.DarkRP.RemoveRestrictEntityFreeze( sClass )
    if not sClass then return end

    classes[ sClass ] = nil

    hook.Add( '[Ambi.DarkRP.RemovedRestrictEntityFreeze]', nil, sClass )
end

-- ---------------------------------------------------------------------------------------------------------------------
hook.Add( 'PlayerSpawnedProp', 'Ambi.DarkRP.RestrictEntityFreeze', function( ePly, sMdl, eObj )
    if not Ambi.DarkRP.Config.restrict_entities_nocollide_between then return end

    eObj:SetCustomCollisionCheck( true )
    
    if not Ambi.DarkRP.Config.restrict_entities_freeze_on_spawn then return end

    local phys = eObj:GetPhysicsObject()
    if IsValid( phys ) then phys:EnableMotion( false ) end
    
    local around_entities = ents.FindInSphere( eObj:LocalToWorld( eObj:OBBCenter() ), eObj:BoundingRadius() )
    for _, ent in ipairs( around_entities ) do
        if ent:IsPlayer() then  
            eObj.old_collision = eObj.old_collision or eObj:GetCollisionGroup()
            eObj.old_material = eObj.old_material or eObj:GetMaterial()

            eObj:SetCollisionGroup( COLLISION_GROUP )
            eObj:SetMaterial( MATERIAL )

            break
        end
    end
end )

hook.Add( 'ShouldCollide', 'Ambi.DarkRP.RestrictEntityFreeze', function( eObj1, eObj2 )
    if Ambi.DarkRP.Config.restrict_entities_nocollide_between and classes[ eObj1:GetClass() ] and classes[ eObj2:GetClass() ] then return false end
end )

hook.Add( 'OnPhysgunPickup', 'Ambi.DarkRP.RestrictEntityFreeze', function( ePly, eObj )
    if not Ambi.DarkRP.Config.restrict_entities_nocollide_on_physgun_use then return end
    if not classes[ eObj:GetClass() ] then return end
    if not IsValid( eObj ) then return end

    eObj.old_collision = eObj.old_collision or eObj:GetCollisionGroup()
    eObj.old_material = eObj.old_material or eObj:GetMaterial()

    eObj:SetCollisionGroup( COLLISION_GROUP )
    eObj:SetMaterial( MATERIAL )
end )

hook.Add( 'PhysgunDrop', 'Ambi.DarkRP.RestrictEntityFreeze', function( ePly, eObj )
    if not Ambi.DarkRP.Config.restrict_entities_nocollide_on_physgun_use then return end
    if not classes[ eObj:GetClass() ] then return end
    if not IsValid( eObj ) then return end

    eObj:GetPhysicsObject():EnableMotion( false )

    local around_entities = ents.FindInSphere( eObj:LocalToWorld( eObj:OBBCenter() ), eObj:BoundingRadius() )
    for _, ent in ipairs( around_entities ) do
        if ent:IsPlayer() then return false end
    end

    eObj:SetCollisionGroup( eObj.old_collision or 0 )
    eObj:SetMaterial( eObj.old_material or '' )

    eObj.old_collision, eObj.old_material = nil
end )