;   File: UD_Events
;   This script containt all event senders, which are send by UD
Scriptname UD_Events Hidden

;/  About: UDEvent_DeviceLocked
    Event UDEvent_DeviceLocked is sent after the Unforgiving device is fully locked
    --- Code
    ; Prototype
    Event UDEvent_DeviceLocked(String asSource, Form akFActor, Form akFID, Form akFRD)
        ;Actor on which was device locked
        Actor akActor   = akFActor as Actor
        
        ;Inventory device of locked device
        Armor akID      = akFID as Armor
        
        ;Render device of locked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---
/;
Bool Function SendEvent_DeviceLocked(UD_CustomDevice_RenderScript akDevice) global
    Int loc_handle = ModEvent.Create("UDEvent_DeviceLocked")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                ;Event Source
        ModEvent.PushForm(loc_handle, akDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akDevice.DeviceRendered)      ;RD
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction

;/  About: UDEvent_DeviceUnlocked
    Event UDEvent_DeviceUnlocked is sent after the Unforgiving device is fully unlocked
    --- Code
    ; Prototype
    Event UDEvent_DeviceUnlocked(String asSource, Form akFActor, Form akFID, Form akFRD)
        ;Actor from which was device unlocked
        Actor akActor   = akFActor as Actor
        
        ;Inventory device of unlocked device
        Armor akID      = akFID as Armor
        
        ;Render device of unlocked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---
/;
Bool Function SendEvent_DeviceUnlocked(UD_CustomDevice_RenderScript akDevice) global
    Int loc_handle = ModEvent.Create("UDEvent_DeviceUnlocked")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                ;Event Source
        ModEvent.PushForm(loc_handle, akDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akDevice.DeviceRendered)      ;RD
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction

;/  About: UDEvent_DeviceMinigameBegin
    Event UDEvent_DeviceMinigameBegin is sent after the Unforgiving device minigame starts
    --- Code
    ; Prototype
    Event UDEvent_DeviceMinigameBegin(String asSource, Form akFActor, Form akFHelper, Float afRelativeDurability, Form akFID, Form akFRD)
        ;Actor on which was device minigame started
        Actor akActor   = akFActor as Actor
        
        ;Minigame helper if it was used. If no helper was used, this will be none
        Actor akHelper   = akFHelper as Actor
        
        ;Inventory device of locked device
        Armor akID      = akFID as Armor
        
        ;Render device of locked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---
/;
Bool Function SendEvent_DeviceMinigameBegin(UD_CustomDevice_RenderScript akDevice, String asMinigame) global
    Int loc_handle = ModEvent.Create("UDEvent_DeviceMinigameBegin")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                ;Event Source
        ModEvent.PushForm(loc_handle, akDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akDevice.GetHelper())         ;Helper
        ModEvent.PushString(loc_handle, asMinigame)                 ;Minigame name
        ModEvent.PushFloat(loc_handle, akDevice.GetRelativeDurability())  ;Relative durability
        ModEvent.PushForm(loc_handle, akDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akDevice.DeviceRendered)      ;RD
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction

;/  About: UDEvent_DeviceMinigameEnd
    Event UDEvent_DeviceMinigameEnd is sent after the Unforgiving device minigame ends
    --- Code
    ; Prototype
    Event UDEvent_DeviceMinigameEnd(String asSource, Form akFActor, Form akFHelper, Float afRelativeDurability, Bool abIsUnlocked, Form akFID, Form akFRD)
        ;Actor on which was device minigame started
        Actor akActor   = akFActor as Actor
        
        ;Minigame helper if it was used. If no helper was used, this will be none
        Actor akHelper   = akFHelper as Actor
        
        ;Inventory device of locked device
        Armor akID      = akFID as Armor
        
        ;Render device of locked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---
/;
Bool Function SendEvent_DeviceMinigameEnd(UD_CustomDevice_RenderScript akDevice, String asMinigame) global
    Int loc_handle = ModEvent.Create("UDEvent_DeviceMinigameEnd")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                ;Event Source
        ModEvent.PushForm(loc_handle, akDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akDevice.GetHelper())         ;Helper
        ModEvent.PushString(loc_handle, asMinigame)                 ;Minigame name
        ModEvent.PushFloat(loc_handle, akDevice.GetRelativeDurability())  ;Relative durability
        ModEvent.PushBool(loc_handle, akDevice.IsUnlocked)          ;True if device is unlocked
        ModEvent.PushForm(loc_handle, akDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akDevice.DeviceRendered)      ;RD
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction