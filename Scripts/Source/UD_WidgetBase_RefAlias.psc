Scriptname UD_WidgetBase_RefAlias extends ReferenceAlias  

String  Property    Name            = ""        Auto Hidden         ; name of the entity (used to identify in API calls)
Bool    Property    IsNew           = True      Auto Hidden         ; flag that this entity is just created (reseted)
Int     Property    PosX            = -1        Auto Hidden         ; x coordinate 
Int     Property    PosY            = -1        Auto Hidden         ; y coordinate 
Bool    Property    Pending         = False     Auto Hidden         ; creation is in process

Function Reset()
    Name = ""
    IsNew = True
    Pending = False
EndFunction

Function SoftReset()
    Pending = False
EndFunction
