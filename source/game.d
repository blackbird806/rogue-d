module game;

import entity;
import world;
import world_reader;
import arsd.terminal;

struct Game
{
	void initialize()
	{
		enum map = 
			"################\n" ~
			"#....#.......e.#\n" ~
			"#.@..#..e......#\n" ~
			"#....#########.#\n" ~
			"#..............#\n" ~
			"#.....e........#\n" ~
			"################\n";

		enum map2 = 
			"#####\n" ~
			"#@..#\n" ~
			"#...#\n" ~
			"#..e#\n" ~
			"#####\n" ;

		currentWorld = readWorld(map);

		terminal = Terminal(ConsoleOutputType.linear);
		input = RealTimeConsoleInput(&terminal, ConsoleInputFlags.raw);
	}

	void handleInputs(dchar key)
	{
		Position npos;
		if (key == 'l')
		{
			npos.x = player.pos.x + 1;
			npos.y = player.pos.y;
		}
		else if (key == 'h')
		{
			npos.x = player.pos.x - 1;
			npos.y = player.pos.y;
		}
		else if (key == 'j')
		{
			npos.x = player.pos.x;
			npos.y = player.pos.y + 1;
		}
		else if (key == 'k')
		{
			npos.x = player.pos.x;
			npos.y = player.pos.y - 1;
		}

		currentWorld.moveEntity(player,	npos);
		
		if (currentWorld.isInBounds(npos.x, npos.y) && 
			currentWorld[npos.x, npos.y].standEntity !is null)
		{
			if (typeid(currentWorld[npos.x, npos.y].standEntity) == typeid(Enemy))
			{
				currentWorld[npos.x, npos.y].standEntity.hit(10);
			}
		}
	}

	void run()
	{
		draw(); // draw the initial screen
		dchar key;
		while (key != 'q')
		{
			key = input.getch(false);
			handleInputs(key);
			currentWorld.update();
			draw();
			turnCount++;
		}
	}

	void draw()
	{
		terminal.clear();
		terminal.moveTo(0, 0);
		currentWorld.draw();
	}

	uint turnCount = 0;
	Terminal terminal = void;
	RealTimeConsoleInput input = void;
	World currentWorld;
	Player player;
}

public Game g_game;


