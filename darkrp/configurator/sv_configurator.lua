local C = Ambi.Packages.Out( 'colors' )

-- ----------------------------------------------------------------------------------------------------------------------------------------
local changed_config = {} -- Не пересохраняйте файл, иначе очистите эту таблицу!
local removed_jobs = {} -- Не пересохраняйте файл, иначе очистите эту таблицу!
local added_jobs = {} -- Не пересохраняйте файл, иначе очистите эту таблицу!
local changed_jobs = {} -- Не пересохраняйте файл, иначе очистите эту таблицу!

function Ambi.DarkRP.GetChangedConfig()
    return changed_config
end

function Ambi.DarkRP.ClearChangedConfig()
    changed_config = {}

    include( 'modules/darkrp/cfg_darkrp.lua' )

    local tab = {}
    for i, v in pairs( Ambi.DarkRP.Config ) do tab[ i ] = v  end
 
    net.Start( 'ambi_darkrp_configurator_set_config_send_new_players' )
        net.WriteTable( tab )
    net.Broadcast()
end

-- ----------------------------------------------------------------------------------------------------------------------------------------
net.AddString( 'ambi_darkrp_configurator_set_config' )
net.Receive( 'ambi_darkrp_configurator_set_config', function( _, ePly ) 
    if not Ambi.DarkRP.configurator_enable then ePly:Kick( '[DarkRP] Конфигуратор выключен [Set]' ) return end
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Вы не супер админ для конфигуратора [Set]' ) return end

    local index = net.ReadString()
    if ( Ambi.DarkRP.Config[ index ] == nil ) then return end

    local value = net.ReadTable()
    if ( value.value != nil ) then value = value.value end -- Если только одно значение

    local old_value = Ambi.DarkRP.Config[ index ]
    Ambi.DarkRP.Config[ index ] = value

    changed_config[ index ] = value

    net.Start( 'ambi_darkrp_configurator_set_config_send_new_players' )
        net.WriteTable( changed_config )
    net.Send( ePly )
end )

net.AddString( 'ambi_darkrp_configurator_set_config_table' )
net.Receive( 'ambi_darkrp_configurator_set_config_table', function( _, ePly ) 
    if not Ambi.DarkRP.configurator_enable then ePly:Kick( '[DarkRP] Конфигуратор выключен [SetTable]' ) return end
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Вы не супер админ для конфигуратора [SetTable]' ) return end

    local config = net.ReadTable()

    for i, v in pairs( config ) do
        if not IsTable( v ) then -- TODO: Для таблиц там отдельная table.Equals нужна
            if ( v == Ambi.DarkRP.Config[ i ] ) then continue end
        end

        changed_config[ i ] = v
    end

    Ambi.DarkRP.Config = config

    net.Start( 'ambi_darkrp_configurator_set_config_send_new_players' )
        net.WriteTable( config )
    net.Send( ePly )
end )

net.AddString( 'ambi_darkrp_configurator_clear_config' )
net.Receive( 'ambi_darkrp_configurator_clear_config', function( _, ePly ) 
    if not Ambi.DarkRP.configurator_enable then ePly:Kick( '[DarkRP] Конфигуратор выключен [Clear]' ) return end
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Вы не супер админ для конфигуратора [Clear]' ) return end

    Ambi.DarkRP.ClearChangedConfig()

    net.Start( 'ambi_darkrp_configurator_set_config_send_new_players' )
        net.WriteTable( Ambi.DarkRP.Config )
    net.Send( ePly )
end )

net.AddString( 'ambi_darkrp_configurator_set_config_send_new_players' )
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.SendNewConfigForNewPlayers', function( ePly ) 
    if not changed_config then return end
    
    net.Start( 'ambi_darkrp_configurator_set_config_send_new_players' )
        net.WriteTable( changed_config )
    net.Send( ePly )
end )

-- Jobs --
net.AddString( 'ambi_darkrp_configurator_change_jobs' )
net.Receive( 'ambi_darkrp_configurator_change_jobs', function( _, ePly ) 
    if not Ambi.DarkRP.configurator_enable then ePly:Kick( '[DarkRP] Конфигуратор выключен!' ) return end
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Вы не супер админ для конфигуратора!' ) return end

    local jobs = net.ReadTable()

    Ambi.DarkRP.jobs = jobs

    net.Start( 'ambi_darkrp_configurator_send_changed_jobs' )
        net.WriteTable( Ambi.DarkRP.GetJobs() )
    net.Broadcast()
end )

net.AddString( 'ambi_darkrp_configurator_send_changed_jobs' )
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.SendChangedJobsForNewPlayers', function( ePly ) 
    net.Start( 'ambi_darkrp_configurator_send_changed_jobs' )
        net.WriteTable( Ambi.DarkRP.GetJobs() )
    net.Send( ePly )
end )

-- Shop --
net.AddString( 'ambi_darkrp_configurator_change_shop' )
net.Receive( 'ambi_darkrp_configurator_change_shop', function( _, ePly ) 
    if not Ambi.DarkRP.configurator_enable then ePly:Kick( '[DarkRP] Конфигуратор выключен!' ) return end
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Вы не супер админ для конфигуратора!' ) return end

    local shop = net.ReadTable()

    Ambi.DarkRP.shop = shop

    net.Start( 'ambi_darkrp_configurator_send_changed_shop' )
        net.WriteTable( Ambi.DarkRP.GetShop() )
    net.Broadcast()
end )

net.AddString( 'ambi_darkrp_configurator_send_changed_shop' )
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.SendChangedShopForNewPlayers', function( ePly ) 
    net.Start( 'ambi_darkrp_configurator_send_changed_shop' )
        net.WriteTable( Ambi.DarkRP.GetShop() )
    net.Send( ePly )
end )

-- Door Categories --
net.AddString( 'ambi_darkrp_configurator_change_door_categories' )
net.Receive( 'ambi_darkrp_configurator_change_door_categories', function( _, ePly ) 
    if not Ambi.DarkRP.configurator_enable then ePly:Kick( '[DarkRP] Конфигуратор выключен!' ) return end
    if not ePly:IsSuperAdmin() then ePly:Kick( '[DarkRP] Вы не супер админ для конфигуратора!' ) return end

    local categories = net.ReadTable()

    Ambi.DarkRP.doors_categories = categories

    net.Start( 'ambi_darkrp_configurator_send_changed_door_categories' )
        net.WriteTable( Ambi.DarkRP.GetDoorCategories() )
    net.Broadcast()
end )

net.AddString( 'ambi_darkrp_configurator_send_changed_door_categories' )
hook.Add( 'PlayerInitialSpawn', 'Ambi.DarkRP.SendChangedDoorCategoriesForNewPlayers', function( ePly ) 
    net.Start( 'ambi_darkrp_configurator_send_changed_door_categories' )
        net.WriteTable( Ambi.DarkRP.GetDoorCategories() )
    net.Send( ePly )
end )