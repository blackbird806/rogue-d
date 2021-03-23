module stack;

struct Stack(T)
{
	void push(T t)
	{
		arr ~= t;
	}

	T peek() const
	{
		return arr[$ - 1];
	}
	
	T pop()
	in(!empty())
	{
		auto t = peek();
		arr = arr[0 .. $ - 1];
		return t;
	}

	alias popFront = pop;

	bool empty() const nothrow pure @nogc
	{
		return arr.length > 0;
	}


private:
	T[] arr;
}