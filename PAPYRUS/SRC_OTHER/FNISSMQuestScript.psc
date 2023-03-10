Scriptname FNISSMQuestScript extends Quest Conditional 

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

int Property FNISsmModID Auto
int Property FNISsmMtBase Auto
int Property FNISsmMtxBase Auto
int Property FNISs3ModID Auto
int Property FNISs3MtBase Auto
int Property FNISs3MtxBase Auto
int Property FNISaaCRC Auto
Quest Property FNISSMQuest2 Auto
Quest Property MQ101 Auto
Bool[] Property SMno Auto
Int Property SMnoTotal Auto
Int Property iSMweight = 1 Auto
Bool Property SMarmor Auto
Bool Property isConfigChangedNPC Auto
Int Property iSMplayer = 5 Auto
Bool Property SMdialog Auto Conditional
Bool Property SMoff Auto
Bool Property SMnocoin Auto
Bool Property SM360 Auto
Int Property StartUpStatus Auto Conditional
bool Property isCellLoaded Auto	
int Property AliasCount Auto
int Property DebugLevel = 0 Auto

Event OnInit()
EndEvent
Event OnUpdate()
endEvent 
int Function getAnimIndex(int[] percentAr)
endFunction
int Function getRandomAnimation(Actor akFemale)
endFunction
Function initializeNPC()
endFunction
bool Function RequirementsAreMet()
endFunction
