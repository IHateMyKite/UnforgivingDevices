Scriptname WICourierScript extends Quest conditional
{Quest script, and holds functions for using the courier.}

ObjectReference Property pCourier  Auto
{Pointer to WICourierRef}

ObjectReference Property pCourierContainer  Auto  
{Pointer to WICourierContainerRef}

GlobalVariable Property pWICourierItemCount Auto  
{Pointer to global variable}

Keyword Property pLocTypeHabitation Auto
{Pointer to keyword LocTypeHabitation}

Message Property WICourierItemsAddedMsg Auto
{Pointer to Message WICourierItemsAddedMsg}

function incrementItemCount()
	pWICourierItemCount.value += 1	;increment the global variable WICourierItemCount which is used to get courier change location event quest to run, and conditionalize dialogue for the courier
EndFunction

Function decrementItemCount()
	pWICourierItemCount.value -= 1	;decrement the global variable WICourierItemCount which is used to get courier change location event quest to run, and conditionalize dialogue for the courier
EndFunction

function addItemToContainer(form FormToAdd, int countToAdd = 1)
{adds a form item to the courier container, and increments global to turn on courier change location event quest}
; 	debug.trace("WICourierScript: addItemToContainer()")
	pCourierContainer.addItem(FormToAdd, countToAdd)			;add parameter object to container
	incrementItemCount()
endFunction 

function addRefToContainer(objectReference objectRefToAdd) 
{adds a reference to the courier container, and increments global to turn on courier change location event quest}
; 	debug.trace("WICourierScript: addRefToContainer()")
	pCourierContainer.addItem(objectRefToAdd)			;add parameter object to container
	incrementItemCount()
endFunction 

function addAliasToContainer(ReferenceAlias refAliasToAdd) 
{adds a reference of a RefAlias to the courier container, and increments global to turn on courier change location event quest}
; 	debug.trace("WICourierScript: addAliasToContainer() which will get the objectReference of the alias, then call its addRefToContainer()")
	objectReference vObjectRefToAdd = refAliasToAdd.getReference()
	addRefToContainer(vObjectRefToAdd)

EndFunction 

function removeRefFromContainer(objectReference objectRefToRemove, bool GiveToPlayer = False)
	{removes a reference to the courier container, and decrements global to turn on courier change location event quest}
; 	debug.trace("WICourierScript: removeRefFromContainer(Object:" + objectRefToRemove + ", GiveToPlayer:" + GiveToPlayer + ")")

	;MAKE SURE PLAYER ISN'T IN DIALOGUE WITH COURIER
	int timeSpentWaiting
	
	while  (pCourier as actor).IsInDialogueWithPlayer()
; 		debug.trace("WICourierScript: removeRefFromContainer(" + objectRefToRemove + ") COURIER IN DIALOGUE WITH PLAYER, WAITING UNTIL DONE BEFORE ATTEMPTING TO REMOVE ITEM. TimeSpentWaiting = " + timeSpentWaiting)
		utility.wait(1)
		timeSpentWaiting += 1
		
	EndWhile
		
	
	if pCourierContainer.GetItemCount(objectRefToRemove) > 0
; 		debug.trace("WICourierScript: removeRefFromContainer(" + objectRefToRemove + ") is in container, will remove it.")
	
		if GiveToPlayer
; 			debug.trace("WICourierScript: removeRefFromContainer(" + objectRefToRemove + ") removing item from contianer and giving to player .")
			Game.GetPlayer().addItem(objectRefToRemove)
		
		Else
; 			debug.trace("WICourierScript: removeRefFromContainer(" + objectRefToRemove + ") removing item from container, destroying it.")
			pCourierContainer.removeItem(objectRefToRemove)
		
		EndIf
		
		;decrement Global
; 		debug.trace("WICourierScript: removeRefFromContainer(" + objectRefToRemove + ") decrementing WICourierItemCount global.")
		decrementItemCount()
	
	Else
; 		debug.trace("WICourierScript: removeRefFromContainer(" + objectRefToRemove + ") item is NOT in container, DOING NOTHING.", 1)
		
	EndIf
	
	(pCourier as actor).EvaluatePackage()
	
EndFunction


function GiveItemsToPlayer()
	pWICourierItemCount.SetValue(0)
	pCourierContainer.RemoveAllItems(Game.GetPlayer())
	WICourierItemsAddedMsg.Show()
EndFunction


Event OnUpdate()		;registered in stage 0, unregistered in stage 200
	if pCourier.getCurrentLocation().IsSameLocation(Game.GetPlayer().getCurrentLocation(), pLocTypeHabitation)
; 		debug.trace("WICourierScript: Courier and player are in same habitation. Quest is continuing to run.")
	else
; 		debug.trace("WICourierScript: Courier and player are not in same habitation. Stopping quest.")
		stop()
	endif
endEvent


Quest Property WICourier  Auto  

Book Property DBEntranceLetter  Auto  
