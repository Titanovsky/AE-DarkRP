local C, GUI, Draw = Ambi.Packages.Out( '@d' )
local W, H = ScrW(), ScrH()

----------------------------------------------------------------------------------------------------------------------------------

local POS_2D = {
    [ 'center' ] = { 
        x_align = TEXT_ALIGN_CENTER, y_align = TEXT_ALIGN_CENTER, 
        x1 = W / 2, y1 = H / 2, x2 = W / 2, y2 = H / 2 + 22 
    },

    [ 'top' ] = { 
        x_align = TEXT_ALIGN_CENTER, y_align = TEXT_ALIGN_TOP, 
        x1 = W / 2, y1 = 24, x2 = W / 2, y2 = 50
    },

    [ 'bottom' ] = { 
        x_align = TEXT_ALIGN_CENTER, y_align = TEXT_ALIGN_BOTTOM, 
        x1 = W / 2, y1 = H - 2, x2 = W / 2, y2 = H - 28 
    },

    [ 'right' ] = { 
        x_align = TEXT_ALIGN_RIGHT, y_align = TEXT_ALIGN_CENTER, 
        x1 = W - 4, y1 = H / 2, x2 = W - 4, y2 = H / 2 + 22
    },

    [ 'left' ] = { 
        x_align = TEXT_ALIGN_LEFT, y_align = TEXT_ALIGN_CENTER, 
        x1 = 4, y1 = H / 2, x2 = 4, y2 = H / 2 + 22
    },
}

----------------------------------------------------------------------------------------------------------------------------------

local function GetOwners( eDoor )
    if eDoor.nw_IsBlocked then return '' end
    if string.IsValid( eDoor.nw_Category ) then return '' end
    if eDoor.nw_IsOwned then return 'Занята' end

    return 'Продаётся '..Ambi.DarkRP.Config.doors_cost_buy..Ambi.DarkRP.Config.money_currency_symbol
end

local function GetTitle( eDoor )
    if eDoor.nw_IsBlocked then return '' end
    if string.IsValid( eDoor.nw_Category ) then return eDoor.nw_Category end

    return eDoor.nw_Title or 'Дверь №'..eDoor:EntIndex()
end

----------------------------------------------------------------------------------------------------------------------------------

hook.Add( 'PostDrawTranslucentRenderables', 'Ambi.DarkRP.DrawInfoDoors', function() 
    if ( Ambi.DarkRP.Config.doors_draw_info_3d == false ) then return end

    for _, door in ipairs( ents.FindInSphere( LocalPlayer():GetPos(), 200 ) ) do
        if Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] then
            local ang = door:GetAngles()

            ang:RotateAroundAxis(ang:Right(), 90)
            ang:RotateAroundAxis(ang:Up(), -90)
            
            --surface.SetAlphaMultiplier( LocalPlayer():GetPos():Distance( door:GetPos() ) / 1000 )
            cam.Start3D2D( door:GetPos() + ang:Forward() * -47 + ang:Up() * 1.1 + ang:Right() * -54, ang, 0.12 )
                draw.SimpleTextOutlined( GetTitle( door ), '26 Ambi', 200, 300, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
                draw.SimpleTextOutlined( GetOwners( door ), '20 Ambi', 200, 334, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
            cam.End3D2D()

            -- второй раз, чтобы было с другой стороны
            ang:RotateAroundAxis(ang:Right(), 180)

            cam.Start3D2D( door:GetPos() + ang:Forward() * -4 + ang:Up() * 1.18 + ang:Right() * -54, ang, 0.12 )
                draw.SimpleTextOutlined( GetTitle( door ), '26 Ambi', 220, 300, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
                draw.SimpleTextOutlined( GetOwners( door ), '20 Ambi', 220, 334, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, C.ABS_BLACK )
            cam.End3D2D()
            surface.SetAlphaMultiplier( 1 )
        end
    end
end )

hook.Add( 'HUDPaint', 'Ambi.DarkRP.DrawInfoDoors', function() 
    if not Ambi.DarkRP.Config.doors_draw_info_2d then return end
    
    local pos_table = POS_2D[ Ambi.DarkRP.Config.doors_draw_info_2d_pos ]
    if not pos_table then pos_table = POS_2D[ 'top' ] end

    local door = LocalPlayer():GetEyeTrace().Entity
    if IsValid( door ) and Ambi.DarkRP.Config.doors_classes[ door:GetClass() ] and ( LocalPlayer():GetPos():Distance( door:GetPos() ) <= 110 ) then
        draw.SimpleTextOutlined( GetTitle( door ), '26 Ambi', pos_table.x1, pos_table.y1, C.ABS_WHITE, pos_table.x_align, pos_table.y_align, 1, C.ABS_BLACK )
        draw.SimpleTextOutlined( GetOwners( door ), '20 Ambi', pos_table.x2, pos_table.y2, C.ABS_WHITE, pos_table.x_align, pos_table.y_align, 1, C.ABS_BLACK )
    end
end )