import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Football App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String?> selectedPlayers = List<String?>.filled(11, null);
  final Set<Player> selectedPlayerSet = {};

  final List<Player> players = [
    Player(name: 'V.Nelsson', position: 'Defender', fee: 7, team: 'Galatasaray'),
    Player(name: 'K.Demirbay', position: 'Midfielder', fee: 6, team: 'Galatasaray'),
    Player(name: 'M.Icardi', position: 'Forward', fee: 12, team: 'Galatasaray'),
    Player(name: 'A.Djiku', position: 'Defender', fee: 7, team: 'Fenerbahçe'),
    Player(name: 'M.Trezeguet', position: 'Midfielder', fee: 7, team: 'Trabzonspor'),
    Player(name: 'C.Immobile', position: 'Forward', fee: 8, team: 'Beşiktaş'),
    Player(name: 'F.Muslera', position: 'Goalkeeper', fee: 6, team: 'Galatasaray'),
    Player(name: 'M.Günok', position: 'Goalkeeper', fee: 8, team: 'Beşiktaş'),
    Player(name: 'D.Sanchez', position: 'Defender', fee: 7, team: 'Galatasaray'),
    Player(name: 'D.Mertens', position: 'Midfielder', fee: 8, team: 'Galatasaray'),
    Player(name: 'Player 11', position: 'Forward', fee: 14),
    Player(name: 'Player 12', position: 'Defender', fee: 11),
    Player(name: 'O.Aydın', position: 'Midfielder', fee: 7, team: 'Fenerbahçe'),
    Player(name: 'Player 14', position: 'Forward', fee: 15),
    Player(name: 'Player 15', position: 'Goalkeeper', fee: 9),
    Player(name: 'Player 16', position: 'Goalkeeper', fee: 8),
    Player(name: 'Player 17', position: 'Defender', fee: 10),
    Player(name: 'M.Rashica', position: 'Midfielder', fee: 7, team: 'Besiktas'),
    Player(name: 'Player 19', position: 'Forward', fee: 14),
    Player(name: 'Player 20', position: 'Defender', fee: 11),
    Player(name: 'Player 21', position: 'Midfielder', fee: 13),
    Player(name: 'Player 22', position: 'Forward', fee: 15),
    Player(name: 'Player 23', position: 'Goalkeeper', fee: 9),
    Player(name: 'Player 24', position: 'Goalkeeper', fee: 8),
    Player(name: 'Player 25', position: 'Defender', fee: 10),
    Player(name: 'Player 26', position: 'Midfielder', fee: 12),
    Player(name: 'Player 27', position: 'Forward', fee: 14),
    Player(name: 'Player 28', position: 'Defender', fee: 11),
    Player(name: 'Player 29', position: 'Midfielder', fee: 13),
    Player(name: 'Player 30', position: 'Forward', fee: 15),
    Player(name: 'Player 31', position: 'Goalkeeper', fee: 9),
    Player(name: 'Player 32', position: 'Goalkeeper', fee: 8),
  ];

  @override
  void initState() {
    super.initState();
    loadSavedSquad();
  }

  Future<void> loadSavedSquad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedPlayers = prefs.getStringList('selectedPlayers') ?? List.filled(11, '');
    Set<Player> savedPlayerSet = {};
    for (String playerName in savedPlayers) {
      if (playerName.isNotEmpty) {
        savedPlayerSet.add(players.firstWhere((player) => player.name == playerName));
      }
    }
    setState(() {
      selectedPlayers.setAll(0, savedPlayers);
      selectedPlayerSet.addAll(savedPlayerSet);
    });
  }

  Future<void> saveSquad() async {
    if (selectedPlayerSet.length != 11) {
      print('Please select all 11 players before saving the squad.');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> playerNames = selectedPlayers.where((name) => name != null).map((name) => name!).toList();
    await prefs.setStringList('selectedPlayers', playerNames);
    print('Squad saved!');
  }

  void autoFillSquad() {
    setState(() {
      selectedPlayers.fillRange(0, 11, null);
      selectedPlayerSet.clear();
      final random = Random();

      autoFillPosition(random, 0, 1, 'Goalkeeper');
      autoFillPosition(random, 1, 4, 'Defender');
      autoFillPosition(random, 5, 3, 'Midfielder');
      autoFillPosition(random, 8, 3, 'Forward');
    });
  }

  void autoFillPosition(Random random, int startIndex, int count, String position) {
    final availablePlayers = players
        .where((player) => player.position == position && !selectedPlayerSet.contains(player))
        .toList();

    for (int i = 0; i < count; i++) {
      if (availablePlayers.isNotEmpty) {
        final player = availablePlayers.removeAt(random.nextInt(availablePlayers.length));
        selectedPlayers[startIndex + i] = player.name;
        selectedPlayerSet.add(player);
      }
    }
  }

  void resetSquad() {
    setState(() {
      selectedPlayers.fillRange(0, 11, null);
      selectedPlayerSet.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fantasy Football'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/football_field.png',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              Column(
                children: [
                  buildRow(context, 0, 1, 'Goalkeeper'),
                  buildRow(context, 1, 4, 'Defender'),
                  buildRow(context, 5, 3, 'Midfielder'),
                  buildRow(context, 8, 3, 'Forward'),
                  SizedBox(height: 20),
                  buildButtonRow(),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(BuildContext context, int startIndex, int count, String position) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(count, (index) {
          return FormaButton(
            number: startIndex + index + 1,
            playerName: selectedPlayers[startIndex + index],
            position: position,
            onTap: () async {
              final selectedPlayer = await Navigator.of(context).push<Player>(
                MaterialPageRoute(
                  builder: (context) => PlayerSelectionScreen(
                    position: position,
                    selectedPlayers: selectedPlayerSet,
                    players: players,
                  ),
                ),
              );
              if (selectedPlayer != null) {
                setState(() {
                  final previousPlayer = selectedPlayers[startIndex + index];
                  if (previousPlayer != null) {
                    selectedPlayerSet.remove(
                      players.firstWhere((player) => player.name == previousPlayer),
                    );
                  }
                  selectedPlayers[startIndex + index] = selectedPlayer.name;
                  selectedPlayerSet.add(selectedPlayer);
                });
              }
            },
          );
        }),
      ),
    );
  }

  Widget buildButtonRow() {
    int totalFee = selectedPlayerSet.fold(0, (sum, player) => sum + player.fee);
    bool overBudget = totalFee > 130;
    bool allPlayersSelected = selectedPlayerSet.length == 11;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Fee: \$${totalFee}M / 130M',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: overBudget ? Colors.red : Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: overBudget || !allPlayersSelected ? null : saveSquad,
                icon: Icon(Icons.save),
                label: Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              ElevatedButton.icon(
                onPressed: overBudget ? null : autoFillSquad,
                icon: Icon(Icons.autorenew),
                label: Text('Auto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              ElevatedButton.icon(
                onPressed: resetSquad,
                icon: Icon(Icons.refresh),
                label: Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MainMenuScreen()),
                  );
                },
                icon: Icon(Icons.home),
                label: Text('Ana menü'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

class FormaButton extends StatelessWidget {
  final int number;
  final String? playerName;
  final String position;
  final VoidCallback onTap;

  FormaButton({
    required this.number,
    required this.playerName,
    required this.position,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String imageAsset = 'assets/forma.png'; // Default image for the button

    if (playerName != null) {
      // Update imageAsset based on playerName (similar to your current code)
      // ...
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 100,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[700],
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imageAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 5,
              child: Text(
                playerName ?? '$number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black45,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Player {
  final String name;
  final String position;
  final int fee;
  final String? team;

  Player({
    required this.name,
    required this.position,
    required this.fee,
    this.team,
  });
}

class PlayerSelectionScreen extends StatelessWidget {
  final String position;
  final Set<Player> selectedPlayers;
  final List<Player> players;

  PlayerSelectionScreen({
    required this.position,
    required this.selectedPlayers,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    final availablePlayers = players.where((player) => player.position == position && !selectedPlayers.contains(player)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select $position'),
      ),
      body: ListView.builder(
        itemCount: availablePlayers.length,
        itemBuilder: (context, index) {
          final player = availablePlayers[index];
          return ListTile(
            title: Text(player.name),
            subtitle: Text('Fee: \$${player.fee}M'),
            onTap: () {
              Navigator.of(context).pop(player);
            },
          );
        },
      ),
    );
  }
}


class MainMenuScreen extends StatelessWidget {
  final List<Standing> standings = [
    Standing(team: 'Galatasaray', played: 33, won: 22, drawn: 6, lost: 5, points: 72),
    Standing(team: 'Fenerbahçe', played: 33, won: 21, drawn: 8, lost: 4, points: 71),
    Standing(team: 'Beşiktaş', played: 33, won: 19, drawn: 9, lost: 5, points: 66),
    Standing(team: 'Trabzonspor', played: 33, won: 17, drawn: 7, lost: 9, points: 58),
    Standing(team: 'Başakşehir', played: 33, won: 15, drawn: 9, lost: 9, points: 54),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu, size: 30),
                    Text(
                      "INTER",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.search, size: 30),
                        SizedBox(width: 16),
                        Icon(Icons.notifications_none, size: 30),
                        SizedBox(width: 16),
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(height: 20),

                // Main Content
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      // Next Match Card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Next Match", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Spacer(),
                            Text("Inter vs Juventus", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("Tomorrow 2:45 PM", style: TextStyle(fontSize: 16, color: Colors.grey)),
                            Spacer(),
                            Text("San Siro Stadium", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ),

                      // Calendar Card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Calendar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Spacer(),
                            Container(
                              height: 80,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      ),

                      // Last Match Card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Last Match", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Spacer(),
                            Text("Fiorentina 1-2 Inter", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("13th Jan 4:00 PM", style: TextStyle(fontSize: 16, color: Colors.grey)),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Match Stats"),
                            )
                          ],
                        ),
                      ),

                      // Standings Card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Standings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Spacer(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: standings.length,
                                itemBuilder: (context, index) {
                                  final standing = standings[index];
                                  return ListTile(
                                    title: Text(standing.team),
                                    subtitle: Text(
                                      'P: ${standing.played}  W: ${standing.won}  D: ${standing.drawn}  L: ${standing.lost}  Pts: ${standing.points}',
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Standing {
  final String team;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int points;

  Standing({
    required this.team,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.points,
  });
}



