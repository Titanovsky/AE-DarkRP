GAMEMODE = GAMEMODE or {}
GAMEMODE.Config = GAMEMODE.Config or {}
GM = GM or {}
setmetatable( GM, { __index = GAMEMODE } )

GAMEMODE.NoLicense = GAMEMODE.NoLicense or {}

GAMEMODE.Config.DisabledCustomModules = GAMEMODE.Config.DisabledCustomModules or {}
GAMEMODE.Config.voice3D = Ambi.DarkRP.Config.chat_voice_3d
GAMEMODE.Config.AdminsCopWeapons = true
GAMEMODE.Config.allowActs = true
GAMEMODE.Config.allowjobswitch = true
GAMEMODE.Config.allowrpnames = false
GAMEMODE.Config.allowsprays = false
GAMEMODE.Config.allowvehicleowning = false
GAMEMODE.Config.allowvnocollide = true
GAMEMODE.Config.alltalk = Ambi.DarkRP.Config.chat_restrict_enable
GAMEMODE.Config.antimultirun = false
GAMEMODE.Config.autovehiclelock = false
GAMEMODE.Config.babygod = false
GAMEMODE.Config.canforcedooropen = false
GAMEMODE.Config.chatsounds = false
GAMEMODE.Config.chiefjailpos = false
GAMEMODE.Config.cit_propertytax = false
GAMEMODE.Config.copscanunfreeze = false
GAMEMODE.Config.copscanunweld = false
GAMEMODE.Config.cpcanarrestcp = Ambi.DarkRP.Config.police_system_arrest_can_other_police
GAMEMODE.Config.currencyLeft = true
GAMEMODE.Config.customjobs = Ambi.DarkRP.Config.jobs_can_change_name
GAMEMODE.Config.customspawns = true
GAMEMODE.Config.deathblack = false
GAMEMODE.Config.showdeaths = true
GAMEMODE.Config.deadtalk = true
GAMEMODE.Config.deadvoice = false
GAMEMODE.Config.deathpov = false
GAMEMODE.Config.decalcleaner = false
GAMEMODE.Config.disallowClientsideScripts = false
GAMEMODE.Config.doorwarrants = true
GAMEMODE.Config.dropmoneyondeath = false
GAMEMODE.Config.droppocketarrest = false
GAMEMODE.Config.droppocketdeath = false
GAMEMODE.Config.dropweapondeath = false
GAMEMODE.Config.dropspawnedweapons = false
GAMEMODE.Config.dynamicvoice = false
GAMEMODE.Config.earthquakes = false
GAMEMODE.Config.enablebuypistol = false
GAMEMODE.Config.enforceplayermodel = true
GAMEMODE.Config.globalshow = Ambi.DarkRP.Config.hud_3d_enable
GAMEMODE.Config.ironshoot = false
GAMEMODE.Config.showjob = Ambi.DarkRP.Config.hud_3d_show_job
GAMEMODE.Config.letters = false
GAMEMODE.Config.license = false
GAMEMODE.Config.lockdown = true
GAMEMODE.Config.lockpickfading = true
GAMEMODE.Config.logging = true
GAMEMODE.Config.lottery = false
GAMEMODE.Config.showname = Ambi.DarkRP.Config.hud_3d_show_name
GAMEMODE.Config.showhealth = Ambi.DarkRP.Config.hud_3d_show_health
GAMEMODE.Config.needwantedforarrest = Ambi.DarkRP.Config.police_system_arrest_only_wanted
GAMEMODE.Config.noguns = false
GAMEMODE.Config.norespawn = not Ambi.DarkRP.Config.jobs_respawn
GAMEMODE.Config.instantjob = false
GAMEMODE.Config.npcarrest = false
GAMEMODE.Config.ooc = true
GAMEMODE.Config.propertytax = false
GAMEMODE.Config.proppaying = false
GAMEMODE.Config.propspawning = true
GAMEMODE.Config.removeclassitems = true
GAMEMODE.Config.removeondisconnect = false
GAMEMODE.Config.respawninjail = true
GAMEMODE.Config.restrictallteams = false
GAMEMODE.Config.restrictbuypistol = false
GAMEMODE.Config.restrictdrop = false
GAMEMODE.Config.revokeLicenseOnJobChange = false
GAMEMODE.Config.shouldResetLaws = false
GAMEMODE.Config.strictsuicide = Ambi.DarkRP.Config.restrict_can_suicide
GAMEMODE.Config.telefromjail = false
GAMEMODE.Config.teletojail = false
GAMEMODE.Config.unlockdoorsonstart = false
GAMEMODE.Config.voiceradius = Ambi.DarkRP.Config.chat_voice_local_enable
GAMEMODE.Config.wallettax = false
GAMEMODE.Config.wantedrespawn = false
GAMEMODE.Config.wantedsuicide = false
GAMEMODE.Config.realisticfalldamage = false
GAMEMODE.Config.printeroverheat = false
GAMEMODE.Config.weaponCheckerHideDefault = true
GAMEMODE.Config.weaponCheckerHideNoLicense = false

GAMEMODE.Config.adminnpcs                     = Ambi.DarkRP.Config.restrict_spawn_npcs
GAMEMODE.Config.adminsents                    = Ambi.DarkRP.Config.restrict_spawn_entities
GAMEMODE.Config.adminvehicles                 = Ambi.DarkRP.Config.restrict_spawn_vehicles
GAMEMODE.Config.adminweapons                  = Ambi.DarkRP.Config.restrict_spawn_weapons
GAMEMODE.Config.arrestspeed                   = 120
GAMEMODE.Config.babygodtime                   = 5
GAMEMODE.Config.chatsoundsdelay               = 5
GAMEMODE.Config.deathfee                      = 30
GAMEMODE.Config.decaltimer                    = 120
GAMEMODE.Config.demotetime                    = Ambi.DarkRP.Config.jobs_demote_delay
GAMEMODE.Config.doorcost                      = Ambi.DarkRP.Config.doors_cost_buy
GAMEMODE.Config.entremovedelay                = 0
GAMEMODE.Config.gunlabweapon                  = "weapon_p2282"
GAMEMODE.Config.jailtimer                     = Ambi.DarkRP.Config.police_system_arrest_time
GAMEMODE.Config.lockdowndelay                 = 120
GAMEMODE.Config.maxadvertbillboards           = 0
GAMEMODE.Config.maxCheques                    = 0
GAMEMODE.Config.maxdoors                      = Ambi.DarkRP.Config.doors_max
GAMEMODE.Config.maxdrugs                      = 0
GAMEMODE.Config.maxfoods                      = 2
GAMEMODE.Config.maxfooditems                  = 20
GAMEMODE.Config.maxlawboards                  = 0
GAMEMODE.Config.maxletters                    = 0
GAMEMODE.Config.maxlotterycost                = 0
GAMEMODE.Config.maxvehicles                   = 0
GAMEMODE.Config.microwavefoodcost             = 30
GAMEMODE.Config.minlotterycost                = 30
GAMEMODE.Config.moneyRemoveTime               = 600
GAMEMODE.Config.mprintamount                  = 250
GAMEMODE.Config.normalsalary                  = 45
GAMEMODE.Config.npckillpay                    = 10
GAMEMODE.Config.paydelay                      = Ambi.DarkRP.Config.player_payday_delay
GAMEMODE.Config.pocketitems                   = 0
GAMEMODE.Config.pricecap                      = 500
GAMEMODE.Config.pricemin                      = 50
GAMEMODE.Config.propcost                      = 0
GAMEMODE.Config.quakechance                   = 4000
GAMEMODE.Config.respawntime                   = 1
GAMEMODE.Config.changejobtime                 = 10
GAMEMODE.Config.runspeed                      = 240
GAMEMODE.Config.runspeedcp                    = 255
GAMEMODE.Config.searchtime                    = 30
GAMEMODE.Config.ShipmentSpamTime              = 3
GAMEMODE.Config.shipmentspawntime             = 10
GAMEMODE.Config.startinghealth                = 100
GAMEMODE.Config.startingmoney                 = 500
GAMEMODE.Config.stunstickdamage               = 1000
GAMEMODE.Config.vehiclecost                   = 40
GAMEMODE.Config.wallettaxmax                  = 5
GAMEMODE.Config.wallettaxmin                  = 1
GAMEMODE.Config.wallettaxtime                 = 600
GAMEMODE.Config.wantedtime                    = 120
GAMEMODE.Config.walkspeed                     = 160
GAMEMODE.Config.falldamagedamper              = 15
GAMEMODE.Config.falldamageamount              = 10
GAMEMODE.Config.printeroverheatchance         = 22
GAMEMODE.Config.printerreward                 = 950

GAMEMODE.Config.talkDistance    = Ambi.DarkRP.Config.chat_max_length
GAMEMODE.Config.whisperDistance = Ambi.DarkRP.Config.chat_max_length_whisper
GAMEMODE.Config.yellDistance    = Ambi.DarkRP.Config.chat_max_length_scream
GAMEMODE.Config.meDistance      = Ambi.DarkRP.Config.chat_max_length
GAMEMODE.Config.voiceDistance   = Ambi.DarkRP.Config.chat_voice_max_length

GAMEMODE.Config.MoneyClass = Ambi.DarkRP.Config.money_drop_entity_class
GAMEMODE.Config.moneyModel = Ambi.DarkRP.Config.money_drop_entity_model
GAMEMODE.Config.lockdownsound = Ambi.DarkRP.Config.goverment_lockdown_sound
GAMEMODE.Config.DarkRPSkin = "DarkRP"
GAMEMODE.Config.currency = Ambi.DarkRP.Config.money_currency_symbol
GAMEMODE.Config.chatCommandPrefix = "/"
GAMEMODE.Config.F1MenuHelpPage = 'https://github.com/Titanovsky/AE-DarkRP'
GAMEMODE.Config.F1MenuHelpPageTitle = 'DarkRP'
GAMEMODE.Config.notificationSound = "buttons/lightswitch2.wav"

GAMEMODE.Config.DefaultPlayerGroups = {
    [ 'STEAM_0:1:95303327' ] = 'superadmin',
}

GAMEMODE.Config.DisabledCustomModules = {
    ["hudreplacement"] = false,
    ["extraf4tab"] = false,
}

-- The list of weapons that players are not allowed to drop. Items set to true are not allowed to be dropped.
GAMEMODE.Config.DisallowDrop = Ambi.DarkRP.Config.weapon_drop_blocked

-- The list of weapons people spawn with.
GAMEMODE.Config.DefaultWeapons = Ambi.DarkRP.Config.player_base_weapons

GAMEMODE.Config.CategoryOverride = {
    jobs = {
        ["Citizen"]                             = "Citizens",
        ["Hobo"]                                = "Citizens",
        ["Gun Dealer"]                          = "Citizens",
        ["Medic"]                               = "Citizens",
        ["Civil Protection"]                    = "Civil Protection",
        ["Gangster"]                            = "Gangsters",
        ["Mob boss"]                            = "Gangsters",
        ["Civil Protection Chief"]              = "Civil Protection",
        ["Mayor"]                               = "Civil Protection",
    },
    entities = {
        ["Drug lab"]                            = "Other",
        ["Money printer"]                       = "Other",
        ["Gun lab"]                             = "Other",

    },
    shipments = {
        ["AK47"]                                = "Rifles",
        ["MP5"]                                 = "Rifles",
        ["M4"]                                  = "Rifles",
        ["Mac 10"]                              = "Other",
        ["Pump shotgun"]                        = "Shotguns",
        ["Sniper rifle"]                        = "Snipers",

    },
    weapons = {
        ["Desert eagle"]                        = "Pistols",
        ["Fiveseven"]                           = "Pistols",
        ["Glock"]                               = "Pistols",
        ["P228"]                                = "Pistols",
    },
    vehicles = {}, -- There are no default vehicles.
    ammo = {
        ["Pistol ammo"]                         = "Other",
        ["Shotgun ammo"]                        = "Other",
        ["Rifle ammo"]                          = "Other",
    },
}

GAMEMODE.Config.AdminWeapons = {
    "weapon_keypadchecker",
}

GAMEMODE.Config.DefaultLaws = {
    "Do not attack other citizens except in self-defence.",
    "Do not steal or break into people's homes.",
    "Money printers/drugs are illegal.",
}

GAMEMODE.Config.PocketBlacklist = {
    ["fadmin_jail"] = true,
    ["meteor"] = true,
    ["door"] = true,
    ["func_"] = true,
    ["player"] = true,
    ["beam"] = true,
    ["worldspawn"] = true,
    ["env_"] = true,
    ["path_"] = true,
    ["prop_physics"] = true,
    ["money_printer"] = true,
    ["gunlab"] = true,
    ["prop_dynamic"] = true,
    ["prop_vehicle_prisoner_pod"] = true,
    ["keypad_wire"] = true,
    ["gmod_button"] = true,
    ["gmod_rtcameraprop"] = true,
    ["gmod_cameraprop"] = true,
    ["gmod_dynamite"] = true,
    ["gmod_thruster"] = true,
    ["gmod_light"] = true,
    ["gmod_lamp"] = true,
    ["gmod_emitter"] = true,
}

GAMEMODE.Config.noStripWeapons = {
}

GAMEMODE.Config.preventClassItemRemoval = {
    ["gunlab"] = false,
    ["microwave"] = false,
    ["spawned_shipment"] = false,
}

GAMEMODE.Config.allowedProperties = Ambi.DarkRP.Config.restrict_properties

GAMEMODE.Config.hideNonBuyable = false
GAMEMODE.Config.hideTeamUnbuyable = false

GAMEMODE.Config.afkdemotetime = 600
GAMEMODE.Config.AFKDelay = 300

GAMEMODE.Config.minHitPrice = 200
GAMEMODE.Config.maxHitPrice = 50000
GAMEMODE.Config.minHitDistance = 150
GAMEMODE.Config.hudText = "I am a hitman.\nPress E on me to request a hit!"
GAMEMODE.Config.hitmanText = "Hit\naccepted!"
GAMEMODE.Config.hitTargetCooldown = 120
GAMEMODE.Config.hitCustomerCooldown = 240

GAMEMODE.Config.hungerspeed = 2
GAMEMODE.Config.starverate = 3

GAMEMODE.FolderName = 'darkrp'

function GAMEMODE:canTax(ply)
    -- Don't tax players if they have less than twice the starting amount
    if ply:getDarkRPVar("money") < (GAMEMODE.Config.startingmoney * 2) then return false end
end

hook.Call( 'loadCustomDarkRPItems', GM )
hook.Call( 'postLoadCustomDarkRPItems', GM )