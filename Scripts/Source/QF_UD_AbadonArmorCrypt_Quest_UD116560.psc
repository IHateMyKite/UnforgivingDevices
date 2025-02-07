;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname QF_UD_AbadonArmorCrypt_Quest_UD116560 Extends Quest Hidden

;BEGIN ALIAS PROPERTY DeadBody
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DeadBody Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BossTreasureMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_BossTreasureMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BossChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_BossChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY LetterOnTable
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_LetterOnTable Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY LocationCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_LocationCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY LocationNotCleared
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_LocationNotCleared Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DeviceInChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DeviceInChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Location
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_Location Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY LetterOnBody
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_LetterOnBody Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; Stage #0 (Start up)
If Alias_DeadBody.GetActorRef() != None
    Alias_DeadBody.GetActorRef().KillSilent()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; Stage #10
; Player found the note
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; Stage #20
; Player read the note
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
; Stage #100 
; The player found the device
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
; Stage #110
; The End. The player has left the location.
If IsStageDone(10) == False
; player didn't find the note
    If Alias_LetterOnTable.GetRef() != None
        Alias_LetterOnTable.GetRef().Delete()
    EndIf
    If Alias_LetterOnBody.GetRef() != None
        Alias_LetterOnBody.GetRef().Delete()
    EndIf
EndIf
If IsStageDone(100) == False
; player didn't find the device
    If Alias_DeviceInChest.GetRef() != None
        Alias_DeviceInChest.GetRef().Delete()
    EndIf
EndIf
If Alias_DeadBody.GetActorRef() != None
    Alias_DeadBody.GetRef().Delete()
EndIf
Self.Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
; Stage #200 (Shut down)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
