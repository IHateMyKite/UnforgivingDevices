Scriptname UD_WidgetMeter_RefAlias extends UD_WidgetBase_RefAlias  

Int     Property    Id              = -1        Auto Hidden
String  Property    Name            = ""        Auto Hidden
Bool    Property    Visible         = False     Auto Hidden
Int     Property    FillPercent     = 0         Auto Hidden
Int     Property    PrimaryColor    = 0         Auto Hidden
Int     Property    SecondaryColor  = 0         Auto Hidden
Int     Property    FlashColor      = 0         Auto Hidden

Function Reset()
    Id = -1
    Name = ""
    FillPercent = 0
    PrimaryColor = 0
    SecondaryColor = 0
    FlashColor = 0
    Visible = False
EndFunction

Function SoftReset()
    FillPercent = 0
    Visible = False
EndFunction
