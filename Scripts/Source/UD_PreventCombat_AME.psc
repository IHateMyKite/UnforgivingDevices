Scriptname UD_PreventCombat_AME extends ActiveMagicEffect  

UDCustomDeviceMain Property UDCDmain auto

Int _aggression = 0
bool _finished = false
zadlibs_UDpatch Property libsp
	zadlibs_UDpatch Function get()
		return UDCDmain.libsp
	EndFunction
EndProperty

UD_Libs Property UDlibs
	UD_Libs Function get()
		return UDCDmain.UDlibs
	EndFunction
EndProperty

Actor _target = none
Event OnEffectStart(Actor akTarget, Actor akCaster)
	_target = akTarget
	;_aggression = StorageUtil.GetIntValue(GetWearer(),"UD_Aggression",0)
	Evaluate()
	registerforsingleupdate(5.0)
EndEvent

Event OnUpdate()
	if !_finished
		Evaluate()
		registerforsingleupdate(5.0)
	endif
EndEvent

Function Evaluate()
	;_target.setAV("aggression",0)
	_target.stopCombat()
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;reset prevent combat
	;actor will be calmed untill their hands are free
	_finished = true
	;_target.setAV("aggression",_aggression)
	if _target.wornhaskeyword(libsp.zad_deviousheavybondage)
		_target.removespell(UDlibs.PreventCombatSpell)
		_target.addspell(UDlibs.PreventCombatSpell)
	else
		
	endif
EndEvent