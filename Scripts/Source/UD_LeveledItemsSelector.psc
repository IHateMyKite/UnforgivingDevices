Scriptname UD_LeveledItemsSelector extends Quest

import PO3_SKSEFunctions

;################# COLOR
int black = 0
int red = 1
int white = 2
int darkred = 3
int lightgrey = 4
int metalnorm = 0
int metalsilver = 1
int metalgold = 2
int metalHRiron = 0
int metalHRrusty = 1
int nocolor = 4

;################# STYLE
int regular = 0
int restrictive = 1
int metal = 2
int latex = 3
int rope = 4

;################# MATERIAL
int leather = 0
int ebonite = 1
int metalUniversal = 0
int metalHR = 1

LeveledItem Property ud_alldevices Auto
FormList Property ud_KeywordsFormlist Auto
int devicekeywords = 0
UD_RandomRestraintManager Property UDRRM auto
UDCustomDeviceMain Property UDCDM auto
zadlibs Property libs auto

int ItemSelector = 68

string[] Options
string[] Style
string[] Material
string[] Color
string[] MaterialMetal
string[] ColorRope

Event OnInit()
	Utility.Wait(5)
	if (GetPapyrusExtenderVersion())[0] < 5
		UDCDM.ShowMessageBox("ERROR: Powerofthree extender is not installed or outdated, advanced item selector is disabled!")
		return
	endif
	RegisterForKey(ItemSelector)
	devicekeywords = ud_KeywordsFormlist.GetSize()

	Options = new String[3]
	Options[0] = "Equip single type-specific device..."
	Options[1] = "Equip multiple type-specific devices..."
	Options[2] = "Suggest and equip a device..."

	Style = new String[5]
	Style[0] = "Regular"
	Style[1] = "Restrictive"
	Style[2] = "Metal"
	Style[3] = "Latex"
	Style[4] = "Rope"

	Material = new String[2]
	Material[0] = "Leather"
	Material[1] = "Ebonite"
	
	MaterialMetal = new String[2]
	MaterialMetal[0] = "Universal"
	MaterialMetal[1] = "Heretical"

	Color = new String[5]
	Color[0] = "Black"
	Color[1] = "Red"
	Color[2] = "White"
	Color[3] = "Dark Red"
	Color[4] = "Light Grey"

	ColorRope = new String[4]
	ColorRope[0] = "Black"
	ColorRope[1] = "Red"
	ColorRope[2] = "White"
	ColorRope[3] = "No Color"
endEvent

Event OnKeyDown(Int KeyCode)
	if KeyCode == ItemSelector
		ItemSelectorMenu()
	endif
endEvent

int function selectrandomstyle() ;TODO
	return Utility.RandomInt(0,4)
endfunction

int function selectrandomColor(int rstyle) ;TODO
	if rstyle == regular
		return Utility.RandomInt(0,2) ;black red white
	elseif rstyle == restrictive
		return Utility.RandomInt(0,2) ;black red white
	elseif rstyle == metal
		return 0						;none
	elseif rstyle == latex
		return Utility.RandomInt(0,4) ;black red white dred lgrey
	elseif rstyle == rope
		return Utility.RandomInt(0,3) + 1 ;noColor black red white
	endif
endfunction

int function selectrandommaterial(int rstyle) ;TODO
	if rstyle == regular
		return Utility.RandomInt(0,1) 
	elseif rstyle == restrictive
		return Utility.RandomInt(0,1)
	elseif rstyle == metal
		return -1
	elseif rstyle == latex
		return -1
	elseif rstyle == rope
		return -1
	endif
endfunction

function equiprandomrestraint(Actor akActor) ;TODO
	int rstyle = 0; selectrandomstyle()
	int rmaterial = 0; selectrandommaterial()
	int rcolor = 0; selectrandomColor(rstyle)
	LeveledItem LL = ud_alldevices.GetNthForm(rstyle) as LeveledItem
	int mat = selectrandommaterial(rstyle)
	if mat >= 0 ;check only those leveled lists which actually have material defined
		LL = LL.GetNthForm(rmaterial) as LeveledItem
	endif
	LL = LL.GetNthForm(rcolor) as LeveledItem ;metal does not really have a color but a subject for a change, i.e. iron/rusty or steel/silver/gold
	int n = LL.GetNumForms()
	Form frm
	while n > 0
		n -= 1
		frm = LL.GetNthForm(n)
		If (frm As Armor) != None ;sanity check
			if IsKeywordedDevice(frm, libs.zad_DeviousArmbinder)
				libs.LockDevice(akActor, frm As Armor)
			endif
		endif
	endwhile
endfunction

Armor Function GetRandomDevice(Actor akActor, int rstyle, int rcolor)
	; UDRRM.getRandomSuitableKeyword(akActor) not suitable because it doesn't check more specific devices, redo
	; return (ud_alldevices.GetNthForm(rstyle) as LeveledItem).GetNthForm(rcolor) as armor = doesn't care about currently equipped devices
EndFunction

; optional string is used as exception/inclusion rule, for example elbowhook -exclude "collar"
; explicitly pass straitjacket as inclusion to dresses and catsuits, else - will return simple device
; explicitly pass belt as inclusion to corset and vice versa, else - will return simple device
; explicitly pass BBYoke (breastbound yoke) as inclusion, else it will fail
; allowvariations allows use of all devices limited by inclusion without specifying that inclusion, i.e. catsuit straitjacket may be returned
bool Function IsKeywordedDevice(Form kForm, Keyword kwKeyword, bool allowvariations = false, string include = "*", string exclude = "*")
	if kwKeyword == libs.zad_DeviousArmbinder
		if tsearch(kForm, "armbinder") || tsearch(kForm, "shackles_steel") ;2nd is exact exclusion, act as armbinder.
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousArmbinderElbow
		if tsearch(kForm, "elbowbinder")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousElbowTie
		if tsearch(kForm, "elbowshackles")
			if (!allowvariations && !tsearch(kForm, include)) || tsearch(kForm, exclude)
				return false
			Else
				return true
			endif
		endif
	elseif kwKeyword == libs.zad_DeviousHobbleSkirt
		if tsearch(kForm, "dress")
			if !allowvariations && (tsearch(kForm, "straitjacket") && !tsearch(kForm, include)) ;explicitly pass straitjacket as inclusion, else - will return simple device
				return false
			Else
				return true
			endif
		endif
	elseif kwKeyword == libs.zad_DeviousCorset
		if tsearch(kForm, "corset")
			if !allowvariations && (tsearch(kForm, "belt") && !tsearch(kForm, include)) ;explicitly pass belt as inclusion, else - will return simple device
				return false
			Else
				return true
			endif
		endif
	elseif kwKeyword == libs.zad_DeviousArmCuffs
		if (tsearch(kForm, "cuff") || tsearch(kForm, "HR")) && tsearch(kForm, "arm")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousLegCuffs
		if (tsearch(kForm, "cuff") || tsearch(kForm, "HR")) && tsearch(kForm, "legs")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousGag
		if (tsearch(kForm, "gag") && !tsearch(kForm, "mask")) || tsearch(kForm, "bridle")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousBoots
		if tsearch(kForm, "boots") || tsearch(kForm, "heels")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousBlindfold
		if tsearch(kForm, "blindfold")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousBra
		if tsearch(kForm, "bra")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousBelt
		if tsearch(kForm, "belt")
			if !allowvariations && (tsearch(kForm, "corset") && !tsearch(kForm, include)) ;explicitly pass corset as inclusion, else - will return simple device
				return false
			Else
				return true
			endif
		endif
		if tsearch(kForm, "rope") && (tsearch(kForm, "crotch") || tsearch(kForm, "corsetExp"))
			if !allowvariations && ((tsearch(kForm, "crotch") || tsearch(kForm, "corsetExp")) && !tsearch(kForm, include)) ;explicitly pass corset as inclusion, else - will return simple device
				return false
			Else
				return true
			endif
		endif
	elseif kwKeyword == libs.zad_DeviousCollar
		if tsearch(kForm, "collar") && !tsearch(kForm, "elbow")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousSuit ;catsuit
		if tsearch(kForm, "catsuit") && !tsearch(kForm, "glove") && !tsearch(kForm, "boot") && !tsearch(kForm, "mask") && !tsearch(kForm, "collar")
			if !allowvariations && (tsearch(kForm, "straitjacket") && !tsearch(kForm, include)) ;explicitly pass straitjacket as inclusion, else - will return simple device
				return false
			Else
				return true
			endif
		endif

	elseif kwKeyword == libs.zad_DeviousPlugAnal
		if (tsearch(kForm, "plug") || tsearch(kForm, "pear")) && (tsearch(kForm, "aninventory") || tsearch(kForm, "anal") || tsearch(kForm, "ponytail"))
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousPlugVaginal
		if (tsearch(kForm, "plug") || tsearch(kForm, "pear"))
			if tsearch(kForm, "vag")
				return true
			elseif !tsearch(kForm, "ponytail") && tsearch(kForm, "set") ;happens in case Anal and legit vaginal check has failed, treat the rest of plugs os vaginal
				UDCDM.Log("VagPlug exclusion triggered: "+kForm.getname(),3)
				return true
			endif
			return false
		endif
	elseif kwKeyword == libs.zad_DeviousPiercingsVaginal
		if tsearch(kForm, "piercingV")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousPiercingsNipple
		if  tsearch(kForm, "piercingN") || (tsearch(kForm, "piercing") && tsearch(kForm, "nipple")) || (tsearch(kForm, "clamps") && tsearch(kForm, "nipple"))
			return true
		endif
		if  tsearch(kForm, "HR") && tsearch(kForm, "Nipple")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousGloves
		if tsearch(kForm, "gloves")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousHood
		if tsearch(kForm, "hood") || tsearch(kForm, "mask")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousStraitJacket
		if tsearch(kForm, "StraitJacket")
			if !allowvariations && ((tsearch(kForm, "catsuit") || tsearch(kForm, "dress")) && !tsearch(kForm, include)) ;explicitly pass corset as inclusion, else - will return simple device
				return false
			Else
				return true
			endif
		endif
	elseif kwKeyword == libs.zad_DeviousBondageMittens
		if tsearch(kForm, "mittens")
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousYoke
		if tsearch(kForm, "yoke")
			if !allowvariations && (tsearch(kForm, "BBYoke") && !tsearch(kForm, include)) ;explicitly pass straitjacket as inclusion, else - will return simple device
				return false
			Else
				return true
			endif
		endif
	elseif kwKeyword == libs.zad_DeviousHarness
		if tsearch(kForm, "harness") && !tsearch(kForm, "collar") && !tsearch(kForm, "gag")
			if !allowvariations && ((tsearch(kForm, "crotch") || tsearch(kForm, "corsetExp")) && !tsearch(kForm, include)) ;explicitly pass corset as inclusion, else - will return simple device
				return false
			Else
				return true
			endif
		endif
	elseif kwKeyword == libs.zad_DeviousAnkleShackles
		if tsearch(kForm, "ballchain") || (tsearch(kForm, "shackles") && !tsearch(kForm, "wrist") && !tsearch(kForm, "elbow"))
			return true
		endif
	elseif kwKeyword == libs.zad_DeviousCuffsFront
		if tsearch(kForm, "shackles") && tsearch(kForm, "wrist")
			return true
		endif
		if tsearch(kForm, "cuffs") && tsearch(kForm, "front")
			return true
		endif
		if (tsearch(kForm, "PrisonerChains") && (tsearch(kForm, include) || allowvariations)) ;explicitly pass PrisonerChains as inclusion, else - will return simple device
			return true
		endif
	; elseif kwKeyword == libs.zad_DeviousPetsuit - wont support, way too shitty to deal with for any mod
	endif
	return false
endfunction

;always pass a str parameter with the function
bool function tsearch(Form kForm, string str = "")
	if StringUtil.Find(GetFormEditorID(kForm), str, 0) > 0
		return true
	endif
	return false
endfunction

;return device keyword by index from formlist
keyword Function GetKeywordByIndex(int index)
	return ud_KeywordsFormlist.GetAt(index) as keyword
endfunction

;returns random device from specific Leveled List by keyword
armor Function PickRandomDeviceFromLL(LeveledItem sLL, keyword kwd)
	form[] frmarr = new Form[10]
	int n = sLL.GetNumForms()
	int k = 0 ;counter, bypass lack of native dynamic array implementation
	int i = 0
	while i < n
		form frm = sLL.GetNthForm(i)
		if IsKeywordedDevice(frm, kwd, true) ;allowed variations for testing, change
			frmarr[k] = frm
			k += 1
			UDCDM.log("Device is valid: "+GetFormEditorID(frm),3)
		endif
		i += 1
	endwhile
	k -= 1
	if k < 0
		UDCDM.Print("No device can be found in selected list by this keyword.")
		return none
	endif
	armor temp = frmarr[(Utility.RandomInt(0, k))] as armor
	UDCDM.Print("Keyword recieved: "+GetFormEditorID(kwd))
	UDCDM.Print("Device returned: "+GetFormEditorID(temp))
	return frmarr[(Utility.RandomInt(0, k))] as armor
endfunction

;################ Selector Menu Functions ############### 

Function ItemSelectorMenu()
	UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	
	if listMenu
		int n = Options.Length 	;Number of entries for the main list
		int i = 0 					;index to browse the main list
		Int currentEntry = -1
		while i < n
			currentEntry = listMenu.AddEntryItem(Options[i]) 	;add an entry, and remember its list index
			i += 1
		endwhile
	endif
	listMenu.OpenMenu()
	String Selected = ListMenu.GetResultString()

	If (Selected != "")
		If (Selected == "Equip single type-specific device...")
			EquipDeviceMenu(false)
		Elseif (Selected == "Equip multiple type-specific devices...")
			EquipDeviceMenu(true)
		ElseIf (Selected == "Suggest and equip a device...")
			UDCDM.Print("TODO")
		endif
	endif
endfunction

Function EquipDeviceMenu(bool Multiple = false)
	LeveledItem LL = ud_alldevices
	int selector = 0
	while selector >= 0 ;loop color/material/style selection until stumble upon armor in 1st index of the list
		selector = ListPossibleSublists(LL)
		if selector == -1
			return
		elseIf selector >= 0
			LL = LL.GetNthForm(selector) as LeveledItem
		endif
	endwhile
	ListPossibleDevices(LL, Multiple)
EndFunction

int Function ListPossibleSublists(LeveledItem sLL)
	if sLL.GetNthForm(0) as Armor != None ; detected armor instead of nested list, abort!
		return -2
	endif
	int n = sLL.GetNumForms()
	if n > 0
		UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
		int i = 0
		while i < n
			listMenu.AddEntryItem(GetFormEditorID(sLL.GetNthForm(i)))
			i += 1
		endwhile
		listMenu.OpenMenu()
		return ListMenu.GetResultInt()
	endif
	return -1
EndFunction

; int Function ListPossibleDevices(LeveledItem sLL, int sStyle, int sMaterial, int sColor)
Function ListPossibleDevices(LeveledItem sLL, bool loop = false)
	; UDCDM.Print("Please wait, listing possible devices...")
	int n = devicekeywords
	; int k = 0 ;internal counter for an array
	; keyword[] storedkwds = new keyword[26] ;devicekeywords as int, papyrus be damned for not supporting dyn arrays natively.
	
	; if n > 0
	; 	int i = 0
	; 	while i < n
	; 		keyword selection = ud_KeywordsFormlist.GetAt(i) as keyword
	; 		if DeviceTypeExists(sLL, selection)
	; 			storedkwds[k] = selection
	; 			k += 1
	; 		endif
	; 		i += 1
	; 	endwhile
	; 	k -= 1
	; endif

	int selection = 0
	; if loop					;commented out, too slow. but working
	; 	While selection >= 0
	; 		UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	; 		if k >= 0
	; 			int i = 0
	; 			while i < k
	; 				listMenu.AddEntryItem(GetFormEditorID(storedkwds[i]))
	; 				i += 1
	; 			endwhile
	; 		Else
	; 			UDCDM.Print("Selected list is empty, abort!")
	; 			return
	; 		endif
	; 		listMenu.OpenMenu()
	; 		selection = ListMenu.GetResultInt()
	; 		if selection >= 0
	; 			libs.LockDevice(Game.GetPlayer(), PickRandomDeviceFromLL(sLL, storedkwds[selection]))
	; 		endif
	; 	EndWhile
	; else
	; 	UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	; 	if k >= 0
	; 		int i = 0
	; 		while i < k
	; 			listMenu.AddEntryItem(GetFormEditorID(storedkwds[i]))
	; 			i += 1
	; 		endwhile
	; 	Else
	; 		UDCDM.Print("Selected list is empty, abort!")
	; 		return
	; 	endif
	; 	listMenu.OpenMenu()
	; 	selection = ListMenu.GetResultInt()
	; 	if selection >= 0
	; 		libs.LockDevice(Game.GetPlayer(), PickRandomDeviceFromLL(sLL, storedkwds[selection]))
	; 	endif
	; endif
	if loop
		While selection >= 0
			UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
			int i = 0
			while i < n
				listMenu.AddEntryItem(GetFormEditorID(ud_KeywordsFormlist.GetAt(i)))
				i += 1
			endwhile
			listMenu.OpenMenu()
			selection = ListMenu.GetResultInt()
			if selection >= 0
				armor arm = PickRandomDeviceFromLL(sLL, ud_KeywordsFormlist.GetAt(selection) as keyword)
				if arm != none
					libs.LockDevice(Game.GetPlayer(), arm)
				else
					; UDCDM.Print("List doesn't contain selected keyword, please choose another.")
				endif
			endif
		EndWhile
	else
		While selection >= 0
			UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
			int i = 0
			while i < n
				listMenu.AddEntryItem(GetFormEditorID(ud_KeywordsFormlist.GetAt(i)))
				i += 1
			endwhile
			listMenu.OpenMenu()
			selection = ListMenu.GetResultInt()
			if selection >= 0
				armor arm = PickRandomDeviceFromLL(sLL, ud_KeywordsFormlist.GetAt(selection) as keyword)
				if arm != none
					libs.LockDevice(Game.GetPlayer(), arm)
					selection = -1
				else
					; UDCDM.Print("List doesn't contain selected keyword, please choose another.")
				endif
			endif
		EndWhile
	endif
EndFunction

;checks if device with provided keyword exists in leveled list
bool Function DeviceTypeExists(LeveledItem kLL, keyword sType)
	int n = kLL.GetNumForms()
	int i = 0
	Form frm
	while i < n
		frm = kLL.GetNthForm(i)
		If (frm As Armor) != None ;sanity check
			if IsKeywordedDevice(frm, sType, true)
				return true
			endif
		endif
		i += 1
	endwhile
	return false
EndFunction