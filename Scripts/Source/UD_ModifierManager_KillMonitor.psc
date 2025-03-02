Scriptname UD_ModifierManager_KillMonitor extends Quest  

UnforgivingDevicesMain Property UDmain auto

Event OnStoryKillActor(ObjectReference akVictim, ObjectReference akKiller, Location akLocation, int aiCrimeStatus, int aiRelationshipRank)
    UDmain.Info("Kill was detected: akVictim = " + akVictim + ", akKiller = " + akKiller + ", aiCrimeStatus = " + aiCrimeStatus)
    If akVictim != None
        UDmain.Info("Victim: Name = " + akVictim.GetName() + " Reference = " + akVictim + ", Base = " + akVictim.GetBaseObject() + ", Leveled Base = " + (akVictim as Actor).GetLeveledActorBase() as ActorBase)
    EndIf
    If akKiller != None
        UDmain.Info("Killer: Name = " + akKiller.GetName() + " Reference = " + akKiller + ", Base = " + akKiller.GetBaseObject() + ", Leveled Base = " + (akKiller as Actor).GetLeveledActorBase() as ActorBase)
    EndIf

    UDmain.UDMOM.UpdateModifiers_KillMonitor(akVictim, akKiller, akLocation, aiCrimeStatus)
    
    Stop()
EndEvent
