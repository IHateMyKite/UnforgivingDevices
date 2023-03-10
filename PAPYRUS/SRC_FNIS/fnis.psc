Scriptname FNIS Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================


int Function set_AACondition(actor ac, string AAtype, string mod, int AAcond, int AAdebug = 1) global
endFunction

Function AAReport(string longReport, string shortReport, int AAdebug = 0, bool isError = true) global
endFunction

bool function IsGenerated() global
endFunction

string function VersionToString( bool abCreature = false ) global
endFunction

int function VersionCompare( int iCompMajor, int iCompMinor1, int iCompMinor2, bool abCreature = false ) global
endFunction

int function GetMajor( bool abCreature = false ) global
endFunction

int function GetMinor1( bool abCreature = false ) global
endFunction

int function GetMinor2( bool abCreature = false ) global
endFunction

int function GetFlags( bool abCreature = false ) global
endFunction

Bool function IsRelease( bool abCreature = false ) global
endFunction
