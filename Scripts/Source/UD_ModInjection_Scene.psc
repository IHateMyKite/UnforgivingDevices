Scriptname UD_ModInjection_Scene extends Scene Hidden
; This script is used in conjunction with the UD_ModOutcome_Scene modifier Outcome.
; If you want certain code to be executed when a scene is called from the modifier, use the script inherited from this one.

; Overrides

Function Start()
    _Prepare()
    Parent.Start()
EndFunction

Function ForceStart()
    _Prepare()
    Parent.ForceStart()
EndFunction

Function _Prepare()
EndFunction