Scriptname UISelectionMenu extends UIMenuBase

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

FormList Property SelectedForms  Auto  

string property		ROOT_MENU		= "CustomMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.MenuHolder.Menu_mc." autoReadonly

Form Function GetResultForm()
EndFunction

Function SetPropertyInt(string propertyName, int value)
EndFunction

Function ResetMenu()
EndFunction

int Function OpenMenu(Form aForm = None, Form aReceiver = None)
EndFunction

string Function GetMenuName()
EndFunction

; Push forms to FormList
Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
EndEvent

; Unlock selection menu
Event OnSelectForm(string eventName, string strArg, float numArg, Form formArg)
EndEvent

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
EndEvent
