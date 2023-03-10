Scriptname FNISSMConfigMenu extends SKI_ConfigBase  

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

FNISSMQuestScript Property FNISSMquest Auto

Event OnPageReset(string page)
endEvent
event OnOptionSelect(int option)
endEvent
Event OnConfigClose()
endEvent
bool Function set_SMno(int OId, bool Val)
endFunction
Function set_SMweight(int OId, int i)
endFunction
Function set_SMplayer(int i)
endFunction
