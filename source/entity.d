module entity;

import game;
import world;

class Entity
{
	public:
	
	this(int x, int y)
	{
		pos.x = x;
		pos.y = y;
	}	

	void hit(int damages)
	{
		life -= damages;
		if (life < 0)
		{
			g_game.currentWorld.removeEntity(this);
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
		import pathfinding, std.stdio;

		auto neighboursFn(Position p) {
			import std.algorithm : filter;
			import std.array : array;
			return g_game.currentWorld.neighbours(p)
			.filter!(a => g_game.currentWorld[a].isWalkable() || g_game.currentWorld[a].standEntity == this)
			.array;
		}

		const path = breadthFirstSearch(&neighboursFn, pos, getTargetPosition());
		pos = path.nodes[pos];
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