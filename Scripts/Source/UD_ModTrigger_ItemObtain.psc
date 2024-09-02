;/  File: UD_ModTrigger_ItemObtain
    It triggers with a given chance after actor obtains an item
    
    NameFull: Item Obtain
    
    Parameters (DataStr):
        [0]     Int     (optional) Minimun number of items to trigger
                        Default value: 1
        
        [1]     Float   (optional) Base probability to trigger (in %)
                        Default value: 100.0%
        
        [2]     Float   (optional) Probability to trigger that is proportional to the accumulated value (number of obtained items)
                        Default value: 0.0%
                        
        [3]     Float   (optional) Reset period (in hours)
                        Default value: -1.0 (Triggers once)
                        
        [6]     Float   (script) Number of obtained items so far

    Forms:
        Form1           Item or Keyword to filter obtained items
    
    Example:
        
/;
Scriptname UD_ModTrigger_ItemObtain extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

