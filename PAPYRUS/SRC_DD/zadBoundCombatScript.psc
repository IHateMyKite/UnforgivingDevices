Scriptname zadBoundCombatScript Extends Quest Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadLibs Property libs Auto
zadConfig Property config Auto
Package Property NPCBoundCombatPackage Auto
Package Property NPCBoundCombatPackageSandbox Auto
Spell Property ArmbinderDebuff Auto
FormList Property zad_List_BCPerks Auto
int Property ABC_ModID Auto
int Property ABC_CRC Auto
int Property ABC_h2heqp Auto
int Property ABC_h2hidle Auto
int Property ABC_h2hatkpow Auto
int Property ABC_h2hatk Auto
int Property ABC_h2hstag Auto
int Property ABC_jump Auto
int Property ABC_sneakmt Auto
int Property ABC_sneakidle Auto
int Property ABC_sprint Auto
int Property ABC_shout Auto
int Property ABC_mtx Auto
int Property ABC_mt Auto
int Property ABC_mtturn Auto
int Property ABC_mtidle Auto
int Property HBC_ModID Auto
int Property HBC_CRC Auto
int Property HBC_h2heqp Auto
int Property HBC_h2hidle Auto
int Property HBC_h2hatkpow Auto
int Property HBC_h2hatk Auto
int Property HBC_h2hstag Auto
int Property HBC_jump Auto
int Property HBC_sneakmt Auto
int Property HBC_sneakidle Auto
int Property HBC_sprint Auto
int Property HBC_shout Auto
int Property HBC_mtx Auto
int Property HBC_mt Auto
int Property HBC_mtturn Auto
int Property HBC_mtidle Auto
int Property PON_ModID Auto
int Property PON_CRC Auto
int Property PON_h2heqp Auto
int Property PON_h2hidle Auto
int Property PON_h2hatkpow Auto
int Property PON_h2hatk Auto
int Property PON_h2hstag Auto
int Property PON_jump Auto
int Property PON_sneakmt Auto
int Property PON_sneakidle Auto
int Property PON_sprint Auto
int Property PON_shout Auto
int Property PON_mtx Auto
int Property PON_mt Auto
int Property PON_mtturn Auto
int Property PON_mtidle Auto

Function UpdateValues()
EndFunction
Function CONFIG_ABC()
EndFunction
Function Maintenance_ABC()
EndFunction
bool Function HasCompatibleDevice(actor akActor)
EndFunction
Int Function GetPrimaryAAState(actor akActor)
EndFunction
Int Function GetSecondaryAAState(actor akActor)
EndFunction
Int Function SelectAnimationSet(actor akActor)
EndFunction
Function EvaluateAA(actor akActor)
EndFunction
Function ClearAA(actor akActor)
EndFunction
Function ResetExternalAA(actor akActor)
EndFunction
Function ApplyBCPerks(Actor akActor)
EndFunction
Function RemoveBCPerks(Actor akActor)
EndFunction
Function Apply_NPC_ABC(actor akActor)
EndFunction
Function Remove_NPC_ABC(actor akActor)
EndFunction
Function CleanupNPCs()
EndFunction
Function Apply_ABC(actor akActor)
EndFunction
Function Remove_ABC(actor akActor)
EndFunction
Function Apply_HBC(actor akActor)
EndFunction
Function Remove_HBC(actor akActor)
EndFunction