Scriptname zadBQ00 Extends zadBaseDeviceQuest Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

ReferenceAlias Property Alias_ArmBinderRescuer Auto
ReferenceAlias Property Alias_Player Auto
SexLabFramework property SexLab auto
slaUtilScr Property Aroused Auto
zadNPCQuestScript Property npcs Auto
Message Property zad_eventSleepStopContent auto
Message Property zad_eventSleepStopDesire auto
Message Property zad_eventSleepStopHorny auto
Message Property zad_eventSleepStopDesperate auto
float Property modVersion Auto
bool Property processMountedEvent Auto
bool Property processDripEvent Auto
bool Property processChafeMessageEvent Auto
bool Property processHornyEvent Auto
bool Property processTightBraEvent Auto
bool Property processPostureCollarMessageEvent Auto
bool Property processBumpPumpEvent Auto
bool Property processBlindfoldEvent Auto
bool Property processHarnessEvent Auto
bool Property processPlugsEvent Auto
bool Property Tainted Auto
string[] Property Registry Auto

function Shutdown(bool silent=false)
EndFunction

Event OnInit()
EndEvent

Event OnInitialize(string eventName, string strArg, float numArg, Form sender)
EndEvent

Function checkBlindfoldDarkFog()
EndFunction

Function Maintenance()
EndFunction

Function CheckCompatibility(string name, float required, float current)
EndFunction

Function VersionChecks()
EndFunction

function Rehook()
EndFunction

bool Function IsValidAnimation(sslBaseAnimation anim, bool permitOral, bool permitVaginal, bool permitAnal, bool permitBoobjob, bool HasBoundActors)
EndFunction

string Function GetAnimationNames(sslBaseAnimation[] anims)
EndFunction

sslBaseAnimation function GetBoundAnim(actor a, actor b, bool permitOral, bool permitVaginal, bool permitAnal, bool permitBoobjob)
EndFunction

String Function GetCreatureType(sslBaseAnimation previousAnim)
EndFunction

sslBaseAnimation[] function SelectValidDDAnimations(Actor[] actors, int count, bool forceaggressive = false, string includetag = "", string suppresstag = "")
endfunction

sslBaseAnimation[] function SelectValidAnimations(sslThreadController Controller, int count, sslBaseAnimation previousAnim, bool usingArmbinder, bool usingYoke,  bool HasBoundActors,  bool forceaggressive, bool permitOral, bool permitVaginal, bool permitAnal, bool permitBoobs)
endfunction

string function getSuppressString(bool aggressive, bool boundArmbinder, bool boundYoke, bool permitOral, bool permitVaginal, bool permitAnal, bool permitBoobs, string suppresstag = "")	
endfunction

string function getTagString(bool aggressive, string includetag = "")
endfunction

int function CountRestrictedActors(actor[] actors, keyword permit, keyword restricted1, keyword restricted2=none, keyword restricted3=none)
EndFunction

int function CountBeltedActors(actor[] actors)
EndFunction

Function TogglePanelGag(actor[] actors, bool insert)
EndFunction

Function StoreHeavyBondage(actor[] originalActors)
EndFunction

Function RetrieveHeavyBondage(actor[] originalActors)
EndFunction

Function StoreBelts(actor[] originalActors)
EndFunction

Function RetrieveBelts(actor[] originalActors)
EndFunction

Function StoreGags(actor[] originalActors)
EndFunction

Function StoreUnblockedPlugs(actor[] originalActors)
EndFunction

Function StorePlugs(actor[] originalActors)
EndFunction

Function RetrievePlugs(actor[] originalActors)
EndFunction

Function RetrieveGags(actor[] originalActors)
EndFunction

Bool Function IsBlockedAnal(Actor akActor)
EndFunction

Bool Function IsBlockedVaginal(Actor akActor)
EndFunction

Bool Function IsBlockedBreast(Actor akActor)
EndFunction

Bool Function IsBlockedOral(Actor akActor)
EndFunction

Bool Function AnimHasNoProblematicDevices(sslThreadController Controller)
EndFunction

Bool Function StartValidDDAnimation(Actor[] SexActors, bool forceaggressive = false, string includetag = "", string suppresstag = "", Actor victim = None, Bool allowbed = False, string hook = "", bool nofallbacks = false)
EndFunction

function Logic(int threadID, bool HasPlayer)	
EndFunction

Function Wait_Animating_State(SslThreadController controller)
EndFunction

Bool Function HasBelt(Actor akActor)
EndFunction

Bool Function HasArmbinder(Actor akActor)
EndFunction

Bool Function HasYoke(Actor akActor)
EndFunction

Bool Function HasBBYoke(Actor akActor)
EndFunction

Bool Function HasFrontCuffs(Actor akActor)
EndFunction

Bool Function HasElbowbinder(Actor akActor)
EndFunction

Bool Function HasArmbinderNonStrict(Actor akActor)
EndFunction

Bool Function HasPetSuit(Actor akActor)
EndFunction

Bool Function HasHeavyBondage(Actor akActor)
EndFunction

Bool Function HasStraitJacket(Actor akActor)
EndFunction

Bool Function HasElbowShackles(Actor akActor)
EndFunction

sslBaseAnimation[] Function GetSoloAnimations(Actor akActor)
EndFunction

function ProcessSolos(actor[] solos)
EndFunction

Event OnAnimationStart(int threadID, bool HasPlayer)
EndEvent

Event OnLeadInEnd(int threadID, bool HasPlayer)
EndEvent

Event OnAnimationChange(int threadID, bool HasPlayer)
EndEvent

Function ChangeLockState(actor[] actors, bool lockState)
EndFunction

Event OnOrgasmStart(int threadID, bool HasPlayer)
EndEvent

Function RefreshBlindfoldState(actor[] actors)
EndFunction

Event OnAnimationEnd(int threadID, bool HasPlayer)
EndEvent

function RelieveSelf()
EndFunction

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)	
EndEvent

Event OnSleepStop(bool abInterrupted)
EndEvent

KeyWord Function GetKeywordByString(String s)
EndFunction

Event OnDDIEquipDevice(Form akActor, String DeviceType)
EndEvent

Event OnDDIRemoveDevice(Form akActor, String DeviceType)
EndEvent

Event OnDDICreateRestraintsKey(Form akActor)
EndEvent
	
Event OnDDICreateChastityKey(Form akActor)
EndEvent

Event OnDDICreatePiercingKey(Form akActor)
EndEvent
