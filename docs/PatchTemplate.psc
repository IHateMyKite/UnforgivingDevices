Scriptname ;/UNIQUE NAME OF THE PATCH SCRIPT/; extends UD_PatchInit

import UnforgivingDevicesMain

Armor _DeviceExample
Armor Property DeviceExample
    ;use GetMeMyForm so we don't have to edit esp
    Armor Function Get()
        if !_DeviceExample
            _DeviceExample = GetMeMyForm(;/FORM ID OF OUR DEVICE/;, "MyPatch.esp") as Armor
        endif
        return _DeviceExample
    EndFunction
    ;or use esp to set the device
    Function Set(Armor akArmor)
        _DeviceExample = akArmor
    EndFunction
EndProperty

;called when one of the suits was choosen to be locked on
Function EquipSuit(Actor akActor,String asEventName)
    ;wait for menu to close before we lock the devices
    Utility.wait(0.01)
    
    ;disable actor, so they cant move while devices are locked on
    UDmain.UDCDmain.DisableActor(akActor)
    
    if asEventName == "UD_NameOfMyCustomEvent"
        libs.lockdevice(akActor,DeviceExample)
    elseif ;/etc.../;
    endif
    
    ;enable actor
    UDmain.UDCDmain.EnableActor(akActor)
EndFunction