scriptname UD_ExpressionManager extends Quest

UDCustomDeviceMain Property UDCDmain auto

bool Property Ready = false auto

Event OnInit()
	Utility.waitMenuMode(2.5)
	RegisterExpression("UDAroused")
	RegisterExpression("UDOrgasm")
	RegisterExpression("UDStruggleMinigame_Angry")
	UDCDmain.Print("[UD]: Expressions ready!")
	Ready = true
EndEvent

Function RegisterExpression(string sJsonName)
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("Registering expression " + sJsonName)
	endif
	
	int loc_aliasNum = GetNumAliases()
	
	while loc_aliasNum
		loc_aliasNum -= 1
		sslBaseExpression loc_expressionSlot = GetNthAlias(loc_aliasNum) as sslBaseExpression
		if !loc_expressionSlot.Registered
			loc_expressionSlot.MakeEphemeral(sJsonName, none)
			loc_expressionSlot.ImportJson()
			if UDCDmain.TraceAllowed()			
				UDCDmain.Log("Expression["+ loc_aliasNum +"] = " + sJsonName + ", registered!")
			endif
			return
		endif
	endwhile
EndFunction

sslBaseExpression Function getExpression(string sExpressionName)
	int loc_aliasNum = GetNumAliases()
	
	while loc_aliasNum
		loc_aliasNum -= 1
		sslBaseExpression loc_expressionSlot = GetNthAlias(loc_aliasNum) as sslBaseExpression
		if loc_expressionSlot.Name == sExpressionName
			return loc_expressionSlot
		endif
	endwhile
	if UDCDmain.TraceAllowed()	
		UDCDmain.Log("!!Expression " + sExpressionName + " not found!")
	endif
EndFunction

