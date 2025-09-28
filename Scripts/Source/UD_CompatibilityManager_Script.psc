Scriptname UD_CompatibilityManager_Script extends Quest Hidden

import UnforgivingDevicesMain

;============================================================
;========================PROPERTIES==========================
;============================================================

UnforgivingDevicesMain  Property UDmain                 auto

UDCustomDeviceMain      Property UDCDmain                       hidden
    UDCustomDeviceMain Function get()
        return UDmain.UDCDmain
    EndFunction
EndProperty

bool                    Property Ready      = false     auto    hidden

;============================================================
;======================LOCAL VARIABLES=======================
;============================================================

;============================================================
;========================FUNCTIONS===========================
;============================================================

Event OnInit()
    if IsRunning()
        RegisterForSingleUpdate(45.0)
        Ready = true
    endif
EndEvent

Event OnUpdate()
EndEvent
Function Update()
EndFunction
