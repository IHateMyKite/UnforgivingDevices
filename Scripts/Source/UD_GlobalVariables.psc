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