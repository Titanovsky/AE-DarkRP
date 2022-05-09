local C = Ambi.Packages.Out( 'colors' )

net.AddString( 'ambi_darkrp_f4menu_set_job' )
net.Receive( 'ambi_darkrp_f4menu_set_job', function( _, ePly )
    if timer.Exists( 'BlockF4MenuSetJob:'..ePly:SteamID() ) then ePly:Kick( '[DarkRP] Быстрая смена работы через F4' ) return end
    timer.Create( 'BlockF4MenuSetJob:'..ePly:SteamID(), 1, 1, function() end )

    local class = net.ReadString()
    local job = Ambi.DarkRP.GetJob( class )
    if not job then return end

    local model = net.ReadUInt( 10 )
    model = job.models[ model ]
    if not model then return end

    ePly.job_model = model
    ePly:SetJob( class )
end )

-- TODO: net команды