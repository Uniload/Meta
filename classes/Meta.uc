class Meta extends Gameplay.Mutator config(meta_v1);


var(Meta) config bool allowCommands;
var(Meta) private bool trocIsOn;

var(Meta) Array<Armor.QuantityWeapon>   LightWeapons,
                                        MediumWeapons,
                                        HeavyWeapons;

var(Meta) private PackReplication prInstance;
var(Meta) private WeaponReplication wrInstance;

replication
{
    reliable if (bNetInitial)
        prInstance
        ;
}

static function Name getLogName()
{
    return Name("meta_v1");
}

/* @Override */
simulated event PreBeginPlay()
{
    Super.PreBeginPlay();
    SaveConfig();
    log("Startup...", class'Meta'.static.getLogName());

    prInstance = spawn(class'PackReplication');
    wrInstance = spawn(class'WeaponReplication');
}

/* @Override */
event Actor ReplaceActor(Actor other)
{
    switch (true) {
        case other.IsA('RepairPack'):
            RepairPack(other).activePeriod = prInstance.repair_activePeriod;
            RepairPack(other).passivePeriod = prInstance.repair_passivePeriod;
            RepairPack(other).radius = prInstance.repair_radius;
            RepairPack(other).deactivatingDuration = prInstance.repair_deactivatingDuration;
            RepairPack(other).durationSeconds = prInstance.repair_durationSeconds;
            RepairPack(other).rampUpTimeSeconds = prInstance.repair_rampUpTimeSeconds;
            RepairPack(other).rechargeTimeSeconds = prInstance.repair_rechargeTimeSeconds;
            RepairPack(other).activeHealthPerPeriod = prInstance.repair_activeHealthPerPeriod;
            RepairPack(other).activeExtraSelfHealthPerPeriod = prInstance.repair_activeExtraSelfHealthPerPeriod;
            RepairPack(other).passiveHealthPerPeriod = prInstance.repair_passiveHealthPerPeriod;
            RepairPack(other).accumulationScale = prInstance.repair_accumulationScale;
            return Super.ReplaceActor(other);

        case other.IsA('EnergyPack'):
            if (trocIsOn)
            {
                EnergyPack(other).durationSeconds = prInstance.energy_durationSeconds_TROC;
                EnergyPack(other).boostImpulsePerSecond = prInstance.energy_boostImpulsePerSecond_TROC;
            } else {
                EnergyPack(other).durationSeconds = prInstance.energy_durationSeconds;
                EnergyPack(other).boostImpulsePerSecond = prInstance.energy_boostImpulsePerSecond;
            }
            EnergyPack(other).deactivatingDuration = prInstance.energy_deactivatingDuration;
            EnergyPack(other).rampUpTimeSeconds = prInstance.energy_rampUpTimeSeconds;
            EnergyPack(other).rechargeTimeSeconds = prInstance.energy_rechargeTimeSeconds;
            EnergyPack(other).rechargeScale = prInstance.energy_rechargeScale;
            return Super.ReplaceActor(other);

        case other.IsA('ShieldPack'):
            ShieldPack(other).deactivatingDuration = prInstance.shield_deactivatingDuration;
            ShieldPack(other).durationSeconds = prInstance.shield_durationSeconds;
            ShieldPack(other).rampUpTimeSeconds = prInstance.shield_rampUpTimeSeconds;
            ShieldPack(other).rechargeTimeSeconds = prInstance.shield_rechargeTimeSeconds;
            ShieldPack(other).passiveFractionDamageBlocked = prInstance.shield_passiveFractionDamageBlocked;
            ShieldPack(other).activeFractionDamageBlocked = prInstance.shield_activeFractionDamageBlocked;
            ShieldPack(other).passiveIdleMaterial = prInstance.shield_passiveIdleMaterial;
            ShieldPack(other).activeIdleMaterial = prInstance.shield_activeIdleMaterial;
            ShieldPack(other).passiveHitMaterial = prInstance.shield_passiveHitMaterial;
            ShieldPack(other).activeHitMaterial = prInstance.shield_activeHitMaterial;
            ShieldPack(other).hitStayTime = prInstance.shield_hitStayTime;
            return Super.ReplaceActor(other);

        case other.IsA('SpeedPack'):
            SpeedPack(other).deactivatingDuration = prInstance.speed_deactivatingDuration;
            SpeedPack(other).durationSeconds = prInstance.speed_durationSeconds;
            SpeedPack(other).rampUpTimeSeconds = prInstance.speed_rampUpTimeSeconds;
            SpeedPack(other).rechargeTimeSeconds = prInstance.speed_rechargeTimeSeconds;
            SpeedPack(other).refireRateScale = prInstance.speed_refireRateScale;
            SpeedPack(other).passiveRefireRateScale = prInstance.speed_passiveRefireRateScale;
            SpeedPack(other).passiveMaterial = prInstance.speed_passiveMaterial;
            SpeedPack(other).activeMaterial = prInstance.speed_activeMaterial;
            return Super.ReplaceActor(other);

        default:
            return Super.ReplaceActor(other);
    }
}

/* @Override */
simulated event Mutate(string command, PlayerController sender)
{
    Super.Mutate(command, sender);
    if (!allowCommands || !sender.AdminManager.bAdmin) return;

    else if (command ~= "troc") {
        if (trocIsOn)
        {
            trocIsOn = false;
            Level.Game.BroadcastLocalized(self, class'metaGameMessages', 101);
        } else {
            trocIsOn = true;
            Level.Game.BroadcastLocalized(self, class'metaGameMessages', 100);
        }
    }
}

/* @Override */
event string MutateSpawnCombatRoleClass(Character c)
{
    Super.MutateSpawnCombatRoleClass(c);

    c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons = LightWeapons;
    c.team().combatRoleData[1].role.default.armorClass.default.AllowedWeapons = MediumWeapons;
    c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons = HeavyWeapons;

    c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons[0].quantity=wrInstance.LightSpinfusorAmmo;
    c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons[1].quantity=wrInstance.LightSniperAmmo;
    c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons[2].quantity=wrInstance.LightGrenadeLauncherAmmo;
    c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons[3].quantity=wrInstance.LightRocketPodAmmo;
    c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons[5].quantity=wrInstance.LightGrapplerAmmo;
    c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons[7].quantity=wrInstance.LightChaingunAmmo;

    c.team().combatRoleData[1].role.default.armorClass.default.AllowedWeapons[0].quantity=wrInstance.MediumSpinfusorAmmo;
    c.team().combatRoleData[1].role.default.armorClass.default.AllowedWeapons[2].quantity=wrInstance.MediumGrenadeLauncherAmmo;
    c.team().combatRoleData[1].role.default.armorClass.default.AllowedWeapons[3].quantity=wrInstance.MediumRocketPodAmmo;
    c.team().combatRoleData[1].role.default.armorClass.default.AllowedWeapons[5].quantity=wrInstance.MediumGrapplerAmmo;
    c.team().combatRoleData[1].role.default.armorClass.default.AllowedWeapons[7].quantity=wrInstance.MediumChaingunAmmo;

    c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons[0].quantity=wrInstance.HeavySpinfusorAmmo;
    c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons[1].quantity=wrInstance.HeavyMortarAmmo;
    c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons[2].quantity=wrInstance.HeavyGrenadeLauncherAmmo;
    c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons[3].quantity=wrInstance.HeavyRocketPodAmmo;
    c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons[5].quantity=wrInstance.HeavyGrapplerAmmo;
    c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons[7].quantity=wrInstance.HeavyChaingunAmmo;

    return "";
}

defaultproperties
{
    allowCommands=true
    trocIsOn=false

    LightWeapons(0)=(typeClass=Class'EquipmentClasses.WeaponSpinfusor',quantity=20)
    LightWeapons(1)=(typeClass=Class'EquipmentClasses.WeaponSniperRifle',quantity=10)
    LightWeapons(2)=(typeClass=Class'EquipmentClasses.WeaponGrenadeLauncher',quantity=15)
    LightWeapons(3)=(typeClass=Class'EquipmentClasses.WeaponRocketPod',quantity=42)
    LightWeapons(4)=(typeClass=Class'EquipmentClasses.WeaponBlaster')
    LightWeapons(5)=(typeClass=Class'EquipmentClasses.WeaponGrappler',quantity=7)
    LightWeapons(6)=(typeClass=Class'EquipmentClasses.WeaponBurner')
    LightWeapons(7)=(typeClass=Class'EquipmentClasses.WeaponChaingun',quantity=150)

    MediumWeapons(0)=(typeClass=Class'EquipmentClasses.WeaponSpinfusor',quantity=22)
    MediumWeapons(1)=(typeClass=Class'EquipmentClasses.WeaponBuckler',quantity=1)
    MediumWeapons(2)=(typeClass=Class'EquipmentClasses.WeaponGrenadeLauncher',quantity=17)
    MediumWeapons(3)=(typeClass=Class'EquipmentClasses.WeaponRocketPod',quantity=72)
    MediumWeapons(4)=(typeClass=Class'EquipmentClasses.WeaponBlaster')
    MediumWeapons(5)=(typeClass=Class'EquipmentClasses.WeaponGrappler',quantity=7)
    MediumWeapons(6)=(typeClass=Class'EquipmentClasses.WeaponBurner')
    MediumWeapons(7)=(typeClass=Class'EquipmentClasses.WeaponChaingun',quantity=200)

    HeavyWeapons(0)=(typeClass=Class'EquipmentClasses.WeaponSpinfusor',quantity=25)
    HeavyWeapons(1)=(typeClass=Class'EquipmentClasses.WeaponMortar',quantity=13)
    HeavyWeapons(2)=(typeClass=Class'EquipmentClasses.WeaponGrenadeLauncher',quantity=20)
    HeavyWeapons(3)=(typeClass=Class'EquipmentClasses.WeaponRocketPod',quantity=96)
    HeavyWeapons(4)=(typeClass=Class'EquipmentClasses.WeaponBlaster')
    HeavyWeapons(5)=(typeClass=Class'EquipmentClasses.WeaponGrappler',quantity=7)
    HeavyWeapons(6)=(typeClass=Class'EquipmentClasses.WeaponBurner')
    HeavyWeapons(7)=(typeClass=Class'EquipmentClasses.WeaponChaingun',quantity=300)

    Role=ROLE_Authority
    bNetNotify=true
    bAlwaysRelevant=false
    bOnlyDirtyReplication=false
    NetUpdateFrequency=1
    netPriority=20

    FriendlyName="Meta"
    Description="Mutator code: Meta_<version>.Mutator"
}
