Scriptname UD_AbadonQuest_script extends Quest Conditional 

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain      Property UDCDmain auto
UnforgivingDevicesMain  Property UDmain  Auto
zadlibs Property libs auto 
Quest   Property DragonRising auto

UD_libs                 Property UDlibs hidden
    UD_libs Function get()
        return UDCDMain.UDlibs
    EndFunction
EndProperty

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

Function Update()
EndFunction

Int _LastHandRestrain = 0
Function AbadonGooEffect(Actor akTarget)
    if !UDmain.ActorIsValidForUD(akTarget)
        return ;non valid actor, return
    endif
    Float loc_arousal = UDmain.UDOM.getArousal(akTarget)
    if !akTarget.wornhaskeyword(libs.zad_deviousheavybondage)
        UDCDmain.DisableActor(akTarget)
        if RandomInt(1,99) < Round(UDCDMain.UD_BlackGooRareDeviceChance*fRange(loc_arousal/50.0,1.0,2.0))
            ;rare devices, drop more loot and goo
            if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
                int random = RandomInt(1,3)
                if random == 1
                    libs.LockDevice(akTarget,UDlibs.AbadonBlueArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDlibs.MageBinder)
                elseif random == 3
                    libs.LockDevice(akTarget,UDlibs.RogueBinder)
                endif
            else
                int random = RandomInt(1,2)
                if random == 1
                    libs.LockDevice(akTarget,UDlibs.AbadonBlueArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDlibs.RogueBinder)
                endif
            endif
            if IsPlayer(akTarget)
                UDmain.ShowMessageBox("Black goo covers your body and tie your hands while changing shape to RARE bondage restraint!")
            endif
        else
            int random = RandomInt(1,4)
            if _LastHandRestrain == random
                if random < 4
                    random += 1
                elseif random > 0
                    random -= 1
                endif
            endif
            _LastHandRestrain = random
            if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
                if random == 0
                    libs.LockDevice(akTarget,UDlibs.AbadonWeakArmbinder)
                elseif random == 1
                    libs.LockDevice(akTarget,UDlibs.AbadonWeakElbowbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDlibs.AbadonWeakYoke)
                elseif random == 3
                    libs.LockDevice(akTarget,UDlibs.AbadonWeakStraitjacket)
                elseif random == 4
                    libs.LockDevice(akTarget,UDlibs.AbadonWeakBoxbinder)
                endif
                
            else
                if random == 0 || random == 3
                    libs.LockDevice(akTarget,UDlibs.AbadonWeakArmbinder)
                elseif random == 1 
                    libs.LockDevice(akTarget,UDlibs.AbadonWeakElbowbinder)
                elseif random == 2 || random == 4
                    libs.LockDevice(akTarget,UDlibs.AbadonWeakYoke)
                endif
            endif
            _LastHandRestrain = random
            if IsPlayer(akTarget)
                UDmain.ShowMessageBox("Black goo covers your body and tie your hands while changing shape to bondage restraint!")
            endif
        endif
        
        ;chance to lock plugs and belt. Only works if player first finished abadon quest (as some plugs can evolve in to abadon plug)
        if RandomInt(1,99) < Round(15.0*fRange(loc_arousal/25.0,1.0,3.5))
            UDmain.ItemManager.lockAbadonHelperPlugs(akTarget)
            if (!akTarget.WornhasKeyword(libs.zad_DeviousBelt))
                ;choose one random chastity device
                if RandomInt(0,1)
                    libs.LockDevice(akTarget,UDlibs.AbadonHarness)
                else
                    libs.LockDevice(akTarget,UDlibs.AbadonBelt)
                endif
            endif
        endif
        UDCDmain.EnableActor(akTarget)
    endif
EndFunction

Function AbadonEquipSuit(Actor target,int suit)
    UDCDmain.DisableActor(target)
    UnforgivingDevicesMain.closeMenu()
    
    UDmain.UDOTM.LockAbadonOutfit(target)
    
    UDCDmain.EnableActor(target)
EndFunction

Function AbadonEquipSuitSelective(Actor target)
    UDCDmain.DisableActor(target)
    UnforgivingDevicesMain.closeMenu()
    
    UDmain.UDOTM.LockAbadonOutfitSelective(target)
    
    UDCDmain.EnableActor(target)
EndFunction

Function EquipAbadonDevices(Actor akTarget,Int aiMinDevices, Int aiMaxDevices)
    if !akTarget.wornhaskeyword(libs.zad_deviousheavybondage)
        UDCDmain.DisableActor(akTarget)
        Int loc_arousal = Round(UDmain.UDOM.getArousal(akTarget))
        if RandomInt(1,99) < Round(UDCDMain.UD_BlackGooRareDeviceChance*fRange(loc_arousal/50,1.0,2.0))
            ;rare devices, drop more loot and goo
            if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
                int random = RandomInt(1,3)
                if random == 1
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonBlueArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDmain.UDlibs.MageBinder)
                elseif random == 3
                    libs.LockDevice(akTarget,UDmain.UDlibs.RogueBinder)
                endif
            else
                int random = RandomInt(1,2)
                if random == 1
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonBlueArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDmain.UDlibs.RogueBinder)
                endif
            endif
            if IsPlayer(akTarget)
                UDmain.ShowMessageBox("Black goo covers your body and tie your hands while changing shape to RARE bondage restraint!")
            endif
        else
            if !akTarget.wornhaskeyword(libs.zad_deviousSuit)
                int random = RandomInt(1,4)
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
                int random = RandomInt(1,3)
                if random == 1
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakArmbinder)
                elseif random == 2
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakElbowbinder)
                elseif random == 3
                    libs.LockDevice(akTarget,UDmain.UDlibs.AbadonWeakYoke)
                endif
            endif
            if IsPlayer(akTarget)
                UDmain.ShowMessageBox("Black goo covers your body and tie your hands while changing shape to bondage restraint!")
            endif
        endif
        UDCDmain.EnableActor(akTarget)
    endif
    int loc_devicenum = RandomInt(aiMinDevices,aiMaxDevices)
    UDmain.UDRRM.LockAnyRandomRestrain(akTarget,loc_devicenum)
EndFunction