Scriptname UITextEntryMenu extends UIMenuBase

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

string property		ROOT_MENU		= "CustomMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.textEntry." autoReadonly

string Function GetMenuName()
EndFunction

string Function GetResultString()
EndFunction

Function SetPropertyString(string propertyName, string value)
EndFunction

Function ResetMenu()
EndFunction

int Function OpenMenu(Form inForm = None, Form akReceiver = None)
EndFunction

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
EndEvent

Event OnTextChanged(string eventName, string strArg, float numArg, Form formArg)
	Unlock()
EndEvent

Function UpdateTextEntryString()
EndFunction

