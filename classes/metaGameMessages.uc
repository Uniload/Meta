class metaGameMessages extends Gameplay.TribesGameMessage;

var localized string trocOn;
var localized string trocOff;
var localized string leagueOn;
var localized string leagueOff;

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
        case 101:
            return default.trocOff;
        case 102:
            return default.leagueOn;
        case 103:
            return default.leagueOff;
    }
}

defaultproperties
{
    leagueOn    =   "Server: League mode enabled."
    leagueOff   =   "Server: League mode disabled."
    trocOn      =   "Server: Troc has been enabled."
    trocOff     =   "Server: Troc has been disabled."
}
