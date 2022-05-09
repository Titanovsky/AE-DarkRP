local lockdown = CreateConVar( 'ambi_darkrp_lockdown', 0, FCVAR_REPLICATED )

net.Receive( 'ambi_darkrp_goverment_send_laws', function() 
    local tbl = net.ReadTable()

    Ambi.DarkRP.laws = tbl
end )