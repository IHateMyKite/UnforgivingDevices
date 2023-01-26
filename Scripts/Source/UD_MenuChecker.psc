Scriptname UD_MenuChecker extends Quest hidden

import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto

String[]     Property UD_MenuList                               auto hidden
bool[]       Property UD_MenuListID                             auto hidden
string       Property UD_LastMenuOpened             = "none"    auto hidden
Bool         Property UD_MenuOpened                 = false     auto hidden

;================================;
;   ID |||        MENU             ;
;--------------------------------;
;    00     =     ContainerMenu        ;
;    01     =     Lockpicking Menu     ;
;    02     =     InventoryMenu        ;
;    03     =     Journal Menu         ;
;    04     =     Crafting Menu        ;
;    05     =     Dialogue Menu        ;
;    06     =     FavoritesMenu        ;
;    07     =     GiftMenu             ;
;    08     =     Main Menu            ;
;    09     =     Loading Menu         ;
;    10     =     Book Menu            ;
;    11     =     MagicMenu            ;
;    12     =     MapMenu              ;
;    13     =     MessageBoxMenu       ;
;    14     =     RaceSex Menu         ;
;    15     =     Sleep/Wait Menu      ;
;    16     =     StatsMenu            ;
;    17     =     Tutorial Menu        ;
;    18     =     TweenMenu            ;
;    19     =     Console              ;
;    20     =     BarterMenu           ;
;=================================

Bool Function IsMenuOpen(Int aiID)
    return UD_MenuListID[aiID]
EndFunction

Event OnInit()
    Utility.waitMenuMode(0.5)
    InitMenuArr()
    RegisterMenuEvents()
EndEvent

Function Update()
    InitMenuArr()
    UnregisterMenuEvents()
    RegisterMenuEvents()
EndFunction

Function InitMenuArr()
    UD_MenuList     = new String[21]
    UD_MenuListID    = new bool[21]
    
    UD_MenuList[00] = "ContainerMenu"
    UD_MenuList[01] = "Lockpicking Menu"
    UD_MenuList[02] = "InventoryMenu"
    UD_MenuList[03] = "Journal Menu"
    UD_MenuList[04] = "Crafting Menu"
    UD_MenuList[05] = "Dialogue Menu"
    UD_MenuList[06] = "FavoritesMenu"
    UD_MenuList[07] = "GiftMenu"
    UD_MenuList[08] = "Main Menu"
    UD_MenuList[09] = "Loading Menu"
    UD_MenuList[10] = "Book Menu"
    UD_MenuList[11] = "MagicMenu"
    UD_MenuList[12] = "MapMenu"
    UD_MenuList[13] = "MessageBoxMenu"
    UD_MenuList[14] = "RaceSex Menu"
    UD_MenuList[15] = "Sleep/Wait Menu"
    UD_MenuList[16] = "StatsMenu"
    UD_MenuList[17] = "Tutorial Menu"
    UD_MenuList[18] = "TweenMenu"
    UD_MenuList[19] = "Console"
    UD_MenuList[20] = "BarterMenu"
EndFunction

Function RegisterMenuEvents()
    int loc_i = UD_MenuList.length
    while loc_i
        loc_i -= 1
        RegisterForMenu(UD_MenuList[loc_i])
    endwhile
EndFunction

Function UnregisterMenuEvents()
    UnregisterForAllMenus()
EndFunction

Event OnMenuOpen(String MenuName)
    if MenuName != "Console" && MenuName != "MessageBoxMenu" ;these can be opened over other menus, check them out
        UD_LastMenuOpened = MenuName
        UD_MenuOpened = true
    elseif UD_LastMenuOpened == "none"
        UD_LastMenuOpened = MenuName
        UD_MenuOpened = true
    endif
    
    Int loc_i = 0
    while loc_i < UD_MenuList.length
        if UD_MenuList[loc_i] == MenuName
            UD_MenuListID[loc_i] = true
            return
        endif
        loc_i += 1
    endwhile
EndEvent

Event OnMenuClose(String MenuName)
    if MenuName != "Console" && MenuName != "MessageBoxMenu" ;these can be opened over other menus, check them out
        UD_MenuOpened = false
        if UD_LastMenuOpened == MenuName
            UD_LastMenuOpened = "none"
        endif
    elseif UD_LastMenuOpened == "Console" || UD_LastMenuOpened == "MessageBoxMenu" ;only reset state if no other menu was used before
        UD_MenuOpened = false
        UD_LastMenuOpened = "none"
    endif
    
    Int loc_i = 0
    while loc_i < UD_MenuList.length
        if UD_MenuList[loc_i] == MenuName
            UD_MenuListID[loc_i] = false
            return
        endif
        loc_i += 1
    endwhile
EndEvent