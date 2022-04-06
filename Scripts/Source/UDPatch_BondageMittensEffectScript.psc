Scriptname UDPatch_BondageMittensEffectScript extends zadx_BondageMittensEffectScript 

bool Function isDeviousDevice(Form device)
	return parent.isDeviousDevice(device) || device.haskeyword(libs.zad_deviousPlug) ;allow plugs to be equipped/locked
EndFunction