Scriptname UD_LockpickRemoval_Effect extends zadArmbinderNoLockpicks  

UD_libs Property UDlibs auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget.hasspell(UDlibs.TelekinesisSpell)
		return
	else
		parent.OnEffectStart(akTarget, akCaster)
		RegisterForSingleUpdate(3.0)
	endif
EndEvent


Event OnUpdate()	
	if !Target.hasspell(UDlibs.TelekinesisSpell)
		RegisterForSingleUpdate(3.0)
	else
		dispel()
	endif
EndEvent

