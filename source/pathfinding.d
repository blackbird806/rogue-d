module pathfinding;
import queue;

struct Path(Node)
{
	Node[Node] nodes;
}

// https://www.redblobgames.com/pathfinding/a-star/implementation.html
Path!(Node) breadthFirstSearch(Neighbours, Node)(Neighbours neighbours, Node start, Node goal)
{
	Path!Node path;
	Queue!Node openList;
	openList.push(goal);
	path.nodes[goal] = goal;

	while (!openList.empty)
	{
		const current = openList.pop();
		if (current == start)
			break;

		foreach (neighbour; neighbours(current))
		{
			if (neighbour !in path.nodes)
			{
				openList.push(neighbour);
				path.nodes[neighbour] = current;
			}
		}
	}

	return path;
}

