scriptname SKI_WidgetBase extends SKI_QuestBase

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

string property		HUD_MENU = "HUD Menu" autoReadOnly
bool property RequireExtend				= true	auto
string property WidgetName				= "I-forgot-to-set-the-widget name" auto
int property WidgetID
	int function get()
	endFunction
endProperty
bool property Ready
	bool function get()
	endFunction
endProperty
string property WidgetRoot
	string function get()
	endFunction
endProperty
string[] property Modes
	string[] function get()
	endFunction
	function set(string[] a_val)
	endFunction
endProperty
string property HAnchor
	string function get()
	endFunction
	function set(string a_val)
	endFunction
endProperty
string property VAnchor
	string function get()
	endFunction
	function set(string a_val)
	endFunction
endProperty
float property X
	float function get()
	endFunction
	function set(float a_val)
	endFunction
endProperty
float property Y
	float function get()
	endFunction
	function set(float a_val)
	endFunction
endProperty
float property Alpha
	float function get()
	endFunction
	function set(float a_val)
	endFunction
endProperty
event OnInit()
endEvent
event OnGameReload()
endEvent
event OnWidgetManagerReady(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
endEvent
event OnWidgetInit()
endEvent
event OnWidgetLoad()
endEvent
event OnWidgetReset()
endEvent
string function GetWidgetSource()
endFunction
string function GetWidgetType()
endFunction
float[] function GetDimensions()
endFunction
function TweenToX(float a_x, float a_duration)
endFunction
function TweenToY(float a_y, float a_duration)
endFunction
function TweenTo(float a_x, float a_y, float a_duration)
endFunction
function FadeTo(float a_alpha, float a_duration)
endFunction
bool function IsExtending()
endFunction
function UpdateWidgetClientInfo()
endFunction
function UpdateWidgetAlpha()
endFunction
function UpdateWidgetHAnchor()
endFunction

function UpdateWidgetVAnchor()
endFunction

function UpdateWidgetPositionX()
endFunction

function UpdateWidgetPositionY()
endFunction

function UpdateWidgetModes()
endFunction