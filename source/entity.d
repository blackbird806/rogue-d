module entity;

import game;
import world;
import log;

class Entity
{
	public:
	
	this(int x, int y)
	{
		pos.x = x;
		pos.y = y;
	}	

	void hit(Entity target, int damages)
	{
		target.life -= damages;
		writeMessagef("%s hit %s for %d damages", typeid(this), typeid(target), damages);
		if (target.life < 0)
		{
			g_game.currentWorld.removeEntity(target);
			writeMessagef("%s died", typeid(target));
		}		
	}

	void update() {}

	char drawChar;
	Position pos;
	int life;
}

final class Enemy : Entity
{
	this(int x, int y) 
	{
		super(x, y);
		drawChar = 'e';
	}

	Position getTargetPosition()
	{
		import std.algorithm;
		auto n = g_game.currentWorld.walkableNeighbours(g_game.player.pos);
		n.sort!((a, b) => distance(g_game.player.pos, a) < distance(g_game.player.pos, b));
		return n[0];
	}

	override void update()
	{
		import pathfinding;
		import std.algorithm;

		// hit player if next to
		if (g_game.currentWorld.neighbours(pos).any!(a => g_game.currentWorld[a].standEntity is g_game.player))
		{
			hit(g_game.player, 5);
			return;	
		}

		auto neighboursFn(Position p) {
			import std.array : array;
			return g_game.currentWorld.neighbours(p)
			.filter!(a => g_game.currentWorld[a].isWalkable() || g_game.currentWorld[a].standEntity == this)
			.array;
		}

		const path = breadthFirstSearch(&neighboursFn, pos, getTargetPosition());
		pos = path.nodes.get(pos, pos);
	}
}

final class Player : Entity
{
	this(int x, int y) 
	{
		super(x, y);
		drawChar = '@';
	}
}