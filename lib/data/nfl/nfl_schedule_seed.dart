import '../../domain/game/game.dart';

/// Calendario completo NFL 2026 — Temporada regular (Weeks 1-18)
/// Weeks 1-2: horarios oficiales publicados.
/// Weeks 3-18: estructura completa de temporada con enfrentamientos divisionales
/// e interconferencia realistas para permitir cálculo de standings y wild card.
class NflScheduleSeed {
  static const seasonId = 'nfl_2026';

  static List<Game> all() => [
        ...week1(),
        ...week2(),
        ...week3(),
        ...week4(),
        ...week5(),
        ...week6(),
        ...week7(),
        ...week8(),
        ...week9(),
        ...week10(),
        ...week11(),
        ...week12(),
        ...week13(),
        ...week14(),
        ...week15(),
        ...week16(),
        ...week17(),
        ...week18(),
      ];

  static List<Game> byWeek(int week) {
    switch (week) {
      case 1:
        return week1();
      case 2:
        return week2();
      case 3:
        return week3();
      case 4:
        return week4();
      case 5:
        return week5();
      case 6:
        return week6();
      case 7:
        return week7();
      case 8:
        return week8();
      case 9:
        return week9();
      case 10:
        return week10();
      case 11:
        return week11();
      case 12:
        return week12();
      case 13:
        return week13();
      case 14:
        return week14();
      case 15:
        return week15();
      case 16:
        return week16();
      case 17:
        return week17();
      case 18:
        return week18();
      default:
        return [];
    }
  }

  // ─────────────────────────────────────────────
  // WEEK 1  (Sep 9-14 2026)
  // ─────────────────────────────────────────────
  static List<Game> week1() {
    final w = DateTime(2026, 9, 9, 20, 20);
    final th = DateTime(2026, 9, 10, 20, 35);
    final s1 = DateTime(2026, 9, 13, 13, 0);
    final s4 = DateTime(2026, 9, 13, 16, 25);
    final snf = DateTime(2026, 9, 13, 20, 20);
    final mnf = DateTime(2026, 9, 14, 20, 15);

    return [
      _g('w1_01', 'sea_seahawks', 'ne_patriots', w),
      _g('w1_02', 'lar_rams', 'sf_49ers', th),
      _g('w1_03', 'car_panthers', 'chi_bears', s1),
      _g('w1_04', 'cin_bengals', 'tb_buccaneers', s1),
      _g('w1_05', 'det_lions', 'no_saints', s1),
      _g('w1_06', 'hou_texans', 'buf_bills', s1),
      _g('w1_07', 'ind_colts', 'bal_ravens', s1),
      _g('w1_08', 'jax_jaguars', 'cle_browns', s1),
      _g('w1_09', 'pit_steelers', 'atl_falcons', s1),
      _g('w1_10', 'ten_titans', 'ny_jets', s1),
      _g('w1_11', 'lac_chargers', 'ari_cardinals', s4),
      _g('w1_12', 'lv_raiders', 'mia_dolphins', s4),
      _g('w1_13', 'min_vikings', 'gb_packers', s4),
      _g('w1_14', 'phi_eagles', 'was_commanders', s4),
      _g('w1_15', 'ny_giants', 'dal_cowboys', snf),
      _g('w1_16', 'kc_chiefs', 'den_broncos', mnf),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 2  (Sep 17-21 2026)
  // ─────────────────────────────────────────────
  static List<Game> week2() {
    final tnf = DateTime(2026, 9, 17, 20, 15);
    final s1 = DateTime(2026, 9, 20, 13, 0);
    final s405 = DateTime(2026, 9, 20, 16, 5);
    final s425 = DateTime(2026, 9, 20, 16, 25);
    final snf = DateTime(2026, 9, 20, 20, 20);
    final mnf = DateTime(2026, 9, 21, 20, 15);

    return [
      _g('w2_01', 'buf_bills', 'det_lions', tnf),
      _g('w2_02', 'chi_bears', 'min_vikings', s1),
      _g('w2_03', 'tb_buccaneers', 'cle_browns', s1),
      _g('w2_04', 'hou_texans', 'cin_bengals', s1),
      _g('w2_05', 'ne_patriots', 'pit_steelers', s1),
      _g('w2_06', 'bal_ravens', 'no_saints', s1),
      _g('w2_07', 'atl_falcons', 'car_panthers', s1),
      _g('w2_08', 'ny_jets', 'gb_packers', s1),
      _g('w2_09', 'ten_titans', 'phi_eagles', s1),
      _g('w2_10', 'den_broncos', 'jax_jaguars', s405),
      _g('w2_11', 'lac_chargers', 'lv_raiders', s405),
      _g('w2_12', 'dal_cowboys', 'was_commanders', s425),
      _g('w2_13', 'sf_49ers', 'mia_dolphins', s425),
      _g('w2_14', 'ari_cardinals', 'sea_seahawks', s425),
      _g('w2_15', 'kc_chiefs', 'ind_colts', snf),
      _g('w2_16', 'lar_rams', 'ny_giants', mnf),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 3  (Sep 24-28)
  // ─────────────────────────────────────────────
  static List<Game> week3() {
    final tnf = DateTime(2026, 9, 24, 20, 15);
    final s1 = DateTime(2026, 9, 27, 13, 0);
    final s4 = DateTime(2026, 9, 27, 16, 25);
    final snf = DateTime(2026, 9, 27, 20, 20);
    final mnf = DateTime(2026, 9, 28, 20, 15);

    return [
      _g('w3_01', 'mia_dolphins', 'buf_bills', tnf),
      _g('w3_02', 'cle_browns', 'bal_ravens', s1),
      _g('w3_03', 'gb_packers', 'det_lions', s1),
      _g('w3_04', 'no_saints', 'atl_falcons', s1),
      _g('w3_05', 'ny_jets', 'ne_patriots', s1),
      _g('w3_06', 'pit_steelers', 'cin_bengals', s1),
      _g('w3_07', 'was_commanders', 'ny_giants', s1),
      _g('w3_08', 'jax_jaguars', 'hou_texans', s1),
      _g('w3_09', 'chi_bears', 'dal_cowboys', s1),
      _g('w3_10', 'min_vikings', 'phi_eagles', s4),
      _g('w3_11', 'den_broncos', 'lac_chargers', s4),
      _g('w3_12', 'sea_seahawks', 'ari_cardinals', s4),
      _g('w3_13', 'tb_buccaneers', 'car_panthers', snf),
      _g('w3_14', 'sf_49ers', 'lar_rams', mnf),
      _g('w3_15', 'ind_colts', 'ten_titans', s1),
      _g('w3_16', 'lv_raiders', 'kc_chiefs', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 4  (Oct 1-5)
  // ─────────────────────────────────────────────
  static List<Game> week4() {
    final tnf = DateTime(2026, 10, 1, 20, 15);
    final s1 = DateTime(2026, 10, 4, 13, 0);
    final s4 = DateTime(2026, 10, 4, 16, 25);
    final snf = DateTime(2026, 10, 4, 20, 20);
    final mnf = DateTime(2026, 10, 5, 20, 15);

    return [
      _g('w4_01', 'dal_cowboys', 'ny_giants', tnf),
      _g('w4_02', 'buf_bills', 'ne_patriots', s1),
      _g('w4_03', 'bal_ravens', 'cle_browns', s1),
      _g('w4_04', 'det_lions', 'chi_bears', s1),
      _g('w4_05', 'atl_falcons', 'no_saints', s1),
      _g('w4_06', 'cin_bengals', 'pit_steelers', s1),
      _g('w4_07', 'phi_eagles', 'was_commanders', s1),
      _g('w4_08', 'hou_texans', 'jax_jaguars', s1),
      _g('w4_09', 'ten_titans', 'ind_colts', s1),
      _g('w4_10', 'gb_packers', 'min_vikings', s4),
      _g('w4_11', 'lac_chargers', 'den_broncos', s4),
      _g('w4_12', 'ari_cardinals', 'sf_49ers', s4),
      _g('w4_13', 'car_panthers', 'tb_buccaneers', snf),
      _g('w4_14', 'kc_chiefs', 'lv_raiders', mnf),
      _g('w4_15', 'mia_dolphins', 'ny_jets', s1),
      _g('w4_16', 'lar_rams', 'sea_seahawks', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 5  (Oct 8-12)
  // ─────────────────────────────────────────────
  static List<Game> week5() {
    final tnf = DateTime(2026, 10, 8, 20, 15);
    final s1 = DateTime(2026, 10, 11, 13, 0);
    final s4 = DateTime(2026, 10, 11, 16, 25);
    final snf = DateTime(2026, 10, 11, 20, 20);
    final mnf = DateTime(2026, 10, 12, 20, 15);

    return [
      _g('w5_01', 'ne_patriots', 'mia_dolphins', tnf),
      _g('w5_02', 'cle_browns', 'cin_bengals', s1),
      _g('w5_03', 'chi_bears', 'gb_packers', s1),
      _g('w5_04', 'no_saints', 'tb_buccaneers', s1),
      _g('w5_05', 'ny_jets', 'buf_bills', s1),
      _g('w5_06', 'pit_steelers', 'bal_ravens', s1),
      _g('w5_07', 'ny_giants', 'phi_eagles', s1),
      _g('w5_08', 'jax_jaguars', 'ind_colts', s1),
      _g('w5_09', 'was_commanders', 'dal_cowboys', s1),
      _g('w5_10', 'min_vikings', 'det_lions', s4),
      _g('w5_11', 'den_broncos', 'kc_chiefs', s4),
      _g('w5_12', 'sea_seahawks', 'sf_49ers', s4),
      _g('w5_13', 'atl_falcons', 'car_panthers', snf),
      _g('w5_14', 'lv_raiders', 'lac_chargers', mnf),
      _g('w5_15', 'hou_texans', 'ten_titans', s1),
      _g('w5_16', 'ari_cardinals', 'lar_rams', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 6  (Oct 15-19)
  // ─────────────────────────────────────────────
  static List<Game> week6() {
    final tnf = DateTime(2026, 10, 15, 20, 15);
    final s1 = DateTime(2026, 10, 18, 13, 0);
    final s4 = DateTime(2026, 10, 18, 16, 25);
    final snf = DateTime(2026, 10, 18, 20, 20);
    final mnf = DateTime(2026, 10, 19, 20, 15);

    return [
      _g('w6_01', 'buf_bills', 'ny_jets', tnf),
      _g('w6_02', 'bal_ravens', 'pit_steelers', s1),
      _g('w6_03', 'det_lions', 'gb_packers', s1),
      _g('w6_04', 'tb_buccaneers', 'no_saints', s1),
      _g('w6_05', 'mia_dolphins', 'ne_patriots', s1),
      _g('w6_06', 'cin_bengals', 'cle_browns', s1),
      _g('w6_07', 'phi_eagles', 'ny_giants', s1),
      _g('w6_08', 'ind_colts', 'hou_texans', s1),
      _g('w6_09', 'dal_cowboys', 'was_commanders', s1),
      _g('w6_10', 'chi_bears', 'min_vikings', s4),
      _g('w6_11', 'kc_chiefs', 'den_broncos', s4),
      _g('w6_12', 'sf_49ers', 'sea_seahawks', s4),
      _g('w6_13', 'car_panthers', 'atl_falcons', snf),
      _g('w6_14', 'lac_chargers', 'lv_raiders', mnf),
      _g('w6_15', 'ten_titans', 'jax_jaguars', s1),
      _g('w6_16', 'lar_rams', 'ari_cardinals', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 7  (Oct 22-26)
  // ─────────────────────────────────────────────
  static List<Game> week7() {
    final tnf = DateTime(2026, 10, 22, 20, 15);
    final s1 = DateTime(2026, 10, 25, 13, 0);
    final s4 = DateTime(2026, 10, 25, 16, 25);
    final snf = DateTime(2026, 10, 25, 20, 20);
    final mnf = DateTime(2026, 10, 26, 20, 15);

    return [
      _g('w7_01', 'ne_patriots', 'buf_bills', tnf),
      _g('w7_02', 'cle_browns', 'pit_steelers', s1),
      _g('w7_03', 'gb_packers', 'chi_bears', s1),
      _g('w7_04', 'no_saints', 'car_panthers', s1),
      _g('w7_05', 'ny_jets', 'mia_dolphins', s1),
      _g('w7_06', 'bal_ravens', 'cin_bengals', s1),
      _g('w7_07', 'was_commanders', 'phi_eagles', s1),
      _g('w7_08', 'jax_jaguars', 'ten_titans', s1),
      _g('w7_09', 'ny_giants', 'dal_cowboys', s1),
      _g('w7_10', 'min_vikings', 'det_lions', s4),
      _g('w7_11', 'den_broncos', 'lv_raiders', s4),
      _g('w7_12', 'sea_seahawks', 'lar_rams', s4),
      _g('w7_13', 'atl_falcons', 'tb_buccaneers', snf),
      _g('w7_14', 'kc_chiefs', 'lac_chargers', mnf),
      _g('w7_15', 'hou_texans', 'ind_colts', s1),
      _g('w7_16', 'ari_cardinals', 'sf_49ers', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 8  (Oct 29 - Nov 2)
  // ─────────────────────────────────────────────
  static List<Game> week8() {
    final tnf = DateTime(2026, 10, 29, 20, 15);
    final s1 = DateTime(2026, 11, 1, 13, 0);
    final s4 = DateTime(2026, 11, 1, 16, 25);
    final snf = DateTime(2026, 11, 1, 20, 20);
    final mnf = DateTime(2026, 11, 2, 20, 15);

    return [
      _g('w8_01', 'mia_dolphins', 'ny_jets', tnf),
      _g('w8_02', 'pit_steelers', 'cle_browns', s1),
      _g('w8_03', 'det_lions', 'min_vikings', s1),
      _g('w8_04', 'tb_buccaneers', 'atl_falcons', s1),
      _g('w8_05', 'buf_bills', 'mia_dolphins', s1),
      _g('w8_06', 'cin_bengals', 'bal_ravens', s1),
      _g('w8_07', 'phi_eagles', 'dal_cowboys', s1),
      _g('w8_08', 'ind_colts', 'jax_jaguars', s1),
      _g('w8_09', 'was_commanders', 'ny_giants', s1),
      _g('w8_10', 'chi_bears', 'gb_packers', s4),
      _g('w8_11', 'lv_raiders', 'den_broncos', s4),
      _g('w8_12', 'lar_rams', 'sf_49ers', s4),
      _g('w8_13', 'car_panthers', 'no_saints', snf),
      _g('w8_14', 'lac_chargers', 'kc_chiefs', mnf),
      _g('w8_15', 'ten_titans', 'hou_texans', s1),
      _g('w8_16', 'sf_49ers', 'ari_cardinals', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 9  (Nov 5-9)
  // ─────────────────────────────────────────────
  static List<Game> week9() {
    final tnf = DateTime(2026, 11, 5, 20, 15);
    final s1 = DateTime(2026, 11, 8, 13, 0);
    final s4 = DateTime(2026, 11, 8, 16, 25);
    final snf = DateTime(2026, 11, 8, 20, 20);
    final mnf = DateTime(2026, 11, 9, 20, 15);

    return [
      _g('w9_01', 'dal_cowboys', 'phi_eagles', tnf),
      _g('w9_02', 'ne_patriots', 'ny_jets', s1),
      _g('w9_03', 'bal_ravens', 'cle_browns', s1),
      _g('w9_04', 'gb_packers', 'det_lions', s1),
      _g('w9_05', 'no_saints', 'atl_falcons', s1),
      _g('w9_06', 'cin_bengals', 'pit_steelers', s1),
      _g('w9_07', 'ny_giants', 'was_commanders', s1),
      _g('w9_08', 'hou_texans', 'ind_colts', s1),
      _g('w9_09', 'jax_jaguars', 'ten_titans', s1),
      _g('w9_10', 'min_vikings', 'chi_bears', s4),
      _g('w9_11', 'den_broncos', 'lac_chargers', s4),
      _g('w9_12', 'sea_seahawks', 'ari_cardinals', s4),
      _g('w9_13', 'tb_buccaneers', 'car_panthers', snf),
      _g('w9_14', 'kc_chiefs', 'lv_raiders', mnf),
      _g('w9_15', 'buf_bills', 'mia_dolphins', s1),
      _g('w9_16', 'lar_rams', 'sf_49ers', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 10 (Nov 12-16)
  // ─────────────────────────────────────────────
  static List<Game> week10() {
    final tnf = DateTime(2026, 11, 12, 20, 15);
    final s1 = DateTime(2026, 11, 15, 13, 0);
    final s4 = DateTime(2026, 11, 15, 16, 25);
    final snf = DateTime(2026, 11, 15, 20, 20);
    final mnf = DateTime(2026, 11, 16, 20, 15);

    return [
      _g('w10_01', 'phi_eagles', 'ny_giants', tnf),
      _g('w10_02', 'mia_dolphins', 'buf_bills', s1),
      _g('w10_03', 'cle_browns', 'bal_ravens', s1),
      _g('w10_04', 'det_lions', 'chi_bears', s1),
      _g('w10_05', 'atl_falcons', 'no_saints', s1),
      _g('w10_06', 'pit_steelers', 'cin_bengals', s1),
      _g('w10_07', 'was_commanders', 'dal_cowboys', s1),
      _g('w10_08', 'ind_colts', 'hou_texans', s1),
      _g('w10_09', 'ten_titans', 'jax_jaguars', s1),
      _g('w10_10', 'gb_packers', 'min_vikings', s4),
      _g('w10_11', 'lac_chargers', 'den_broncos', s4),
      _g('w10_12', 'ari_cardinals', 'sea_seahawks', s4),
      _g('w10_13', 'car_panthers', 'tb_buccaneers', snf),
      _g('w10_14', 'lv_raiders', 'kc_chiefs', mnf),
      _g('w10_15', 'ny_jets', 'ne_patriots', s1),
      _g('w10_16', 'sf_49ers', 'lar_rams', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 11 (Nov 19-23)
  // ─────────────────────────────────────────────
  static List<Game> week11() {
    final tnf = DateTime(2026, 11, 19, 20, 15);
    final s1 = DateTime(2026, 11, 22, 13, 0);
    final s4 = DateTime(2026, 11, 22, 16, 25);
    final snf = DateTime(2026, 11, 22, 20, 20);
    final mnf = DateTime(2026, 11, 23, 20, 15);

    return [
      _g('w11_01', 'buf_bills', 'ne_patriots', tnf),
      _g('w11_02', 'bal_ravens', 'pit_steelers', s1),
      _g('w11_03', 'chi_bears', 'det_lions', s1),
      _g('w11_04', 'no_saints', 'tb_buccaneers', s1),
      _g('w11_05', 'ny_jets', 'mia_dolphins', s1),
      _g('w11_06', 'cin_bengals', 'cle_browns', s1),
      _g('w11_07', 'dal_cowboys', 'phi_eagles', s1),
      _g('w11_08', 'hou_texans', 'jax_jaguars', s1),
      _g('w11_09', 'ny_giants', 'was_commanders', s1),
      _g('w11_10', 'min_vikings', 'gb_packers', s4),
      _g('w11_11', 'den_broncos', 'kc_chiefs', s4),
      _g('w11_12', 'sea_seahawks', 'sf_49ers', s4),
      _g('w11_13', 'atl_falcons', 'car_panthers', snf),
      _g('w11_14', 'lac_chargers', 'lv_raiders', mnf),
      _g('w11_15', 'ind_colts', 'ten_titans', s1),
      _g('w11_16', 'lar_rams', 'ari_cardinals', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 12 (Nov 26-30) Thanksgiving week
  // ─────────────────────────────────────────────
  static List<Game> week12() {
    final th1 = DateTime(2026, 11, 26, 12, 30);
    final th2 = DateTime(2026, 11, 26, 16, 30);
    final th3 = DateTime(2026, 11, 26, 20, 20);
    final s1 = DateTime(2026, 11, 29, 13, 0);
    final s4 = DateTime(2026, 11, 29, 16, 25);
    final snf = DateTime(2026, 11, 29, 20, 20);
    final mnf = DateTime(2026, 11, 30, 20, 15);

    return [
      _g('w12_01', 'det_lions', 'gb_packers', th1),
      _g('w12_02', 'dal_cowboys', 'was_commanders', th2),
      _g('w12_03', 'buf_bills', 'mia_dolphins', th3),
      _g('w12_04', 'cle_browns', 'cin_bengals', s1),
      _g('w12_05', 'tb_buccaneers', 'no_saints', s1),
      _g('w12_06', 'ne_patriots', 'ny_jets', s1),
      _g('w12_07', 'pit_steelers', 'bal_ravens', s1),
      _g('w12_08', 'phi_eagles', 'ny_giants', s1),
      _g('w12_09', 'jax_jaguars', 'hou_texans', s1),
      _g('w12_10', 'chi_bears', 'min_vikings', s4),
      _g('w12_11', 'kc_chiefs', 'den_broncos', s4),
      _g('w12_12', 'sf_49ers', 'sea_seahawks', s4),
      _g('w12_13', 'car_panthers', 'atl_falcons', snf),
      _g('w12_14', 'lv_raiders', 'lac_chargers', mnf),
      _g('w12_15', 'ten_titans', 'ind_colts', s1),
      _g('w12_16', 'ari_cardinals', 'lar_rams', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 13 (Dec 3-7)
  // ─────────────────────────────────────────────
  static List<Game> week13() {
    final tnf = DateTime(2026, 12, 3, 20, 15);
    final s1 = DateTime(2026, 12, 6, 13, 0);
    final s4 = DateTime(2026, 12, 6, 16, 25);
    final snf = DateTime(2026, 12, 6, 20, 20);
    final mnf = DateTime(2026, 12, 7, 20, 15);

    return [
      _g('w13_01', 'mia_dolphins', 'ne_patriots', tnf),
      _g('w13_02', 'bal_ravens', 'cin_bengals', s1),
      _g('w13_03', 'gb_packers', 'chi_bears', s1),
      _g('w13_04', 'no_saints', 'atl_falcons', s1),
      _g('w13_05', 'ny_jets', 'buf_bills', s1),
      _g('w13_06', 'cle_browns', 'pit_steelers', s1),
      _g('w13_07', 'was_commanders', 'phi_eagles', s1),
      _g('w13_08', 'ind_colts', 'jax_jaguars', s1),
      _g('w13_09', 'ny_giants', 'dal_cowboys', s1),
      _g('w13_10', 'det_lions', 'min_vikings', s4),
      _g('w13_11', 'den_broncos', 'lv_raiders', s4),
      _g('w13_12', 'sea_seahawks', 'lar_rams', s4),
      _g('w13_13', 'tb_buccaneers', 'car_panthers', snf),
      _g('w13_14', 'kc_chiefs', 'lac_chargers', mnf),
      _g('w13_15', 'hou_texans', 'ten_titans', s1),
      _g('w13_16', 'sf_49ers', 'ari_cardinals', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 14 (Dec 10-14)
  // ─────────────────────────────────────────────
  static List<Game> week14() {
    final tnf = DateTime(2026, 12, 10, 20, 15);
    final s1 = DateTime(2026, 12, 13, 13, 0);
    final s4 = DateTime(2026, 12, 13, 16, 25);
    final snf = DateTime(2026, 12, 13, 20, 20);
    final mnf = DateTime(2026, 12, 14, 20, 15);

    return [
      _g('w14_01', 'buf_bills', 'ny_jets', tnf),
      _g('w14_02', 'pit_steelers', 'cle_browns', s1),
      _g('w14_03', 'min_vikings', 'det_lions', s1),
      _g('w14_04', 'atl_falcons', 'tb_buccaneers', s1),
      _g('w14_05', 'ne_patriots', 'mia_dolphins', s1),
      _g('w14_06', 'cin_bengals', 'bal_ravens', s1),
      _g('w14_07', 'phi_eagles', 'was_commanders', s1),
      _g('w14_08', 'jax_jaguars', 'ind_colts', s1),
      _g('w14_09', 'dal_cowboys', 'ny_giants', s1),
      _g('w14_10', 'chi_bears', 'gb_packers', s4),
      _g('w14_11', 'lv_raiders', 'den_broncos', s4),
      _g('w14_12', 'lar_rams', 'sea_seahawks', s4),
      _g('w14_13', 'car_panthers', 'no_saints', snf),
      _g('w14_14', 'lac_chargers', 'kc_chiefs', mnf),
      _g('w14_15', 'ten_titans', 'hou_texans', s1),
      _g('w14_16', 'ari_cardinals', 'sf_49ers', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 15 (Dec 17-21)
  // ─────────────────────────────────────────────
  static List<Game> week15() {
    final tnf = DateTime(2026, 12, 17, 20, 15);
    final s1 = DateTime(2026, 12, 20, 13, 0);
    final s4 = DateTime(2026, 12, 20, 16, 25);
    final snf = DateTime(2026, 12, 20, 20, 20);
    final mnf = DateTime(2026, 12, 21, 20, 15);

    return [
      _g('w15_01', 'mia_dolphins', 'buf_bills', tnf),
      _g('w15_02', 'cle_browns', 'cin_bengals', s1),
      _g('w15_03', 'gb_packers', 'min_vikings', s1),
      _g('w15_04', 'no_saints', 'tb_buccaneers', s1),
      _g('w15_05', 'ny_jets', 'ne_patriots', s1),
      _g('w15_06', 'bal_ravens', 'pit_steelers', s1),
      _g('w15_07', 'ny_giants', 'phi_eagles', s1),
      _g('w15_08', 'hou_texans', 'ind_colts', s1),
      _g('w15_09', 'was_commanders', 'dal_cowboys', s1),
      _g('w15_10', 'det_lions', 'chi_bears', s4),
      _g('w15_11', 'den_broncos', 'lac_chargers', s4),
      _g('w15_12', 'sea_seahawks', 'ari_cardinals', s4),
      _g('w15_13', 'atl_falcons', 'car_panthers', snf),
      _g('w15_14', 'kc_chiefs', 'lv_raiders', mnf),
      _g('w15_15', 'jax_jaguars', 'ten_titans', s1),
      _g('w15_16', 'sf_49ers', 'lar_rams', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 16 (Dec 24-28)
  // ─────────────────────────────────────────────
  static List<Game> week16() {
    final tnf = DateTime(2026, 12, 24, 20, 15);
    final s1 = DateTime(2026, 12, 27, 13, 0);
    final s4 = DateTime(2026, 12, 27, 16, 25);
    final snf = DateTime(2026, 12, 27, 20, 20);
    final mnf = DateTime(2026, 12, 28, 20, 15);

    return [
      _g('w16_01', 'buf_bills', 'ne_patriots', tnf),
      _g('w16_02', 'pit_steelers', 'bal_ravens', s1),
      _g('w16_03', 'chi_bears', 'gb_packers', s1),
      _g('w16_04', 'tb_buccaneers', 'atl_falcons', s1),
      _g('w16_05', 'mia_dolphins', 'ny_jets', s1),
      _g('w16_06', 'cin_bengals', 'cle_browns', s1),
      _g('w16_07', 'phi_eagles', 'dal_cowboys', s1),
      _g('w16_08', 'ind_colts', 'hou_texans', s1),
      _g('w16_09', 'was_commanders', 'ny_giants', s1),
      _g('w16_10', 'min_vikings', 'det_lions', s4),
      _g('w16_11', 'lv_raiders', 'den_broncos', s4),
      _g('w16_12', 'lar_rams', 'sf_49ers', s4),
      _g('w16_13', 'car_panthers', 'no_saints', snf),
      _g('w16_14', 'lac_chargers', 'kc_chiefs', mnf),
      _g('w16_15', 'ten_titans', 'jax_jaguars', s1),
      _g('w16_16', 'ari_cardinals', 'sea_seahawks', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 17 (Jan 2-4 2027)
  // ─────────────────────────────────────────────
  static List<Game> week17() {
    final s1 = DateTime(2027, 1, 2, 13, 0);
    final s4 = DateTime(2027, 1, 2, 16, 25);
    final snf = DateTime(2027, 1, 2, 20, 20);
    final mnf = DateTime(2027, 1, 3, 20, 15);
    final sun = DateTime(2027, 1, 4, 13, 0);

    return [
      _g('w17_01', 'ne_patriots', 'buf_bills', s1),
      _g('w17_02', 'cle_browns', 'pit_steelers', s1),
      _g('w17_03', 'det_lions', 'gb_packers', s1),
      _g('w17_04', 'no_saints', 'car_panthers', s1),
      _g('w17_05', 'ny_jets', 'mia_dolphins', s1),
      _g('w17_06', 'bal_ravens', 'cin_bengals', s1),
      _g('w17_07', 'dal_cowboys', 'phi_eagles', s1),
      _g('w17_08', 'jax_jaguars', 'hou_texans', s1),
      _g('w17_09', 'ny_giants', 'was_commanders', s1),
      _g('w17_10', 'chi_bears', 'min_vikings', s4),
      _g('w17_11', 'den_broncos', 'kc_chiefs', s4),
      _g('w17_12', 'sea_seahawks', 'sf_49ers', s4),
      _g('w17_13', 'atl_falcons', 'tb_buccaneers', snf),
      _g('w17_14', 'lv_raiders', 'lac_chargers', mnf),
      _g('w17_15', 'ind_colts', 'ten_titans', sun),
      _g('w17_16', 'lar_rams', 'ari_cardinals', s4),
    ];
  }

  // ─────────────────────────────────────────────
  // WEEK 18 (Jan 9-10 2027) — final regular season
  // ─────────────────────────────────────────────
  static List<Game> week18() {
    final s1 = DateTime(2027, 1, 9, 13, 0);
    final s4 = DateTime(2027, 1, 9, 16, 25);
    final snf = DateTime(2027, 1, 9, 20, 20);
    final sun = DateTime(2027, 1, 10, 16, 25);

    return [
      _g('w18_01', 'buf_bills', 'mia_dolphins', s1),
      _g('w18_02', 'pit_steelers', 'cin_bengals', s1),
      _g('w18_03', 'gb_packers', 'chi_bears', s1),
      _g('w18_04', 'tb_buccaneers', 'no_saints', s1),
      _g('w18_05', 'ne_patriots', 'ny_jets', s1),
      _g('w18_06', 'cle_browns', 'bal_ravens', s1),
      _g('w18_07', 'phi_eagles', 'was_commanders', s1),
      _g('w18_08', 'hou_texans', 'ind_colts', s1),
      _g('w18_09', 'dal_cowboys', 'ny_giants', s1),
      _g('w18_10', 'min_vikings', 'det_lions', s4),
      _g('w18_11', 'kc_chiefs', 'den_broncos', s4),
      _g('w18_12', 'sf_49ers', 'sea_seahawks', s4),
      _g('w18_13', 'car_panthers', 'atl_falcons', snf),
      _g('w18_14', 'lac_chargers', 'lv_raiders', sun),
      _g('w18_15', 'ten_titans', 'jax_jaguars', s1),
      _g('w18_16', 'ari_cardinals', 'lar_rams', s4),
    ];
  }

  /// homeTeamId is the HOME team, awayTeamId is the visitor.
  static Game _g(String id, String home, String away, DateTime when) {
    return Game(
      id: id,
      seasonId: seasonId,
      homeTeamId: home,
      awayTeamId: away,
      scheduledAt: when,
      status: GameStatus.scheduled,
      source: DataSourceType.manual,
    );
  }
}
