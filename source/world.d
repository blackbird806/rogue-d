module world;

public import tile;

import std.typecons : Tuple, tuple;
import std.algorithm;
import arsd.terminal;
import entity;
import stack;

struct Position
{
	int x, y;
}

float distance(Position p1, Position p2)
{
	const x = p2.x - p1.x;
	const y = p2.y - p1.y;
	return x*x + y*y;
}

class World
{
	this(int width, int height)
	{
		map = new Tile[width * height];
		outputBuffer = new char[map.length];
		this.width = width;
		this.height = height;
	}

	void addEntity(Entity e)
	{
		entities ~= e;
		this[e.pos.x, e.pos.y].standEntity = e;
	}

	void removeEntity(Entity e)
	{
		this[e.pos.x, e.pos.y].standEntity = null;
		entities.remove!(a => a is e)();
	}

	void moveEntity(Entity e, Position pos)
	{
		if (!isInBounds(pos.x, pos.y)) return;

		if (!this[pos.x, pos.y].isWalkable())
			return;

		this[e.pos].standEntity = null;
		e.pos.x = pos.x;
		e.pos.y = pos.y;
		this[e.pos].standEntity = e;
	}

	bool isInBounds(int x, int y) const nothrow pure @nogc
	{
		return x >= 0 && x < width && y >= 0 && y < height;
	}

	// Get the 4 adjacents cells of the given Pos
	Position[] neighbours(Position p) const pure
	{
		immutable x = p.x;
		immutable y = p.y;

		Position[] neighbours;

		if (x + 1 < width)
			neighbours ~= Position(x+1, y);
		if (x > 0)
			neighbours ~= Position(x-1, y);
		if (y + 1 < height)
			neighbours ~= Position(x, y+1);
		if (y > 0)
			neighbours ~= Position(x, y-1);
		
		return neighbours;
	}
	
	auto walkableNeighbours(Position p) const
	{
		import std.algorithm : filter;
		import std.array : array;
		return neighbours(p).filter!(a => this[a].isWalkable()).array;
	}

	ref inout(Tile) opIndex(Position p) inout
	{
		return this[p.x, p.y];
	}

	ref inout(Tile) opIndex(int i, int j) inout
	in(isInBounds(i, j))
	{
		return map[j * width + i];
	}

	void update()
	{
		foreach (e; entities)
		{
			e.update();
		}
	}

	void draw()
	{
		import std.stdio : write;
		uint n = 0;
		foreach(j; 0 .. height)
		{
			foreach(i; 0 .. width)
			{
				outputBuffer[n++] = tileRender[this[i, j].type];
			}
		}

		foreach (e; entities)
		{
			outputBuffer[e.pos.y * width + e.pos.x] = e.drawChar;
		}

		uint i = 0;
		while(i < outputBuffer.length)
		{
			write(outputBuffer[i++]);
			if (i % width == 0) write('\n');
		}
	}

	immutable int height, width;

	private:

	Entity[] entities;
	Tile[] map;
	char[] outputBuffer;
}