Scriptname zadGagScript extends zadEquipScript

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

Message Property callForHelpMsg Auto
Message Property zad_GagPreEquipMsg Auto
Message Property zad_GagEquipMsg Auto
Message Property zad_GagRemovedMsg Auto
Message Property zad_GagPickLockFailMsg Auto
Message Property zad_GagPickLockSuccessMsg Auto
Message Property zad_GagArmsTiedMsg Auto
Message Property zad_GagBruteForceArmsTiedMsg Auto
Message Property zad_GagBruteForceMsg Auto

Function OnEquippedPre(actor akActor, bool silent=false)
EndFunction

Function DeviceMenuExt(int msgChoice)
EndFunction

Function OnRemoveDevice(actor akActor)
EndFunction

Function OnEquippedPost(actor akActor)
EndFunction
