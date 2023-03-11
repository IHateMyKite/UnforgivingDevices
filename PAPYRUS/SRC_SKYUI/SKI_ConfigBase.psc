scriptname SKI_ConfigBase extends SKI_QuestBase

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

; CONSTANTS ---------------------------------------------------------------------------------------

int property		OPTION_FLAG_NONE		= 0x00 autoReadonly
int property		OPTION_FLAG_DISABLED	= 0x01 autoReadonly
int property		OPTION_FLAG_HIDDEN		= 0x02 autoReadonly			; @since 3
int property		OPTION_FLAG_WITH_UNMAP	= 0x04 autoReadonly			; @since 3

int property		LEFT_TO_RIGHT			= 1	autoReadonly
int property		TOP_TO_BOTTOM			= 2 autoReadonly


; PROPERTIES --------------------------------------------------------------------------------------

string property		ModName auto

string[] property	Pages auto

string property		CurrentPage
	string function get()
		Guard()
		return  ""
	endFunction
endProperty


; EVENTS ------------------------------------------------------------------------------------------

event OnConfigInit()
endEvent

event OnConfigRegister()
endEvent

event OnConfigOpen()
endEvent

event OnConfigClose()
endEvent

event OnVersionUpdate(int aVersion)
endEvent

event OnPageReset(string a_page)
endEvent

event OnOptionHighlight(int a_option)
endEvent

event OnOptionSelect(int a_option)
endEvent

event OnOptionDefault(int a_option)
endEvent

event OnOptionSliderOpen(int a_option)
endEvent

event OnOptionSliderAccept(int a_option, float a_value)
endEvent

event OnOptionMenuOpen(int a_option)
endEvent

event OnOptionMenuAccept(int a_option, int a_index)
endEvent

event OnOptionColorOpen(int a_option)
endEvent

event OnOptionColorAccept(int a_option, int a_color)
endEvent

event OnOptionKeyMapChange(int a_option, int a_keyCode, string a_conflictControl, string a_conflictName)
endEvent

; @since 4
event OnOptionInputOpen(int a_option)
endEvent

; @since 4
event OnOptionInputAccept(int a_option, string a_input)
endEvent

; @since 2
event OnHighlightST()
endEvent

; @since 2
event OnSelectST()
endEvent

; @since 2
event OnDefaultST()
endEvent

; @since 2
event OnSliderOpenST()
endEvent

; @since 2
event OnSliderAcceptST(float a_value)
endEvent

; @since 2
event OnMenuOpenST()
endEvent

; @since 2
event OnMenuAcceptST(int a_index)
endEvent

; @since 2
event OnColorOpenST()
endEvent

; @since 2
event OnColorAcceptST(int a_color)
endEvent

; @since 2
event OnKeyMapChangeST(int a_keyCode, string a_conflictControl, string a_conflictName)
endEvent

; @since 4
event OnInputOpenST()
endEvent

; @since 4
event OnInputAcceptST(string a_input)
endEvent


; FUNCTIONS ---------------------------------------------------------------------------------------

int function GetVersion()
endFunction

string function GetCustomControl(int a_keyCode)
endFunction

function ForcePageReset()
endFunction

function SetTitleText(string a_text)
endFunction

function SetInfoText(string a_text)
endFunction

function SetCursorPosition(int a_position)
endFunction

function SetCursorFillMode(int a_fillMode)
endFunction

int function AddEmptyOption()
endFunction

int function AddHeaderOption(string a_text, int a_flags = 0)
endFunction

int function AddTextOption(string a_text, string a_value, int a_flags = 0)
endFunction

int function AddToggleOption(string a_text, bool a_checked, int a_flags = 0)
endfunction

int function AddSliderOption(string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0)
endFunction

int function AddMenuOption(string a_text, string a_value, int a_flags = 0)
endFunction

int function AddColorOption(string a_text, int a_color, int a_flags = 0)
endFunction

int function AddKeyMapOption(string a_text, int a_keyCode, int a_flags = 0)
endFunction

; @since 4
int function AddInputOption(string a_text, string a_value, int a_flags = 0)
endFunction

; @since 2
function AddTextOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
endFunction

; @since 2
function AddToggleOptionST(string a_stateName, string a_text, bool a_checked, int a_flags = 0)
endfunction

; @since 2
function AddSliderOptionST(string a_stateName, string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0)
endFunction

; @since 2
function AddMenuOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
endFunction

; @since 2
function AddColorOptionST(string a_stateName, string a_text, int a_color, int a_flags = 0)
endFunction

; @since 2
function AddKeyMapOptionST(string a_stateName, string a_text, int a_keyCode, int a_flags = 0)
endFunction

; @since 4
function AddInputOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
endFunction

function LoadCustomContent(string a_source, float a_x = 0.0, float a_y = 0.0)
endFunction

function UnloadCustomContent()
endFunction

function SetOptionFlags(int a_option, int a_flags, bool a_noUpdate = false)
endFunction

function SetTextOptionValue(int a_option, string a_value, bool a_noUpdate = false)
endFunction

function SetToggleOptionValue(int a_option, bool a_checked, bool a_noUpdate = false)
endfunction

function SetSliderOptionValue(int a_option, float a_value, string a_formatString = "{0}", bool a_noUpdate = false)
endFunction

function SetMenuOptionValue(int a_option, string a_value, bool a_noUpdate = false)
endFunction

function SetColorOptionValue(int a_option, int a_color, bool a_noUpdate = false)
endFunction

function SetKeyMapOptionValue(int a_option, int a_keyCode, bool a_noUpdate = false)
endFunction

; @since 4
function SetInputOptionValue(int a_option, string a_value, bool a_noUpdate = false)
endFunction

; @since 2
function SetOptionFlagsST(int a_flags, bool a_noUpdate = false, string a_stateName = "")
endFunction

; @since 2
function SetTextOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
endFunction

; @since 2
function SetToggleOptionValueST(bool a_checked, bool a_noUpdate = false, string a_stateName = "")
endFunction

; @since 2
function SetSliderOptionValueST(float a_value, string a_formatString = "{0}", bool a_noUpdate = false, string a_stateName = "")
endFunction

; @since 2
function SetMenuOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
endFunction

; @since 2
function SetColorOptionValueST(int a_color, bool a_noUpdate = false, string a_stateName = "")
endFunction

; @since 2
function SetKeyMapOptionValueST(int a_keyCode, bool a_noUpdate = false, string a_stateName = "")
endFunction

; @since 4
function SetInputOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
endFunction

function SetSliderDialogStartValue(float a_value)
endFunction

function SetSliderDialogDefaultValue(float a_value)
endFunction

function SetSliderDialogRange(float a_minValue, float a_maxValue)
endFunction

function SetSliderDialogInterval(float a_value)
endFunction

function SetMenuDialogStartIndex(int a_value)
endFunction

function SetMenuDialogDefaultIndex(int a_value)
endFunction

function SetMenuDialogOptions(string[] a_options)
endFunction

function SetColorDialogStartColor(int a_color)
endFunction

function SetColorDialogDefaultColor(int a_color)
endFunction

; @since 4
function SetInputDialogStartText(string a_text)
endFunction

bool function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel")
endFunction

function Guard()
endFunction

