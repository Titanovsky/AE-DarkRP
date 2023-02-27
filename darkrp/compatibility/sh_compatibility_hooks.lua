hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.Compatibility', function( ePly ) 
    ePly.maxFoods = 0 -- https://github.com/FPtje/DarkRP/blob/master/entities/entities/food/init.lua#L53
end )

hook.Add( '[Ambi.DarkRP.CanUseFood]', 'Ambi.DarkRP.Compatibility', function( ePly, eFood ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    
    local can, reason = hook.Call( 'canDarkRPUse', nil, ePly, eFood, ePly )

    if ( can == false ) then ePly:ChatPrint( reason or '' ) return false end
end )

hook.Add( '[Ambi.DarkRP.PlayerAteFood]', 'Ambi.DarkRP.Compatibility', function( ePly, eFood ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    
    hook.Call( 'playerAteFood', nil, ePly, eFood, eFood )
end )

hook.Add( '[Ambi.DarkRP.SetLaw]', 'Ambi.DarkRP.Compatibility', function( ePly, nID, sText, sOldText )
    if not Ambi.DarkRP.compatibility_enable then return end
    
    if ( sText == '' ) then hook.Call( 'removeLaw', nil, nID, sText, ePly ) else hook.Call( 'addLaw', nil, nID, sText, ePly ) end
end )

hook.Add( '[Ambi.DarkRP.ClearLaws]', 'Ambi.DarkRP.Compatibility', function( ePlу )
    if not Ambi.DarkRP.compatibility_enable then return end
    
    hook.Call( 'resetLaws', nil, ePly )
end )

hook.Add( '[Ambi.DarkRP.CanWarrant]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget, sReason )
    if not Ambi.DarkRP.compatibility_enable then return end
    
    if ( hook.Call( 'canRequestWarrant', nil, eTarget, ePly, sReason ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUnWarrant]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget )
    if not Ambi.DarkRP.compatibility_enable then return end
    
    if ( hook.Call( 'canRemoveWarrant', nil, eTarget, ePly ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanWanted]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget, sReason )
    if not Ambi.DarkRP.compatibility_enable then return end
    
    if ( hook.Call( 'canWanted', nil, eTarget, ePly, sReason ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUnWanted]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget )
    if not Ambi.DarkRP.compatibility_enable then return end
    
    if ( hook.Call( 'canUnwant', nil, eTarget, ePly ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.BoughtDoor]', 'Ambi.DarkRP.Compatibility', function( ePly, eDoor )
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_doors then return end
    
    hook.Call( 'playerBoughtDoor', nil, ePly, eDoor, Ambi.DarkRP.Config.doors_cost_buy )
end )

hook.Add( '[Ambi.DarkRP.CanBuyDoor]', 'Ambi.DarkRP.Compatibility', function( ePly, eDoor )
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_doors then return end
    
    if ( hook.Call( 'playerBuyDoor', nil, ePly, eDoor ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanBuyShopItem]', 'Ambi.DarkRP.Compatibility', function( ePly, sClass, bForce ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    
    local item = Ambi.DarkRP.GetShopItem( sClass )

    if item.shipment then
        if ( hook.Call( 'canBuyShipment', nil, ePly, item ) == false ) then return false end
    elseif item.weapon then
        if ( hook.Call( 'canBuyPistol', nil, ePly, item ) == false ) then return false end
    else
        if ( hook.Call( 'canBuyCustomEntity', nil, ePly, item ) == false ) then return false end
    end
end )

hook.Add( '[Ambi.DarkRP.CanArrest]', 'Ambi.DarkRP.Compatibility', function( ePolice, ePly, sReason, nTime )
    if not Ambi.DarkRP.compatibility_enable then return end

    local can, msg = hook.Call( 'canArrest', nil, ePolice, ePly )

    if ( can == false ) then ePolice:ChatPrint( msg or '' ) return false end
end )

hook.Add( '[Ambi.DarkRP.CanUnArrest]', 'Ambi.DarkRP.Compatibility', function( ePolice, ePly )
    if not Ambi.DarkRP.compatibility_enable then return end
    if not IsValid( ePolice ) then return end

    local can, msg = hook.Call( 'canUnarrest', nil, ePolice, ePly )
    if ( can == false ) then ePolice:ChatPrint( msg or '' ) return false end
end )

hook.Add( '[Ambi.DarkRP.CanDoorRam]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj )
    if not Ambi.DarkRP.compatibility_enable then return end

    if ( hook.Call( 'canDoorRam', nil, ePly, ePly:GetEyeTrace(), eObj ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.OnDoorRamUsed]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj )
    if not Ambi.DarkRP.compatibility_enable then return end

    if ( hook.Call( 'onDoorRamUsed', nil, true, ePly, ePly:GetEyeTrace() ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanDropWeapon]', 'Ambi.DarkRP.Compatibility', function( ePly, sClass, eWeapon )
    if not Ambi.DarkRP.compatibility_enable then return end

    if ( hook.Call( 'canDropWeapon', nil, ePly, eWeapon ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUseKeysLock]', 'Ambi.DarkRP.Compatibility', function( ePly, eDoor )
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_doors then return end

    if ( hook.Call( 'canKeysLock', nil, ePly, eDoor ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUseKeysUnLock]', 'Ambi.DarkRP.Compatibility', function( ePly, eDoor )
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_doors then return end

    if ( hook.Call( 'canKeysUnlock', nil, ePly, eDoor ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanUseLockpick]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj )
    if not Ambi.DarkRP.compatibility_enable then return end

    if ( hook.Call( 'canLockpick', nil, ePly, eObj, ePly:GetEyeTrace() ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.LockpickStart]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj )
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'lockpickStarted', nil, ePly, eObj, ePly:GetEyeTrace() )
end )

hook.Add( '[Ambi.DarkRP.LockpickEnd]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj, bSuccess )
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'onLockpickCompleted', nil, ePly, bSuccess )
end )

hook.Add( 'InitPostEntity', 'Ambi.DarkRP.Compatibility', function() 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'DarkRPDBInitialized' )
    hook.Call( 'DarkRPStartedLoading' )
    hook.Call( 'DarkRPFinishedLoading' )
end )

hook.Add( '[Ambi.DarkRP.Advert]', 'Ambi.DarkRP.Compatibility', function( ePly, sText )
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerAdverted', nil, ePly, sText )
end )

hook.Add( '[Ambi.DarkRP.PlayerArrested]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice, sReason, nTime )
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerArrested', nil, ePly, nTime, ePolice )
end )

hook.Add( '[Ambi.DarkRP.BuyShopItem]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj, sClass, bForce, tItem )
    if not Ambi.DarkRP.compatibility_enable then return end

    if tItem.shipment then hook.Call( 'playerBoughtShipment', nil, ePly, tItem, eObj, tItem.price )
    elseif tItem.weapon then hook.Call( 'playerBoughtPistol', nil, ePly, tItem, eObj, tItem.price )
    else hook.Call( 'playerBoughtCustomEntity', nil, ePly, tItem, eObj, tItem.price )
    end
end )

hook.Add( '[Ambi.DarkRP.DroppedWeapon]', 'Ambi.DarkRP.Compatibility', function( ePly, eWeapon, tWeapon ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'onDarkRPWeaponDropped', nil, ePly, eWeapon, tWeapon )
end )

hook.Add( '[Ambi.DarkRP.DroppedMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerDroppedMoney', nil, ePly, eObj.nw_Money, eObj )
    hook.Call( 'playerDropMoney', nil, ePly, eObj.nw_Money, eObj )
end )

hook.Add( '[Ambi.DarkRP.TransferedMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, eTarget, nCount ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerGaveMoney', nil, ePly, eTarget, nCount )
    hook.Call( 'playerGiveMoney', nil, ePly, eTarget, nCount )
end )

hook.Add( '[Ambi.DarkRP.PlayerCanPickupMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, eMoney, nMoney ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    local can, msg = hook.Call( 'canDarkRPUse', nil, ePly, eMoney )
    if ( can == false ) then ePly:ChatPrint( msg or '' ) return false end
end )

hook.Add( '[Ambi.DarkRP.PlayerPickedupMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, eMoney, nMoney ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerPickedUpMoney', nil, ePly, nMoney, eMoney )
end )

hook.Add( '[Ambi.DarkRP.PlayerPickedupWeapon]', 'Ambi.DarkRP.Compatibility', function( ePly, eWeapon ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerPickedUpWeapon', nil, ePly, eWeapon )
end )

hook.Add( '[Ambi.DarkRP.CanSellDoor]', 'Ambi.DarkRP.Compatibility', function( ePly, eObj ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_doors then return end

    local can, msg = hook.Call( 'playerSellDoor', nil, ePly, eObj )

    if ( can == false ) then ePly:ChatPrint( msg or '' ) return false end
end )

hook.Add( '[Ambi.DarkRP.PlayerUnArrested]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerUnArrested', nil, ePly, ePolice )
end )

hook.Add( '[Ambi.DarkRP.PlayerUnWanted]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerUnWanted', nil, ePly, ePolice )
end )

hook.Add( '[Ambi.DarkRP.PlayerUnWarranted]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerUnWarranted', nil, ePly, ePolice )
end )

hook.Add( '[Ambi.DarkRP.SetMoney]', 'Ambi.DarkRP.Compatibility', function( ePly, nMoney, nOldMoney )
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerWalletChanged', nil, ePly, nMoney, nOldMoney )
end )

hook.Add( '[Ambi.DarkRP.PlayerWanted]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice, sReason )
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerWanted', nil, ePly, ePolice, sReason )
end )

hook.Add( '[Ambi.DarkRP.PlayerWarrant]', 'Ambi.DarkRP.Compatibility', function( ePly, ePolice, sReason )
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'playerWarranted', nil, ePly, ePolice, sReason )
end )

hook.Add( '[Ambi.DarkRP.PlayerCanOpenShipment]', 'Ambi.DarkRP.Compatibility', function( ePly, eShipment )
    if not Ambi.DarkRP.compatibility_enable then return end

    local can, msg = hook.Call( 'canDarkRPUse', nil, ePly, eShipment )
    if ( can == false ) then ePly:ChatPrint( msg or '' ) return false end
end )

hook.Add( '[Ambi.DarkRP.AddedShopItem]', 'Ambi.DarkRP.Compatibility', function( sClass, tItem )
    if not Ambi.DarkRP.compatibility_enable then return end

    if not tItem.shipment then 
        local index = #DarkRPEntities + 1
        for i, v in ipairs( DarkRPEntities ) do
            if ( v.class == sClass ) then index = i break end
        end

        tItem.class = sClass
        DarkRPEntities[ index ] = tItem 
    else
        CustomShipments[ sClass ] = tItem 
    end
end )

hook.Add( '[Ambi.DarkRP.RemovedShopItem]', 'Ambi.DarkRP.Compatibility', function( sClass, tItem )
    if not Ambi.DarkRP.compatibility_enable then return end

    if not tItem.shipment then 
        local index = #DarkRPEntities + 1
        for i, v in ipairs( DarkRPEntities ) do
            if ( v.class == sClass ) then index = i break end
        end
        
        DarkRPEntities[ index ] = {} 
    else 
        CustomShipments[ sClass ] = nil 
    end
end )

hook.Add( '[Ambi.DarkRP.SetRPName]', 'Ambi.DarkRP.Compatibility', function( ePly, sNewName, sOldName )
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'onPlayerChangedName', nil, ePly, sOldName, sNewName )
end )

hook.Add( 'PostGamemodeLoaded', 'Ambi.DarkRP.SetStandartTeamToJobs', function()
    timer.Simple( 1, function()
        for i, v in ipairs( team.GetAllTeams() ) do
            v.description = v.description or '' -- Описание должно быть всегда при созданой профе
        end
    end )
end )

hook.Add( 'PlayerSay', 'Ambi.DarkRP.Compatibility', function( ePly, sText, bTeamOnly ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'PostPlayerSay', nil, ePly, sText, bTeamOnly, ePly:Alive() )
end )

hook.Add( '[Ambi.DarkRP.SetJob]', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, sClass, bForce, sOldClass )
    local class = sClass or sOldClass
    local old_class = sOldClass or sClass 
    local index_class, index_old_class = Ambi.DarkRP.GetJob( class ) and Ambi.DarkRP.GetJob( class ).index or 1001, Ambi.DarkRP.GetJob( old_class ) and Ambi.DarkRP.GetJob( old_class ).index or 1002
    
    hook.Call( 'OnPlayerChangedTeam', nil, ePly, index_old_class, index_class )
end )

hook.Add( '[Ambi.DarkRP.AddedJob]', 'Ambi.DarkRP.CompatibilityJobs', function( sClass, tJob ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_jobs then return end

    RPExtraTeams[ tJob.index ] = tJob
end )

hook.Add( '[Ambi.DarkRP.RemovedJob]', 'Ambi.DarkRP.CompatibilityJobs', function( sClass, tJob ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_jobs then return end

    RPExtraTeams[ tJob.index ] = nil
end )

hook.Add( '[Ambi.DarkRP.CanDemote]', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, eTarget ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_jobs then return end

    if ( hook.Call( 'canDemote', nil, ePly, eTarget, '' ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.PlayerDemoted]', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, eTarget, bForce ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_jobs then return end

    if ( hook.Call( 'onPlayerDemoted', nil, ePly, eTarget, '' ) == false ) then return false end
end )

hook.Add( '[Ambi.DarkRP.CanChangeJob]', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, sClass, bForce ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_jobs then return end

    local can, reason = hook.Call( 'playerCanChangeTeam', nil, ePly, Ambi.DarkRP.GetJob( sClass ).index, bForce )
    if ( can == false ) then ePly:ChatPrint( reason or '' ) return false end

    local can, reason, _ = hook.Call( 'canChangeJob', nil, ePly, Ambi.DarkRP.GetJob( sClass ).command )
    if ( can == false ) then ePly:ChatPrint( reason or '' ) return false end
end )

hook.Add( 'PlayerSay', 'Ambi.DarkRP.CompatibilityJobs', function( ePly, sText ) 
    if not Ambi.DarkRP.compatibility_enable then return end
    if not Ambi.DarkRP.compatibility_jobs then return end

    if string.StartWith( sText, '/vote' ) then 
        local text = string.Trim( sText )
        text = string.sub( text, 6, #text )

        ePly:Say( '/'..text )

        return ''
    end
end )

hook.Add( '[Ambi.DarkRP.StartVote]', 'Ambi.DarkRP.Compatibility', function( ePly, nID, sTitle, fWin, fRemove ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'onVoteStarted', nil, { time = Ambi.DarkRP.Config.vote_time, question = sTitle, id = nID, exclude = player.GetAll() } )
end )

hook.Add( '[Ambi.DarkRP.PlayerMoneyTableCreated]', 'Ambi.DarkRP.Compatibility', function( ePly ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'onPlayerFirstJoined', nil, ePly, { wallet = 0, salary = 0, rpname = ePly:Nick() } )
end )

hook.Add( '[Ambi.DarkRP.PlayerRPNameTableCreated]', 'Ambi.DarkRP.Compatibility', function( ePly ) 
    if not Ambi.DarkRP.compatibility_enable then return end

    hook.Call( 'onPlayerFirstJoined', nil, ePly, { wallet = 0, salary = 0, rpname = ePly:Nick() } )
end )

if CLIENT then
    hook.Add("StartChat", "DarkRP_StartFindChatReceivers", function() end )
    hook.Add("PlayerStartVoice", "DarkRP_VoiceChatReceiverFinder", function() end )
end