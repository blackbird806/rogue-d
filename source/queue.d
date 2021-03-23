module queue;

struct Queue(T)
{
	void push(T e)
	{
		arr ~= e;
	}

	T pop()
	in(!empty())
	{
		T tmp = front();
		arr = arr[1 .. $];
		return tmp;
	}

	alias popFront = pop;

	bool empty() const nothrow pure @nogc
	{
		return arr.length == 0;
	}

	T front() const nothrow pure @nogc
	in(!empty())
	{
		return arr[0];
	}

private:
	T[] arr;
}

unittest
{
	import std.range;
	static assert(isInputRange!(Queue!int));
}