class WeaponReplication extends Engine.Actor config(meta_v1);

var config float HandGrenade_roundsPerSecond;

var(Meta) config int    LightSpinfusorAmmo,
                        LightSniperAmmo,
                        LightGrenadeLauncherAmmo,
                        LightRocketPodAmmo,
                        LightGrapplerAmmo,
                        LightChaingunAmmo,
                        MediumSpinfusorAmmo,
                        MediumGrenadeLauncherAmmo,
                        MediumRocketPodAmmo,
                        MediumGrapplerAmmo,
                        MediumChaingunAmmo,
                        HeavySpinfusorAmmo,
                        HeavyMortarAmmo,
                        HeavyGrenadeLauncherAmmo,
                        HeavyRocketPodAmmo,
                        HeavyGrapplerAmmo,
                        HeavyChaingunAmmo;

var config travel int cg_ammoCount;
var config int cg_ammoUsage;
var config float cg_roundsPerSecond;
var config class<Projectile> cg_projectileClass;
var config float cg_projectileVelocity;
var config float cg_projectileInheritedVelFactor;
var config float cg_minSpread;
var config float cg_maxSpread;
var config float cg_spinPeriod;
var config float cg_heatPeriod;
var config float cg_coolDownThreshold;
var config float cg_speedCooldownFactor;
var config float cg_damageAmt;
var config float cg_AccelerationMagtitude;
var config bool cg_bDeflectable;
var config float cg_MaxVelocity;
var config float cg_lifeSpan;

replication
{
    reliable if (Role == ROLE_Authority)
        HandGrenade_roundsPerSecond,

        cg_ammoCount, cg_ammoUsage, cg_roundsPerSecond,
        cg_projectileClass, cg_projectileVelocity,
        cg_projectileInheritedVelFactor, cg_spinPeriod,
        cg_heatPeriod, cg_coolDownThreshold, cg_speedCooldownFactor,
        cg_AccelerationMagtitude, cg_MaxVelocity
        ;
}

simulated event PostBeginPlay()
{
    if (Level.NetMode != NM_Client) {
        SaveConfig();
        setServerSettings();
    }
}

/**
 * Set config settings to projectile classes on the server
 */
simulated function setServerSettings()
{
    class'EquipmentClasses.WeaponHandGrenade'.default.roundsPerSecond = HandGrenade_roundsPerSecond;

    class'ProjectileChaingun'.default.damageAmt = cg_damageAmt;
    class'ProjectileChaingun'.default.AccelerationMagtitude = cg_AccelerationMagtitude;
    class'ProjectileChaingun'.default.bDeflectable = cg_bDeflectable;
    class'ProjectileChaingun'.default.MaxVelocity = cg_MaxVelocity;
    class'ProjectileChaingun'.default.LifeSpan = cg_lifeSpan;
    class'EquipmentClasses.WeaponChaingun'.default.ammoCount = cg_ammoCount;
    class'EquipmentClasses.WeaponChaingun'.default.ammoUsage = cg_ammoUsage;
    class'EquipmentClasses.WeaponChaingun'.default.roundsPerSecond = cg_roundsPerSecond;
    class'EquipmentClasses.WeaponChaingun'.default.projectileVelocity = cg_projectileVelocity;
    class'EquipmentClasses.WeaponChaingun'.default.projectileInheritedVelFactor = cg_projectileInheritedVelFactor;
    class'EquipmentClasses.WeaponChaingun'.default.spinPeriod = cg_spinPeriod;
    class'EquipmentClasses.WeaponChaingun'.default.heatPeriod = cg_heatPeriod;
    class'EquipmentClasses.WeaponChaingun'.default.coolDownThreshold = cg_coolDownThreshold;
    class'EquipmentClasses.WeaponChaingun'.default.speedCooldownFactor = cg_speedCooldownFactor;
}

/**
 * Corrupts game cache prohibiting the user to join another server
 */
simulated event PostNetReceive()
{
    super.PostNetReceive();
    class'EquipmentClasses.WeaponHandGrenade'.default.roundsPerSecond = HandGrenade_roundsPerSecond;

    class'ProjectileChaingun'.default.damageAmt = cg_damageAmt;
    class'ProjectileChaingun'.default.AccelerationMagtitude = cg_AccelerationMagtitude;
    class'ProjectileChaingun'.default.bDeflectable = cg_bDeflectable;
    class'ProjectileChaingun'.default.MaxVelocity = cg_MaxVelocity;
    class'ProjectileChaingun'.default.LifeSpan = cg_lifeSpan;
    class'EquipmentClasses.WeaponChaingun'.default.ammoCount = cg_ammoCount;
    class'EquipmentClasses.WeaponChaingun'.default.ammoUsage = cg_ammoUsage;
    class'EquipmentClasses.WeaponChaingun'.default.roundsPerSecond = cg_roundsPerSecond;
    class'EquipmentClasses.WeaponChaingun'.default.projectileVelocity = cg_projectileVelocity;
    class'EquipmentClasses.WeaponChaingun'.default.projectileInheritedVelFactor = cg_projectileInheritedVelFactor;
    class'EquipmentClasses.WeaponChaingun'.default.spinPeriod = cg_spinPeriod;
    class'EquipmentClasses.WeaponChaingun'.default.heatPeriod = cg_heatPeriod;
    class'EquipmentClasses.WeaponChaingun'.default.coolDownThreshold = cg_coolDownThreshold;
    class'EquipmentClasses.WeaponChaingun'.default.speedCooldownFactor = cg_speedCooldownFactor;

    log("weapon properties replication completed", class'Meta'.static.getLogName());
}

defaultproperties
{
    HandGrenade_roundsPerSecond =   0.500000

    LightSpinfusorAmmo          =   15
    LightSniperAmmo             =   7
    LightGrenadeLauncherAmmo    =   10
    LightRocketPodAmmo          =   54
    LightGrapplerAmmo           =   7
    LightChaingunAmmo           =   100
    MediumSpinfusorAmmo         =   20
    MediumGrenadeLauncherAmmo   =   15
    MediumRocketPodAmmo         =   84
    MediumGrapplerAmmo          =   5
    MediumChaingunAmmo          =   150
    HeavySpinfusorAmmo          =   25
    HeavyMortarAmmo             =   13
    HeavyGrenadeLauncherAmmo    =   20
    HeavyRocketPodAmmo          =   96
    HeavyGrapplerAmmo           =   7
    HeavyChaingunAmmo           =   200

    cg_ammoCount                   =       150
    cg_ammoUsage                   =       1
    cg_roundsPerSecond             =       7.500000
    cg_projectileClass             =       Class'ProjectileChaingun';
    cg_projectileVelocity          =       32000.000000
    cg_projectileInheritedVelFactor=       1.000000
    cg_minSpread                   =       0.400000
    cg_maxSpread                   =       2.000000
    cg_spinPeriod                  =       0.050000
    cg_heatPeriod                  =       7.000000
    cg_coolDownThreshold           =       1.000000
    cg_speedCooldownFactor         =       0.002000
    cg_damageAmt                   =       6.000000
    cg_AccelerationMagtitude       =       0.000000
    cg_bDeflectable                =       False
    cg_MaxVelocity                 =       0.000000
    cg_lifeSpan                    =       1.100000

    bNetNotify                  =   True
    NetUpdateFrequency          =   1
    bStatic                     =   False
    bNoDelete                   =   False
    bAlwaysRelevant             =   True
    netPriority                 =   1
}

