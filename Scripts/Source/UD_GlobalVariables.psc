;/  File: UD_GlobalVariables
    Contains properties linked to global variables
    
    Name of all properties is same as the editorID of linked forms
    
    To change the Global Variable ingame, all that is need is to type following in console
    
    --- Code
        Set *EditorID* to *NewValue*
    ---
    
    So for example, to change mingame update time to 0.1 seconds, following will have to be typed
    
    --- Code
        Set UDG_CustomMinigameUpT to 0.1
    ---
    
    As papyrus/console/forms is not case sensitive, following will also work
    
    --- Code
        Set udg_customminigameupt to 0.1
    ---
/;
Scriptname UD_GlobalVariables extends Quest conditional
{Scripts containing all global variables and switches}

import UnforgivingDevicesMain

;/  Group: Global Variables
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: UDG_ShowCritVars
    Shows details about crit in device details if different from 0
    
    Type = *short*
/;
GlobalVariable Property UDG_ShowCritVars        auto

;/  Variable: UDG_CustomMinigameUpT
    Minigame update time.
    
    Is used if its different from 0
    
    Type = float
/;
GlobalVariable Property UDG_CustomMinigameUpT   auto

;/  Variable: UDG_NPCScanUpT
    Update time for NPC scan
    
    Type = *float*
/;
GlobalVariable Property UDG_NPCScanUpT          auto

;/  Variable: UDG_NPCHeavyUpT
    Update time for NPC heavy processing (skill update)
    
    Type = *float*
/;
GlobalVariable Property UDG_NPCHeavyUpT         auto

;/  Variable: UDG_MinigameExhaustion
    Setting it to value different then 1 will disable exhaustion from being applied
    
    Type = *short*
/;
GlobalVariable Property UDG_MinigameExhaustion  auto

;/  Variable: UDG_ConsoleLog
    Allow to toggle console logging (to show messages in cmd if log level is not 0)
    
    By default turned on, you can turn it off if you still wan't to use trace, but don't wan't it to mess up the console
 
    Type = *short*
/;
GlobalVariable Property UDG_ConsoleLog  auto

;/  Variable: UDG_UndressNPC
    Toggle to 1 to also automatically undress NPC when they wear HB
    
    They have to be registered for this to work

    Type = *short*

    Default = *1*
/;
GlobalVariable Property UDG_UndressNPC  auto

;/  Variable: UDG_UndressFollower
    Toggle to 1 to automatically also undress follower when they wear HB
    
    They have to be registered for this to work

    Type = *short*

    Default = *0*
/;
GlobalVariable Property UDG_UndressFollower  auto

;/  Variable: UDG_NPCOrgasmUpT
    Update time of orgasm updater
    
    By default is 1s, but 2s can be also used. Should not be highter then 2s, as it might cause issues

    Type = *short*

    Default = *1*
/;
GlobalVariable Property UDG_NPCOrgasmUpT  auto

;/  Variable: UDG_PO3PEDetection
    Change this to 1 to force disable of detection by PO3PE
    
    Can help with freeze in case of Lockpick minigame

    Type = *short*

    Default = *1*
/;
GlobalVariable Property UDG_PO3PEDetection  auto

;/  Variable: UDG_MinigameProfiling
    Change this to 1 to enable profiling of device minigame
    
    bEnableProfiling needs to be set to 1 in skyrim .ini file

    Type = *short*

    Default = *0*
/;
GlobalVariable Property UDG_MinigameProfiling  auto

;/  Variable: UDG_AIMinigameInfo
    Change this to 1 to print NPC Ai information about minigames to console

    Type = *short*

    Default = *0*
/;
GlobalVariable Property UDG_AIMinigameInfo  auto



;/  Group: Internal Constants
===========================================================================================
===========================================================================================
===========================================================================================
/;

;constants used for lock/unlock mutexes
Float Property UD_LockTimeoutID         = 1.0 autoreadonly
Float Property UD_LockTimeoutRD         = 2.0 autoreadonly
Float Property UD_MutexTimeout          = 3.5 autoreadonly