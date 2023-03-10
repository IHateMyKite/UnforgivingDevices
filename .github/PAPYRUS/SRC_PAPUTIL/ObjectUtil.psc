scriptname ObjectUtil Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

function SetReplaceAnimation(ObjectReference obj, string oldAnimEvent, Idle newAnim) global native
bool function RemoveReplaceAnimation(ObjectReference obj, string oldAnimEvent) global native
int function CountReplaceAnimation(ObjectReference obj) global native
int function ClearReplaceAnimation(ObjectReference obj) global native
string function GetKeyReplaceAnimation(ObjectReference obj, int index) global native
Idle function GetValueReplaceAnimation(ObjectReference obj, string oldAnim) global native
