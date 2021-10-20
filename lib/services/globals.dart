import 'package:flutter_ledger/services/models.dart';
import 'services.dart';

/// Static global state.
class Global {
  // Services

  // Data Models
  static final Map models = {
    Report: (data) => Report.fromMap(data()),
    History: (data) => History.fromMap(data()),
    Game: (data) => Game.fromMap(data()),
    Owes: (data) => Owes.fromMap(data()),
    Owed: (data) => Owed.fromMap(data()),
    ExpenseHistory: (data) => ExpenseHistory.fromMap(data()),
    HostSetup: (data) => HostSetup.fromMap(data()),
    Chips: (data) => Chips.fromMap(data()),
    HostSplits: (data) => HostSplits.fromMap(data()),
  };

  // References for Users
  static final Collection<Report> reportRef =
      Collection<Report>(path: 'reports');

  // Reference for Owes
  Collection<Owes> owesRef = Collection<Owes>(path: 'reports');

  // Reference for Owed
  static final Collection<Owed> owedRef = Collection<Owed>(path: 'reports');

  // Reference for History
  static final Collection<History> historyRef =
      Collection<History>(path: 'history');

  // Reference for Expnese History
  static final Collection<ExpenseHistory> expenseHistoryRef =
      Collection<ExpenseHistory>(path: 'history');

  // Reference for game data
  static final Document<Game> gameInfo = Document<Game>(path: 'game/stats');
}
