import 'package:osrs_rng/features/activity_randomizer/activity_randomizer.dart';

enum ActivityPreset {
  skills,
  bosses,
  custom;

  String get label {
    switch (this) {
      case ActivityPreset.skills:
        return 'Skills';
      case ActivityPreset.bosses:
        return 'Bosses';
      case ActivityPreset.custom:
        return 'Custom';
    }
  }

  List<Activity> get activities {
    switch (this) {
      case ActivityPreset.skills:
        return const [
          Activity('Attack', 1),
          Activity('Strength', 1),
          Activity('Defence', 1),
          Activity('Ranged', 1),
          Activity('Prayer', 1),
          Activity('Magic', 1),
          Activity('Runecrafting', 1),
          Activity('Construction', 1),
          Activity('Hitpoints', 1),
          Activity('Agility', 1),
          Activity('Herblore', 1),
          Activity('Thieving', 1),
          Activity('Crafting', 1),
          Activity('Fletching', 1),
          Activity('Slayer', 1),
          Activity('Hunter', 1),
          Activity('Mining', 1),
          Activity('Smithing', 1),
          Activity('Fishing', 1),
          Activity('Cooking', 1),
          Activity('Firemaking', 1),
          Activity('Woodcutting', 1),
          Activity('Farming', 1),
        ];
      case ActivityPreset.bosses:
        return const [
          Activity('Grotesque Gruadians', 1),
          Activity('Abyssal Sire', 1),
          Activity('Kraken', 1),
          Activity('Cerberus', 1),
          Activity('Thermonuclear smoke devil', 1),
          Activity('Alchemical Hydra', 1),
          Activity('Chaos Fanatic', 1),
          Activity('Crazy archaeologist', 1),
          Activity('Scorpia', 1),
          Activity('King Black Dragon', 1),
          Activity('Chaos Elemental', 1),
          Activity('Vet\'ion', 1),
          Activity('Venenatis', 1),
          Activity('Callisto', 1),
          Activity('Obor', 1),
          Activity('Bryophyta', 1),
          Activity('The Mimic', 1),
          Activity('Hespori', 1),
          Activity('Skotizo', 1),
          Activity('Tempoross', 1),
          Activity('Wintertodt', 1),
          Activity('Zalcano', 1),
          Activity('Chambers of Xeric', 1),
          Activity('Theatre of Blood', 1),
          Activity('Tombs of Amascut', 1),
          Activity('Barbarian Assault', 1),
          Activity('The Gauntlet', 1),
          Activity('Fight Caves', 1),
          Activity('Inferno', 1),
          Activity('Barrows', 1),
          Activity('Rabbit', 1),
          Activity('Evil Chicken', 1),
          Activity('Giant Mole', 1),
          Activity('Deranged Archaeologist', 1),
          Activity('Dagannoth Kings', 1),
          Activity('Sarachnis', 1),
          Activity('Kalphite Queen', 1),
          Activity('Kree\'arra', 1),
          Activity('Commander Zilyana', 1),
          Activity('General Graardor', 1),
          Activity('K\'ril Tsutsaroth', 1),
          Activity('Zulrah', 1),
          Activity('Vorkath', 1),
          Activity('Corporeal Beast', 1),
          Activity('The Nightmare', 1),
          Activity('Nex', 1),
        ];
      case ActivityPreset.custom:
        return [];
    }
  }
}
