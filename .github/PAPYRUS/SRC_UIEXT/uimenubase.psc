Scriptname UIMenuBase extends Quest

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

bool Property isResetting = false Auto

Function Lock()
EndFunction

bool Function WaitLock()
EndFunction

Function Unlock()
EndFunction

bool Function BlockUntilClosed()
EndFunction

bool Function WaitForReset()
EndFunction

int Function OpenMenu(Form akForm = None, Form akReceiver = None)
EndFunction

string Function GetMenuName()
EndFunction

Event OnGameReload()
EndEvent

Function ResetMenu()
EndFunction

float Function GetResultFloat()
EndFunction

int Function GetResultInt()
EndFunction

string Function GetResultString()
EndFunction

Form Function GetResultForm()
EndFunction

int Function GetPropertyInt(string propertyName)
EndFunction

bool Function GetPropertyBool(string propertyName)
EndFunction

string Function GetPropertyString(string propertyName)
EndFunction

float Function GetPropertyFloat(string propertyName)
EndFunction

Form Function GetPropertyForm(string propertyName)
EndFunction

Alias Function GetPropertyAlias(string propertyName)
EndFunction

Function SetPropertyInt(string propertyName, int value)
EndFunction

Function SetPropertyBool(string propertyName, bool value)
EndFunction

Function SetPropertyString(string propertyName, string value)
EndFunction

Function SetPropertyFloat(string propertyName, float value)
EndFunction

Function SetPropertyForm(string propertyName, Form value)
EndFunction

Function SetPropertyAlias(string propertyName, Alias value)
EndFunction

Function SetPropertyIndexInt(string propertyName, int index, int value)
EndFunction

Function SetPropertyIndexBool(string propertyName, int index, bool value)
EndFunction

Function SetPropertyIndexString(string propertyName, int index, string value)
EndFunction

Function SetPropertyIndexFloat(string propertyName, int index, float value)
EndFunction

Function SetPropertyIndexForm(string propertyName, int index, Form value)
EndFunction

Function SetPropertyIndexAlias(string propertyName, int index, Alias value)
EndFunction

Function SetPropertyIntA(string propertyName, int[] value)
EndFunction

Function SetPropertyBoolA(string propertyName, bool[] value)
EndFunction

Function SetPropertyStringA(string propertyName, string[] value)
EndFunction

Function SetPropertyFloatA(string propertyName, float[] value)
EndFunction

Function SetPropertyFormA(string propertyName, Form[] value)
EndFunction

Function SetPropertyAliasA(string propertyName, Alias[] value)
EndFunction