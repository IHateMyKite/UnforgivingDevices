ScriptName zadArmbinderNoLockpicks extends ActiveMagicEffect

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadLibs Property Libs Auto
actor Property Target Auto
ObjectReference Property TheSafe Auto
MiscObject Property Lockpick Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
EndEvent