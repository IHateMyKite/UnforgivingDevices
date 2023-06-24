Scriptname UD_SwimmingScript extends Quest  

UnforgivingDevicesMain                  Property UDmain     auto

zadlibs Property libs auto
bool Property UD_hardcore_swimming = True auto
int Property UD_hardcore_swimming_difficulty = 1 auto
Spell Property SwimPenaltySpell auto

bool Property startedSwimming = False auto
bool Property drowning = False auto

bool Property SpellActivated = False auto

Event OnInit()
    Utility.wait(10.0)
    registerforsingleupdate(0.2)
EndEvent

Event OnUpdate()
    if UDmain.IsEnabled()
        if libs.playerRef.wornhaskeyword(libs.zad_deviousheavybondage) && UD_hardcore_swimming
            if libs.playerRef.isSwimming(); && !SpellActivated
                SpellActivated = True
                SwimPenaltySpell.cast(libs.playerRef, libs.playerRef)
                while SpellActivated
                    Utility.wait(1.0)
                endwhile
            endif
        endif
        registerforsingleupdate(1.0)
    else
        registerforsingleupdate(3.0)
    endif
EndEvent
