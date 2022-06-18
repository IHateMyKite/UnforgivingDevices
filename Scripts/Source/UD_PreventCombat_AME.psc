Scriptname UD_PreventCombat_AME extends ActiveMagicEffect  

UDCustomDeviceMain Property UDCDmain auto

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
	;UDCDmain.CLog("UD_PreventCombat_AME OnEffectStart("+UDCDmain.GetActorName(_target)+")")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;UDCDmain.CLog("UD_PreventCombat_AME OnEffectFinish("+UDCDmain.GetActorName(_target)+")")
	;reset prevent combat
	;actor will be calmed untill their hands are free
	if _target.wornhaskeyword(libsp.zad_deviousheavybondage)
		_target.removespell(UDlibs.PreventCombatSpell)
		_target.addspell(UDlibs.PreventCombatSpell)
	endif
EndEvent