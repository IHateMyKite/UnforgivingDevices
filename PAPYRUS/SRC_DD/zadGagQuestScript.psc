Scriptname zadGagQuestScript extends Quest  Conditional

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

Bool Property canTalk = false  Auto  Conditional
Actor Property PlayerRef  Auto  
GlobalVariable Property zadGagExpertise  Auto  
GlobalVariable Property zadPlayerMasochism  Auto  
Spell      Property zadgag_SpeechDebuff  Auto
slaFrameworkScr Property sla Auto
zadLibs Property libs Auto

function enableTalk()
endFunction

event OnInit()
endEvent
 
event OnMenuClose(String asMenuName)
endEvent

function increaseGagExp()
endFunction

function increasePlayerMaso()
endFunction