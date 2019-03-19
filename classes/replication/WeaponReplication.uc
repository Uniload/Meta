class WeaponReplication extends Engine.Actor config(meta);

var config float HandGrenade_roundsPerSecond;

var(Ammo) config int    LightSpinfusorAmmo,
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

var(Sniper) config float    snipe_damageAmt,
                            snipe_AccelerationMagtitude,
                            snipe_MaxVelocity,
                            snipe_lifeSpan,
                            snipe_roundsPerSecond,
                            snipe_projectileVelocity,
                            snipe_projectileInheritedVelFactor;

var(Sniper) config int      snipe_ammoCount,
                            snipe_ammoUsage;

var(Sniper) config bool     snipe_bDeflectable;

var(Sniper) config class<Projectile> snipe_projectileClass;


var(Chaingun) config float      cg_roundsPerSecond,
                                cg_projectileVelocity,
                                cg_projectileInheritedVelFactor,
                                cg_minSpread,
                                cg_maxSpread,
                                cg_spinPeriod,
                                cg_heatPeriod,
                                cg_coolDownThreshold,
                                cg_speedCooldownFactor,
                                cg_damageAmt,
                                cg_AccelerationMagtitude,
                                cg_MaxVelocity,
                                cg_lifeSpan;

var(Chaingun) config int        cg_ammoCount,
                                cg_ammoUsage;

var(Chaingun) config bool     cg_bDeflectable;

var(Chaingun) config class<Projectile> cg_projectileClass;

replication
{
    reliable if (Role == ROLE_Authority)
        HandGrenade_roundsPerSecond,

        //sniper
        snipe_damageAmt, snipe_AccelerationMagtitude,
        snipe_MaxVelocity, snipe_lifeSpan, snipe_roundsPerSecond,
        snipe_projectileVelocity, snipe_projectileInheritedVelFactor,
        snipe_ammoCount, snipe_ammoUsage, snipe_bDeflectable,
        snipe_projectileClass,

        //chaingun
        cg_roundsPerSecond, cg_projectileVelocity,
        cg_projectileInheritedVelFactor, cg_minSpread, cg_maxSpread,
        cg_spinPeriod, cg_heatPeriod, cg_coolDownThreshold,
        cg_speedCooldownFactor, cg_damageAmt, cg_AccelerationMagtitude,
        cg_MaxVelocity, cg_lifeSpan, cg_ammoCount, cg_ammoUsage,
        cg_bDeflectable, cg_projectileClass

        ;
}

simulated event PostBeginPlay()
{
    if (Level.NetMode != NM_Client) {
        SaveConfig();
        changeEquipmentClassesProperties();
    }
}

/**
 * Set config settings to projectile classes on the server
 */
simulated function changeEquipmentClassesProperties()
{
    class'EquipmentClasses.WeaponHandGrenade'.default.roundsPerSecond = HandGrenade_roundsPerSecond;

    class'ProjectileSniperRifle'.default.damageAmt = snipe_damageAmt;
    class'ProjectileSniperRifle'.default.AccelerationMagtitude = snipe_AccelerationMagtitude;
    class'ProjectileSniperRifle'.default.bDeflectable = snipe_bDeflectable;
    class'ProjectileSniperRifle'.default.MaxVelocity = snipe_MaxVelocity;
    class'ProjectileSniperRifle'.default.LifeSpan = snipe_lifeSpan;
    class'EquipmentClasses.WeaponSniperRifle'.default.ammoCount = snipe_ammoCount;
    class'EquipmentClasses.WeaponSniperRifle'.default.ammoUsage = snipe_ammoUsage;
    class'EquipmentClasses.WeaponSniperRifle'.default.roundsPerSecond = snipe_roundsPerSecond;
    class'EquipmentClasses.WeaponSniperRifle'.default.projectileVelocity = snipe_projectileVelocity;
    class'EquipmentClasses.WeaponSniperRifle'.default.projectileInheritedVelFactor = snipe_projectileInheritedVelFactor;
    class'EquipmentClasses.WeaponSniperRifle'.default.projectileClass = snipe_projectileClass;

    class'ProjectileChaingun'.default.damageAmt = cg_damageAmt;
    class'ProjectileChaingun'.default.AccelerationMagtitude = cg_AccelerationMagtitude;
    class'ProjectileChaingun'.default.bDeflectable = cg_bDeflectable;
    class'ProjectileChaingun'.default.MaxVelocity = cg_MaxVelocity;
    class'ProjectileChaingun'.default.LifeSpan = cg_lifeSpan;
    class'EquipmentClasses.WeaponChaingun'.default.ammoCount = cg_ammoCount;
    class'EquipmentClasses.WeaponChaingun'.default.ammoUsage = cg_ammoUsage;
    class'EquipmentClasses.WeaponChaingun'.default.roundsPerSecond = cg_roundsPerSecond;
    class'EquipmentClasses.WeaponChaingun'.default.projectileClass = cg_projectileclass;
    class'EquipmentClasses.WeaponChaingun'.default.projectileVelocity = cg_projectileVelocity;
    class'EquipmentClasses.WeaponChaingun'.default.projectileInheritedVelFactor = cg_projectileInheritedVelFactor;
    class'EquipmentClasses.WeaponChaingun'.default.spinPeriod = cg_spinPeriod;
    class'EquipmentClasses.WeaponChaingun'.default.heatPeriod = cg_heatPeriod;
    class'EquipmentClasses.WeaponChaingun'.default.coolDownThreshold = cg_coolDownThreshold;
    class'EquipmentClasses.WeaponChaingun'.default.speedCooldownFactor = cg_speedCooldownFactor;
    class'EquipmentClasses.WeaponChaingun'.default.minSpread = cg_minSpread;
    class'EquipmentClasses.WeaponChaingun'.default.maxSpread = cg_maxSpread;
}

/**
 * Corrupts game cache prohibiting the user to join another server
 */
simulated event PostNetReceive()
{
    super.PostNetReceive();
    changeEquipmentClassesProperties();
    log("weapon properties replication completed", class'Meta'.static.getLogName());
}

defaultproperties
{
    HandGrenade_roundsPerSecond =   0.500000

    LightSpinfusorAmmo          =   20
    LightSniperAmmo             =   10
    LightGrenadeLauncherAmmo    =   15
    LightRocketPodAmmo          =   54
    LightGrapplerAmmo           =   10
    LightChaingunAmmo           =   150
    MediumSpinfusorAmmo         =   22
    MediumGrenadeLauncherAmmo   =   20
    MediumRocketPodAmmo         =   84
    MediumGrapplerAmmo          =   7
    MediumChaingunAmmo          =   200
    HeavySpinfusorAmmo          =   25
    HeavyMortarAmmo             =   13
    HeavyGrenadeLauncherAmmo    =   20
    HeavyRocketPodAmmo          =   96
    HeavyGrapplerAmmo           =   15
    HeavyChaingunAmmo           =   300

    snipe_damageAmt                     =       50
    snipe_ammoCount                     =       10
    snipe_ammoUsage                     =       1
    snipe_roundsPerSecond               =       0.500000
    snipe_projectileClass               =       Class'ProjectileSniperRifle';
    snipe_projectileVelocity            =       400000.000000
    snipe_projectileInheritedVelFactor  =       1.000000
    snipe_AccelerationMagtitude         =       0.000000
    snipe_MaxVelocity                   =       0.000000
    snipe_lifeSpan                      =       0.100000
    snipe_bDeflectable                  =       True


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
    cg_damageAmt                   =       5.000000
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

