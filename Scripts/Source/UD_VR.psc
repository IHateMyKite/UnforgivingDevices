Scriptname UD_VR
Bool Function VRIKFixStart() Global
    VRIK.VrikSetSetting("lockHeightToBody", 0.0)
    VRIK.VrikSetSetting("enableLeftArm", 0.0)
    VRIK.VrikSetSetting("enableRightArm", 0.0)
    VRIK.VrikSetSetting("enableHead", 1.0)    
    VRIK.VrikSetSetting("hidePlayerHeadDistance",12.0)
    VRIK.VrikSetSetting("lockHmdToBody", 0.0)    
    VRIK.VrikSetSetting("lockHmdMinThreshold", 500.0)  
    VRIK.VrikSetSetting("lockHmdMaxThreshold", 500.0)  
    VRIK.VrikSetSetting("lockHmdSpeed", 20.0)  
    VRIK.VrikSetSetting("rotateHmdToBodySeconds", 0.0)  
    VRIK.VriKSetSetting("disableVrik",1.0)   
EndFunction
Bool Function VRIKFixEnd() Global
    VRIK.VrikRestoreSettings()
EndFunction
