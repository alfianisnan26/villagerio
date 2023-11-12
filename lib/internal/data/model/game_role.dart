import 'package:flutter_gen/gen_l10n/lang.dart';
import 'package:villagerio/internal/data/enum/game_role_type.dart';
import 'package:villagerio/internal/data/model/game_event.dart';

class GameRole {
  final String id;
  final String? picUrl;
  final int point;
  final GameRoleType type;
  final bool isMultiple;

  final String Function(AppLang) getName;
  final String Function(AppLang) getDescription;
  final Function(GameEvent)? onEvent;

  const GameRole(this.id,
      {this.picUrl,
      this.point = 0,
      required this.type,
      required this.getName,
      required this.getDescription,
      this.isMultiple = false,
      this.onEvent});

  @override
  bool operator ==(Object other) {
    return id == (other as GameRole).id;
  }

  // ignore: unnecessary_overrides
  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return '{"id":"$id","picUrl":"${picUrl ?? ""}","point":$point,"type":"${type.name}"}';
  }

  // Each night, choose a player. That players is eliminated when a player gets their 2nd accusation the next day
  // Setiap malam, pilih seorang pemain. Pemain tersebut akan dieliminasi ketika pemain lain menuduhnya untuk kedua kalinya keesokan harinya.
  static final vampire = GameRole(
    "vampire",
    getName: (str) => str.vampire,
    getDescription: (str) => str.vampireDesc,
    type: GameRoleType.otherTeam,
    isMultiple: true,
    point: -7,
  );
  // The first night, wake up to see who the other Mason is
  // Pada malam pertama, bangunlah untuk melihat siapa Mason lainnya.
  static final mason = GameRole(
    "mason",
    getName: (str) => str.mason,
    getDescription: (str) => str.masonDesc,
    type: GameRoleType.villagerTeam,
    isMultiple: true,
    point: 2,
  );
  // Each night, wake with the other werewolves and choose a player to eliminate
  // Setiap malam, bangunlah bersama manusia serigala lainnya dan pilihlah seorang pemain untuk dieliminasi.
  static final werewolf = GameRole(
    "werewolf",
    getName: (str) => str.werewolf,
    getDescription: (str) => str.werewolfDesc,
    type: GameRoleType.werewolfTeam,
    isMultiple: true,
    point: -6,
  );
  // Find the werewolves and eliminate them through the voting.
  // Temukan manusia serigala dan eliminasi mereka melalui pemungutan suara.
  static final villager = GameRole(
    "villager",
    getName: (str) => str.villager,
    getDescription: (str) => str.villagerDesc,
    type: GameRoleType.villagerTeam,
    isMultiple: true,
    point: 1,
  );
  // Choose a player each night to see if that player is not Werewolf or Villager
  // Pilih seorang pemain setiap malam untuk melihat apakah pemain tersebut bukan Manusia.
  static final auraSeer = GameRole(
    "aura_seer",
    getName: (str) => str.auraSeer,
    getDescription: (str) => str.auraSeerDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // You may eliminate player at night once per game.
  // amu dapat mengeliminasi seorang pemain pada malam hari sekali permainan.
  static final huntress = GameRole(
    "huntress",
    getName: (str) => str.huntress,
    getDescription: (str) => str.huntressDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // One night per game, choose a player to be protected. That player may not be eliminated at night.
  // Sekali malam dalam satu permainan, pilih seorang pemain untuk dilindungi. Pemain tersebut tidak dapat dieliminasi pada malam tersebut.
  static final priest = GameRole(
    "priest",
    getName: (str) => str.priest,
    getDescription: (str) => str.priestDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // Each night you may point two players, and are told if those players are on the same team or not.
  // Setiap malam, kamu dapat menunjuk dua pemain, dan kamu akan diberitahu apakah pemain-pemain tersebut berada dalam tim yang sama atau tidak.
  static final mentalist = GameRole(
    "mentalist",
    getName: (str) => str.mentalist,
    getDescription: (str) => str.mentalistDesc,
    type: GameRoleType.villagerTeam,
    point: 6,
  );
  // Your vote counts twice.
  // Suaramu dihitung dua kali.
  static final mayor = GameRole(
    "mayor",
    getName: (str) => str.mayor,
    getDescription: (str) => str.mayorDesc,
    type: GameRoleType.villagerTeam,
    point: 2,
  );
  // If the Wereolves attempt to eliminate you, you are not eliminated until the following night.
  // Jika Manusia Serigala mencoba mengeliminasimu, kamu tidak akan dieliminasi sampai malam berikutnya.
  static final toughGuy = GameRole(
    "tough_guy",
    getName: (str) => str.toughGuy,
    getDescription: (str) => str.toughGuyDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // If you are eliminated, the players immediately to your left and right are eliminated as well.
  // Jika kamu dieliminasi, para pemain yang berada tepat di sebelah kirimu dan sebelah kananmu juga akan dieliminasi.
  static final madBomber = GameRole(
    "mad_bomber",
    getName: (str) => str.madBomber,
    getDescription: (str) => str.madBomberDesc,
    type: GameRoleType.villagerTeam,
    point: -2,
  );
  // They may not talk during the day at all, and if they do, automatically die during that night.
  // Mereka tidak boleh berbicara sama sekali selama siang hari, dan jika melakukannya, secara otomatis akan mati pada malam tersebut.
  static final drunk = GameRole(
    "drunk",
    getName: (str) => str.drunk,
    getDescription: (str) => str.drunkDesc,
    type: GameRoleType.villagerTeam,
    point: 4,
  );
  // Each night, choose a player who may not speak the following day.
  // Setiap malam, pilih seorang pemain yang tidak boleh berbicara pada hari berikutnya.
  static final spellcaster = GameRole(
    "spellcaster",
    getName: (str) => str.spellcaster,
    getDescription: (str) => str.spellcasterDesc,
    type: GameRoleType.villagerTeam,
    point: 1,
  );
  // The first night, choose two players to be linked together. If one of them is eliminated, the others is eliminated as well.
  // Pada malam pertama, pilih dua pemain untuk dihubungkan. Jika salah satunya dieliminasi, pemain lainnya juga akan dieliminasi.
  static final cupid = GameRole(
    "cupid",
    getName: (str) => str.cupid,
    getDescription: (str) => str.cupidDesc,
    type: GameRoleType.villagerTeam,
    point: -3,
  );
  // One night per game, choose a player. You'll be told if that players or one of his neighbors is a Werewolf.
  // Satu malam dalam satu permainan, pilih seorang pemain. Kamu akan diberitahu apakah pemain tersebut atau salah satu dari tetangganya adalah Manusia Serigala.
  static final privateInvestigator = GameRole(
    "private_investigator",
    getName: (str) => str.privateInvestigator,
    getDescription: (str) => str.privateInvestigatorDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // If you are voted to be eliminated, your role is revealed and you stay.
  // Jika kamu mendapatkan suara untuk dieliminasi, peranmu akan terungkap dan kamu tetap berada dalam permainan.
  static final prince = GameRole(
    "prince",
    getName: (str) => str.prince,
    getDescription: (str) => str.princeDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // Each night, point to a player and learn their exact role.
  // Setiap malam, tunjuk seorang pemain dan ketahui peran mereka dengan tepat.
  static final mysticSeer = GameRole(
    "mystic_seer",
    getName: (str) => str.mysticSeer,
    getDescription: (str) => str.mysticSeerDesc,
    type: GameRoleType.villagerTeam,
    point: 9,
  );
  // The first night, you are eliminated. Communicate to the players with single letters each day.
  // Pada malam pertama, kamu dieliminasi. Komunikasikan dengan pemain lain dengan menggunakan huruf tunggal setiap harinya.
  static final ghost = GameRole(
    "ghost",
    getName: (str) => str.ghost,
    getDescription: (str) => str.ghostDesc,
    type: GameRoleType.villagerTeam,
    point: 2,
  );
  // Each night, choose a player to leave the village during the next day.
  // Setiap malam, pilih seorang pemain untuk meninggalkan desa pada hari berikutnya.
  static final oldHag = GameRole(
    "old_hag",
    getName: (str) => str.oldHag,
    getDescription: (str) => str.oldHagDesc,
    type: GameRoleType.villagerTeam,
    point: 1,
  );
  // Each night you may point to a player. If that player is a Werewolf, he is eliminated. If he isn't, you are eliminated.
  // Setiap malam, kamu dapat menunjuk seorang pemain. Jika pemain tersebut adalah Manusia Serigala, dia akan dieliminasi. Jika bukan, kamu yang akan dieliminasi.
  static final revealer = GameRole(
    "revealer",
    getName: (str) => str.revealer,
    getDescription: (str) => str.revealerDesc,
    type: GameRoleType.villagerTeam,
    point: 4,
  );
  // You always vote players to be eliminated.
  // Kamu selalu memberikan suara untuk mengeliminasi pemain.
  static final villageIdiot = GameRole(
    "village_idiot",
    getName: (str) => str.villageIdiot,
    getDescription: (str) => str.villageIdiotDesc,
    type: GameRoleType.villagerTeam,
    point: 2,
  );
  // The first night, choose a player. When that player is eliminated you become that role.
  // Pada malam pertama, pilih seorang pemain. Ketika pemain tersebut dieliminasi, kamu akan mengambil peran sebagai pemain tersebut.
  static final doppelganger = GameRole(
    "doppelganger",
    getName: (str) => str.doppelganger,
    getDescription: (str) => str.doppelgangerDesc,
    type: GameRoleType.villagerTeam,
    point: -2,
  );
  // One night per game, stir up trouble by calling for players to be eliminated the following day.
  // Satu malam dalam satu permainan, timbulkan masalah dengan meminta pemain-pemain untuk dieliminasi pada hari berikutnya.
  static final troubleMaker = GameRole(
    "trouble_maker",
    getName: (str) => str.troubleMaker,
    getDescription: (str) => str.troubleMakerDesc,
    type: GameRoleType.villagerTeam,
    point: -3,
  );
  // You must always vote for players to not be eliminated.
  // Kamu selalu harus memberikan suara untuk mencegah pemain-pemain agar tidak dieliminasi.
  static final pacifist = GameRole(
    "pacifist",
    getName: (str) => str.pacifist,
    getDescription: (str) => str.pacifistDesc,
    type: GameRoleType.villagerTeam,
    point: -1,
  );
  // If the Seer is eliminated, you become the Seer, waking each night to look for Werewolves.
  // Jika Peramal (Seer) dieliminasi, kamu akan menjadi Peramal berikutnya, yang akan bangun setiap malam untuk mencari Manusia Serigala.
  static final apprenticeSeer = GameRole(
    "apprentice_seer",
    getName: (str) => str.apprenticeSeer,
    getDescription: (str) => str.apprenticeSeerDesc,
    type: GameRoleType.villagerTeam,
    point: 4,
  );
  // If you are eliminated, you may immediately eliminate another player.
  // Jika kamu dieliminasi, kamu dapat segera mengeliminasi pemain lain.
  static final hunter = GameRole(
    "hunter",
    getName: (str) => str.hunter,
    getDescription: (str) => str.hunterDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // You are a Villager, but appear to the Seer as a Werewolf.
  // Kamu adalah Penduduk Desa, tetapi terlihat oleh Peramal (Seer) sebagai Manusia Serigala.
  static final lycan = GameRole(
    "lycan",
    getName: (str) => str.lycan,
    getDescription: (str) => str.lycanDesc,
    type: GameRoleType.villagerTeam,
    point: -1,
  );
  // If you are eliminated by Werewolves, they don't get to eliminate anyone the following night.
  // Jika kamu dieliminasi oleh Manusia Serigala, mereka tidak dapat mengeliminasi siapapun pada malam berikutnya.
  static final diseased = GameRole(
    "diseased",
    getName: (str) => str.diseased,
    getDescription: (str) => str.diseasedDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // Each night, choose a player who cannot be eliminated that night, including yourself.
  // Setiap malam, pilih seorang pemain yang tidak dapat dieliminasi pada malam tersebut, termasuk dirimu sendiri.
  static final bodyguard = GameRole(
    "bodyguard",
    getName: (str) => str.bodyguard,
    getDescription: (str) => str.bodyguardDesc,
    type: GameRoleType.villagerTeam,
    point: 3,
  );
  // You may save or eliminate a player at night once each per game.
  // Kamu dapat menyelamatkan atau mengeliminasi seorang pemain pada malam hari sekali dalam satu permainan.
  static final witch = GameRole(
    "witch",
    getName: (str) => str.witch,
    getDescription: (str) => str.witchDesc,
    type: GameRoleType.villagerTeam,
    point: 4,
  );
  // Each night choose a player to learn if he is a Villager or a Werewolf.
  // Setiap malam, pilih seorang pemain untuk mengetahui apakah dia adalah Penduduk Desa atau Manusia Serigala.
  static final seer = GameRole(
    "seer",
    getName: (str) => str.seer,
    getDescription: (str) => str.seerDesc,
    type: GameRoleType.villagerTeam,
    point: 7,
  );

  // You are the Moderator for guiding the gameplay.
  // Kamu adalah Moderator untuk memandu permainan.
  static final moderator = GameRole(
    "moderator",
    getName: (str) => str.moderator,
    getDescription: (str) => str.moderatorDesc,
    type: GameRoleType.independent,
    point: 0,
  );

  // You hate your job and your life. You win if you are eliminated.
  // Kamu benci pekerjaanmu dan kehidupanmu. Kamu menang jika kamu dieliminasi.
  static final tanner = GameRole(
    "tanner",
    getName: (str) => str.tanner,
    getDescription: (str) => str.tannerDesc,
    type: GameRoleType.independent,
    point: -2,
  );

  // Each night, choose a player to join your cult. If all players are in your cult, you win.
  // Setiap malam, pilih seorang pemain untuk bergabung dengan kultusmu. Jika semua pemain bergabung dalam kultusmu, kamu menang.
  static final cultLeader = GameRole(
    "culd_leader",
    getName: (str) => str.cultLeader,
    getDescription: (str) => str.cultLeaderDesc,
    type: GameRoleType.independent,
    point: 1,
  );

  // Each night, wake with the Werewolves. If you are eliminated, the Werewolves wliminate two players the following night.
  // Setiap malam, bangunlah bersama Manusia Serigala. Jika kamu dieliminasi, Manusia Serigala akan mengeliminasi dua pemain pada malam berikutnya.
  static final wolfCub = GameRole(
    "wolf_cub",
    getName: (str) => str.wolfCub,
    getDescription: (str) => str.wolfCubDesc,
    type: GameRoleType.werewolfTeam,
    point: -8,
  );

  // You know who the werewolves are, but you do not wake up with them at night.
  // Kamu mengetahui siapa Manusia Serigala, tetapi kamu tidak bangun bersama mereka pada malam hari.
  static final minion = GameRole(
    "minion",
    getName: (str) => str.minion,
    getDescription: (str) => str.minionDesc,
    type: GameRoleType.werewolfTeam,
    point: -6,
  );

  // Each night, look for the Seer. You are on the werewolf team.
  // Setiap malam, carilah Peramal (Seer). Kamu berada dalam tim Manusia Serigala.
  static final sorceress = GameRole(
    "sorceress",
    getName: (str) => str.sorceress,
    getDescription: (str) => str.sorceressDesc,
    type: GameRoleType.werewolfTeam,
    point: -3,
  );

  // Each night, wake with the other Werewolves. You only win if you are the last player in the game.
  // Setiap malam, bangun bersama Manusia Serigala lainnya. Kamu hanya akan menang jika kamu menjadi pemain terakhir dalam permainan.
  static final loneWolf = GameRole(
    "lone_wolf",
    getName: (str) => str.loneWolf,
    getDescription: (str) => str.loneWolfDesc,
    type: GameRoleType.independent,
    point: -5,
  );

  // Choose two player on the first night. To win, they must be eliminated and you must still be in the game at the end of the game.
  // Pada malam pertama, pilih dua pemain. Untuk menang, kedua pemain yang dipilih harus dieliminasi, dan kamu harus tetap berada dalam permainan hingga akhir permainan.
  static final holdum = GameRole(
    "holdum",
    getName: (str) => str.holdum,
    getDescription: (str) => str.holdumDesc,
    type: GameRoleType.independent,
    point: 0,
  );

  // You are on the Villager team unless you are targeted for elimination by the Werewolves, at which time you become a Werewolf.
  // Kamu berada dalam tim Penduduk Desa kecuali jika kamu menjadi target eliminasi oleh Manusia Serigala, pada saat itu kamu akan menjadi seorang Manusia Serigala.
  static final cursed = GameRole(
    "cursed",
    getName: (str) => str.cursed,
    getDescription: (str) => str.cursedDesc,
    type: GameRoleType.villagerTeam,
    point: -3,
  );

  // Once per game, When a regular werewolf is eliminated by the village during the daytime voting, the Alpha Werewolf can choose to utilize their special power. Instead of the eliminated werewolf being completely removed from the game, the Alpha Werewolf can turn the targeted player into another werewolf, effectively converting them to join the werewolf team.
  static final alphaWerewolf = GameRole(
    "alpha_werewolf",
    getName: (str) => str.alphaWerewolf,
    getDescription: (str) => str.alphaWerewolfDesc,
    type: GameRoleType.werewolfTeam,
    point: -9,
  );

  static final List<GameRole> values = List<GameRole>.from([
    alphaWerewolf,
    cursed,
    holdum,
    loneWolf,
    sorceress,
    minion,
    wolfCub,
    cultLeader,
    tanner,
    moderator,
    seer,
    witch,
    bodyguard,
    diseased,
    lycan,
    hunter,
    apprenticeSeer,
    pacifist,
    troubleMaker,
    doppelganger,
    villageIdiot,
    revealer,
    oldHag,
    ghost,
    mysticSeer,
    prince,
    privateInvestigator,
    cupid,
    spellcaster,
    drunk,
    madBomber,
    toughGuy,
    mayor,
    mentalist,
    priest,
    huntress,
    auraSeer,
    villager,
    werewolf,
    mason,
    vampire,
  ], growable: false);
}

class GameRoleSelection {
  final GameRole role;
  final int selected;

  GameRoleSelection(this.role, this.selected);
}

class GameRoleStats {
  final GameRole role;
  bool isUserFavorite;
  int countFavorite;
  int countUsed;

  GameRoleStats(this.role,
      {this.isUserFavorite = false,
      this.countFavorite = 0,
      this.countUsed = 0});
}
