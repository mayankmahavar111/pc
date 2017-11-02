#include<stdio.h>
#include<string.h>
int compare(char * , char *);
int main(){

  char str[10];
  FILE *fp;
  int count=0,lines=0;
  fp = fopen("files/positive.txt","r");
  if(fp){
    char temp[10] = "good";
    while (fscanf(fp,"%s",str)!=EOF) {
      lines++;
      if(compare(temp,str)!=0)
        count++;
          printf("%s\n",str );
        }
    fclose(fp);
    printf("%d %d\n", count,lines);
  }
}

int compare(char *a,char *b){
  int i;
  if(strlen(a) != strlen(b))
    return 0;
  for (i=0;i<strlen(a);i++){
    if(a[i]!=b[i])
      return 0;
  }
  return 1;
}
