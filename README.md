# Royale Insights

*Royal Insights* is a web-based application designed to veiw various player and clan information for the online game *Clash Royale.* The main functionality is the global and clan leaderboard, which each displays the top 1000 players and clans, respectively. Additional data can also be viewed for each player, including display name, id, trophies, rank, current deck, and so on. This data is also held for each player in the top 1000 clan, which can be seen under each clan. 

## Advanced Features

- API Update
- Utilizing Royale API, all data in the database is updated nightly. 

- Matchmaking

By entering a user's trophy count, trophy range, and number of players, *Royale Insights* will display several players that are reccomended to challenge against. The range can be adjusted in order to find enough players suited to the user's needs. Players found for matchmaking come from the player_clans table, which contains all the players for the top 1000 clans (up to 50,000 players). This ensures the greatest range of trophies and available stored players for matchmaking. A stored procedure was created on the database end to handle this calculation, since the time to randomly search through each player can create significant latency time. 

- Data Over Time

Utilizing Royale API's user verification system, a user can "log in" using their player tag and a token found in-game. When logged in, a user can view their personal stats held over time in various graphs. Each day after initial login, an extra day of data is added as the application's database updates. The database will hold a maximum of 50 days worth of data, with the oldest data being deleted once 50 points in time are tracked. This is handled using a count variable and an update trigger on the database end. 

## Build Instructions

Required Downloads: Flutter SDK, Dart

Go to File > Open.
You can also press Ctrl / Cmd + O
Browse to the directory holding your existing Flutter source code files.
Click Open.

Go to View > Run.
You can also press Ctrl / Cmd + Shift + D
The Run and Debug panel displays.
Click create a launch.json file.

Install the Flutter SDK with VS Code - Required Programming Language: Dart
Open the project with VS Code.
Run the commands:
    flutter pub get
    flutter build web 

For any extra documentation or issues, see https://docs.flutter.dev/platform-integration/web/building and https://docs.flutter.dev/tools/vs-code?gclsrc=aw.ds&gad_source=1&gclid=Cj0KCQiApNW6BhD5ARIsACmEbkUi37ZgQmdMTPHny2tGEekYWs3MiNjeB8OqMgmi9I0ETO_Fo8VzRFAaAhKpEALw_wcB

## Assets and Data

The `assets` directory houses images, fonts, and any other files used for Royale Insights, sourced from [Link].

Data gathered for this project is hosted in a Google Cloud VM server. Data is updated every day at 11:59 P.M. EST from Royale API [https://royaleapi.com/?lang=en].

## Credits

Elaine Steel, Kara Smith
CPSC 475-010 Fall 2024
Final Term Project
