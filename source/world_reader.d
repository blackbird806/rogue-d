module world_reader;

import std.algorithm;
import game;
import world;
import entity;

World readWorld(string worldStr)
{
	World w = new World(cast(uint) worldStr.countUntil('\n'), cast(uint) worldStr.count('\n'));
	int x = 0, y = 0;
	foreach (c; worldStr)
	{
		switch(c)
		{
			case '\n':
				y++;
				x = -1; // will be set to 0 below
			break;

			case ' ':
				w[x, y] = Tile(Tile.Type.Void);
			break;

			case '#':
				w[x, y] = Tile(Tile.Type.Wall);
			break;

			case '.':
				w[x, y] = Tile(Tile.Type.Ground);
			break;

			case 'e':
				w[x, y] = Tile(Tile.Type.Ground);
				w.addEntity(new Enemy(x, y));
			break;

			case '@':
				w[x, y] = Tile(Tile.Type.Ground);
				auto p = new Player(x, y);
				w.addEntity(p);
				assert(g_game.player is null, "only one player per map is allowed");
				g_game.player = p;
			break;

			default: break;
		}
		x++;
	}
	
	return w;
}




	