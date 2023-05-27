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

;UTILITY
Int Function CodeBit(int aiCodedMap,int aiValue,int aiSize,int aiIndex) global native
Int Function DecodeBit(int aiCodedMap,int aiSize,int aiIndex) global native

;UI
Function AddMeterEntry(string asPath, int aiId, string asName, float afBase, float afRate, bool abShow) global native
Function RemoveMeterEntry(int aiId) global native
Function ToggleAllMeters(bool abToggle) global native
Function ToggleMeter(int aiId, bool abToggle) global native
Function SetMeterRate(int aiId, float afNewRate) global native
Function SetMeterMult(int aiId, float afNewMult) global native
Function SetMeterValue(int aiId, float afNewValue) global native
Float Function UpdateMeterValue(int aiId, float afDiffValue) global native
Float Function GetMeterValue(int aiId) global native
int Function RemoveAllMeterEntries() global native