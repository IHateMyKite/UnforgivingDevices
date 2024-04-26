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

;/  About: UDEvent_VibDeviceEffectStart
    Event UDEvent_VibDeviceEffectStart is sent after UD vibrator device starts vibrating
    --- Code
    ; Prototype
    Event UDEvent_VibDeviceEffectStart(String asSource, Form akFActor, Form akFID, Form akFRD, Int aiEroZones, Int aiBaseStrength, Int aiCurrentStrength)
        ;Actor on which was vibrator turned on
        Actor akActor   = akFActor as Actor
        
        ;Inventory device of locked device
        Armor akID      = akFID as Armor
        
        ;Render device of locked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---

    See: <EroZone>
/;
Bool Function SendEvent_VibDeviceEffectStart(UD_CustomVibratorBase_RenderScript akVibDevice) global
    Int loc_handle = ModEvent.Create("UDEvent_VibDeviceEffectStart")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                   ;Event Source
        ModEvent.PushForm(loc_handle, akVibDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akVibDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akVibDevice.DeviceRendered)      ;RD
        ModEvent.PushInt(loc_handle, akVibDevice.UD_EroZones)          ;Ero zones
        ModEvent.PushInt(loc_handle, akVibDevice.UD_VibStrength)       ;Base vib strength
        ModEvent.PushInt(loc_handle, akVibDevice.CurrentVibStrength)   ;Current vib strength (might change over time!)
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction

;/  About: UDEvent_VibDeviceEffectUpdate
    Event UDEvent_VibDeviceEffectUpdate is sent after UD vibrator device strength is changed
    --- Code
    ; Prototype
    Event UDEvent_VibDeviceEffectUpdate(String asSource, Form akFActor, Form akFID, Form akFRD, Int aiEroZones, Int aiBaseStrength, Int aiCurrentStrength, Bool abIsPaused)
        ;Actor on which was vibrator updated
        Actor akActor   = akFActor as Actor
        
        ;Inventory device of locked device
        Armor akID      = akFID as Armor
        
        ;Render device of locked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---

    See: <EroZone>
/;
Bool Function SendEvent_VibDeviceEffectUpdate(UD_CustomVibratorBase_RenderScript akVibDevice) global
    Int loc_handle = ModEvent.Create("UDEvent_VibDeviceEffectUpdate")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                ;Event Source
        ModEvent.PushForm(loc_handle, akVibDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akVibDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akVibDevice.DeviceRendered)      ;RD
        ModEvent.PushInt(loc_handle, akVibDevice.UD_EroZones)          ;Ero zones
        ModEvent.PushInt(loc_handle, akVibDevice.UD_VibStrength)       ;Base vib strength
        ModEvent.PushInt(loc_handle, akVibDevice.CurrentVibStrength)   ;Current vib strength (might change over time!)
        ModEvent.PushBool(loc_handle, akVibDevice.isVibPaused())       ;If vib is currently paused
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction

;/  About: UDEvent_VibDeviceEffectEnd
    Event UDEvent_VibDeviceEffectEnd is sent after UD vibrator device stops vibrating
    --- Code
    ; Prototype
    Event UDEvent_VibDeviceEffectEnd(String asSource, Form akFActor, Form akFID, Form akFRD, Int aiEroZones, Int aiBaseStrength)
        ;Actor on which was vibrator turned off
        Actor akActor   = akFActor as Actor
        
        ;Inventory device of locked device
        Armor akID      = akFID as Armor
        
        ;Render device of locked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---

    See: <EroZone>
/;
Bool Function SendEvent_VibDeviceEffectEnd(UD_CustomVibratorBase_RenderScript akVibDevice) global
    Int loc_handle = ModEvent.Create("UDEvent_VibDeviceEffectEnd")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                   ;Event Source
        ModEvent.PushForm(loc_handle, akVibDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akVibDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akVibDevice.DeviceRendered)      ;RD
        ModEvent.PushInt(loc_handle, akVibDevice.UD_EroZones)          ;Ero zones
        ModEvent.PushInt(loc_handle, akVibDevice.UD_VibStrength)       ;Base vib strength
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction

;/  About: UDEvent_InflatablePlugInflate
    Event UDEvent_InflatablePlugInflate is sent after UD inflatable plug is inflated
    --- Code
    ; Prototype
    Event UDEvent_InflatablePlugInflate(String asSource, Form akFActor, Form akFID, Form akFRD, Int aiEroZones, Int aiNewLevel)
        ;Actor on which was vibrator turned off
        Actor akActor   = akFActor as Actor
        
        ;Inventory device of locked device
        Armor akID      = akFID as Armor
        
        ;Render device of locked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---

    See: <EroZone>
/;
Bool Function SendEvent_InflatablePlugInflate(UD_CustomInflatablePlug_RenderScript akInfDevice) global
    Int loc_handle = ModEvent.Create("UDEvent_InflatablePlugInflate")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                   ;Event Source
        ModEvent.PushForm(loc_handle, akInfDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akInfDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akInfDevice.DeviceRendered)      ;RD
        ModEvent.PushInt(loc_handle, akInfDevice.UD_EroZones)          ;Ero zones
        ModEvent.PushInt(loc_handle, akInfDevice.getPlugInflateLevel());New level
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction

;/  About: UDEvent_InflatablePlugDeflate
    Event UDEvent_InflatablePlugDeflate is sent after UD inflatable plug is deflated
    --- Code
    ; Prototype
    Event UDEvent_InflatablePlugDeflate(String asSource, Form akFActor, Form akFID, Form akFRD, Int aiEroZones, Int aiNewLevel)
        ;Actor on which was vibrator turned off
        Actor akActor   = akFActor as Actor
        
        ;Inventory device of locked device
        Armor akID      = akFID as Armor
        
        ;Render device of locked device
        Armor akRD      = akFRD as Armor
    EndEvent
    ---

    See: <EroZone>
/;
Bool Function SendEvent_InflatablePlugDeflate(UD_CustomInflatablePlug_RenderScript akInfDevice) global
    Int loc_handle = ModEvent.Create("UDEvent_InflatablePlugDeflate")
    if loc_handle
        ModEvent.PushString(loc_handle, "UD_Events")                   ;Event Source
        ModEvent.PushForm(loc_handle, akInfDevice.GetWearer())         ;Wearer
        ModEvent.PushForm(loc_handle, akInfDevice.DeviceInventory)     ;ID
        ModEvent.PushForm(loc_handle, akInfDevice.DeviceRendered)      ;RD
        ModEvent.PushInt(loc_handle, akInfDevice.UD_EroZones)          ;Ero zones
        ModEvent.PushInt(loc_handle, akInfDevice.getPlugInflateLevel());New level
        ModEvent.Send(loc_handle)
        return true
    endif
    return false
EndFunction