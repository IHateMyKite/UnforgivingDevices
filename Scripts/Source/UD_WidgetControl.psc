;   File: UD_WidgetControl
;   This module contains functions for manipulating widgets.
;   It has two states: "Default" and "iWidgetInstalled".
;   Many of the functions defined here will work differently, depending on what state the script is in.
;   For example, status icons will not be displayed in the standard interface rendering mode, although their state will be changed and saved from API calls.
ScriptName UD_WidgetControl extends UD_ModuleBase

import UnforgivingDevicesMain
import UD_Native
