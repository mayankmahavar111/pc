# include <mpi.h>
# include <stdio.h>
# include <stdlib.h>
# include <time.h>
# include <string.h>
# define N 10000

void readneg();
void readpos();
int countPos(int pos,int my_id,int numprocs,int n);
int countNeg(int pos,int my_id,int numprocs,int n);
void function(int id);
void readTest();

char positive[10000][20];
char negative[10000][20];
char test[10000][20];
//char **stop;
int posLength=10000;
int negLength=10000;
int testLength;
//int stopLength;
long totTest=1;


int main ( int argc, char *argv[] )
{
  int i,master = 0,my_id,numprocs,j;
  MPI_Status status;
  int tempPosSum=0,tempNegSum=0,pos_sum_all=0,neg_sum_all=0;

  MPI_Init ( &argc, &argv );
  MPI_Comm_size ( MPI_COMM_WORLD, &numprocs );
  MPI_Comm_rank ( MPI_COMM_WORLD, &my_id );

  if ( my_id == master )
  {
    printf ( "The number of processes available is %d.\n", numprocs );
    readpos();
    readneg();
    readTest();
    //function(my_id);
    printf("test Length %ld\n",totTest );
    for(i=1;i<numprocs;i++)
    {
      MPI_Ssend ( positive, 10000*20, MPI_BYTE,i,121,MPI_COMM_WORLD );
      MPI_Ssend ( negative ,200000, MPI_BYTE,i,122,MPI_COMM_WORLD );
      MPI_Ssend ( test,200000, MPI_BYTE,i,123,MPI_COMM_WORLD );
      MPI_Ssend(&totTest,1,MPI_INT,i,124,MPI_COMM_WORLD);
    }
    //function(my_id);
  }
  else
  {
    MPI_Recv(positive,200000,MPI_BYTE,0,121,MPI_COMM_WORLD,&status);
    MPI_Recv(negative,200000,MPI_BYTE,0,122,MPI_COMM_WORLD,&status);
    MPI_Recv(test,200000,MPI_BYTE,0,123,MPI_COMM_WORLD,&status);
    MPI_Recv(&totTest,1,MPI_INT,0,124,MPI_COMM_WORLD,&status);
  }
  for(j=0;j<totTest;j++)
  {
    tempPosSum=0;
    tempNegSum=0;
    tempPosSum=countPos(j,my_id,numprocs,posLength);
    tempNegSum=countNeg(j,my_id,numprocs,posLength);
    printf("my id %d tempPosSum: %d j: %d\n",my_id,tempPosSum,j+1 );
    printf("my id %d tempNegSum: %d j: %d\n",my_id,tempNegSum,j+1 );
    if ( my_id != master )
    {
      MPI_Ssend ( &tempPosSum, 1, MPI_INT, master, my_id, MPI_COMM_WORLD );
      MPI_Ssend ( &tempNegSum, 1, MPI_INT, master, my_id+4, MPI_COMM_WORLD );
    }
    else
    {
      printf("%s\n",test[j]);
      pos_sum_all+= tempPosSum;
      neg_sum_all+=tempNegSum;

      for ( i = 1; i < numprocs; i++ )
      {
        MPI_Recv ( &tempPosSum, 1, MPI_INT, i, i,MPI_COMM_WORLD, &status );
        MPI_Recv ( &tempNegSum, 1, MPI_INT, i, i+4,MPI_COMM_WORLD, &status );
        pos_sum_all = pos_sum_all + tempPosSum;
        neg_sum_all+=tempNegSum;
        printf("master :%d %d\n",pos_sum_all,neg_sum_all );
      }
    }
  }

  if ( my_id == master )
  {
    printf ( "\n");
    printf ( "The total positive sum is %d\n", pos_sum_all );
    printf ( "The total negative sum is %d\n", neg_sum_all );
  }
  MPI_Finalize ( );
# undef N
}


void readpos()
{
  FILE *fp ;
  int i,n,stringsize;
  char a[100];
  fp= fopen("files/positive.txt","r");
  for (i = 0; i < posLength; i++)
  {
      fscanf(fp,"%s",a);
      strcpy(positive[i],a);
  }
  fclose(fp);
  printf("Length of positive file : %d\n",posLength );
}

void readneg()
{
  FILE *fp ;
  int i,n,stringsize;
  char a[100];
  fp= fopen("files/negative.txt","r");
  for (i = 0; i < negLength; i++)
  {
      fscanf(fp,"%s",a);
      strcpy(negative[i],a);
  }
  fclose(fp);
  printf("Length of the negative file is %d\n",negLength );
}

int countPos(int pos,int my_id,int numprocs,int n)
{
  int sum=0,i;
  for ( i = 0+(my_id*(n/numprocs)); i < n/numprocs+(my_id*(n/numprocs)); i++ )
  {
    if(strcmp(test[pos],positive[i])==0)
    {
      sum++;
    }
  }
  return sum;
}

int countNeg(int pos,int my_id,int numprocs,int n)
{
  int sum=0,i;
  for ( i = 0+(my_id*(n/numprocs)); i < n/numprocs+(my_id*(n/numprocs)); i++ )
  {
    if(strcmp(test[pos],negative[i])==0)
    {
      sum++;
    }
  }
  return sum;
}

 void function(int id)
 {
   printf("\nPositive words %d \n",id);
   for(int i=0;i<5;i++)
   {
     printf("%s\n",positive[i] );
   }
   printf("\nNegative words %d\n",id);
   for(int i=0;i<5;i++)
   {
     printf("%s\n",negative[i] );
   }
   printf("\nTest words %d\n",id);
   for(int i=0;i<totTest;i++)
   {
     //printf("hello world\n");
     printf("%s\n",test[i] );
   }
 }

 void readTest()
 {
   int count=0,i,stringsize;
   char temp[10000],temp2[10000];
   char a[100];
   printf("Enter Sentence to be processed :");
   fgets(temp,sizeof(temp),stdin);
   strcpy(temp2,temp);
   char *token=strtok(temp," ");
   while(token != NULL){
     count++;
     token = strtok(NULL, " ");
   }
   strcpy(temp,temp2);
   token=strtok(temp," ");
   for(i=0;i<count;i++){
     strcpy(a,token);
     printf("%ld\n",strlen(a));
     a[strlen(a)]='\0';
     strcpy(test[i],a);
     token = strtok(NULL, " ");
   }
   test[i-1][strlen(a)-1]='\0';
   totTest=count;
 }
