Scriptname iWant_Widgets extends SKI_WidgetBase

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================


Int Function loadWidget(String filename, Int xpos = 10000, Int ypos = 10000, Bool visible = False)
EndFunction

Int Function loadLibraryWidget(String filename, Int xpos = 10000, Int ypos = 10000, Bool visible = False)
EndFunction

Int Function loadText(String displayString, String font = "$EverywhereFont", Int size = 24, Int xpos = 10000, Int ypos = 10000, Bool visible = False)
EndFunction

Int Function loadMeter(Int xpos = 10000, Int ypos = 10000, Bool visible = False)
EndFunction

Function _waitForReadyToLoad()
EndFunction

String Function _getMessageFromFlash()
EndFunction

Function setMeterPercent(Int id, Int percent)
EndFunction

Function setMeterFillDirection(Int id, String direction)
EndFunction

Function sendToBack(Int id)
EndFunction

Function sendToFront(Int id)
EndFunction

Function doMeterFlash(Int id)
EndFunction

Function setMeterRGB(Int id, Int lightR = 255, Int lightG = 255, Int lightB = 255, Int darkR = 0, Int darkG = 0, Int darkB = 0, Int flashR = 127, Int flashG = 127, Int flashB = 127)
EndFunction

Function setText(Int id, String displayString)
EndFunction

Function appendText(Int id, String displayString)
EndFunction

Function swapDepths(Int id1, Int id2)
EndFunction

Function setPos(Int id, Int xpos, Int ypos)
EndFunction

Function setSize(Int id, Int h, Int w)
EndFunction

Int Function getXsize(Int id)
EndFunction

Int Function getYsize(Int id)
EndFunction

Function setZoom(Int id, Int xscale, Int yscale)
EndFunction

Function setVisible(Int id, Int visible = 1)
EndFunction

Function setRotation(Int id, Int rotation)
EndFunction

Function setTransparency(Int id, Int a)
EndFunction

Function setRGB(Int id, Int r, Int g, Int b)
EndFunction

Function destroy(Int id)
EndFunction

Function drawShapeLine(Int[] list, Int XPos = 639, Int YPos = 359, Int XChange = 25, Int YChange = 25, Bool skipInvisible = True, Bool skipAlpha0 = True)
EndFunction

Function drawShapeCircle(Int[] list, Int XPos = 639, Int YPos = 359, Int radius = 50, Int startAngle = 0, Int degreeChange = 45, Bool skipInvisible = True, Bool skipAlpha0 = True, Bool autoSpace = False)
EndFunction

Function drawShapeOrbit(Int[] list, Int XPos = 639, Int YPos = 359, Int radius = 50, Int startAngle = 0, Int degreeChange = 45, Bool skipInvisible = True, Bool skipAlpha0 = True, Bool autoSpace = False)
EndFunction

Function doTransition(Int id, Int targetValue, Int frames = 60, String targetAttribute = "alpha", String easingClass = "none", String easingMethod = "none", Int delay = 0)
EndFunction

Function doTransitionByFrames(Int id, Int targetValue, Int frames = 120, String targetAttribute = "alpha", String easingClass = "none", String easingMethod = "none", Int delay = 0, Int fps = 60)
EndFunction

Function doTransitionByTime(Int id, Int targetValue, Float seconds = 2.0, String targetAttribute = "alpha", String easingClass = "none", String easingMethod = "none", Float delay = 0.0)
EndFunction

Function setAllVisible(Bool visible = True)
EndFunction

String Function _serializeArray(String[] a)
EndFunction

Function logWidgetData(Int id)
EndFunction

Function triggerReset()
EndFunction

Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
EndEvent

Function setSkyrimTemperature(Int level)
EndFunction

Function setSkyrimHealthMeterPercent(Int percent)
EndFunction

Function setSkyrimStaminaMeterPercent(Int percent)
EndFunction

Function setSkyrimMagickaMeterPercent(Int percent)
EndFunction

String Function _getSkyrimTargetBase(String element)
EndFunction

Function setSkyrimTransparency(String element, Int a = 100)
EndFunction

Function setSkyrimZoom(String element, Int xscale = 100, Int yscale = 100)
EndFunction

Function setSkyrimVisible(String element, Int visible = 1)
EndFunction

Function _setSkyrimPos(String element, Int xpos = 0, Int ypos = 0)
EndFunction

Int Function _getSkyrimXPos(String element)
EndFunction

Int Function _getSkyrimYPos(String element)
EndFunction

Function _setSkyrimSize(String element, Int h, Int w)
EndFunction

Function _setSkyrimRotation(String element, Int rot = 0)
EndFunction

Event OnWidgetReset()
EndEvent

String Function GetWidgetSource()
EndFunction

String Function GetWidgetType()
endFunction
