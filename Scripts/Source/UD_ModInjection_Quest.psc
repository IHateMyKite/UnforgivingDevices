Scriptname UD_ModInjection_Quest extends Quest Hidden
; This script is used in conjunction with the UD_ModOutcome_Quest modifier Outcome.
; If you want certain code to be executed when a quest is called from the modifier, use the script inherited from this one.

; Overrides

Bool Function Start()
    _Prepare()
    Return Parent.Start()
EndFunction

Function _Prepare()
EndFunction