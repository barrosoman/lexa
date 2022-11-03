#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int getn(const char c);
int my_atoi(const char *message);

int main(void)
{
	char nstr[256];
	int  v;

	printf("Insira um número: ");
	scanf("%s", nstr);

	v = my_atoi(nstr);

	printf("String: %s.\n", nstr);
	printf("Valor: %d.\n", v);
	printf("Valor add 5: %d.\n", v + 5);
}

int my_atoi(const char *message)
{
	register int t;
	const size_t len = strlen(message);

	int value;
	int d;

	value = 0;
	d     = 1;

	for (t = len-1; t >= 0; t--)
	{
		value += getn(message[t]) * d;
		d     *= 10;
	}

	return value;
}

int getn(const char c)
{
	switch (c)
	{
		case '0': return 0;
		case '1': return 1;
		case '2': return 2;
		case '3': return 3;
		case '4': return 4;
		case '5': return 5;
		case '6': return 6;
		case '7': return 7;
		case '8': return 8;
		case '9': return 9;
	}

	printf("Unreachable.\n");
	exit(EXIT_FAILURE);
}
