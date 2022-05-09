local C = Ambi.Packages.Out( 'colors' )
Ambi.DarkRP.votes = Ambi.DarkRP.votes or {}

-- == Main ===================================================================================================
local function GetLenTable( tTable )
    local j = 0
    for i, _ in pairs( tTable ) do
        j = j + 1
        if ( i != j ) then return j - 1 end
    end

    return #tTable
end

function Ambi.DarkRP.CanStartVote()
    return Ambi.DarkRP.Config.vote_max > GetLenTable( Ambi.DarkRP.votes )
end

function Ambi.DarkRP.StartVote( sTitle, fWin, fFail )
    sTitle = sTitle or 'Нет названия'
    fWin = fWin or function() end
    fFail = fFail or function() end

    local id = GetLenTable( Ambi.DarkRP.votes ) + 1
    if not Ambi.DarkRP.CanStartVote() then Ambi.General.Error( 'DarkRP', 'StartVote | New vote cannot to start, maximum has been reached' ) return end

    if ( hook.Call( '[Ambi.DarkRP.CanStartVote]', nil, id, sTitle, fWin, fFail ) == false ) then return end

    local function EndVote()
        local yes, no = Ambi.DarkRP.votes[ id ].yes, Ambi.DarkRP.votes[ id ].no
        local Win, Fail = Ambi.DarkRP.votes[ id ].Win, Ambi.DarkRP.votes[ id ].Fail

        Ambi.DarkRP.votes[ id ] = nil

        if ( yes > no ) then
            Win( sTitle )
        else
            Fail( sTitle )
        end

        for _, ply in ipairs( player.GetAll() ) do
            if not ply.last_vote_choices then ply.last_vote_choices = {} end
            ply.last_vote_choices[ id ] = nil 
        end
    end

    Ambi.DarkRP.votes[ id ] = { title = sTitle, Win = fWin, Fail = fFail, End = EndVote, yes = 0, no = 0 }

    net.Start( 'ambi_darkrp_start_vote' )
        net.WriteUInt( id, 5 ) -- При заходе в игру, у игрока должна быть одна и та же ID у Vote, иначе его кикнет за неправильный ID
        net.WriteString( sTitle )
    net.Broadcast()

    timer.Create( 'AmbiDarkRPVote['..id..']', Ambi.DarkRP.Config.vote_time + 0.25, 1, EndVote )
end

-- == Nets ===================================================================================================
net.AddString( 'ambi_darkrp_start_vote' )
net.AddString( 'ambi_darkrp_start_choice' )

net.Receive( 'ambi_darkrp_start_choice', function( _, ePly )
    local id = net.ReadUInt( 5 )
    if not Ambi.DarkRP.votes[ id ] then ePly:Kick( '[DarkRP] Попытка сделать выбор в голосований, которого не существует!' ) return end
    if ePly.last_vote_choices and ePly.last_vote_choices[ id ] then ePly:Kick( '[DarkRP] Попытка сделать повторный выбор в голосований!' ) return end

    local choice = net.ReadBool()
    
    local yes, no = Ambi.DarkRP.votes[ id ].yes, Ambi.DarkRP.votes[ id ].no
    if choice then Ambi.DarkRP.votes[ id ].yes = yes + 1 else Ambi.DarkRP.votes[ id ].no = no + 1 end

    if not ePly.last_vote_choices then ePly.last_vote_choices = {} end
    ePly.last_vote_choices[ id ] = true

    if ( #player.GetAll() == Ambi.DarkRP.votes[ id ].yes + Ambi.DarkRP.votes[ id ].no ) then 
        timer.Remove( 'AmbiDarkRPVote['..id..']' )
        Ambi.DarkRP.votes[ id ].End() 
    end
end )