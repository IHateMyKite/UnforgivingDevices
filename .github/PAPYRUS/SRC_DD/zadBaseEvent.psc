scriptName zadBaseEvent extends ReferenceAlias

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadLibs Property libs Auto
bool Property Process = False Auto Hidden
Int Property Probability = -1 Auto Hidden
String Property Name Auto
String Property Help = "" Auto 
Int Property DefaultProbability Auto 

Bool Function Filter(actor akActor, int chanceMod = 0)
EndFunction
bool Function HasKeywords(actor akActor)
EndFunction
Function Execute(actor akActor)
EndFunction
Function Eval(actor akActor)
EndFunction
Event OnPlayerLoadGame()
EndEvent
Event OnRegisterEvents(string eventName, string strArg, float numArg, Form sender)
EndEvent
Function RegisterDeviceEffect()
EndFunction

