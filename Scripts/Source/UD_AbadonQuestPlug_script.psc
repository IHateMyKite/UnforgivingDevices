Scriptname UD_AbadonQuestPlug_script extends ReferenceAlias  

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if (akNewContainer as Actor) && GetOwningQuest().GetStage() < 20
        Actor akActor = akNewContainer as Actor
        ;UDAbadonPlugScript script = Game.getPlayer().placeatme(self.getReference().getBaseObject()) as UDAbadonPlugScript
        UD_AbadonQuest_script script = GetOwningQuest() as UD_AbadonQuest_script
        if script.UseAnalVariant
            script.UDmain.libs.SwapDevices(akActor, UDlibs.AbadonPlugAnal, script.UDmain.libs.zad_deviousPlugAnal, false, true)
        else
            script.UDmain.libs.SwapDevices(akActor, UDlibs.AbadonPlug, script.UDmain.libs.zad_deviousPlugVaginal, false, true)
        endif
        
        script.UD_AbadonVictim = akActor
        debug.messagebox("After being buried for centuries the plugs hunger is immeasurable! Powerful magics cloud your mind and compel you to insert the plug. After the plug is inserted, restraints summoned by the plug latch on to you! It seems the plug does not want to be removed.")
        GetOwningQuest().SetStage(20)        
        GetOwningQuest().SetObjectiveCompleted(20)
        GetOwningQuest().SetObjectiveDisplayed(30)
    endif
EndEvent

UD_libs Property UDlibs auto