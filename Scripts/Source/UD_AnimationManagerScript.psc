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


;==========;                                                                           
;==MANUAL==;                                                                           
;==========;                                                                           
zadlibs_UDPatch                        Property     libsp                           hidden
    zadlibs_UDPatch Function get()
        return libs as zadlibs_UDPatch
    EndFunction
EndProperty

sslSystemConfig _slConfig = None
sslSystemConfig                         Property    slConfig                       Hidden
    sslSystemConfig Function Get()
        If _slConfig != None
            Return _slConfig
        EndIf
        _slConfig = (Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig)
        If _slConfig == None
            _slConfig = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig)
        EndIf
        If _slConfig == None
            UDmain.Error("UD_AnimationManagerScript::slConfig Can't find SexLab system config object!")
        EndIf
        Return _slConfig
    EndFunction
EndProperty

; XCross Static
; TODO: Make it auto property
Form _VehicleMarkerForm
Form                                    Property VehicleMarkerForm                  Hidden
    Form Function Get()
        If _VehicleMarkerForm == None 
            _VehicleMarkerForm = Game.GetForm(0x0000003B)
        EndIf
        Return _VehicleMarkerForm
    EndFunction
EndProperty

; NOT USED ANYMORE
;===================;
;==ANIMATION ARRAY==;
;===================;
;animations arrays for faster acces
;normal animations without hobble skirt
String[] Property UD_StruggleAnimation_Armbinder            auto
String[] Property UD_StruggleAnimation_Elbowbinder          auto
String[] Property UD_StruggleAnimation_StraitJacket         auto
String[] Property UD_StruggleAnimation_CuffsFront           auto
String[] Property UD_StruggleAnimation_Yoke                 auto
String[] Property UD_StruggleAnimation_YokeBB               auto
String[] Property UD_StruggleAnimation_ElbowTie             auto
;String[] Property UD_StruggleAnimation_PetSuit             auto !TODO
String[] Property UD_StruggleAnimation_Gag                  auto
String[] Property UD_StruggleAnimation_Boots                auto ;also leg cuffs
String[] Property UD_StruggleAnimation_ArmCuffs             auto ;also gloves and mittens
String[] Property UD_StruggleAnimation_Collar               auto
String[] Property UD_StruggleAnimation_Blindfold            auto ;also includes hood
String[] Property UD_StruggleAnimation_Suit                 auto
String[] Property UD_StruggleAnimation_Belt                 auto
String[] Property UD_StruggleAnimation_Plug                 auto
String[] Property UD_StruggleAnimation_Default              auto
;animations with hobble skirt
String[] Property UD_StruggleAnimation_Armbinder_HB         auto
String[] Property UD_StruggleAnimation_Elbowbinder_HB       auto
String[] Property UD_StruggleAnimation_StraitJacket_HB      auto
String[] Property UD_StruggleAnimation_CuffsFront_HB        auto
String[] Property UD_StruggleAnimation_Yoke_HB              auto
String[] Property UD_StruggleAnimation_YokeBB_HB            auto
String[] Property UD_StruggleAnimation_ElbowTie_HB          auto
;String[] Property UD_StruggleAnimation_PetSuit_HB          auto !TODO
String[] Property UD_StruggleAnimation_Gag_HB               auto
String[] Property UD_StruggleAnimation_Boots_HB             auto ;also leg cuffs
String[] Property UD_StruggleAnimation_ArmCuffs_HB          auto ;also gloves and mittens
String[] Property UD_StruggleAnimation_Collar_HB            auto
String[] Property UD_StruggleAnimation_Blindfold_HB         auto ;also includes hood
String[] Property UD_StruggleAnimation_Suit_HB              auto
String[] Property UD_StruggleAnimation_Belt_HB              auto
String[] Property UD_StruggleAnimation_Plug_HB              auto
String[] Property UD_StruggleAnimation_Default_HB           auto

; / NOT USED ANYMORE

;============================================================
;======================LOCAL VARIABLES=======================
;============================================================

Bool ZAZAnimationsInstalled = false

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
    
EndFunction

;reduced startanimation function
;doesn't disable actor movement and doesn't check if actor is valid
;doesn't check camera state
bool Function FastStartThirdPersonAnimation(actor akActor, string animation)
    if animation == "none" || animation == ""
        UDmain.Warning("UD_AnimationManagerScript::FastStartThirdPersonAnimation() Called animation is None, aborting")
        return false
    endif
    
    LockAnimatingActor(akActor)
    ; in case it called just after paired animation (for example, during orgasm ending)
    akActor.SetVehicle(None)
    
    Debug.SendAnimationEvent(akActor, animation)
    
    return true
EndFunction

;reduced endanimation function
;doesn't enable actor movement and doesn't check if actor is valid
;doesn't check camera state
Function FastEndThirdPersonAnimation(actor akActor)
    
    UnlockAnimatingActor(akActor)
    ; restoring HH if it was removed in FastStartThirdPersonAnimationWithHelper
    _RestoreHeelEffect(akActor)
    
    Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
EndFunction

;copied from zadlibs
Bool Function IsAnimating(Actor akActor, Bool abBonusCheck = true)
    if abBonusCheck
        if (akActor.GetSitState() != 0) || akActor.IsOnMount()
            return True
        endif
    endif
    return (akActor.IsInFaction(ZadAnimationFaction) || akActor.IsInFaction(SexlabAnimationFaction))
EndFunction

Form Function GetShield(Actor akActor)
    Form loc_shield = akActor.GetEquippedObject(0)
    if loc_shield && (loc_shield.GetType() == 26 || loc_shield.GetType() == 31)
        return loc_shield
    else
        return none
    endif
EndFunction


; Prepare actors and start an animation for them 
; akActor       - first actor
; akHelper      - second actor (helper)
; animationA1   - animation (animation event) for the first actor
; animationA2   - animation (animation event) for the second actor (helper)
; return        - true if OK
bool Function FastStartThirdPersonAnimationWithHelper(actor akActor, actor akHelper, string animationA1, string animationA2, bool alignActors = true)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() akActor = " + akActor + ", akHelper = " + akHelper + ", animationA1 = " + animationA1 + ", animationA2 = " + animationA2 + ", alignActors = " + alignActors)
    EndIf
    If akActor == None 
        UDmain.Error("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() akActor is None, aborting")
        Return False
    EndIf
    If akHelper == None
        Return FastStartThirdPersonAnimation(akActor, animationA1)
    EndIf
    If (animationA1 == "none" || animationA1 == "") && (animationA2 == "none" || animationA2 == "")
        UDmain.Error("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() animations is None, aborting")
        Return False
    ElseIf (animationA1 == "none" || animationA1 == "")
        UDmain.Log("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() animation for Actor 1 is None, using solo animation for the Actor 2")
        Return FastStartThirdPersonAnimation(akHelper, animationA2)
    ElseIf (animationA2 == "none" || animationA2 == "")
        UDmain.Log("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() animation for Actor 2 is None, using solo animation for the Actor 1")
        Return FastStartThirdPersonAnimation(akActor, animationA1)
    endif
    
    ; locking actors
    LockAnimatingActor(akActor)
    LockAnimatingActor(akHelper)
    ; removing HH
    _RemoveHeelEffect(akActor)
    _RemoveHeelEffect(akHelper)
    
    ObjectReference vehicleMarkerRef = None
    If alignActors
        ;creating vehicle marker once for each akActor
        vehicleMarkerRef = StorageUtil.GetFormValue(akActor, "UD_AnimationManager_VehicleMarker") as ObjectReference
        if (vehicleMarkerRef == None)
            vehicleMarkerRef = akActor.PlaceAtMe(VehicleMarkerForm)
            int cycle
            while !vehicleMarkerRef.Is3DLoaded() && cycle < 10
                Utility.Wait(0.1)
                cycle += 1
            endWhile
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

    ; sending animation events
    Debug.SendAnimationEvent(akActor, animationA1)
    Debug.SendAnimationEvent(akHelper, animationA2)
    
    If alignActors
        akHelper.MoveTo(vehicleMarkerRef)
        akActor.MoveTo(vehicleMarkerRef)
        
        akActor.SetVehicle(vehicleMarkerRef)
        akHelper.SetVehicle(vehicleMarkerRef)
        
        akActor.TranslateToRef(vehicleMarkerRef, 200.0)
        akHelper.TranslateToRef(vehicleMarkerRef, 200.0)
    EndIf
    
    return true
EndFunction

Function LockAnimatingActor(Actor akActor)

    libs.SetAnimating(akActor, True)
    ActorUtil.AddPackageOverride(akActor, slConfig.DoNothing, 100, 1)
    akActor.EvaluatePackage()
    
    If UDmain.ActorIsPlayer(akActor)

    Else
        akActor.SetDontMove(true)
    EndIf

    if akActor.IsWeaponDrawn()
        akActor.SheatheWeapon()
        ; Wait for users with flourish sheathe animations.
        int timeout=0
        while akActor.IsWeaponDrawn() && timeout <= 35 ;  Wait 3.5 seconds at most before giving up and proceeding.
            Utility.Wait(0.1)
            timeout += 1
        EndWhile
    EndIf

EndFunction

Function UnlockAnimatingActor(Actor akActor)

    ActorUtil.RemovePackageOverride(akActor, slConfig.DoNothing)
    akActor.EvaluatePackage()
    libs.SetAnimating(akActor, False)
    akActor.SetVehicle(None)
    If UDmain.ActorIsPlayer(akActor)
        ; should it be done via some UD wrapper?
        libs.UpdateControls()
    Else
        akActor.SetDontMove(False)
    EndIf
    akActor.SetVehicle(None)
    
EndFunction

; array with loaded json files
String[] UD_AnimationDefs

; For debug purposes. Remove in prod
Bool forceReloadFiles = True
Bool enableForcedFlag = True

; function to preload and validate json files with animations
; it also checks if met load condtion (a specified mod is loaded or there is a json file in the data folder)
Function LoadAnimationJSONFiles()
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles()")
    EndIf
    UD_AnimationDefs = PapyrusUtil.ResizeStringArray(UD_AnimationDefs, 0)
    String[] files = JsonUtil.JsonInFolder("UD/Animations")
    Int i = 0
    While i < files.Length
        String file = "UD/Animations/" + files[i]
        JsonUtil.Unload(file)
        Bool file_is_good = True
        If JsonUtil.Load(file) && JsonUtil.IsGood(file)
            String file_to_check = JsonUtil.GetPathStringValue(file, "conditions.has_json")
            If file_to_check != "" && JsonUtil.JsonExists(file_to_check) == False
                UDMain.Warning("UD_AnimationManagerScript::LoadAnimationJSONFiles() Load condition of the file " + file + " is not valid. Can't find JSON file " + file_to_check)
                file_is_good = False
            EndIf
            file_to_check = JsonUtil.GetPathStringValue(file, "conditions.has_mod")
            If file_to_check != "" && UnforgivingDevicesMain.ModInstalled(file_to_check) == False
                UDMain.Warning("UD_AnimationManagerScript::LoadAnimationJSONFiles() Load condition of the file " + file + " is not valid. Can't find mod " + file_to_check)
                file_is_good = False
            EndIf
        Else
            UDMain.Warning("UD_AnimationManagerScript::LoadAnimationJSONFiles() Failed to load json file " + file)
            UDMain.Warning("UD_AnimationManagerScript::LoadAnimationJSONFiles() Found errors: " + JsonUtil.GetErrors(file))
            file_is_good = False
        EndIf
        If file_is_good
            UD_AnimationDefs = PapyrusUtil.PushString(UD_AnimationDefs, files[i])
        EndIf
        i += 1
    EndWhile
    
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles() Loaded files: " + UD_AnimationDefs)
    EndIf
EndFunction

; Function GetAnimationsFromDB
; This function returns an array of animations found by the given criteria
; sType                 - type of the animations needed (solo, paired or anything defined in json files as root object). Value should starts with '.' because papyrus sometimes replaces the first character with a capital one.
; sKeyword              - animation keyword (device keyword or any other string like "horny" to define animation). Value should starts with '.' because papyrus sometimes replaces the first character with a capital one.
; iActor1Constraints    - constraints for Actor1 as bit mask (see func. GetActorConstraints)
; iActor2Constraints    - constraints for Actor2 as bit mask (see func. GetActorConstraints)
; return                - array of strings with found animations. To get animation for the akActor and akHelper add A1 or A2 to the end
;
; JSON file syntax
;{
;   "conditions": {                                                     Conditions that determine whether the file will be used 
;       "has_mod": "<mod name>",
;       "has_json": "<path to json file relative to SKSE\Plugins\StorageUtilData>"
;   },
;   "paired": {                                                         Animation type
;       "zad_DeviousArmCuffs" : [                                       Animation keyword (device keyword or any other string like "horny" to define animation)
;           {
;               "animation" : "PS_Babo_Conquering04_S1_",               Animation base name. To get animation events for the akActor and akHelper add A1 or A2 to the end
;               "reqConstraintsA1" : 0,                                 Required constraints for the akActor (animation shouldn't be picked if actor doesn't have all required constraints)
;               "optConstraintsA1" : 0,                                 Optional constraints for the akActor (animation shouldn't be picked if actor has constraints not defined by this bit-mask)
;               "reqConstraintsA2" : 0,                                 Required constraints for the akHelper (animation shouldn't be picked if helper doesn't have all required constraints)
;               "optConstraintsA2" : 0,                                 Optional constraints for the akHelper (animation shouldn't be picked if helper has constraints not defined by this bit-mask)
;               "lewd" : 0,                                             Rate of lewdiness
;               "aggressive" : 1,                                       Rate of aggressiveness (from akHelper towards akActor). Could be negative
;               "forced" : true                                         First forced animation will be the only animation in result array. Used to test animation in game with forceReloadFiles = true and enableForcedFlag = true
;           },
;           ...
;       ], 
;       ...
;   }
;}
String[] Function GetAnimationsFromDB(String sType, String sKeyword, Int iActor1Constraints, Int iActor2Constraints = -1, Int iLewdMin = 0, Int iLewdMax = 10, Int iAggroMin = -10, Int iAggroMax = 10)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetAnimationsFromDB() sType = " + sType + ", sKeyword = " + sKeyword + ", iActor1Constraints = " + iActor1Constraints + ", iActor2Constraints = " + iActor2Constraints)
    EndIf
    String[] result_temp = new String[10]
    Int currentIndex = 0
    
    If forceReloadFiles || UD_AnimationDefs.Length == 0
        If forceReloadFiles
            UDMain.Info("UD_AnimationManagerScript::GetAnimationsFromDB() Reloading json files since flag 'forceReloadFiles' is set")
        EndIf
        LoadAnimationJSONFiles()
    EndIf
    
    String dict_path = sType + sKeyword
    Int i = 0
    While i < UD_AnimationDefs.Length && currentIndex < 128
        String file = "UD/Animations/" + UD_AnimationDefs[i]
        Int path_count = JsonUtil.PathCount(file, dict_path)
        Int j = 0
        While j < path_count
            String anim_path = dict_path + "[" + j + "]"
            If enableForcedFlag
                Bool forced = JsonUtil.GetPathBoolValue(file, anim_path + ".forced")
                If forced 
                    String[] result_forced = new String[1]
                    result_forced[0] = JsonUtil.GetPathStringValue(file, anim_path + ".animation")
                    UDMain.Info("UD_AnimationManagerScript::GetAnimationsFromDB() Returning the first forced animation: " + result_forced[0])
                    Return result_forced
                EndIf
            EndIf
            
            String anim = JsonUtil.GetPathStringValue(file, anim_path + ".animation")
        ; using this odd construction to hopefully minimize reads from file
            If anim != "" && _CheckConstraintsA1(file, anim_path, iActor1Constraints) && _CheckConstraintsA2(file, anim_path, iActor2Constraints) && _CheckAnimationLewd(file, anim_path, iLewdMin, iLewdMax) && _CheckAnimationAggro(file, anim_path, iAggroMin, iAggroMax)
                result_temp[currentIndex] = anim
                currentIndex += 1
                
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
    If currentIndex == 128
        UDMain.Warning("UD_AnimationManagerScript::GetAnimationsFromDB() Reached maximum array size!")
    EndIf
    result_temp = Utility.ResizeStringArray(result_temp, currentIndex)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetAnimationsFromDB() Animation array: " + result_temp)
    EndIf
    Return result_temp
EndFunction

Bool Function _CheckAnimationLewd(String sFile, String sObjPath, Int iLewdMin, Int iLewdMax)
    Int lewd = JsonUtil.GetPathIntValue(sFile, sObjPath + ".lewd", -100)
    Return lewd == -100 || (lewd >= iLewdMin && lewd <= iLewdMax)
EndFunction

Bool Function _CheckAnimationAggro(String sFile, String sObjPath, Int iAggroMin = -10, Int iAggroMax = 10)
    Int aggro = JsonUtil.GetPathIntValue(sFile, sObjPath + ".aggressive", -100)
    Return aggro == -100 || (aggro >= iAggroMin && aggro <= iAggroMax)
EndFunction

Bool Function _CheckConstraintsA1(String sFile, String sObjPath, Int iActorConstraints)
    If iActorConstraints < 0
        Return True
    EndIf
    Int anim_reqConstrA1 = JsonUtil.GetPathIntValue(sFile, sObjPath + ".reqConstraintsA1", -1)
    If anim_reqConstrA1 < 0
        Return True
    EndIf
    Int anim_optConstrA1 = JsonUtil.GetPathIntValue(sFile, sObjPath + ".optConstraintsA1", -1)
    Return Math.LogicalAnd(anim_reqConstrA1, iActorConstraints) == anim_reqConstrA1 && (anim_optConstrA1 < 0 || Math.LogicalAnd(Math.LogicalOr(anim_optConstrA1, anim_reqConstrA1), iActorConstraints) == iActorConstraints)
EndFunction

Bool Function _CheckConstraintsA2(String sFile, String sObjPath, Int iActorConstraints)
    If iActorConstraints < 0
        Return True
    EndIf
    Int anim_reqConstrA2 = JsonUtil.GetPathIntValue(sFile, sObjPath + ".reqConstraintsA2", -1)
    If anim_reqConstrA2 < 0
        Return True
    EndIf
    Int anim_optConstrA2 = JsonUtil.GetPathIntValue(sFile, sObjPath + ".optConstraintsA2", -1)
    Return Math.LogicalAnd(anim_reqConstrA2, iActorConstraints) == anim_reqConstrA2 && (anim_optConstrA2 < 0 || Math.LogicalAnd(Math.LogicalOr(anim_optConstrA2, anim_reqConstrA2), iActorConstraints) == iActorConstraints)
EndFunction

; Function GetStruggleAnimationsByKeyword
; This function returns an array of struggle animations for the specified device on actor with optional helper
; akKeyword             - device keyword to struggle from
; akActor               - wearer of the device
; akHelper              - optional helper
; return                - array of strings
String[] Function GetStruggleAnimationsByKeyword(Keyword akKeyword, Actor akActor, Actor akHelper = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetStruggleAnimationsByKeyword akKeyword = " + akKeyword.GetString() + ", akActor = " + akActor + ", akHelper = " + akHelper)
    EndIf
    Int iActorConstraints = _FromContraintsBoolArrayToInt(GetActorConstraints(akActor))
    If akHelper == None
        Return GetAnimationsFromDB(".solo", "." + akKeyword.GetString(), iActorConstraints)
    Else
        Int iHelperConstraints = _FromContraintsBoolArrayToInt(GetActorConstraints(akHelper))
        Return GetAnimationsFromDB(".paired", "." + akKeyword.GetString(), iActorConstraints, iHelperConstraints)
    EndIf
EndFunction

String[] Function GetHornyAnimations(Actor akActor, Bool bIncludeDD = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetHornyAnimations akActor = " + akActor)
    EndIf
    Int iActorConstraints = _FromContraintsBoolArrayToInt(GetActorConstraints(akActor))

    String[] anims = GetAnimationsFromDB(".solo", ".horny", iActorConstraints)
    If bIncludeDD
        String anim_dd = libs.AnimSwitchKeyword(akActor, "Horny0" + (Utility.RandomInt(1, 3) as String))
        If (anim_dd != "" && anim_dd != "none") && anims.Length < 128
            anims = PapyrusUtil.PushString(anims, anim_dd)
        EndIf
    EndIf
    Return anims
EndFunction

String[] Function GetOrgasmAnimations(Actor akActor, Bool bIncludeDD = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetOrgasmAnimations akActor = " + akActor)
    EndIf
    Int iActorConstraints = _FromContraintsBoolArrayToInt(GetActorConstraints(akActor))

    String[] anims = GetAnimationsFromDB(".solo", ".orgasm", iActorConstraints)
    If bIncludeDD
        String anim_dd = libs.AnimSwitchKeyword(akActor, "Orgasm")
        If (anim_dd != "" && anim_dd != "none") && anims.Length < 128
            anims = PapyrusUtil.PushString(anims, anim_dd)
        EndIf
    EndIf
    Return anims
EndFunction

String[] Function GetEdgedAnimations(Actor akActor, Bool bIncludeDD = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetEdgedAnimations akActor = " + akActor)
    EndIf
    Int iActorConstraints = _FromContraintsBoolArrayToInt(GetActorConstraints(akActor))

    String[] anims = GetAnimationsFromDB(".solo", ".edged", iActorConstraints)
    If bIncludeDD
        String anim_dd = libs.AnimSwitchKeyword(akActor, "Edged")
        If (anim_dd != "" && anim_dd != "none") && anims.Length < 128
            anims = PapyrusUtil.PushString(anims, anim_dd)
        EndIf
    EndIf
    Return anims
EndFunction

; checks compatibility between constraints applied to actor and constraints in animation
; actorConstraints      - actor contraints as Int
; animReqConstraints    - animation required constraints as Int (animation shouldn't be picked if player doesn't have all required constraints)
; animOptConstraints    - animation optional constraints as Int (animation shouldn't be picked if player has constraints not defined by this bit-mask)
Bool Function _CheckAnimationConstraints(Int actorConstraints, Int animReqConstraints, Int animOptConstraints)

    If actorConstraints < 0 || animReqConstraints < 0 || animOptConstraints < 0 
        Return True
    EndIf
    Return Math.LogicalAnd(animReqConstraints, actorConstraints) == animReqConstraints && Math.LogicalAnd(Math.LogicalOr(animOptConstraints, animReqConstraints), actorConstraints) == actorConstraints
    
EndFunction

; (0,0,1,0,0,0,0) => 4
; (1,1,0,0,1,0,0) => 1+2+16
Int Function _FromContraintsBoolArrayToInt(Bool[] constraintsArray)
    If constraintsArray.length == 0
        Return 0
    EndIf
    Int i = 0
    Int m = 1
    Int r = 0
    While i < constraintsArray.length
        r += m * (constraintsArray[i] as Int)
        m *= 2
        i += 1
    EndWhile
    Return r
EndFunction

; Possible constraints:
; [0] hobble skirt or linked cuffs
; [1] bound ankles
; [2] yoke
; [3] wrists bound in front
; [4] armbinder
; [5] elbowbinder
; [6] pet suit
; [7] elbowtie
; [8] mittens
; [9] StraitJacket
Bool[] Function GetActorConstraints(Actor akActor)
	Bool[] result = new Bool[10]
    If akActor == None
        Return result
    EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirt)
	; TODO: check for linked cuffs
		result[0] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousAnkleShackles) || akActor.WornHasKeyword(libs.zad_DeviousHobbleSkirtRelaxed)
		result[1] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousYoke)
		result[2] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousCuffsFront)
		result[3] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousArmbinder)
	; TODO: check for linked cuffs
		result[4] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousArmbinderElbow)
	; TODO: check for linked cuffs
		result[5] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousPetSuit)
		result[6] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousElbowTie)
		result[7] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousBondageMittens)
		result[8] = True
	EndIf
	If akActor.WornHasKeyword(libs.zad_DeviousStraitJacket)
		result[9] = True
	EndIf
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
        If overrideKeys.Find("UnforgivingDevices.esm") >= 0
            NiOverride.RemoveNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esm")
            UpdateNiOPosition = True
        EndIf
        ; checking if actor has SexLab HH and DD overrides on override is not present
        ; TODO: Can be done as a shift by the sum of all vectors
        If overrideKeys.Find("DDC") < 0 && overrideKeys.Find("DDPET") < 0 && overrideKeys.Find("internal") >= 0
            float[] pos = NiOverride.GetNodeTransformPosition(akActor, false, isRealFemale, "NPC", "internal")
            pos[0] = -pos[0]
            pos[1] = -pos[1]
            pos[2] = -pos[2]
            NiOverride.AddNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esm", pos)
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
        bool UpdateNiOPosition = NiOverride.RemoveNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esm")
        if UpdateNiOPosition
            NiOverride.UpdateNodeTransform(akActor, false, isRealFemale, "NPC")
        endIf
    endIf
EndFunction