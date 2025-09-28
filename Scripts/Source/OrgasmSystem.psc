;   File: OrgasmSystem
;   This script containt native functions for OrgasmSystem
Scriptname OrgasmSystem hidden

;/   About: OrgasmVariable
     --- Code
     enum OrgasmVariable : uint8_t
     {
         vNone                       =  0,
     
         vOrgasmRate                 =  1,
         vOrgasmRateMult             =  2,
         vOrgasmResistence           =  3,
         vOrgasmResistenceMult       =  4,
         vOrgasmCapacity             =  5,
         vOrgasmForcing              =  6,
     
         vElapsedTime                =  7, //orgasm change only! UpdateOrgasmChangeVar and GetOrgasmChangeVar only
     
         vArousal                    =  8, //no orgasm change! GetOrgasmVariable only
         vArousalRate                =  9,
         vArousalRateMult            = 10,
     
         vEdgeDuration               = 11, //orgasm change only! UpdateOrgasmChangeVar and GetOrgasmChangeVar only
         vEdgeRemDuration            = 12, //orgasm change only! UpdateOrgasmChangeVar and GetOrgasmChangeVar only
         vEdgeThreashold             = 13, //orgasm change only! UpdateOrgasmChangeVar and GetOrgasmChangeVar only
     
         vBaseDistance               = 14,
     
         vLast
     }
     ---
/;

;/   About: OrgasmUpdateType
     --- Code
     enum OrgasmUpdateType : uint8_t
     {
        mSet                        = 0x1,
        mAdd                        = 0x2,
        mMultiply                   = 0x3,
     }
     ---
/;

;/  About: OrgasmMod
    --- Code
    enum OrgasmMod : uint32_t
    {
         //default modes
         mNone                       = 0x00,

         mEdgeOnly                   = 0x01,
         mEdgeRandom                 = 0x02, //currently works same as mEdgeOnly
         mTimed                      = 0x04, //orgasm change will be removed once time elapses. Duration is saved in last 16 bites of OrgasmMod passed to AddOrgasmChange function
         mTimeMod_Lin                = 0x08, //orgasm rate will decrease over time lineary

         mTimeMod_Exp                = 0x10, //orgasm rate will decrease over time exponencialy. Use this in combination with mTimed to make multiple timed changes
         mMakeKey                    = 0x20, //create new key if passed key is already used
         mArousingMovement           = 0x40

         //16-31 = Duration (seconds)
    }
    ---
/;

;/  About: EroZone
    --- Code
    enum EroZone : uint32_t
    {
        eNone                   = 0x00000000,
        eVagina1                = 0x00000001,
        eVagina2                = 0x00000002,
        eClitoris               = 0x00000004,
        ePenis1                 = 0x00000008,
        ePenis2                 = 0x00000010,
        ePenis3                 = 0x00000020,
        eNipples                = 0x00000040,
        eAnal1                  = 0x00000080,
        eAnal2                  = 0x00000100,
        eDefault                = 0x00000200    //when you dont care about ero zones
    }
    ---
/;

;/  About: OrgasmFlag
    --- Code
    enum OrgasmFlag : uint32_t
    {
        eOfNone           = 0x00000000,
        eOfPreventOrgasm  = 0x00000001    // Actor cant orgasm while this flag is present
    }
    ---
/;

Bool    Function AddOrgasmChange(Actor akActor, String askey, Int aiMod,Int aiEroZones, Float afOrgasmRate = 0.0, Float afOrgasmRateMult = 0.0, Float afOrgasmForcing = 0.0, Float afOrgasmCapacity = 0.0, Float afOrgasmResistence = 0.0, Float afOrgasmResistenceMult = 0.0) global native
Bool    Function RemoveOrgasmChange(Actor akActor, String asKey)                    global native


Bool    Function UpdateOrgasmChangeVar(Actor akActor, String asKey, Int aiVariable, Float afValue, Int aiUpdateType = 1) global native
Float   Function GetOrgasmChangeVar(Actor akActor, String asKey, Int aiVariable)    global native
Bool    Function HaveOrgasmChange(Actor akActor, String asKey)                      global native

Float   Function GetOrgasmProgress(Actor akActor, Int aiMod = 0)                    global native
        Function ResetOrgasmProgress(Actor akActor)                                 global native

Float   Function GetOrgasmVariable(Actor akActor, Int aiVariable)                   global native
Float   Function GetAntiOrgasmRate(Actor akActor)                                   global native

        Function LinkActorToMeter(Actor akActor, String asPath,Int aiType,Int aiId) global native
        Function UnlinkActorFromMeter(Actor akActor)                                global native
        
String  Function MakeUniqueKey(Actor akActor,String asBase)                         global native

String[] Function GetAllOrgasmChanges(Actor akActor)                                global native
Int     Function RemoveAllOrgasmChanges(Actor akActor)                              global native

bool    Function IsOrgasming(Actor akActor)                                         global native
int     Function GetOrgasmingCount(Actor akActor)                                   global native

        Function ForceOrgasm(Actor akActor)                                         global native ;mainly for compatibility with mods which use different aproach

String  Function GetHornyStatus(Actor akActor)                                      global native

; See OrgasmFlag section above
Int     Function GetOrgasmFlags(Actor akActor)                                      global native
Bool    Function SetOrgasmFlags(Actor akActor, Int aiFlags)                         global native

; If fallback arousal calculation should be used instead
Bool    Function UseArousalFallback()                                               global native

;Events
        Function RegisterForOrgasmEvent_Ref(ReferenceAlias akRefAlias)              global native
        Function RegisterForOrgasmEvent_Form(Form akForm)                           global native
        Function RegisterForExpressionUpdate_Ref(ReferenceAlias akRefAlias)         global native
        Function RegisterForExpressionUpdate_Form(Form akForm)                      global native