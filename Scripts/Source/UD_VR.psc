Scriptname UD_VR
; Credit to the OStim Standalone VR code that had the settings in the C++ code for third person animations.
Bool Function VRIKFixStart() Global
    VRIK.VrikSetSetting("lockHeightToBody", 0.0)
    VRIK.VrikSetSetting("enableLeftArm", 0.0)
    VRIK.VrikSetSetting("enableRightArm", 0.0)
    VRIK.VrikSetSetting("enablePosture",0.0)
    VRIK.VrikSetSetting("enableBody", 0.0)  
    VRIK.VrikSetSetting("enableHead", 0.0)    
    VRIK.VrikSetSetting("hidePlayerHeadDistance",12.0)
    VRIK.VrikSetSetting("lockHmdToBody", 0.0)    
    VRIK.VrikSetSetting("lockHmdMinThreshold", 500.0)  
    VRIK.VrikSetSetting("lockHmdMaxThreshold", 500.0)  
    VRIK.VrikSetSetting("lockHmdSpeed", 20.0)  
    VRIK.VrikSetSetting("rotateHmdToBodySeconds", 0.0)  
    float angle=Game.GetPlayer().GetAngleZ()*0.0174533
    float distance=50.0
    float ZOffset=0.0
    float XOffset=Math.Sin(angle)*distance
    float YOffset=Math.Cos(angle)*distance
    VRIK.VrikSetSetting("lockPositionX",Game.GetPlayer().GetPositionX()+XOffset)
    VRIK.VrikSetSetting("lockPositionY",Game.GetPlayer().GetPositionY()+YOffset)
    VRIK.VrikSetSetting("lockPositionZ",Game.GetPlayer().GetPositionZ()+ZOffset)
    VRIK.VrikSetSetting("lockRotation",1)
    VRIK.VrikSetSetting("lockPosition",2.0)
EndFunction
Bool Function VRIKFixEnd() Global
    VRIK.VrikRestoreSettings()
EndFunction
