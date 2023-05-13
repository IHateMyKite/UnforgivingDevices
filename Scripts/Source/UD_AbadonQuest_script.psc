Scriptname UD_AbadonQuest_script extends Quest Conditional 

import UnforgivingDevicesMain

UDCustomDeviceMain      Property UDCDmain auto
UnforgivingDevicesMain  Property UDmain  Auto
zadlibs Property libs auto 
Quest   Property DragonRising auto

;const values
int     property overaldifficulty   = 1     auto ;0-2 where 3 is same as in MDS
float   property max_difficulty     = 100.0 auto
int     property eventchancemod     = 5     auto

int     property little_finisher_chance     = 40    auto
int     property min_orgasm_little_finisher = 3     auto
int     property max_orgasm_little_finisher = 6     auto

bool    property dmg_heal       = True  auto
bool    property dmg_magica     = True  auto
bool    property dmg_stamina    = False auto

bool    property hardcore                   = False auto
float   property little_finisher_cooldown   = 3.0   auto ;in hours
float   property plug_hunger_update_time    = 1.0   auto ;after one hour plugs escape difficulty increase again
;float property plug_hunger = 0.0 auto
float   Property arousaltimehours       = 0.05  auto
int     Property final_finisher_pref    = 0     auto
float   Property masturbate_cd          = 3.0   auto    ;hours
float   property handrestrain_chance    = 15.0  auto    ;maximal chance for getting hand restrain on orgasm
float   Property executecdhoursbase     = 1.0   auto
int     Property gooRareDeviceChance    = 25    auto
bool    Property UseAnalVariant         = false auto Conditional
bool    property final_finisher_set     = True  auto

Actor   Property UD_AbadonVictim auto

Event onInit()
    registerForSingleUpdate(120.0)
    if UDmain.TraceAllowed()    
        UDmain.Log("Abadon quest initiated")
    endif
EndEvent

Event OnUpdate()
    if (DragonRising.isCompleted() && getStage() == 0)
        if UDmain.DebugMod
            UDmain.Print("Abadon quest courier send")
        endif
        setStage(10)
    else
        registerForSingleUpdate(30.0)
    endif
EndEvent

Int         _CustomSets     = 0
String[]    _EquipEvent
String[]    _SuitNames
String[]    _PatchName ;only used for possible further optimizations

Function Update()
    _CustomSets     = 0
    _EquipEvent     = Utility.CreateStringArray(0) ;create empty array .......
    _SuitNames      = Utility.CreateStringArray(0) ;create empty array .......
    _PatchName      = Utility.CreateStringArray(0) ;create empty array .......
    _CustomSetMutex = false
    SendModEvent("UD_AbadonSuitUpdate", "UpdateEvent") ;send update event, which should all patches get
EndFunction

Bool        _CustomSetMutex = false
Function AddCustomAbadonSet(String asEquipEvent,String asSuitName, String asPatchName)
    _CustomSets += 1
    while _CustomSetMutex
        Utility.waitMenuMode(0.01)
    endwhile
    _CustomSetMutex = true
    _EquipEvent = PapyrusUtil.PushString(_EquipEvent,asEquipEvent)
    _SuitNames  = PapyrusUtil.PushString(_SuitNames,asSuitName)
    _PatchName  = PapyrusUtil.PushString(_PatchName,asPatchName)
    ;UDmain.Info("Adding new custom abadon suit /" + asSuitName + " / from patch " + asPatchName)
    _CustomSetMutex = false
EndFunction
Function EquipCustomAbadonSet(Actor akActor, Int aiSuitEvent)
    Int loc_suit = aiSuitEvent - UDmain.config.final_finisher_pref_list.length
    int loc_handle = ModEvent.Create(_EquipEvent[loc_suit])
    if loc_handle
        ModEvent.PushForm(loc_handle, akActor) ;actor
        ModEvent.PushString(loc_handle, _EquipEvent[loc_suit]) ;event
        ModEvent.Send(loc_handle)
    endif
EndFunction

Int Property UD_AbadonSuitNumber
    Int Function Get()
        return UDmain.config.final_finisher_pref_list.length + _CustomSets
    EndFunction
EndProperty

String[] Property UD_AbadonSuitList
    String[] Function Get()
        if _CustomSets
            return PapyrusUtil.MergeStringArray(UDmain.config.final_finisher_pref_list,_EquipEvent)
        else
            return UDmain.config.final_finisher_pref_list
        endif
    EndFunction
EndProperty
String[] Property UD_AbadonSuitNames
    String[] Function Get()
        if _CustomSets
            return PapyrusUtil.MergeStringArray(UDmain.config.final_finisher_pref_list,_SuitNames)
        else
            return UDmain.config.final_finisher_pref_list
        endif
    EndFunction
EndProperty


Function AbadonEquipSuit(Actor target,int suit)
    UDCDmain.DisableActor(target)
    UnforgivingDevicesMain.closeMenu()
    if suit == 0
        if _CustomSets
            suit = Utility.randomInt(1,UDmain.config.final_finisher_pref_list.length - 1 + _CustomSets)
        else
            suit = Utility.randomInt(1,UDmain.config.final_finisher_pref_list.length - 1)
        endif
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
    else
        EquipCustomAbadonSet(target,suit)
    endif
    UDCDmain.EnableActor(target)
EndFunction

Function EquipAbadonDevices(Actor akTarget,Int aiMinDevices, Int aiMaxDevices)
    if !akTarget.wornhaskeyword(libs.zad_deviousheavybondage)
        UDCDmain.DisableActor(akTarget)
        Int loc_arousal = UDmain.UDOM.getArousal(akTarget)
        if Utility.randomInt(1,99) < Round(UDCDMain.UD_BlackGooRareDeviceChance*fRange(loc_arousal/50,1.0,2.0))
            ;rare devices, drop more loot and goo
            if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
                int random = Utility.randomInt(1,3)
                if random == 1
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonBlueArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDmain.UDlibs.MageBinder)
                elseif random == 3
                    libs.LockDevice(akTarget,UDmain.UDlibs.RogueBinder)
                endif
            else
                int random = Utility.randomInt(1,2)
                if random == 1
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonBlueArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDmain.UDlibs.RogueBinder)
                endif
            endif
            if UDmain.ActorIsPlayer(akTarget)
                UDmain.ShowMessageBox("Black goo covers your body and tie your hands while changing shape to RARE bondage restraint!")
            endif
        else
            if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
                int random = Utility.randomInt(1,4)
                if random == 1
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakStraitjacket)
                elseif random == 3
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakElbowbinder)
                elseif random == 4
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakYoke)
                endif
            else
                int random = Utility.randomInt(1,3)
                if random == 1
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakElbowbinder)
                elseif random == 3
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakYoke)
                endif
            endif
            if UDmain.ActorIsPlayer(akTarget)
                UDmain.ShowMessageBox("Black goo covers your body and tie your hands while changing shape to bondage restraint!")
            endif
        endif
        UDCDmain.EnableActor(akTarget)
    endif
    int loc_devicenum = Utility.randomInt(aiMinDevices,aiMaxDevices)
    UDmain.UDRRM.LockAnyRandomRestrain(akTarget,loc_devicenum)
EndFunction