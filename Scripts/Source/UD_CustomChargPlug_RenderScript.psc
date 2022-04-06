Scriptname UD_CustomChargPlug_RenderScript extends UD_CustomPlug_RenderScript  

string Function addInfoString(string str = "")
	;string res = str
	str += "Charge level: " + getChargeLevel() + " %\n"
	return parent.addInfoString(str)
EndFunction

int Function getChargeLevel()
	return StorageUtil.GetIntValue(getWearer(), "zad.SoulgemChargeValue") 
EndFunction

Function InitPost()
	StorageUtil.SetIntValue(getWearer(), "zad.SoulgemChargeValue", 0)
	UD_DeviceType = "Chargable Plug"
	parent.InitPost()
EndFunction

Function removeDevice(actor akActor)
	int CurrentCharge = StorageUtil.GetIntValue(getWearer(), "zad.SoulgemChargeValue") 
	If CurrentCharge >= 100 ; Fully charged.
		; Break down plug.
		libs.NotifyPlayer("After removing the plug from your trembling groin, the stand easily detaches.") 
		getWearer().RemoveItem(DeviceInventory)
		getWearer().AddItem(libs.SoulgemFilled)
		getWearer().AddItem(libs.SoulgemStand)
	Else
		libs.NotifyPlayer("Though the plug glows upon removal, the light quickly fades from it.")
	EndIf
	StorageUtil.UnsetIntValue(getWearer(), "zad.SoulgemChargeValue")
	parent.removeDevice(akActor)
EndFunction
