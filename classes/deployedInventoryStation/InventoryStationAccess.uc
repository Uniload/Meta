class InventoryStationAccess extends DeployableClasses.DeployedInventoryStationAccess config(meta);

function bool CanBeUsedBy(Pawn user)
{
    // if user is holding the flag do nothing TODO apropriate error message
    if (PlayerCharacterController(user.Controller).Character.carryables.length >= 1)
        return false;
    return Super.CanBeUsedBy(user);
}

defaultproperties
{
}
