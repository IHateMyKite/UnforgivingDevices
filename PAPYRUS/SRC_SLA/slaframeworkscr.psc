Scriptname slaFrameworkScr extends Quest

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

Actor Property PlayerRef Auto

slaConfigScr Property slaConfig Auto

FormList Property slaArousedVoiceList Auto
FormList Property slaUnArousedVoiceList Auto

Faction Property slaArousal Auto
Faction Property slaArousalBlocked Auto
Faction Property slaArousalLocked Auto
Faction Property slaExposure Auto
Faction Property slaExhibitionist Auto
Faction Property slaGenderPreference Auto
Faction Property slaTimeRate Auto
Faction Property slaExposureRate Auto

GlobalVariable Property sla_NextMaintenance  Auto  

Int Property slaArousalCap = 100 AutoReadOnly

Int Function GetVersion()
EndFunction
Int Function GetGenderPreference(Actor akRef, Bool forConfig = False)
EndFunction
Function SetGenderPreference(Actor akRef, Int gender)
EndFunction
bool Function IsActorExhibitionist(Actor akRef)
EndFunction
Function SetActorExhibitionist(Actor akRef, bool val = false)
EndFunction
Float Function GetActorTimeRate(Actor akRef)
EndFunction
Float Function SetActorTimeRate(Actor akRef, Float val)
EndFunction
Float Function UpdateActorTimeRate(Actor akRef, Float val)
EndFunction
Float Function GetActorExposureRate(Actor akRef)
EndFunction
Float Function SetActorExposureRate(Actor akRef, Float val)
EndFunction
Float Function UpdateActorExposureRate(Actor akRef, Float val)
EndFunction
Int Function GetActorExposure(Actor akRef)
EndFunction
Int Function SetActorExposure(Actor akRef, Int val)
EndFunction
Int Function UpdateActorExposure(Actor akRef, Int val, String debugMsg = "")
EndFunction
Float Function GetActorDaysSinceLastOrgasm(Actor akRef)
EndFunction
Function UpdateActorOrgasmDate(Actor akRef)
EndFunction
bool Function IsActorArousalLocked(Actor akRef)
EndFunction
Function SetActorArousalLocked(Actor akRef, bool val)
EndFunction
bool Function IsActorArousalBlocked(Actor akRef)
EndFunction
Function SetActorArousalBlocked(Actor akRef, bool val)
EndFunction
int Function GetActorArousal(Actor akRef)
EndFunction
Actor Function GetMostArousedActorInLocation()
EndFunction
Function UpdateSOSPosition(Actor akRef, int akArousal)
EndFunction
Function HandleErection(Actor akRef, int position)
EndFunction
Int Function GetActorHoursSinceLastSex(Actor akRef)
EndFunction
Float Function GetActorDaysSinceLastSex(Actor akRef)
EndFunction
