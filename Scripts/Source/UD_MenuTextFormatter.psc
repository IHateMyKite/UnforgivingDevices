Scriptname UD_MenuTextFormatter Extends Quest
{Script with functions to format text for messages}

;/
The script is intentionally written without external dependencies except for standard libraries. 
Therefore, there may be repetitions of some trivial methods already implemented elsewhere.
/;

;/  Group: Config
===========================================================================================
===========================================================================================
===========================================================================================
/; 

;/  Variable: FontSize
    Default font size
    
    Used in HTML mode only
/;
Int     Property FontSize = 20                      Auto    Hidden

;/  Variable: TextColorDefault
    Default text color
    
    Used in HTML mode only
/;
String  Property TextColorDefault = "#FFFFFF"       Auto    Hidden

;/  Variable: LinesOnPage
    The number of lines on one page. If there are more, the text will be divided into several page
    
    Used in Legacy mode only
/;
Int     Property LinesOnPage = 12                   Auto    Hidden

;/  Variable: LinesOnHTMLPage
    The number of lines on one page. If there are more, the text will be divided into several page
    
    Used in HTML mode only
/;
Int     Property LinesOnHTMLPage = 16               Auto    Hidden

;/  Variable: CharsOnPage
    Maximum number of characters per page. If there are more, the text will be divided into several page
    
    Used in all modes
/;
Int     Property CharsOnPage = 1900                 Auto    Hidden

;/  Variable: CharsCTD
    A hard limit on the number of characters in a single window. 
    If there are more characters than this, the text will be skipped to avoid CTD

    Used in all modes
/;
Int     Property CharsCTD = 2047                    Auto    Hidden

;/  Group: Mode Control
===========================================================================================
===========================================================================================
===========================================================================================
/;

String[] _Modes

;/  Function: GetModes

    The function returns all possible modes of the formatter as an array of strings
    
    Returns:
        Array of strings with possible modes
/;
String[] Function GetModes()
    If _Modes.Length == 0
        _Modes = Utility.CreateStringArray(2)
        _Modes[0] = "Legacy"
        _Modes[1] = "HTML"
    EndIf
    Return _Modes
EndFunction

;/  Function: SetMode

    The function sets new operation mode for the formatter
    
    Parameters:
        abMode                   - New operation mode
/;
Function SetMode(String abMode)
    If abMode == "Legacy"
        abMode = ""
    EndIf
    GoToState(abMode)
EndFunction

;/  Function: GetMode

    The function returns current operation mode of the formatter
    
    Returns:
        Operation mode
/;
String Function GetMode()
    If GetState() == ""
        Return "Legacy"
    EndIf
    Return GetState()
EndFunction

;/  Function: GetModeIndex

    The function returns index of the current operation mode
    
    Returns:
        Operation mode index
/;
Int Function GetModeIndex()
    If GetState() == ""
        Return 0
    EndIf
    Return GetModes().Find(GetState())
EndFunction

;/  Function: HasHtmlMarkup

    Returns true if the formatted text contains HTML markup
    
    Returns:
        True for HTML
/;
Bool Function HasHtmlMarkup()
    Return GetState() == "HTML"
EndFunction

;/  Group: Text Formatting
===========================================================================================
===========================================================================================
===========================================================================================
/; 

;/  Function: Header

    Returns formatted header
    
    Parameters:
        asHeader                - Header content
        aiFontSize              - Font size. If -1 then it doesn't change
    
    Returns:
        String with the text fragment
/;
String Function Header(String asHeader, Int aiFontSize = -1)
    Return "=== " + asHeader + " ===" + LineBreak()
EndFunction

;/  Function: TableBegin

    Returns the beginning of the table customized by the specified parameters
    
    Parameters:
        aiLeftMargin            - Indentation on the left. Not always respected, because the automatic window width 
                                  calculation in SWF does not always handle our improvised tables correctly.
        aiColumn1Width          - Width of the first column
        aiColumn2Width          - Width of the second column
        aiColumn3Width          - Width of the third column
        aiColumn4Width          - Width of the fourth column
        aiLeading               - Spacing between lines
    
    Returns:
        String with the text fragment
/;
String Function TableBegin(Int aiLeftMargin, Int aiColumn1Width, Int aiColumn2Width = 0, Int aiColumn3Width = 0, Int aiColumn4Width = 0, Int aiLeading = -2)
    Return ""
EndFunction

;/  Function: TableEnd

    Returns closing table tags
    
    Returns:
        String with the text fragment
/;
String Function TableEnd()
    Return ""
EndFunction

;/  Function: FontBegin

    Opening tag for the text with customized font
    
    Parameters:
        aiFontSize              - Font size. If no value is specified, the size does not change.
        asFontFace              - Font name. If no value is specified, the font face does not change.
        asColor                 - Color hex code. If no value is specified, the font color does not change.
        
    Returns:
        String with the text fragment
/;
String Function FontBegin(Int aiFontSize = -1, String asFontFace = "", String asColor = "")
    Return ""
EndFunction

;/  Function: FontEnd

    Returns closing font tag
    
    Returns:
        String with the text fragment
/;
String Function FontEnd()
    Return ""
EndFunction

;/  Function: ParagraphBegin

    Opening tag for the text in customized paragraph
    
    Parameters:
        asAlign                 - Horizontal text alignment (left, center, right). If no value is specified, the alignment does not change.
        aiLeading               - Spacing between lines. If no value is specified, the spacing does not change. 
        
    Returns:
        String with the text fragment
/;
String Function ParagraphBegin(String asAlign = "", Int aiLeading = -99)
    Return ""
EndFunction

;/  Function: ParagraphEnd

    Returns closing paragraph tag. It has a line break at the end!

    Returns:
        String with the text fragment
/;
String Function ParagraphEnd()
    Return LineBreak()
EndFunction

;/  Function: Paragraph

    Returns text decorated with specified modifiers as a separate paragraph (with line break at the end)
    
    Parameters:
        asText                  - Text to print.
        aiFontSize              - Font size. If no value is specified, the size does not change.
        asFontFace              - Font name. If no value is specified, the font face does not change.
        asColor                 - Color hex code. If no value is specified, the font color does not change.
        asAlign                 - Horizontal text alignment (left, center, right). If no value is specified, the alignment does not change.
        aiLeading               - Spacing between lines. If no value is specified, the spacing does not change. 
    
    Returns:
        String with the text fragment
/;
String Function Paragraph(String asText, Int aiFontSize = -1, String asFontFace = "", String asColor = "", String asAlign = "", Int aiLeading = -99)
    String loc_res = ""
    loc_res += ParagraphBegin(asAlign, aiLeading)
    loc_res += Text(asText, aiFontSize, asFontFace, asColor)
    loc_res += ParagraphEnd()
    Return loc_res
EndFunction

;/  Function: Text

    Returns text decorated with specified modifiers
    
    Parameters:
        asText                  - Text to print.
        aiFontSize              - Font size. If no value is specified, the size does not change.
        asFontFace              - Font name. If no value is specified, the font face does not change.
        asColor                 - Color hex code. If no value is specified, the font color does not change.
    
    Returns:
        String with the text fragment
/;
String Function Text(String asText, Int aiFontSize = -1, String asFontFace = "", String asColor = "")
    String loc_res = ""
    loc_res += InlineIfString(asColor != "" || asFontFace != "", StringUtil.AsChar(171)) ; StringUtil.AsChar(171))
    loc_res += asText
    loc_res += InlineIfString(asColor != "" || asFontFace != "", StringUtil.AsChar(187)) ; StringUtil.AsChar(187))
    Return loc_res
EndFunction

;/  Function: TableRowDetails

    Returns a single row with two columns for the improvised table
    
    Parameters:
        asLeft                  - Text in the first (left) column.
        asRight                 - Text in the second (right) column.
        asColor                 - Color of the text in the second column. If no value is specified, the font color does not change.
    
    Returns:
        String with the text fragment
/;
String Function TableRowDetails(String asLeft, String asRight, String asColor = "")
    Return asLeft + " " + asRight + LineBreak()
EndFunction

;/  Function: TableRowWide

    Returns a single row with up to four columns for the improvised table
    
    Parameters:
        asCell1                 - Text in the first column.
        asCell2                 - Text in the second column.
        asCell3                 - Text in the third column.
        asCell4                 - Text in the fourth column.
        asCell5                 - Text in the fifth column.
    
    Returns:
        String with the text fragment
/;
String Function TableRowWide(String asCell1, String asCell2, String asCell3 = "", String asCell4 = "", String asCell5 = "")
    String loc_res = ""
    loc_res += asCell1
    loc_res += InlineIfString(asCell2 != "", asCell2)
    loc_res += InlineIfString(asCell3 != "", asCell3)
    loc_res += InlineIfString(asCell4 != "", asCell4)
    loc_res += InlineIfString(asCell5 != "", asCell5)
    loc_res += LineBreak()
    Return loc_res
EndFunction

;/  Function: LineGap

    Returns the formatted text for displaying the narrow space between sections
    
    Returns:
        String with the text fragment
/;
String Function LineGap()
    Return "\n"
EndFunction

;/  Function: LineBreak

    Returns a line break
    
    Returns:
        String with the text fragment
/;
String Function LineBreak()
    Return "\n"
EndFunction

;/  Function: PageSplit

    Returns a page break
    
    Parameters:
        abForce                 - If true, the page break will be used when rendering message. 
                                  Otherwise, the it will be used only if necessary.

    Returns:
        String with the text fragment
/;
String Function PageSplit(Bool abForce = True)
    If abForce
        Return "\n\n\n\n\n\n\n\n\n\n\n\n"
    Else
        Return ""
    EndIf
EndFunction

;/  Function: HeaderSplit

    Marking the boundary of the message header. The header will be repeated on each page of the 
    message when displayed on multiple pages

    Returns:
        String with the text fragment
/;
String Function HeaderSplit()
    Return ""
EndFunction

;/  Function: FooterSplit

    Marking the boundary of the message footer. The footer will be repeated on each page of the 
    message when displayed on multiple pages

    Returns:
        String with the text fragment
/;
String Function FooterSplit()
    Return ""
EndFunction

;/  Function: AddTag

    Helper function for wrapping text in an arbitrary tag

    Returns:
        String with the text fragment
/;
String Function AddTag(String asTag, String asInner = "")
    Return asInner
EndFunction

;/  Function: SplitMessageIntoPages

    Function for dividing long message text into pages. This is also where you clean up the text, 
    substitute replacements, add a header and footer
    
    Parameters:
        asMessage                   - Message text
        aiLines                     - Number of lines per page. If no value is specified, the default value used 
                                      (see <LinesOnPage> and <LinesOnHTMLPage>)

    Returns:
        String array with pages
/;
String[] Function SplitMessageIntoPages(String asMessage, Int aiLines = -1)
    If aiLines < 0 
        aiLines = LinesOnPage
    EndIf
    
    String loc_txt = asMessage
    String[] loc_lines
    String loc_delim = "\n"
    String[] loc_page_lines
    String loc_page_txt
    String[] loc_pages
    String[] loc_res
    
    loc_lines = PapyrusUtil.StringSplit(loc_txt, loc_delim)
    
    Int loc_line_start = 0       
    While loc_line_start < loc_lines.Length
        String[] loc_subset = PapyrusUtil.SliceStringArray(loc_lines, loc_line_start, loc_line_start + aiLines)
        loc_page_txt = PapyrusUtil.StringJoin(loc_subset, loc_delim)
        loc_page_txt = _CleanPage(loc_page_txt)
        If StringUtil.GetLength(loc_page_txt) > CharsCTD
        ; last check
            loc_page_txt = "\nThe page is too large to output (attempting to do so will result in CTD)! Split it into several parts.\n"
        ElseIf StringUtil.GetLength(loc_page_txt) > 0
            loc_pages = PapyrusUtil.PushString(loc_pages, loc_page_txt)
        EndIf
        loc_line_start += aiLines
    EndWhile
    
    Int loc_i = 0
    While loc_i < loc_pages.Length
        loc_page_txt = loc_pages[loc_i]
        If loc_pages.Length > 1
            loc_page_txt += LineBreak() + PageFooter(loc_i + 1, loc_pages.Length)
        EndIf
        loc_res = PapyrusUtil.PushString(loc_res, loc_page_txt)
        loc_i += 1
    EndWhile
    
    Return loc_res
    
EndFunction

;/  Function: PageFooter

    Adds a footer with page number
    
    Parameters:
        aiPageCurrent                       - Current page number
        aiPageTotal                         - Total number of pages

    Returns:
        String with the text fragment
/;
String Function PageFooter(Int aiPageCurrent, Int aiPageTotal)
    Return "== Page " + aiPageCurrent + "/" + aiPageTotal + " =="
EndFunction

;/  Function: DeviceLockIcon

    Returns an improvised device lock indicator (icon)
    
    Parameters:
        abOpen                              - The lock is open
        abJammed                            - The lock is jammed
        abTimer                             - The lock has timer

    Returns:
        String with the text fragment
/;
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
    Return "L"
EndFunction

;/  Function: DeviceLockLegend

    Returns a legend for our improvised device lock indicators (icons)
    
    Returns:
        String with the text fragment
/;
String Function DeviceLockLegend()
    String loc_res = ""
    
    loc_res += "L - locked;"
    loc_res += LineBreak()
    loc_res += "O - unlocked (open);"
    loc_res += LineBreak()
    loc_res += "T - with timer;"
    loc_res += LineBreak()
    loc_res += "J - jammed."
    
    Return loc_res
EndFunction

;/  Function: _CleanPage

    Final page cleanup
    
    Parameters:
        asPage                              - Page text
    
    Returns:
        String with the page text
/;
String Function _CleanPage(String asPage)
    String loc_res = asPage
    loc_res = TrimSubstr(loc_res, "\n")
    loc_res = TrimSubstr(loc_res, " ")
    Return loc_res
EndFunction

Auto State HTML

    String Function Header(String asHeader, Int aiFontSize = -1)
        Int loc_pad_len = Math.Ceiling((30 - StringUtil.GetLength(asHeader)) / 10)
        If loc_pad_len < 0
            loc_pad_len = 0
        EndIf
        String loc_pad = PapyrusUtil.StringJoin(Utility.CreateStringArray(loc_pad_len + 1, "0"), "")
        String loc_res = ""
        loc_res += ParagraphBegin(asAlign = "center")
        loc_res += FontBegin(aiFontSize, "$SkyrimSymbolsFont")
        loc_res += "6" + loc_pad
        loc_res += Text(" " + asHeader + " ", asFontFace = "$EverywhereMediumFont")
        loc_res += loc_pad + "7"
        loc_res += FontEnd()
        loc_res += ParagraphEnd()
        Return loc_res
    EndFunction

    ; Best looking presets for Details menus:
    ; Papyrus_UI: aiLeftMargin = 30, aiColumn1Width = 140
    ; Native_IU:  aiLeftMargin = 50, aiColumn1Width = 160
    String Function TableBegin(Int aiLeftMargin, Int aiColumn1Width, Int aiColumn2Width = 0, Int aiColumn3Width = 0, Int aiColumn4Width = 0, Int aiLeading = -2)
        String loc_res = ""
        String loc_tabstops = ""
        Int loc_pos = 0
        loc_pos += aiLeftMargin
        loc_tabstops += loc_pos as String
        loc_tabstops += ", "
        loc_pos += aiColumn1Width
        loc_tabstops += loc_pos as String
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
        If aiColumn4Width > 0
            loc_tabstops += ", "
            loc_pos += aiColumn4Width
            loc_tabstops += loc_pos as String
        EndIf
        
        loc_res += "<p align='left'>"
        loc_res += "<textformat tabstops='[" + loc_tabstops + "]' leading='" + (aiLeading As String) + "'>"
        
        Return loc_res
    EndFunction

    String Function TableEnd()
        String loc_res = ""
        loc_res += "</textformat>"
        loc_res += "</p>"
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
    String Function FontBegin(Int aiFontSize = -1, String asFontFace = "", String asColor = "")
        Bool loc_font = aiFontSize > 0 || asColor != "" || asFontFace != ""
        If !loc_font
            Return ""
        EndIf
        String loc_res = ""
        loc_res += "<font"
        loc_res += InlineIfString(aiFontSize > 0, " size='" + (aiFontSize as String) + "'")
        loc_res += InlineIfString(asFontFace != "", " face='" + asFontFace + "'")
        loc_res += InlineIfString(asColor != "", " color='" + asColor + "'")
        loc_res += ">"
        Return loc_res
    EndFunction

    String Function FontEnd()
        Return "</font>"
    EndFunction
    
    String Function ParagraphBegin(String asAlign = "", Int aiLeading = -99)
        String loc_res = ""
        loc_res += "<p" + InlineIfString(asAlign != "", " align='" + asAlign + "'") + ">"
        loc_res += "<textformat" + InlineIfString(aiLeading > -99, " leading='" + (aiLeading as String) + "'") + ">"
        Return loc_res
    EndFunction
    
    String Function ParagraphEnd()
        String loc_res = ""
        loc_res += "</textformat>"
        loc_res += "</p>"
        Return loc_res
    EndFunction

    String Function Text(String asText, Int aiFontSize = -1, String asFontFace = "", String asColor = "")
        String loc_res = ""
        Bool loc_font = aiFontSize > 0 || asColor != "" || asFontFace != ""
        If loc_font
            loc_res += FontBegin(aiFontSize = aiFontSize, asFontFace = asFontFace, asColor = asColor)
        EndIf
        loc_res += asText
        If loc_font
            loc_res += FontEnd()
        EndIf
        Return loc_res
    EndFunction

    String Function TableRowDetails(String asLeft, String asRight, String asColor = "")
        String loc_res = ""
        loc_res += "\t" + asLeft
        loc_res += "\t"
        loc_res += Text(asRight, asColor = asColor)
        loc_res += LineBreak()
        Return loc_res
    EndFunction

    String Function TableRowWide(String asCell1, String asCell2, String asCell3 = "", String asCell4 = "", String asCell5 = "")
        String loc_res = ""
        loc_res += "\t" + asCell1
        loc_res += InlineIfString(asCell2 != "", "\t" + asCell2)
        loc_res += InlineIfString(asCell3 != "", "\t" + asCell3)
        loc_res += InlineIfString(asCell4 != "", "\t" + asCell4)
        loc_res += InlineIfString(asCell5 != "", "\t" + asCell5)
        loc_res += LineBreak()
        Return loc_res
    EndFunction

    String Function LineGap()
    ; On postprocessing it will be replaced with narrow line
        Return "<gap/>"
    EndFunction

    String Function LineBreak()
        Return "<br/>"
    EndFunction

    String Function HeaderSplit()
    ; <g/> is a fake tag used to protect starting whitespace characters (such as \t) from the PapyrusUtil.StringSplit function.
        Return "<header/><g/>"
    EndFunction
    
    String Function FooterSplit()
        Return "<footer/>"
    EndFunction
    
    String Function PageSplit(Bool abForce = True)
    ; <g/> is a fake tag used to protect starting whitespace characters (such as \t) from the PapyrusUtil.StringSplit function.
        If abForce
            Return "<page/><g/>"
        Else
            Return "<section/><g/>"
        EndIf
    EndFunction

    String Function AddTag(String asTag, String asInner = "")
        If asInner != ""
            Return "<" + asTag + ">" + asInner + "</" + asTag + ">"
        Else
            Return "<" + asTag + "/>"
        EndIf
    EndFunction
    
    String[] Function SplitMessageIntoPages(String asMessage, Int aiLines = -1)
        If aiLines < 0 
            aiLines = LinesOnHTMLPage
        EndIf
        String loc_txt = asMessage
        String loc_delim_l = "<br/>"
        String loc_delim_g = "<g/>"
        String loc_delim_p = "<page/>"
        String loc_delim_s = "<section/>"
        String loc_delim_h = "<header/>"
        String loc_delim_f = "<footer/>"
        String loc_page_txt
        Int loc_pos
        String[] loc_res
        String loc_header = ""
        String loc_footer = ""
        String[] loc_pages
        String[] loc_pages2
        
        ; for compatibility with plain text
        loc_txt = ReplaceSubstr(loc_txt, "\n", "<br/>")
        
        ; extract and save header
        loc_pos = StringUtil.Find(loc_txt, loc_delim_h)
        If loc_pos >= 0
            loc_header = StringUtil.Substring(loc_txt, 0, loc_pos)
            loc_txt = StringUtil.Substring(loc_txt, loc_pos + StringUtil.GetLength(loc_delim_h))
        EndIf
        ; extract and save footer
        loc_pos = StringUtil.Find(loc_txt, loc_delim_f)
        If loc_pos >= 0
            loc_footer = StringUtil.Substring(loc_txt, loc_pos + StringUtil.GetLength(loc_delim_f))
            loc_txt = StringUtil.Substring(loc_txt, 0, loc_pos)
        EndIf
        
        Int loc_chars_limit = CharsOnPage - StringUtil.GetLength(loc_header) - StringUtil.GetLength(loc_footer)

        Int loc_i = 0
        Int loc_j = 0
        ; The <page/> tag is used to indicate pagination. So divide the message by this tag first.
        loc_pages2 = PapyrusUtil.StringSplit(loc_txt, loc_delim_p)
        
        ; Next, we check each page to make sure it's within the acceptable size. 
        ; Split long pages into smaller pages using the <section/> tag.
        loc_i = 0
        loc_pages = Utility.ResizeStringArray(loc_pages, 0)
        While loc_i < loc_pages2.Length
            String[] loc_sections = PapyrusUtil.StringSplit(loc_pages2[loc_i], loc_delim_s)
            loc_j = 0
            Int loc_page_len = 0        ; the number of line breaks on the assembled page
            Int loc_chars = 0           ; the number of chars on the assembled page
            loc_page_txt = ""
            While loc_j < loc_sections.Length
                ; count lines in this section
                Int loc_gaps = CountSubstr(loc_sections[loc_j], "<gap/>")
                Int loc_br = CountSubstr(loc_sections[loc_j], "<br/>")
                Int loc_lines_in_sec = CountSubstr(loc_sections[loc_j], "</p>") + loc_gaps / 2 + loc_br + 1
                Int loc_chars_in_sec = StringUtil.GetLength(loc_sections[loc_j]) + loc_gaps * 24 - loc_br * 4
                If loc_page_len > loc_chars_limit
                ; there is no way we could print message this large!
                    loc_pages = PapyrusUtil.PushString(loc_pages, "<br/>The section is too large to output (attempting to do so will result in CTD)! Split it into several parts.<br/>")
                    ; clear all vars before assembling new page
                    loc_page_txt = ""
                    loc_page_len = 0
                    loc_chars = 0
                EndIf
                If (loc_chars + loc_chars_in_sec > loc_chars_limit || loc_page_len + loc_lines_in_sec > aiLines) && loc_page_len > 0
                    ; If there are more rows than the limit and it is already a not empty page, we start filling a new page
                    ; But first we save the result of assembling the current page
                    loc_page_txt = _CleanPage(loc_page_txt)
                    If StringUtil.GetLength(loc_page_txt) > 0
                        loc_pages = PapyrusUtil.PushString(loc_pages, loc_page_txt)
                    EndIf
                    ; clear all vars before assembling new page
                    loc_page_txt = ""
                    loc_page_len = 0
                    loc_chars = 0
                EndIf
                loc_page_txt += loc_sections[loc_j]
                loc_page_len += loc_lines_in_sec
                loc_chars += loc_chars_in_sec
                loc_j += 1
            EndWhile
            ; append last page
            If loc_page_len > 0
                loc_page_txt = _CleanPage(loc_page_txt)
                If loc_page_len > loc_chars_limit
                ; there is no way we could print message this large!
                    loc_page_txt = StringUtil.Substring(loc_page_txt, 0, loc_chars_limit - 20) + " [text is too long]"
                EndIf
                If StringUtil.GetLength(loc_page_txt) > 0
                    loc_pages = PapyrusUtil.PushString(loc_pages, loc_page_txt)
                EndIf
            EndIf
            loc_i += 1
        EndWhile
        
        ; final run over array to add headers and footers
        loc_i = 0
        While loc_i < loc_pages.Length
            loc_page_txt = loc_pages[loc_i]
            loc_page_txt = loc_header + loc_page_txt + loc_footer
            If loc_pages.Length > 1
                loc_page_txt += PageFooter(loc_i + 1, loc_pages.Length)
            EndIf
            If StringUtil.GetLength(loc_page_txt) > CharsCTD
            ; last check
                loc_page_txt = "<br/>The page is too large to output (attempting to do so will result in CTD)! Split it into several parts.<br/>"
            EndIf
            loc_res = PapyrusUtil.PushString(loc_res, loc_page_txt)
            loc_i += 1
        EndWhile

        Return loc_res
    EndFunction

    String Function PageFooter(Int aiPageCurrent, Int aiPageTotal)
        String loc_res = ""
        loc_res += FontBegin(asFontFace = "$SkyrimSymbolsFont")
        loc_res += "6000"
        loc_res += Text(" Page " + aiPageCurrent + "/" + aiPageTotal + " ", asFontFace = "$EverywhereMediumFont")
        loc_res += "0007"
        loc_res += FontEnd()
        Return loc_res
    EndFunction

    String Function DeviceLockIcon(Bool abOpen, Bool abJammed, Bool abTimer)
    ; for better visual it should be used with $EverywhereBoldFont font
        If abOpen
            Return Text(StringUtil.AsChar(183), asColor = "#FFFFFF")
        EndIf
        If abTimer
            Return Text(StringUtil.AsChar(164), asColor = "#4444FF")
        EndIf
        If abJammed
            Return Text(StringUtil.AsChar(164), asColor = "#FF4444")
        EndIf
        Return Text(StringUtil.AsChar(164), asColor = "#FFFFFF")
    EndFunction

    String Function DeviceLockLegend()
        String loc_res = ""
        loc_res += ParagraphBegin(aiLeading = -3)
        loc_res += Text(StringUtil.AsChar(164), asColor = "#FFFFFF") + " - locked;"
        loc_res += LineBreak()
        loc_res += Text(StringUtil.AsChar(183), asColor = "#FFFFFF") + " - unlocked;"
        loc_res += LineBreak()
        loc_res += Text(StringUtil.AsChar(164), asColor = "#4444FF") + " - with timer;"
        loc_res += LineBreak()
        loc_res += Text(StringUtil.AsChar(164), asColor = "#FF4444") + " - jammed."
        loc_res += ParagraphEnd()
        
        Return loc_res
    EndFunction

    String Function _CleanPage(String asPage)
        Debug.Trace(Self + "::_CleanPage() Before: begining = " + StringUtil.Substring(asPage, 0, 150))
        Debug.Trace(Self + "::_CleanPage() Before:   ending = " + StringUtil.Substring(asPage, StringUtil.GetLength(asPage) - 150))
        String loc_res = asPage
        loc_res = RemoveSubstr(loc_res, "<g/>")
        loc_res = TrimSubstr(loc_res, "<br/>")
        loc_res = TrimSubstr(loc_res, " ")
        loc_res = TrimSubstr(loc_res, LineGap())
        loc_res = RemoveDuplicates(loc_res, LineGap())
        loc_res = ReplaceSubstr(loc_res, "<br/><p", "<p")
        loc_res = ReplaceSubstr(loc_res, "<br/></p>", "</p>")
        loc_res = ReplaceSubstr(loc_res, "<br/></textformat></p>", "</textformat></p>")
        loc_res = ReplaceSubstr(loc_res, "<gap/>", "<font size='12'> <br/></font>") ;"<textformat leading='-10'> <br/></textformat>"
;        loc_res = ReplaceSubstr(loc_res, "<br/>", "\n")
        Debug.Trace(Self + "::_CleanPage() After: begining = " + StringUtil.Substring(loc_res, 0, 150))
        Debug.Trace(Self + "::_CleanPage() After:   ending = " + StringUtil.Substring(loc_res, StringUtil.GetLength(loc_res) - 150))
        Return loc_res
    EndFunction
    
EndState

;String Function _DetailImage(String asSrc)
;    Return "<img src='" + asSrc + "' height='32' width='32' />"
;EndFunction

;/  Group: Helpers
===========================================================================================
===========================================================================================
===========================================================================================
/; 

;/  Function: PercentToGrayscale

    Turns the percentage into a color code on the gray scale.
    0 corresponds to dark gray color
    100 corresponds to white color
    
    Parameters:
        aiPercent                       - Percent value

    Returns:
        Hexadecimal color code in CSS format with leading '#'
/;
String Function PercentToGrayscale(Int aiPercent)
    Return _PercentToColor(aiPercent, 0x444444, 0xAAAAAA, 0xFFFFFF)
EndFunction

;/  Function: PercentToRainbow

    Turns the percentage into a color code on a "rainbow".
    0 corresponds to purple color
    50 corresponds to yellow color
    100 corresponds to green color
    
    Parameters:
        aiPercent                       - Percent value

    Returns:
        Hexadecimal color code in CSS format with leading '#'
/;
String Function PercentToRainbow(Int aiPercent)
    Return _PercentToColor(aiPercent, 0xFF00FF, 0xFFFF00, 0x00FF00)
EndFunction

;/  Function: BoolToGrayscale

    Turns the boolean into a color code on the gray scale.
    False corresponds to dark gray color
    True corresponds to white color
    
    Parameters:
        abValue                         - Boolean value

    Returns:
        Hexadecimal color code in CSS format with leading '#'
/;
String Function BoolToGrayscale(Bool abValue)
    If abValue 
        Return PercentToGrayscale(100)
    Else
        Return PercentToGrayscale(0)
    EndIf
EndFunction

;/  Function: BoolToRainbow

    Turns the boolean into a color code on the 'rainbow'.
    False corresponds to magenta
    True corresponds to green
    
    Parameters:
        abValue                         - Boolean value

    Returns:
        Hexadecimal color code in CSS format with leading '#'
/;
String Function BoolToRainbow(Bool abValue)
    If abValue 
        Return PercentToRainbow(100)
    Else
        Return PercentToRainbow(0)
    EndIf
EndFunction

String Function StringHashToColor(String asStr)
    Int loc_n = StringUtil.GetLength(asStr)
    Int loc_i = 0
    Int loc_c
    Int loc_hash = 0x444444
    While loc_i < loc_n
        loc_c = StringUtil.AsOrd(StringUtil.GetNthChar(asStr, loc_i))
        loc_hash += ((loc_c * (loc_c + 11)) % 0x100) * (Math.Pow(0x100, loc_i % 3) as Int)
        loc_hash %= 0x1000000
        loc_i += 1
    EndWhile
    Return "#" + _IntToHex(loc_hash)
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

;/  Function: CountSubstr

    Counts the number of encountered substrings within a given string
    
    Parameters:
        asStr                         - Given string
        asSubstr                      - Substring

    Returns:
        Number of encountered substrings
/;
Int Function CountSubstr(String asStr, String asSubstr)
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

;/  Function: TrimSubstr

    Removes substrings from the beginning and end of the specified string
    
    Parameters:
        asStr                         - Given string
        asSubstr                      - Substring
        abBegining                    - Check the begining
        abEnding                      - Check the end

    Returns:
        The resulting string
/;
String Function TrimSubstr(String asStr, String asSubstr, Bool abBegining = True, Bool abEnding = True)
    String loc_res = asStr
    Int loc_delta = StringUtil.GetLength(asSubstr)
    Int loc_pos
    If abBegining
        loc_pos = 0
        While loc_pos == 0
            loc_pos = StringUtil.Find(loc_res, asSubstr)
            If loc_pos == 0
                loc_res = StringUtil.Substring(loc_res, loc_delta)
            EndIf
        EndWhile
    EndIf
    If abEnding
        loc_pos = 0
        While loc_pos >= 0
            loc_pos = StringUtil.Find(loc_res, asSubstr, StringUtil.GetLength(loc_res) - loc_delta)
            If loc_pos >= 0
                loc_res = StringUtil.Substring(loc_res, 0, StringUtil.GetLength(loc_res) - loc_delta)
            EndIf
        EndWhile
    EndIf    
    Return loc_res
EndFunction

;/  Function: RemoveSubstr

    Removes substrings from the specified string
    
    Parameters:
        asStr                         - Given string
        asSubstr                      - Substring

    Returns:
        The resulting string
/;
String Function RemoveSubstr(String asStr, String asSubstr)
    String loc_res = asStr
    Int loc_delta = StringUtil.GetLength(asSubstr)
    Int loc_pos = StringUtil.Find(loc_res, asSubstr)
    While loc_pos >= 0
        If loc_pos == 0
            loc_res = StringUtil.Substring(loc_res, loc_delta)
        ElseIf loc_pos > 0
            loc_res = StringUtil.Substring(loc_res, 0, loc_pos) + StringUtil.Substring(loc_res, loc_pos + loc_delta)
        EndIf
        loc_pos = StringUtil.Find(loc_res, asSubstr, loc_pos)
    EndWhile
    Return loc_res
EndFunction

;/  Function: ReplaceSubstr

    Replaces one substring with another within the given string
    
    Parameters:
        asStr                         - Given string
        asFind                        - Substring to find
        asReplace                     - Substring to replace the found substring with

    Returns:
        The resulting string
/;
String Function ReplaceSubstr(String asStr, String asFind, String asReplace)
    String loc_res = asStr
    Int loc_delta = StringUtil.GetLength(asFind)
    Int loc_pos = StringUtil.Find(loc_res, asFind)
    While loc_pos >= 0
        If loc_pos == 0
            loc_res = asReplace + StringUtil.Substring(loc_res, loc_delta)
        ElseIf loc_pos > 0
            loc_res = StringUtil.Substring(loc_res, 0, loc_pos) + asReplace + StringUtil.Substring(loc_res, loc_pos + loc_delta)
        EndIf
        loc_pos = StringUtil.Find(loc_res, asFind, loc_pos)
    EndWhile
    Return loc_res
EndFunction

;/  Function: RemoveDuplicates

    Deletes consecutive substrings
    
    Parameters:
        asStr                         - Given string
        asFind                        - Substring to find and remove duplicates

    Returns:
        The resulting string
/;
String Function RemoveDuplicates(String asStr, String asSubstr)
    String loc_res = asStr
    Int loc_delta = StringUtil.GetLength(asSubstr)
    Int loc_pos = StringUtil.Find(loc_res, asSubstr)
    Int loc_prev = -1
    While loc_pos >= 0
        If loc_prev >= 0 && loc_prev + loc_delta == loc_pos
            loc_res = StringUtil.Substring(loc_res, 0, loc_prev) + StringUtil.Substring(loc_res, loc_pos)
        Else
            loc_prev = loc_pos
        EndIf
        loc_pos = StringUtil.Find(loc_res, asSubstr, loc_prev + loc_delta)
    EndWhile
    Return loc_res
EndFunction

; The main disadvantage of the function is that it is calculated in advance for all branches, regardless of the condition
; Use with caution


;/  Function: RemoveDuplicates

    Returns one of its arguments depending on the condition.
    The main disadvantage of the function is that it is calculated in advance for all branches, regardless of the condition.
    Use with caution

    Parameters:
        abCondition                     - Condition
        asTrue                          - String for True condition
        asFalse                         - String for False condition

    Returns:
        The resulting string
/;
String Function InlineIfString(Bool abCondition, String asTrue, String asFalse = "")
    If abCondition
        Return asTrue
    Else
        Return asFalse
    EndIf
EndFunction
