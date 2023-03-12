scriptname StorageUtil Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

int function SetIntValue(Form ObjKey, string KeyName, int value) global native
float function SetFloatValue(Form ObjKey, string KeyName, float value) global native
string function SetStringValue(Form ObjKey, string KeyName, string value) global native
Form function SetFormValue(Form ObjKey, string KeyName, Form value) global native
bool function UnsetIntValue(Form ObjKey, string KeyName) global native;
bool function UnsetFloatValue(Form ObjKey, string KeyName) global native
bool function UnsetStringValue(Form ObjKey, string KeyName) global native
bool function UnsetFormValue(Form ObjKey, string KeyName) global native
bool function HasIntValue(Form ObjKey, string KeyName) global native
bool function HasFloatValue(Form ObjKey, string KeyName) global native
bool function HasStringValue(Form ObjKey, string KeyName) global native
bool function HasFormValue(Form ObjKey, string KeyName) global native
int function GetIntValue(Form ObjKey, string KeyName, int missing = 0) global native
float function GetFloatValue(Form ObjKey, string KeyName, float missing = 0.0) global native
string function GetStringValue(Form ObjKey, string KeyName, string missing = "") global native
Form function GetFormValue(Form ObjKey, string KeyName, Form missing = none) global native
int function PluckIntValue(Form ObjKey, string KeyName, int missing = 0) global native
float function PluckFloatValue(Form ObjKey, string KeyName, float missing = 0.0) global native
string function PluckStringValue(Form ObjKey, string KeyName, string missing = "") global native
Form function PluckFormValue(Form ObjKey, string KeyName, Form missing = none) global native
int function AdjustIntValue(Form ObjKey, string KeyName, int amount) global native
float function AdjustFloatValue(Form ObjKey, string KeyName, float amount) global native
int function IntListAdd(Form ObjKey, string KeyName, int value, bool allowDuplicate = true) global native
int function FloatListAdd(Form ObjKey, string KeyName, float value, bool allowDuplicate = true) global native
int function StringListAdd(Form ObjKey, string KeyName, string value, bool allowDuplicate = true) global native
int function FormListAdd(Form ObjKey, string KeyName, Form value, bool allowDuplicate = true) global native
int function IntListGet(Form ObjKey, string KeyName, int index) global native
float function FloatListGet(Form ObjKey, string KeyName, int index) global native
string function StringListGet(Form ObjKey, string KeyName, int index) global native
Form function FormListGet(Form ObjKey, string KeyName, int index) global native
int function IntListSet(Form ObjKey, string KeyName, int index, int value) global native
float function FloatListSet(Form ObjKey, string KeyName, int index, float value) global native
string function StringListSet(Form ObjKey, string KeyName, int index, string value) global native
Form function FormListSet(Form ObjKey, string KeyName, int index, Form value) global native
int function IntListPluck(Form ObjKey, string KeyName, int index, int missing) global native
float function FloatListPluck(Form ObjKey, string KeyName, int index, float missing) global native
string function StringListPluck(Form ObjKey, string KeyName, int index, string missing) global native
Form function FormListPluck(Form ObjKey, string KeyName, int index, Form missing) global native
int function IntListShift(Form ObjKey, string KeyName) global native
float function FloatListShift(Form ObjKey, string KeyName) global native
string function StringListShift(Form ObjKey, string KeyName) global native
Form function FormListShift(Form ObjKey, string KeyName) global native
int function IntListPop(Form ObjKey, string KeyName) global native
float function FloatListPop(Form ObjKey, string KeyName) global native
string function StringListPop(Form ObjKey, string KeyName) global native
Form function FormListPop(Form ObjKey, string KeyName) global native
int function IntListAdjust(Form ObjKey, string KeyName, int index, int amount) global native
float function FloatListAdjust(Form ObjKey, string KeyName, int index, float amount) global native
bool function IntListInsert(Form ObjKey, string KeyName, int index, int value) global native
bool function FloatListInsert(Form ObjKey, string KeyName, int index, float value) global native
bool function StringListInsert(Form ObjKey, string KeyName, int index, string value) global native
bool function FormListInsert(Form ObjKey, string KeyName, int index, Form value) global native
int function IntListRemove(Form ObjKey, string KeyName, int value, bool allInstances = false) global native
int function FloatListRemove(Form ObjKey, string KeyName, float value, bool allInstances = false) global native
int function StringListRemove(Form ObjKey, string KeyName, string value, bool allInstances = false) global native
int function FormListRemove(Form ObjKey, string KeyName, Form value, bool allInstances = false) global native
int function IntListClear(Form ObjKey, string KeyName) global native
int function FloatListClear(Form ObjKey, string KeyName) global native
int function StringListClear(Form ObjKey, string KeyName) global native
int function FormListClear(Form ObjKey, string KeyName) global native
bool function IntListRemoveAt(Form ObjKey, string KeyName, int index) global native
bool function FloatListRemoveAt(Form ObjKey, string KeyName, int index) global native
bool function StringListRemoveAt(Form ObjKey, string KeyName, int index) global native
bool function FormListRemoveAt(Form ObjKey, string KeyName, int index) global native
int function IntListCount(Form ObjKey, string KeyName) global native
int function FloatListCount(Form ObjKey, string KeyName) global native
int function StringListCount(Form ObjKey, string KeyName) global native
int function FormListCount(Form ObjKey, string KeyName) global native
int function IntListCountValue(Form ObjKey, string KeyName, int value, bool exclude = false) global native
int function FloatListCountValue(Form ObjKey, string KeyName, float value, bool exclude = false) global native
int function StringListCountValue(Form ObjKey, string KeyName, string value, bool exclude = false) global native
int function FormListCountValue(Form ObjKey, string KeyName, Form value, bool exclude = false) global native
int function IntListFind(Form ObjKey, string KeyName, int value) global native
int function FloatListFind(Form ObjKey, string KeyName, float value) global native
int function StringListFind(Form ObjKey, string KeyName, string value) global native
int function FormListFind(Form ObjKey, string KeyName, Form value) global native
bool function IntListHas(Form ObjKey, string KeyName, int value) global native
bool function FloatListHas(Form ObjKey, string KeyName, float value) global native
bool function StringListHas(Form ObjKey, string KeyName, string value) global native
bool function FormListHas(Form ObjKey, string KeyName, Form value) global native
function IntListSort(Form ObjKey, string KeyName) global native
function FloatListSort(Form ObjKey, string KeyName) global native
function StringListSort(Form ObjKey, string KeyName) global native
function FormListSort(Form ObjKey, string KeyName) global native
function IntListSlice(Form ObjKey, string KeyName, int[] slice, int startIndex = 0) global native
function FloatListSlice(Form ObjKey, string KeyName, float[] slice, int startIndex = 0) global native
function StringListSlice(Form ObjKey, string KeyName, string[] slice, int startIndex = 0) global native
function FormListSlice(Form ObjKey, string KeyName, Form[] slice, int startIndex = 0) global native
int function IntListResize(Form ObjKey, string KeyName, int toLength, int filler = 0) global native
int function FloatListResize(Form ObjKey, string KeyName, int toLength, float filler = 0.0) global native
int function StringListResize(Form ObjKey, string KeyName, int toLength, string filler = "") global native
int function FormListResize(Form ObjKey, string KeyName, int toLength, Form filler = none) global native
bool function IntListCopy(Form ObjKey, string KeyName, int[] copy) global native
bool function FloatListCopy(Form ObjKey, string KeyName, float[] copy) global native
bool function StringListCopy(Form ObjKey, string KeyName, string[] copy) global native
bool function FormListCopy(Form ObjKey, string KeyName, Form[] copy) global native
int[] function IntListToArray(Form ObjKey, string KeyName) global native
float[] function FloatListToArray(Form ObjKey, string KeyName) global native
string[] function StringListToArray(Form ObjKey, string KeyName) global native
Form[] function FormListToArray(Form ObjKey, string KeyName) global native
Form[] function FormListFilterByTypes(Form ObjKey, string KeyName, int[] FormTypeIDs, bool ReturnMatching = true) global native
Form[] function FormListFilterByType(Form ObjKey, string KeyName, int FormTypeID, bool ReturnMatching = true) global
endFunction
int function CountIntValuePrefix(string PrefixKey) global native
int function CountFloatValuePrefix(string PrefixKey) global native
int function CountStringValuePrefix(string PrefixKey) global native
int function CountFormValuePrefix(string PrefixKey) global native
int function CountIntListPrefix(string PrefixKey) global native
int function CountFloatListPrefix(string PrefixKey) global native
int function CountStringListPrefix(string PrefixKey) global native
int function CountFormListPrefix(string PrefixKey) global native
int function CountAllPrefix(string PrefixKey) global native
int function CountObjIntValuePrefix(Form ObjKey, string PrefixKey) global native
int function CountObjFloatValuePrefix(Form ObjKey, string PrefixKey) global native
int function CountObjStringValuePrefix(Form ObjKey, string PrefixKey) global native
int function CountObjFormValuePrefix(Form ObjKey, string PrefixKey) global native
int function CountObjIntListPrefix(Form ObjKey, string PrefixKey) global native
int function CountObjFloatListPrefix(Form ObjKey, string PrefixKey) global native
int function CountObjStringListPrefix(Form ObjKey, string PrefixKey) global native
int function CountObjFormListPrefix(Form ObjKey, string PrefixKey) global native
int function CountAllObjPrefix(Form ObjKey, string PrefixKey) global native
int function ClearIntValuePrefix(string PrefixKey) global native
int function ClearFloatValuePrefix(string PrefixKey) global native
int function ClearStringValuePrefix(string PrefixKey) global native
int function ClearFormValuePrefix(string PrefixKey) global native
int function ClearIntListPrefix(string PrefixKey) global native
int function ClearFloatListPrefix(string PrefixKey) global native
int function ClearStringListPrefix(string PrefixKey) global native
int function ClearFormListPrefix(string PrefixKey) global native
int function ClearAllPrefix(string PrefixKey) global native
int function ClearObjIntValuePrefix(Form ObjKey, string PrefixKey) global native
int function ClearObjFloatValuePrefix(Form ObjKey, string PrefixKey) global native
int function ClearObjStringValuePrefix(Form ObjKey, string PrefixKey) global native
int function ClearObjFormValuePrefix(Form ObjKey, string PrefixKey) global native
int function ClearObjIntListPrefix(Form ObjKey, string PrefixKey) global native
int function ClearObjFloatListPrefix(Form ObjKey, string PrefixKey) global native
int function ClearObjStringListPrefix(Form ObjKey, string PrefixKey) global native
int function ClearObjFormListPrefix(Form ObjKey, string PrefixKey) global native
int function ClearAllObjPrefix(Form ObjKey, string PrefixKey) global native
function debug_DeleteValues(Form ObjKey) global native
function debug_DeleteAllValues() global native
int function debug_Cleanup() global native
Form[] function debug_AllIntObjs() global native
Form[] function debug_AllFloatObjs() global native
Form[] function debug_AllStringObjs() global native
Form[] function debug_AllFormObjs() global native
Form[] function debug_AllIntListObjs() global native
Form[] function debug_AllFloatListObjs() global native
Form[] function debug_AllStringListObjs() global native
Form[] function debug_AllFormListObjs() global native
string[] function debug_AllObjIntKeys(Form ObjKey) global native
string[] function debug_AllObjFloatKeys(Form ObjKey) global native
string[] function debug_AllObjStringKeys(Form ObjKey) global native
string[] function debug_AllObjFormKeys(Form ObjKey) global native
string[] function debug_AllObjIntListKeys(Form ObjKey) global native
string[] function debug_AllObjFloatListKeys(Form ObjKey) global native
string[] function debug_AllObjStringListKeys(Form ObjKey) global native
string[] function debug_AllObjFormListKeys(Form ObjKey) global native
int function debug_GetIntObjectCount() global native
int function debug_GetFloatObjectCount() global native
int function debug_GetStringObjectCount() global native
int function debug_GetFormObjectCount() global native
int function debug_GetIntListObjectCount() global native
int function debug_GetFloatListObjectCount() global native
int function debug_GetStringListObjectCount() global native
int function debug_GetFormListObjectCount() global native
Form function debug_GetIntObject(int index) global native
Form function debug_GetFloatObject(int index) global native
Form function debug_GetStringObject(int index) global native
Form function debug_GetFormObject(int index) global native
Form function debug_GetIntListObject(int index) global native
Form function debug_GetFloatListObject(int index) global native
Form function debug_GetStringListObject(int index) global native
Form function debug_GetFormListObject(int index) global native
int function debug_GetIntKeysCount(Form ObjKey) global native
int function debug_GetFloatKeysCount(Form ObjKey) global native
int function debug_GetStringKeysCount(Form ObjKey) global native
int function debug_GetFormKeysCount(Form ObjKey) global native
int function debug_GetIntListKeysCount(Form ObjKey) global native
int function debug_GetFloatListKeysCount(Form ObjKey) global native
int function debug_GetStringListKeysCount(Form ObjKey) global native
int function debug_GetFormListKeysCount(Form ObjKey) global native
string function debug_GetIntKey(Form ObjKey, int index) global native
string function debug_GetFloatKey(Form ObjKey, int index) global native
string function debug_GetStringKey(Form ObjKey, int index) global native
string function debug_GetFormKey(Form ObjKey, int index) global native
string function debug_GetIntListKey(Form ObjKey, int index) global native
string function debug_GetFloatListKey(Form ObjKey, int index) global native
string function debug_GetStringListKey(Form ObjKey, int index) global native
string function debug_GetFormListKey(Form ObjKey, int index) global native
int function FileSetIntValue(string KeyName, int value) global
endFunction
float function FileSetFloatValue(string KeyName, float value) global
endFunction
string function FileSetStringValue(string KeyName, string value) global
endFunction
form function FileSetFormValue(string KeyName, Form value) global
endFunction
int function FileAdjustIntValue(string KeyName, int amount) global
endFunction
float function FileAdjustFloatValue(string KeyName, float amount) global
endFunction
bool function FileUnsetIntValue(string KeyName) global
endFunction
bool function FileUnsetFloatValue(string KeyName) global
endFunction
bool function FileUnsetStringValue(string KeyName) global
endFunction
bool function FileUnsetFormValue(string KeyName) global
endFunction
bool function FileHasIntValue(string KeyName) global
endFunction
bool function FileHasFloatValue(string KeyName) global
endFunction
bool function FileHasStringValue(string KeyName) global
endFunction
bool function FileHasFormValue(string KeyName) global
endFunction
int function FileGetIntValue(string KeyName, int missing = 0) global
endFunction
float function FileGetFloatValue(string KeyName, float missing = 0.0) global
endFunction
string function FileGetStringValue(string KeyName, string missing = "") global
endFunction
Form function FileGetFormValue(string KeyName, Form missing = none) global
endFunction
int function FileIntListAdd(string KeyName, int value, bool allowDuplicate = true) global
endFunction
int function FileFloatListAdd(string KeyName, float value, bool allowDuplicate = true) global
endFunction
int function FileStringListAdd(string KeyName, string value, bool allowDuplicate = true) global
endFunction
int function FileFormListAdd(string KeyName, Form value, bool allowDuplicate = true) global
endFunction
int function FileIntListAdjust(string KeyName, int index, int amount) global
endFunction
float function FileFloatListAdjust(string KeyName, int index, float amount) global
endFunction
int function FileIntListRemove(string KeyName, int value, bool allInstances = false) global
endFunction
int function FileFloatListRemove(string KeyName, float value, bool allInstances = false) global
endFunction
int function FileStringListRemove(string KeyName, string value, bool allInstances = false) global
endFunction
int function FileFormListRemove(string KeyName, Form value, bool allInstances = false) global
endFunction
int function FileIntListGet(string KeyName, int index) global
endFunction
float function FileFloatListGet(string KeyName, int index) global
endFunction
string function FileStringListGet(string KeyName, int index) global
endFunction
Form function FileFormListGet(string KeyName, int index) global
endFunction
int function FileIntListSet(string KeyName, int index, int value) global
endFunction
float function FileFloatListSet(string KeyName, int index, float value) global
endFunction
string function FileStringListSet(string KeyName, int index, string value) global
endFunction
Form function FileFormListSet(string KeyName, int index, Form value) global
endFunction
int function FileIntListClear(string KeyName) global
endFunction
int function FileFloatListClear(string KeyName) global
endFunction
int function FileStringListClear(string KeyName) global
endFunction
int function FileFormListClear(string KeyName) global
endFunction
bool function FileIntListRemoveAt(string KeyName, int index) global
endFunction
bool function FileFloatListRemoveAt(string KeyName, int index) global
endFunction
bool function FileStringListRemoveAt(string KeyName, int index) global
endFunction
bool function FileFormListRemoveAt(string KeyName, int index) global
endFunction
bool function FileIntListInsert(string KeyName, int index, int value) global
endFunction
bool function FileFloatListInsert(string KeyName, int index, float value) global
endFunction
bool function FileStringListInsert(string KeyName, int index, string value) global
endFunction
bool function FileFormListInsert(string KeyName, int index, Form value) global
endFunction
int function FileIntListCount(string KeyName) global
endFunction
int function FileFloatListCount(string KeyName) global
endFunction
int function FileStringListCount(string KeyName) global
endFunction
int function FileFormListCount(string KeyName) global
endFunction
int function FileIntListFind(string KeyName, int value) global
endFunction
int function FileFloatListFind(string KeyName, float value) global
endFunction
int function FileStringListFind(string KeyName, string value) global
endFunction
int function FileFormListFind(string KeyName, Form value) global
endFunction
bool function FileIntListHas(string KeyName, int value) global
endFunction
bool function FileFloatListHas(string KeyName, float value) global
endFunction
bool function FileStringListHas(string KeyName, string value) global
endFunction
bool function FileFormListHas(string KeyName, Form value) global
endFunction
function FileIntListSlice(string KeyName, int[] slice, int startIndex = 0) global
endFunction
function FileFloatListSlice(string KeyName, float[] slice, int startIndex = 0) global
endFunction
function FileStringListSlice(string KeyName, string[] slice, int startIndex = 0) global
endFunction
function FileFormListSlice(string KeyName, Form[] slice, int startIndex = 0) global
endFunction
int function FileIntListResize(string KeyName, int toLength, int filler = 0) global
endFunction
int function FileFloatListResize(string KeyName, int toLength, float filler = 0.0) global
endFunction
int function FileStringListResize(string KeyName, int toLength, string filler = "") global
endFunction
int function FileFormListResize(string KeyName, int toLength, Form filler = none) global
endFunction
bool function FileIntListCopy(string KeyName, int[] copy) global
endFunction
bool function FileFloatListCopy(string KeyName, float[] copy) global
endFunction
bool function FileStringListCopy(string KeyName, string[] copy) global
endFunction
bool function FileFormListCopy(string KeyName, Form[] copy) global
endFunction
function debug_SaveFile() global
endFunction
int function debug_FileGetIntKeysCount() global
endFunction
int function debug_FileGetFloatKeysCount() global
endFunction
int function debug_FileGetStringKeysCount() global
endFunction
int function debug_FileGetIntListKeysCount() global
endFunction
int function debug_FileGetFloatListKeysCount() global
endFunction
int function debug_FileGetStringListKeysCount() global
endFunction
string function debug_FileGetIntKey(int index) global
endFunction
string function debug_FileGetFloatKey(int index) global
endFunction
string function debug_FileGetStringKey(int index) global
endFunction
string function debug_FileGetIntListKey(int index) global
endFunction
string function debug_FileGetFloatListKey(int index) global
endFunction
string function debug_FileGetStringListKey(int index) global
endFunction
function debug_FileDeleteAllValues() global
endFunction
function debug_SetDebugMode(bool enabled) global
endFunction
bool function ImportFile(string fileName, string restrictKey = "", int restrictType = -1, Form restrictForm = none, bool restrictGlobal = false, bool keyContains = false) global
endFunction
bool function ExportFile(string fileName, string restrictKey = "", int restrictType = -1, Form restrictForm = none, bool restrictGlobal = false, bool keyContains = false, bool append = true) global
endFunction
