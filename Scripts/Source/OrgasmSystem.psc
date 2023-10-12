Scriptname OrgasmSystem hidden

;   enum OrgasmVariable : uint8_t
;   {
;       vOrgasmRate                 = 1,
;       vOrgasmRateMult             = 2,
;       vOrgasmResistence           = 3,
;       vOrgasmResistenceMult       = 4,
;       vOrgasmCapacity             = 5,
;       vOrgasmForcing              = 6
;   };

;   enum OrgasmUpdateType : uint8_t
;   {
;       mSet                        = 0x1,
;       mAdd                        = 0x2,
;       mMultiply                   = 0x3,
;   };

;   enum OrgasmMod : uint32_t
;   {
;       //default modes
;       mNone                       = 0x00,
;       mEdgeOnly                   = 0x01,
;
;       //timer setting
;       mTimed                      = 0x02, //orgasm change will be removed once time elapses. Duration is saved in last 16 bites of OrgasmMod passed to AddOrgasmChange function
;       mTimeMod_Lin                = 0x03, //orgasm rate will decrease over time lineary
;       mTimeMod_Exp                = 0x04  //orgasm rate will decrease over time exponencialy
;
;       //7-15  = reserved
;       //16-31 = Duration (seconds)
;   };
Bool    Function AddOrgasmChange( Actor akActor, String askey, Int aiMod,Int aiEroZones, Float afOrgasmRate, Float afOrgasmRateMult = 0.0, Float afOrgasmForcing = 0.0, Float afOrgasmCapacity = 0.0, Float afOrgasmResistence = 0.0, Float afOrgasmResistenceMult = 0.0) global native
Bool    Function RemoveOrgasmChange(Actor akActor, String asKey)                    global native


Bool    Function UpdateOrgasmChangeVar(Actor akActor, String asKey, Int aiVariable, Float afValue, Int aiUpdateType) global native
Float   Function GetOrgasmChangeVar(Actor akActor, String asKey, Int aiVariable)    global native
Bool    Function HaveOrgasmChange(Actor akActor, String asKey)                      global native

Float   Function GetOrgasmProgress(Actor akActor, Int aiMod = 0)                    global native
        Function ResetOrgasmProgress(Actor akActor)                                 global native

Float   Function GetOrgasmVariable(Actor akActor, Int aiVariable)                   global native
Float   Function GetAntiOrgasmRate(Actor akActor)                                   global native

        Function LinkActorToMeter(Actor akActor, String asPath,Int aiType,Int aiId) global native
        Function UnlinkActorFromMeter(Actor akActor)                                global native