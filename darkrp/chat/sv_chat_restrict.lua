-- =============================================================== --
hook.Add( 'PlayerCanSeePlayersChat', 'Ambi.DarkRP.ChatRestrict', function( sText, bTeamOnly, eListener, eSpeaker ) 
    if not Ambi.DarkRP.Config.chat_restrict_enable then return end

    if ( eSpeaker:GetPos():Distance( eListener:GetPos() ) <= Ambi.DarkRP.Config.chat_max_length ) then return true end

    return false
end )

hook.Add( 'PlayerCanHearPlayersVoice', 'Ambi.DarkRP.ChatRestrict', function( eListener, eTalker ) 
    if not Ambi.DarkRP.Config.chat_voice_local_enable then return end

    if ( eListener:GetPos():Distance( eTalker:GetPos() ) <= Ambi.DarkRP.Config.chat_voice_max_length ) then return true, Ambi.DarkRP.Config.chat_voice_3d end

    return false
end )
-- =============================================================== --