#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char **array;
void print(int n) {
  int i;
  for (i=0;i<n;i++)
  {
      printf("%s\n",array[i] );
  }
}


int main()
{
    int i,n,stringsize;
    char a[100];
    printf("Enter number of elements: ");
    scanf("%d", &n);
    array = (char **)malloc(n*sizeof(char *));
    char **temp=array;
    for (i = 0; i < n; i++)
    {
        scanf("%s",a);
        stringsize=strlen(a);
        array[i] = (char *)malloc(stringsize+1);
        strcpy(array[i],a);
    }
    print(n);

}
