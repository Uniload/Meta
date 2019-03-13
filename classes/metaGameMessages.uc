class metaGameMessages extends Gameplay.TribesGameMessage;

var localized string trocOn;
var localized string trocOff;

static function string GetString(
        optional int Switch,
        optional Core.Object Related1,
        optional Core.Object Related2,
        optional Core.Object OptionalObject,
        optional String OptionalString
        )
{
    switch (Switch) {
        case 100:
            return default.trocOn;
            break;
        case 101:
            return default.trocOff;
            break;
    }
    return super.GetString(Switch, Related1, Related2, OptionalObject, OptionalString);
}

defaultproperties
{
    trocOn="Server: Troc has been enabled."
    trocOff="Server: Troc has been disabled."
}
