class InventoryStationAccess extends DeployableClasses.DeployedInventoryStationAccess config(meta);

var config bool AllowReinvoForFlagHolder;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    SaveConfig();
}

function bool CanBeUsedBy(Pawn user)
{
    // if user is holding the flag do nothing TODO apropriate error message
    if (!AllowReinvoForFlagHolder &&
        PlayerCharacterController(user.Controller).Character.carryables.length >= 1)
        return false;
    return Super.CanBeUsedBy(user);
}

defaultproperties
{
    AllowReinvoForFlagHolder    =   false
}
