Scriptname UD_MenuTextFormatter Extends Quest
{Script to format messages}

Int     Property FontSize = 20                      Auto    Hidden

String  Property TextColorDefault = "#FFFFFF"       Auto    Hidden

Int     Property LinesOnPage = 12                   Auto    Hidden

Int     Property LinesOnHTMLPage = 18               Auto    Hidden   

;===============================================================================
;===============================================================================
;                                    State: Default
;===============================================================================
;===============================================================================

String Function Header(String asHeader, Int aiPlusSize = 4, Bool abHeaderTag = True)
    Return "=== " + asHeader + " ===\n"
EndFunction
    
String Function TableBegin(Int aiLeftMargin, Int aiColumn1Width, Int aiColumn2Width = 0, Int aiColumn3Width = 0, Int aiLeading = -2)
    Return ""
EndFunction

String Function TableEnd()
    Return "\n"
EndFunction

String Function FontBegin(Int aiFontSize = -1, String asFontFace = "")
    Return ""
EndFunction

String Function FontEnd()
    Return ""
EndFunction

String Function TextDecoration(String asText, Int aiFontSize = -1, String asFontFace = "", String asColor = "", String asAlign = "")
    Return asText
EndFunction

String Function TableRowDetails(String asLeft, String asRight, String asColor = "")
    Return asLeft + " " + asRight + "\n"
EndFunction

String Function TableRowWide(String asCell1, String asCell2, String asCell3 = "", String asCell4 = "")
    String loc_res = ""
    loc_res += asCell1
    If asCell2 != ""
        loc_res += " " + asCell2
    EndIf
    If asCell3 != ""
        loc_res += " " + asCell3
    EndIf
    If asCell4 != ""
        loc_res += " " + asCell4
    EndIf
    loc_res += "\n"
    Return loc_res
EndFunction

String Function IsolatedRowDetail(Int aiPos1, String asText1, Int aiPos2, String asText2, String asColor2 = "", Int aiFontSize = -1, Int aiLeading = -99)
    Return asText1 + " " + asText2 + "\n"
EndFunction

String Function LineGap(Int aiLeading = -10)
    Return "\n"
EndFunction

String Function LineBreak()
    Return "\n"
EndFunction

String Function PageSplit(Bool abForce = True)
    If abForce
        Return "\n\n\n\n\n\n\n\n\n\n\n\n"
    Else
        Return ""
    EndIf
EndFunction

String Function HeaderSplit()
    Return ""
EndFunction

String[] Function SplitMessageIntoPages(String asMessage, Int aiLines = -1)
    If aiLines < 0 
        aiLines = LinesOnPage
    EndIf
    
    String loc_txt = asMessage
    String[] loc_lines
    String loc_delim = "\n"
    String[] loc_page_lines
    String loc_page_txt
    String[] loc_res
    
    loc_lines = StringUtil.Split(loc_txt, loc_delim)
    
    Int loc_linesNum = loc_lines.Length
    Int loc_start = 0
    Int loc_i = 1
    Int loc_total = Math.Ceiling((loc_lines.Length as Float) / (aiLines as Float))
        
    While loc_start < loc_lines.Length
        String[] loc_subset = PapyrusUtil.SliceStringArray(loc_lines, loc_start, aiLines)
        String loc_group = ""
        loc_group += PapyrusUtil.StringJoin(loc_subset, loc_delim)
        loc_group += PageFooter(loc_i, loc_total)
        loc_res = PapyrusUtil.PushString(loc_res, loc_group)
        
        loc_start += aiLines
        loc_i += 1
    EndWhile
    
    Return loc_res
    
EndFunction

String Function PageFooter(Int aiPageCurrent, Int aiPageTotal)
    Return "== PAGE " + aiPageCurrent + "/" + aiPageTotal + " =="
EndFunction

String Function DeviceLockIcon(Bool abOpen, Bool abJammed, Bool abTimer)
    If abOpen
        Return "O"
    EndIf
    If abTimer
        Return "T"
    EndIf
    If abJammed
        Return "J"
    EndIf
    Return "C"
EndFunction
    
;===============================================================================
;===============================================================================
;                                    State: HTML
;===============================================================================
;===============================================================================

Auto State HTML

    String Function Header(String asHeader, Int aiPlusSize = 4, Bool abHeaderTag = True)
        String loc_res = ""
        loc_res += TextDecoration(asHeader, FontSize + aiPlusSize, asColor = TextColorDefault, asAlign = "center")
        loc_res += LineBreak()
        If abHeaderTag
            loc_res += HeaderSplit()
        EndIf
        Return loc_res
    EndFunction

    String Function TableBegin(Int aiLeftMargin, Int aiColumn1Width, Int aiColumn2Width = 0, Int aiColumn3Width = 0, Int aiLeading = -2)
        String loc_res = ""
        String loc_tabstops = ""
        Int loc_pos = 0
        loc_pos += aiLeftMargin
        loc_tabstops += loc_pos as String
        If aiColumn1Width > 0
            loc_tabstops += ", "
            loc_pos += aiColumn1Width
            loc_tabstops += loc_pos as String
        EndIf
        If aiColumn2Width > 0
            loc_tabstops += ", "
            loc_pos += aiColumn2Width
            loc_tabstops += loc_pos as String
        EndIf
        If aiColumn3Width > 0
            loc_tabstops += ", "
            loc_pos += aiColumn3Width
            loc_tabstops += loc_pos as String
        EndIf
        
        loc_res += "<textformat tabstops='[" + loc_tabstops + "]' leading='" + (aiLeading As String) + "'>"
        loc_res += "<p align='left'>"
        
        Return loc_res
    EndFunction

    String Function TableEnd()
        String loc_res = ""
        loc_res += "</p>"
        loc_res += "</textformat>"
        loc_res += PageSplit(abForce = False)
        Return loc_res
    EndFunction
    
;/
    map "$ConsoleFont" = "Arial" Normal
    map "$StartMenuFont" = "Futura Condensed" Normal
    map "$DialogueFont" = "Futura CondensedLight" Normal
    map "$EverywhereFont" = "Futura CondensedLight" Normal
    map "$EverywhereBoldFont" = "Futura Condensed" Bold
    map "$EverywhereMediumFont" = "Futura Condensed" Normal
    map "$DragonFont" = "Dragon_script" Normal
    map "$SkyrimBooks" = "SkyrimBooks_Gaelic" Normal
    map "$HandwrittenFont" = "SkyrimBooks_Handwritten_Bold" Normal
    map "$HandwrittenBold" = "SkyrimBooks_Handwritten_Bold" Normal
    map "$FalmerFont" = "Falmer" Normal
    map "$DwemerFont" = "Dwemer" Normal
    map "$DaedricFont" = "Daedric" Normal
    map "$MageScriptFont" = "Mage Script" Normal
    map "$SkyrimSymbolsFont" = "SkyrimSymbols" Normal
    map "$SkyrimBooks_UnreadableFont" = "SkyrimBooks_Unreadable" Normal
/;
    String Function FontBegin(Int aiFontSize = -1, String asFontFace = "")
        String loc_res = "<font "
        If aiFontSize > 0
            loc_res += " size='" + (aiFontSize as String) + "'"
        EndIf
        If asFontFace != ""
            loc_res += " face='" + asFontFace + "'"
        EndIf
        loc_res += ">"
        Return loc_res
    EndFunction

    String Function FontEnd()
        Return "</font>"
    EndFunction

    String Function TextDecoration(String asText, Int aiFontSize = -1, String asFontFace = "", String asColor = "", String asAlign = "")
        String loc_res = ""
        Bool loc_font = aiFontSize > 0 || asColor != "" || asFontFace != ""
        If loc_font
            loc_res += "<font"
            If aiFontSize > 0
                loc_res += " size='" + (aiFontSize as String) + "'"
            EndIf
            If asColor != ""
                loc_res += " color='" + asColor + "'"
            EndIf
            If asFontFace != ""
                loc_res += " face='" + asFontFace + "'"
            EndIf
            loc_res += ">"
        EndIf
        If asAlign != ""
            loc_res += "<span align='" + asAlign + "'>"
        EndIf
        
        loc_res += asText
        
        If asAlign != ""
            loc_res += "</span>"
        EndIf
        
        If loc_font
            loc_res += "</font>"
        EndIf
        
        Return loc_res
    EndFunction

    String Function TableRowDetails(String asLeft, String asRight, String asColor = "")
        String loc_res = ""
;        loc_res += "<span align='left'>"
        loc_res += " \t" + asLeft
        loc_res += " \t"
        If asColor != ""
            loc_res += "<font color='" + asColor + "'>"
        EndIf
        loc_res += asRight
        If asColor != ""
            loc_res += "</font>"
        EndIf
;        loc_res += "</span>"
        loc_res += "<br/>"
        
        Return loc_res
    EndFunction

    String Function TableRowWide(String asCell1, String asCell2, String asCell3 = "", String asCell4 = "")
        String loc_res = ""
        loc_res += "\t" + asCell1
        If asCell2 != ""
            loc_res += "\t" + asCell2
        EndIf
        If asCell2 != ""
            loc_res += "\t" + asCell2
        EndIf
        If asCell3 != ""
            loc_res += "\t" + asCell3
        EndIf
        If asCell4 != ""
            loc_res += "\t" + asCell4
        EndIf
        loc_res += "<br/>"
        Return loc_res
    EndFunction
    
    ; all decorators are isolated inside line so it is possible to split message on pages
    String Function IsolatedRowDetail(Int aiPos1, String asText1, Int aiPos2, String asText2, String asColor2 = "", Int aiFontSize = -1, Int aiLeading = -99)
        String loc_res = ""
        If aiLeading > -99
            loc_res += TableBegin(aiPos1, aiPos1 + aiPos2, aiLeading = aiLeading)
        Else
            loc_res += TableBegin(aiPos1, aiPos1 + aiPos2)
        EndIf
        If aiFontSize > 0
            loc_res += FontBegin(aiFontSize)
        EndIf
        loc_res += "\t" + asText1
        loc_res += "\t" + TextDecoration(asText2, asColor = asColor2)
        If aiFontSize > 0
            loc_res += FontEnd()
        EndIf
        loc_res += TableEnd()
        loc_res += "<br/>"
        
        Return loc_res
    EndFunction

    String Function LineGap(Int aiLeading = -10)
        String loc_res = ""
        loc_res += "<textformat leading='" + (aiLeading as String) + "'>"
        loc_res += "  "                  ; some text is needed otherwise 'leading' will not work
        loc_res += "<br/>"
        loc_res += "</textformat>"
        Return loc_res
    EndFunction

    String Function LineBreak()
        Return "<br/>"
    EndFunction

    String Function HeaderSplit()
        Return "<header/>"
    EndFunction
    
    String Function PageSplit(Bool abForce = True)
        If abForce
            Return "<page/>"
        Else
            Return "<section/>"
        EndIf
    EndFunction
    
    String[] Function SplitMessageIntoPages(String asMessage, Int aiLines = -1)
        If aiLines < 0 
            aiLines = LinesOnHTMLPage
        EndIf
        String loc_txt = asMessage
        String loc_delim_l = "<br/>"
        String loc_delim_p = "<page/>"
        String loc_delim_s = "<section/>"
        String loc_delim_h = "<header/>"
        String loc_page_txt
        String[] loc_res
        String loc_header = ""
        String[] loc_pages
        String[] loc_pages2
        
        Int loc_h_pos = StringUtil.Find(loc_txt, loc_delim_h)
        If loc_h_pos >= 0
            loc_header = StringUtil.Substring(loc_txt, 0, loc_h_pos)
            loc_txt = StringUtil.Substring(loc_txt, loc_h_pos + StringUtil.GetLength(loc_delim_h))
        EndIf
        
        loc_pages = PapyrusUtil.StringSplit(loc_txt, loc_delim_p)
        
        Int loc_i = 0
        Int loc_j = 0
        ; The <page/> tag is used to indicate pagination. So divide the text by this tag first.
        While loc_i < loc_pages.Length
            loc_page_txt = loc_pages[loc_i]
            If StringUtil.GetLength(loc_page_txt) > 5
                loc_pages2 = PapyrusUtil.PushString(loc_pages2, loc_page_txt)
            EndIf
            loc_i += 1
        EndWhile
        
        ; Next, we check each page to make sure it's within the acceptable size. 
        ; Split long pages into smaller pages using the <section/> tag.
        loc_i = 0
        loc_pages = Utility.ResizeStringArray(loc_pages, 0)
        While loc_i < loc_pages2.Length
            String[] loc_sections = PapyrusUtil.StringSplit(loc_pages2[loc_i], loc_delim_s)
            loc_j = 0
            Int loc_page_len = 0        ; the number of line breaks on the page we assemble from sections
            loc_page_txt = ""
            While loc_j < loc_sections.Length
                ; count lines in this section
                Int loc_lines_in_sec = _CountSubstr(loc_sections[loc_j], "<br/>") + _CountSubstr(loc_sections[loc_j], "</p>")
                If loc_page_len + loc_lines_in_sec > aiLines && loc_page_len > 0
                    ; If there are more rows than the limit and it is already a not empty page, we start filling a new page
                    ; But first we save the result of assembling the current page
                    loc_pages = PapyrusUtil.PushString(loc_pages, loc_page_txt)
                    ; clear all vars before assembling new page
                    loc_page_txt = ""
                    loc_page_len = 0
                EndIf
                loc_page_txt += loc_sections[loc_j]
                loc_page_len += loc_lines_in_sec
                loc_j += 1
            EndWhile
            ; append last page
            If loc_page_txt != ""
                loc_pages = PapyrusUtil.PushString(loc_pages, loc_page_txt)
            EndIf
            loc_i += 1
        EndWhile
        
        ; final run over array to add headers and footers
        loc_i = 0
        While loc_i < loc_pages.Length
            loc_page_txt = loc_header
            loc_page_txt += loc_pages2[loc_i]
            If loc_pages.Length > 1
                loc_page_txt += LineBreak() + PageFooter(loc_i + 1, loc_pages.Length)
            EndIf
            loc_res = PapyrusUtil.PushString(loc_res, loc_page_txt)
            loc_i += 1
        EndWhile
        
        Return loc_res
        
    EndFunction

    String Function DeviceLockIcon(Bool abOpen, Bool abJammed, Bool abTimer)
        If abOpen
            Return TextDecoration(StringUtil.AsChar(183), asFontFace = "$EverywhereBoldFont", asColor = "#FFFFFF")
        EndIf
        If abTimer
            Return TextDecoration(StringUtil.AsChar(164), asFontFace = "$EverywhereBoldFont", asColor = "#4444FF")
        EndIf
        If abJammed
            Return TextDecoration(StringUtil.AsChar(164), asFontFace = "$EverywhereBoldFont", asColor = "#FF4444")
        EndIf
        Return TextDecoration(StringUtil.AsChar(164), asFontFace = "$EverywhereBoldFont", asColor = "#FFFFFF")
    EndFunction

EndState

;String Function _DetailImage(String asSrc)
;    Return "<img src='" + asSrc + "' height='32' width='32' />"
;EndFunction

;===============================================================================
;===============================================================================
;                                    Helpers
;===============================================================================
;===============================================================================


String Function PercentToGrayscale(Int aiPercent)
    Return _PercentToColor(aiPercent, 0x444444, 0xAAAAAA, 0xFFFFFF)
EndFunction

String Function PercentToRainbow(Int aiPercent)
    Return _PercentToColor(aiPercent, 0xFF00FF, 0xFFFF00, 0x00FF00)
EndFunction

String Function _PercentToColor(Int aiPercent, Int aiMin, Int aiMiddle, Int aiMax)
    Int loc_value = aiPercent
    If loc_value < 0
        loc_value = 0
    ElseIf loc_value > 100
        loc_value = 100
    EndIf
    Int R
    Int G
    Int B
    If loc_value <= 50
        R  = (Math.LogicalAnd(Math.RightShift(aiMin, 16), 0xFF) * (50 - loc_value) + Math.LogicalAnd(Math.RightShift(aiMiddle, 16), 0xFF) * loc_value) / 50
        G  = (Math.LogicalAnd(Math.RightShift(aiMin, 8), 0xFF) * (50 - loc_value) + Math.LogicalAnd(Math.RightShift(aiMiddle, 8), 0xFF) * loc_value) / 50
        B  = (Math.LogicalAnd(Math.RightShift(aiMin, 0), 0xFF) * (50 - loc_value) + Math.LogicalAnd(Math.RightShift(aiMiddle, 0), 0xFF) * loc_value) / 50
    Else
        R  = (Math.LogicalAnd(Math.RightShift(aiMax, 16), 0xFF) * (loc_value - 50) + Math.LogicalAnd(Math.RightShift(aiMiddle, 16), 0xFF) * (100 - loc_value)) / 50
        G  = (Math.LogicalAnd(Math.RightShift(aiMax, 8), 0xFF) * (loc_value - 50) + Math.LogicalAnd(Math.RightShift(aiMiddle, 8), 0xFF) * (100 - loc_value)) / 50
        B  = (Math.LogicalAnd(Math.RightShift(aiMax, 0), 0xFF) * (loc_value - 50) + Math.LogicalAnd(Math.RightShift(aiMiddle, 0), 0xFF) * (100 - loc_value)) / 50
    EndIf
    Return "#" + _IntToHex(R * 0x10000 + G * 0x100 + B, 6)
EndFunction

; very elegant idea from  https://forums.nexusmods.com/topic/8441118-convert-decimal-formid-to-hexadecimal/?do=findComment&comment=95344608
String Function _IntToHex(Int aiDecimal, Int aiLength = -1)
    Int loc_value = aiDecimal
    String loc_hex = ""
    Int loc_pos = 0

    While (loc_value > 0)
        Int loc_remainder = loc_value % 16
        loc_hex = StringUtil.GetNthChar("0123456789ABCDEF", loc_remainder) + loc_hex
        loc_value /= 16
        loc_pos += 1
    EndWhile
    
    While loc_pos < aiLength
        loc_hex = "0" + loc_hex
        loc_pos += 1
    EndWhile

    Return loc_hex
EndFunction

String[] Function _SplitIntoGroups(String[] aasLines, Int aiGroup, String asDelim, String asHeader = "", String asFooter = "")
    Int loc_i = 0
    Int loc_start = 0
    String[] loc_subset
    String loc_group
    String[] loc_res
    
    While loc_i < aasLines.Length
        loc_subset = PapyrusUtil.SliceStringArray(aasLines, loc_start, aiGroup)
        loc_group = asHeader
        loc_group += PapyrusUtil.StringJoin(loc_subset, asDelim)
        loc_group += asFooter
        loc_res = PapyrusUtil.PushString(loc_res, loc_group)
        
        loc_start += aiGroup
        loc_i += 1
    EndWhile
    
    Return loc_res
EndFunction 

Int Function _CountSubstr(String asStr, String asSubstr)
    Int loc_start = 0
    Int loc_res = 0
    Int loc_delta = StringUtil.GetLength(asSubstr)
    Int loc_len = StringUtil.GetLength(asStr)
    While loc_start >= 0 && loc_start < loc_len
        loc_start = StringUtil.Find(asStr, asSubstr, loc_start)
        If loc_start >= 0
            loc_res += 1
            loc_start += loc_delta
        EndIf
    EndWhile
    Return loc_res
EndFunction
