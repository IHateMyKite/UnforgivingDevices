;/  File: UD_ModTrigger_ItemDemand
    It triggers with a given chance after actor failed to obtain an item before time expires
    
    NameFull: Item Demand
    
    Parameters (DataStr):
        [0]     Int     (optional) Number of items demanded
                        Default value: 1
        
        [1]     Float   (optional) Base probability to trigger (in %) at the end of the check period if actor failed to obtain items
                        Default value: 100.0%
        
        [2]     Float   (optional) Probability to trigger that is proportional to the accumulated value (number of obtained items)
                        Default value: 0.0%
                        
        [3]     Float   (optional) The time given to obtain items (in hours)
                        Default value: 8.0
                        
        [4]     Int     (optional) Repeat
                        Default value: 0 (False)
                        
        [6]     Float   (script) Number of obtained items so far

    Forms:
        Form1           Item or Keyword to filter demanded items
        
    Example:
        
/;
Scriptname UD_ModTrigger_ItemDemand extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Int Function GetEventProcessingMask()
    Return 0x00000000
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;

