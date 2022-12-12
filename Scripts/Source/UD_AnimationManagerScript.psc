Scriptname UD_AnimationManagerScript extends Quest

import UnforgivingDevicesMain

;============================================================
;========================PROPERTIES==========================
;============================================================

;==========;
;==AUTO====;
;==========;
Bool                                   Property     Ready         = false   auto    hidden
UnforgivingDevicesMain                 Property     UDmain                  auto
UD_CustomDevices_NPCSlotsManager       Property     UDCD_NPCM               auto
zadlibs                                Property     libs                    auto
Faction                                Property     ZadAnimationFaction     auto
Faction                                Property     SexlabAnimationFaction  auto
sslSystemConfig                        Property     slConfig                Auto
{SexLab Config to check NiOverride}
Static                                 Property     VehicleMarkerForm       Auto
{XMarker Static to place vehicle marker for animating actors}

; array with all found json files
String[]                               Property     UD_AnimationJSON_All    Auto    Hidden
; array with files disabled by load condition
String[]                               Property     UD_AnimationJSON_Inv    Auto    Hidden
; array with files disabled by user
String[]                               Property     UD_AnimationJSON_Dis    Auto    Hidden
; array with currently used files
String[]                               Property     UD_AnimationJSON        Auto    Hidden

; Animation playback settings moved from UDMain
Bool                                   Property     UD_AlternateAnimation       = False     Auto    Hidden
Float                                  Property     UD_AlternateAnimationPeriod = 5.0       Auto    Hidden

;==========;                                                                           
;==MANUAL==;                                                                           
;==========;                                                                           
zadlibs_UDPatch                        Property     libsp                           hidden
    zadlibs_UDPatch Function get()
        return libs as zadlibs_UDPatch
    EndFunction
EndProperty

;------------local variables-------------------

; reload json files before every use
Bool forceReloadFiles = False
; enable checking the "force" flag of animation
Bool enableForcedFlag = False
; print full array of found animations (may lead to CTD)
Bool useUnsafeLogging = False

;============================================================
;========================FUNCTIONS===========================
;============================================================

Function OnInit()
    RegisterForSingleUpdate(5.0)
    Ready = True
EndFunction

Function OnUpdate()
    Update()
EndFunction

Function Update()

    LoadAnimationJSONFiles()
    
;    _Benchmark()
    
    forceReloadFiles = False
    enableForcedFlag = False
    useUnsafeLogging = False
EndFunction

; Prepare actor and start an animation sequence for it. The sequence is scrolled to the last element, which remains active until the animation stops from the outside
; Used to play any animation even from the middle of the sequence.
; akActor        - actor
; aAnimation     - animation sequence (array of animation events) for the actor
; return         - true if OK
Bool Function StartSoloAnimationSequence(Actor akActor, String[] aAnimation, Bool bContinueAnimation = False)
    If (aAnimation.Length == 0 || aAnimation[0] == "" || aAnimation[0] == "none")
        UDmain.Warning("UD_AnimationManagerScript::StartSoloAnimationSequence() Called animation is None, aborting")
        Return False
    EndIf
    If !bContinueAnimation
        LockAnimatingActor(akActor)
    EndIf
    ; in case it called just after paired animation (for example, during orgasm ending)
    akActor.SetVehicle(None)

    Int a_index = 0
    While a_index < aAnimation.Length
        Debug.SendAnimationEvent(akActor, aAnimation[a_index])
        a_index += 1
        If a_index < aAnimation.Length 
            Utility.Wait(0.05)
        EndIf
    EndWhile
    
    If !bContinueAnimation
        ; unequipping the shield again after starting the animation
        If StorageUtil.HasFormValue(akActor, "UD_EquippedShield")
            akActor.UnequipItemSlot(39)
        EndIf
    EndIf
    Return True
EndFunction

; Shortcut of StartSoloAnimationSequence for single animation
Bool Function StartSoloAnimation(Actor akActor, String sAnimation, Bool bContinueAnimation = False)
    String[] aAnimation = new String[1]
    aAnimation[0] = sAnimation
    Return StartSoloAnimationSequence(akActor, aAnimation, bContinueAnimation)
EndFunction

; Function to stop animation and unlock actor(s)
Function StopAnimation(Actor akActor, Actor akHelper = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::EndAnimation() akActor = " + akActor + ", akHelper = " + akHelper, 3)
    EndIf
    UnlockAnimatingActor(akActor)
    ; restoring HH if it was removed in StartPairAnimation
    _RestoreHeelEffect(akActor)
    Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
    If akHelper != None
        UnlockAnimatingActor(akHelper)
        ; restoring HH if it was removed in StartPairAnimation
        _RestoreHeelEffect(akHelper)
        Debug.SendAnimationEvent(akHelper, "IdleForceDefaultState")
    EndIf
EndFunction

;copied from zadlibs
; check if actor is in animation
Bool Function IsAnimating(Actor akActor, Bool abBonusCheck = True)
    if abBonusCheck
        if (akActor.GetSitState() != 0) || akActor.IsOnMount()
            return True
        endif
    endif
    return (akActor.IsInFaction(ZadAnimationFaction) || akActor.IsInFaction(SexlabAnimationFaction))
EndFunction

; Prepare actors and start an animation sequence for them. The sequence is scrolled to the last element, which remains active until the animation stops from the outside
; Used to play any animation even from the middle of the sequence.
; akActor               - first actor
; akHelper              - second actor (helper)
; aAnimationA1          - animation sequence (array of animation events) for the first actor
; aAnimationA2          - animation sequence (array of animation events) for the second actor (helper)
; bAlignActors          - should actors be aligned
; bContinueAnimation    - if actor have been locked already
; bInterruptSequence    - if previous animation was from a sequence
; return                - true if OK
Bool Function StartPairAnimationSequence(Actor akActor, Actor akHelper, String[] aAnimationA1, String[] aAnimationA2, Bool bAlignActors = True, Bool bContinueAnimation = False)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::StartPairAnimationSequence() akActor = " + akActor + ", akHelper = " + akHelper + ", aAnimationA1 = " + aAnimationA1 + ", animationA2 = " + aAnimationA2 + ", alignActors = " + bAlignActors + ", bContinueAnimation = " + bContinueAnimation, 3)
    EndIf
    If akActor == None 
        UDmain.Error("UD_AnimationManagerScript::StartPairAnimationSequence() akActor is None, aborting")
        Return False
    EndIf
    If akHelper == None
        Return StartSoloAnimationSequence(akActor, aAnimationA1)
    EndIf
    Bool a1_is_none = (aAnimationA1.Length == 0 || aAnimationA1[0] == "" || aAnimationA1[0] == "none")
    Bool a2_is_none = (aAnimationA2.Length == 0 || aAnimationA2[0] == "" || aAnimationA2[0] == "none")
    If a1_is_none && a2_is_none
        UDmain.Error("UD_AnimationManagerScript::StartPairAnimationSequence() animations is None, aborting")
        Return False
    ElseIf a1_is_none
        UDmain.Log("UD_AnimationManagerScript::StartPairAnimationSequence() animation for Actor 1 is None, using solo animation for the Actor 2")
        Return StartSoloAnimation(akHelper, aAnimationA2)
    ElseIf a2_is_none
        UDmain.Log("UD_AnimationManagerScript::StartPairAnimationSequence() animation for Actor 2 is None, using solo animation for the Actor 1")
        Return StartSoloAnimation(akActor, aAnimationA1)
    EndIf
    
    If !bContinueAnimation
        ; locking actors
        LockAnimatingActor(akActor)
        LockAnimatingActor(akHelper)
        ; removing HH
        _RemoveHeelEffect(akActor)
        _RemoveHeelEffect(akHelper)
    EndIf
    
    ObjectReference vehicleMarkerRef = None
    If !bContinueAnimation && bAlignActors
        ;creating vehicle marker once for each akActor
        vehicleMarkerRef = StorageUtil.GetFormValue(akActor, "UD_AnimationManager_VehicleMarker") as ObjectReference
        If (vehicleMarkerRef == None)
            vehicleMarkerRef = akActor.PlaceAtMe(VehicleMarkerForm)
            Int cycle
            While !vehicleMarkerRef.Is3DLoaded() && cycle < 20
                Utility.Wait(0.05)
                cycle += 1
            EndWhile
            StorageUtil.SetFormValue(akActor, "UD_AnimationManager_VehicleMarker", vehicleMarkerRef)
        EndIf
        ; moving marker to the first actor
        vehicleMarkerRef.MoveTo(akActor)
        vehicleMarkerRef.Enable()
        
        akHelper.MoveTo(vehicleMarkerRef)
        akActor.MoveTo(vehicleMarkerRef)
        
        akActor.SetVehicle(vehicleMarkerRef)
        akHelper.SetVehicle(vehicleMarkerRef)
        
        akActor.StopTranslation()
        akHelper.StopTranslation()
    EndIf

    Int seq_length = aAnimationA1.Length
    If seq_length < aAnimationA2.Length
        seq_length = aAnimationA2.Length
    EndIf
    Int index_a1 = aAnimationA1.Length - seq_length
    Int index_a2 = aAnimationA2.Length - seq_length
    While index_a1 < aAnimationA1.Length && index_a2 < aAnimationA2.Length
        ; sending animation events
        If index_a1 >= 0
            Debug.SendAnimationEvent(akActor, aAnimationA1[index_a1])
        EndIf
        If index_a2 >= 0
            Debug.SendAnimationEvent(akHelper, aAnimationA2[index_a2])
        EndIf
        index_a1 += 1
        index_a2 += 1
        If index_a1 < aAnimationA1.Length && index_a2 < aAnimationA2.Length 
            Utility.Wait(0.05)
        EndIf
    EndWhile
    
    If !bContinueAnimation && bAlignActors
        akHelper.MoveTo(vehicleMarkerRef)
        akActor.MoveTo(vehicleMarkerRef)
        
        akActor.SetVehicle(vehicleMarkerRef)
        akHelper.SetVehicle(vehicleMarkerRef)
        
        akActor.TranslateToRef(vehicleMarkerRef, 200.0)
        akHelper.TranslateToRef(vehicleMarkerRef, 200.0)
    EndIf
    
    If !bContinueAnimation
        ; unequipping the shield again after starting the animation
        If StorageUtil.HasFormValue(akActor, "UD_EquippedShield")
            akActor.UnequipItemSlot(39)
        EndIf
        If StorageUtil.HasFormValue(akHelper, "UD_EquippedShield")
            akHelper.UnequipItemSlot(39)
        EndIf
    EndIf
    
    Return True
EndFunction

; Shortcut for StartPairAnimationSequence with single animation events
Bool Function StartPairAnimation(Actor akActor, Actor akHelper, String sAnimationA1, String sAnimationA2, Bool bAlignActors = True, Bool bContinueAnimation = False)
    String[] aAnimationA1 = new String[1]
    aAnimationA1[0] = sAnimationA1
    String[] aAnimationA2 = new String[1]
    aAnimationA2[0] = sAnimationA2
    Return StartPairAnimationSequence(akActor, akHelper, aAnimationA1, aAnimationA2, bAlignActors, bContinueAnimation)
EndFunction

; Function to lock actor to perform in animation
Function LockAnimatingActor(Actor akActor)
    
    If IsAnimating(akActor)
        Return
    EndIf
    
    libs.SetAnimating(akActor, True)

    
    If UDmain.ActorIsPlayer(akActor)

    Else
        ActorUtil.AddPackageOverride(akActor, slConfig.DoNothing, 100, 1)
        akActor.EvaluatePackage()
        akActor.SetDontMove(true)
    EndIf
    
    Armor shield = akActor.GetEquippedShield()
    If shield
        StorageUtil.SetFormValue(akActor, "UD_EquippedShield", shield)
        akActor.UnequipItemSlot(39)
    Else
        StorageUtil.UnsetFormValue(akActor, "UD_EquippedShield")
    EndIf
    
    if akActor.IsWeaponDrawn()
        akActor.SheatheWeapon()
        ; Wait for users with flourish sheathe animations.
        int timeout=0
        while akActor.IsWeaponDrawn() && timeout <= 70 ;  Wait 3.5 seconds at most before giving up and proceeding.
            Utility.Wait(0.05)
            timeout += 1
        EndWhile
    EndIf
    

EndFunction

; Function to unlock actor after animation
Function UnlockAnimatingActor(Actor akActor)

    libs.SetAnimating(akActor, False)

    If UDmain.ActorIsPlayer(akActor)
        ; should it be done via some UD wrapper?
        libs.UpdateControls()
    Else
        ActorUtil.RemovePackageOverride(akActor, slConfig.DoNothing)
        akActor.EvaluatePackage()
        akActor.SetDontMove(False)
    EndIf
    akActor.SetVehicle(None)
    
    If StorageUtil.HasFormValue(akActor, "UD_EquippedShield")
        If UDmain.ActorIsPlayer(akActor)
            Armor shield = StorageUtil.GetFormValue(akActor, "UD_EquippedShield") as Armor
            If shield
                akActor.EquipItem(akActor, shield)
            EndIf
        Else
            ; if akActor is a NPC lets hope it has enough AI to equip shield
            ; because I don't want to check its outfit for having shiled.
        EndIf
        StorageUtil.UnsetFormValue(akActor, "UD_EquippedShield")
    EndIf

EndFunction

; Function to start animation according to the specified definition from json
; sAnimDef                  animation definition from json, should be in format <file_name>:<path_in_file>
; akActors                  actors who will participate
; bContinueAnimation        flag that the animation continues with already locked actors
Bool Function PlayAnimationByDef(String sAnimDef, Actor[] aakActors, Bool bContinueAnimation = False)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::PlayAnimationByDef() sAnimDef = " + sAnimDef + ", aakActors = " + aakActors + ", bContinueAnimation = " + bContinueAnimation, 3)
    EndIf
    
    Int part_index = StringUtil.Find(sAnimDef, ":")
    If part_index < 0 
        UDMain.Error("UD_AnimationManagerScript::PlayAnimationByDef() AnimDef has invalid format (should be <file_name>:<path_in_file>): " + sAnimDef)
        Return False
    EndIf
    String file = "UD/Animations/" + StringUtil.Substring(sAnimDef, 0, part_index)
    String path = StringUtil.Substring(sAnimDef, part_index + 1)
    String[] actor_animVars = PapyrusUtil.StringArray(aakActors.Length)
    
    Int k = 0
    While k < aakActors.Length
        Int actor_constraints = GetActorConstraintsInt(aakActors[k], True)
        String anim_var_path = path + ".A" + (k + 1)
        ; checking if it has variations
        Bool has_vars = JsonUtil.GetPathIntValue(file, anim_var_path + ".req", -1) == -1
        If has_vars
            Int var_count = JsonUtil.PathCount(file, anim_var_path) - 1
            While var_count >= 0 && !_CheckConstraints(file, anim_var_path + "[" + var_count + "]", actor_constraints)
                var_count -= 1
            EndWhile
            If var_count >= 0
                actor_animVars[k] = anim_var_path + "[" + var_count + "]"
            Else
                UDmain.Warning("UD_AnimationManagerScript::PlayAnimationByDef() Can't find valid animation variant in def " + sAnimDef +" for actor with constraints " + actor_constraints)
                Return False
            EndIf
        ElseIf _CheckConstraints(file, anim_var_path, actor_constraints)
            actor_animVars[k] = anim_var_path
        Else
            UDmain.Warning("UD_AnimationManagerScript::PlayAnimationByDef() Can't find valid animation in def " + sAnimDef +" for actor with constraints " + actor_constraints)
            Return False
        EndIf
        k += 1
    EndWhile

    ; checking if it is a sequence
    Bool is_sequence = JsonUtil.GetPathStringValue(file, actor_animVars[0] + ".anim[0]", "") != ""
    ;Bool is_sequence = JsonUtil.GetPathStringValue(file, path + ".isSequence") == "TRUE"
    
    If aakActors.Length == 2
        If is_sequence
        ; sequence animation (from sex lab animation packs)
            String[] atemp1 = JsonUtil.PathStringElements(file, actor_animVars[0] + ".anim")
            String[] atemp2 = JsonUtil.PathStringElements(file, actor_animVars[1] + ".anim")
            If atemp1.Length > 0 && atemp2.Length > 0
                StartPairAnimationSequence(aakActors[0], aakActors[1], atemp1, atemp2, True, bContinueAnimation)
                Return True
            Else
                UDMain.Error("UD_CustomDevice_RenderScript::PlayAnimationByDef() animation sequence array is empty! Check file " + file + " and animDef variations: " + actor_animVars)
                Return False
            EndIf
        Else
        ; regular animation 
            String temp1 = JsonUtil.GetPathStringValue(file, actor_animVars[0] + ".anim")
            String temp2 = JsonUtil.GetPathStringValue(file, actor_animVars[1] + ".anim")
            If temp1 != "" && temp2 != ""
                StartPairAnimation(aakActors[0], aakActors[1], temp1, temp2, True, bContinueAnimation)
                Return True
            Else
                UDMain.Error("UD_CustomDevice_RenderScript::PlayAnimationByDef() animation is empty! Check file " + file + " and animDef variations: " + actor_animVars)
                Return False
            EndIf
        EndIf
    ElseIf aakActors.Length == 1
        If is_sequence
        ; sequence animation (from sex lab animation packs)
            String[] atemp1 = JsonUtil.PathStringElements(file, actor_animVars[0] + ".anim")
            If atemp1.Length > 0
                StartSoloAnimationSequence(aakActors[0], atemp1, bContinueAnimation)
                Return True
            Else
                UDMain.Error("UD_CustomDevice_RenderScript::PlayAnimationByDef() animation sequence array is empty! Check file " + file + " and animDef variations: " + actor_animVars)
                Return False
            EndIf
        Else
        ; regular animation 
            String temp1 = JsonUtil.GetPathStringValue(file, actor_animVars[0] + ".anim")
            If temp1 != ""
                StartSoloAnimation(aakActors[0], temp1, bContinueAnimation)
                Return True
            Else
                UDMain.Error("UD_CustomDevice_RenderScript::PlayAnimationByDef() animation is empty! Check file " + file + " and animDef variations: " + actor_animVars)
                Return False
            EndIf
        EndIf
    EndIf
    Return False
EndFunction

; Function to preload and validate json files with animations
; If the use conditions are specified in the file (by the "condition" field), then they are checked before the file name is saved in the list for the future uses.
; All loaded and validated files saved in the UD_AnimationJSON array.
Function LoadAnimationJSONFiles()
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles()", 3)
    EndIf
    UD_AnimationJSON_All = PapyrusUtil.ResizeStringArray(UD_AnimationJSON_All, 0)
    UD_AnimationJSON_Inv = PapyrusUtil.ResizeStringArray(UD_AnimationJSON_Inv, 0)
    UD_AnimationJSON = PapyrusUtil.ResizeStringArray(UD_AnimationJSON, 0)
    String[] files = JsonUtil.JsonInFolder("UD/Animations")
    Int i = 0
    While i < files.Length
        String file = "UD/Animations/" + files[i]
        JsonUtil.Unload(file)
        Bool file_is_valid = True
        If JsonUtil.Load(file) && JsonUtil.IsGood(file)
            String file_to_check = JsonUtil.GetPathStringValue(file, "conditions.json")
            If file_to_check != "" && JsonUtil.JsonExists(file_to_check) == False
                UDMain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles() Load condition of the file '" + file + "' is not valid. Can't find JSON file " + file_to_check, 1)
                file_is_valid = False
            EndIf
            file_to_check = JsonUtil.GetPathStringValue(file, "conditions.mod")
            If file_to_check != "" && UnforgivingDevicesMain.ModInstalled(file_to_check) == False
                UDMain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles() Load condition of the file '" + file + "' is not valid. Can't find mod " + file_to_check, 1)
                file_is_valid = False
            EndIf
        Else
            UDMain.Warning("UD_AnimationManagerScript::LoadAnimationJSONFiles() Failed to load json file '" + file + "'")
            UDMain.Warning("UD_AnimationManagerScript::LoadAnimationJSONFiles() Found errors: " + JsonUtil.GetErrors(file))
            file_is_valid = False
        EndIf
        UD_AnimationJSON_All = PapyrusUtil.PushString(UD_AnimationJSON_All, files[i])
        If !file_is_valid
            UD_AnimationJSON_Inv = PapyrusUtil.PushString(UD_AnimationJSON_Inv, files[i])
        Else
            If UD_AnimationJSON_Dis.Find(files[i]) < 0
                UD_AnimationJSON = PapyrusUtil.PushString(UD_AnimationJSON, files[i])
            Else
                UDMain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles() File '" + file + "' is disabled by player", 1)
            EndIf
        EndIf
        i += 1
    EndWhile
    
    If UDmain.TraceAllowed()
        If useUnsafeLogging
            ; Even though when outputting long arrays, the last elements are replaced with ellipsis, sometimes CTD occurs. (It's unsafe to print more than 1000 symbols or so. That's about 14 animations)
            UDmain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles() Loaded files: " + UD_AnimationJSON, 3)
        Else
            UDmain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles() Loaded files count: " + UD_AnimationJSON.Length, 3)
        EndIf
    EndIf
EndFunction

; Function GetAnimationsFromDB
; This function returns an array of animations found by the given criteria
; As an alternative (when sAttribute == "") it returns paths to animation definitions in fson files (formatted as <json_file>:<path_in_file>)
; sType                 - type of the animations needed (solo, paired or anything defined in json files as root object). 
;                         Value should starts with '.' because papyrus sometimes replaces the first character with a capital one.
; sKeywords             - animation keywords (device keywords or any other strings like "horny" to define animation). Value should 
;                         starts with '.' because papyrus sometimes replaces the first character with a capital one.
; aActorConstraints[]   - array with constraints for the participating actors as bit mask (see func. GetActorConstraints)
; sAttribute            - attribute of animation which should be returned
; return                - array of strings with attributes values. If sAttribute is not set then funtion resturns paths to animation definitions in fson files 
;                         (formatted as <json_file>:<path_in_file>)
;
; JSON file syntax
;{
;   "conditions": {                                                     Conditions that determine whether the file will be used 
;       "mod": "<mod name>",
;       "json": "<path to json file relative to SKSE\Plugins\StorageUtilData>"
;   },
;   "paired": {                                                         Animation type
;       "zad_DeviousArmCuffs" : [                                       Animation keyword (device keyword or any other string like "horny" to define animation)
;           {
;               "A1" : {
;                   "anim" : "<animation event>",                       Animation event
;                   "req" : 0,                                          Required constraints for the first actor (animation shouldn't be picked if actor doesn't have all required constraints)
;                   "opt" : 0                                           Optional constraints for the first actor (animation shouldn't be picked if actor has constraints not defined by this bit-mask)
;               },
;               "A2" : [                                                Array with variants
;                   {
;                       "anim" : "<animation event variant 1>",             Animation event for specified actor's constraints
;                       "req" : 256,                                        Required constraints for the second actor (animation shouldn't be picked if actor doesn't have all required constraints)
;                       "opt" : 0                                           Optional constraints for the second actor (animation shouldn't be picked if actor has constraints not defined by this bit-mask)
;                  },
;                   {
;                       "animation" : "<animation event variant 2>",        Variant for specified actor's constraints
;                       "req" : 512,                                        Required constraints for the second actor (animation shouldn't be picked if actor doesn't have all required constraints)
;                       "opt" : 0                                           Optional constraints for the second actor (animation shouldn't be picked if actor has constraints not defined by this bit-mask)
;                   }
;               ],
;               "lewd" : 0,                                             Rate of lewdiness
;               "aggr" : 1,                                             Rate of aggressiveness (from akHelper towards akActor). Could be negative
;               "forced" : true                                         First forced animation will be the only animation in result array. Used to test animation in game with forceReloadFiles = true and enableForcedFlag = true
;           },
;           ...
;       ], 
;       ...
;   }
;}
String[] Function GetAnimationsFromDB(String sType, String[] sKeywords, String sAttribute, Int[] aActorConstraints, Int iLewdMin = 0, Int iLewdMax = 10, Int iAggroMin = -10, Int iAggroMax = 10)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetAnimationsFromDB() sType = " + sType + ", sKeywords = " + sKeywords + ", sAttribute = " + sAttribute + ", aActorConstraints = " + aActorConstraints, 3)
    EndIf
    String[] result_temp = new String[10]
    Int currentIndex = 0
    
    If forceReloadFiles || UD_AnimationJSON.Length == 0
        If forceReloadFiles
            UDMain.Info("UD_AnimationManagerScript::GetAnimationsFromDB() Reloading json files since flag 'forceReloadFiles' is set")
        EndIf
        LoadAnimationJSONFiles()
    EndIf
    
    Int h = 0
    While h < sKeywords.Length
        String dict_path = sType + sKeywords[h]
        Int i = 0
        While i < UD_AnimationJSON.Length
            String file = "UD/Animations/" + UD_AnimationJSON[i]
            Int path_count = JsonUtil.PathCount(file, dict_path)
            Int j = 0
            While j < path_count
                String anim_path = dict_path + "[" + j + "]"
                If enableForcedFlag
                    Bool forced = JsonUtil.GetPathBoolValue(file, anim_path + ".forced")
                    If forced 
                        String[] result_forced = new String[1]
                        If sAttribute == ""
                            result_forced[0] = UD_AnimationJSON[i] + ":" + anim_path
                        Else
                            result_forced[0] = JsonUtil.GetPathStringValue(file, anim_path + sAttribute)
                        EndIf
                        UDMain.Log("UD_AnimationManagerScript::GetAnimationsFromDB() Returning the first forced animation: " + result_forced[0])
                        Return result_forced
                    EndIf
                EndIf
                Bool check = True
                Int k = 0
                While check && k < aActorConstraints.Length
                    String anim_var_path = anim_path + ".A" + (k + 1)
                    ; checking if it has variants
                    Bool has_vars = JsonUtil.GetPathIntValue(file, anim_var_path + ".req", -1) == -1
                    If has_vars
                        Int var_count = JsonUtil.PathCount(file, anim_var_path) - 1
                        While var_count >= 0 && !_CheckConstraints(file, anim_var_path + "[" + var_count + "]", aActorConstraints[k])
                            var_count -= 1
                        EndWhile
                        check = check && (var_count >= 0)
                    Else
                        check = check && _CheckConstraints(file, anim_var_path, aActorConstraints[k])
                    EndIf
                    k += 1
                EndWhile
                If check && _CheckAnimationLewd(file, anim_path, iLewdMin, iLewdMax) && _CheckAnimationAggro(file, anim_path, iAggroMin, iAggroMax)
                    If sAttribute == ""
                        result_temp[currentIndex] = UD_AnimationJSON[i] + ":" + anim_path
                    Else
                        result_temp[currentIndex] = JsonUtil.GetPathStringValue(file, anim_path + sAttribute)
                    EndIf
                    currentIndex += 1
                    If currentIndex >= 128
                        UDMain.Warning("UD_AnimationManagerScript::GetAnimationsFromDB() Reached maximum array size!")
                        Return result_temp
                    EndIf
                    If currentIndex == result_temp.length
                        Int new_length = result_temp.length + 10
                        If new_length > 128 
                            new_length = 128
                        EndIf
                        result_temp = Utility.ResizeStringArray(result_temp, new_length)
                    EndIf
                EndIf
                j += 1
            EndWhile
            i += 1
        EndWhile
        h += 1
    EndWhile
    result_temp = Utility.ResizeStringArray(result_temp, currentIndex)
    If UDmain.TraceAllowed()
        If useUnsafeLogging
            ; Even though when outputting long arrays, the last elements are replaced with ellipsis, sometimes CTD occurs. (It's unsafe to print more than 1000 symbols or so. That's about 14 animations)
            UDmain.Log("UD_AnimationManagerScript::GetAnimationsFromDB() Animation array: " + result_temp, 3)
        Else
            UDmain.Log("UD_AnimationManagerScript::GetAnimationsFromDB() Animation array length: " + result_temp.Length, 3)
        EndIf
    EndIf
    Return result_temp
EndFunction

Bool Function _CheckAnimationLewd(String sFile, String sObjPath, Int iLewdMin, Int iLewdMax)
    Int lewd = JsonUtil.GetPathIntValue(sFile, sObjPath + ".lewd", -100)
    Return lewd == -100 || (lewd >= iLewdMin && lewd <= iLewdMax)
EndFunction

Bool Function _CheckAnimationAggro(String sFile, String sObjPath, Int iAggroMin = -10, Int iAggroMax = 10)
    Int aggro = JsonUtil.GetPathIntValue(sFile, sObjPath + ".aggr", -100)
    Return aggro == -100 || (aggro >= iAggroMin && aggro <= iAggroMax)
EndFunction

Bool Function _CheckConstraints(String sFile, String sObjPath, Int iActorConstraints)
; checking that the actor has constraints suitable for the specified animation
; iActorConstraints      - actor contraints
; anim_reqConstr         - animation required constraints (animation shouldn't be picked if player doesn't have all required constraints)
; anim_optConstr         - animation optional constraints (animation shouldn't be picked if player has constraints not defined by this bit-mask)

    Int anim_reqConstr = JsonUtil.GetPathIntValue(sFile, sObjPath + ".req")
    If Math.LogicalAnd(anim_reqConstr, iActorConstraints) != anim_reqConstr
        Return False
    Else
        Int anim_optConstr = JsonUtil.GetPathIntValue(sFile, sObjPath + ".opt")
        Return Math.LogicalAnd(Math.LogicalOr(anim_optConstr, anim_reqConstr), iActorConstraints) == iActorConstraints
    EndIf
EndFunction

; Function GetStruggleAnimationsByKeyword
; This function returns an array of struggle animations for the specified device on actor with optional helper.
; akKeyword             - device keyword to struggle from
; akActor               - wearer of the device
; akHelper              - optional helper
; return                - array of strings with animation paths in DB
String[] Function GetStruggleAnimationsByKeyword(Keyword akKeyword, Actor akActor, Actor akHelper = None, Bool bReuseConstraintsCache = False)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetStruggleAnimationsByKeyword() akKeyword = " + akKeyword.GetString() + ", akActor = " + akActor + ", akHelper = " + akHelper, 3)
    EndIf

    If akHelper == None
        Int[] aActorConstraints = new Int[1]
        aActorConstraints[0] = GetActorConstraintsInt(akActor, bReuseConstraintsCache)
        String[] sKeywords = new String[1]
        sKeywords[0] = "." + akKeyword.GetString()
        Return GetAnimationsFromDB(".solo", sKeywords, "", aActorConstraints)
    Else
        Int[] aActorConstraints = new Int[2]
        aActorConstraints[0] = GetActorConstraintsInt(akActor, bReuseConstraintsCache)
        aActorConstraints[1] = GetActorConstraintsInt(akHelper, bReuseConstraintsCache)
        String[] sKeywords = new String[1]
        sKeywords[0] = "." + akKeyword.GetString()
        Return GetAnimationsFromDB(".paired", sKeywords, "", aActorConstraints)
    EndIf
EndFunction

String[] Function GetHornyAnimEvents(Actor akActor)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetHornyAnimEvents() akActor = " + akActor, 3)
    EndIf

    Int[] aActorConstraints = new Int[1]
    aActorConstraints[0] = GetActorConstraintsInt(akActor)
    String[] sKeywords = new String[1]
    sKeywords[0] = ".horny"
    
    String[] anims = GetAnimationsFromDB(".solo", sKeywords, ".A1.anim", aActorConstraints)

    Return anims
EndFunction

String[] Function GetOrgasmAnimEvents(Actor akActor)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetOrgasmAnimEvents() akActor = " + akActor, 3)
    EndIf

    Int[] aActorConstraints = new Int[1]
    aActorConstraints[0] = GetActorConstraintsInt(akActor)
    String[] sKeywords = new String[1]
    sKeywords[0] = ".orgasm"
    
    String[] anims = GetAnimationsFromDB(".solo", sKeywords, ".A1.anim", aActorConstraints)

    Return anims
EndFunction

String[] Function GetEdgedAnimEvents(Actor akActor)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetEdgedAnimEvents() akActor = " + akActor, 3)
    EndIf

    Int[] aActorConstraints = new Int[1]
    aActorConstraints[0] = GetActorConstraintsInt(akActor)
    String[] sKeywords = new String[1]
    sKeywords[0] = ".edged"

    String[] anims = GetAnimationsFromDB(".solo", sKeywords, ".A1.anim", aActorConstraints)

    Return anims
EndFunction

; Function GetAnimDefAttribute
; Should be used to get from animation definition's value from json file 
; sAnimDef      - animation definition address in format: "<file_name>:<path_in_file>"
; sAttrName     - needed attribute from object in json file. Must start with "."
; return        - attribute value as string
String Function GetAnimDefAttribute(String sAnimDef, String sAttrName, String sDefault = "")
    If sAnimDef == ""
        UDMain.Error("UD_AnimationManagerScript::GetAnimDefAttribute() Empty string as an AnimDef!")
        Return sDefault
    EndIf
    Int part_index = StringUtil.Find(sAnimDef, ":")
    If part_index < 0 
        UDMain.Error("UD_AnimationManagerScript::GetAnimDefAttribute() AnimDef has invalid format (should be <file_name>:<path_in_file>)")
        Return sDefault
    EndIf
    String file = "UD/Animations/" + StringUtil.Substring(sAnimDef, 0, part_index)
    String path = StringUtil.Substring(sAnimDef, part_index + 1)
    String res = JsonUtil.GetPathStringValue(file, path + sAttrName, sDefault)
    If res == sDefault
        UDMain.Warning("UD_AnimationManagerScript::GetAnimDefAttribute() Returning default value for the attribute " + sAttrName + " in AnimDef + " + sAnimDef)
    EndIf
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetAnimDefAttribute() sAnimDef = " + sAnimDef + ", sAttrName = " + sAttrName + " Value = " + res, 3)
    EndIf
    Return res
EndFunction

; Function GetAnimDefAttributeArray
; It is a version of GetAttributeFromAnimationDef where return value is an array
; sAnimDef      - animation definition address in format: "<file_name>:<path_in_file>"
; sAttrName     - needed array attribute from object in json file. Must start with "."
; return        - attribute value as string[]
String[] Function GetAnimDefAttributeArray(String sAnimDef, String sAttrName)
    If sAnimDef == ""
        UDMain.Error("UD_AnimationManagerScript::GetAnimDefAttributeArray() Empty string as an AnimDef!")
        Return PapyrusUtil.StringArray(0)
    EndIf
    Int part_index = StringUtil.Find(sAnimDef, ":")
    If part_index < 0 
        UDMain.Error("UD_AnimationManagerScript::GetAnimDefAttributeArray() AnimDef has invalid format (should be <file_name>:<path_in_file>)")
        Return PapyrusUtil.StringArray(0)
    EndIf
    String file = "UD/Animations/" + StringUtil.Substring(sAnimDef, 0, part_index)
    String path = StringUtil.Substring(sAnimDef, part_index + 1)
    String[] res = JsonUtil.PathStringElements(file, path + sAttrName)
    If res.Length == 0
        UDMain.Warning("UD_AnimationManagerScript::GetAnimDefAttributeArray() Empty array as attribute value " + sAttrName + " in AnimDef + " + sAnimDef)
    EndIf
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetAnimDefAttributeArray() sAnimDef = " + sAnimDef + ", sAttrName = " + sAttrName + " Value = " + res, 3)
    EndIf
    Return res
EndFunction

; TODO: Cache it somehow for actors
; Function GetActorConstraintsInt
; Used to get actor's constraints from equipped devices as a bit mask
Int Function GetActorConstraintsInt(Actor akActor, Bool bUseCache = False)
    If bUseCache && StorageUtil.HasIntValue(akActor, "UD_ActorConstraintsInt")
        Return StorageUtil.GetIntValue(akActor, "UD_ActorConstraintsInt")
    EndIf
	Int result = 0
    If akActor == None
        Return result
    EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirt) && !akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
		result += 1
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousAnkleShackles) || akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
		result += 2
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousYoke)
		result += 4
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousCuffsFront)
		result += 8
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousArmbinder)
		result += 16
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousArmbinderElbow)
		result += 32
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousPetSuit)
		result += 64
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousElbowTie)
		result += 128
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousStraitJacket)
		result += 512
	ElseIf akActor.WornHasKeyword(libs.zad_DeviousYokeBB)
		result += 1024
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousBondageMittens)
		result += 256
	EndIf

    StorageUtil.SetIntValue(akActor, "UD_ActorConstraintsInt", result)
    Return result
EndFunction

; compilation of the code from SexLab functions
; there is a weak dependence on NiOverride
Function _RemoveHeelEffect(Actor akActor, Bool bRemoveHDT = true, Bool bRemoveNiOverride = true)
    If !akActor.GetWornForm(0x00000080)
        Return
    EndIf
    If slConfig == None
        Return
    EndIf
    if bRemoveNiOverride && slConfig.HasNiOverride
        Bool isRealFemale = (akActor.GetLeveledActorBase().GetSex() == 1)
        bool UpdateNiOPosition = False
        String[] overrideKeys = NiOverride.GetNodeTransformKeys(akActor, false, isRealFemale, "NPC")
        ; removing previous override
        If overrideKeys.Find("UnforgivingDevices.esp") >= 0
            NiOverride.RemoveNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esp")
            UpdateNiOPosition = True
        EndIf
        ; checking if actor has SexLab HH and DD overrides are not present
        ; TODO: Can be done as a shift by the sum of all vectors
        If overrideKeys.Find("DDC") < 0 && overrideKeys.Find("DDPET") < 0 && overrideKeys.Find("internal") >= 0
            float[] pos = NiOverride.GetNodeTransformPosition(akActor, false, isRealFemale, "NPC", "internal")
            pos[0] = -pos[0]
            pos[1] = -pos[1]
            pos[2] = -pos[2]
            NiOverride.AddNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esp", pos)
            UpdateNiOPosition = True
        EndIf
        If UpdateNiOPosition
            NiOverride.UpdateNodeTransform(akActor, false, isRealFemale, "NPC")
        endIf
    endIf
    if bRemoveHDT
        Spell hdtHeelSpell = slConfig.GetHDTSpell(akActor)
        if hdtHeelSpell
            StorageUtil.SetFormValue(akActor, "UD_AnimationManager_HDTHeelSpell", hdtHeelSpell)
            akActor.RemoveSpell(hdtHeelSpell)
        endIf
    endIf
EndFunction

; compilation of the code from SexLab functions
; there is a weak dependence on NiOverride
Function _RestoreHeelEffect(Actor akActor)
    If !akActor.GetWornForm(0x00000080)
        Return
    EndIf
    If slConfig == None
        Return
    EndIf
    ; HDT High Heel
    if True
        Spell hdtHeelSpell = StorageUtil.GetFormValue(akActor, "UD_AnimationManager_HDTHeelSpell") as Spell
        if hdtHeelSpell && !akActor.HasSpell(hdtHeelSpell)
            akActor.AddSpell(hdtHeelSpell)
        endIf
        StorageUtil.UnsetFormValue(akActor, "UD_AnimationManager_HDTHeelSpell")
    endIf
    if slConfig.HasNiOverride
        Bool isRealFemale = (akActor.GetLeveledActorBase().GetSex() == 1)
        bool UpdateNiOPosition = NiOverride.RemoveNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esp")
        if UpdateNiOPosition
            NiOverride.UpdateNodeTransform(akActor, false, isRealFemale, "NPC")
        endIf
    endIf
EndFunction

Function _Benchmark(Int iCycles = 10)
    Int n = iCycles
    Float start_time
    Int duration
    Bool old_forceReloadFiles = forceReloadFiles
    Bool old_enableForcedFlag = enableForcedFlag
    Int old_UDPrintLevel = UDmain.UD_PrintLevel
    Int old_UDLogLevel = UDmain.LogLevel
    forceReloadFiles = False
    enableForcedFlag = False
    UDmain.UD_PrintLevel = 0
    UDmain.LogLevel = 0

    If True
        n = iCycles
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            ; NOP
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark NOP with " + (iCycles) + " cycles ends in " + duration + " ms")
        ; Benchmark NOP with 10 cycles ends in 6 ms
    EndIf

    If True
        n = iCycles * 100
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            ; NOP
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark NOP with " + (iCycles * 100) + " cycles ends in " + duration + " ms")
        ; Benchmark NOP with 1000 cycles ends in 173 ms
    EndIf
    
    If False
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int[] cc = new Int[1]
            cc[0] = 0
            String[] sKeywords = new String[1]
            sKeywords[0] = ".zad_DeviousBoots"
            String[] res = GetAnimationsFromDB(".solo", sKeywords, "", cc)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark GetAnimationsFromDB(solo) with " + iCycles + " cycles ends in " + duration + " ms")
    EndIf

    If True
        n = iCycles
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int[] cc = new Int[2]
            cc[0] = 0
            cc[1] = 0
            String[] sKeywords = new String[1]
            sKeywords[0] = ".zad_DeviousBelt"
            String[] res = GetAnimationsFromDB(".paired", sKeywords, "", cc)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark GetAnimationsFromDB(paired) with " + iCycles + " cycles ends in " + duration + " ms")
        ; Benchmark GetAnimationsFromDB(paired) with 10 cycles ends in 2014 ms
    EndIf
    
    If False
        Actor akActor = Game.GetPlayer()
        n = iCycles
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int cc = GetActorConstraintsInt(akActor)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark UDAM.GetActorConstraintsInt with " + iCycles + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = iCycles * 100
        start_time = Utility.GetCurrentRealTime()
        Int aa
        While n >= 0
            n -= 1
            aa = JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1[0].req", -1)
            aa = JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1[1].req", -1)
            aa = JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1[2].req", -1)
            aa = JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1[3].req", -1)
            aa = JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1[4].req", -1)
            aa = JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1[5].req", -1)
            aa = JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1[6].req", -1)
            aa = JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1[7].req", -1)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark JsonUtil #1 with " + iCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = iCycles * 100
        start_time = Utility.GetCurrentRealTime()
        Int aa
        Int[] arr
        While n >= 0
            n -= 1
            arr = JsonUtil.PathIntElements("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[1]" + ".A1_req")
            aa = arr[0]
            aa = arr[1]
            aa = arr[2]
            aa = arr[3]
            aa = arr[4]
            aa = arr[5]
            aa = arr[6]
            aa = arr[7]
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark JsonUtil #2 with " + iCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = iCycles * 100
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[0]" + ".A1[0].req", -1)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark JsonUtil #3 with " + iCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = iCycles * 100
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int[] arr = JsonUtil.PathIntElements("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[0]" + ".A1_req")
            Int aa = arr[0]
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark JsonUtil #4 with " + iCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = iCycles * 100
        String[] temp_str_array = new String[10]
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int m = 10
            While m <= 100
                m += 10
                temp_str_array = Utility.ResizeStringArray(temp_str_array, m)
            EndWhile
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark ResizeStringArray with " + iCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf
    
    forceReloadFiles = old_forceReloadFiles
    enableForcedFlag = old_enableForcedFlag
    UDmain.UD_PrintLevel = old_UDPrintLevel
    UDmain.LogLevel = old_UDLogLevel
EndFunction