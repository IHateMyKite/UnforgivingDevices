Scriptname UD_WidgetMeter_RefAlias extends UD_WidgetBase_RefAlias  

Int     Property    Id              = -1        Auto Hidden
Int     Property    IconId          = -1        Auto Hidden
Bool    Property    Visible         = False     Auto Hidden
Int     Property    FillPercent     = 0         Auto Hidden
Int     Property    PrimaryColor    = 0         Auto Hidden
Int     Property    SecondaryColor  = 0         Auto Hidden
Int     Property    FlashColor      = 0         Auto Hidden
String  Property    IconName        = ""        Auto Hidden
Actor   Property    OrgasmLink      = None      Auto Hidden         ; link to the native orgasm lib
Int     Property    NR_Formula      = 0         Auto Hidden
Float   Property    NR_Value        = 0.0       Auto Hidden
Float   Property    NR_Rate         = 0.0       Auto Hidden
Bool    Property    NR_Toggle       = True      Auto Hidden

Function Reset()
    Parent.Reset()
    Id = -1
    IconId = -1
    FillPercent = 0
    PrimaryColor = 0
    SecondaryColor = 0
    FlashColor = 0
    Visible = False
    IconName = ""
    NR_Formula      = 0
    NR_Value        = 0.0
    NR_Rate         = 0.0
    NR_Toggle       = True
    OrgasmLink      = None
EndFunction

Function SoftReset()
    Parent.SoftReset()
    FillPercent = 0
    Visible = False
    NR_Formula      = 0
    NR_Value        = 0.0
    NR_Rate         = 0.0
    NR_Toggle       = True
    OrgasmLink      = None
EndFunction

Int _PrimaryColor
Int _SecondaryColor
Int _FlashColor
Bool _Visible
Int _FillPercent

Function StartTest()
    _Visible = Visible
    _PrimaryColor = PrimaryColor
    _SecondaryColor = SecondaryColor
    _FlashColor = FlashColor
    _FillPercent = FillPercent
EndFunction

Function EndTest()
    Visible = _Visible
    PrimaryColor = _PrimaryColor
    SecondaryColor = _SecondaryColor
    FlashColor = _FlashColor
    FillPercent = _FillPercent
EndFunction
