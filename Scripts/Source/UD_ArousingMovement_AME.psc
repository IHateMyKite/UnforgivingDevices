Scriptname UD_ArousingMovement_AME extends ActiveMagicEffect

import UnforgivingDevicesMain
import UD_Native

UnforgivingDevicesMain  Property UDmain auto
UD_OrgasmManager        Property UDOM   auto
Actor akActor

Float Property UpdateTime = 1.0 autoreadonly

Bool _finished = false
Float _magnitude
Float _lastX = 0.0
Float _lastY = 0.0
Cell _previousCell = none