scriptname UD_ExpressionManager extends Quest

import MfgConsoleFunc
import sslBaseExpression
import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty

bool Property Ready = false auto

Event OnInit()
    RegisterForSingleUpdate(10.0) ;update expression manager on init
    Ready = true
EndEvent

;on init update
Event OnUpdate()
    if UDmain.UDReady()
        Update()
    else
        RegisterForSingleUpdate(30.0)
    endif
EndEvent

Function Update()
    UpdatePrebuildExpressions()
EndFunction

float[] Function CreateEmptyExpression()
    return new float[32]
EndFunction

Function UpdatePrebuildExpressions()
    _UpdatePrebuildExpression_Happy1()
    _UpdatePrebuildExpression_Concetrated1()
    _UpdatePrebuildExpression_Angry1()
    _UpdatePrebuildExpression_Tired1()
    _UpdatePrebuildExpression_Horny1()
    _UpdatePrebuildExpression_Orgasm1()
    _UpdatePrebuildExpression_Orgasm2()
    _UpdatePrebuildExpression_Orgasm3()
EndFunction

float[] loc_Expression_Happy1
Function _UpdatePrebuildExpression_Happy1()
    if !loc_Expression_Happy1
        loc_Expression_Happy1 = CreateEmptyExpression()
    endif
    ;phonems
    loc_Expression_Happy1[ 5] = 0.079
    loc_Expression_Happy1[ 6] = 0.284
    loc_Expression_Happy1[ 7] = 0.237
    loc_Expression_Happy1[ 8] = 0.055
    loc_Expression_Happy1[11] = 0.192
    loc_Expression_Happy1[13] = 0.03
    loc_Expression_Happy1[14] = 0.115
    ;modifiers
    loc_Expression_Happy1[20] = 0.104
    loc_Expression_Happy1[22] = 0.212
    loc_Expression_Happy1[23] = 0.078
    loc_Expression_Happy1[24] = 0.129
    loc_Expression_Happy1[27] = 0.108
    ;expression
    loc_Expression_Happy1[30] = 10.0
    loc_Expression_Happy1[31] = 0.729
EndFunction
Float[] Function GetPrebuildExpression_Happy1()
    return loc_Expression_Happy1
EndFunction

float[] loc_Expression_Concetrated1
Function _UpdatePrebuildExpression_Concetrated1()
    if !loc_Expression_Concetrated1
        loc_Expression_Concetrated1 = CreateEmptyExpression()
    endif
    ;phonems
    loc_Expression_Concetrated1[ 2] = 0.12
    loc_Expression_Concetrated1[ 3] = 0.24
    loc_Expression_Concetrated1[ 7] = 0.08
    loc_Expression_Concetrated1[ 8] = 0.08
    loc_Expression_Concetrated1[ 9] = 0.14
    loc_Expression_Concetrated1[14] = 0.08
    ;modifiers
    loc_Expression_Concetrated1[18] = 0.18
    loc_Expression_Concetrated1[19] = 0.29
    loc_Expression_Concetrated1[21] = 0.06
    loc_Expression_Concetrated1[22] = 0.19
    loc_Expression_Concetrated1[25] = 0.27
    loc_Expression_Concetrated1[26] = 0.26
    loc_Expression_Concetrated1[27] = 0.29
    loc_Expression_Concetrated1[29] = 0.01
    ;expression
    loc_Expression_Concetrated1[30] = 4
    loc_Expression_Concetrated1[31] = 0.59
EndFunction
Float[] Function GetPrebuildExpression_Concetrated1()
    return loc_Expression_Concetrated1
EndFunction

float[] loc_Expression_Angry1
Function _UpdatePrebuildExpression_Angry1()
    if !loc_Expression_Angry1
        loc_Expression_Angry1 = CreateEmptyExpression()
    endif
    ;phonems
    loc_Expression_Angry1[ 1] = 0.174
    loc_Expression_Angry1[ 3] = 0.122
    loc_Expression_Angry1[ 4] = 0.08
    loc_Expression_Angry1[ 6] = 0.281
    loc_Expression_Angry1[ 8] = 0.053
    loc_Expression_Angry1[ 9] = 0.004
    loc_Expression_Angry1[10] = 0.145
    loc_Expression_Angry1[11] = 0.073
    loc_Expression_Angry1[14] = 0.277
    ;modifiers
    loc_Expression_Angry1[19] = 0.144
    loc_Expression_Angry1[20] = 0.245
    loc_Expression_Angry1[21] = 0.23
    loc_Expression_Angry1[24] = 0.269
    loc_Expression_Angry1[25] = 0.067
    loc_Expression_Angry1[27] = 0.186
    loc_Expression_Angry1[28] = 0.247
    loc_Expression_Angry1[29] = 0.103
    ;expression
    loc_Expression_Angry1[30] = 14
    loc_Expression_Angry1[31] = 0.757
EndFunction
Float[] Function GetPrebuildExpression_Angry1()
    return loc_Expression_Angry1
EndFunction

float[] loc_Expression_Tired1
Function _UpdatePrebuildExpression_Tired1()
    if !loc_Expression_Tired1
        loc_Expression_Tired1 = CreateEmptyExpression()
    endif
    loc_Expression_Tired1[ 0] = 0.151
    loc_Expression_Tired1[ 1] = 0.246
    loc_Expression_Tired1[ 2] = 0.181
    loc_Expression_Tired1[ 3] = 0.226
    loc_Expression_Tired1[ 7] = 0.060
    loc_Expression_Tired1[ 8] = 0.216
    loc_Expression_Tired1[10] = 0.098
    loc_Expression_Tired1[12] = 0.122
    loc_Expression_Tired1[13] = 0.170
    loc_Expression_Tired1[14] = 0.094
    loc_Expression_Tired1[15] = 0.071
    loc_Expression_Tired1[22] = 0.213
    loc_Expression_Tired1[23] = 0.187
    loc_Expression_Tired1[25] = 0.092
    loc_Expression_Tired1[26] = 0.205
    loc_Expression_Tired1[28] = 0.274
    loc_Expression_Tired1[30] = 3.000
    loc_Expression_Tired1[31] = 0.641
EndFunction
Float[] Function GetPrebuildExpression_Tired1()
    return loc_Expression_Tired1
EndFunction

float[] loc_Expression_Horny1
Function _UpdatePrebuildExpression_Horny1()
    if !loc_Expression_Horny1
        loc_Expression_Horny1 = CreateEmptyExpression()
    endif
    loc_Expression_Horny1[10] = 0.50
    loc_Expression_Horny1[16] = 0.10
    loc_Expression_Horny1[17] = 0.10
    loc_Expression_Horny1[18] = 0.25
    loc_Expression_Horny1[19] = 0.25
    loc_Expression_Horny1[20] = 0.25
    loc_Expression_Horny1[21] = 0.25
    loc_Expression_Horny1[24] = 0.30
    loc_Expression_Horny1[25] = 0.50
    loc_Expression_Horny1[26] = 0.50
    loc_Expression_Horny1[28] = 0.25
    loc_Expression_Horny1[29] = 0.25
    loc_Expression_Horny1[30] = 13.0
    loc_Expression_Horny1[31] = 0.25
EndFunction
Float[] Function GetPrebuildExpression_Horny1()
    return loc_Expression_Horny1
EndFunction

float[] loc_Expression_Orgasm1
Function _UpdatePrebuildExpression_Orgasm1()
    if !loc_Expression_Orgasm1
        loc_Expression_Orgasm1 = CreateEmptyExpression()
    endif
    loc_Expression_Orgasm1[ 0] = 0.5
    loc_Expression_Orgasm1[11] = 0.5
    loc_Expression_Orgasm1[16] = 0.2
    loc_Expression_Orgasm1[17] = 0.2
    loc_Expression_Orgasm1[22] = 0.4
    loc_Expression_Orgasm1[23] = 0.4
    loc_Expression_Orgasm1[27] = 0.75
    loc_Expression_Orgasm1[30] = 10.0
    loc_Expression_Orgasm1[31] = 0.5
EndFunction
Float[] Function GetPrebuildExpression_Orgasm1()
    return loc_Expression_Orgasm1
EndFunction

float[] loc_Expression_Orgasm2
Function _UpdatePrebuildExpression_Orgasm2()
    if !loc_Expression_Orgasm2
        loc_Expression_Orgasm2 = CreateEmptyExpression()
    endif
    loc_Expression_Orgasm2[ 5] = 0.079
    loc_Expression_Orgasm2[ 6] = 0.284
    loc_Expression_Orgasm2[ 7] = 0.237
    loc_Expression_Orgasm2[ 8] = 0.055
    loc_Expression_Orgasm2[11] = 0.192
    loc_Expression_Orgasm2[13] = 0.030
    loc_Expression_Orgasm2[14] = 0.115
    loc_Expression_Orgasm2[16] = 0.200
    loc_Expression_Orgasm2[17] = 0.200
    loc_Expression_Orgasm2[22] = 0.400
    loc_Expression_Orgasm2[23] = 0.400
    loc_Expression_Orgasm2[27] = 0.750
    loc_Expression_Orgasm2[30] = 10.00
    loc_Expression_Orgasm2[31] = 0.729
EndFunction
Float[] Function GetPrebuildExpression_Orgasm2()
    return loc_Expression_Orgasm2
EndFunction

float[] loc_Expression_Orgasm3
Function _UpdatePrebuildExpression_Orgasm3()
    if !loc_Expression_Orgasm3
        loc_Expression_Orgasm3 = CreateEmptyExpression()
    endif
    loc_Expression_Orgasm3[ 5] = 0.079
    loc_Expression_Orgasm3[ 6] = 0.284
    loc_Expression_Orgasm3[ 7] = 0.237
    loc_Expression_Orgasm3[ 8] = 0.055
    loc_Expression_Orgasm3[11] = 0.192
    loc_Expression_Orgasm3[13] = 0.030
    loc_Expression_Orgasm3[14] = 0.115
    loc_Expression_Orgasm3[16] = 0.170
    loc_Expression_Orgasm3[17] = 0.170
    loc_Expression_Orgasm3[22] = 0.280
    loc_Expression_Orgasm3[30] = 11.00
    loc_Expression_Orgasm3[31] = 0.900
EndFunction
Float[] Function GetPrebuildExpression_Orgasm3()
    return loc_Expression_Orgasm3
EndFunction