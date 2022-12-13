Scriptname UD_GlobalVariables extends Quest conditional
{Scripts containing all global variables and switches}


GlobalVariable Property UDG_ShowCritVars        auto ;shows details about crit in device details if different from 0, short
GlobalVariable Property UDG_CustomMinigameUpT   auto ;minigame update time, is used if its different from 0, float

GlobalVariable Property UDG_NPCScanUpT          auto ;update time for NPC scan, float
GlobalVariable Property UDG_NPCHeavyUpT         auto ;update time for NPC heavy processing (skill update), float