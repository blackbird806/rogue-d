module tile;

import entity;

struct Tile
{
	enum Type
	{
		Void,
		Ground,
		Wall,
		Debug,
	}

	bool isWalkable() const pure nothrow @nogc
	{
		return type == Type.Ground && standEntity is null;
	}

	Type type;
	Entity standEntity;
}

static immutable char[Tile.Type] tileRender;

shared static this()
{
	tileRender[Tile.Type.Void] = ' ';
	tileRender[Tile.Type.Ground] = '.';
	tileRender[Tile.Type.Wall] = '#';
	tileRender[Tile.Type.Debug] = '+';
}