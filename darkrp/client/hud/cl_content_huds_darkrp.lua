if not Ambi.MultiHUD then return end

local CL = Ambi.Packages.Out( 'ContentLoader' )

-- ---------------------------------------------------------------------------------------------------------------------------------------
CL.CreateDir( 'ambi_hud' )

CL.DownloadMaterial( 'hud1_darkrp_job', 'ambi_hud/darkrp_job.png', 'https://i.ibb.co/PWT5d60/darkrp-job.png' )
CL.DownloadMaterial( 'hud1_darkrp_wallet', 'ambi_hud/darkrp_wallet.png', 'https://i.ibb.co/PFSZCnx/darkrp-wallet.png' )
CL.DownloadMaterial( 'hud1_darkrp_hungry', 'ambi_hud/darkrp_hungry.png', 'https://i.ibb.co/D945T4W/darkrp-hungry.png' )
CL.DownloadMaterial( 'hud1_darkrp_license', 'ambi_hud/darkrp_license.png', 'https://i.ibb.co/mGK2c8T/darkrp-license.png' )
CL.DownloadMaterial( 'hud1_darkrp_wanted', 'ambi_hud/darkrp_wanted.png', 'https://i.ibb.co/NptdLzk/darkrp-wanted.png' )