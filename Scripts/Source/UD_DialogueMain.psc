Scriptname UD_DialogueMain extends Quest Conditional

ReferenceAlias  Property Dummy auto 
ReferenceAlias  Property Player auto 
Int Property SelectedDialogue = 0 auto Conditional

Scene Property HeavyBondageDialogueScene_Start auto
Scene Property GagDialogueScene_Start auto
Scene Property BlindfoldDialogueScene_Start auto
Scene Property SuitDialogueScene_Start auto
Scene Property PlugDialogueScene_Start auto
Scene Property ControllablePlugDialogueScene_Start auto
Scene Property InflatablePlugDialogueScene_Start auto
Scene Property BeltDialogueScene_Start auto
Scene Property BraDialogueScene_Start auto
Scene Property GenericDialogueScene_Start auto
Scene Property HoodDialogueScene_Start auto

Scene Property HeavyBondageDialogueScene_End auto
Scene Property GagDialogueScene_End auto
Scene Property BlindfoldDialogueScene_End auto
Scene Property SuitDialogueScene_End auto
Scene Property PlugDialogueScene_End auto
Scene Property ControllablePlugDialogueScene_End auto
Scene Property InflatablePlugDialogueScene_End auto
Scene Property BeltDialogueScene_End auto
Scene Property BraDialogueScene_End auto
Scene Property GenericDialogueScene_End auto
Scene Property HoodDialogueScene_End auto


Function onInit()
    Utility.wait(3.0)
    RegisterForModEvent("UD_SentientDialogue","startDialogue")
EndFUnction

Function spawnDummy()
    int random = Utility.randomInt(0,3)
    if random == 0
        Dummy.GetReference().GetBaseObject().SetName("*Sound inside your head*")
    elseif random == 1
        Dummy.GetReference().GetBaseObject().SetName("*Devious thought*")
    elseif random == 2
        Dummy.GetReference().GetBaseObject().SetName("*Mysterious voice*")
    elseif random == 3
        Dummy.GetReference().GetBaseObject().SetName("*Voice from within*")
    endif
    
    Dummy.GetReference().moveto(Game.getPlayer(), afZOffset = -35.0)
EndFunction

Function startDialogue(string eventName, string type, float fArg, Form sender)
    bool OnStart = Math.ceiling(fArg - 0.5) as bool
    ;debug.trace("[UD] Dialogue called for "+type+ " , value : "+OnStart)
    spawnDummy()
    Utility.wait(1.0)
    if type == "Hand restrain"
        if OnStart
            HeavyBondageDialogueScene_Start.start()
        else
            HeavyBondageDialogueScene_End.start()
        endif
    elseif type == "Gag"
        if OnStart
            GagDialogueScene_Start.start()
        else
            GagDialogueScene_End.start()
        endif
    elseif type == "Blindfold"
        if OnStart
            BlindfoldDialogueScene_Start.start()
        else
            BlindfoldDialogueScene_End.start()
        endif
    elseif type == "Suit"
        if OnStart
            SuitDialogueScene_Start.start()
        else
            SuitDialogueScene_End.start()
        endif
    elseif type == "Plug" ||  type == "Controllable Plug" || type == "Inflatable Plug"&& PlugDialogueScene_Start
        if OnStart
            PlugDialogueScene_Start.start()
        else
            PlugDialogueScene_End.start()
        endif
    elseif type == "Belt"
        if OnStart
            BeltDialogueScene_Start.start()
        else
            BeltDialogueScene_End.start()
        endif
    elseif type == "Bra"
        if OnStart
            BraDialogueScene_Start.start()
        else
            BraDialogueScene_End.start()
        endif
    elseif type == "Hood"
        if OnStart
            HoodDialogueScene_Start.start()
        else
            HoodDialogueScene_End.start()
        endif
    else
        if OnStart
            GenericDialogueScene_Start.start()
        else
            GenericDialogueScene_End.start()
        endif
    endif
EndFunction
