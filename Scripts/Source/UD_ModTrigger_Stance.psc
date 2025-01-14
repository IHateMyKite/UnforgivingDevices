;/  File: UD_ModTrigger_Stance
    It triggers with a given chance while actor uses specific stance or movement style
    
    NameFull: On Stance
    
    Parameters in DataStr:
        [0]     String      Stance (one or combination):
                                RN or Running
                                SP or Sprinting
                                SN or Sneaking
                                TP or Trespassing
                                WD or WeaponDrawn

        [1]     Float       (optional) Minimum duration in seconds
                            Default value: 0.0 sec

        [2]     Float       (optional) Probability to trigger per second of the stance duration
                            Default value: 0.0%

        [3]     Int         (optional) Reset duration on new stance. If false then duration is accumulated for all periods of taking the stance
                            Default value: 1 (True)

        [4]     Int         (optional) Repeat
                            Default value: 0 (False)

        [5]     Float       (script) Accumulated duration (in seconds)

    Example:

/;
Scriptname UD_ModTrigger_Stance extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function Stance(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool[] aabStances, String aiDataStr, Form akForm1)
    ; TODO PR195: 
    ; See functions Actor.IsSprinting, Actor.IsRunning, Actor.IsSneaking, Actor.IsTrespassing, Actor.IsWeaponDrawn
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    String loc_res = ""

    Return loc_res
EndFunction