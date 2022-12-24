while {true} do {
	sleep 5;

	private _playerCount = playersNumber independent + playersNumber west + playersNumber east;
	"dcpr" callExtension ["updateplayercount", [_playerCount]];
};