Scriptname UD_Native hidden

Function StartMinigameEffect(Actor akActor,Float afMult, Float afStamina, Float afHealth, Float afMagicka, Bool abToggle) global native
Function EndMinigameEffect(Actor akActor) global native
bool Function IsMinigameEffectOn(Actor akActor)  global native
Function UpdateMinigameEffectMult(Actor akActor, float afNewMult)  global native
Function ToggleMinigameEffect(Actor akActor, bool abToggle)  global native ;abToggle = true -> enabled, abToggle = false -> disabled
bool Function MinigameStatsCheck(Actor akActor)  global native

Function MinigameEffectUpdateHealth(Actor akActor, float afNewHealth)  global native
Function MinigameEffectUpdateStamina(Actor akActor, float afNewStamina)  global native
Function MinigameEffectUpdateMagicka(Actor akActor, float afNewMagicka)  global native
