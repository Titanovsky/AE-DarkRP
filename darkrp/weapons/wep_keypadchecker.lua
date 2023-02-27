local RegEnt, C = Ambi.RegEntity, Ambi.General.Global.Colors

-- ---------------------------------------------------------------------------------------------------------------------------------------
local SWEP = {}
SWEP.Primary = {}
SWEP.Secondary = {}

SWEP.Class          = 'weapon_keypadchecker'
SWEP.Base           = 'weapon_base'
SWEP.Category       = 'DarkRP'
SWEP.PrintName = "Admin Keypad Checker"
SWEP.Author = "DarkRP Developers"
SWEP.Instructions = "Left click on a keypad or fading door to check it\nRight click to clear"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.ViewModelFlip = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.Ammo = ""
SWEP.Secondary.Ammo = ""

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = 'DarkRP'

SWEP.HoldType = "normal"
SWEP.ViewModel = Model("models/weapons/c_pistol.mdl")
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.IconLetter = ""

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.UseHands = true

local table_insert = table.insert
local tonumber = tonumber

local function getTargets(keypad, keyPass, keyDenied, delayPass, delayDenied)
    local targets = {}
    local Owner = keypad:CPPIGetOwner()

    for _, v in pairs(numpad.OnDownItems or {}) do
        if v.key == keyPass and v.ply == Owner then
            table_insert(targets, {type = DarkRP.getPhrase("keypad_checker_entering_right_pass"), name = v.name, ent = v.ent, original = keypad})
        end
        if v.key == keyDenied and v.ply == Owner then
            table_insert(targets, {type = DarkRP.getPhrase("keypad_checker_entering_wrong_pass"), name = v.name, ent = v.ent, original = keypad})
        end
    end

    for _, v in pairs(numpad.OnUpItems or {}) do
        if v.key == keyPass and v.ply == Owner then
            table_insert(targets, {type = DarkRP.getPhrase("keypad_checker_after_right_pass"), name = v.name, delay = math.Round(delayPass, 2), ent = v.ent, original = keypad})
        end
        if v.key == keyDenied and v.ply == Owner then
            table_insert(targets, {type = DarkRP.getPhrase("keypad_checker_after_wrong_pass"), name = v.name, delay = math.Round(delayDenied, 2), ent = v.ent, original = keypad})
        end
    end

    return targets
end

--[[---------------------------------------------------------------------------
Get the entities that are affected by the keypad
---------------------------------------------------------------------------]]
local function get_sent_keypad_Info(keypad)
    local keyPass = keypad:GetNWInt("keypad_keygroup1")
    local keyDenied = keypad:GetNWInt("keypad_keygroup2")
    local delayPass = keypad:GetNWInt("keypad_length1")
    local delayDenied = keypad:GetNWInt("keypad_length2")

    return getTargets(keypad, keyPass, keyDenied, delayPass, delayDenied)
end

--[[---------------------------------------------------------------------------
Overload for a different keypad addon
---------------------------------------------------------------------------]]
local function get_keypad_Info(keypad)
    local keyPass = tonumber(keypad.KeypadData.KeyGranted) or 0
    local keyDenied = tonumber(keypad.KeypadData.KeyDenied) or 0
    local delayPass = tonumber(keypad.KeypadData.LengthGranted) or 0
    local delayDenied = tonumber(keypad.KeypadData.LengthDenied) or 0

    return getTargets(keypad, keyPass, keyDenied, delayPass, delayDenied)
end


--[[---------------------------------------------------------------------------
Get the keypads that trigger this entity
---------------------------------------------------------------------------]]
local function getEntityKeypad(ent)
    local targets = {}
    local doorKeys = {} -- The numpad keys that activate this entity
    local entOwner = ent:CPPIGetOwner()

    for _, v in pairs(numpad.OnDownItems or {}) do
        if v.ent == ent then
            table_insert(doorKeys, v.key)
        end
    end

    for _, v in pairs(numpad.OnUpItems or {}) do
        if v.ent == ent then
            table_insert(doorKeys, v.key)
        end
    end

    for _, v in ipairs(ents.FindByClass("sent_keypad")) do
        local vOwner = v:CPPIGetOwner()

        if vOwner == entOwner and table.HasValue(doorKeys, v:GetNWInt("keypad_keygroup1")) then
            table_insert(targets, {type = DarkRP.getPhrase("keypad_checker_right_pass_entered"), ent = v, original = ent})
        end
        if vOwner == entOwner and table.HasValue(doorKeys, v:GetNWInt("keypad_keygroup2")) then
            table_insert(targets, {type = DarkRP.getPhrase("keypad_checker_wrong_pass_entered"), ent = v, original = ent})
        end
    end

    for _, v in ipairs(ents.FindByClass("keypad")) do
        local vOwner = v:CPPIGetOwner()

        if vOwner == entOwner and table.HasValue(doorKeys, tonumber(v.KeypadData.KeyGranted) or 0) then
            table_insert(targets, {type = DarkRP.getPhrase("keypad_checker_right_pass_entered"), ent = v, original = ent})
        end
        if vOwner == entOwner and table.HasValue(doorKeys, tonumber(v.KeypadData.KeyDenied) or 0) then
            table_insert(targets, {type = DarkRP.getPhrase("keypad_checker_wrong_pass_entered"), ent = v, original = ent})
        end
    end

    return targets
end

--[[---------------------------------------------------------------------------
Send the info to the client
---------------------------------------------------------------------------]]
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.3)
    if not SERVER then return end

    local Owner = self:GetOwner()
    local trace = Owner:GetEyeTrace()
    if not IsValid(trace.Entity) then return end
    local ent, class = trace.Entity, string.lower(trace.Entity:GetClass() or "")
    local data

    if class == "sent_keypad" then
        data = get_sent_keypad_Info(ent)
        DarkRP.notify(Owner, 1, 4, DarkRP.getPhrase("keypad_checker_controls_x_entities", #data / 2))
    elseif class == "keypad" then
        data = get_keypad_Info(ent)
        DarkRP.notify(Owner, 1, 4, DarkRP.getPhrase("keypad_checker_controls_x_entities", #data / 2))
    else
        data = getEntityKeypad(ent)
        DarkRP.notify(Owner, 1, 4, DarkRP.getPhrase("keypad_checker_controlled_by_x_keypads", #data))
    end

    net.Start("DarkRP_keypadData")
        net.WriteTable(data)
    net.Send(Owner)
end

function SWEP:SecondaryAttack()
end

if CLIENT then
    local DrawData = {}
    local KeypadCheckerHalos

    net.Receive("DarkRP_keypadData", function(len)
        DrawData = net.ReadTable()
        hook.Add("PreDrawHalos", "KeypadCheckerHalos", KeypadCheckerHalos)
    end)

    local lineMat = Material("cable/chain")
    local textCol = Color(0, 0, 0, 120)
    local haloCol = Color(0, 255, 0, 255)

    function SWEP:DrawHUD()
        local screenCenter = ScrH() / 2
        draw.WordBox(2, 10, screenCenter, DarkRP.getPhrase("keypad_checker_shoot_keypad"), "UiBold", textCol, color_white)
        draw.WordBox(2, 10, screenCenter + 20, DarkRP.getPhrase("keypad_checker_shoot_entity"), "UiBold", textCol, color_white)
        draw.WordBox(2, 10, screenCenter + 40, DarkRP.getPhrase("keypad_checker_click_to_clear"), "UiBold", textCol, color_white)

        local eyePos = EyePos()
        local eyeAngles = EyeAngles()

        local entMessages = {}
        for k,v in ipairs(DrawData or {}) do
            if not IsValid(v.ent) or not IsValid(v.original) then continue end
            entMessages[v.ent] = (entMessages[v.ent] or 0) + 1
            local obbCenter = v.ent:OBBCenter()
            local pos = v.ent:LocalToWorld(obbCenter):ToScreen()

            local name = v.name and ": " .. v.name:gsub("onDown", DarkRP.getPhrase("keypad_on")):gsub("onUp", DarkRP.getPhrase("keypad_off")) or ""

            draw.WordBox(2, pos.x, pos.y + entMessages[v.ent] * 16, (v.delay and v.delay .. " " .. DarkRP.getPhrase("seconds") .. " " or "") .. v.type .. name, "UiBold", textCol, color_white)

            cam.Start3D(eyePos, eyeAngles)
                render.SetMaterial(lineMat)
                render.DrawBeam(v.original:GetPos(), v.ent:GetPos(), 2, 0.01, 20, haloCol)
            cam.End3D()
        end
    end

    KeypadCheckerHalos = function()
        local drawEnts = {}
        local i = 1
        for k,v in ipairs(DrawData) do
            if not IsValid(v.ent) then continue end

            drawEnts[i] = v.ent
            i = i + 1
        end

        if table.IsEmpty(drawEnts) then return end
        halo.Add(drawEnts, haloCol, 5, 5, 5, nil, true)
    end

    function SWEP:SecondaryAttack()
        DrawData = {}
        hook.Remove("PreDrawHalos", "KeypadCheckerHalos")
    end
end

if not SERVER then return end

--[[---------------------------------------------------------------------------
Registering numpad data
---------------------------------------------------------------------------]]
local oldNumpadUp = numpad.OnUp
local oldNumpadDown = numpad.OnDown

function numpad.OnUp(ply, key, name, ent, ...)
    numpad.OnUpItems = numpad.OnUpItems or {}
    table_insert(numpad.OnUpItems, {ply = ply, key = key, name = name, ent = ent, arg = {...}})

    return oldNumpadUp(ply, key, name, ent, ...)
end

function numpad.OnDown(ply, key, name, ent, ...)
    numpad.OnDownItems = numpad.OnDownItems or {}
    table_insert(numpad.OnDownItems, {ply = ply, key = key, name = name, ent = ent, arg = {...}})

    return oldNumpadDown(ply, key, name, ent, ...)
end

util.AddNetworkString( "DarkRP_keypadData" )

RegEnt.Register( SWEP.Class, 'weapons', SWEP )