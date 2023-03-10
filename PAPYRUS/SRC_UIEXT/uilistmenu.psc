Scriptname UIListMenu extends UIMenuBase

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

string property		ROOT_MENU		= "CustomMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.listMenu." autoReadonly

int Function GetResultInt()
EndFunction

float Function GetResultFloat()
EndFunction

string Function GetResultString()
EndFunction

Function SetPropertyInt(string propertyName, int value)
EndFunction

Function SetPropertyBool(string propertyName, bool value)
EndFunction

Function SetPropertyStringA(string propertyName, string[] value)
EndFunction

int Function AddEntryItem(string entryName, int entryParent = -1, int entryCallback = -1, bool entryHasChildren = false)
EndFunction

Function SetPropertyIndexInt(string propertyName, int index, int value)
EndFunction

Function SetPropertyIndexBool(string propertyName, int index, bool value)
EndFunction

Function SetPropertyIndexString(string propertyName, int index, string value)
EndFunction

int Function GetPropertyInt(string propertyName)
EndFunction

Function OnInit()
EndFunction

Function ResetMenu()
EndFunction

int Function OpenMenu(Form aForm = None, Form aReceiver = None)
EndFunction

string Function GetMenuName()
EndFunction

Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
EndEvent

Event OnSelectText(string eventName, string strArg, float numArg, Form formArg)
EndEvent

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
EndEvent
