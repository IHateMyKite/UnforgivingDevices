Scriptname UD_MCM_Page_Debug extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_CustomDevices_NPCSlotsManager Property UDCD_NPCM
    UD_CustomDevices_NPCSlotsManager Function Get()
        return UDmain.UDNPCM
    EndFunction
EndProperty

Function PageInit()
    actorIndex = 10 ; Why is it set to 10 ???
EndFunction

Function PageUpdate()
    registered_devices_T = new Int[25]
    NPCSlots_T = Utility.CreateIntArray(UDCD_NPCM.GetNumAliases())
EndFunction

int[] registered_devices_T
int[] NPCSlots_T
int fix_flag
;int npc_flag
int fixBugs_T
int rescanSlots_T
int unlockAll_T
int showDetails_T
int actorIndex = 15
int unregisterNPC_T
int GlobalUpdateNPC_T
int OrgasmResist_S
int OrgasmCapacity_S
Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
    setCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("$UD_H_DEVICE_SLOTS")
    AddHeaderOption("$UD_H_NPC SLOTS")
    int i = 0
    
    UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(actorIndex)
    if !slot.isUsed()
        slot = UDCD_NPCM.getPlayerSlot()
        actorIndex = UDCD_NPCM.getPlayerIndex()
    endif
    UD_CustomDevice_RenderScript[] devices = slot.UD_equipedCustomDevices
    int size = devices.length
    
    fix_flag = OPTION_FLAG_NONE
    
    while i < size
        if devices[i]
            registered_devices_T[i] = AddTextOption((i + 1) + ") " , devices[i].deviceInventory.getName(),FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))
        else
            registered_devices_T[i] = AddTextOption((i + 1) + ") " , "$UD_EMPTY" ,OPTION_FLAG_DISABLED)
        endif
            if i == 0
                setNPCSlot(15,"PlayerSlot",False)
            elseif i == 1
                setNPCSlot(0)
            elseif i == 2
                setNPCSlot(1)
            elseif i == 3
                setNPCSlot(2)
            elseif i == 4
                setNPCSlot(3)
            elseif i == 5
                setNPCSlot(4)
            elseif i == 6
                setNPCSlot(5)
            elseif i == 7
                setNPCSlot(6)
            elseif i == 8
                setNPCSlot(7)
            elseif i == 9
                setNPCSlot(8)
            elseif i == 10
                setNPCSlot(9)
            elseif i == 11
                setNPCSlot(10)
            elseif i == 12
                setNPCSlot(11)
            elseif i == 13
                setNPCSlot(12)
            elseif i == 14
                setNPCSlot(13)
            elseif i == 15
                setNPCSlot(14)
            elseif i == 16
                AddHeaderOption("$UD_H_TOOLS")
            elseif i == 17
                AddTextOption("$UD_DEVICES", slot.getNumberOfRegisteredDevices() ,OPTION_FLAG_DISABLED)
            elseif i == 18
                OrgasmResist_S          = addSliderOption("$UD_ORGASMRESIST",OrgasmSystem.GetOrgasmVariable(slot.getActor(),3), "{1}",OPTION_FLAG_DISABLED)
            elseif i == 19
                OrgasmCapacity_S        = addSliderOption("$UD_ORGASMCAPACITY",OrgasmSystem.GetOrgasmVariable(slot.getActor(),5), "{0}",OPTION_FLAG_DISABLED)
            elseif i == 20
                unlockAll_T             = AddTextOption("$UD_UNLOCK_ALL", "$CLICK" ,FlagSwitchAnd(UD_LockMenu_flag,FlagSwitch(!UDmain.UD_LockDebugMCM)))
            elseif i == 21
                showDetails_T           = AddTextOption("$UD_DEBUGSHOWDETAILS", "$CLICK" )
            elseif i == 22
                fixBugs_T               = AddTextOption("$UD_FIXBUGS", "$CLICK" ,fix_flag)
            elseif i == 23
                if !slot.isPlayer()
                    unregisterNPC_T = AddTextOption("$UD_UNREGISTER_NPC","$CLICK")
                else
                    addEmptyOption()
                endif
            elseif i == 24
                addEmptyOption()
                    
            else     
                addEmptyOption()
            endif
        i += 1
    endwhile
    
    AddHeaderOption("$UD_H_GLOBAL")
    addEmptyOption()
    
    rescanSlots_T = AddTextOption("$UD_RESCANSLOTS", "$CLICK")
    addEmptyOption()
EndFunction

int selected_device
Function PageOptionSelect(Int option)
    if fixBugs_T == option
        closeMCM()
        UDCD_NPCM.getNPCSlotByIndex(actorIndex).fix()
    elseif unlockAll_T == option
        closeMCM()
        UDCDmain.removeAllDevices(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
    elseif showDetails_T == option
        closeMCM()
        UDCDmain.ShowActorDetailsMenu(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
    elseif unregisterNPC_T == option
        UDCD_NPCM.unregisterNPC(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor())
        forcePageReset()
    elseif option == GlobalUpdateNPC_T
        int loc_globalupdate = StorageUtil.GetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , 0)
        StorageUtil.SetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , (!loc_globalupdate) as Int)
        SetToggleOptionValue(GlobalUpdateNPC_T, StorageUtil.GetIntValue(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(), "GlobalUpdate" , 0))    
    elseif option == rescanSlots_T
        closeMCM()
        Utility.waitMenuMode(0.5)
        debug.notification("$[UD] Scanning!")
        UDCD_NPCM.scanSlots(True)
        
        ;forcePageReset()
    else
        int i = UDCD_NPCM.getNumSlots()
        while i 
            i -= 1
            if NPCSlots_T[i] == option
                actorIndex = i
                forcePageReset()
                return
            endif
        endwhile
    
        i = registered_devices_T.length
        while i 
            i -= 1
            if registered_devices_T[i] == option
                selected_device = i
                
                closeMCM()
                UDCDmain.showDebugMenu(UDCD_NPCM.getNPCSlotByIndex(actorIndex).getActor(),selected_device)
                return
            endif
        endwhile
    endif
EndFunction

Function PageOptionSliderOpen(Int aiOption)

EndFunction
Function PageOptionSliderAccept(Int aiOption, Float afValue)

EndFunction

Function PageOptionMenuOpen(int aiOption)

EndFunction
Function PageOptionMenuAccept(int aiOption, int aiIndex)

EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int option)
    ;dear mother of god
    if (option == rescanSlots_T)
        SetInfoText("$UD_RESCANSLOTS_INFO")
    elseif option == fixBugs_T
        SetInfoText("$UD_FIXBUGS_INFO")
    elseif option == unlockAll_T
        SetInfoText("$UD_UNLOCK_ALL_INFO")
    elseif option == showDetails_T
        SetInfoText("$UD_DEBUGSHOWDETAILS_INFO")
    elseif option == unregisterNPC_T
        SetInfoText("$UD_UNREGISTER_NPC_INFO")
    elseif option == OrgasmCapacity_S
        SetInfoText("$UD_ORGASMCAPACITY_INFO")
    elseif option == OrgasmResist_S
        SetInfoText("$UD_ORGASMRESIST_INFO")
    endIf
EndFunction

Function setNPCSlot(int index,string text = "NPC Slot",bool useIndex = True)
    int npcflag = OPTION_FLAG_NONE
    UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByIndex(index)
    if !slot.isUsed()
        npcflag = OPTION_FLAG_DISABLED
    else
        npcflag = OPTION_FLAG_NONE
    endif
    string name = ""
    if actorIndex == index
        name = "->" +  slot.getSlotedNPCName()
    else
        name = slot.getSlotedNPCName()
    endif
    if useIndex
        NPCSlots_T[index] = AddTextOption(text + (index + 1)+": ", name ,npcflag)
    else
        NPCSlots_T[index] = AddTextOption(text +": ", name ,npcflag)
    endif
EndFunction