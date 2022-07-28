Scriptname UD_AbadonQuest_script extends Quest Conditional 

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain  Auto
UD_libs Property UDlibs  Auto  
zadlibs Property libs auto 
Quest Property DragonRising auto

;const values
int property overaldifficulty  = 1 auto ;0-2 where 3 is same as in MDS
float property max_difficulty = 100.0 auto
int property eventchancemod = 5 auto

int property little_finisher_chance = 40 auto
int property min_orgasm_little_finisher = 3 auto
int property max_orgasm_little_finisher = 6 auto

bool property dmg_heal = True auto
bool property dmg_magica = True auto
bool property dmg_stamina = False auto

bool property hardcore = False auto
float property little_finisher_cooldown = 3.0 auto ;in hours
float property plug_hunger_update_time = 1.0 auto ;after one hour plugs escape difficulty increase again
;float property plug_hunger = 0.0 auto
float Property arousaltimehours = 0.05 auto
int Property final_finisher_pref = 0 auto
float Property masturbate_cd = 3.0 auto;hours
float property handrestrain_chance = 15.0 auto ;maximal chance for getting hand restrain on orgasm
float Property executecdhoursbase = 1.0 auto
int Property gooRareDeviceChance = 25 auto
bool Property UseAnalVariant = false auto Conditional
bool property final_finisher_set = True auto

Actor Property UD_AbadonVictim auto

Event onInit()
    registerForSingleUpdate(120.0)
        
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Abadon quest initiated")
    endif
EndEvent

Event OnUpdate()
    if (DragonRising.isCompleted() && getStage() == 0)
        if UDmain.DebugMod
            UDCDmain.Print("Abadon quest courier send")
        endif
        setStage(10)
    else
        ;registerForSingleUpdate(25.0)
        registerForSingleUpdate(30.0)
    endif
EndEvent

Function AbadonEquipSuit(Actor target,int suit)
    ;Game.DisablePlayerControls()
    UDCDmain.DisableActor(target)
    if suit == 0
        suit = Utility.randomInt(1,UDmain.config.final_finisher_pref_list.length - 1)
    endif
    if suit == 1
        UDmain.ItemManager.equipAbadonRopeSuit(target)
    elseif suit == 2
        UDmain.ItemManager.equipAbadonTransparentSuit(target)    
    elseif suit == 3
        UDmain.ItemManager.equipAbadonLatexSuit(target)
    elseif suit == 4
        UDmain.ItemManager.equipAbadonRestrictiveSuit(target)
    elseif suit == 5
        UDmain.ItemManager.equipAbadonSimpleSuit(target)
    elseif suit == 6
        UDmain.ItemManager.equipAbadonYokeSuit(target)
    endif
    UDCDmain.EnableActor(target)
    ;Game.EnablePlayerControls()
EndFunction

