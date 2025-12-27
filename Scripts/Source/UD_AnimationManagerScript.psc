;/   File: UD_AnimationManager
     The module contains functions for manipulating animations and for working with the animation database.
     
     *Used terms:*
     
        *Animation event* (anim. event or AnimEvent) - is the minimum unit of animation that game operates with. Custom anim. events 
        can be created with FNIS tools and browsed in the Creation Kit's Animation window.

        *Animation sequence* - a sequence of animation events. A specially created sequence in which only the first 
        element can be explicitly called (anim event). And then only a sequential transition through the sequence is possible.

        *Animation definition* (anim. def. or AnimDef) - definition of animation in json files that UDAM uses. 
        It is a part of a json file that defines animation events for one or two actor with conditions for use 
        (actor constraints, levels of aggression or perversity). Within a single AnimDef, animation events for actors are 
        mutually compatible. In UDAM AnimDef is passed between functions as a string formatted like "<file_name>:<path_in_file>".
        See example section in <GetAnimationsFromDB>.
/;
Scriptname UD_AnimationManagerScript extends Quest

import UD_Native

UnforgivingDevicesMain                 Property     UDmain                  Auto
UDCustomDeviceMain                     Property     UDCDmain                        Hidden
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
zadlibs                                Property     libs                    Auto
sslSystemConfig                        Property     slConfig                Auto
{SexLab config object to check NiOverride}
Static                                 Property     VehicleMarkerForm       Auto
{XMarker Static to place vehicle marker for animating actors}

;/  Group: Config
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: Ready
    Will be toggled to True once script is ready.
    
    Do not edit, *READ ONLY!*.
/;
Bool                                   Property     Ready         = False   Auto    Hidden

;/  Variable: UD_AnimationJSON_All
    Array with all json files found in "<Data>/SKSE/Plugins/StorageUtilData/UD/Animations/" folder.
    
    Do not edit, *READ ONLY!*.
    
    See <LoadAnimationJSONFiles>.
/;
String[]                               Property     UD_AnimationJSON_All    Auto    Hidden

;/  Variable: UD_AnimationJSON_Status
    Array with load statuses for the files in UD_AnimationJSON_All array.
    Possible values:
    0       OK
    1       Disabled by the player
    2       Conditions not met
    3       Parsing errors
    
    Do not edit, *READ ONLY!*.
    
    See <LoadAnimationJSONFiles>.
/;
Int[]                               Property     UD_AnimationJSON_Status    Auto    Hidden

;/  Variable: UD_AnimationJSON_Error
    Array with load errors for the files in UD_AnimationJSON_All array.
    Possible values:
    ""              everything is OK
    <file>          absent json or esp file from the condition
    <json errors>   json parsing errors
    
    Do not edit, *READ ONLY!*.
    
    See <LoadAnimationJSONFiles>.
/;
String[]                               Property     UD_AnimationJSON_Error    Auto    Hidden

;/  Variable: UD_AnimationJSON_Off
    Array (more like set) with file names disabled by the player in MCM.

    Do not edit, *READ ONLY!*. Configurable on MCM Animation page by user.
    
    See <LoadAnimationJSONFiles>
/;
String[]                               Property     UD_AnimationJSON_Off    Auto    Hidden

;/  Variable: UD_AlternateAnimation
    Enabling this will force struggle animation to randomly switch to different animation periodically. See <UD_AlternateAnimationPeriod>.
    
    Do not edit, *READ ONLY!*. Configurable on MCM Animation page by user.
/;
Bool                                   Property     UD_AlternateAnimation       = False     Auto    Hidden

;/  Variable: UD_AlternateAnimationPeriod
    Animation is picked from an array of suitable ones with a given period. See <UD_AlternateAnimation>.
    
    Do not edit, *READ ONLY!*. Configurable on MCM Animation page by user.
/;
Int                                    Property     UD_AlternateAnimationPeriod = 5         Auto    Hidden

;/  Variable: UD_UseSingleStruggleKeyword
    If this option is enabled, then only one (defining) device keyword will be used when filtering the struggle animation. Otherwise, all suitable keywords will be used.
    
    Do not edit, *READ ONLY!*. Configurable on MCM Animation page by user.
/;
Bool                                   Property     UD_UseSingleStruggleKeyword = True      Auto    Hidden

Bool _UseUnsafeLogging = False

;============================================================
;========================FUNCTIONS===========================
;============================================================

Function OnInit()
    RegisterForSingleUpdate(10.0)
    Ready = True
EndFunction

Function OnUpdate()
    if UDmain.UDReady()
        Update()
    else
        RegisterForSingleUpdate(20.0)
    endif
EndFunction

Function Update()

    LoadAnimationJSONFiles()
    
;    _Benchmark()

    _UseUnsafeLogging = False
    
    _CheckAndLoadForms()
EndFunction

Function _CheckAndLoadForms()
    If !slConfig
        slConfig = (Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig)
        If !slConfig
            slConfig = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig)
        EndIf
        If !slConfig
            UDmain.Error("UD_AnimationManagerScript::_CheckAndLoadForms() Can't find SexLab system config object!")
        EndIf
    EndIf
    If !VehicleMarkerForm
        VehicleMarkerForm = Game.GetForm(0x0000003B) as Static
    EndIf
EndFunction

; Function LoadDefaultMCMSettings
; Load default values for properties on MCM page
Function LoadDefaultMCMSettings()
    UD_AnimationJSON_Off = PapyrusUtil.StringArray(0)
    LoadAnimationJSONFiles()
    UD_AlternateAnimation = False
    UD_AlternateAnimationPeriod = 5
    UD_UseSingleStruggleKeyword = True
EndFunction

;/  Group: Animation Playback
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: StartSoloAnimationSequence

    This function prepares the actor and starts an animation sequence for it. The animation sequence is quickly scrolls to the last animation event, which is played until the animation is interrupted from the outside (for example, by the <StopAnimation> function).

    Using this function, you can trigger any animation event, even defined in the middle of the sequence.
    
    Parameters:
        akActor                - Target actor.
        aasAnimation           - Animation sequence (array of animation events) to play.
        abContinueAnimation    - True value means that animation is applied for already locked (and aligned) actor(s).
        abDisableActor         - If true then actor should be disabled before the animation starts (see <UDCustomDeviceMain.psc:DisableActor>).
        
    Returns:
        True if animation was started
/;
Bool Function StartSoloAnimationSequence(Actor akActor, String[] aasAnimation, Bool abContinueAnimation = False, Bool abDisableActor = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::StartSoloAnimationSequence() akActor = " + akActor + ", aasAnimation = " + aasAnimation + ", abContinueAnimation = " + abContinueAnimation, 3)
    EndIf
    If (aasAnimation.Length == 0 || aasAnimation[0] == "" || aasAnimation[0] == "none")
        UDmain.Warning("UD_AnimationManagerScript::StartSoloAnimationSequence() Called animation is None, aborting.")
        Return False
    EndIf
    If IsInFurniture(akActor)
        UDmain.Warning("UD_AnimationManagerScript::StartSoloAnimationSequence() Can't start animation because actor is in furniture.")
        Return False
    EndIf
    If !abContinueAnimation
        If UD_Native.IsPlayer(akActor)
            _Apply3rdPersonCamera(abDismount = True)
        EndIf
        LockAnimatingActor(akActor, abDisableActor)
    EndIf

    ; in case it called just after paired animation (for example, during orgasm ending)
    akActor.SetVehicle(None)

    Int a_index = 0
    While a_index < aasAnimation.Length
        Debug.SendAnimationEvent(akActor, aasAnimation[a_index])
        a_index += 1
        If a_index < aasAnimation.Length 
            Utility.Wait(0.05)
        EndIf
    EndWhile
    
    ;If !abContinueAnimation
    ;    ; unequipping the shield again after starting the animation
    ;    If StorageUtil.HasFormValue(akActor, "UD_EquippedShield")
    ;        akActor.UnequipItemSlot(39)
    ;    EndIf
    ;EndIf
    Return True
EndFunction

;/  Function: StartSoloAnimation

    This function prepares the actor and starts an animation. 
    
    It is wrapper of <StartSoloAnimationSequence> function to use with single animation event.
    
    Parameters:
        akActor                - Target actor.
        asAnimation            - Animation to play.
        abContinueAnimation    - True value means that animation is applied for already locked actor.
        abDisableActor         - If true then actor should be disabled before the animation starts (see <UDCustomDeviceMain.psc:DisableActor>).
        
    Returns:
        True if animation was started
/;
Bool Function StartSoloAnimation(Actor akActor, String asAnimation, Bool abContinueAnimation = False, Bool abDisableActor = True)
    String[] loc_anims = new String[1]
    loc_anims[0] = asAnimation
    Return StartSoloAnimationSequence(akActor, loc_anims, abContinueAnimation, abDisableActor)
EndFunction

;/  Function: StartPairAnimationSequence

    This function prepares two actors and starts an animation sequence for them. The animation sequences is quickly scrolls to the last animation events, which are played until the animation is interrupted from the outside (for example, by the <StopAnimation> function).

    Using this function, you can trigger any animation events, even defined in the middle of the sequences.
    
    Parameters:
        akActor                - First actor.
        akHelper               - Second actor (helper).
        aasAnimationA1         - Animation sequence (array of animation events) to play for the first actor.
        aasAnimationA2         - Animation sequence (array of animation events) to play for the second actor.
        abAlignActors          - If true then actors should be aligned before the animation starts.
        abContinueAnimation    - True value means that animation is applied for already locked (and aligned) actors.
        abDisableActors        - If true then actorы should be disabled before the animation starts (see <UDCustomDeviceMain.psc:DisableActor>).
        
    Returns:
        True if animation was started.
/;
Bool Function StartPairAnimationSequence(Actor akActor, Actor akHelper, String[] aasAnimationA1, String[] aasAnimationA2, Bool abAlignActors = True, Bool abContinueAnimation = False, Bool abDisableActors = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::StartPairAnimationSequence() akActor = " + akActor + ", akHelper = " + akHelper + ", aasAnimationA1 = " + aasAnimationA1 + ", aasAnimationA2 = " + aasAnimationA2 + ", abAlignActors = " + abAlignActors + ", abContinueAnimation = " + abContinueAnimation + ", abDisableActors = " + abDisableActors, 3)
    EndIf
    If akActor == None 
        UDmain.Error("UD_AnimationManagerScript::StartPairAnimationSequence() akActor is None, aborting.")
        Return False
    EndIf
    If akHelper == None
        Return StartSoloAnimationSequence(akActor, aasAnimationA1, abContinueAnimation, abDisableActors)
    EndIf
    If IsInFurniture(akActor) || IsInFurniture(akHelper)
        UDmain.Warning("UD_AnimationManagerScript::StartSoloAnimationSequence() Can't start animation because one of actors is in furniture.")
        Return False
    EndIf
    Bool a1_is_none = (aasAnimationA1.Length == 0 || aasAnimationA1[0] == "" || aasAnimationA1[0] == "none")
    Bool a2_is_none = (aasAnimationA2.Length == 0 || aasAnimationA2[0] == "" || aasAnimationA2[0] == "none")
    If a1_is_none && a2_is_none
        UDmain.Error("UD_AnimationManagerScript::StartPairAnimationSequence() animations is None, aborting.")
        Return False
    ElseIf a1_is_none
        UDmain.Log("UD_AnimationManagerScript::StartPairAnimationSequence() animation for Actor 1 is None, using solo animation for the Actor 2.")
        Return StartSoloAnimationSequence(akHelper, aasAnimationA2, abContinueAnimation, abDisableActors)
    ElseIf a2_is_none
        UDmain.Log("UD_AnimationManagerScript::StartPairAnimationSequence() animation for Actor 2 is None, using solo animation for the Actor 1.")
        Return StartSoloAnimationSequence(akActor, aasAnimationA1, abContinueAnimation, abDisableActors)
    EndIf
    
    If !abContinueAnimation
        If UD_Native.IsPlayer(akActor) || UD_Native.IsPlayer(akHelper)
            _Apply3rdPersonCamera(abDismount = False)
        EndIf
        ; locking actors, disable actors control/movement
        LockAnimatingActor(akActor, abDisableActors)
        LockAnimatingActor(akHelper, abDisableActors)
        ; removing HH
        _RemoveHeelEffect(akActor)
        _RemoveHeelEffect(akHelper)
        _SaveActorPosition(akActor, abSavePos = False, abSaveAngle = True, akHeadingTarget = akHelper)
        _SaveActorPosition(akHelper, abSavePos = True, abSaveAngle = True, akHeadingTarget = akActor)
    EndIf
    
    ObjectReference vehicleMarkerRef = None
    If !abContinueAnimation && abAlignActors
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

    Int seq_length = aasAnimationA1.Length
    If seq_length < aasAnimationA2.Length
        seq_length = aasAnimationA2.Length
    EndIf
    Int index_a1 = aasAnimationA1.Length - seq_length
    Int index_a2 = aasAnimationA2.Length - seq_length
    While index_a1 < aasAnimationA1.Length && index_a2 < aasAnimationA2.Length
        ; sending animation events
        If index_a1 >= 0
            Debug.SendAnimationEvent(akActor, aasAnimationA1[index_a1])
        EndIf
        If index_a2 >= 0
            Debug.SendAnimationEvent(akHelper, aasAnimationA2[index_a2])
        EndIf
        index_a1 += 1
        index_a2 += 1
        If index_a1 < aasAnimationA1.Length && index_a2 < aasAnimationA2.Length 
            Utility.Wait(0.05)
        EndIf
    EndWhile
    
    If !abContinueAnimation && abAlignActors
        akHelper.MoveTo(vehicleMarkerRef)
        akActor.MoveTo(vehicleMarkerRef)
        
        akActor.SetVehicle(vehicleMarkerRef)
        akHelper.SetVehicle(vehicleMarkerRef)
        
        akActor.TranslateToRef(vehicleMarkerRef, 200.0)
        akHelper.TranslateToRef(vehicleMarkerRef, 200.0)
    EndIf
    
    ;If !abContinueAnimation
    ;    ; unequipping the shield again after starting the animation
    ;    If StorageUtil.HasFormValue(akActor, "UD_EquippedShield")
    ;        akActor.UnequipItemSlot(39)
    ;    EndIf
    ;    If StorageUtil.HasFormValue(akHelper, "UD_EquippedShield")
    ;        akHelper.UnequipItemSlot(39)
    ;    EndIf
    ;EndIf
    
    Return True
EndFunction

;/  Function: StartPairAnimation

    This function prepares two actors and starts an animations for them.

    It is wrapper of <StartPairAnimationSequence> function to use with non-sequence animation events.
    
    Parameters:
        akActor                - First actor.
        akHelper               - Second actor (helper).
        asAnimationA1          - Animation sequence (array of animation events) to play for the first actor.
        asAnimationA2          - Animation sequence (array of animation events) to play for the second actor.
        abAlignActors          - If true then actors should be aligned before the animation starts.
        abContinueAnimation    - True value means that animation is applied for already locked (and aligned) actors.
        abDisableActors        - If true then actorы should be disabled before the animation starts (see <UDCustomDeviceMain.psc:DisableActor>).
        
    Returns:
        True if animation was started.
/;
Bool Function StartPairAnimation(Actor akActor, Actor akHelper, String asAnimationA1, String asAnimationA2, Bool abAlignActors = True, Bool abContinueAnimation = False, Bool abDisableActors = True)
    String[] loc_animA1 = new String[1]
    loc_animA1[0] = asAnimationA1
    String[] loc_animA2 = new String[1]
    loc_animA2[0] = asAnimationA2
    Return StartPairAnimationSequence(akActor, akHelper, loc_animA1, loc_animA2, abAlignActors, abContinueAnimation, abDisableActors)
EndFunction

;/  Function: StopAnimation

    Function to stop any animation and unlock actor(s)
    
    Parameters:

        akActor                - First actor
        akHelper               - Second actor (helper)
        abEnableActors         - If true then actors should be enabled
        aiToggle               - Bitmask for enabling actors: 0x1 - enable first actor, 0x2 - enable second actor.
/;
Function StopAnimation(Actor akActor, Actor akHelper = None, Bool abEnableActors = True, Int aiToggle = 0x3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::StopAnimation() akActor = " + akActor + ", akHelper = " + akHelper, 3)
    EndIf
    
    Bool loc_stopActor  = Math.LogicalAnd(aiToggle, 0x1)
    Bool loc_stopHelper = Math.LogicalAnd(aiToggle, 0x2)
    
    if loc_stopActor && IsInFurniture(akActor)
        loc_stopActor = False
        UDmain.Warning("UD_AnimationManagerScript::StartSoloAnimationSequence() Can't stop animation because actor is in furniture.")
    endif
    
    if loc_stopHelper && IsInFurniture(akHelper)
        loc_stopHelper = False
        UDmain.Warning("UD_AnimationManagerScript::StartSoloAnimationSequence() Can't stop animation because helper is in furniture.")
    endif
    
    if loc_stopActor
        ; restoring HH if it was removed in StartPairAnimation
        _RestoreHeelEffect(akActor)
        Debug.SendAnimationEvent(akActor, "AnimObjectUnequip")
        Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
        
        ;unlock actor after animation stops
        UnlockAnimatingActor(akActor, abEnableActors)
    endif
    
    If akHelper != None && loc_stopHelper
        if loc_stopActor ;only restore position if actors animation should be stopped
            _RestoreActorPosition(akActor) ;only move player if there are 2 actors, otherwise solo animation is player and there is no need to move player
        endif
        
        ; restoring HH if it was removed in StartPairAnimation
        _RestoreHeelEffect(akHelper)
        Debug.SendAnimationEvent(akHelper, "AnimObjectUnequip")
        Debug.SendAnimationEvent(akHelper, "IdleForceDefaultState")
        
        ;unlock actor after animation stops
        UnlockAnimatingActor(akHelper, abEnableActors)
        
        _RestoreActorPosition(akHelper)
    EndIf
    If (loc_stopActor && UD_Native.IsPlayer(akActor)) || (loc_stopHelper && UD_Native.IsPlayer(akHelper))
        _RestorePlayerCamera()
    EndIf
EndFunction

;/  Group: Animation Utility
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: IsAnimating

    Function to check if actor is in animation.
    
    Parameters:
        akActor                - Actor.
        abBonusCheck           - Extra checking (more accurate but time consuming).
        
    Returns:
        True if actor is currently in animation.
/;
Bool Function IsAnimating(Actor akActor, Bool abBonusCheck = True)
    If StorageUtil.GetIntValue(akActor, "UD_ActorIsAnimating", 0) == 1
        Return True
    EndIf
    Return abBonusCheck && libs.IsAnimating(akActor)
EndFunction

;/  Function: IsInFurniture

    Function to check if actor is in animation.
    
    Parameters:
        akActor                - Actor.
        
    Returns:
        True if actor is currently in furniture.
/;
Bool Function IsInFurniture(Actor akActor)
    Return akActor && UDMain.libsc.GetDevice(akActor)
EndFunction

;/  Function: LockAnimatingActor

    Function to lock and prepare actor to perform in animation.
    
    Parameters:
        akActor               - Actor.
        abDisableActor        - Disable actor (NPC or player) controls.
/;
Function LockAnimatingActor(Actor akActor, Bool abDisableActor = True)

    If IsAnimating(akActor)
        Return
    EndIf
    
    UnforgivingDevicesMain.DisableWeapons(akActor)
    
    StorageUtil.SetIntValue(akActor, "UD_ActorIsAnimating", 1)
    
    libs.SetAnimating(akActor, True)
    UD_Native.ForceUpdateControls()
    
    if abDisableActor
        UDCDMain.DisableActor(akActor)
    endif

    If !UD_Native.IsPlayer(akActor)
        akActor.ClearLookAt()
        akActor.SetHeadTracking(False)
        akActor.SetAnimationVariableInt("IsNPC", 0)
        akActor.SetAnimationVariableBool("bHeadTrackSpine", False)
    EndIf
EndFunction

;/  Function: UnlockAnimatingActor

    Function to unlock actor after animation.
    
    Parameters:
        akActor               - Actor.
        abEnableActor         - Enable actor (NPC or player) controls.
/;
Function UnlockAnimatingActor(Actor akActor, Bool abEnableActor = True)

    StorageUtil.SetIntValue(akActor, "UD_ActorIsAnimating", 0)
    libs.SetAnimating(akActor, False)
    UD_Native.ForceUpdateControls()
    
    if abEnableActor
        UDCDMain.EnableActor(akActor)
    endif
    
    If !UD_Native.IsPlayer(akActor)
        akActor.SetHeadTracking(True)
        akActor.SetAnimationVariableInt("IsNPC", 1)
        akActor.SetAnimationVariableBool("bHeadTrackSpine", True)
    EndIf
    
    akActor.SetVehicle(None)
    
    UnforgivingDevicesMain.EnableWeapons(akActor)
EndFunction

;/  Function: SetActorHeading

    Sets the direction of the actor to the specified object.
    
    Parameters:
        akActor               - Actor.
        akHeadingTarget       - The object the actor should be aimed at.
/;
Function SetActorHeading(Actor akActor, ObjectReference akHeadingTarget)
    If akActor == None || akHeadingTarget == None
        Return
    EndIf
    Float a = akActor.GetAngleZ()
    If akHeadingTarget != None
        a += akActor.GetHeadingAngle(akHeadingTarget)
    EndIf
    If UD_Native.IsPlayer(akActor)
        akActor.SetAngle(0, 0, a)
    Else
        akActor.TranslateTo(akActor.X, akActor.Y, akActor.Z, 0, 0, a, 150, 180)
    EndIf
EndFunction

;/  Function: GetActorConstraintsInt

    The function calculates (if necessary) and returns a bit mask with actor constraints. The calculated value is stored in the actor's local storage and used until it is explicitly invalidated.
    
    Parameters:
        akActor               - Actor.
        abUseCache            - Use value stored in local storage (variable UD_ActorConstraintsInt).
        
    Returns:
        Bit mask with actor constraints
        
        --- Code
        Hobble skirt                      - 0000 0000 0001 / 0x0001 /    1
        Ankle shackel or relaxed skirt    - 0000 0000 0010 / 0x0002 /    2
        Yoke                              - 0000 0000 0100 / 0x0004 /    4
        Front cuffs                       - 0000 0000 1000 / 0x0008 /    8
        Armbinder                         - 0000 0001 0000 / 0x0010 /   16
        Armbinder (Elbow)                 - 0000 0010 0000 / 0x0020 /   32
        Pet suit                          - 0000 0100 0000 / 0x0040 /   64
        Elbowtie                          - 0000 1000 0000 / 0x0080 /  128
        Mittens                           - 0001 0000 0000 / 0x0100 /  256
        Straitjacket                      - 0010 0000 0000 / 0x0200 /  512
        Breast yoke                       - 0100 0000 0000 / 0x0400 / 1024
        Gag                               - 1000 0000 0000 / 0x0800 / 2048
        ---
/;
Int Function GetActorConstraintsInt(Actor akActor, Bool abUseCache = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetActorConstraintsInt() akActor = " + akActor + ", abUseCache = " + abUseCache, 3)
    EndIf
    If akActor == None
        Return 0
    EndIf
    
    ;If abUseCache && StorageUtil.HasIntValue(akActor, "UD_ActorConstraintsInt") && (StorageUtil.GetIntValue(akActor, "UD_ActorConstraintsInt_Invalid", 0) == 0)
    ;    Return StorageUtil.GetIntValue(akActor, "UD_ActorConstraintsInt")
    ;EndIf
    
    Int loc_result = UD_Native.GetActorConstrains(akActor)
    ;StorageUtil.SetIntValue(akActor, "UD_ActorConstraintsInt_Invalid", 0)
    ;StorageUtil.SetIntValue(akActor, "UD_ActorConstraintsInt", loc_result)
    Return loc_result
EndFunction

;/  Function: InvalidateActorConstraintsInt

    Function to invalidate actor's constraints bit mask in its local storage. After invalidating the value, the next <GetActorConstraintsInt> function call will result in an honest calculation of the value.
    
    Parameters:
        akActor               - Actor.
/;
Function InvalidateActorConstraintsInt(Actor akActor)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::InvalidateActorConstraintsInt() akActor = " + akActor, 3)
    EndIf
    If akActor == None
        Return
    EndIf
    ;StorageUtil.SetIntValue(akActor, "UD_ActorConstraintsInt_Invalid", 1)
EndFunction

;/  Function: GetHeavyBondageKeyword

    Fast function to get keyword for the heavy bondage equippied on actor by its constraints int
    
    Parameters:
        aiConstraints               - Actor constraints int (see <GetActorConstraintsInt>).
        
    Returns:
        Zad device keyword.
/;
Keyword Function GetHeavyBondageKeyword(Int aiConstraints)
    If Math.LogicalAnd(aiConstraints, 128) == 128
        Return libs.zad_DeviousElbowTie
    ElseIf Math.LogicalAnd(aiConstraints, 4) == 4
        Return libs.zad_DeviousYoke
    ElseIf Math.LogicalAnd(aiConstraints, 8) == 8
        Return libs.zad_DeviousCuffsFront
    ElseIf Math.LogicalAnd(aiConstraints, 16) == 16
        Return libs.zad_DeviousArmbinder
    ElseIf Math.LogicalAnd(aiConstraints, 32) == 32
        Return libs.zad_DeviousArmbinderElbow
    ElseIf Math.LogicalAnd(aiConstraints, 64) == 64
        Return libs.zad_DeviousPetSuit
    ElseIf Math.LogicalAnd(aiConstraints, 512) == 512
        Return libs.zad_DeviousStraitJacket
    ElseIf Math.LogicalAnd(aiConstraints, 1024) == 1024
        Return libs.zad_DeviousYokeBB
    EndIf
    Return None
EndFunction

;/  Group: Animation Database
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: PlayAnimationByDef

    Function to start animation according to the specified definition from json.
    
    Parameters:
        asAnimDef                   - Animation definition from json, should be in format <file_name>:<path_in_file>.
        aakActors                   - Actors who will participate.
        abContinueAnimation         - Flag that the animation played with already locked actors.
        abDisableActors             - Disable participating actors (see <UDCustomDeviceMain.psc:DisableActor>).
        aiConstraintsOverrideA1     - Override first actor's constraints (see <GetActorConstraintsInt>). A value of -1 means that the original constraints of the actor are used.
        aiConstraintsOverrideA2     - Override second actor's constraints (see <GetActorConstraintsInt>). A value of -1 means that the original constraints of the actor are used.
        
    Returns:
        True if the animations were successfully started.
/;
Bool Function PlayAnimationByDef(String asAnimDef, Actor[] aakActors, Bool abContinueAnimation = False, Bool abDisableActors = True, Int aiConstraintsOverrideA1 = -1, Int aiConstraintsOverrideA2 = -1)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::PlayAnimationByDef() asAnimDef = " + asAnimDef + ", aakActors = " + aakActors + ", abContinueAnimation = " + abContinueAnimation + ", abDisableActors = " + abDisableActors + ", aiConstraintsOverrideA1 = " + aiConstraintsOverrideA1 + ", aiConstraintsOverrideA2 = " + aiConstraintsOverrideA2, 3)
    EndIf
    
    String[] loc_res = UD_Native.GetAnimationsFromJSON(asAnimDef,aakActors,aiConstraintsOverrideA1,aiConstraintsOverrideA2)
    
    if loc_res[0] == "OK"
        int loc_num = loc_res[1] as Int
        if loc_num == -1 ;no sequence
            if aakActors.length == 1
                String loc_anim = loc_res[2]
                StartSoloAnimation(aakActors[0], loc_anim, abContinueAnimation, abDisableActors)
            elseif aakActors.length == 2
                String loc_anim1 = loc_res[2]
                String loc_anim2 = loc_res[3]
                StartPairAnimation(aakActors[0], aakActors[1], loc_anim1, loc_anim2, True, abContinueAnimation, abDisableActors)
            else
                UDMain.Error("Incorrect number of actors")
                return false
            endif
        elseif loc_num > 0 ;sequence
            if aakActors.length == 1
                String[] loc_anims = PapyrusUtil.SliceStringArray(loc_res,2)
                StartSoloAnimationSequence(aakActors[0], loc_anims, abContinueAnimation, abDisableActors)
            elseif aakActors.length == 2
                String[] loc_anims1 = PapyrusUtil.SliceStringArray(loc_res,2,2 + (loc_num - 1))
                String[] loc_anims2 = PapyrusUtil.SliceStringArray(loc_res,2 + loc_num,-1)
                StartPairAnimationSequence(aakActors[0], aakActors[1], loc_anims1, loc_anims2, True, abContinueAnimation, abDisableActors)
            else
                UDMain.Error("Incorrect number of actors")
                return false
            endif
        else
            UDMain.Error("Invalid animation")
            return false
        endif
        
    else
        UDMain.Error("Could not find animation -> " + loc_res[1])
        return false
    endif
    
    return true
EndFunction

;/  Function: LoadAnimationJSONFiles

    In this function, json files with animation bindings to different mod situations are checked and loaded.
    
    During the load process, the conditions described in the "condition" field are taken into account, as well as flags from the <UD_AnimationJSON_Off> array that the file is disabled by the user.
    
    The names of all valid files are stored in the <UD_AnimationJSON> array.
/;
Function LoadAnimationJSONFiles()
    UD_Native.SyncAnimationSetting(UD_AnimationJSON_Off)
    UD_AnimationJSON_All = UD_Native.GetAllAnimationFiles()
    UD_AnimationJSON_Error = UD_Native.GetAllAnimationFilesErrors()
    UD_AnimationJSON_Status = UD_Native.GetAllAnimationFilesStatus()
EndFunction

;/  Function: GetAnimationsFromDB

    The function is used to filter the list of animations (defined in json files) according to the specified criteria. For each suitable animation, the value of the filed specified in the argument "asField" will be extracted and an array of such values will be returned.

    If the value of the asField argument is "", the function returns the paths to the animation definitions in the files (formatted as <json_file>:<path_in_file>).
    
    Parameters:
        asType                   - Type of the animations needed (solo, paired or anything defined in json files as root object). Value should starts with '.' because papyrus sometimes replaces the first character with a capital one.
        aasKeywords              - Animation keywords (device keywords or any other strings like "horny" to define animation). Value should starts with '.' because papyrus sometimes replaces the first character with a capital one.
        asField                  - Field of the animation which should be returned. Or empty string to return animation definitions instead.
        aaiActorConstraints      - Array with constraints for the participating actors as bit mask (see <GetActorConstraintsInt>). if the array consists of a single value, then only solo animations are searched. If there are two values in the array, then paired animations are checked and returned.
        aiLewdMin                - minimum value in "lewd" field.
        aiLewdMin                - maximum value in "lewd" field.
        aiAggroMin               - minimum value in "aggro" field.
        aiAggroMax               - maximum value in "aggro" field.
        
    Returns:
        Array of the field "asField" values, or animation paths in DB (formatted as <json_file>:<path_in_file>) if asField == "".
        
    *Animation JSON file syntax:*
    --- Code
    {
       "conditions": {                                                     Conditions that determine whether the file will be used 
           "mod": "<mod name>",
           "json": "<path to json file relative to SKSE\Plugins\StorageUtilData>"
       },
       "paired": {                                                         Animation type
           "zad_DeviousArmCuffs" : [                                       Animation keyword (device keyword or any other string like "horny" to define animation)
               {
                   "A1" : {
                       "anim" : "<animation event>",                       Animation event
                       "req" : 0,                                          Required constraints for the first actor (animation shouldn't be picked if actor doesn't have all required constraints)
                       "opt" : 0                                           Optional constraints for the first actor (animation shouldn't be picked if actor has constraints not defined by this bit-mask)
                   },
                   "A2" : [                                                Array with variants
                       {
                           "anim" : "<animation event variant 1>",             Animation event for specified actor's constraints
                           "req" : 256,                                        Required constraints for the second actor (animation shouldn't be picked if actor doesn't have all required constraints)
                           "opt" : 0                                           Optional constraints for the second actor (animation shouldn't be picked if actor has constraints not defined by this bit-mask)
                      },
                       {
                           "anim" : "<animation event variant 2>",             Variant for specified actor's constraints
                           "req" : 512,                                        Required constraints for the second actor (animation shouldn't be picked if actor doesn't have all required constraints)
                           "opt" : 0                                           Optional constraints for the second actor (animation shouldn't be picked if actor has constraints not defined by this bit-mask)
                       }
                   ],
                   "lewd" : 0,                                             Rate of lewdiness
                   "aggr" : 1,                                             Rate of aggressiveness (from akHelper towards akActor). Could be negative
               },
               ...
           ], 
           ...
       }
    }
    ---
    string "paired.zad_DeviousArmCuffs[0]" is a path to the AnimDef defined in this example. To get full address it is needed to add file name to it. For example, "UD_Example.json:paired.zad_DeviousArmCuffs[0]"
    
    
/;
String[] Function GetAnimationsFromDB(String asType, String[] aasKeywords, String asField, Int[] aaiActorConstraints, Int aiLewdMin = 0, Int aiLewdMax = 10, Int aiAggroMin = -10, Int aiAggroMax = 10)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetAnimationsFromDB() asType = " + asType + ", aasKeywords = " + aasKeywords + ", asField = " + asField + ", aaiActorConstraints = " + aaiActorConstraints, 3)
    EndIf
    
    String[] loc_res = UD_Native.GetAnimationsFromDB(asType,aasKeywords,asField,aaiActorConstraints,aiLewdMin,aiLewdMax,aiAggroMin,aiAggroMax)
    return loc_res
EndFunction

Bool Function _CheckAnimationLewd(String sFile, String sObjPath, Int aiLewdMin = -10, Int aiLewdMax = 10)
    Int lewd = JsonUtil.GetPathIntValue(sFile, sObjPath + ".lewd", -100)
    Return lewd == -100 || (lewd >= aiLewdMin && lewd <= aiLewdMax)
EndFunction

Bool Function _CheckAnimationAggro(String sFile, String sObjPath, Int aiAggroMin = -10, Int aiAggroMax = 10)
    Int aggro = JsonUtil.GetPathIntValue(sFile, sObjPath + ".aggr", -100)
    Return aggro == -100 || (aggro >= aiAggroMin && aggro <= aiAggroMax)
EndFunction

;/  Function: GetStruggleAnimDefsByKeyword

    This function returns an array of struggle animations for the specified device keyword on actor with optional helper.
    
    Parameters:
        asKeyword                 - Device keyword to struggle from. Should starts with ".".
        akActor                   - Wearer of the device.
        akHelper                  - Optional helper.
        
    Returns:
        Array of strings with animation paths in DB (formatted as <json_file>:<path_in_file>).
/;
String[] Function GetStruggleAnimDefsByKeyword(String asKeyword, Actor akActor, Actor akHelper = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetStruggleAnimDefsByKeyword() asKeyword = " + asKeyword + ", akActor = " + akActor + ", akHelper = " + akHelper, 3)
    EndIf
    String[] asKwd = new String[1]
    asKwd[0] = asKeyword
    If akHelper == None
        Int[] aaiActorConstraints = new Int[1]
        aaiActorConstraints[0] = GetActorConstraintsInt(akActor)
        Return GetAnimationsFromDB(".solo", asKwd, "", aaiActorConstraints)
    Else
        Int[] aaiActorConstraints = new Int[2]
        aaiActorConstraints[0] = GetActorConstraintsInt(akActor)
        aaiActorConstraints[1] = GetActorConstraintsInt(akHelper)
        Return GetAnimationsFromDB(".paired", asKwd, "", aaiActorConstraints)
    EndIf
EndFunction

;/  Function: GetStruggleAnimDefsByKeywordsList

    This function returns an array of struggle animations for the specified device keywords on actor with optional helper.
    
    Parameters:
        aasKeywords               - Device keywords to struggle from. Each string should starts with ".".
        akActor                   - Wearer of the device.
        akHelper                  - Optional helper.
        
    Returns:
        Array of strings with animation paths in DB (formatted as <json_file>:<path_in_file>).
/;
String[] Function GetStruggleAnimDefsByKeywordsList(String[] aasKeywords, Actor akActor, Actor akHelper = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetStruggleAnimDefsByKeyword() aasKeywords = " + aasKeywords + ", akActor = " + akActor + ", akHelper = " + akHelper, 3)
    EndIf

    If akHelper == None
        Int[] loc_constraints = new Int[1]
        loc_constraints[0] = GetActorConstraintsInt(akActor)
        Return GetAnimationsFromDB(".solo", aasKeywords, "", loc_constraints)
    Else
        Int[] loc_constraints = new Int[2]
        loc_constraints[0] = GetActorConstraintsInt(akActor)
        loc_constraints[1] = GetActorConstraintsInt(akHelper)
        Return GetAnimationsFromDB(".paired", aasKeywords, "", loc_constraints)
    EndIf
EndFunction

;/  Function: GetHornyAnimEvents

    Filters and returns horny animation events for the given actor.
    
    Parameters:
        akActor                     - Actor.
        abUseConstraintsIntCache    - If True, then the actor constraints value is calculated on the spot (see <GetActorConstraintsInt>).
        
    Returns:
        Array of strings with animation events.
/;
String[] Function GetHornyAnimEvents(Actor akActor, Bool abUseConstraintsIntCache = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetHornyAnimEvents() akActor = " + akActor, 3)
    EndIf

    Int[] loc_constraints = new Int[1]
    loc_constraints[0] = GetActorConstraintsInt(akActor, abUseConstraintsIntCache)
    String[] loc_keywords = new String[1]
    loc_keywords[0] = ".horny"
    
    Return GetAnimationsFromDB(".solo", loc_keywords, ".A1.anim", loc_constraints)
EndFunction

;/  Function: GetHornyAnimDefs

    Filters and returns horny animations from DB for the given actor.
    
    Parameters:
        akActor                     - Actor.
        
    Returns:
        Array of strings with animation paths in DB (formatted as <json_file>:<path_in_file>).
/;
String[] Function GetHornyAnimDefs(Actor akActor)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetHornyAnimDefs() akActor = " + akActor, 3)
    EndIf

    Int[] loc_constraints = new Int[1]
    loc_constraints[0] = GetActorConstraintsInt(akActor)
    String[] loc_keywords = new String[1]
    loc_keywords[0] = ".horny"
    
    Return GetAnimationsFromDB(".solo", loc_keywords, "", loc_constraints)
EndFunction

;/  Function: GetOrgasmAnimEvents

    Filters and returns orgasm animation events for the given actor.
    
    Parameters:
        akActor                     - Actor.
        abUseConstraintsIntCache    - If True, then the actor constraints value is calculated on the spot (see <GetActorConstraintsInt>).
        
    Returns:
        Array of strings with animation events.
/;
String[] Function GetOrgasmAnimEvents(Actor akActor, Bool abUseConstraintsIntCache = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetOrgasmAnimEvents() akActor = " + akActor, 3)
    EndIf

    Int[] loc_constraints = new Int[1]
    loc_constraints[0] = GetActorConstraintsInt(akActor, abUseConstraintsIntCache)
    String[] loc_keywords
    if (UDmain.UDCONF.UD_OrgasmAnimation == 1)
        loc_keywords = new String[2]
        loc_keywords[0] = ".orgasm"
        loc_keywords[1] = ".horny"
    else
        loc_keywords = new String[1]
        loc_keywords[0] = ".orgasm"
    endif
    Return GetAnimationsFromDB(".solo", loc_keywords, ".A1.anim", loc_constraints)
EndFunction

;/  Function: GetOrgasmAnimDefs

    Filters and returns orgasm animations from DB for the given actor.
    
    Parameters:
        akActor                     - Actor.
        
    Returns:
        Array of strings with animation paths in DB (formatted as <json_file>:<path_in_file>).
/;
String[] Function GetOrgasmAnimDefs(Actor akActor)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetOrgasmAnimDefs() akActor = " + akActor, 3)
    EndIf

    Int[] loc_constraints = new Int[1]
    loc_constraints[0] = GetActorConstraintsInt(akActor)
    String[] loc_keywords = new String[1]
    if (UDmain.UDCONF.UD_OrgasmAnimation == 1)
        loc_keywords = new String[2]
        loc_keywords[0] = ".orgasm"
        loc_keywords[1] = ".horny"
    else
        loc_keywords = new String[1]
        loc_keywords[0] = ".orgasm"
    endif
    
    Return GetAnimationsFromDB(".solo", loc_keywords, "", loc_constraints)
EndFunction

;/  Function: GetEdgedAnimEvents

    Filters and returns edge animation events for the given actor.
    
    Parameters:
        akActor                     - Actor.
        abUseConstraintsIntCache    - If True, then the actor constraints value is calculated on the spot (see <GetActorConstraintsInt>).
        
    Returns:
        Array of strings with animation events
/;
String[] Function GetEdgedAnimEvents(Actor akActor, Bool abUseConstraintsIntCache = True)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetEdgedAnimEvents() akActor = " + akActor, 3)
    EndIf

    Int[] loc_constraints = new Int[1]
    loc_constraints[0] = GetActorConstraintsInt(akActor, abUseConstraintsIntCache)
    String[] loc_keywords = new String[1]
    loc_keywords[0] = ".edged"

    String[] anims = GetAnimationsFromDB(".solo", loc_keywords, ".A1.anim", loc_constraints)

    Return anims
EndFunction

;/  Function: GetEdgedAnimDefs

    Filters and returns edge animations from DB for the given actor.
    
    Parameters:
        akActor                     - Actor.
        
    Returns:
        Array of strings with animation paths in DB (formatted as <json_file>:<path_in_file>).
/;
String[] Function GetEdgedAnimDefs(Actor akActor)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetEdgedAnimDefs() akActor = " + akActor, 3)
    EndIf

    Int[] loc_constraints = new Int[1]
    loc_constraints[0] = GetActorConstraintsInt(akActor)
    String[] loc_keywords = new String[1]
    loc_keywords[0] = ".edged"
    
    String[] anim_defs = GetAnimationsFromDB(".solo", loc_keywords, "", loc_constraints)

    Return anim_defs
EndFunction

;/  Function: GetAnimDefAttribute

    Function to extract attribute (field) value from the animation definition by its path in DB.
    
    Parameters:
        asAnimDef                     - Animation definition path in DB (formatted as <json_file>:<path_in_file>).
        asAttrName                    - Attribute name. Must start with ".".
        asDefault                     - Default value used if no attribute was found.
        
    Returns:
        Attribute value as string or default value specified by asDefault.
/;
String Function GetAnimDefAttribute(String asAnimDef, String asAttrName, String asDefault = "")
    If asAnimDef == ""
        UDMain.Error("UD_AnimationManagerScript::GetAnimDefAttribute() Empty string as an AnimDef!")
        Return asDefault
    EndIf
    Int part_index = StringUtil.Find(asAnimDef, ":")
    If part_index < 0 
        UDMain.Error("UD_AnimationManagerScript::GetAnimDefAttribute() AnimDef has invalid format (should be <file_name>:<path_in_file>)")
        Return asDefault
    EndIf
    String file = "UD/Animations/" + StringUtil.Substring(asAnimDef, 0, part_index)
    String path = StringUtil.Substring(asAnimDef, part_index + 1)
    String res = JsonUtil.GetPathStringValue(file, path + asAttrName, asDefault)
    If res == asDefault
        UDMain.Warning("UD_AnimationManagerScript::GetAnimDefAttribute() Returning default value for the attribute " + asAttrName + " in AnimDef + " + asAnimDef)
    EndIf
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetAnimDefAttribute() asAnimDef = " + asAnimDef + ", asAttrName = " + asAttrName + " Value = " + res, 3)
    EndIf
    Return res
EndFunction

;/  Function: GetAnimDefAttributeArray

    Function to extract attribute (field) value from the animation definition by its path in DB. Same as <GetAnimDefAttribute> but for the array values.
    
    Parameters:
        asAnimDef                     - Animation definition path in DB (formatted as <json_file>:<path_in_file>).
        asAttrName                    - Attribute name. Must start with ".".
        
    Returns:
        Attribute value as string array. Or empty string array if nothing was found.
/;
String[] Function GetAnimDefAttributeArray(String asAnimDef, String asAttrName)
    If asAnimDef == ""
        UDMain.Error("UD_AnimationManagerScript::GetAnimDefAttributeArray() Empty string as an AnimDef!")
        Return PapyrusUtil.StringArray(0)
    EndIf
    Int part_index = StringUtil.Find(asAnimDef, ":")
    If part_index < 0 
        UDMain.Error("UD_AnimationManagerScript::GetAnimDefAttributeArray() AnimDef has invalid format (should be <file_name>:<path_in_file>)")
        Return PapyrusUtil.StringArray(0)
    EndIf
    String file = "UD/Animations/" + StringUtil.Substring(asAnimDef, 0, part_index)
    String path = StringUtil.Substring(asAnimDef, part_index + 1)
    String[] res = JsonUtil.PathStringElements(file, path + asAttrName)
    If res.Length == 0
        UDMain.Warning("UD_AnimationManagerScript::GetAnimDefAttributeArray() Empty array as attribute value " + asAttrName + " in AnimDef + " + asAnimDef)
    EndIf
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AnimationManagerScript::GetAnimDefAttributeArray() asAnimDef = " + asAnimDef + ", asAttrName = " + asAttrName + " Value = " + res, 3)
    EndIf
    Return res
EndFunction

; compilation of the code from SexLab functions
; there is a weak dependence on NiOverride
Function _RemoveHeelEffect(Actor akActor, Bool abRemoveHDT = true, Bool abRemoveNiOverride = true)
    If !akActor.GetWornForm(0x00000080)
        Return
    EndIf
    If slConfig == None
        Return
    EndIf
    if abRemoveNiOverride && slConfig.HasNiOverride
        Bool isRealFemale = (akActor.GetLeveledActorBase().GetSex() == 1)
        Bool UpdateNiOPosition = False
        String[] overrideKeys = NiOverride.GetNodeTransformKeys(akActor, false, isRealFemale, "NPC")
        ; removing previous override
        If overrideKeys.Find("UnforgivingDevices.esp") >= 0
            NiOverride.RemoveNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esp")
            UpdateNiOPosition = True
            overrideKeys = NiOverride.GetNodeTransformKeys(akActor, false, isRealFemale, "NPC")
        EndIf
        ; calculation of the resulting shift from all modificators
        Int i = overrideKeys.Length
        UDmain.Log("UD_AnimationManagerScript::_RemoveHeelEffect() akActor " + akActor + ", overrideKeys[] = " + overrideKeys, 3)
        Float[] shift_sum = new Float[3]
        While i > 0
            i -= 1
            Float[] shift = NiOverride.GetNodeTransformPosition(akActor, false, isRealFemale, "NPC", overrideKeys[i])
            shift_sum[0] = shift_sum[0] - shift[0]
            shift_sum[1] = shift_sum[1] - shift[1]
            shift_sum[2] = shift_sum[2] - shift[2]
;            UDmain.Log("UD_AnimationManagerScript::_RemoveHeelEffect() akActor " + akActor + ", shift_sum[] = " + shift_sum, 3)
        EndWhile
        If shift_sum[0] != 0 || shift_sum[1] != 0 || shift_sum[2] != 0
            NiOverride.AddNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esp", shift_sum)
            UpdateNiOPosition = True
        EndIf
        If UpdateNiOPosition
            NiOverride.UpdateNodeTransform(akActor, false, isRealFemale, "NPC")
        endIf
    endIf
    if abRemoveHDT
        Spell hdtHeelSpell = slConfig.GetHDTSpell(akActor)
        if hdtHeelSpell
;            UDmain.Log("UD_AnimationManagerScript::_RemoveHeelEffect() akActor " + akActor + ", hdtHeelSpell = " + hdtHeelSpell, 3)
            StorageUtil.SetFormValue(akActor, "UD_AnimationManager_HDTHeelSpell", hdtHeelSpell)
            akActor.RemoveSpell(hdtHeelSpell)
        Else
            StorageUtil.UnsetFormValue(akActor, "UD_AnimationManager_HDTHeelSpell")
        endIf
    endIf
EndFunction

; compilation of the code from SexLab functions
; there is a weak dependence on NiOverride
Function _RestoreHeelEffect(Actor akActor)
    ; Needs to remove existing override first because boots may have been removed during the animation.
    if slConfig.HasNiOverride
        Bool isRealFemale = (akActor.GetLeveledActorBase().GetSex() == 1)
        bool UpdateNiOPosition = NiOverride.RemoveNodeTransformPosition(akActor, false, isRealFemale, "NPC", "UnforgivingDevices.esp")
        if UpdateNiOPosition
            NiOverride.UpdateNodeTransform(akActor, false, isRealFemale, "NPC")
        endIf
    endIf
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
EndFunction

; abDismount should not be used with group animations since they are using "mount"
Function _Apply3rdPersonCamera(Bool abDismount = True)
    if UDmain.ImprovedCameraInstalled
        ;UDmain.Log("UD_AnimationManagerScript::_Apply3rdPersonCamera() ImprovedCameraInstalled = true, CameraState = " + Game.GetCameraState())
        ; 0 - first person; 3 - free camera; 9 - third person; 10 - On a horse
        ; TODO: need more tests with free camera
        if UDmain.VRIKInstalled
            UD_VR.VRIKFixStart()
        EndIf
        Game.ForceThirdPerson()
        
        If (abDismount && UDMain.Player.IsOnMount())
            UDMain.Player.Dismount()
            int timeout = 0
            while UDMain.Player.IsOnMount() && timeout <= 30; Wait for dismount to complete
                Utility.Wait(0.1)
                timeout += 1
            EndWhile
            ;UDmain.Log("UD_AnimationManagerScript::_Apply3rdPersonCamera() Dismount waiting, IsOnMount = " + UDMain.Player.IsOnMount() + ", timeout = " + timeout)
        EndIf
        if UDmain.VRIKInstalled
            UD_VR.VRIKFixStart()
        EndIf
        return
    endif

    ; taken from zadLibs.psc
    int cameraOld = Game.GetCameraState()
    if cameraOld == 3 ;free camera, don't do anything, else the cameara can get broekn
    
    ElseIf cameraOld == 8 || cameraOld == 9 || cameraOld ==  7 ;;; 8 / 9 are third person. 7 is tween menu.
    
    elseIf (cameraOld == 10 || UDMain.Player.IsOnMount()); 10 On a horse
        If abDismount
            UDMain.Player.Dismount()
            StorageUtil.SetIntValue(UDMain.Player, "UD_AnimationManager_RestoreCamera", 1)
            if UDmain.VRIKInstalled
                UD_VR.VRIKFixStart()
            EndIf            
            Game.ForceThirdPerson()
            if UDmain.VRIKInstalled
                UD_VR.VRIKFixStart()
            EndIf            
            int timeout = 0
            while UDMain.Player.IsOnMount() && timeout <= 30; Wait for dismount to complete
                Utility.Wait(0.1)
                timeout += 1
            EndWhile
        EndIf
    ElseIf cameraOld == 11; Bleeding out.
        
    ElseIf cameraOld == 12 ; Dragon? Wtf?
    
    Else
        StorageUtil.SetIntValue(UDMain.Player, "UD_AnimationManager_RestoreCamera", 1)
        if UDmain.VRIKInstalled
            UD_VR.VRIKFixStart()
        EndIf        
        Game.ForceThirdPerson()
        if UDmain.VRIKInstalled
            UD_VR.VRIKFixStart()
        EndIf        
    EndIf
EndFunction

Function _RestorePlayerCamera()
    Actor player = UDMain.Player
    ;do not restore camera if actor changed camera to free (3) after animation begin
    If StorageUtil.GetIntValue(player, "UD_AnimationManager_RestoreCamera", 0) == 1 && Game.GetCameraState() != 3
        StorageUtil.SetIntValue(player, "UD_AnimationManager_RestoreCamera", 0)
        Game.ForceFirstPerson()
    EndIf
    if UDmain.VRIKInstalled
        UD_VR.VRIKFixEnd()
    EndIf
EndFunction

Function _SaveActorPosition(Actor akActor, Bool abSavePos = True, Bool abSaveAngle = True, ObjectReference akHeadingTarget = None)
    If !akActor
        Return
    EndIf
    If abSavePos
        StorageUtil.SetFloatValue(akActor, "UD_AnimationManager_X", akActor.X)
        StorageUtil.SetFloatValue(akActor, "UD_AnimationManager_Y", akActor.Y)
        StorageUtil.SetFloatValue(akActor, "UD_AnimationManager_Z", akActor.Z)
    Else
        StorageUtil.UnsetFloatValue(akActor, "UD_AnimationManager_X")
        StorageUtil.UnsetFloatValue(akActor, "UD_AnimationManager_Y")
        StorageUtil.UnsetFloatValue(akActor, "UD_AnimationManager_Z")
    EndIf
    If abSaveAngle
        Float a = akActor.GetAngleZ()
        ; The actor will face towards the akHeadingTarget
        If akHeadingTarget != None
            a += akActor.GetHeadingAngle(akHeadingTarget)
        EndIf
        StorageUtil.SetFloatValue(akActor, "UD_AnimationManager_A", a)
    Else
        StorageUtil.UnsetFloatValue(akActor, "UD_AnimationManager_A")
    EndIf
EndFunction

Function _RestoreActorPosition(Actor akActor)
    If !akActor
        Return
    EndIf
    Float x = StorageUtil.GetFloatValue(akActor, "UD_AnimationManager_X", akActor.X)
    Float y = StorageUtil.GetFloatValue(akActor, "UD_AnimationManager_Y", akActor.Y)
    Float z = StorageUtil.GetFloatValue(akActor, "UD_AnimationManager_Z", akActor.Z)
    Float a = StorageUtil.GetFloatValue(akActor, "UD_AnimationManager_A", akActor.GetAngleZ())
    
    If UD_Native.IsPlayer(akActor)
        akActor.SetPosition(x, y, z)
        akActor.SetAngle(0, 0, a)
    Else
        akActor.TranslateTo(x , y, z, 0, 0, a, 150, 180)
    EndIf
    StorageUtil.UnsetFloatValue(akActor, "UD_AnimationManager_X")
    StorageUtil.UnsetFloatValue(akActor, "UD_AnimationManager_Y")
    StorageUtil.UnsetFloatValue(akActor, "UD_AnimationManager_Z")
    StorageUtil.UnsetFloatValue(akActor, "UD_AnimationManager_A")
EndFunction

Function _Benchmark(Int aiCycles = 10)
    Int n = aiCycles
    Float start_time
    Int duration
    Int old_UDPrintLevel = UDmain.UD_PrintLevel
    Int old_UDLogLevel = UDmain.LogLevel
    UDmain.UD_PrintLevel = 0
    UDmain.LogLevel = 0

    If True
        n = aiCycles
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            ; NOP
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark NOP with " + (aiCycles) + " cycles ends in " + duration + " ms")
        ; Benchmark NOP with 10 cycles ends in 6 ms
    EndIf

    If True
        n = aiCycles * 100
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            ; NOP
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark NOP with " + (aiCycles * 100) + " cycles ends in " + duration + " ms")
        ; Benchmark NOP with 1000 cycles ends in 173 ms
    EndIf
    
    If False
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int[] cc = new Int[1]
            cc[0] = 0
            String[] aasKeywords = new String[1]
            aasKeywords[0] = ".zad_DeviousBoots"
            String[] res = GetAnimationsFromDB(".solo", aasKeywords, "", cc)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark GetAnimationsFromDB(solo) with " + aiCycles + " cycles ends in " + duration + " ms")
    EndIf

    If True
        n = aiCycles
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int[] cc = new Int[2]
            cc[0] = 0
            cc[1] = 0
            String[] aasKeywords = new String[1]
            aasKeywords[0] = ".zad_DeviousBelt"
            String[] res = GetAnimationsFromDB(".paired", aasKeywords, "", cc)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark GetAnimationsFromDB(paired) with " + aiCycles + " cycles ends in " + duration + " ms")
        ; Benchmark GetAnimationsFromDB(paired) with 10 cycles ends in 2014 ms
    EndIf
    
    If False
        Actor akActor = Game.GetPlayer()
        n = aiCycles
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int cc = GetActorConstraintsInt(akActor)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark UDAM.GetActorConstraintsInt with " + aiCycles + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = aiCycles * 100
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
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark JsonUtil #1 with " + aiCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = aiCycles * 100
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
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark JsonUtil #2 with " + aiCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = aiCycles * 100
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            JsonUtil.GetPathIntValue("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[0]" + ".A1[0].req", -1)
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark JsonUtil #3 with " + aiCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = aiCycles * 100
        start_time = Utility.GetCurrentRealTime()
        While n >= 0
            n -= 1
            Int[] arr = JsonUtil.PathIntElements("UD/Animations/UDStruggle_DB_Custom_Pair.json", ".paired.zad_DeviousBoots[0]" + ".A1_req")
            Int aa = arr[0]
        EndWhile
        duration = ((Utility.GetCurrentRealTime() - start_time) * 1000) As Int
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark JsonUtil #4 with " + aiCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf

    If False
        Actor akActor = Game.GetPlayer()
        n = aiCycles * 100
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
        UDmain.Warning("UD_AnimationManagerScript::_Benchmark() Benchmark ResizeStringArray with " + aiCycles * 100 + " cycles ends in " + duration + " ms")
    EndIf
    
    UDmain.UD_PrintLevel = old_UDPrintLevel
    UDmain.LogLevel = old_UDLogLevel
EndFunction
