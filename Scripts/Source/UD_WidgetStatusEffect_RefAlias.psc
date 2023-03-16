Scriptname UD_WidgetStatusEffect_RefAlias extends UD_WidgetBase_RefAlias  

Int     Property    Cluster       = -1    Auto Hidden
Int     Property    Variant       = 0     Auto Hidden    
Int     Property    VariantLoaded = -1    Auto Hidden

Int     Property    Id            = -1    Auto Hidden     ; widget id (foreground)
Int     Property    AuxId         = -1    Auto Hidden     ; aux widget id (background)
String  Property    FileName                   Hidden     ; DDS file name in '<Data>/interface/exported/widgets/iwant/widgets/library' folder
    String Function Get()
        If Variant == 0
            Return Name
        ElseIf Variant > 0
            Return Name + "-" + Variant
        EndIf
    EndFunction
EndProperty
Int     Property    Magnitude     = 0     Auto Hidden     ; 0 .. 100+
Float   Property    Timer         = 0.0   Auto Hidden     ; animation timer
Int     Property    Stage         = 0     Auto Hidden     ; animation stage
Bool    Property    Blinking      = False Auto Hidden     ; 0, 1
Int     Property    Alpha         = 100   Auto Hidden     ; 0 .. 100
Bool    Property    Visible       = False Auto Hidden     ; 0, 1
Bool    Property    Enabled       = True  Auto Hidden     ; 0, 1

Function Reset()
    Parent.Reset()
    Cluster = -1
    Variant = 0
    VariantLoaded = -1
    Id = -1
    AuxId = -1
    Magnitude = 0
    Timer = 0.0
    Stage = 0
    Blinking = False
    Alpha = 100
    Visible = False
    Enabled = True
EndFunction

Function SoftReset()
    Parent.SoftReset()
    Magnitude = 0
    Timer = 0.0
    Stage = 0
    Blinking = False
    Visible = False
EndFunction

Int _Magnitude
Float _Timer
Int _Stage
Bool _Blinking
Bool _Visible

Function StartTest()
    _Magnitude = Magnitude
    _Timer = Timer
    _Stage = Stage
    _Blinking = Blinking
    _Visible = Visible
EndFunction

Function EndTest()
    Magnitude = _Magnitude
    Timer = _Timer
    Stage = _Stage
    Blinking = _Blinking
    Visible = _Visible
EndFunction
