scriptname zadexpressionlibs extends Quest

import MfgConsoleFunc
import sslBaseExpression
import PapyrusUtil

;for debuging
import ConsoleUtil

Faction         Property BlockExpressionFaction                             auto
zadlibs         Property libs                                               auto
bool            Property Ready                              = false         auto hidden

;Gag faction lists
Faction[]       Property PhonemeModifierFactions                            auto ;000801-000810
Faction[]       Property PhonemeModifierFactions_Large                      auto ;000901-000910
Faction[]       Property PhonemeModifierFactions_Ring                       auto ;000A01-000A10
Faction[]       Property PhonemeModifierFactions_Bit                        auto ;000B01-000B10
Faction[]       Property PhonemeModifierFactions_Panel                      auto ;000C01-000C10

;Default expressions
int[]           Property DefaultGagExpression_Simple                        auto
int[]           Property DefaultGagExpression_Large                         auto
int[]           Property DefaultGagExpression_Ring                          auto
int[]           Property DefaultGagExpression_Bit                           auto
int[]           Property DefaultGagExpression_Panel                         auto

;New gag keywords, they are not filled yet, as more works will be required before they can be used
Keyword         Property GagKeyword_Ring                                    auto
Keyword         Property GagKeyword_Bit                                     auto


;==============================================================================================================================
;                                           Sexlab Expression Construct Documantation
;==============================================================================================================================
;All number are floats in range 0.0-1.0
;Only exception is expression[30] where it needs whole number in range 0-16
;
;    =====================Phonems=====================
;    
;    expression[ 0] = Aah       [ 0.0 , 1.0 ]
;    expression[ 1] = BigAah    [ 0.0 , 1.0 ]
;    expression[ 2] = BMP       [ 0.0 , 1.0 ]
;    expression[ 3] = ChJSh     [ 0.0 , 1.0 ]
;    expression[ 4] = DST       [ 0.0 , 1.0 ]
;    expression[ 5] = Eee       [ 0.0 , 1.0 ]
;    expression[ 6] = Eh        [ 0.0 , 1.0 ]
;    expression[ 7] = FV        [ 0.0 , 1.0 ]
;    expression[ 8] = I         [ 0.0 , 1.0 ]
;    expression[ 9] = K         [ 0.0 , 1.0 ]
;    expression[10] = N         [ 0.0 , 1.0 ]
;    expression[11] = Oh        [ 0.0 , 1.0 ]
;    expression[12] = OohQ      [ 0.0 , 1.0 ]
;    expression[13] = R         [ 0.0 , 1.0 ]
;    expression[14] = Th        [ 0.0 , 1.0 ]
;    expression[15] = W         [ 0.0 , 1.0 ]
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
;    expression[30] =        X: Selected expression, see below [ 0 , 16 ]
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
;                        16: Combat Shout - this opens mouth like phoneme, try to not use this unless you have good reason
;    expression[31] = Strength of choosen expression (expression[30]) [ 0.0 , 1.0 ]
;==============================================================================================================================
;==============================================================================================================================



;==============================================================================================================================
;==============================================================================================================================
;                                                            API                                                               
;==============================================================================================================================
;==============================================================================================================================

;    Int      Round(Float afValue)                                                                                global
;    float[]  CreateEmptyExpression()                                                                             global
;    float[]  GetCurrentExpression(Actor akActor)                                                                 global
;
;    bool     ApplyExpression(Actor akActor, sslBaseExpression akExpression, int aiStrength, bool abOpenMouth=false,int aiPriority = 0)
;    bool     ApplyExpressionRaw(Actor akActor, float[] apExpression, int aiStrength, bool abOpenMouth=false,int aiPriority = 0)
;    bool     ResetExpression(actor akActor, sslBaseExpression akExpression,int aiPriority = 0)
;    bool     ResetExpressionRaw(actor akActor, int aiPriority = 0)
;
;             SetExpressionPhonems(float[] apExpression,float[] apPhonems)                                        global
;             ResetExpressionPhonems(float[] apExpression)                                                        global
;             SetExpressionModifiers(float[] apExpression,float[] apModifiers)                                    global
;             SetExpressionExpression(float[] apExpression,int aiExpression_type,int aiExpression_strength)       global
;    Float[]  CreateRandomExpression()                                                                            global
;    float[]  ApplyStrentghToExpression(float[] apExpression,int aiStrength)                                      global
;    bool     CompareExpressions(Float[] apExpression1, Float[] apExpression2)                                    global
;             ApplyGagEffect(actor akActor)
;             RemoveGagEffect(actor akActor)

string property DefaultGagExpFile hidden
    string function get()
        return "../DD/GagExpressions/DefaultExp.json"
    endFunction
endProperty

;round float number and returns int
Int Function Round(Float afValue) global
    return Math.Floor(afValue + 0.5)
EndFunction

;returns empty expression float array
float[] Function CreateEmptyExpression() global
    return new float[32]
EndFunction

;returns current actor expression, it is only wrapper for sexlab function GetCurrentMFG
float[] Function GetCurrentExpression(Actor akActor) global
    return GetCurrentMFG(akActor)
EndFunction

;API function for applying expression on actor
;        =Arguments=
;akActor            = actor to process
;akExpression       = sexlab expression which will be applied
;aiStrength         = strength which will be used to modify expression. Range 1-100
;abOpenMouth        = if true, will edit phonems to open mouth little
;aiPriority         = expression priority. This needs to be bigger that already applied expression, otherwise expression will not applied
;        =Return value=
;Return true in case that expression was successfully applied
bool Function ApplyExpression(Actor akActor, sslBaseExpression akExpression, int aiStrength, bool abOpenMouth=false,int aiPriority = 0)
    if !libs.IsValidActor(akActor)
        libs.Log("ApplyExpressionPatched(): Actor is not loaded (Or is otherwise invalid). Aborting.")
        return false
    EndIf
    if !akExpression
        libs.Log("ApplyExpressionPatched(): Expression is none.")
        return false
    EndIf

    StartExpressionMutex(akActor)

    if !CheckExpressionBlock(akActor,aiPriority,1)
        EndExpressionMutex(akActor)
        return false
    endif

    SetExpression(akActor,akExpression,aiStrength,abOpenMouth)

    EndExpressionMutex(akActor)

    return true
EndFunction

;API function for applying expression on actor
;        =Arguments=
;akActor            = actor to process
;apExpression       = raw expression construct. See documantation at the top of this script. You can also use prebuilded expressions from zadprebuildedexpressions
;aiStrength         = strength which will be used to modify expression. Range 1-100
;abOpenMouth        = if true, will edit phonems to open mouth little
;aiPriority         = expression priority. This needs to be bigger that already applied expression, otherwise expression will not applied
;        =Return value=
;Return true in case that expression was successfully applied
bool Function ApplyExpressionRaw(Actor akActor, float[] apExpression, int aiStrength, bool abOpenMouth=false,int aiPriority = 0)
    if !libs.IsValidActor(akActor)    
        libs.Log("ApplyExpressionRaw(): Actor is not loaded (Or is otherwise invalid). Aborting.")
        return false
    EndIf
    if !apExpression
        libs.Log("ApplyExpressionRaw(): Expression is none.")
        return false
    EndIf
    if apExpression.length != 32
        libs.Log("ApplyExpressionRaw(): Expression is not size 32!")
        return false
    EndIf

    StartExpressionMutex(akActor)

    if !CheckExpressionBlock(akActor,aiPriority,1)
        EndExpressionMutex(akActor)
        return false
    endif

    SetExpressionRaw(akActor,apExpression,aiStrength,abOpenMouth)

    EndExpressionMutex(akActor)

    return true
EndFunction

;API function for reseting expression on actor
;        =Arguments=
;akActor           = actor to process
;akExpression      = UNUSED. Pass in none or call ResetExpressionRaw()
;aiPriority        = expression priority. This needs to be bigger that already applied expression, otherwise expression will not removed
;        =Return value=
;Return true in case that expression was successfully removed
bool Function ResetExpression(actor akActor, sslBaseExpression akExpression,int aiPriority = 0)
    return ResetExpressionRaw(akActor, aiPriority)
EndFunction

;API function for reseting expression on actor
;        =Arguments=
;akActor           = actor to process
;aiPriority        = expression priority. This needs to be bigger that already applied expression, otherwise expression will not removed
;        =Return value=
;Return true in case that expression was successfully removed
bool Function ResetExpressionRaw(actor akActor, int aiPriority = 0)
    StartExpressionMutex(akActor)

    if !CheckExpressionBlock(akActor,aiPriority,1)
        EndExpressionMutex(akActor)
        return false
    endif

    if !akActor.WornHasKeyword(libs.zad_DeviousGag)
        MfgConsoleFunc.SetPhonemeModifier(akActor, -1, 0, 0)
        akActor.ClearExpressionOverride()
    else
        ResetPresetFloats_NOMC(akActor,false,true)
    endif
    akActor.SetFactionRank(BlockExpressionFaction,0)

    EndExpressionMutex(akActor)
    return true
EndFunction

;edits passed apExpression phonems with apPhonems
Function SetExpressionPhonems(float[] apExpression,float[] apPhonems) global
    if apExpression.length != 32
        return ;expression can only have length 32!
    endif
    if apPhonems.length != 16
        return ;phonems can only have length 16!
    endif
    int loc_i = 0
    while loc_i < 16
        apExpression[loc_i] = ClampFloat(apPhonems[loc_i],0.0,1.0)
        loc_i += 1
    endWhile
EndFunction

;resets phonems from passed apExpression
Function ResetExpressionPhonems(float[] apExpression) global
    if apExpression.length != 32
        return ;expression can only have length 32!
    endif
    int loc_i = 0
    while loc_i < 16
        apExpression[loc_i] = 0.0
        loc_i += 1
    endWhile
EndFunction

;edits passed apExpression modifiers with apModifiers
Function SetExpressionModifiers(float[] apExpression,float[] apModifiers) global
    if apExpression.length != 32
        return ;expression can only have length 32!
    endif
    if apModifiers.length != 14
        return ;modifiers can only have length 14!
    endif
    int loc_i = 16
    int loc_x = 0
    while loc_i < 30
        apExpression[loc_i] = ClampFloat(apModifiers[loc_x],0.0,1.0)
        loc_i += 1
        loc_x += 1
    endWhile
EndFunction

;edits passed apExpression expression with aiExpression_type and aiExpression_strength
Function SetExpressionExpression(float[] apExpression,int aiExpression_type,int aiExpression_strength) global
    if apExpression.length != 32
        return ;expression can only have length 32!
    endif
    apExpression[30] = ClampInt(aiExpression_type,0,16)
    apExpression[31] = ClampFloat(aiExpression_strength,0.0,1.0)
EndFunction

;returns randomly created expression
;sometimes look stupid, other times look good. Depends on luck :)
Float[] Function CreateRandomExpression() global
    float[] loc_expression      = CreateEmptyExpression()
    string  loc_strres          = ""
    int     loc_i               = 0

    while loc_i < loc_expression.length - 2
        loc_expression[loc_i] = Utility.randomFloat(0.0,0.3)*Utility.randomInt(0,1)
        loc_i += 1
    endwhile

    loc_expression[loc_expression.length - 2] = Utility.randomInt(0,15) ;don't choose Combat shout, it looks stoopid
    loc_expression[loc_expression.length - 1] = Utility.randomFloat(0.0,1.0)

    return loc_expression
EndFunction

;apply strentgh on to expression. Returns new expression
;in case of failure, returns empty expression
float[] Function ApplyStrentghToExpression(float[] apExpression,int aiStrength) global
    if apExpression.length != 32
        return CreateEmptyExpression() ;expression can only have length 32!
    endif

    float[] loc_expression          = CreateEmptyExpression()
    float   loc_strength            = ClampFloat(aiStrength/100.0,0.0,1.0)
    int     loc_i                   = 0

    while loc_i < 30
        loc_expression[loc_i] = apExpression[loc_i]*loc_strength
        loc_i += 1
    endWhile

    loc_expression[30] = apExpression[30]
    loc_expression[31] = apExpression[31]*loc_strength

    return loc_expression
EndFunction

;compare passed expressions. Returns True if they are same, otherwise returns false
bool Function CompareExpressions(Float[] apExpression1, Float[] apExpression2, bool abPhoneme = true, bool abExpressionMod = true) global
    if apExpression1 != apExpression2
        ;they can still be same, but only with difference caused by float inaccuracy
        int i       = 0
        int i_max   = 30

        ;skip phonemes
        if !abPhoneme
            i = 16
        endif

        ;skip expression
        if !abExpressionMod
            i_max = 16
        else
            if Round(apExpression1[30]) != Round(apExpression2[30])
                return false
            endif
            if Round(apExpression1[31]*100) != Round(apExpression2[31]*100)
                return false
            endif
        endif

        ;process
        while i < i_max
            if Round(apExpression1[i] * 100.0) != Round(apExpression2[i] * 100.0)
                return false
            endif
            i += 1
        endWhile
        return true ;expressions are same
    else
        return true ;expressions are same
    endif
EndFunction

;check current gag state and update phonems 
Function ApplyGagEffect(actor akActor)    
    if akActor.Is3DLoaded() || akActor == Game.getPlayer()
        ;Check custom gag expressions first before mutex is applied
        If akActor.WornHasKeyword(libs.zad_GagCustomExpression)
            libs.SendGagEffectEvent(akActor, false)
            return
        endif

        StartExpressionMutex(akActor)
        float[] loc_appliedExpression      = GetCurrentMFG(akActor)
        float[] loc_expression             = ApplyGagEffectToPreset(akActor,loc_appliedExpression)

        if loc_expression != loc_appliedExpression
            UpdatePresetFloats_NOMC(akActor, loc_expression,loc_appliedExpression)
        endif
        EndExpressionMutex(akActor)
    endif
EndFunction

;check current gag state and update phonemes 
Function ApplyGagEffect_v2(actor akActor,Int[] apGagPreset,Faction[] apGagModFactions)
    if !akActor
        return
    endif
    if !apGagPreset
        return
    endif
    if akActor.Is3DLoaded() || akActor == Game.getPlayer()
        StartExpressionMutex(akActor)
        float[] loc_appliedExpression      = GetCurrentMFG(akActor)
        float[] loc_expression             = ProcessGagEffectToPreset(akActor, apGagPreset,apGagModFactions)
        if !CompareExpressions(loc_expression,loc_appliedExpression,true,false)
            UpdatePresetFloats_NOMC(akActor, loc_expression,loc_appliedExpression,true,false)
        endif
        EndExpressionMutex(akActor)
    endif
EndFunction

;check current gag state and remove phonems
Function RemoveGagEffect(actor akActor)
    If akActor.WornHasKeyword(libs.zad_GagCustomExpression)
        libs.SendGagEffectEvent(akActor, false)
        Return
    EndIf
    StartExpressionMutex(akActor)
    ResetPresetFloats_NOMC(akActor,true,false)
    EndExpressionMutex(akActor)
EndFunction

;==============================================================================================================================
;==============================================================================================================================
;                                               INTERNAL FUNCTIONS, DO NOT USE
;==============================================================================================================================
;==============================================================================================================================

Event OnInit()
    Utility.waitMenuMode(2.5)
    RegisterForSingleupdate(10.0)
    libs.ExpLibs = self ;set lib when installing mod. Made for compatiblity between indev version and beta version
    Ready = true
EndEvent

Event OnUpdate()
    Maintenance()
    RegisterForSingleupdate(25.0)
EndEvent

Function Maintenance()
    ;currently unused
EndFunction

;check expression blocking with priority
;mode 1 = sets blocking if priority is met
;mode 2 = resets blocking if priority is met
bool Function CheckExpressionBlock(Actor akActor,int aiPriority, int aiMode = 0)
    if !akActor.isInFaction(BlockExpressionFaction)
        if aiMode == 1
            akActor.AddToFaction(BlockExpressionFaction)
            akActor.SetFactionRank(BlockExpressionFaction,aiPriority)
        endif
        return true
    endif

    if aiPriority >= akActor.GetFactionRank(BlockExpressionFaction)
        if aiMode == 1 ;set blocking priority
            if aiPriority >= akActor.GetFactionRank(BlockExpressionFaction)
                akActor.SetFactionRank(BlockExpressionFaction,aiPriority)
                return true
            else
                return false
            endif
        elseif aiMode == 2 ;reset blocking priority
            akActor.SetFactionRank(BlockExpressionFaction,0)
        endif
        return true
    else
        return false
    endif
EndFunction

bool _ExpressionManip_Mutex = false ;expression mutex variable
;start expression mutex. Will block thread in case that expression manipulation is already being proccessed
Function StartExpressionMutex(Actor akActor)
    while StorageUtil.GetIntValue(akActor,"zadExpMutex",0)
        Utility.waitMenuMode(0.5)
    endwhile
    StorageUtil.SetIntValue(akActor,"zadExpMutex",1)
EndFunction

;reset expression mutex
Function EndExpressionMutex(Actor akActor)
    _ExpressionManip_Mutex = false ;turn off old mutex, so it is compatible with previous version
    StorageUtil.UnsetIntValue(akActor,"zadExpMutex")
EndFunction

;internal function for setting expression. Do not call
Function SetExpression(Actor akActor, sslBaseExpression akExpression, int aiStrength, bool aiOpenMouth=false)
    int     loc_gender                     = (akActor.GetBaseObject() as ActorBase).GetSex()
    bool    loc_hasGag                     = akActor.WornHasKeyword(libs.zad_DeviousGag)
    bool    loc_applyPhonems               = true
    ;yes, the strength is actually not applied, even when its passed in CalcPhase :)
    float[] loc_expression                 = ApplyStrentghToExpression(akExpression.GenderPhase(akExpression.CalcPhase(aiStrength, loc_gender), loc_gender),aiStrength)
    float[] loc_appliedExpression          = GetCurrentMFG(akActor) 

    if loc_hasGag
        loc_applyPhonems = false
    elseif aiOpenMouth
        loc_expression[akExpression.Phoneme + 0] = 0.75
    endif

    if !CompareExpressions(loc_expression,loc_appliedExpression,loc_applyPhonems)
        UpdatePresetFloats_NOMC(akActor, loc_expression,loc_appliedExpression,loc_applyPhonems)
    endif
EndFunction

;internal function for setting expression. Do not call
Function SetExpressionRaw(Actor akActor, float[]  apExpression, int aiStrength, bool aiOpenMouth=false)
    bool     loc_hasGag                 = akActor.WornHasKeyword(libs.zad_DeviousGag)
    float[] loc_expression              = ApplyStrentghToExpression(apExpression,aiStrength)
    float[] loc_appliedExpression       = GetCurrentMFG(akActor)

    bool loc_applyPhonems = true
    if loc_hasGag
        loc_applyPhonems = false
    elseif aiOpenMouth
        loc_expression[0] = 0.75
    endif

    if !CompareExpressions(loc_expression,loc_appliedExpression,loc_applyPhonems)
        UpdatePresetFloats_NOMC(akActor, loc_expression,loc_appliedExpression,loc_applyPhonems)
    endif
EndFunction

;internal function for applying phonems to expression
float[] Function ApplyGagEffectToPreset(Actor akActor,Float[] apPreset)
    float[] loc_preset = CreateEmptyExpression()

    int i = apPreset.length
    while i > 15 ;do not copy phonems
        i -= 1
        loc_preset[i] = apPreset[i]
    endwhile

    ; apply this affect to actual gags only, not hoods that also share this keyword.
    if akActor.WornHasKeyword(libs.zad_GagNoOpenMouth)
        ;close mouth, reset phonems
        return loc_preset
    elseIf akActor.WornHasKeyword(libs.zad_DeviousGagLarge)
        ApplyGagModifiers(akActor,loc_preset,PhonemeModifierFactions_Large,DefaultGagExpression_Large)
    elseif akActor.wornhaskeyword(libs.zad_DeviousGagPanel)
        ApplyGagModifiers(akActor,loc_preset,PhonemeModifierFactions_Panel,DefaultGagExpression_Panel)
    elseif GagKeyword_Ring && akActor.wornhaskeyword(GagKeyword_Ring)   ;Ring gag
        ApplyGagModifiers(akActor,loc_preset,PhonemeModifierFactions_Ring,DefaultGagExpression_Ring)
    elseif GagKeyword_Bit && akActor.wornhaskeyword(GagKeyword_Bit)     ;Bit gag
        ApplyGagModifiers(akActor,loc_preset,PhonemeModifierFactions_Bit,DefaultGagExpression_Bit)
    else
        ApplyGagModifiers(akActor,loc_preset,PhonemeModifierFactions,DefaultGagExpression_Simple)
    EndIf

    ;prevent Combat shout expression as it makes gag looking worse
    if loc_preset[30] == 16
        loc_preset[31] = 0
    endif

    return loc_preset
EndFunction

;internal function for applying phonems to expression
float[] Function ProcessGagEffectToPreset(Actor akActor, Int[] apGagPreset,Faction[] apGagModFactions)
    float[] loc_preset = CreateEmptyExpression()

    ;no phonemes when keyword  zad_GagNoOpenMouth is present
    if !akActor.wornhaskeyword(libs.zad_GagNoOpenMouth)
        int loc_i = 0
        while loc_i < 16
            int loc_mod = -1
            if apGagModFactions
                loc_mod = ClampInt(akActor.GetFactionRank(apGagModFactions[loc_i]),-1,100)
            endif
            if loc_mod >= 0    
                loc_preset[loc_i] = loc_mod/100.0 ;Mod set.
            else
                loc_preset[loc_i] = apGagPreset[loc_i]/100.0 ;default value
            endif
            loc_i += 1
        endwhile
    endif

    ;prevent Combat shout expression as it makes gag looking worse
    if loc_preset[30] == 16
        loc_preset[31] = 0
    endif

    return loc_preset
EndFunction

;applies gag modifiers to passed expression
;apGagFactions and apDefaultValues should have same length
Function ApplyGagModifiers(Actor akActor, Float[] apExpression, Faction[] apGagFactions, Int[] apDefaultValues)
    int loc_mods = apGagFactions.length    
    int loc_i = 0        
    while loc_i < loc_mods
        int loc_mod = ClampInt(akActor.GetFactionRank(apGagFactions[loc_i]),-1,100)
        if loc_mod >= 0    
            apExpression[loc_i] = loc_mod/100.0 ;Mod set.
        else
            apExpression[loc_i] = apDefaultValues[loc_i]/100.0 ;default value
        endif
        loc_i += 1
    endwhile
EndFunction

;Internal function for actually changing expression. Requires Mfg console!
;COPIED FROM sslBaseExpression because it will otherwise not work for SE because of MouthOpen check 
function ApplyPresetFloats_NOMC(Actor ActorRef, float[] apPreset, bool abPhoneme = true,bool abExpressionMod = true) global 
    int i = 0
    if abPhoneme
        ; Set Phoneme
        int p
        while p <= 15
            MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, Round(apPreset[i] * 100.0))
            i += 1
            p += 1
        endWhile
    else
        i = 16
    endif
    if abExpressionMod
        ; Set Modifers
        int m
        while m <= 13
            MfgConsoleFunc.SetPhonemeModifier(ActorRef, 1, m, Round(apPreset[i] * 100.0))
            i += 1
            m += 1
        endWhile
        ; Set expression
        ActorRef.SetExpressionOverride(Round(apPreset[30]), Round(apPreset[31] * 100.0))
    endif
endFunction

;Internal function for actually changing expression. Requires Mfg console!
;update expression. Only changes nodes that are different
function UpdatePresetFloats_NOMC(Actor ActorRef, float[] apPreset,float[] apPreset_p, bool abPhoneme = true,bool abExpressionMod = true) global 
    int i = 0
    if abPhoneme
        ; Set Phoneme
        int p = 0
        while p <= 15
            if Round(apPreset[i]*100) != Round(apPreset_p[i]*100) ;round the value, as float is inaccurate
                MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, Round(apPreset[i] * 100.0))
            endif
            i += 1
            p += 1
        endWhile
    else
        i = 16
    endif
    if abExpressionMod
        ; Set Modifers
        int m = 0
        while m <= 13
            if Round(apPreset[i]*100) != Round(apPreset_p[i]*100) ;round the value, as float is inaccurate
                MfgConsoleFunc.SetPhonemeModifier(ActorRef, 1, m, Round(apPreset[i] * 100.0))
            endif
            i += 1
            m += 1
        endWhile
        ; Set expression
        if (Round(apPreset[30]) != Round(apPreset_p[30])) || (Round(apPreset[31]) != Round(apPreset_p[31])) ;round the value, as float is inaccurate
            ActorRef.SetExpressionOverride(Round(apPreset[30]), Round(apPreset[31] * 100.0))
        endif
    endif
endFunction

;Internal function for reseting expression. Requires Mfg console!
function ResetPresetFloats_NOMC(Actor akActor, bool abPhoneme = true,bool abExpressionMod = true) global 
    if abPhoneme
        ;ReSet Phoneme
        int p = 0
        while p <= 15
            MfgConsoleFunc.SetPhonemeModifier(akActor, 0, p, 0)
            p += 1
        endWhile
    endif
    if abExpressionMod
        ;ReSet Modifers
        int m = 0
        while m <= 13
            MfgConsoleFunc.SetPhonemeModifier(akActor, 1, m, 0)
            m += 1
        endWhile
        ;ReSet expression
        akActor.ClearExpressionOverride()
    endif
endFunction

Int[] Function LoadGagExpFromJSON(String asFilePath,string asFlag = "DefaultGagExpression")
    if JsonUtil.IntListCount(asFilePath, asFlag) == 16
        return JsonUtil.IntListToArray(asFilePath, asFlag)
    endIf
    return new Int[16]
EndFunction