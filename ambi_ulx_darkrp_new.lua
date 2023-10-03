local CATEGORY = '[New DarkRP]' -- Новый ДаркРП

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'setarrest' -- чтобы не мешать /arrest
local function Action( eCaller, ePly )
    local text = ''

    if ePly:IsArrested() then
        text = 'освободил'

        Ambi.DarkRP.UnArrest( ePly, eCaller )
    else
        text = 'арестовал'

        Ambi.DarkRP.Arrest( ePly, eCaller )
    end

	ulx.fancyLogAdmin( eCaller, '#A '..text..' #T', ePly )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Арестовать / Освободить' )

local command = 'setwarrant' -- чтобы не мешать /warrant
local function Action( eCaller, ePly )
    local text = ''

    if ePly:HasWarrant() then
        text = 'убрал ордер на обыск у'

        Ambi.DarkRP.UnWarrant( ePly, eCaller )
    else
        text = 'подал ордер на обыск'

        Ambi.DarkRP.Warrant( ePly, eCaller )
    end

	ulx.fancyLogAdmin( eCaller, '#A '..text..' #T', ePly )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Подать Ордер на Обыск / Удалить Ордер на Обыск' )

local command = 'setwanted' -- чтобы не мешать /wanted
local function Action( eCaller, ePly )
    local text = ''

    if ePly:IsWanted() then
        text = 'убрал розыск у'

        Ambi.DarkRP.UnWanted( ePly, eCaller )
    else
        text = 'подал в розыск'

        Ambi.DarkRP.Wanted( ePly, eCaller )
    end

	ulx.fancyLogAdmin( eCaller, '#A '..text..' #T', ePly )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Подать Ордер на Обыск / Удалить Ордер на Обыск' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local classes = {}
for class, _ in pairs( Ambi.DarkRP.GetJobs() ) do classes[ #classes + 1 ] = class end

local command = 'setjob'
local function Action( eCaller, tPlayers, sJob )
    if not Ambi.DarkRP.GetJob( sJob ) then eCaller:ChatPrint( 'Нет такой работы! Смотрите /getjobs' ) return end

    for _, ply in ipairs( tPlayers ) do ply:SetJob( sJob, true ) end

    for class, _ in pairs( Ambi.DarkRP.GetJobs() ) do classes[ #classes + 1 ] = class end -- refresh

	ulx.fancyLogAdmin( eCaller, '#A изменил работу #T на #s', tPlayers, sJob )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.StringArg, hint= 'Класс работы', ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes = classes }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить (насильно) работу игроку' )

local command = 'getjobs'
local function Action( eCaller )
    for class, job in pairs( Ambi.DarkRP.GetJobs() ) do
        if IsValid( eCaller ) then 
            eCaller:ChatPrint( job.name..' — '..class )
        else
            print( job.name..' — '..class )
        end
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:defaultAccess( ULib.ACCESS_ADMIN )
method:help( 'Узнать все работы: Название - Класс' )

local command = 'demote'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:SetJob( Ambi.DarkRP.Config.jobs_class, true, false ) end

	ulx.fancyLogAdmin( eCaller, '#A уволил #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Уволить (насильно) игроков' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'setmoney'
local function Action( eCaller, tPlayers, nMoney )
    for _, ply in ipairs( tPlayers ) do ply:SetMoney( nMoney ) end

	ulx.fancyLogAdmin( eCaller, '#A изменил деньги #T на #i', tPlayers, nMoney )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.NumArg, min=0, hint = 'Деньги', ULib.cmds.round, ULib.cmds.optional }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить деньги игрокам' )

local command = 'addmoney'
local function Action( eCaller, tPlayers, nMoney )
    for _, ply in ipairs( tPlayers ) do ply:AddMoney( nMoney ) end

	ulx.fancyLogAdmin( eCaller, '#A добавил деньги #T на #i', tPlayers, nMoney )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.NumArg, hint = 'Деньги', ULib.cmds.round, ULib.cmds.optional }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Добавить деньги игрокам' )

local command = 'clearmoney'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:SetMoney( Ambi.DarkRP.Config.money_start ) end

	ulx.fancyLogAdmin( eCaller, '#A вайпнул деньги у #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Вайпнуть деньги у игроков' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'setrpname'
local function Action( eCaller, ePlayer, sValue )
    ePlayer:SetRPName( sValue )

	ulx.fancyLogAdmin( eCaller, '#A изменил имя у #T на #s', ePlayer, sValue )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayerArg }
method:addParam{ type=ULib.cmds.StringArg, hint= 'Имя', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить игроку игровое имя' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'setsatiety'
local function Action( eCaller, tPlayers, nValue )
    for _, ply in ipairs( tPlayers ) do ply:SetSatiety( nValue ) end

	ulx.fancyLogAdmin( eCaller, '#A изменил сытость у #T на #i', tPlayers, nValue )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.NumArg, hint = 'Сытость', ULib.cmds.round, ULib.cmds.optional, default = Ambi.DarkRP.Config.hunger_satiety_default, min = 0 }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить сытость игрокам' )

local command = 'setmaxsatiety'
local function Action( eCaller, tPlayers, nValue )
    for _, ply in ipairs( tPlayers ) do ply:SetMaxSatiety( nValue ) end

	ulx.fancyLogAdmin( eCaller, '#A изменил максимум сытости у #T на #i', tPlayers, nValue )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:addParam{ type=ULib.cmds.NumArg, hint = 'Сытость', ULib.cmds.round, ULib.cmds.optional }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить максимум сытости игрокам' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'lockdown'
local function Action( eCaller )
    local word = ''

    if Ambi.DarkRP.IsLockdown() then
        word = 'закончил'

        Ambi.DarkRP.SetLockdown( false )
    else
        word = 'начал'

        Ambi.DarkRP.SetLockdown( true )
    end

	ulx.fancyLogAdmin( eCaller, '#A '..word..' ком. час' )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Начать/Закончить Ком. Час' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'dropgun'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:DropActiveWeapon() end

	ulx.fancyLogAdmin( eCaller, '#A выкинул текущее оружие у #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Выкинуть текущее оружие у игроков (Через DarkRP функцию)' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'darkrpvote'
local function Action( eCaller, sValue )
    print( '[DarkRP] Запущено голосование: '..sValue )

    Ambi.DarkRP.StartVote( sValue, function() 
        for _, ply in ipairs( player.GetHumans() ) do
            ply:ChatSend( '~GREEN~ •  ~WHITE~ Голосование завершилось удачно: ~GREEN~'..sValue )
        end

        print( '[DarkRP] Голосование завершилось удачно: '..sValue )
    end, function() 
        for _, ply in ipairs( player.GetHumans() ) do
            ply:ChatSend( '~RED~ •  ~WHITE~ Голосование провалилось: ~RED~ '..sValue )
        end

        print( '[DarkRP] Голосование провалилось: '..sValue )
    end )

	ulx.fancyLogAdmin( eCaller, '#A запустил голосование: #s', sValue )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type = ULib.cmds.StringArg, hint = 'Причина', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Запустить DarkRP голосование' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'setlaw'
local function Action( eCaller, nValue, sValue )
    Ambi.DarkRP.SetLaw( nValue, sValue )

	ulx.fancyLogAdmin( eCaller, '#A изменил закон под номером #i', nValue )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type = ULib.cmds.NumArg, hint = 'Номер закона от 1 до '..#Ambi.DarkRP.Config.goverment_laws_default, ULib.cmds.round, ULib.cmds.optional, min = 1, max = #Ambi.DarkRP.Config.goverment_laws_default }
method:addParam{ type = ULib.cmds.StringArg, hint = 'Закон', ULib.cmds.optional, ULib.cmds.takeRestOfLine }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Изменить/Добавить закон' )

local command = 'clearlaws'
local function Action( eCaller )
    Ambi.DarkRP.ClearLaws()

	ulx.fancyLogAdmin( eCaller, '#A очистил все законы' )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Очистить все законы' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'givelicense'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:GiveRealLicenseGun() end

	ulx.fancyLogAdmin( eCaller, '#A выдал реальную лицензию для #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Выдать реальную лицензию игрокам' )

local command = 'givefakelicense'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:GiveFakeLicenseGun() end

	ulx.fancyLogAdmin( eCaller, '#A выдал ложную лицензию для #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Выдать ложную лицензию игрокам' )

local command = 'removelicense'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:RemoveLicenses() end

	ulx.fancyLogAdmin( eCaller, '#A забрал все лицензий у #T', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Забрать все лицензий (настоящую и фейковую) у игроков' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
local command = 'sellalldoors'
local function Action( eCaller, tPlayers )
    for _, ply in ipairs( tPlayers ) do ply:SellDoors() end

	ulx.fancyLogAdmin( eCaller, '#A вызвал у игрока(-ов) #T продажу всех своих дверей', tPlayers )
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:addParam{ type=ULib.cmds.PlayersArg }
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Продать все двери у игроков' )

local command = 'selldoor'
local function Action( eCaller )
    if not IsValid( eCaller ) then return end
    local ent = eCaller:GetEyeTrace().Entity

    if IsValid( ent ) and Ambi.DarkRP.Config.doors_classes[ ent:GetClass() ] then
        Ambi.DarkRP.RemoveDoorOwners( ent )

        ulx.fancyLogAdmin( eCaller, '#A освободил дверь напротив' )
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Освободить дверь напротив себя' )

local command = 'getdoorinfo'
local function Action( eCaller )
    if not IsValid( eCaller ) then return end
    local ent = eCaller:GetEyeTrace().Entity

    if IsValid( ent ) and ent:IsDoor() then
        eCaller:ChatSend( '~RED~ \n==================' )
        eCaller:ChatSend( '~WHITE~ Дверь: ~RED~'..tostring( ent ) )
        eCaller:ChatSend( '~WHITE~ Владельцы: ' )
        for i, ply in ipairs( ent.owners ) do
            eCaller:ChatSend( '~RED~'..i..'. ~WHITE~ '..ply:Nick() )
        end
        eCaller:ChatSend( '~RED~ ==================\n' )
    end
end
local method = ulx.command( CATEGORY, 'ulx '..command, Action, '!'..command )
method:defaultAccess( ULib.ACCESS_SUPERADMIN )
method:help( 'Узнать инфу о двери напротив себя' )