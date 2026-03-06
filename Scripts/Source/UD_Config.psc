;   File: UD_Config
;   (should) Contains configuration variables for all Unforgiving Devices modules
Scriptname UD_Config Extends UD_ModuleBase

;/  Group: Orgasm manager Config
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: UD_OrgasmResistence
    Default orgasm resistence
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
float   Property UD_OrgasmResistence                = 3.5   auto hidden ;orgasm rate required for actor to be able to orgasm, lower the value, the faster will orgasm rate increase stop

;/  Variable: UD_UseOrgasmWidget
    If orgasm widget should be shown
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
bool    Property UD_UseOrgasmWidget                 = True  auto hidden

;/  Variable: UD_OrgasmUpdateTime
    Orgasm update time. Only used by Player. NPC have sepperate global variable
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
float   Property UD_OrgasmUpdateTime                = 0.2   auto hidden

;/  Variable: UD_OrgasmAnimation
    Orgasm animation list.
    
    --- Code
        0 = Only orgasm animations are used for orgasm
        1 = Both orgasm and horny animations are used for orgasm
    ---
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
int     Property UD_OrgasmAnimation                 = 1     auto hidden

;/  Variable: UD_OrgasmDuration
    Duration of orgasm.
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
int     Property UD_OrgasmDuration                  = 20    auto hidden

;/  Variable: UD_HornyAnimation
    If horny animations can play while actor is aroused
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
bool    Property UD_HornyAnimation                  = false  auto hidden

;/  Variable: UD_HornyAnimationDuration
    Duration of horny animation. Requires <UD_HornyAnimation> to be enabled first
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
int     Property UD_HornyAnimationDuration          = 5     auto hidden

;/  Variable: UD_OrgasmArousalReduce
    How much will be arousal rate reduced per second on orgasm
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
Int     Property UD_OrgasmArousalReduce             = 25    auto hidden

;/  Variable: UD_OrgasmArousalReduceDuration
    How long will <UD_OrgasmArousalReduce> last
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
Int     Property UD_OrgasmArousalReduceDuration     = 7     auto hidden

;/  Variable: UD_OrgasmExhaustionStruggleMax
    How many orgasm exhaustions are required to prevent struggling. Disabled if 0.
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
Int     Property UD_OrgasmExhaustionStruggleMax     = 6     auto hidden


;/  Variable: UD_RandomDevice_GlobalFilter

    Filter used for disabling certain devices from being randomely choosen
    
    *IS CHANGED USING MCM. READ ONLY!*
    
    BiteDetails:
    
    ---Code
        0x00000001 = zad_DeviousPiercingsVaginal
        0x00000002 = zad_DeviousPiercingsNipple
        0x00000004 = zad_DeviousPlugVaginal
        0x00000008 = zad_DeviousPlugAnal
        
        0x00000010 = zad_DeviousHeavyBondage
        0x00000020 = zad_deviousHarness
        0x00000040 = zad_DeviousCorset
        0x00000080 = zad_deviousHood
        
        0x00000100 = zad_DeviousCollar
        0x00000200 = zad_DeviousGag
        0x00000400 = zad_DeviousBlindfold
        0x00000800 = zad_DeviousBoots
        
        0x00001000 = zad_DeviousArmCuffs
        0x00002000 = zad_DeviousLegCuffs
        0x00004000 = zad_DeviousSuit
        0x00008000 = zad_DeviousGloves
        
        0x00010000 = zad_DeviousBra
        0x00020000 = zad_DeviousBelt
    ---
    
    Example:
    
    ---Code
        ;Disables hoods and suits from being randomely choosen
        UD_RandomDevice_GlobalFilter -> 0xFFFFBFBF
    ---
/;
int Property UD_RandomDevice_GlobalFilter = 0xFFFFFFFF auto hidden

;/  Variable: UD_UpdateTime
    Update time used by many parts of the mod
      * Device update time
      * NPC/Player Slot update time
    
    Do not edit, *READ ONLY!* Is set by user with MCM
/;
float Property UD_UpdateTime = 5.0 auto

Function OnSaveJSON(String strFile)
    JsonUtil.SetFloatValue(strFile, "DeviceUpdateTime", UD_UpdateTime)
    JsonUtil.SetFloatValue(strFile, "OrgasmResistence", UD_OrgasmResistence)
    JsonUtil.SetIntValue(strFile, "OrgasmExhaustionStruggleMax", UD_OrgasmExhaustionStruggleMax)
    JsonUtil.SetIntValue(strFile, "UseOrgasmWidget", UD_UseOrgasmWidget as Int)
    JsonUtil.SetFloatValue(strFile, "OrgasmUpdateTime", UD_OrgasmUpdateTime)
    JsonUtil.SetIntValue(strFile, "OrgasmAnimation", UD_OrgasmAnimation)
    JsonUtil.SetIntValue(strFile, "HornyAnimation", UD_HornyAnimation as Int)
    JsonUtil.SetIntValue(strFile, "HornyAnimationDuration", UD_HornyAnimationDuration)
    JsonUtil.SetIntValue(strFile, "PostOrgasmArousalReduce", UD_OrgasmArousalReduce)
    JsonUtil.SetIntValue(strFile, "PostOrgasmArousalReduce_Duration", UD_OrgasmArousalReduceDuration)
    JsonUtil.SetIntValue(strFile, "RandomFiler", UD_RandomDevice_GlobalFilter)
EndFunction
Function OnLoadJSON(String strFile)
    UD_UpdateTime                     = JsonUtil.GetFloatValue(strFile, "DeviceUpdateTime", UD_UpdateTime)
    UD_UseOrgasmWidget                = JsonUtil.GetIntValue(strFile, "UseOrgasmWidget", UD_UseOrgasmWidget as Int)
    UD_OrgasmUpdateTime               = JsonUtil.GetFloatValue(strFile, "OrgasmUpdateTime", UD_OrgasmUpdateTime)
    UD_OrgasmAnimation                = JsonUtil.GetIntValue(strFile, "OrgasmAnimation", UD_OrgasmAnimation)
    UD_HornyAnimation                 = JsonUtil.GetIntValue(strFile, "HornyAnimation", UD_HornyAnimation as Int)
    UD_HornyAnimationDuration         = JsonUtil.GetIntValue(strFile, "HornyAnimationDuration", UD_HornyAnimationDuration)
    UD_OrgasmResistence               = JsonUtil.GetFloatValue(strFile, "OrgasmResistence", UD_OrgasmResistence)
    UD_OrgasmExhaustionStruggleMax    = JsonUtil.GetIntValue(strFile, "OrgasmExhaustionStruggleMax", UD_OrgasmExhaustionStruggleMax)
    UD_OrgasmArousalReduce            = JsonUtil.GetIntValue(strFile, "PostOrgasmArousalReduce", UD_OrgasmArousalReduce)
    UD_OrgasmArousalReduceDuration    = JsonUtil.GetIntValue(strFile, "PostOrgasmArousalReduce_Duration", UD_OrgasmArousalReduceDuration)
    UD_RandomDevice_GlobalFilter      =  JsonUtil.GetIntValue(strFile, "RandomFiler", UD_RandomDevice_GlobalFilter)
EndFunction
Function OnResetToDefault()
    UD_UpdateTime                   = 5.0
    UD_OrgasmResistence             = 3.5
    UD_OrgasmExhaustionStruggleMax  = 6
    UD_UseOrgasmWidget              = true
    UD_OrgasmUpdateTime             = 0.5
    UD_OrgasmAnimation              = 1
    UD_HornyAnimation               = false
    UD_HornyAnimationDuration       = 5
    UD_OrgasmArousalReduce          = 25
    UD_OrgasmArousalReduceDuration  =  7
    UD_RandomDevice_GlobalFilter    = 0xFFFFFFFF ;32b
EndFunction