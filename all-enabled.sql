-- 1. Buildings
-- 1.1. No Prereq Techs
UPDATE Buildings SET PrereqTech = NULL;
-- 1.2. No Prereq Civics
UPDATE Buildings SET PrereqCivic = NULL;
-- 1.2. Cost 1 production
UPDATE Buildings SET Cost = 1;
-- 1.3. No obsolete Era (Wonders can be built at all Start Era)
UPDATE Buildings SET ObsoleteEra = 'NO_ERA';
-- 1.4. No TraitType (all players can build unique buildings)
UPDATE Buildings SET TraitType = NULL;
-- 1.5. No Building Replace (Ex: Film Studio does not replace Broadcast Center, just in case there is trouble with Removing TraitType)
DELETE FROM BuildingReplaces;
-- 1.6. No Building Prereqs (Ex: University can be built without Library)
DELETE FROM BuildingPrereqs;
-- 1.7. No Feature Requirements (Ex: Chichen Itza no longer requires Jungle)
DELETE FROM Building_RequiredFeatures;
-- 1.8. No Terrain Requirements (Ex: Alhambra no longer requires Hills)
DELETE FROM Building_ValidTerrains;
-- 1.9. Granary grants 1000 yields per turn (you can change the BuildingType if needed)
INSERT OR REPLACE INTO Building_YieldChanges(BuildingType, YieldType, YieldChange) SELECT 'BUILDING_GRANARY', YieldType, 1000 FROM Yields;
-- 1.10. Granry grants 1000 housing, 1000 Entertainment, 1000 Defense HP
UPDATE Buildings SET Housing = 1000, Entertainment = 1000, OuterDefenseHitPoints = 1000 WHERE BuildingType = 'BUILDING_GRANARY';
-- 1.11. Buildings with Regional Range increases to 100000
UPDATE Buildings SET RegionalRange = 100000 WHERE RegionalRange > 0;

-- 2. Districts
-- 2.1. No Prereq Tech
UPDATE Districts SET PrereqTech = NULL;
-- 2.2. No Prereq Civics
UPDATE Districts SET PrereqCivic = NULL;
-- 2.3.a Cost 1 Production
UPDATE Districts SET Cost = 1;
-- 2.3.b No Progression Cost (next build does not increase cost)
UPDATE Districts SET CostProgressionParam1 = 0;
-- 2.4. Does not require/cost Population
UPDATE Districts SET RequiresPopulation = 0;
-- 2.5. No Trait Type (can be built by all players/no unique)
UPDATE Districts SET TraitType = NULL;
-- 2.6. No Replacement (should use with No TraitType to prevent problem of same replacement District)
DELETE FROM DistrictReplaces;
-- 2.7. No Feature requirements (Ex: Mbanza can be built anywhere, be careful with Dam)
DELETE FROM District_RequiredFeatures;
-- 2.8. No Terrain requirements (Ex: Acropolis can be built anywhere)
DELETE FROM District_ValidTerrains;
-- 2.9. GPP from Districts are 1000 per turns
UPDATE District_GreatPersonPoints SET PointsPerTurn = 1000;
-- 2.10. All Districts can be rushed 100% by Builders
INSERT OR REPLACE INTO District_BuildChargeProductions(DistrictType, UnitType, PercentProductionPerCharge) SELECT DistrictType, 'UNIT_BUILDER', 100 FROM Districts;

-- 3. Technologies
-- 3.1. Pottery Cost 1 Science (to prevent messing up UI)
UPDATE Technologies SET Cost = 1 WHERE TechnologyType = 'TECH_POTTERY';
-- 3.2. No Prereq (All technologies can be researched immediately)
DELETE FROM TechnologyPrereqs;
-- 3.3. All bonuses unlocked by Pottery (Ex: Embarkment, Spy Slot, etc.)
UPDATE OR IGNORE TechnologyModifiers SET TechnologyType = 'TECH_POTTERY';

-- 4. Civics
-- 4.1. Law of Code cost 1 Culture (to prevent messing up UI)
UPDATE Civics SET Cost = 1 WHERE CivicType = 'CIVIC_CODE_OF_LAWS';
-- 4.2. No Prereq (All civics can be researched immediately)
DELETE FROM CivicPrereqs;
-- 4.3. All bonuses unlocked by Code of Law (Ex: Governor Promotion, Spy Slot, etc.)
UPDATE OR IGNORE CivicModifiers SET CivicType = 'CIVIC_CODE_OF_LAWS';

-- 5. Units
-- 5.1.a. Cost 1 Production
UPDATE Units SET Cost = 1;
-- 5.1.b. No Cost Progression (further version does not increase cost)
UPDATE Units SET CostProgressionParam1 = 0;
-- 5.1.c. No Resource Cost, ignored by GS
UPDATE Units SET StrategicResource = NULL;
-- 5.1.d. No Gold Maintenance
UPDATE Units SET Maintenance = 0;
-- 5.1.e. No Resource Maintenance and Cost, for GS only
UPDATE Units_XP2 SET ResourceMaintenanceAmount = 0, ResourceCost = 0;
-- 5.2. No Population Cost (Settler can be built in 1-pop city)
UPDATE Units SET PopulationCost = NULL, PrereqPopulation = NULL;
-- 5.3. No Prereq Tech (should use with 5.5)
UPDATE Units SET PrereqTech = NULL;
-- 5.4. No Prereq Civic (should use with 5.5)
UPDATE Units SET PrereqCivic = NULL;
-- 5.5.a. No Unit Upgrades (Ex: can build Warrior + Swordman, useful for 5.3 and 5.4)
DELETE FROM UnitUpgrades;
-- 5.5.b. No Obsolete (Ex: Warrior after Gunpowder, Battering Ram after , useful for 5.3 and 5.4)
UPDATE Units SET MandatoryObsoleteTech = NULL, MandatoryObsoleteCivic = NULL;
-- 5.6. No Trait Type (no more unique units, all players can build, should use with 5.7)
UPDATE Units SET TraitType = NULL;
-- 5.7. No Unit Replacements (Ex: can build both Hoplite and Spearman, useful for 5.6)
DELETE FROM UnitReplaces;
-- 5.8.a. Units with charges have 999 charges (except National Park)
UPDATE Units SET BuildCharges = 999 WHERE BuildCharges > 0;
-- 5.8.b. Units with National Park charges have 999 charges
UPDATE Units SET ParkCharges = 999 WHERE ParkCharges > 0;
-- 5.9. All units start with 1 Promotion
UPDATE Units SET InitialLevel = 2;
-- 5.10. All have 10 Movement Point
UPDATE Units SET BaseMoves = 10;
-- 5.11. All have 10 Sight Range
UPDATE Units SET BaseSightRange = 10;

-- 6. Governments
-- 6.1. No Required Policy
UPDATE Governments SET PolicyToUnlock = NULL, PrereqCivic = NULL;
-- 6.2. 999 Influence per turn
UPDATE Governments SET InfluencePointsPerTurn = 999;
-- 6.3. 999 Favor per turn (GS only)
UPDATE Governments_XP2 SET Favor = 999;

-- 7. Governors
-- 7.1. No Trait Type (every Civ can have Ibrahim)
UPDATE Governors SET TraitType = NULL;
-- 7.2. Established in 0 turn (immediately)
UPDATE GlobalParameters SET Value = 0 WHERE Name='GOVERNOR_BASE_TURNS_TO_ESTABLISH';
UPDATE Governors SET TransitionStrength = 100;

-- 8. Improvements
-- 8.1. No Prereq Tech
UPDATE Improvements SET PrereqTech = NULL;
-- 8.2. No Prereq Civic
UPDATE Improvements SET PrereqCivic = NULL;
-- 8.3. No Trait Type (no unique, everyone can build, including Fishery)
UPDATE Improvements SET TraitType = NULL;
-- 8.4. Improvements can be built anywhere on land
INSERT OR REPLACE INTO Improvement_ValidTerrains(ImprovementType, TerrainType, PrereqTech, PrereqCivic) SELECT ImprovementType, TerrainType, NULL, NULL FROM Improvements, Terrains WHERE Water = 0;
-- 8.5. Builder can build everything
UPDATE Improvements SET Buildable = 1;
INSERT OR IGNORE INTO Improvement_ValidBuildUnits(ImprovementType, UnitType) SELECT ImprovementType, 'UNIT_BUILDER' FROM Improvements;
-- 8.6. No Invalid Adjacent Feature (Ex: Moai can be built next to Jungle)
DELETE FROM Improvement_InvalidAdjacentFeatures;

-- 9. Policies
-- 9.1. All Policies unlocks at Code of Laws
UPDATE Policies SET PrereqCivic = 'CIVIC_CODE_OF_LAWS';
-- 9.2. No Government Requirements (Ex: New Deal does not require Democracy), require GS
DELETE FROM Policy_GovernmentExclusives_XP2;
-- 9.3. No Dark Age Requirements (Ex: Monasticism can be equipped anywhere), require R&F
DELETE FROM Policies_XP1;

-- 10. Projects
-- 10.1.a. Cost 1 Production
UPDATE Projects SET Cost = 1;
-- 10.1.b. No Progression Cost
UPDATE Projects SET CostProgressionParam1 = 0;
-- 10.1.c. No Resource Cost (Vanilla and R&F)
UPDATE Projects SET PrereqResource = NULL;
-- 10.1.d. No Resource Cost (GS)
DELETE FROM Project_ResourceCosts;
-- 10.2. No Prereq Tech
UPDATE Projects SET PrereqTech = NULL;
-- 10.3. No Prereq Civic
UPDATE Projects SET PrereqCivic = NULL;
-- 10.4. No District Requirements
UPDATE Projects SET PrereqDistrict = NULL;