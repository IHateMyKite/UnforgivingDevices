Scriptname UD_GlobalVariables extends Quest conditional
{Scripts containing all global variables and switches}
import UnforgivingDevicesMain

;shows details about crit in device details if different from 0, short
GlobalVariable Property UDG_ShowCritVars        auto

;minigame update time, is used if its different from 0, float
GlobalVariable Property UDG_CustomMinigameUpT   auto

;update time for NPC scan, float
GlobalVariable Property UDG_NPCScanUpT          auto

;update time for NPC heavy processing (skill update), float
GlobalVariable Property UDG_NPCHeavyUpT         auto

;setting it to value different then 1 will disable exhaustion from being applied, short
GlobalVariable Property UDG_MinigameExhaustion  auto

;allow to toggle console logging (to show messages in cmd if log level is not 0), short
;by default turned on, you can turn it off if you still wan't to use trace, but don't wan't it to mess up the console
GlobalVariable Property UDG_ConsoleLog  auto

;toggle to 1 to automatically also NPC when they wear HB, they have to be registered for it to work, short
;by default is 1
GlobalVariable Property UDG_UndressNPC  auto

;toggle to 1 to automatically also undress follower when they wear HB, they have to be registered for it to work, short
;by default is 0
GlobalVariable Property UDG_UndressFollower  auto