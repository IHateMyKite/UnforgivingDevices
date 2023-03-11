scriptname ActorUtil Hidden

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

function AddPackageOverride(Actor targetActor, Package targetPackage, int priority = 30, int flags = 0) global native
bool function RemovePackageOverride(Actor targetActor, Package targetPackage) global native
int function CountPackageOverride(Actor targetActor) global native
int function ClearPackageOverride(Actor targetActor) global native
int function RemoveAllPackageOverride(Package targetPackage) global native