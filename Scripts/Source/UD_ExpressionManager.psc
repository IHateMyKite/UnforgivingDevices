scriptname UD_ExpressionManager extends Quest

import MfgConsoleFunc
import sslBaseExpression
import UnforgivingDevicesMain
;====Sexlab Expression Construct====
;All number are floats in range 0.0-1.0
;Only exception is expression[30] whre it needs whole number in range 0-16
;
;    =====================Phonems=====================
;    
;    expression[ 0] = Aah     [ 0.0 , 1.0 ]
;    expression[ 1] = BigAah  [ 0.0 , 1.0 ]
;    expression[ 2] = BMP     [ 0.0 , 1.0 ]
;    expression[ 3] = ChJSh   [ 0.0 , 1.0 ]
;    expression[ 4] = DST     [ 0.0 , 1.0 ]
;    expression[ 5] = Eee     [ 0.0 , 1.0 ]
;    expression[ 6] = Eh      [ 0.0 , 1.0 ]
;    expression[ 7] = FV      [ 0.0 , 1.0 ]
;    expression[ 8] = I       [ 0.0 , 1.0 ]
;    expression[ 9] = K       [ 0.0 , 1.0 ]
;    expression[10] = N       [ 0.0 , 1.0 ]
;    expression[11] = Oh      [ 0.0 , 1.0 ]
;    expression[12] = OohQ    [ 0.0 , 1.0 ]
;    expression[13] = R       [ 0.0 , 1.0 ]
;    expression[14] = Th      [ 0.0 , 1.0 ]
;    expression[15] = W       [ 0.0 , 1.0 ]
;    
;    =====================Modifiers=====================
;    
;    expression[16] = BlinkLeft      [ 0.0 , 1.0 ]     !Warning, using this will prevent the eye from blinking! 
;    expression[17] = BlinkRight     [ 0.0 , 1.0 ]     !Warning, using this will prevent the eye from blinking! 
;    expression[18] = BrowDownLeft   [ 0.0 , 1.0 ]
;    expression[19] = BrowDownRight  [ 0.0 , 1.0 ]
;    expression[20] = BrowInLeft     [ 0.0 , 1.0 ]
;    expression[21] = BrowInRight    [ 0.0 , 1.0 ]
;    expression[22] = BrowUpLeft     [ 0.0 , 1.0 ]
;    expression[23] = BrowUpRight    [ 0.0 , 1.0 ]
;    expression[24] = LookDown       [ 0.0 , 1.0 ]
;    expression[25] = LookLeft       [ 0.0 , 1.0 ]
;    expression[26] = LookRight      [ 0.0 , 1.0 ]
;    expression[27] = LookUp         [ 0.0 , 1.0 ]
;    expression[28] = SquintLeft     [ 0.0 , 1.0 ]
;    expression[29] = SquintRight    [ 0.0 , 1.0 ]
;    
;    =====================Expression=====================
;    
;    expression[30] =     X: Selected expression, see below [ 0 , 16 ]
;                         0: Dialogue Anger
;                         1: Dialogue Fear
;                         2: Dialogue Happy
;                         3: Dialogue Sad
;                         4: Dialogue Surprise
;                         5: Dialogue Puzzled
;                         6: Dialogue Disgusted
;                         7: Mood Neutral
;                         8: Mood Anger
;                         9: Mood Fear
;                        10: Mood Happy
;                        11: Mood Sad
;                        12: Mood Surprise
;                        13: Mood Puzzled
;                        14: Mood Disgusted
;                        15: Combat Anger
;                        16: Combat Shout - this opens mouth like phonem, try to not use this unless you have good reason
;    expression[31] = Strength of choosen expression (expression[30]) [ 0.0 , 1.0 ]


UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty
zadlibs_UDPatch Property libsp
    zadlibs_UDPatch Function get()
        return UDCDmain.libsp
    EndFunction
EndProperty

bool Property Ready = false auto

Event OnInit()
    Utility.waitMenuMode(2.5)
    RegisterForSingleUpdate(10.0) ;update expression manager on init
    Ready = true
EndEvent

;on init update
Event OnUpdate()
    Update()
EndEvent

Function Update()
    UnregisterForAllModEvents()
    UpdatePrebuildExpressions()
EndFunction

Function RegisterExpression(string sJsonName)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Registering expression " + sJsonName)
    endif
    
    int loc_aliasNum = GetNumAliases()
    
    while loc_aliasNum
        loc_aliasNum -= 1
        sslBaseExpression loc_expressionSlot = GetNthAlias(loc_aliasNum) as sslBaseExpression
        if !loc_expressionSlot.Registered
            loc_expressionSlot.MakeEphemeral(sJsonName, none)
            loc_expressionSlot.ImportJson()
            if UDmain.TraceAllowed()            
                UDCDmain.Log("Expression["+ loc_aliasNum +"] = " + sJsonName + ", registered!")
            endif
            return
        endif
    endwhile
EndFunction

sslBaseExpression Function getExpression(string sExpressionName)
    int loc_aliasNum = GetNumAliases()
    
    while loc_aliasNum
        loc_aliasNum -= 1
        sslBaseExpression loc_expressionSlot = GetNthAlias(loc_aliasNum) as sslBaseExpression
        if loc_expressionSlot.Name == sExpressionName
            return loc_expressionSlot
        endif
    endwhile
    UDCDmain.Error("Expression " + sExpressionName + " not found!")
    return none
EndFunction

float[] Function CreateEmptyExpression()
    return new float[32]
EndFunction

float[] Function CreatePhonems()
    return new float[16]
EndFunction

float[] Function GetCurrentExpression(Actor akActor)
    return GetCurrentMFG(akActor) 
EndFunction


;/====PHONEMS====
    https://www.creationkit.com/index.php?title=ModifyFaceGen
    0: Aah
    1: BigAah
    2: BMP
    3: ChJSh
    4: DST
    5: Eee
    6: Eh
    7: FV
    8: I
    9: K
    10: N
    11: Oh
    12: OohQ
    13: R
    14: Th
    15: W
/;
Function SetExpressionPhonems(float[] expression,float[] phonems)
    if expression.length != 32
        UDCDmain.Error("SetExpressionModifiers - expression can only have length 32!")
        return
    endif
    if phonems.length != 16
        UDCDmain.Error("SetExpressionModifiers - phonems can only have length 16!")
        return
    endif
    int loc_i = 0
    while loc_i < 16
        expression[loc_i] = fRange(phonems[loc_i],0.0,1.0)
        loc_i += 1
    endWhile
EndFunction
Function ResetExpressionPhonems(float[] expression)
    if expression.length != 32
        UDCDmain.Error("SetExpressionModifiers - expression can only have length 32!")
        return
    endif
    int loc_i = 0
    while loc_i < 16
        expression[loc_i] = 0.0
        loc_i += 1
    endWhile
EndFunction

;/====MODIFIERS====
    https://www.creationkit.com/index.php?title=ModifyFaceGen
    0: BlinkLeft
    1: BlinkRight
    2: BrowDownLeft
    3: BrowDownRight
    4: BrowInLeft
    5: BrowInRight
    6: BrowUpLeft
    7: BrowUpRight
    8: LookDown
    9: LookLeft
    10: LookRight
    11: LookUp
    12: SquintLeft
    13: SquintRight
/;
Function SetExpressionModifiers(float[] expression,float[] modifiers)
    if expression.length != 32
        UDCDmain.Error("SetExpressionModifiers - expression can only have length 32!")
        return
    endif
    if modifiers.length != 14
        UDCDmain.Error("SetExpressionModifiers - modifiers can only have length 14!")
        return
    endif
    int loc_i = 16
    int loc_x = 0
    while loc_i < 30
        expression[loc_i] = fRange(modifiers[loc_x],0.0,1.0)
        loc_i += 1
        loc_x += 1
    endWhile
EndFunction


;/====EXPRESSION====
    https://www.creationkit.com/index.php?title=ModifyFaceGen
    0: Dialogue Anger
    1: Dialogue Fear
    2: Dialogue Happy
    3: Dialogue Sad
    4: Dialogue Surprise
    5: Dialogue Puzzled
    6: Dialogue Disgusted
    7: Mood Neutral
    8: Mood Anger
    9: Mood Fear
    10: Mood Happy
    11: Mood Sad
    12: Mood Surprise
    13: Mood Puzzled
    14: Mood Disgusted
    15: Combat Anger
    16: Combat Shout
/;

Function SetExpressionExpression(float[] expression,int expression_type,int expression_strength)
    if expression.length != 32
        UDCDmain.Error("SetExpressionModifiers - expression can only have length 32!")
        return
    endif
    expression[30] = iRange(expression_type,0,16)
    expression[31] = fRange(expression_strength,0.0,1.0)
EndFunction

;total random, will look stupid, but its good for debuging
Float[] Function CreateRandomExpression(bool bExport = false)
    float[] loc_expression = CreateEmptyExpression()
    string loc_strres = ""
    int loc_i = 0
    while loc_i < loc_expression.length - 2
        loc_expression[loc_i] = Utility.randomFloat(0.0,0.3)*Utility.randomInt(0,1)
        loc_strres += "loc_expression["+loc_i+"] = "+loc_expression[loc_i] + "\n"
        loc_i += 1
    endwhile
    loc_expression[17] = loc_expression[16] ;same blink modifier, so not only one eye blink
    loc_expression[loc_expression.length - 2] = Utility.randomInt(0,15) ;don't choose Combat shout, it looks stoopid
    loc_expression[loc_expression.length - 1] = Utility.randomFloat(0.0,1.0)
    return loc_expression
EndFunction

;apply strentgh on to expression. Returns new expression
;in case of failure returns empty expression
float[] Function ApplyStrentghToExpression(float[] expression,int strength)
    if expression.length != 32
        UDCDmain.Error("SetExpressionModifiers - expression can only have length 32!")
        return CreateEmptyExpression()
    endif
    float[] loc_expression = CreateEmptyExpression()
    int loc_strength = iRange(strength,0,100)
    int loc_i = 0
    
    while loc_i < 30
        loc_expression[loc_i] = expression[loc_i]*fRange(loc_strength/100.0,0.0,1.0)
        loc_i += 1
    endWhile
    loc_expression[30] = expression[30]
    loc_expression[31] = expression[31]*fRange(loc_strength/100.0,0.0,1.0)
    return loc_expression
EndFunction

;check expression blocking with priority
;mode 1 = sets blocking if priority is met
;mode 2 = resets blocking if priority is met
bool Function CheckExpressionBlock(Actor akActor,int iPriority, int iMode = 0)
    if !akActor.isInFaction(UDCDmain.BlockExpressionFaction)
        if iMode == 1
            akActor.AddToFaction(UDCDmain.BlockExpressionFaction)
            akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,iPriority)
        endif
        return true
    endif

    if iPriority >= akActor.GetFactionRank(UDCDmain.BlockExpressionFaction)
        if iMode == 1 ;set blocking priority
            if iPriority >= akActor.GetFactionRank(UDCDmain.BlockExpressionFaction)
                akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,iPriority)
                return true
            else
                return false
            endif
        elseif iMode == 2 ;reset blocking priority
            akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,0)
        endif
        return true
    else
        return false
    endif
EndFunction

bool _ExpressionManip_Mutex = false
bool Function ApplyExpression(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false,int iPriority = 0)
    if !libsp.IsValidActor(akActor)    
        UDCDMain.Error("ApplyExpressionPatched(): Actor is not loaded (Or is otherwise invalid). Aborting.")
        return false
    EndIf
    if !expression    
        UDCDMain.Error("ApplyExpressionPatched(): Expression is none.")
        return false
    EndIf
    
    if UDmain.TraceAllowed()    
        UDCDmain.Log("(Patched) Expression " + expression + " applied for " + getActorName(akActor) +", strength: " + strength + ",mouth?: " + openMouth,2)
    endif
    
    while _ExpressionManip_Mutex
        Utility.waitMenuMode(0.1)
    endwhile
    _ExpressionManip_Mutex = true
    
    if !CheckExpressionBlock(akActor,iPriority,1)
        if UDmain.TraceAllowed()        
            UDCDmain.Log("(Patched) Expression " + expression + " is blocked for " + getActorName(akActor) +", strength: " + strength + ",mouth?: " + openMouth,2)
        endif
        _ExpressionManip_Mutex = false
        return false
    endif
    
    ;UDCDmain.SendSetExpressionEvent(akActor, expression, strength, openMouth)
    
    SetExpression(akActor,expression,strength,openMouth)
    
    _ExpressionManip_Mutex = false
    return true
EndFunction

bool Function ApplyExpressionRaw(Actor akActor, float[] expression, int strength, bool openMouth=false,int iPriority = 0)
    if !libsp.IsValidActor(akActor)    
        UDCDMain.Error("ApplyExpressionRaw(): Actor is not loaded (Or is otherwise invalid). Aborting.")
        return false
    EndIf
    if !expression
        UDCDMain.Error("ApplyExpressionRaw(): Expression is none.")
        return false
    EndIf
    if expression.length != 32
        UDCDMain.Error("ApplyExpressionRaw(): Expression is not size 32!")
        return false
    EndIf
    if UDmain.TraceAllowed()    
        UDCDmain.Log("ApplyExpressionRaw (" + expression + ") applied for " + getActorName(akActor) +", strength: " + strength + ",mouth?: " + openMouth,2)
    endif
    
    while _ExpressionManip_Mutex
        Utility.waitMenuMode(0.1)
    endwhile
    _ExpressionManip_Mutex = true
    
    if !CheckExpressionBlock(akActor,iPriority,1)
        if UDmain.TraceAllowed()        
            UDCDmain.Log("ApplyExpressionRaw (" + expression + ") is blocked for " + getActorName(akActor) +", strength: " + strength + ",mouth?: " + openMouth,2)
        endif
        _ExpressionManip_Mutex = false
        return false
    endif
    
    ;UDCDmain.SendSetExpressionEvent(akActor, expression, strength, openMouth)
    
    SetExpressionRaw(akActor,expression,strength,openMouth)
    
    _ExpressionManip_Mutex = false
    return true
EndFunction

Function SetExpression(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false)
    ;StorageUtil.SetIntValue(akActor,"zad_expressionApplied",1)
    int gender = (akActor.GetBaseObject() as ActorBase).GetSex()
    bool hasGag = akActor.WornHasKeyword(libsp.zad_DeviousGag)
    
    float[] loc_expression = expression.GenderPhase(expression.CalcPhase(Strength, Gender), Gender)
    float[] loc_appliedExpression = GetCurrentMFG(akActor) 

    if UDmain.TraceAllowed()
        UDCDmain.Log("SetExpression("+akActor+") - passed expression: \n"+loc_expression+"\n Current expression: \n"+loc_appliedExpression)
    endif

    if hasGag
        loc_expression = ApplyGagEffectToPreset(akActor,loc_expression)
    elseif openMouth
        loc_expression[expression.Phoneme + 0] = 0.75
    endif
    
    if UDmain.TraceAllowed()
        UDCDmain.Log("SetExpression("+akActor+") - modified expression: \n"+loc_expression)
    endif
    
    if loc_expression != loc_appliedExpression
        ApplyPresetFloats_NOMC(akActor, loc_expression)
    endif
EndFunction

Function SetExpressionRaw(Actor akActor, float[]  expression, int strength, bool openMouth=false)
    int gender = (akActor.GetBaseObject() as ActorBase).GetSex()
    bool hasGag = akActor.WornHasKeyword(libsp.zad_DeviousGag)
    
    float[] loc_expression = ApplyStrentghToExpression(expression,strength)
    float[] loc_appliedExpression = GetCurrentMFG(akActor) 

    if hasGag
        loc_expression = ApplyGagEffectToPreset(akActor,loc_expression)
    elseif openMouth
        loc_expression[0] = 0.75
    endif
    
    if loc_expression != loc_appliedExpression
        UpdatePresetFloats_NOMC(akActor, loc_expression,loc_appliedExpression)
    endif
EndFunction

bool Function ResetExpression(actor akActor, sslBaseExpression expression,int iPriority = 0)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("Expression " + expression + " reset for " + getActorName(akActor),2)
    endif
    
    while _ExpressionManip_Mutex
        Utility.waitMenuMode(0.01)
    endwhile
    
    _ExpressionManip_Mutex = true
    if !CheckExpressionBlock(akActor,iPriority,0)
        if UDmain.TraceAllowed()        
            UDCDmain.Log("(Patched) Expression " + expression + " is blocked for " + getActorName(akActor),3)
        endif
        _ExpressionManip_Mutex = false
        return false
    endif
    
    if !akActor.WornHasKeyword(libsp.zad_DeviousGag)
        MfgConsoleFunc.SetPhonemeModifier(akActor, -1, 0, 0)
        akActor.ClearExpressionOverride()
    else
        ;reset only expression without phonems
        float[] loc_appliedExpression = GetCurrentMFG(akActor)
        int loc_i = 16
        while loc_i < 30
            loc_appliedExpression[loc_i] = 0
            loc_i += 1
        endWhile
        ApplyPresetFloats_NOMC(akActor, loc_appliedExpression)
        akActor.ClearExpressionOverride()
    endif
    akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,0)
    
    _ExpressionManip_Mutex = false
    return true
EndFunction

bool Function ResetExpressionRaw(actor akActor, int iPriority = 0)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("ResetExpressionRaw - Expression reset for " + getActorName(akActor),2)
    endif
    
    while _ExpressionManip_Mutex
        Utility.waitMenuMode(0.01)
    endwhile
    
    _ExpressionManip_Mutex = true
    if !CheckExpressionBlock(akActor,iPriority,0)
        if UDmain.TraceAllowed()        
            UDCDmain.Log("ResetExpressionRaw - Expression is blocked for " + getActorName(akActor),3)
        endif
        _ExpressionManip_Mutex = false
        return false
    endif
    
    if !akActor.WornHasKeyword(libsp.zad_DeviousGag)
        MfgConsoleFunc.SetPhonemeModifier(akActor, -1, 0, 0)
        akActor.ClearExpressionOverride()
    else
        ;reset only expression without phonems
        float[] loc_appliedExpression = GetCurrentMFG(akActor)
        int loc_i = 16
        while loc_i < 30
            loc_appliedExpression[loc_i] = 0
            loc_i += 1
        endWhile
        ApplyPresetFloats_NOMC(akActor, loc_appliedExpression)
        akActor.ClearExpressionOverride()
    endif
    akActor.SetFactionRank(UDCDmain.BlockExpressionFaction,0)
    
    _ExpressionManip_Mutex = false
    return true
EndFunction

Function ApplyGagEffect(actor akActor)    
    if akActor.Is3DLoaded() || UDmain.ActorIsPlayer(akActor)
        while _ExpressionManip_Mutex
            Utility.waitMenuMode(0.1)
        endwhile
        _ExpressionManip_Mutex = true
        float[] loc_appliedExpression = GetCurrentMFG(akActor)
        float[] loc_expression = ApplyGagEffectToPreset(akActor,loc_appliedExpression)

        if loc_expression != loc_appliedExpression
            UpdatePresetFloats_NOMC(akActor, loc_expression,loc_appliedExpression)
        endif
        _ExpressionManip_Mutex = false
    endif
EndFunction

Function RemoveGagEffect(actor akActor)
    if UDmain.TraceAllowed()    
        UDCDmain.Log("RemoveGagEffect called",2)
    endif
    while _ExpressionManip_Mutex
        Utility.waitMenuMode(0.1)
    endwhile
    _ExpressionManip_Mutex = true
    If akActor.WornHasKeyword(libsp.zad_GagCustomExpression)
        libsp.SendGagEffectEvent(akActor, false)
        _ExpressionManip_Mutex = false
        Return
    EndIf
    ;reset only expression without phonems
    float[] loc_appliedExpression = GetCurrentMFG(akActor)
    int loc_i = 0
    while loc_i < 16
        loc_appliedExpression[loc_i] = 0.0
        loc_i += 1
    endWhile
    ApplyPresetFloats_NOMC(akActor, loc_appliedExpression)
    _ExpressionManip_Mutex = false
EndFunction

State DDExpressionSystemInstalled
    bool Function ApplyExpression(Actor akActor, sslBaseExpression expression, int strength, bool openMouth=false,int iPriority = 0)
        return libsp.ApplyExpression_v2(akActor, expression, iPriority, strength, openMouth)
    EndFunction
    bool Function ApplyExpressionRaw(Actor akActor, float[] expression, int strength, bool openMouth=false,int iPriority = 0)
        return libsp.ApplyExpressionRaw(akActor, expression, iPriority, strength, openMouth)
    EndFunction
    bool Function ResetExpression(actor akActor, sslBaseExpression expression,int iPriority = 0)
        return libsp.ResetExpressionRaw(akActor,iPriority)
    EndFunction
    bool Function ResetExpressionRaw(actor akActor, int iPriority = 0)
        return libsp.ResetExpressionRaw(akActor,iPriority)
    EndFunction
    Function ApplyGagEffect(actor akActor)    
        libsp.ApplyGagEffect(akActor)
    EndFunction
    Function RemoveGagEffect(actor akActor)
        libsp.RemoveGagEffect(akActor)
    EndFunction
EndState

float[] Function ApplyGagEffectToPreset(Actor akActor,Float[] preset)
    float[] loc_preset = Utility.CreateFloatArray(preset.length)
    
    int i = preset.length
    while i
        i -= 1
        loc_preset[i] = preset[i]
    endwhile
    
    ResetExpressionPhonems(loc_preset)
    
    ; apply this affect to actual gags only, not hoods that also share this keyword.
    If akActor.WornHasKeyword(libsp.zad_GagCustomExpression)
        libsp.SendGagEffectEvent(akActor, false)
    elseIf akActor.WornHasKeyword(libsp.zad_GagNoOpenMouth)
        ;close mouth, reset phonems
        return loc_preset
    elseIf akActor.WornHasKeyword(libsp.zad_DeviousGagLarge)
        loc_preset[0] = 1.0
        loc_preset[1] = 1.0
        loc_preset[11] = 0.30

        loc_preset[16 + 4] = 1.00
        loc_preset[16 + 5] = 1.00
        loc_preset[16 + 6] = 1.00
        loc_preset[16 + 7] = 1.00    
    else
        if !akActor.wornhaskeyword(libsp.zad_DeviousGagPanel)
            loc_preset[0 + 0] = (UDCDmain.UD_GagPhonemModifier as float)/100.0
        else
            loc_preset[0 + 0] = 0 ;panel is clipping when this value is > 0
        endif
        loc_preset[0 + 1] = 1.0
        loc_preset[0 + 11] = 0.70        
    EndIf
    ;prevent Combat shout expression as it makes gag looking worse
    if loc_preset[30] == 16
        loc_preset[31] == 0
    endif
    return loc_preset
EndFunction

;COPIED FROM sslBaseExpression because it will otherwise not work for SE because of MouthOpen check 
function ApplyPresetFloats_NOMC(Actor ActorRef, float[] Preset) global 
    int i
    ; Set Phoneme
    int p
    while p <= 15
        MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, (Preset[i] * 100.0) as int)
        i += 1
        p += 1
    endWhile
    ; Set Modifers
    int m
    while m <= 13
        MfgConsoleFunc.SetPhonemeModifier(ActorRef, 1, m, (Preset[i] * 100.0) as int)
        i += 1
        m += 1
    endWhile
    ; Set expression
    ActorRef.SetExpressionOverride(Preset[30] as int, (Preset[31] * 100.0) as int)
endFunction

;update expression. Only changes nodes that are different
function UpdatePresetFloats_NOMC(Actor ActorRef, float[] Preset,float[] Preset_p) global 
    int i
    ; Set Phoneme
    int p
    while p <= 15
        if Preset[i] != Preset_p[i]
            MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, (Preset[i] * 100.0) as int)
        endif
        i += 1
        p += 1
    endWhile
    ; Set Modifers
    int m
    while m <= 13
        if Preset[i] != Preset_p[i]
            MfgConsoleFunc.SetPhonemeModifier(ActorRef, 1, m, (Preset[i] * 100.0) as int)
        endif
        i += 1
        m += 1
    endWhile
    ; Set expression
    if (Preset[30] != Preset_p[30]) || (Preset[31] != Preset_p[31])
        ActorRef.SetExpressionOverride(Preset[30] as int, (Preset[31] * 100.0) as int)
    endif
endFunction

;prebuild expressions

Function UpdatePrebuildExpressions()
    _UpdatePrebuildExpression_Happy1()
    _UpdatePrebuildExpression_Concetrated1()
    _UpdatePrebuildExpression_Angry1()
    _UpdatePrebuildExpression_Tired1()
    _UpdatePrebuildExpression_Horny1()
    _UpdatePrebuildExpression_Orgasm1()
    _UpdatePrebuildExpression_Orgasm2()
    _UpdatePrebuildExpression_Orgasm3()
EndFunction

float[] loc_Expression_Happy1
Function _UpdatePrebuildExpression_Happy1()
    if !loc_Expression_Happy1
        loc_Expression_Happy1 = CreateEmptyExpression()
    endif
    ;phonems
    loc_Expression_Happy1[ 5] = 0.079
    loc_Expression_Happy1[ 6] = 0.284
    loc_Expression_Happy1[ 7] = 0.237
    loc_Expression_Happy1[ 8] = 0.055
    loc_Expression_Happy1[11] = 0.192
    loc_Expression_Happy1[13] = 0.03
    loc_Expression_Happy1[14] = 0.115
    ;modifiers
    loc_Expression_Happy1[20] = 0.104
    loc_Expression_Happy1[22] = 0.212
    loc_Expression_Happy1[23] = 0.078
    loc_Expression_Happy1[24] = 0.129
    loc_Expression_Happy1[27] = 0.108
    ;expression
    loc_Expression_Happy1[30] = 10.0
    loc_Expression_Happy1[31] = 0.729
EndFunction
Float[] Function GetPrebuildExpression_Happy1()
    return loc_Expression_Happy1
EndFunction

float[] loc_Expression_Concetrated1
Function _UpdatePrebuildExpression_Concetrated1()
    if !loc_Expression_Concetrated1
        loc_Expression_Concetrated1 = CreateEmptyExpression()
    endif
    ;phonems
    loc_Expression_Concetrated1[ 2] = 0.12
    loc_Expression_Concetrated1[ 3] = 0.24
    loc_Expression_Concetrated1[ 7] = 0.08
    loc_Expression_Concetrated1[ 8] = 0.08
    loc_Expression_Concetrated1[ 9] = 0.14
    loc_Expression_Concetrated1[14] = 0.08
    ;modifiers
    loc_Expression_Concetrated1[18] = 0.18
    loc_Expression_Concetrated1[19] = 0.29
    loc_Expression_Concetrated1[21] = 0.06
    loc_Expression_Concetrated1[22] = 0.19
    loc_Expression_Concetrated1[25] = 0.27
    loc_Expression_Concetrated1[26] = 0.26
    loc_Expression_Concetrated1[27] = 0.29
    loc_Expression_Concetrated1[29] = 0.01
    ;expression
    loc_Expression_Concetrated1[30] = 4
    loc_Expression_Concetrated1[31] = 0.59
EndFunction
Float[] Function GetPrebuildExpression_Concetrated1()
    return loc_Expression_Concetrated1
EndFunction

float[] loc_Expression_Angry1
Function _UpdatePrebuildExpression_Angry1()
    if !loc_Expression_Angry1
        loc_Expression_Angry1 = CreateEmptyExpression()
    endif
    ;phonems
    loc_Expression_Angry1[ 1] = 0.174
    loc_Expression_Angry1[ 3] = 0.122
    loc_Expression_Angry1[ 4] = 0.08
    loc_Expression_Angry1[ 6] = 0.281
    loc_Expression_Angry1[ 8] = 0.053
    loc_Expression_Angry1[ 9] = 0.004
    loc_Expression_Angry1[10] = 0.145
    loc_Expression_Angry1[11] = 0.073
    loc_Expression_Angry1[14] = 0.277
    ;modifiers
    loc_Expression_Angry1[19] = 0.144
    loc_Expression_Angry1[20] = 0.245
    loc_Expression_Angry1[21] = 0.23
    loc_Expression_Angry1[24] = 0.269
    loc_Expression_Angry1[25] = 0.067
    loc_Expression_Angry1[27] = 0.186
    loc_Expression_Angry1[28] = 0.247
    loc_Expression_Angry1[29] = 0.103
    ;expression
    loc_Expression_Angry1[30] = 14
    loc_Expression_Angry1[31] = 0.757
EndFunction
Float[] Function GetPrebuildExpression_Angry1()
    return loc_Expression_Angry1
EndFunction

float[] loc_Expression_Tired1
Function _UpdatePrebuildExpression_Tired1()
    if !loc_Expression_Tired1
        loc_Expression_Tired1 = CreateEmptyExpression()
    endif
    loc_Expression_Tired1[ 0] = 0.151
    loc_Expression_Tired1[ 1] = 0.246
    loc_Expression_Tired1[ 2] = 0.181
    loc_Expression_Tired1[ 3] = 0.226
    loc_Expression_Tired1[ 7] = 0.060
    loc_Expression_Tired1[ 8] = 0.216
    loc_Expression_Tired1[10] = 0.098
    loc_Expression_Tired1[12] = 0.122
    loc_Expression_Tired1[13] = 0.170
    loc_Expression_Tired1[14] = 0.094
    loc_Expression_Tired1[15] = 0.071
    loc_Expression_Tired1[22] = 0.213
    loc_Expression_Tired1[23] = 0.187
    loc_Expression_Tired1[25] = 0.092
    loc_Expression_Tired1[26] = 0.205
    loc_Expression_Tired1[28] = 0.274
    loc_Expression_Tired1[30] = 3.000
    loc_Expression_Tired1[31] = 0.641
EndFunction
Float[] Function GetPrebuildExpression_Tired1()
    return loc_Expression_Tired1
EndFunction

float[] loc_Expression_Horny1
Function _UpdatePrebuildExpression_Horny1()
    if !loc_Expression_Horny1
        loc_Expression_Horny1 = CreateEmptyExpression()
    endif
    loc_Expression_Horny1[10] = 0.50
    loc_Expression_Horny1[16] = 0.10
    loc_Expression_Horny1[17] = 0.10
    loc_Expression_Horny1[18] = 0.25
    loc_Expression_Horny1[19] = 0.25
    loc_Expression_Horny1[20] = 0.25
    loc_Expression_Horny1[21] = 0.25
    loc_Expression_Horny1[24] = 0.30
    loc_Expression_Horny1[25] = 0.50
    loc_Expression_Horny1[26] = 0.50
    loc_Expression_Horny1[28] = 0.25
    loc_Expression_Horny1[29] = 0.25
    loc_Expression_Horny1[30] = 13.0
    loc_Expression_Horny1[31] = 0.25
EndFunction
Float[] Function GetPrebuildExpression_Horny1()
    return loc_Expression_Horny1
EndFunction

float[] loc_Expression_Orgasm1
Function _UpdatePrebuildExpression_Orgasm1()
    if !loc_Expression_Orgasm1
        loc_Expression_Orgasm1 = CreateEmptyExpression()
    endif
    loc_Expression_Orgasm1[ 0] = 0.5
    loc_Expression_Orgasm1[11] = 0.5
    loc_Expression_Orgasm1[16] = 0.2
    loc_Expression_Orgasm1[17] = 0.2
    loc_Expression_Orgasm1[22] = 0.4
    loc_Expression_Orgasm1[23] = 0.4
    loc_Expression_Orgasm1[27] = 0.75
    loc_Expression_Orgasm1[30] = 10.0
    loc_Expression_Orgasm1[31] = 0.5
EndFunction
Float[] Function GetPrebuildExpression_Orgasm1()
    return loc_Expression_Orgasm1
EndFunction

float[] loc_Expression_Orgasm2
Function _UpdatePrebuildExpression_Orgasm2()
    if !loc_Expression_Orgasm2
        loc_Expression_Orgasm2 = CreateEmptyExpression()
    endif
    loc_Expression_Orgasm2[ 5] = 0.079
    loc_Expression_Orgasm2[ 6] = 0.284
    loc_Expression_Orgasm2[ 7] = 0.237
    loc_Expression_Orgasm2[ 8] = 0.055
    loc_Expression_Orgasm2[11] = 0.192
    loc_Expression_Orgasm2[13] = 0.030
    loc_Expression_Orgasm2[14] = 0.115
    loc_Expression_Orgasm2[16] = 0.200
    loc_Expression_Orgasm2[17] = 0.200
    loc_Expression_Orgasm2[22] = 0.400
    loc_Expression_Orgasm2[23] = 0.400
    loc_Expression_Orgasm2[27] = 0.750
    loc_Expression_Orgasm2[30] = 10.00
    loc_Expression_Orgasm2[31] = 0.729
EndFunction
Float[] Function GetPrebuildExpression_Orgasm2()
    return loc_Expression_Orgasm2
EndFunction

float[] loc_Expression_Orgasm3
Function _UpdatePrebuildExpression_Orgasm3()
    if !loc_Expression_Orgasm3
        loc_Expression_Orgasm3 = CreateEmptyExpression()
    endif
    loc_Expression_Orgasm3[ 5] = 0.079
    loc_Expression_Orgasm3[ 6] = 0.284
    loc_Expression_Orgasm3[ 7] = 0.237
    loc_Expression_Orgasm3[ 8] = 0.055
    loc_Expression_Orgasm3[11] = 0.192
    loc_Expression_Orgasm3[13] = 0.030
    loc_Expression_Orgasm3[14] = 0.115
    loc_Expression_Orgasm3[16] = 0.170
    loc_Expression_Orgasm3[17] = 0.170
    loc_Expression_Orgasm3[22] = 0.280
    loc_Expression_Orgasm3[30] = 11.00
    loc_Expression_Orgasm3[31] = 0.900
EndFunction
Float[] Function GetPrebuildExpression_Orgasm3()
    return loc_Expression_Orgasm3
EndFunction