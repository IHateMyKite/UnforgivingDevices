scriptName zadEventSlots extends Quest

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadLibs Property libs Auto

String[] Property Registry Auto
zadBaseEvent[] Property Slots Auto

Int Property Slotted Auto
Int Property ProcessNum = 0 Auto

Int Function Register(string Name, zadBaseEvent TheEvent)
EndFunction

zadBaseEvent Function GetByName(string Name)
EndFunction

Function Initialize()
EndFunction

Function Reset()
EndFunction

Function LoadDefaults()
EndFunction

Function UpdateProcessNum()
EndFunction

Function CheckAllEvents()
EndFunction

Bool Function ProcessOneEvent(actor akActor)
EndFunction

function DoRegister()
EndFunction

bool Function ProcessEvents(actor akActor)
EndFunction

Event OnUpdateGameTime()
EndEvent

Function UpdateGlobalEvent()
EndFunction

Function Maintenance()
EndFunction
