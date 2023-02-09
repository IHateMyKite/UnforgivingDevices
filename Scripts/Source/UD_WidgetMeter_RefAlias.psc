Scriptname UD_WidgetMeter_RefAlias extends UD_WidgetBase_RefAlias  

Int     Property    Id              = -1        Auto Hidden
Bool    Property    Visible         = False     Auto Hidden
Int     Property    FillPercent     = 0         Auto Hidden
Int     Property    PrimaryColor    = 0         Auto Hidden
Int     Property    SecondaryColor  = 0         Auto Hidden
Int     Property    FlashColor      = 0         Auto Hidden

Function Reset()
    Parent.Reset()
    Id = -1
    FillPercent = 0
    PrimaryColor = 0
    SecondaryColor = 0
    FlashColor = 0
    Visible = False
EndFunction

Function SoftReset()
    Parent.SoftReset()
    FillPercent = 0
    Visible = False
EndFunction
