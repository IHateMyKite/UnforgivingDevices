Scriptname XPMSELib Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

float Function GetXPMSELibVersion() global
EndFunction

float Function GetXPMSEVersion(Actor akActor, bool isFemale) global
EndFunction

bool Function CheckXPMSEVersion(Actor akActor, bool isFemale, float XPMSEVersion = 2.0, bool abSilent = false) global
EndFunction

bool Function CheckXPMSELibVersion(float XPMSELibVersion = 2.0) global 
EndFunction

Function SetNodeScale(Actor akActor, bool isFemale, string nodeName, float value, string modkey) global
EndFunction

Function SetNodeScaleSkeleton(Actor akActor, bool isFemale, string nodeName, float value, string modkey, bool isFirstPerson = false) global
EndFunction

Function SetNodePosition(Actor akActor, bool isFemale, string nodeName, float[] values, string modkey) global
EndFunction

Function SetNodePositionSkeleton(Actor akActor, bool isFemale, string nodeName, float[] values, string modkey, bool isFirstPerson = false) global
EndFunction

Function SetNodeRotation(Actor akActor, bool isFemale, string nodeName, float[] values, string modkey) global
EndFunction

Function SetNodeRotationSkeleton(Actor akActor, bool isFemale, string nodeName, float[] values, string modkey, bool isFirstPerson = false) global
EndFunction

Function SetNodeParent(Actor akActor, bool isFemale, string nodeName, string newParent) global
EndFunction

Function SetNodeHidden(Actor akActor, bool isFemale, string nodeName, bool value, string modkey) global
EndFunction

Function SetNodeParentSkeleton(Actor akActor, bool isFemale, string nodeName, string newParent, bool isFirstPerson = false) global
EndFunction

bool Function HasNode(Actor akActor, string nodeName, bool isFirstPerson = false) global
EndFunction

Function WriteXPMSEData(Actor akActor, string keyName, int savelevel, float value) global
EndFunction

Function RemoveXPMSEData(Actor akActor, string keyName, int savelevel) global
EndFunction

Function SetAA(Actor akActor, string groupName, float myBase, float myset, string mymod = "XPMSE", int writeback = 0) global
EndFunction

bool Function RevertAnimGroupTo(actor akActor, string animGroup, int writeback) global
endFunction

Bool Function isValidForDualWielding(Actor akActor) global
EndFunction

Int Function isValidForDualWieldingInt(Actor akActor) global
EndFunction

Bool Function isValidFNISaaCameraState() global
EndFunction

Function SetAltAnimation(Actor akActor, string animationVariableName, int value) global
EndFunction

Function SetExtraInfo(Actor akActor, string keyName, float value) global
EndFunction

Function RemoveExtraInfo(Actor akActor, string keyName) global
EndFunction