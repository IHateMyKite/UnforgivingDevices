Scriptname UD_LeveledList_Patcher extends Quest 

import UnforgivingDevicesMain

UD_libs Property UDlibs auto
UnforgivingDevicesMain Property UDmain auto
bool Property Ready = false auto

;Lists to add
LeveledItem Property UD_LIL_AncientSeed auto
LeveledItem Property UD_LIL_BlackGoo auto
LeveledItem Property UD_LIL_DragonNuts auto
LeveledItem Property UD_LIL_Jewelry auto
LeveledItem Property UD_LIL_EnchCirclet auto

;LISTS to patch
LeveledItem Property UD_LIL_DraugrNormal auto
LeveledItem Property UD_LIL_Wolf auto
LeveledItem Property UD_LIL_Dragon auto
LeveledItem Property UD_LIL_MerchantEnchJewel auto

LeveledItem Property LIL_AllEnchCirclet auto

FormList Property UD_BlackGooDropList auto

Event OnInit()
    RegisterForSingleUpdate(30)
    Ready = true
EndEvent

Event OnUpdate()
    if UDmain.UDReady()
        Process()
    else
        RegisterForSingleUpdate(30)
    endif
EndEvent

Function Update()
    Process()
EndFunction

Function Process()
    int loc_patched = 0
    ;UD_LIL_DraugrNormal
    if !LILHaveForm(UD_LIL_DraugrNormal,UD_LIL_AncientSeed)
        loc_patched += 1
        UD_LIL_DraugrNormal.addForm(UD_LIL_AncientSeed, 1, 1)
    endif
    
    ;UD_BlackGooDropList
    loc_patched += AddFormToLIL(UD_LIL_BlackGoo, UD_BlackGooDropList)
    
    ;UD_LIL_Dragon
    if !LILHaveForm(UD_LIL_Dragon,UD_LIL_DragonNuts)
        loc_patched += 1
        UD_LIL_Dragon.addForm(UD_LIL_DragonNuts,1,1)
    endif
    
    ;UD_LIL_MerchantEnchJewel
    if !LILHaveForm(LIL_AllEnchCirclet,UD_LIL_EnchCirclet)
        loc_patched += 1
        LIL_AllEnchCirclet.AddForm(UD_LIL_EnchCirclet,1,1)
    endif
    if loc_patched
    GInfo("UD_LeveledList_Patcher - Forms added to LeveledLists: " + loc_patched)
    endif
EndFunction

Bool Function LILHaveForm(LeveledItem akLIL, Form akForm)
    int loc_size = akLIL.GetNumForms()
    while loc_size
        loc_size -= 1
        if akLIL.GetNthForm(loc_size) == akForm
            return true
        endif
    endwhile
    return false
EndFunction

int Function AddFormToLIL(Form akForm, FormList akFormList)
    int loc_res = 0
    int loc_size = akFormList.GetSize()
    while loc_size
        loc_size -= 1
        LeveledItem loc_LIL =  akFormList.GetAt(loc_size) as LeveledItem
        if !LILHaveForm(loc_LIL,akForm)
            loc_LIL.addForm(akForm,1,1)
            loc_res += 1
        endif
    endwhile
    return loc_res
EndFunction