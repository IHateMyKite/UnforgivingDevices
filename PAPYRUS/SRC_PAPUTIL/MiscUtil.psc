scriptname MiscUtil Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

ObjectReference[] function ScanCellObjects(int formType, ObjectReference CenterOn, float radius = 5000.0, Keyword HasKeyword = none) global native
Actor[] function ScanCellNPCs(ObjectReference CenterOn, float radius = 5000.0, Keyword HasKeyword = none, bool IgnoreDead = true) global native
Actor[] function ScanCellNPCsByFaction(Faction FindFaction, ObjectReference CenterOn, float radius = 5000.0, int minRank = 0, int maxRank = 127, bool IgnoreDead = true) global native
function ToggleFreeCamera(bool stopTime = false) global native
function SetFreeCameraSpeed(float speed) global native
function SetFreeCameraState(bool enable, float speed = 10.0) global native
string[] function FilesInFolder(string directory, string extension="*") global native
bool function FileExists(string fileName) global native
string function ReadFromFile(string fileName) global native
bool function WriteToFile(string fileName, string text, bool append = true, bool timestamp = false) global native
function PrintConsole(string text) global native
string function GetRaceEditorID(Race raceForm) global native
string function GetActorRaceEditorID(Actor actorRef) global native
function SetMenus(bool enabled) global native
float function GetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex) global
endFunction
function ExecuteBat(string fileName) global
endFunction
Actor[] function ScanCellActors(ObjectReference CenterOn, float radius = 5000.0, Keyword HasKeyword = none) global
endFunction