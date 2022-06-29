Scriptname UD_LeveledList_Patcher extends Quest 

UD_libs Property UDlibs auto
UnforgivingDevicesMain Property UDmain auto
bool Property Ready = false auto

;Lists to add
LeveledItem Property UD_LIL_AncientSeed auto
LeveledItem Property UD_LIL_BlackGoo auto
LeveledItem Property UD_LIL_DragonNuts auto
LeveledItem Property UD_LIL_Jewelry auto
LeveledItem Property UD_LIL_EnchCirclet auto

;LISTS to patch
LeveledItem Property UD_LIL_DraugrNormal auto
LeveledItem Property UD_LIL_Wolf auto
LeveledItem Property UD_LIL_Dragon auto
LeveledItem Property UD_LIL_MerchantEnchJewel auto

LeveledItem Property LIL_AllEnchCirclet auto

Event OnInit()
	Utility.wait(Utility.randomFloat(1.0,3.0))
	Process()
	Ready = true
EndEvent

Function Process()
	;UD_LIL_DraugrNormal
	UD_LIL_DraugrNormal.addForm(UD_LIL_AncientSeed, 1, 1)
	
	;UD_LIL_Wolf
	UD_LIL_Wolf.addForm(UD_LIL_BlackGoo,1,1)
	
	;UD_LIL_Dragon
	UD_LIL_Dragon.addForm(UD_LIL_DragonNuts,1,1)
	
	;UD_LIL_MerchantEnchJewel.addForm(UD_LIL_Jewelry,1,1)
	LIL_AllEnchCirclet.AddForm(UD_LIL_EnchCirclet,1,1)
EndFunction