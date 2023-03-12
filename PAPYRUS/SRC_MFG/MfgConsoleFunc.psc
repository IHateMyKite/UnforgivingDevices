Scriptname MfgConsoleFunc Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

bool function SetPhonemeModifier(Actor act, int mode, int id, int value) native global
int function GetPhonemeModifier(Actor act, int mode, int id) native global
bool function SetPhoneme(Actor act, int id, int value) global
endfunction
bool function SetModifier(Actor act, int id, int value) global
endfunction
bool function ResetPhonemeModifier(Actor act) global
endfunction
int function GetPhoneme(Actor act, int id) global
endfunction
int function GetModifier(Actor act, int id) global
endfunction
int function GetExpressionValue(Actor act) global
endfunction
int function GetExpressionID(Actor act) global
endfunction

