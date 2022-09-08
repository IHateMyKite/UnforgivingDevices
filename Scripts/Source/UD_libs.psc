Scriptname UD_libs extends Quest  

import UnforgivingDevicesMain

UnforgivingDevicesMain Property main auto

;zadlibs slots
;zad_DeviousHood                30
;hair                           31
;zad_DeviousSuit                32
;zad_DeviousGloves              33
;VANILLA                        34-36
;zad_DeviousBoots               37
;VANILLA                        38-43
;zad_DeviousGag                 44
;zad_DeviousCollar              45
;zad_DeviousHeavyBondage        46
;??????                         47
;zad_DeviousPlugAnal            48
;zad_DeviousBelt                49
;zad_DeviousPiercingsVaginal    50
;zad_DeviousPiercingsNipple     51
;SOS                            52
;zad_DeviousLegCuffs            53
;???                            54
;zad_DeviousBlindfold           55
;zad_DeviousBra                 56
;zad_DeviousPlugVaginal         57
;zad_DeviousHarness             58
;zad_DeviousCorset              58
;zad_DeviousArmCuffs            59
;???                            60

;misc
MiscObject Property Gold auto
Soulgem Property EmptySoulgem_Petty auto
Soulgem Property EmptySoulgem_Lesser auto
Soulgem Property EmptySoulgem_Common auto
Soulgem Property FilledSoulgem_Petty auto
Soulgem Property FilledSoulgem_Lesser auto
Soulgem Property FilledSoulgem_Common auto

Bool Property Ready = False auto
Event OnInit()
    Ready = True
EndEvent

Function Update()
    if !PunisherArmbinder
        PunisherArmbinder = GetMeMyForm(0x15B53D,"UnforgivingDevices.esp") as Armor
    endif
    
    if !PunisherPiercing
        PunisherPiercing = GetMeMyForm(0x15B538,"UnforgivingDevices.esp") as Armor
    endif

    if !PreventCombat_KW
        main.Error("PreventCombat_KW not detected. Loading...")
        PreventCombat_KW = GetMeMyForm(0x15B551,"UnforgivingDevices.esp") as Keyword
        main.Error("PreventCombat_KW loaded")
    endif

    if !PreventCombatSpell
        main.Error("PreventCombatSpell not detected. Loading...")
        PreventCombatSpell = GetMeMyForm(0x15B553,"UnforgivingDevices.esp") as Spell
        main.Error("PreventCombatSpell loaded")
    endif
    
    if !ActorTypeNPC
        main.Error("ActorTypeNPC not detected. Loading...")
        ActorTypeNPC = GetMeMyForm(0x013794,"Skyrim.esm") as Keyword
        main.Error("ActorTypeNPC loaded " + ActorTypeNPC)
    endif
EndFunction

;plug
Armor Property AbadonPlug auto
Armor Property AbadonPlugAnal auto
Armor Property LittleHelper auto
Armor Property ControlablePlugVag auto
Armor Property ControlablePlugAnal auto
Armor Property CursedInflatablePlugAnal auto
Armor Property InflatablePlugAnal auto
Armor Property InflatablePlugVag auto

;hand restrains
Armor Property AbadonArmbinder auto
Armor Property AbadonArmbinderEbonite auto
Armor Property AbadonElbowbinderEbonite auto
Armor Property AbadonCursedStraitjacket auto
Armor Property AbadonStraitjacket auto
Armor Property AbadonStraitjacketEbonite auto
Armor Property AbadonStraitjacketEboniteOpen auto
Armor Property AbadonArmbinderWhite auto
Armor Property AbadonArmbinderRope auto
Armor Property AbadonYoke auto


Armor Property AbadonWeakArmbinder auto
Armor Property AbadonWeakStraitjacket auto
Armor Property AbadonWeakElbowbinder auto
Armor Property AbadonWeakYoke auto

;gags
Armor Property AbadonBallGag auto
Armor Property AbadonPanelGag auto
Armor Property AbadonRingGag auto
Armor Property AbadonGagTape auto
Armor Property AbadonExtremeBallGag auto
Armor Property AbadonExtremeInflatableGag auto
;blindfolds
Armor Property AbadonBlindfold auto
Armor Property AbadonBlindfoldWhite auto
;cuffs
Armor Property AbadonArmCuffs auto
Armor Property AbadonLegsCuffs auto
;collar
Armor Property AbadonCuffCollar auto
Armor Property AbadonRestrictiveCollar auto
;gasmaska
Armor Property AbadonGasmask auto
Armor Property CursedAbadonGasmask auto
;catsuit
Armor Property AbadonSuit auto
Armor Property AbadonTransSuit auto
;boots
Armor Property AbadonBalletBoots auto
Armor Property AbadonRestrictiveBoots auto
Armor Property AbadonTransBoots auto
Armor Property AbadonPonyBootsWhite auto
;gloves
Armor Property AbadonRestrictiveGloves auto
Armor Property AbadonMittens auto
;belt
Armor Property AbadonBelt auto
Armor Property AbadonHarness auto
;corset
Armor Property AbadonCorset auto
;bra
Armor Property AbadonBra auto
;piercings
Armor Property AbadonPiercingVaginal auto
Armor Property AbadonPiercingNipple auto

;other items
Armor Property CustomArmbinder auto

;rare restrains
Armor Property MageBinder auto
Armor Property RogueBinder auto
Armor Property AbadonBlueArmbinder auto
Armor Property PunisherArmbinder auto
Armor Property PunisherPiercing auto

;INVISIBLE RESTRAINS
Armor Property InvisibleArmbinder auto
Armor Property InvisibleHobble auto
Keyword Property InvisibleHBKW auto
Keyword Property InvisibleHobbleKW auto

;Other armors
Armor Property OrgasmResistCirclet auto
Armor Property OrgasmResistRing auto

;other
Ingredient Property BlackGoo auto
Ingredient Property AncientSeed auto
MiscObject Property AbadonGem auto
  
;keywords
Keyword Property QuestDevice auto
Keyword Property AbadonPlugkw auto
Keyword Property CustomHeavyBondageQuestDevice auto
Keyword Property UnforgivingDevice auto
Keyword Property CustomHeavyBondage auto 
Keyword Property PatchedDevice auto
Keyword Property PatchedInventoryDevice auto
Keyword Property HardcoreDisable_KW auto
Keyword Property OrgasmCheck_KW auto
Keyword Property ArousalCheck_KW auto
Keyword Property PreventCombat_KW auto

;spells
Spell Property MinigameDisableSpell auto
Spell Property HardcoreDisableSpell auto
Spell Property OrgasmExhaustionSpell auto
Spell Property StruggleExhaustionSpell auto
Spell Property OrgasmCheckSpell auto
Spell Property OrgasmCheckAbilitySpell auto
Spell Property ArousalCheckSpell auto
Spell Property ArousalCheckAbilitySpell auto
;Spell Property BreathingDebuffSpell auto
Spell Property TelekinesisSpell auto
Spell Property AphrodisiacsSpell auto
Spell Property NPCRegisterSpell auto
Spell Property PreventCombatSpell auto

;crits
Spell Property GreenCrit auto
Spell Property BlueCrit auto
Spell Property RedCrit auto


;ME keywords
Keyword Property OrgasmExhaustionEffect_KW auto
Keyword Property StruggleExhaustionEffect_KW auto
Keyword Property MinigameDisableEffect_KW auto
Keyword Property AphrodisiacsEffect_KW auto

;sharp WEAPON keywords
Keyword[] Property SharpWeaponsKeywords auto

;zad objects
ObjectReference Property TheSafe Auto
ObjectReference Property TheFridge Auto

;formlists
FormList Property GiftMenuFilter auto

;Optional mods
Keyword Property ZAZTears_KW auto
Spell Property ZAZTearsSpell auto

Keyword Property ZAZDrool_KW auto
Spell Property ZAZDroolSpell auto

;DEBUG
Spell Property DEBUGMagickEffect auto

;skyrim keywords
Keyword  Property ActorTypeNPC auto
Keyword  Property ArmorShield auto
FormList Property WeaponKeywords auto

;Device abilities
Spell Property ArousingMovement auto

;Patched devices keywords
Keyword Property PatchNoModes_KW auto
Keyword Property PatchVeryEasy_KW auto
Keyword Property PatchEasy_KW auto
Keyword Property PatchHard_KW auto
Keyword Property PatchVeryHard_KW auto