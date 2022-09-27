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
sslSystemConfig                         Property slConfig                           Hidden
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


;============================================================
;======================LOCAL VARIABLES=======================
;============================================================

Bool ZAZAnimationsInstalled = false

;============================================================
;========================FUNCTIONS===========================
;============================================================

; / NOT USED ANYMORE

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
    if animation == "none"
        UDmain.Warning("StartThirdPersonAnimation - Called animation is None, aborting")
        return false
    endif
    
    LockAnimatingActor(akActor)
    
    Debug.SendAnimationEvent(akActor, animation)
    
    return true
EndFunction

;reduced endanimation function
;doesn't enable actor movement and doesn't check if actor is valid
;doesn't check camera state
Function FastEndThirdPersonAnimation(actor akActor)
    
    UnlockAnimatingActor(akActor)
    
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
    If animationA1 == "none" && animationA1 == "none"
        UDmain.Error("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() animationA1 is None, aborting")
        Return False
    ElseIf animationA1 == "none"
        UDmain.Log("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() animation for Actor 1 is None, using solo animation for the Actor 2")
        Return FastStartThirdPersonAnimation(akHelper, animationA2)
    ElseIf animationA2 == "none"
        UDmain.Log("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() animation for Actor 2 is None, using solo animation for the Actor 1")
        Return FastStartThirdPersonAnimation(akActor, animationA1)
    endif
    
    ; locking actors
    LockAnimatingActor(akActor)
    LockAnimatingActor(akHelper)
    
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
        Else
            UDMain.Error("UD_AnimationManagerScript::FastStartThirdPersonAnimationWithHelper() Failed to load vehicle marker form")
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
; TODO: remove high heels

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
    ;unequip shield
    Form loc_shield = GetShield(akActor)
    if loc_shield
        akActor.UnequipItem(loc_shield, true, true)
        StorageUtil.SetFormValue(akActor, "UD_UnequippedShield", loc_shield)
    endif

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
    Form loc_shield = StorageUtil.GetFormValue(akActor, "UD_UnequippedShield", none)
    if loc_shield
        StorageUtil.UnsetFormValue(akActor,"UD_UnequippedShield")
        akActor.equipItem(loc_shield,false,true)
        StorageUtil.UnSetFormValue(akActor,"UD_UnequippedShield")
    endif
EndFunction

; array with loaded json files
String[] UD_StruggleAnimDefs

; For debug purposes. Remove in prod
; Forces to reload json files on every use
Bool forceReloadFiles = true

; function to preload and check for errors json files with animation defs
Function LoadAnimationJSONFiles()
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::LoadAnimationJSONFiles()")
    EndIf
    UD_StruggleAnimDefs = JsonUtil.JsonInFolder("UD/StruggleAnims")
    Int i = 0
    While i < UD_StruggleAnimDefs.Length
        String file = "UD/StruggleAnims/" + UD_StruggleAnimDefs[i]
        JsonUtil.Unload(file)
        If JsonUtil.Load(file) && JsonUtil.IsGood(file)
; TODO: Check for dependencies (loaded esp or SLAL packs)
            i += 1
        Else
            UDMain.Warning("UD_AnimationManagerScript::LoadAnimationJSONFiles() Failed to load json file " + file)
            UDMain.Warning("UD_AnimationManagerScript::LoadAnimationJSONFiles() Found errors: " + JsonUtil.GetErrors(file))
            PapyrusUtil.RemoveString(UD_StruggleAnimDefs, UD_StruggleAnimDefs[i])
        EndIf
    EndWhile
EndFunction
           

; Function GetStrugglePairAnimationsByKeyword
; akActor       - 
; akHelper      - 
; akKeyword     - device keyword to struggle from
; abActorState  - bool[10] additional constraints for akActor (see below fro the list of possible constraints)
; bHelperState  - bool[10] additional constraints for akHelper (see below fro the list of possible constraints)
; return        - string array of found animations for the actors. To get animation for the akActor and akHelper add A1 or A2 to the end
; Possible constraints:
; [0] hobble skirt 
; [1] bound ankles
; [2] yoke
; [3] wrists bound in front
; [4] armbinder
; [5] elbowbinder
; [6] pet suit
; [7] elbowtie
; [8] mittens
; [9] straitjacket
;
; JSON file syntax
;{
;   "paired": {
;       "zad_DeviousArmCuffs" : [                                   Device keyword
;           {
;               "animation" : "PS_Babo_Conquering04_S1_",               Animation base name. To get animation events for the akActor and akHelper add A1 or A2 to the end
;               "reqConstraintsA1" : 0,                                 Required constraints for the akActor (see description for _CheckAnimationConstraints)
;               "optConstraintsA1" : 0,                                 Optional constraints for the akActor (see description for _CheckAnimationConstraints)
;               "reqConstraintsA2" : 0,                                 Required constraints for the akHelper (see description for _CheckAnimationConstraints)
;               "optConstraintsA2" : 0,                                 Optional constraints for the akHelper (see description for _CheckAnimationConstraints)
;               "lewd" : 0,                                             Rate of lewdiness
;               "aggressive" : 1,                                       Rate of aggressiveness (from akHelper towards akActor). Could be negative
;               "forced" : true                                         First forced animation will be the only animation in result array. Used to test animation in game with forceReloadFiles = true
;           },
;           ...
;       ], 
;       ...
;   }
;}
string[] Function GetStruggleAnimationsByKeywordWithHelper(Keyword akKeyword, Bool[] abActorConstraints, Bool[] abHelperConstraints)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetStruggleAnimationsByKeywordWithHelper() akKeyword = " + akKeyword.GetString() + ", abActorConstraints = " + abActorConstraints + ", abHelperConstraints = " + abHelperConstraints)
    EndIf
    Int iActorConstraints = _FromContraintsBoolArrayToInt(abActorConstraints)
    Int iHelperConstraints = _FromContraintsBoolArrayToInt(abHelperConstraints)
    String[] result_temp = new String[10]
    Int resultCount = 0
    
    If forceReloadFiles
        UDMain.Info("UD_AnimationManagerScript::GetStruggleAnimationsByKeywordWithHelper() Reloading json files since flag 'forceReloadFiles' is set")
        LoadAnimationJSONFiles()
    EndIf
    
    Int i = 0
    While i < UD_StruggleAnimDefs.Length
        String file = "UD/StruggleAnims/" + UD_StruggleAnimDefs[i]
        String dict_path = ".paired." + akKeyword.GetString()
        Int path_count = JsonUtil.PathCount(file, dict_path)
        Int j = 0
        While j < path_count
            String anim_path = dict_path + "[" + j + "]"
            Bool forced = JsonUtil.GetPathBoolValue(file, anim_path + ".forced")
            If forced 
                String[] result_forced = new String[1]
                result_forced[0] = JsonUtil.GetPathStringValue(file, anim_path + ".animation")
                UDMain.Info("UD_AnimationManagerScript::GetStruggleAnimationsByKeywordWithHelper() Returning the first forced animation: " + result_forced[0])
                Return result_forced
            EndIf
            Int anim_reqConstrA1 = JsonUtil.GetPathIntValue(file, anim_path + ".reqConstraintsA1")
            Int anim_optConstrA1 = JsonUtil.GetPathIntValue(file, anim_path + ".optConstraintsA1")
            Int anim_reqConstrA2 = JsonUtil.GetPathIntValue(file, anim_path + ".reqConstraintsA2")
            Int anim_optConstrA2 = JsonUtil.GetPathIntValue(file, anim_path + ".optConstraintsA2")
            If _CheckAnimationConstraints(iActorConstraints, anim_reqConstrA1, anim_optConstrA1) && _CheckAnimationConstraints(iHelperConstraints, anim_reqConstrA2, anim_optConstrA2)
                result_temp[resultCount] = JsonUtil.GetPathStringValue(file, anim_path + ".animation")
                resultCount += 1
                If resultCount == result_temp.length
                    result_temp = Utility.ResizeStringArray(result_temp, result_temp.length + 10)
                EndIf
                If UDmain.TraceAllowed()
                    UDmain.Log("UD_AnimationManagerScript::GetStruggleAnimationsByKeywordWithHelper() Filling animation list: pushing into array " + result_temp[resultCount - 1])
                EndIf
            EndIf
            j += 1
        EndWhile
        i += 1
    EndWhile
    Return Utility.ResizeStringArray(result_temp, resultCount)
EndFunction

; Return array with animations for solo struggling
; 
;
; JSON file syntax
;{
;   "solo": {
;       "zad_DeviousPetSuit" : [                                   Device keyword
;           {
;               "animation" : "UD_Struggle_PetSuit_Solo01_A1",          Animation event name.
;               "reqConstraintsA1" : 0,                                 Required constraints for the akActor (see description for _CheckAnimationConstraints)
;               "optConstraintsA1" : 0,                                 Optional constraints for the akActor (see description for _CheckAnimationConstraints)
;               "lewd" : 0,                                             Rate of lewdiness
;               "aggressive" : 1,                                       Rate of aggressiveness (from akHelper towards akActor). Could be negative
;               "forced" : true                                         First forced animation will be the only animation in result array. Used to test animation in game with forceReloadFiles = true
;           },
;           ...
;       ], 
;       ...
;   }
;}
;
; Possible constraints:
; [0] hobble skirt 
; [1] bound ankles
; [2] yoke
; [3] wrists bound in front
; [4] armbinder
; [5] elbowbinder
; [6] pet suit
; [7] elbowtie
; [8] mittens
; [9] straitjacket
String[] Function GetStruggleAnimationsByKeyword2(Keyword akKeyword, Bool[] abActorConstraints)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetStruggleAnimationsByKeyword2 akKeyword = " + akKeyword.GetString() + ", abActorConstraints = " + abActorConstraints)
    EndIf
    Int iActorConstraints = _FromContraintsBoolArrayToInt(abActorConstraints)
    String[] result_temp = new String[10]
    Int resultCount = 0
    
    If forceReloadFiles
        UDMain.Info("UD_AnimationManagerScript::GetStruggleAnimationsByKeyword2() Reloading json files since flag 'forceReloadFiles' is set")
        LoadAnimationJSONFiles()
    EndIf
    Int i = 0
    While i < UD_StruggleAnimDefs.Length
        String file = "UD/StruggleAnims/" + UD_StruggleAnimDefs[i]
        String dict_path = ".solo." + akKeyword.GetString()
        Int path_count = JsonUtil.PathCount(file, dict_path)
        Int j = 0
        While j < path_count
            String anim_path = dict_path + "[" + j + "]"
            Bool forced = JsonUtil.GetPathBoolValue(file, anim_path + ".forced")
            If forced 
                String[] result_forced = new String[1]
                result_forced[0] = JsonUtil.GetPathStringValue(file, anim_path + ".animation")
                UDMain.Info("UD_AnimationManagerScript::GetStruggleAnimationsByKeyword2() Returning the first forced animation: " + result_forced[0])
                Return result_forced
            EndIf
            Int anim_reqConstrA1 = JsonUtil.GetPathIntValue(file, anim_path + ".reqConstraintsA1")
            Int anim_optConstrA1 = JsonUtil.GetPathIntValue(file, anim_path + ".optConstraintsA1")
            If _CheckAnimationConstraints(iActorConstraints, anim_reqConstrA1, anim_optConstrA1)
                result_temp[resultCount] = JsonUtil.GetPathStringValue(file, anim_path + ".animation")
                resultCount += 1
                If resultCount == result_temp.length
                    result_temp = Utility.ResizeStringArray(result_temp, result_temp.length + 10)
                EndIf
                If UDmain.TraceAllowed()
                    UDmain.Log("UD_AnimationManagerScript::GetStruggleAnimationsByKeyword2() Filling animation list: pushing into array " + result_temp[resultCount - 1])
                EndIf
            EndIf
            j += 1
        EndWhile
        i += 1
    EndWhile
    Return Utility.ResizeStringArray(result_temp, resultCount)

EndFunction

; checks compatibility between constraints applied to actor and constraints in animation
; actorConstraints      - actor contraints as Int
; animReqConstraints    - animation required constraints as Int (animation shouldn't be picked if player doesn't have all required constraints)
; animOptConstraints    - animation optional constraints as Int (animation shouldn't be picked if player has constraints not defined by this bit-mask)
Bool Function _CheckAnimationConstraints(Int actorConstraints, Int animReqConstraints, Int animOptConstraints)

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
; added dependency for NiOverride
Function _RemoveHeelEffect(Actor akActor, Bool bRemoveHDT = true, Bool bRemoveNiOverride = true)
    If !akActor.GetWornForm(0x00000080)
        Return
    EndIf
    If slConfig == None
        Return
    EndIf
    if slConfig.HasNiOverride && bRemoveHDT
        Bool isRealFemale = (akActor.GetLeveledActorBase().GetSex() == 1)
        ; Remove NiOverride SexLab High Heels
        bool UpdateNiOPosition = NiOverride.RemoveNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esm")
        ; Remove NiOverride High Heels
        if NiOverride.HasNodeTransformPosition(akActor, false, isRealFemale, "NPC", "internal")
            float[] pos = NiOverride.GetNodeTransformPosition(akActor, false, isRealFemale, "NPC", "internal")
            pos[0] = -pos[0]
            pos[1] = -pos[1]
            pos[2] = -pos[2]
            NiOverride.AddNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esm", pos)
            NiOverride.UpdateNodeTransform(akActor, false, isRealFemale, "NPC")
        elseIf UpdateNiOPosition
            NiOverride.UpdateNodeTransform(akActor, false, isRealFemale, "NPC")
        endIf
    endIf
    if bRemoveNiOverride
        Spell hdtHeelSpell = slConfig.GetHDTSpell(akActor)
        if hdtHeelSpell
            StorageUtil.SetFormValue(akActor, "UD_AnimationManager_HDTHeelSpell", hdtHeelSpell)
            akActor.RemoveSpell(hdtHeelSpell)
        endIf
    endIf
EndFunction

; compilation of the code from SexLab functions
; added dependency for NiOverride
Function _RestoreHeelEffect(Actor akActor)
    If !akActor.GetWornForm(0x00000080)
        Return
    EndIf
    If slConfig == None
        Return
    EndIf
    if slConfig.RemoveHeelEffect
        ; HDT High Heel
        Spell hdtHeelSpell = StorageUtil.GetFormValue(akActor, "UD_AnimationManager_HDTHeelSpell") as Spell
        if hdtHeelSpell && akActor.GetWornForm(0x00000080) && !akActor.HasSpell(hdtHeelSpell)
            akActor.AddSpell(hdtHeelSpell)
        endIf
        StorageUtil.UnsetFormValue(akActor, "UD_AnimationManager_HDTHeelSpell")
    endIf
    if slConfig.HasNiOverride
        Bool isRealFemale = (akActor.GetLeveledActorBase().GetSex() == 1)
        bool UpdateNiOPosition = NiOverride.RemoveNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esm")
        bool UpdateNiOScale = NiOverride.RemoveNodeTransformScale(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esm")
        if UpdateNiOPosition || UpdateNiOScale ; I make the variables because not sure if execute both funtion in OR condition.
            NiOverride.UpdateNodeTransform(akActor, false, isRealFemale, "NPC")
        endIf
    endIf
EndFunction