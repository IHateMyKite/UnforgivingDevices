scriptname JsonUtil Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

bool function Load(string FileName) global native
bool function Save(string FileName, bool minify = false) global native
bool function Unload(string FileName, bool saveChanges = true, bool minify = false) global native
bool function IsPendingSave(string FileName) global native
bool function IsGood(string FileName) global native
string function GetErrors(string FileName) global native
string[] function JsonInFolder(string folderPath) global native
bool function JsonExists(string FileName) global
endFunction
int function SetIntValue(string FileName, string KeyName, int value) global native
float function SetFloatValue(string FileName, string KeyName, float value) global native
string function SetStringValue(string FileName, string KeyName, string value) global native
form function SetFormValue(string FileName, string KeyName, form value) global native
int function GetIntValue(string FileName, string KeyName, int missing = 0) global native
float function GetFloatValue(string FileName, string KeyName, float missing = 0.0) global native
string function GetStringValue(string FileName, string KeyName, string missing = "") global native
form function GetFormValue(string FileName, string KeyName, form missing = none) global native
bool function UnsetIntValue(string FileName, string KeyName) global native
bool function UnsetFloatValue(string FileName, string KeyName) global native
bool function UnsetStringValue(string FileName, string KeyName) global native
bool function UnsetFormValue(string FileName, string KeyName) global native
bool function HasIntValue(string FileName, string KeyName) global native
bool function HasFloatValue(string FileName, string KeyName) global native
bool function HasStringValue(string FileName, string KeyName) global native
bool function HasFormValue(string FileName, string KeyName) global native
int function IntListAdd(string FileName, string KeyName, int value, bool allowDuplicate = true) global native
int function FloatListAdd(string FileName, string KeyName, float value, bool allowDuplicate = true) global native
int function StringListAdd(string FileName, string KeyName, String value, bool allowDuplicate = true) global native
int function FormListAdd(string FileName, string KeyName, Form value, bool allowDuplicate = true) global native
Int function IntListGet(string FileName, string KeyName, int index) global native
Float function FloatListGet(string FileName, string KeyName, int index) global native
String function StringListGet(string FileName, string KeyName, int index) global native
Form function FormListGet(string FileName, string KeyName, int index) global native
Int function IntListSet(string FileName, string KeyName, int index, int value) global native
Float function FloatListSet(string FileName, string KeyName, int index, float value) global native
String function StringListSet(string FileName, string KeyName, int index, String value) global native
Form function FormListSet(string FileName, string KeyName, int index, Form value) global native
int function IntListRemove(string FileName, string KeyName, int value, bool allInstances = true) global native
int function FloatListRemove(string FileName, string KeyName, float value, bool allInstances = true) global native
int function StringListRemove(string FileName, string KeyName, String value, bool allInstances = true) global native
int function FormListRemove(string FileName, string KeyName, Form value, bool allInstances = true) global native
bool function IntListInsertAt(string FileName, string KeyName, int index, int value) global native
bool function FloatListInsertAt(string FileName, string KeyName, int index, float value) global native
bool function StringListInsertAt(string FileName, string KeyName, int index, String value) global native
bool function FormListInsertAt(string FileName, string KeyName, int index, Form value) global native
bool function IntListRemoveAt(string FileName, string KeyName, int index) global native
bool function FloatListRemoveAt(string FileName, string KeyName, int index) global native
bool function StringListRemoveAt(string FileName, string KeyName, int index) global native
bool function FormListRemoveAt(string FileName, string KeyName, int index) global native
int function IntListClear(string FileName, string KeyName) global native
int function FloatListClear(string FileName, string KeyName) global native
int function StringListClear(string FileName, string KeyName) global native
int function FormListClear(string FileName, string KeyName) global native
int function IntListCount(string FileName, string KeyName) global native
int function FloatListCount(string FileName, string KeyName) global native
int function StringListCount(string FileName, string KeyName) global native
int function FormListCount(string FileName, string KeyName) global native
int function IntListCountValue(string FileName, string KeyName, int value, bool exclude = false) global native
int function FloatListCountValue(string FileName, string KeyName, float value, bool exclude = false) global native
int function StringListCountValue(string FileName, string KeyName, String value, bool exclude = false) global native
int function FormListCountValue(string FileName, string KeyName, Form value, bool exclude = false) global native
int function IntListFind(string FileName, string KeyName, int value) global native
int function FloatListFind(string FileName, string KeyName, float value) global native
int function StringListFind(string FileName, string KeyName, String value) global native
int function FormListFind(string FileName, string KeyName, Form value) global native
bool function IntListHas(string FileName, string KeyName, int value) global native
bool function FloatListHas(string FileName, string KeyName, float value) global native
bool function StringListHas(string FileName, string KeyName, String value) global native
bool function FormListHas(string FileName, string KeyName, Form value) global native
function IntListSlice(string FileName, string KeyName, int[] slice, int startIndex = 0) global native
function FloatListSlice(string FileName, string KeyName, float[] slice, int startIndex = 0) global native
function StringListSlice(string FileName, string KeyName, string[] slice, int startIndex = 0) global native
function FormListSlice(string FileName, string KeyName, Form[] slice, int startIndex = 0) global native
int function IntListResize(string FileName, string KeyName, int toLength, int filler = 0) global native
int function FloatListResize(string FileName, string KeyName, int toLength, float filler = 0.0) global native
int function StringListResize(string FileName, string KeyName, int toLength, string filler = "") global native
int function FormListResize(string FileName, string KeyName, int toLength, Form filler = none) global native
bool function IntListCopy(string FileName, string KeyName, int[] copy) global native
bool function FloatListCopy(string FileName, string KeyName, float[] copy) global native
bool function StringListCopy(string FileName, string KeyName, string[] copy) global native
bool function FormListCopy(string FileName, string KeyName, Form[] copy) global native
int[] function IntListToArray(string FileName, string KeyName) global native
float[] function FloatListToArray(string FileName, string KeyName) global native
string[] function StringListToArray(string FileName, string KeyName) global native
Form[] function FormListToArray(string FileName, string KeyName) global native
int function AdjustIntValue(string FileName, string KeyName, int amount) global native
float function AdjustFloatValue(string FileName, string KeyName, float amount) global native
Int function IntListAdjust(string FileName, string KeyName, int index, Int amount) global native
float function FloatListAdjust(string FileName, string KeyName, int index, float amount) global native
int function CountIntValuePrefix(string FileName, string PrefixKey) global native
int function CountFloatValuePrefix(string FileName, string PrefixKey) global native
int function CountStringValuePrefix(string FileName, string PrefixKey) global native
int function CountFormValuePrefix(string FileName, string PrefixKey) global native
int function CountIntListPrefix(string FileName, string PrefixKey) global native
int function CountFloatListPrefix(string FileName, string PrefixKey) global native
int function CountStringListPrefix(string FileName, string PrefixKey) global native
int function CountFormListPrefix(string FileName, string PrefixKey) global native
int function CountAllPrefix(string FileName, string PrefixKey) global native
function SetPathIntValue(string FileName, string Path, int value) global native
function SetPathFloatValue(string FileName, string Path, float value) global native
function SetPathStringValue(string FileName, string Path, string value) global native
function SetPathFormValue(string FileName, string Path, form value) global native
bool function SetRawPathValue(string FileName, string Path, string RawJSON) global native
int function GetPathIntValue(string FileName, string Path, int missing = 0) global native
float function GetPathFloatValue(string FileName, string Path, float missing = 0.0) global native
string function GetPathStringValue(string FileName, string Path, string missing = "") global native
form function GetPathFormValue(string FileName, string Path, form missing = none) global native
bool function GetPathBoolValue(string FileName, string Path, bool missing = false) global
endFunction
int[] function PathIntElements(string FileName, string Path, int invalidType = 0) global native
float[] function PathFloatElements(string FileName, string Path, float invalidType = 0.0) global native
string[] function PathStringElements(string FileName, string Path, string invalidType = "") global native
form[] function PathFormElements(string FileName, string Path, form invalidType = none) global native
int function FindPathIntElement(string FileName, string Path, int toFind) global native
int function FindPathFloatElement(string FileName, string Path, float toFind) global native
int function FindPathStringElement(string FileName, string Path, string toFind) global native
int function FindPathFormElement(string FileName, string Path, form toFind) global native
int function PathCount(string FileName, string Path) global native
string[] function PathMembers(string FileName, string Path) global native
bool function CanResolvePath(string FileName, string Path) global native
bool function IsPathString(string FileName, string Path) global native
bool function IsPathNumber(string FileName, string Path) global native
bool function IsPathForm(string FileName, string Path) global native
bool function IsPathBool(string FileName, string Path) global native
bool function IsPathArray(string FileName, string Path) global native
bool function IsPathObject(string FileName, string Path) global native
function SetPathIntArray(string FileName, string Path, int[] arr, bool append = false) global native
function SetPathFloatArray(string FileName, string Path, float[] arr, bool append = false) global native
function SetPathStringArray(string FileName, string Path, string[] arr, bool append = false) global native
function SetPathFormArray(string FileName, string Path, form[] arr, bool append = false) global native
function ClearPath(string FileName, string Path) global native
function ClearAll(string FileName) global native
