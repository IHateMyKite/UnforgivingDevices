Scriptname UD_libs extends Quest  

UnforgivingDevicesMain Property main auto
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

;plug
Armor Property AbadonPlug auto
Armor Property AbadonPlugAnal auto
Armor Property LittleHelper auto
Armor Property ControlablePlugVag auto
Armor Property ControlablePlugAnal auto
Armor Property CursedInflatablePlugAnal auto
Armor Property InflatablePlugAnal auto
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

;INVISIBLE RESTRAINS
Armor Property InvisibleArmbinder auto
Armor Property InvisibleHobble auto
Keyword Property InvisibleHBKW auto
Keyword Property InvisibleHobbleKW auto

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
Keyword Property PatchNoModes_KW auto
;spells
Spell Property MinigameDisableSpell auto
Spell Property OrgasmExhaustionSpell auto
Spell Property StruggleExhaustionSpell auto
;Spell Property BreathingDebuffSpell auto
Spell Property TelekinesisSpell auto
Spell Property AphrodisiacsSpell auto
Spell Property NPCRegisterSpell auto
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