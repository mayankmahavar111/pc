#include <stdio.h>
#include <string.h>
#include <malloc.h>

#define NUMBER 2
#define MAX_STRING 80

char **
build_array ()
{
  int i = 0;
  char **array = malloc (sizeof (char *) * NUMBER);
  if (!array)
    return NULL;
  for (i = 0; i < NUMBER; i++) {
    array[i] = malloc (MAX_STRING + 1);
    if (!array[i]) {
      free (array);
      return NULL;
    }
  }
  strncpy (array[0], "ABC", MAX_STRING);
  strncpy (array[1], "123", MAX_STRING);
  return array;
}

int
main (int argc, char *argv[])
{
  char **my_array = build_array ();
  if (!my_array) {
    printf ("ERROR: Unable to allocate my_array!\n");
    return 1;
  }
  else {
    printf ("my_array[0]=%s, my_array[1]=%s.\n",
      my_array[0], my_array[1]);
  }
  return 0;
}
