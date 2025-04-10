#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifndef ITERATIONS
#define ITERATIONS 1000
#endif

extern char *ft_strcpy_avx(char *dst, const char *src);

double benchmark_strcpy(char *(*func)(char *, const char *), const char *src, int *correct)
{
    size_t len = strlen(src) + 1;
    char *dst = malloc(len);
    if (!dst) return -1.0;

    clock_t start = clock();
    for (int i = 0; i < ITERATIONS; ++i) {
        func(dst, src);
    }
    clock_t end = clock();
    
    *correct = (strcmp(dst, src) == 0 && func(dst, src) == dst);

    free(dst);
    return (double)(end - start) / CLOCKS_PER_SEC * 1e6 / ITERATIONS;  // µs/iteration
}

void run_test(const char *label, char *(*func)(char *, const char *), const char *src)
{
    int valid = 0;
    double avg_time = benchmark_strcpy(func, src, &valid);

    printf("%s:\n", label);
    printf("  Temps moyen : %.2f µs (%d itérations)\n", avg_time, ITERATIONS);
    printf("  Copie correcte : %s\n\n", valid ? "✅" : "❌");
}

int main(void)
{
    const char *str1 = "Hello world";
    const char *str2 = "";
    const char *str3 = "Chaîne courte";
    const char *str4 = "Ceci est une chaîne plus longue pour tester le comportement de la fonction.";

    char *huge_str = malloc(1000000);
    memset(huge_str, 'A', 999999);
    huge_str[999999] = '\0';

    printf("=== Benchmark ft_strcpy_avx vs strcpy (%d itérations) ===\n\n", ITERATIONS);

    run_test("Chaîne normale (ft_strcpy_avx)", ft_strcpy_avx, str1);
    run_test("Chaîne normale (strcpy)", strcpy, str1);

    run_test("Chaîne vide (ft_strcpy_avx)", ft_strcpy_avx, str2);
    run_test("Chaîne vide (strcpy)", strcpy, str2);

    run_test("Chaîne courte (ft_strcpy_avx)", ft_strcpy_avx, str3);
    run_test("Chaîne courte (strcpy)", strcpy, str3);

    run_test("Chaîne longue (ft_strcpy_avx)", ft_strcpy_avx, str4);
    run_test("Chaîne longue (strcpy)", strcpy, str4);

    run_test("Très grande chaîne (ft_strcpy_avx)", ft_strcpy_avx, huge_str);
    run_test("Très grande chaîne (strcpy)", strcpy, huge_str);

    free(huge_str);
    return 0;
}
