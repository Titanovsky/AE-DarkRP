hook.Add( 'PlayerSpawnProp', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_spawn_props == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_spawn_props == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'PlayerSpawnRagdoll', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_spawn_ragdolls == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_spawn_ragdolls == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'PlayerSpawnEffect', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_spawn_effects == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_spawn_effects == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'PlayerSpawnSENT', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_spawn_entities == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_spawn_entities == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'PlayerSpawnSWEP', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_spawn_weapons == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_spawn_weapons == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'PlayerGiveSWEP', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_spawn_weapons == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_spawn_weapons == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'PlayerSpawnNPC', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_spawn_npcs == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_spawn_npcs == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'PlayerSpawnVehicle', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_spawn_vehicles == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_spawn_vehicles == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'CanProperty', 'Ambi.DarkRP.Restrict', function( ePly, sProperty ) 
    if ( Ambi.DarkRP.Config.restrict_use_properties == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_use_properties == 2 ) and not ePly:IsSuperAdmin() then return false end

    if Ambi.DarkRP.Config.restrict_properties[ sProperty ] then return false end
end )

hook.Add( 'CanTool', 'Ambi.DarkRP.Restrict', function( ePly, _, sTool ) 
    if ( Ambi.DarkRP.Config.restrict_use_tools == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_use_tools == 2 ) and not ePly:IsSuperAdmin() then return false end

    if Ambi.DarkRP.Config.restrict_tools[ sTool ] then return false end
end )

hook.Add( 'PlayerSwitchFlashlight', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_use_flashlight == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_use_flashlight == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'PlayerNoClip', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_use_noclip == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_use_noclip == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'OnPhysgunReload', 'Ambi.DarkRP.Restrict', function( _, ePly ) 
    if ( Ambi.DarkRP.Config.restrict_use_mass_unfreeze_physgun == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_use_mass_unfreeze_physgun == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'CanPlayerUnfreeze', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_use_unfreeze_physgun == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_use_unfreeze_physgun == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'GravGunPunt', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if ( Ambi.DarkRP.Config.restrict_use_punt_gravgun == 1 ) and not Ambi.DarkRP.Config.restrict_usergroups[ ePly:GetUserGroup() ] then return false end
    if ( Ambi.DarkRP.Config.restrict_use_punt_gravgun == 2 ) and not ePly:IsSuperAdmin() then return false end
end )

hook.Add( 'CanPlayerSuicide', 'Ambi.DarkRP.Restrict', function( ePly ) 
    if not Ambi.DarkRP.Config.restrict_can_suicide then return false end
end )