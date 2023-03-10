Scriptname sslEffectDebug extends ActiveMagicEffect

import PapyrusUtil
import JsonUtil

SexLabFramework property SexLab auto
sslSystemConfig property Config auto
Actor property PlayerRef auto

Actor Ref1
Actor Ref2

float scale1
float scale2

string ActorName
ObjectReference MarkerRef

sslBenchmark function Benchmark(int Tests = 1, int Iterations = 5000, int Loops = 10, bool UseBaseLoop = false)
	return (Quest.GetQuest("SexLabDev") as sslBenchmark).StartBenchmark(Tests, Iterations, Loops, UseBaseLoop)
endFunction


event OnEffectStart(Actor TargetRef, Actor CasterRef)
	; Benchmark(3, 5000, 5)
	SexLab.QuickStart(CasterRef, TargetRef)

	; CreatureSlots.RegisterJSONFolder()
	; Log("Creature slots should have just failed!")

	; sslAnimationSlots AnimSlots = SexLab.AnimSlots

	; AnimSlots.GetbyRegistrar("ArrokReverseCowgirl").ExportJSON()

	; sslBaseAnimation[] Anims = new sslBaseAnimation[10]
	; Anims[0] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[1] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[2] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[3] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[4] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[5] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[6] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[7] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[8] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))
	; Anims[9] = AnimSlots.GetBySlot(Utility.RandomInt(1, 125))

	; Log("Export test")
	; Anims[0].ExportJSON()
	; Anims[1].ExportJSON()
	; Anims[2].ExportJSON()
	; Anims[3].ExportJSON()
	; Anims[4].ExportJSON()
	; Anims[5].ExportJSON()

	; AnimSlots.RegisterJSONFolder()

	; Log("Creature Export test")
	; sslCreatureAnimationSlots CreatureSlots = SexLab.CreatureSlots
	; CreatureSlots.GetbyRegistrar("TrollGrabbing").ExportJSON()
	; CreatureSlots.RegisterJSONFolder()
	; Log("Creature slots should have just failed!")

	; sslBaseAnimation[] CAnims = new sslBaseAnimation[10]
	; CAnims[0] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[1] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[2] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[3] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[4] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[5] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[6] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[7] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[8] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))
	; CAnims[9] = CreatureSlots.GetBySlot(Utility.RandomInt(1, 125))


	; CAnims[0].ExportJSON()
	; CAnims[1].ExportJSON()
	; CAnims[2].ExportJSON()
	; CAnims[3].ExportJSON()
	; CAnims[4].ExportJSON()
	; CAnims[5].ExportJSON()

	; CreatureSlots.RegisterJSONFolder()



	;/ Log("Forbid test")

	AnimSlots.NeverRegister(Anims[9].Registry)
	AnimSlots.NeverRegister(Anims[8].Registry)
	AnimSlots.NeverRegister(Anims[7].Registry)
	AnimSlots.NeverRegister(Anims[7].Registry)
	AnimSlots.NeverRegister(Anims[7].Registry)

	AnimSlots.NeverRegister(Anims[2].Registry)
	Log(" --- "+Anims[2].Registry +": TRUE == "+AnimSlots.IsSuppressed(Anims[2].Registry))
	Log(" --- "+Anims[3].Registry +": FALSE == "+AnimSlots.IsSuppressed(Anims[3].Registry))
	AnimSlots.AllowRegister(Anims[2].Registry)
	Log(" --- "+Anims[2].Registry +": FALSE == "+AnimSlots.IsSuppressed(Anims[2].Registry))
	AnimSlots.NeverRegister(Anims[4].Registry)
	Log(" --- "+Anims[4].Registry +": TRUE == "+AnimSlots.IsSuppressed(Anims[4].Registry))
	AnimSlots.NeverRegister(Anims[4].Registry)
	AnimSlots.NeverRegister(Anims[4].Registry)
	AnimSlots.NeverRegister(Anims[4].Registry)
	Log(" --- "+Anims[4].Registry +": TRUE == "+AnimSlots.IsSuppressed(Anims[4].Registry))
	AnimSlots.AllowRegister(Anims[4].Registry)
	Log(" --- "+Anims[4].Registry +": FALSE == "+AnimSlots.IsSuppressed(Anims[4].Registry))
	Log(" --- "+Anims[7].Registry +": TRUE == "+AnimSlots.IsSuppressed(Anims[7].Registry))
	Log(" --- "+Anims[8].Registry +": TRUE == "+AnimSlots.IsSuppressed(Anims[8].Registry))
	Log(" --- "+Anims[9].Registry +": TRUE == "+AnimSlots.IsSuppressed(Anims[9].Registry))
	Log(" --- "+Anims[6].Registry +": FALSE == "+AnimSlots.IsSuppressed(Anims[6].Registry)) /;




	; sslBaseAnimation Anim1 = SexLab.AnimSlots.GetBySlot(Utility.RandomInt(1, 42))
	; Anim.ExportJSON()
;/ 
	string[] Tags = Anim.GetTags()
	Log(Anim.Name+" Tags: "+Tags)
	bool[] CachedTags = new bool[8]
	sslBaseAnimation._CacheTags(Tags, CachedTags)
	Log("Cached Tags: "+CachedTags) 
 /;
	; StorageUtil.FormListAdd(Config, "TestList", Config)
	; StorageUtil.FormListAdd(Config, "TestList", TargetRef)
	; StorageUtil.FormListAdd(Config, "TestList", CasterRef)
	; StorageUtil.FormListAdd(Config, "TestList", none)
	; StorageUtil.FormListAdd(Config, "TestList", Config.AnimSlots)
	; StorageUtil.FormListAdd(Config, "TestList", CasterRef)

	; int[] Types = new int[3]
	; Types[0] = 43
	; Types[1] = 44
	; Types[2] = 62

	; Log("Count: "+StorageUtil.FormListCount(Config, "TestList"))
	; Log("FormListFilterByTypes(Array, true): "+StorageUtil.FormListFilterByTypes(Config, "TestList", Types, true))
	; Log("FormListFilterByTypes(Array, false): "+StorageUtil.FormListFilterByTypes(Config, "TestList", Types, false))
	; Log("FormListFilterByType(43, true): "+StorageUtil.FormListFilterByType(Config, "TestList", 43, true))
	; Log("FormListFilterByType(43, false): "+StorageUtil.FormListFilterByType(Config, "TestList", 43, false))
	; Log("FormListFilterByType(44, true): "+StorageUtil.FormListFilterByType(Config, "TestList", 44, true))
	; Log("FormListFilterByType(44, false): "+StorageUtil.FormListFilterByType(Config, "TestList", 44, false))
	; Log("FormListFilterByType(62, true): "+StorageUtil.FormListFilterByType(Config, "TestList", 62, true))
	; Log("FormListFilterByType(62, false): "+StorageUtil.FormListFilterByType(Config, "TestList", 62, false))


	; Form FormRef = JsonUtil.GetFormValue("TempTest.json", "FormRef")
	; Log("Current FormRef: "+FormRef+" / TYPE: "+FormRef.GetType())

	; if Config.BackwardsPressed() || Config.AdjustStagePressed()

	; 	(FormRef as ObjectReference).Disable()
	; 	(FormRef as ObjectReference).Delete()
	; 	FormRef = none
	; 	Log("DELETED FormRef[1]: "+JsonUtil.GetFormValue("TempTest.json", "FormRef")+" / TYPE: "+JsonUtil.GetFormValue("TempTest.json", "FormRef").GetType())
	; 	Utility.Wait(5.0)
	; 	Log("DELETED FormRef[2]: "+JsonUtil.GetFormValue("TempTest.json", "FormRef")+" / TYPE: "+JsonUtil.GetFormValue("TempTest.json", "FormRef").GetType())
	; 	ObjectReference TmpRef1 = CasterRef.PlaceAtMe(Config.BaseMarker)
	; 	Utility.Wait(5.0)
	; 	ObjectReference TmpRef2 = CasterRef.PlaceAtMe(Config.BaseMarker)
	; 	Log("TmpRef1: "+TmpRef1+" TmpRef2: "+TmpRef2)
	; 	Utility.Wait(5.0)
	; 	Log("DELETED FormRef[2]: "+JsonUtil.GetFormValue("TempTest.json", "FormRef")+" / TYPE: "+JsonUtil.GetFormValue("TempTest.json", "FormRef").GetType())
	; 	Utility.Wait(5.0)

	; else

	; 	MarkerRef = CasterRef.PlaceAtMe(Config.BaseMarker)
	; 	int cycle
	; 	while !MarkerRef.Is3DLoaded() && cycle < 50
	; 		Utility.Wait(0.1)
	; 		cycle += 1
	; 	endWhile
	; 	Log("Waited ["+cycle+"] cycles for MarkerRef["+MarkerRef+"]")
	; 	Utility.Wait(5.0)
	; 	Log("Setting FormRef: "+MarkerRef+" / TYPE: "+MarkerRef.GetType())
	; 	JsonUtil.SetFormValue("TempTest.json", "FormRef", MarkerRef)
	; 	Form CurrentRef = JsonUtil.GetFormValue("TempTest.json", "FormRef")
	; 	Log("GETTING FormRef: "+CurrentRef+" / TYPE: "+CurrentRef.GetType())

	; endIf

	; JsonUtil.Save("TempTest.json")

	; Utility.Wait(10.0)

	Dispel()
endEvent

event OnUpdate()
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
	;/ if MarkerRef
		TargetRef.SetVehicle(none)
		MarkerRef.Disable()
		MarkerRef.Delete()
		MarkerRef = none
	endIf /;
	; Log("---- FINISHED ----")
endEvent



;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function Log(string log)
	Debug.Trace(log)
	Debug.TraceUser("SexLabDebug", log)
	SexLabUtil.PrintConsole(log)
endfunction

string function GetActorNames(Actor[] Actors)
	string names
	int i = Actors.Length
	while i
		i -= 1
		names += "["+Actors[i].GetLeveledActorBase().GetName()+"]"
	endWhile
	return names
endFunction

string function GetObjNames(ObjectReference[] Objects)
	string names
	int i = Objects.Length
	while i
		i -= 1
		names += "["+Objects[i].GetName()+"]"
	endWhile
	return names
endFunction

float[] function GetCoords(Actor ActorRef)
	float[] coords = new float[6]
	coords[0] = ActorRef.GetPositionX()
	coords[1] = ActorRef.GetPositionY()
	coords[2] = ActorRef.GetPositionZ()
	coords[3] = ActorRef.GetAngleX()
	coords[4] = ActorRef.GetAngleY()
	coords[5] = ActorRef.GetAngleZ()
	return coords
endFunction

float[] function OffsetCoords(float[] Loc, float[] CenterLoc, float[] Offsets)
	Loc[0] = CenterLoc[0] + ( Math.sin(CenterLoc[5]) * Offsets[0] ) + ( Math.cos(CenterLoc[5]) * Offsets[1] )
	Loc[1] = CenterLoc[1] + ( Math.cos(CenterLoc[5]) * Offsets[0] ) + ( Math.sin(CenterLoc[5]) * Offsets[1] )
	Loc[2] = CenterLoc[2] + Offsets[2]
	Loc[3] = CenterLoc[3]
	Loc[4] = CenterLoc[4]
	Loc[5] = CenterLoc[5] + Offsets[3]
	if Loc[5] >= 360.0
		Loc[5] = Loc[5] - 360.0
	elseIf Loc[5] < 0.0
		Loc[5] = Loc[5] + 360.0
	endIf
	return Loc
endFunction

float function Scale(Actor ActorRef)
	float display = ActorRef.GetScale()
	ActorRef.SetScale(1.0)
	float base = ActorRef.GetScale()
	float ActorScale = ( display / base )
	ActorRef.SetScale(ActorScale)
	float AnimScale = (1.0 / base)
	return AnimScale
endFunction

function LockActor(actor ActorRef)
	ActorRef.StopCombat()
	; Disable movement
	if ActorRef == SexLab.PlayerRef
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.ForceThirdPerson()
		; Game.SetPlayerAIDriven()
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
	endIf
	; Start DoNothing package
	ActorUtil.AddPackageOverride(ActorRef, SexLab.ActorLib.DoNothing, 100)
	ActorRef.SetFactionRank(SexLab.AnimatingFaction, 1)
	ActorRef.EvaluatePackage()
endFunction

function UnlockActor(actor ActorRef)
	; Enable movement
	if ActorRef == SexLab.PlayerRef
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
		; Game.SetPlayerAIDriven(false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
	endIf
	; Remove from animation faction
	ActorUtil.RemovePackageOverride(ActorRef, SexLab.ActorLib.DoNothing)
	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
endFunction
