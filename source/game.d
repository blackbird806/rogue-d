module game;

import entity;
import world;
import world_reader;
import arsd.terminal;
import std.file;
import log;

struct Game
{
	void initialize()
	{
		enum map = 
			"################\n" ~
			"#....#.........#\n" ~
			"#.@..#..e......#\n" ~
			"#....########.##\n" ~
			"#..............#\n" ~
			"#..............#\n" ~
			"################\n";
		
		// currentWorld = readWorld(readText("level1.txt"));
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
				player.hit(currentWorld[npos.x, npos.y].standEntity, 10);
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
			drawLogMessages();
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


