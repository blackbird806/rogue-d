module log;

void writeMessagef(Args...)(string fmt, Args args)
{
	import std.format;
	messages ~= format(fmt, args);
}

void drawLogMessages()
{
	import std.stdio : writeln;
	for(auto i = messages.length > nbShowLines ? messages.length - 3 : 0;
	 	i < messages.length;
		i++)
	{
		writeln(messages[i]);
	}
}

enum nbShowLines = 3;
string[] messages;