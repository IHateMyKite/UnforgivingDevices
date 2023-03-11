Scriptname slaConfigScr extends SKI_ConfigBase  
; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

Keyword Property kArmorCuirass Auto
Keyword Property kClothingBody Auto

Int[] Property slaSlotMaskValues Auto hidden
Actor Property slaPuppetActor Auto

Actor Property slaNakedActor Auto hidden
Actor Property slaMostArousedActorInLocation Auto hidden
Int Property slaArousalOfMostArousedActorInLoc Auto

; config settings
Bool Property IsCloakEffect Auto
Bool Property IsDesireSpell Auto
Bool Property IsUseSOS Auto
Bool Property IsExtendedNPCNaked Auto
Bool Property wantsPurging = false Auto Hidden
Float Property TimeRateHalfLife Auto hidden
Int Property SexOveruseEffect = 5 Auto hidden
Float Property DefaultExposureRate = 2.0 Auto hidden
Int Property NotificationKey = 49 Auto hidden
Float Property cellScanFreq = 120.00 Auto hidden
bool Property maleAnimation = false Auto hidden
bool Property femaleAnimation = false Auto hidden
bool Property useLOS = false Auto hidden
Bool Property IsNakedOnly = true Auto Hidden
Bool Property bDisabled = false Auto Hidden

Int Function GetVersion()
EndFunction

;slaMainScr slaMain 

Event OnVersionUpdate(int a_version)
EndEvent

event OnGameReload()
endEvent


Function ResetToDefault()
EndFunction


Event OnPageReset(string page)
EndEvent


Function DisplayActorStatus(Actor akRef)
EndFunction


Function DisplayPuppetMaster(Actor akRef)
EndFunction


Function DisplayListOfWornItems(Actor akRef)
EndFunction


Event OnOptionMenuOpen(int option)
EndEvent


Event OnOptionMenuAccept(int option, int index)
EndEvent


Event OnOptionSelect(int option)
EndEvent


Event OnOptionSliderOpen(int option)		
EndEvent


Event OnOptionSliderAccept(int option, float value)		
EndEvent


event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
endEvent


Event OnOptionHighlight(int option)
EndEvent


Event OnOptionDefault(int option)
EndEvent


Event OnConfigClose()
EndEvent


Form[] Function RemoveForm(Form item, Form[] itemList)
EndFunction


Function InitSlotMaskValues()
EndFunction


Form[] Function GetEquippedArmors(Actor akRef)
EndFunction