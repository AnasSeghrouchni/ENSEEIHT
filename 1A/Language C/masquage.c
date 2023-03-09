#include <stdio.h>
#include <stdlib.h>
int main() {
int n=10;
int *p=NULL;
printf("%p\n", (void *) &n);
printf ("%p\n", (void *) p);
{ int a=5;
p=&a;
printf("%p\n", (void *) &a);

printf("%d", *p);
}
printf("%p\n", (void *) p);
printf("%d\n",*p);
{int n=7;
printf("%d\n",n);
printf("%p\n",(void *) &n);
}
        printf("%p\n",(void *) p);
        printf("%d\n", *p);

        printf("%d\n",n);
        {double r=11;
        printf ("%f\n",r);
        printf("%p\n",(void *) &r);
        }
        printf("%d\n",*p);
return EXIT_SUCCESS;
}
