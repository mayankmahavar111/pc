
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>

char **negative;
char **positive;
char **test;
char **stop;
int posLength;
int negLength;
int testLength;
int stopLength;


int negation(char *key) {
	char temp[10] = "no";
	if (strcmp(key, temp) == 0)
		return 1;
	char temp2[10] = "not";
	if (strcmp(key, temp2) == 0)
		return 1;
	return 0;
}


int checkStopwords(char *key) {
	int i;
	int temp = 0;
	for (i = 0; i<stopLength; i++) {
		if (strcmp(stop[i], key) == 0)
			temp += 1;
	}
	return temp;
}

int findCountPos(char *key) {
	int i, count = 0;
	for (i = 0; i<posLength; i++) {
		//printf("%d %s %s\n", strcmp(key, positive[i]) == 0,key,positive[i]);
		if (strcmp(key, positive[i]) == 0)
			count=count+1;
	}
	printf("%s %d\n", key, count);
	return count;
}

int findCountNeg(char *key) {
	int i, count = 0;
	for (i = 0; i<negLength; i++) {
		if (strcmp(key, negative[i]) == 0)
			count=count+1;
	}
	printf("%s %d\n", key, count);
	return count;
}


void readStop() {
	FILE *fp;
	int count = 0;
	char str[10];

	int i, n, stringsize;
	char a[100];

	//char **temp=negative;
	fp = fopen("G:\\test\\pc\\pc-cuda\\pc-cuda\\files\\stopWords.txt", "r");

	while (fscanf(fp, "%s", str) != EOF) {
		count = count + 1;
		if (count >10000)
			break;
	}
	stop = (char **)malloc(count * sizeof(char *));
	fclose(fp);
	fp = fopen("G:\\test\\pc\\pc-cuda\\pc-cuda\\files\\stopWords.txt", "r");
	for (i = 0; i < count; i++)
	{
		fscanf(fp, "%s", a);
		stringsize = strlen(a);
		stop[i] = (char *)malloc(stringsize + 1);
		strcpy(stop[i], a);
	}
	fclose(fp);
	stopLength = count;
	//print(3);
}


void readTest() {
	int count = 0, i, stringsize;
	char temp[1000], temp2[1000];
	char a[100];
	printf("Enter Sentence to be processed :");
	fgets(temp, sizeof(temp), stdin);
	//printf("%s \n",temp);
	strcpy(temp2, temp);
	char *token = strtok(temp, " ");
	while (token != NULL) {
		count++;
		//printf("%s\n",token );
		//strcpy(a,token);
		//printf("%s\n",a );
		/*
		stringsize=strlen(a);
		test[i] = (char *)malloc(stringsize+2);
		strcpy(test[i],a);
		*/
		token = strtok(NULL, " ");
	}
	//printf("%d\n",count );
	test = (char **)malloc(count * sizeof(char *));
	strcpy(temp, temp2);
	//printf("%s\n",temp );
	token = strtok(temp, " ");
	for (i = 0; i<count; i++) {
		strcpy(a, token);
		//printf("%s\n",a );
		stringsize = strlen(a);
		test[i] = (char *)malloc(stringsize );
		strcpy(test[i], a);
		token = strtok(NULL, " ");
		//printf("Hello World\n%s",token );
	}
	//printf("%d\n",count );

	//token=(char *)strtok(temp," ");
	testLength = count;
	//print(2);
}

void readpos() {
	FILE *fp;
	int count = 0;
	char str[10];

	int i, n, stringsize;
	char a[100];

	//char **temp=negative;
	fp = fopen("G:\\test\\pc\\pc-cuda\\pc-cuda\\files\\positive.txt", "r");

	while (fscanf(fp, "%s", str) != EOF) {
		count = count + 1;
		if (count >10000)
			break;
	}
	positive = (char **)malloc(count * sizeof(char *));
	fclose(fp);
	fp = fopen("G:\\test\\pc\\pc-cuda\\pc-cuda\\files\\positive.txt", "r");
	for (i = 0; i < count; i++)
	{
		fscanf(fp, "%s", a);
		stringsize = strlen(a);
		positive[i] = (char *)malloc(stringsize + 1);
		strcpy(positive[i], a);
	}
	fclose(fp);
	//printf("Hello World \n %d\n",count );
	posLength = count;
	//print(1);
}

void readneg() {
	FILE *fp;
	int count = 0;
	char str[10];

	int i, n, stringsize;
	char a[100];

	//char **temp=negative;
	fp = fopen("G:\\test\\pc\\pc-cuda\\pc-cuda\\files\\negative.txt", "r");

	while (fscanf(fp, "%s", str) != EOF) {
		count = count + 1;
		if (count >10000)
			break;
	}
	negative = (char **)malloc(count * sizeof(char *));
	fclose(fp);
	fp = fopen("G:\\test\\pc\\pc-cuda\\pc-cuda\\files\\negative.txt", "r");
	for (i = 0; i < count; i++)
	{
		fscanf(fp, "%s", a);
		stringsize = strlen(a);
		negative[i] = (char *)malloc(stringsize + 1);
		strcpy(negative[i], a);
	}
	fclose(fp);
	//printf("Hello World \n %d\n",count );
	negLength = count;
	//print(0);
}

__global__ void findcount(char **negative, char *key,int *count , int n) {
	int i = threadIdx.x;
	if (i < n)
	{
		printf("%s and %s in %d and %d\n",negative[i][0],key, i,count[0]);
		int j = 0,flag=0;
		while (key[j] != '\0') {
			if (key[j] != negative[i][j]) {
				flag = 1;
				break;
			}
		}
		if (flag == 1) {
			count[0] = count[0] + 1;
		}
	}
}


__global__ void addarray(float *a, float *b, int n) {
	int i = threadIdx.x;
	if (i < n) {
		b[0] = b[0] + a[i];
		printf(" value in count : %lf thread no. %d and value %d\n", b[0] ,i , a[i]);
	}

}


__global__ void check(float *a, float *b, int *c, float n) {
	int i = threadIdx.x;
	if (i < n) {
		printf(" condition is %d value are %lf , %lf\n", a[i] < b[i],a[i],b[i]);
		if ((a[i] < b[i]) == 0) {
			c[i] = -1;
			printf(" c[%d]values is %d\n", i, c[i]);
		}
		else
		{
			c[i] = 1;
		}
	}

}


int main() {


	
	int posTotal, negTotal, i,j=0, flag = 0;
	float posProb = 0, negProb = 0, posCons, negCons, TotalPos = 0, TotalNeg = 0;
	double pos, neg, k;
	int posarrayCount, negarrayCount;
	float *posarray,*posarray_d;
	float *negarray,*negarray_d;
	int *count;
	int sum=0;
	clock_t t;
	printf("Hello world \n");
	t = clock();
	readneg();
	readpos();
	readTest();
	readStop();


	posTotal = posLength;
	negTotal = negLength;
	posCons = (posTotal*1.0) / (posTotal + negTotal);
	negCons = (negTotal*1.0) / (posTotal + negTotal);

	cudaMallocManaged(&posarray, sizeof(float) * testLength);
	cudaMallocManaged(&negarray, sizeof(float) * testLength);

	



	for (i = 0; i<testLength; i++) {
		if (negation(test[i]) == 1) {
			flag = 1;
			continue;
		}
		//printf("%s %d\n",test[i] ,checkStopwords(test[i]) );
		if (checkStopwords(test[i]) != 0)
			continue;
		if (flag == 1)
		{
			k = findCountNeg(test[i]);
			pos = log((k + 1) / (negTotal*1.0));
			flag = 0;
		}
		else
		{
			k = findCountPos(test[i]);
			pos = log((k + 1) / (posTotal*1.0));
		}

		//printf("%lf %lf\n",pos,neg);
		posarray[j++] = pos;
		TotalPos += pos;

	}
	posarrayCount = j;
	j = 0;
	for (i = 0; i<testLength; i++) {
		if (negation(test[i]) == 1) {
			flag = 1;
			continue;
		}
		if (checkStopwords(test[i]) != 0)
			continue;
		if (flag == 1)
		{
			k = findCountPos(test[i]);
			neg = log((k + 1) / (posTotal*1.0));
			flag = 0;
		}
		else
		{
			k = findCountNeg(test[i]);
			neg = log((k + 1) / (negTotal*1.0));
		}
		negarray[j++] = neg;
		TotalNeg += neg;
	}
	negarrayCount = j;
	for (i = 0; i < posarrayCount;i++) {
		printf("positive%lf,negative%lf\n",posarray[i],negarray[i]);
	}
	cudaMallocManaged(&count, sizeof(int) * posarrayCount);
	check << <1,posarrayCount>> > (posarray,negarray, count,posarrayCount);
	cudaDeviceSynchronize();
	for (i = 0; i < posarrayCount; i++) {
		sum += count[i];
		printf("sum is :%d\n",sum);
	}
	if (sum > 0)
		printf("positive\n");
	else
		printf("negative\n");
	
	printf("Total positve %lf\nTotal negative %lf\n",TotalPos,TotalNeg);
}
