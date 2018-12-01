#include <stdio.h>
#include "list.c"

int main()
{
	int n = 500, m = 100;
	HBnodePtr L = createHBlist(n,m);
	
	printf("\n");
	
	SLnodePtr P = flattenList(L);
	
	printf("\n");
	
	freeSLlist(P);
	freeHBlist(L);
	return 0;
}