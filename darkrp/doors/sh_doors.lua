local C = Ambi.General.Global.Colors

Ambi.DarkRP.doors_categories = Ambi.DarkRP.doors_categories or {}

-- ================= Core ========================================================================= --
function Ambi.DarkRP.AddDoorCategory( sCategory, tJobs )
    if not sCategory then return end
    if not tJobs then return end

    if ( hook.Call( '[Ambi.DarkRP.CanAddDoorCategory]', nil, sCategory, tJobs ) == false ) then return false end

    Ambi.DarkRP.doors_categories[ sCategory ] = tJobs

    print( '[DarkRP] Created Door Category: '..sCategory )

    hook.Call( '[Ambi.DarkRP.AddedDoorCategory]', nil, sCategory, tJobs )
end

function Ambi.DarkRP.RemoveDoorCategory( sCategory )
    if not sCategory then return end

    Ambi.DarkRP.doors_categories[ sCategory ] = nil

    print( '[DarkRP] Removed Door Category: '..sCategory )

    hook.Call( '[Ambi.DarkRP.RemovedDoorCategory]', nil, sCategory )
end

function Ambi.DarkRP.GetDoorCategory( sCategory )
    return Ambi.DarkRP.doors_categories[ sCategory ]
end

function Ambi.DarkRP.GetDoorCategories()
    return Ambi.DarkRP.doors_categories
end

-- ================= Entity ========================================================================= --
local ENTITY = FindMetaTable( 'Entity' )

function ENTITY:IsDoor()
    return Ambi.DarkRP.Config.doors_classes[ self:GetClass() ]
end

-- ================= Commands ========================================================================= --
if not Ambi.ChatCommands then Ambi.General.Error( 'DarkRP', 'Before DarkRP module, need to connect ChatCommands module' ) return end

local Add = Ambi.ChatCommands.AddCommand
local TYPE = 'DarkRP | Doors'

Add( Ambi.DarkRP.Config.doors_sell_all_command, TYPE, Ambi.DarkRP.Config.doors_sell_all_description, Ambi.DarkRP.Config.doors_sell_all_delay, function( ePly, tArgs ) 
    ePly:SellDoors()
end )

-- ================= Defaults ========================================================================= --
if not Ambi.DarkRP.Config.jobs_create_defaults then return end
if not Ambi.DarkRP.Config.doors_categories_create_defaults then return end

hook.Add( 'InitPostEntity', 'Ambi.DarkRP.AddDefaultsCategory', function()
    Ambi.DarkRP.AddDoorCategory( 'Мэрия', { 'TEAM_MAYOR' } )
    Ambi.DarkRP.AddDoorCategory( 'Полицейский Участок', { 'TEAM_POLICE', 'TEAM_SHERIFF', 'TEAM_SWAT', 'TEAM_MAYOR' } )
    Ambi.DarkRP.AddDoorCategory( 'Тюрьма', { 'TEAM_SHERIFF', 'TEAM_MAYOR' } )
end )