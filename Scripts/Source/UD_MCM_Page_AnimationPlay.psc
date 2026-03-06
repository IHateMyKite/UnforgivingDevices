Scriptname UD_MCM_Page_AnimationPlay extends UD_MCM_Page

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_AnimationManagerScript Property UDAM Hidden
    UD_AnimationManagerScript Function Get()
        return UDmain.UDAM
    EndFunction
EndProperty

Int UDAM_TestQuery_PlayerArms_M
String[] UDAM_TestQuery_PlayerArms_List
Int[] UDAM_TestQuery_PlayerArms_Bit
Int UDAM_TestQuery_PlayerArms_Index

Int UDAM_TestQuery_PlayerLegs_M
String[] UDAM_TestQuery_PlayerLegs_List
Int[] UDAM_TestQuery_PlayerLegs_Bit
Int UDAM_TestQuery_PlayerLegs_Index

Int UDAM_TestQuery_PlayerMittens_T
Bool UDAM_TestQuery_PlayerMittens

Int UDAM_TestQuery_PlayerGag_T
Bool UDAM_TestQuery_PlayerGag

Int UDAM_TestQuery_HelperArms_M
Int UDAM_TestQuery_HelperArms_Index

Int UDAM_TestQuery_HelperLegs_M
Int UDAM_TestQuery_HelperLegs_Index

Int UDAM_TestQuery_HelperMittens_T
Bool UDAM_TestQuery_HelperMittens

Int UDAM_TestQuery_HelperGag_T
Bool UDAM_TestQuery_HelperGag

Int UDAM_TestQuery_Request_T
Int UDAM_TestQuery_StopAnimation_T 

Int UDAM_TestQuery_Keyword_M
String[] UDAM_TestQuery_Keyword_List
Int UDAM_TestQuery_Keyword_Index

Int UDAM_TestQuery_Type_M
String[] UDAM_TestQuery_Type_List
Int UDAM_TestQuery_Type_Index

Float UDAM_TestQuery_TimeSpan

String[] UDAM_TestQuery_Results_JsonPath
String[] UDAM_TestQuery_Results_AnimEvent

Int UDAM_TestQuery_Results_JsonPath_First_T
Int UDAM_TestQuery_Results_AnimEvent_First_T

Int UDAM_TestQuery_ElapsedTime_T

Actor LastHelper
Int UD_Helper_T

function PageInit()
endfunction

Function PageUpdate()
    If !UDAM_TestQuery_Type_List
        UDAM_TestQuery_Type_List = new String[2]
        UDAM_TestQuery_Type_List[0] = ".solo"
        UDAM_TestQuery_Type_List[1] = ".paired"
        UDAM_TestQuery_Type_Index = 1
    EndIf
    If !UDAM_TestQuery_Keyword_List
        UDAM_TestQuery_Keyword_List = new String[37]
        UDAM_TestQuery_Keyword_List[0] = ".zad_DeviousBoots"
        UDAM_TestQuery_Keyword_List[1] = ".zad_DeviousPlug"
        UDAM_TestQuery_Keyword_List[2] = ".zad_DeviousBelt"
        UDAM_TestQuery_Keyword_List[3] = ".zad_DeviousBra"
        UDAM_TestQuery_Keyword_List[4] = ".zad_DeviousCollar"
        UDAM_TestQuery_Keyword_List[5] = ".zad_DeviousArmCuffs"
        UDAM_TestQuery_Keyword_List[6] = ".zad_DeviousLegCuffs"
        UDAM_TestQuery_Keyword_List[7] = ".zad_DeviousArmbinder"
        UDAM_TestQuery_Keyword_List[8] = ".zad_DeviousArmbinderElbow"
        UDAM_TestQuery_Keyword_List[9] = ".zad_DeviousHobbleSkirt"
        UDAM_TestQuery_Keyword_List[10] = ".zad_DeviousHobbleSkirtRelaxed"
        UDAM_TestQuery_Keyword_List[11] = ".zad_DeviousAnkleShackles"
        UDAM_TestQuery_Keyword_List[12] = ".zad_DeviousStraitJacket"
        UDAM_TestQuery_Keyword_List[13] = ".zad_DeviousCuffsFront"
        UDAM_TestQuery_Keyword_List[14] = ".zad_DeviousPetSuit"
        UDAM_TestQuery_Keyword_List[15] = ".zad_DeviousYoke"
        UDAM_TestQuery_Keyword_List[16] = ".zad_DeviousYokeBB"
        UDAM_TestQuery_Keyword_List[17] = ".zad_DeviousCorset"
        UDAM_TestQuery_Keyword_List[18] = ".zad_DeviousClamps"
        UDAM_TestQuery_Keyword_List[19] = ".zad_DeviousGloves"
        UDAM_TestQuery_Keyword_List[20] = ".zad_DeviousHood"
        UDAM_TestQuery_Keyword_List[21] = ".zad_DeviousElbowTie"
        UDAM_TestQuery_Keyword_List[22] = ".zad_DeviousGag"
        UDAM_TestQuery_Keyword_List[23] = ".zad_DeviousGagLarge"
        UDAM_TestQuery_Keyword_List[24] = ".zad_DeviousGagPanel"
        UDAM_TestQuery_Keyword_List[25] = ".zad_DeviousPlugVaginal"
        UDAM_TestQuery_Keyword_List[26] = ".zad_DeviousPlugAnal"
        UDAM_TestQuery_Keyword_List[27] = ".zad_DeviousHarness"
        UDAM_TestQuery_Keyword_List[28] = ".zad_DeviousBlindfold"
        UDAM_TestQuery_Keyword_List[29] = ".zad_DeviousPiercingsNipple"
        UDAM_TestQuery_Keyword_List[30] = ".zad_DeviousPiercingsVaginal"
        UDAM_TestQuery_Keyword_List[31] = ".zad_DeviousBondageMittens"
        UDAM_TestQuery_Keyword_List[32] = ".zad_DeviousSuit"
        UDAM_TestQuery_Keyword_List[33] = ".horny"
        UDAM_TestQuery_Keyword_List[34] = ".edged"
        UDAM_TestQuery_Keyword_List[35] = ".orgasm"
        UDAM_TestQuery_Keyword_List[36] = ".spectator"
        UDAM_TestQuery_Keyword_Index = 0
    EndIf
    If !UDAM_TestQuery_PlayerArms_List
        UDAM_TestQuery_PlayerArms_List = new String[9]
        UDAM_TestQuery_PlayerArms_Bit = new Int[9]
        UDAM_TestQuery_PlayerArms_List[0] = "NOTHING"
        UDAM_TestQuery_PlayerArms_Bit[0] = 0
        UDAM_TestQuery_PlayerArms_List[1] = "$Yoke"
        UDAM_TestQuery_PlayerArms_Bit[1] = 4
        UDAM_TestQuery_PlayerArms_List[2] = "Front Cuffs"
        UDAM_TestQuery_PlayerArms_Bit[2] = 8
        UDAM_TestQuery_PlayerArms_List[3] = "Armbinder"
        UDAM_TestQuery_PlayerArms_Bit[3] = 16
        UDAM_TestQuery_PlayerArms_List[4] = "Elbowbinder"
        UDAM_TestQuery_PlayerArms_Bit[4] = 32
        UDAM_TestQuery_PlayerArms_List[5] = "Pet suit"
        UDAM_TestQuery_PlayerArms_Bit[5] = 64
        UDAM_TestQuery_PlayerArms_List[6] = "Elbowtie"
        UDAM_TestQuery_PlayerArms_Bit[6] = 128
        UDAM_TestQuery_PlayerArms_List[7] = "Straitjacket"
        UDAM_TestQuery_PlayerArms_Bit[7] = 512
        UDAM_TestQuery_PlayerArms_List[8] = "YokeBB"
        UDAM_TestQuery_PlayerArms_Bit[8] = 1024
        UDAM_TestQuery_PlayerArms_Index = 0
    EndIf
    If !UDAM_TestQuery_PlayerLegs_List
        UDAM_TestQuery_PlayerLegs_List = new String[3]
        UDAM_TestQuery_PlayerLegs_Bit = new Int[3]
        UDAM_TestQuery_PlayerLegs_List[0] = "NOTHING"
        UDAM_TestQuery_PlayerLegs_Bit[0] = 0
        UDAM_TestQuery_PlayerLegs_List[1] = "Bound Ankles"
        UDAM_TestQuery_PlayerLegs_Bit[1] = 2
        UDAM_TestQuery_PlayerLegs_List[2] = "Hobble Skirt"
        UDAM_TestQuery_PlayerLegs_Bit[2] = 1
    EndIf
EndFunction

Function PageReset(Bool abLockMenu)
    Int UD_LockMenu_flag = FlagSwitch(!abLockMenu)
; FIRST RUN
    
    Actor actor_in_crosshair = (Game.GetCurrentCrosshairRef() as Actor)
    ; change helper if the last one is not in animation
    If !(LastHelper && UDAM.IsAnimating(LastHelper)) && actor_in_crosshair
        LastHelper = actor_in_crosshair
    EndIf
    
    Int flags = OPTION_FLAG_NONE
        
    MCM.UpdateLockMenuFlag()
    Int rows_right = 0
    Int rows_left = 0
    
; LEFT COLUMN

    SetCursorPosition(0)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_H_TESTANIMATIONQUERY")
    rows_left += 1
    UDAM_TestQuery_Type_M = AddMenuOption("$UD_TESTQUERY", UDAM_TestQuery_Type_List[UDAM_TestQuery_Type_Index])
    rows_left += 1
    UDAM_TestQuery_Keyword_M = AddMenuOption("$UD_TESTQUERY_KEYWORD", UDAM_TestQuery_Keyword_List[UDAM_TestQuery_Keyword_Index])
    rows_left += 1

    UDAM_TestQuery_PlayerArms_M = AddMenuOption("$UD_TESTQUERY_PLAYERARMS", UDAM_TestQuery_PlayerArms_List[UDAM_TestQuery_PlayerArms_Index])
    rows_left += 1
    UDAM_TestQuery_PlayerLegs_M = AddMenuOption("$UD_TESTQUERY_PLAYERLEGS", UDAM_TestQuery_PlayerLegs_List[UDAM_TestQuery_PlayerLegs_Index])
    rows_left += 1
    UDAM_TestQuery_PlayerMittens_T = AddToggleOption("$UD_TESTQUERY_PLAYERMITTENS", UDAM_TestQuery_PlayerMittens)
    rows_left += 1
    UDAM_TestQuery_PlayerGag_T = AddToggleOption("$UD_TESTQUERY_PLAYERGAG", UDAM_TestQuery_PlayerGag)
    rows_left += 1
    
; RIGHT COLUMN

    SetCursorPosition(1)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$UD_H_TESTANIMATIONQUERY")
    rows_right += 1
    AddEmptyOption()
    rows_right += 1
    
    Int helper_flags = OPTION_FLAG_NONE
    If UDAM_TestQuery_Type_Index == 0
        helper_flags = OPTION_FLAG_DISABLED
    EndIf
    If LastHelper
        AddTextOption("$UD_HELPER", LastHelper.GetActorBase().GetName(), OPTION_FLAG_DISABLED)
    Else
        UD_Helper_T = AddTextOption("$UD_HELPER", "----", OPTION_FLAG_NONE)
    EndIf
    rows_right += 1
    
    UDAM_TestQuery_HelperArms_M = AddMenuOption("$UD_TESTQUERY_HELPERARMS", UDAM_TestQuery_PlayerArms_List[UDAM_TestQuery_HelperArms_Index])
    rows_right += 1
    UDAM_TestQuery_HelperLegs_M = AddMenuOption("$UD_TESTQUERY_HELPERLEGS", UDAM_TestQuery_PlayerLegs_List[UDAM_TestQuery_HelperLegs_Index])
    rows_right += 1
    UDAM_TestQuery_HelperMittens_T = AddToggleOption("$UD_TESTQUERY_HELPERMITTENS", UDAM_TestQuery_HelperMittens)
    rows_right += 1
    UDAM_TestQuery_HelperGag_T = AddToggleOption("$UD_TESTQUERY_HELPERGAG", UDAM_TestQuery_HelperGag)
    rows_right += 1
    
    UDAM_TestQuery_Request_T =  AddTextOption("$UD_TESTQUERY_REQUEST", "$-PRESS-")
    rows_right += 1
    If UDAM.IsAnimating(UDMain.Player)
        flags = OPTION_FLAG_NONE
    Else
        flags = OPTION_FLAG_DISABLED
    EndIf
    UDAM_TestQuery_StopAnimation_T =  AddTextOption("$UD_TESTQUERY_STOPANIMATION", "$-PRESS-", flags)
    rows_right += 1
    
; BOTH COLUMNS 
    If rows_right > rows_left
        SetCursorPosition(rows_right * 2)
    Else
        SetCursorPosition(rows_left * 2)
    EndIf
    SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption("$UD_H_TEST_ANIMATION_QUERY_RESULTS_FILE")
    AddHeaderOption("$UD_H_TEST_ANIMATION_QUERY_RESULTS_PATH")
    
    AddTextOption("$UD_H_NUMBER_OF_FOUND_ANIMATIONS", UDAM_TestQuery_Results_JsonPath.Length, OPTION_FLAG_DISABLED)
    UDAM_TestQuery_ElapsedTime_T = AddTextOption("$UD_TESTQUERY_ELAPSEDTIME", (UDAM_TestQuery_TimeSpan * 1000) As Int + " ms", OPTION_FLAG_DISABLED)
    
    If LastHelper == None && UDAM_TestQuery_Type_Index == 1
        flags = OPTION_FLAG_DISABLED
    Else
        flags = OPTION_FLAG_NONE
    EndIf
    Int i = 0
    While i < UDAM_TestQuery_Results_JsonPath.Length
        String item_name = ""
        Int part_index = StringUtil.Find(UDAM_TestQuery_Results_JsonPath[i], ":")
;       String file_part = StringUtil.Substring(UDAM_TestQuery_Results_JsonPath[i], 0, part_index)
;       String path_part = StringUtil.Substring(UDAM_TestQuery_Results_JsonPath[i], part_index + 1)
        If part_index > -1
            item_name = StringUtil.Substring(UDAM_TestQuery_Results_JsonPath[i], 0, part_index)         ; part of the path with file name
        Else
            item_name = UDAM_TestQuery_Results_JsonPath[i]
        EndIf
        Int id = AddTextOption(item_name, "$-INFO-")
        If i == 0
            UDAM_TestQuery_Results_JsonPath_First_T = id
        EndIf
        id = AddTextOption("", "$-PLAY-")
        If i == 0
            UDAM_TestQuery_Results_AnimEvent_First_T = id
        EndIf
        i += 1
    EndWhile
    
EndFunction

Function PageOptionSelect(Int option)
    If option == UDAM_TestQuery_Request_T
        SetOptionFlags(option, OPTION_FLAG_DISABLED)
        Float start_time = Utility.GetCurrentRealTime()
        String[] kwds = new String[1]
        kwds[0] = UDAM_TestQuery_Keyword_List[UDAM_TestQuery_Keyword_Index]
        String anim_type = UDAM_TestQuery_Type_List[UDAM_TestQuery_Type_Index]
        If UDAM_TestQuery_Type_Index == 1                                       ; .paired
            Int[] constr = new Int[2]
            constr[0] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int) + 2048 * (UDAM_TestQuery_PlayerGag as Int)
            constr[1] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_HelperArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_HelperLegs_Index] + 256 * (UDAM_TestQuery_HelperMittens as Int) + 2048 * (UDAM_TestQuery_HelperGag as Int)
            UDAM_TestQuery_Results_AnimEvent = UDAM.GetAnimationsFromDB(anim_type, kwds, ".A1.anim", constr)
            UDAM_TestQuery_Results_JsonPath = UDAM.GetAnimationsFromDB(anim_type, kwds, "", constr)
        Else                                                                    ; .solo
            Int[] constr = new Int[1]
            constr[0] = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int) + 2048 * (UDAM_TestQuery_PlayerGag as Int)
            UDAM_TestQuery_Results_AnimEvent = UDAM.GetAnimationsFromDB(anim_type, kwds, ".A1.anim", constr)
            UDAM_TestQuery_Results_JsonPath = UDAM.GetAnimationsFromDB(anim_type, kwds, "", constr)
        EndIf
        UDAM_TestQuery_TimeSpan = Utility.GetCurrentRealTime() - start_time
        forcePageReset()
        SetOptionFlags(option, OPTION_FLAG_NONE)
    ElseIf option == UDAM_TestQuery_PlayerMittens_T
        UDAM_TestQuery_PlayerMittens = !UDAM_TestQuery_PlayerMittens
        SetToggleOptionValue(option, UDAM_TestQuery_PlayerMittens)
    ElseIf option == UDAM_TestQuery_HelperMittens_T
        UDAM_TestQuery_HelperMittens = !UDAM_TestQuery_HelperMittens
        SetToggleOptionValue(option, UDAM_TestQuery_HelperMittens)
    ElseIf option == UDAM_TestQuery_PlayerGag_T
        UDAM_TestQuery_PlayerGag = !UDAM_TestQuery_PlayerGag
        SetToggleOptionValue(option, UDAM_TestQuery_PlayerGag)
    ElseIf option == UDAM_TestQuery_HelperGag_T
        UDAM_TestQuery_HelperGag = !UDAM_TestQuery_HelperGag
        SetToggleOptionValue(option, UDAM_TestQuery_HelperGag)
    ElseIf (option >= UDAM_TestQuery_Results_AnimEvent_First_T) && (option <= (UDAM_TestQuery_Results_AnimEvent_First_T + (UDAM_TestQuery_Results_JsonPath.Length - 1) * 2)) && (((option - UDAM_TestQuery_Results_AnimEvent_First_T) % 2) == 0)
        Int index = (option - UDAM_TestQuery_Results_AnimEvent_First_T) / 2
        String val = UDAM_TestQuery_Results_JsonPath[index]
        If UDAM_TestQuery_Type_Index == 1 && !LastHelper
            ShowMessage("$First you need to choose a helper. Hover your crosshair over an NPC in the game and make sure its name appears in the 'Helper' option above")
        Else
            If ShowMessage("$FOR DEBUG ONLY! To stop animation use command 'Stop animation' in this menu. Animation will start if you press ACCEPT and close menu.", True)
                closeMCM()
                If LastHelper && UDAM_TestQuery_Type_Index == 1
                    Actor[] actors = new Actor[2]
                    actors[0] = Game.GetPlayer()
                    actors[1] = LastHelper
                    Int constrA1 = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int)
                    Int constrA2 = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_HelperArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_HelperLegs_Index] + 256 * (UDAM_TestQuery_HelperMittens as Int)
                    UDAM.PlayAnimationByDef(val, actors, False, True, constrA1, constrA2)
                Else
                    Actor[] actors = new Actor[1]
                    actors[0] = Game.GetPlayer()
                    Int constr = UDAM_TestQuery_PlayerArms_Bit[UDAM_TestQuery_PlayerArms_Index] + UDAM_TestQuery_PlayerLegs_Bit[UDAM_TestQuery_PlayerLegs_Index] + 256 * (UDAM_TestQuery_PlayerMittens as Int)
                    UDAM.PlayAnimationByDef(val, actors, False, True, constr)
                EndIf
            EndIf
        EndIf
    ElseIf (option >= UDAM_TestQuery_Results_JsonPath_First_T) && (option <= (UDAM_TestQuery_Results_JsonPath_First_T + (UDAM_TestQuery_Results_JsonPath.Length - 1) * 2)) && (((option - UDAM_TestQuery_Results_JsonPath_First_T) % 2) == 0)
;        Int index = (option - UDAM_TestQuery_Results_JsonPath_First_T) / 2
;        String val = UDAM_TestQuery_Results_JsonPath[index]
    ElseIf option == UDAM_TestQuery_StopAnimation_T
        ShowMessage("$Lets try to stop animation", False)
        UDAM.StopAnimation(Game.GetPlayer(), LastHelper)
        closeMCM()
    EndIf
EndFunction

Function PageOptionSliderOpen(Int option)

EndFunction
Function PageOptionSliderAccept(Int option, Float value)

EndFunction

Function PageOptionMenuOpen(int option)
    If option == UDAM_TestQuery_Type_M
        SetMenuDialogOptions(UDAM_TestQuery_Type_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_Type_Index)
        SetMenuDialogDefaultIndex(1)
    ElseIf option == UDAM_TestQuery_Keyword_M
        SetMenuDialogOptions(UDAM_TestQuery_Keyword_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_Keyword_Index)
        SetMenuDialogDefaultIndex(0)
    ElseIf option == UDAM_TestQuery_PlayerArms_M
        SetMenuDialogOptions(UDAM_TestQuery_PlayerArms_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_PlayerArms_Index)
        SetMenuDialogDefaultIndex(0)
    ElseIf option == UDAM_TestQuery_PlayerLegs_M
        SetMenuDialogOptions(UDAM_TestQuery_PlayerLegs_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_PlayerLegs_Index)
        SetMenuDialogDefaultIndex(0)
    ElseIf option == UDAM_TestQuery_HelperArms_M
        SetMenuDialogOptions(UDAM_TestQuery_PlayerArms_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_HelperArms_Index)
        SetMenuDialogDefaultIndex(0)
    ElseIf option == UDAM_TestQuery_HelperLegs_M
        SetMenuDialogOptions(UDAM_TestQuery_PlayerLegs_List)
        SetMenuDialogStartIndex(UDAM_TestQuery_HelperLegs_Index)
        SetMenuDialogDefaultIndex(0)
    EndIf
EndFunction
Function PageOptionMenuAccept(int option, int index)
    If option == UDAM_TestQuery_Type_M
        UDAM_TestQuery_Type_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_Type_List[index])
        Int helper_flags = OPTION_FLAG_NONE
        If index == 0
            helper_flags = OPTION_FLAG_DISABLED
        EndIf
        SetOptionFlags(UDAM_TestQuery_HelperArms_M, helper_flags)
        SetOptionFlags(UDAM_TestQuery_HelperLegs_M, helper_flags)
        SetOptionFlags(UDAM_TestQuery_HelperMittens_T, helper_flags)
        SetOptionFlags(UDAM_TestQuery_HelperGag_T, helper_flags)
    ElseIf option == UDAM_TestQuery_Keyword_M
        UDAM_TestQuery_Keyword_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_Keyword_List[index])
    ElseIf option == UDAM_TestQuery_PlayerArms_M
        UDAM_TestQuery_PlayerArms_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_PlayerArms_List[index])
    ElseIf option == UDAM_TestQuery_PlayerLegs_M
        UDAM_TestQuery_PlayerLegs_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_PlayerLegs_List[index])
    ElseIf option == UDAM_TestQuery_HelperArms_M
        UDAM_TestQuery_HelperArms_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_PlayerArms_List[index])
    ElseIf option == UDAM_TestQuery_HelperLegs_M
        UDAM_TestQuery_HelperLegs_Index = index
        SetMenuOptionValue(option, UDAM_TestQuery_PlayerLegs_List[index])
    EndIf
EndFunction

Function PageDefault(int aiOption)

EndFunction

Function PageInfo(int option)
    If option == UDAM_TestQuery_Request_T
        SetInfoText("$UD_TESTQUERY_INFO")
    ElseIf option == UDAM_TestQuery_StopAnimation_T
        SetInfoText("$UD_TESTQUERY_STOPANIMATION_INFO")
    ElseIf option == UDAM_TestQuery_ElapsedTime_T
        SetInfoText("")
    ElseIf (option >= UDAM_TestQuery_Results_JsonPath_First_T) && (option <= (UDAM_TestQuery_Results_JsonPath_First_T + (UDAM_TestQuery_Results_JsonPath.Length - 1) * 2)) && (((option - UDAM_TestQuery_Results_JsonPath_First_T) % 2) == 0)
        Int index = (option - UDAM_TestQuery_Results_JsonPath_First_T) / 2
        String val = UDAM_TestQuery_Results_JsonPath[index]
        SetInfoText("Json path: " + UDAM_TestQuery_Results_JsonPath[index] + "\nAnim. event(s): " + UDAM_TestQuery_Results_AnimEvent[index])
    ElseIf option == UD_Helper_T
        SetInfoText("$UD_HELPER_INFO")
    EndIf
EndFunction
