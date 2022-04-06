;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_UD_AbadonQuest_0712B6B1 Extends Quest Hidden

;BEGIN ALIAS PROPERTY LetterAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_LetterAlias Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY GiverAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_GiverAlias Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AbadonPlugAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AbadonPlugAlias Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AbadonPlugAnalAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AbadonPlugAnalAlias Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Alias_LetterAlias.GetReference().Enable() ;If you marked your note alias as "Initially Disabled"
CourierScript.AddItemToContainer(Alias_LetterAlias.GetReference())
;debug.notification("Courier sent!")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

WICourierScript Property CourierScript  Auto  
