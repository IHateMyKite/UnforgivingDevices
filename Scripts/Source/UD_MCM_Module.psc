Scriptname UD_MCM_Module extends UD_ModuleBase

import UnforgivingDevicesMain

UD_MCM_script  Property MCM
  UD_MCM_script Function get()
    return (self as Quest) as UD_MCM_script
  EndFunction
EndProperty

Event OnSetup()
    MCM.Init()
EndEvent

Function OnGameReload()
    MCM.Update()
EndFunction

Alias[] Function GetSortedPages()
    Alias[] loc_pages = UD_Native.GetModulesAliasesByScript("ud_mcm_pagestorage")
    if loc_pages && loc_pages.length > 0
        ; Sort by priority to prevent pages jumping around
        Int loc_indx1 = 0
        while loc_indx1 < loc_pages.length
            Int loc_indx2 = loc_indx1
            Int loc_indx3 = loc_indx1
            UD_MCM_Page loc_page1 = loc_pages[loc_indx1] as UD_MCM_Page
            ; Get highest priority page
            while loc_indx2 < loc_pages.length
                UD_MCM_Page loc_page2 = loc_pages[loc_indx2] as UD_MCM_Page
                if loc_page2.PagePriority > loc_page1.PagePriority
                    loc_page1 = loc_page2
                    loc_indx3 = loc_indx2
                endif
                loc_indx2 += 1
            endwhile
            UD_MCM_Page loc_page3 = loc_pages[loc_indx1] as UD_MCM_Page
            loc_pages[loc_indx1] = loc_page1 as Alias
            loc_pages[loc_indx3] = loc_page3 as Alias
            loc_indx1 += 1
        endwhile
    else
        UDMain.Error("No MCM pages found!")
    endif
    return loc_pages
EndFunction

String[] Function GetPagesNames()
    Alias[] loc_pages = GetSortedPages()
    String[] loc_res = Utility.CreateStringArray(loc_pages.length)
    
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        loc_res[loc_indx] = (loc_pages[loc_indx] as UD_MCM_Page).PageName
        loc_indx += 1
    endwhile
    return loc_res
EndFunction

Function InitPages()
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        (loc_pages[loc_indx] as UD_MCM_Page).PageInit()
        loc_indx += 1
    endwhile
EndFunction

Function UpdatePages()
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        (loc_pages[loc_indx] as UD_MCM_Page).PageUpdate()
        loc_indx += 1
    endwhile
EndFunction

Function ResetPages(String asPage, Bool abLockMenu)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageReset(abLockMenu)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction

Function OptionSelect(String asPage, Int aiOption)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageOptionSelect(aiOption)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction

Function OptionSliderOpen(String asPage, Int aiOption)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageOptionSliderOpen(aiOption)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction
Function OptionSliderAccept(String asPage, Int aiOption, Float afValue)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageOptionSliderAccept(aiOption,afValue)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction

Function OptionKeyMapChange(String asPage, Int aiOption, Int aiKeyCode, String asConflictControl, String asConflictName)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageOptionKeyMapChange(aiOption,aiKeyCode,asConflictControl,asConflictName)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction

Function OptionInputOpen(String asPage, Int aiOption)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageOptionInputOpen(aiOption)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction
Function OptionInputAccept(String asPage, Int aiOption, String asValue)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageOptionInputAccept(aiOption,asValue)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction

Function OptionMenuOpen(String asPage, Int aiOption)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageOptionMenuOpen(aiOption)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction
Function OptionMenuAccept(String asPage, Int aiOption, int aiIndex)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageOptionMenuAccept(aiOption,aiIndex)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction

Function PageDefault(String asPage, Int aiOption)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageDefault(aiOption)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction
Function PageInfo(String asPage, Int aiOption)
    Alias[] loc_pages = GetSortedPages()
    Int loc_indx = 0
    while loc_indx < loc_pages.length
        UD_MCM_Page loc_page = (loc_pages[loc_indx] as UD_MCM_Page)
        if loc_page.PageName == asPage
            loc_page.PageInfo(aiOption)
            return
        endif
        loc_indx += 1
    endwhile
EndFunction