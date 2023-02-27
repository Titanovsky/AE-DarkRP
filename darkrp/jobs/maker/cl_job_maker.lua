local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

-- ---------------------------------------------------------------------------------------------------------------------------------------
function Ambi.DarkRP.OpenJobMaker()
    if not Ambi.DarkRP.Config.jobs_maker_enable then chat.AddText( C.ERROR, '• ', C.ABS_WHITE, 'Система Job Maker отключена!' ) return end
    if not Ambi.DarkRP.Config.jobs_maker_usergroups[ LocalPlayer():GetUserGroup() ] then chat.AddText( C.ERROR, '• ', C.ABS_WHITE, 'У вас нет прав для Job Maker' )  return end

    --todo
    chat.AddText( C.ERROR, '• ', C.ABS_WHITE, 'Система не готова!' )
end
concommand.Add( 'ambi_darkrp_job_maker', Ambi.DarkRP.OpenJobMaker )

-- ---------------------------------------------------------------------------------------------------------------------------------------
net.Receive( 'ambi_darkrp_job_maker_sync', function() 
    local class, tab = net.ReadString(), net.ReadTable()

    local job = Ambi.DarkRP.GetJob( class )
    if job then
        for k, v in pairs( tab ) do
            job[ k ] = v
        end

        print( '[DarkRP] Changed the job: '..class..' by Job Maker' )
    else
        Ambi.DarkRP.AddJob( class, tab ) 
    end

    print( '[DarkRP] Job Maker: Sync '..class )
end )