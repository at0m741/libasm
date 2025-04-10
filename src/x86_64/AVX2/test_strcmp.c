
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

extern int ft_strcmp_avx(const char *s1, const char *s2);

void test_strcmp(const char *name, int (*func)(const char *, const char *), const char *s1, const char *s2)
{
    clock_t start = clock();
    int result = func(s1, s2);
    clock_t end = clock();
    double elapsed = (double)(end - start) / CLOCKS_PER_SEC * 1e6;

    printf("%s:\n", name);
    printf("  Résultat: %d\n", result);
    printf("  Temps: %.2f µs\n\n", elapsed);
}

int main(void)
{
    const char *str1 = "Hello world";
    const char *str2 = "Hello world";
    const char *str3 = "Hello worlz";
    const char *str4 = "Hello wor";
    const char *str5 = "";
    const char *str6 = "Non-empty";

    char *huge_str1 = malloc(1000000);
    char *huge_str2 = malloc(1000000);
    memset(huge_str1, 'A', 999999);
    huge_str1[999999] = '\0';
    memset(huge_str2, 'A', 999998);
    huge_str2[999998] = 'B';
    huge_str2[999999] = '\0';

    printf("=== Tests de ft_strcmp_avx ===\n\n");

    test_strcmp("Chaînes identiques", ft_strcmp_avx, str1, str2);
    test_strcmp("Chaînes avec dernier caractère différent", ft_strcmp_avx, str1, str3);
    test_strcmp("Chaîne plus courte vs plus longue", ft_strcmp_avx, str4, str1);
    test_strcmp("Chaîne vide vs non vide", ft_strcmp_avx, str5, str6);
    test_strcmp("Très grandes chaînes (diff à la fin)", ft_strcmp_avx, huge_str1, huge_str2);

    printf("\n=== Comparaison avec strcmp() standard ===\n\n");
    test_strcmp("strcmp (identiques)", strcmp, str1, str2);
    test_strcmp("ft_strcmp_avx (identiques)", ft_strcmp_avx, str1, str2);

    test_strcmp("strcmp (diff)", strcmp, str1, str3);
    test_strcmp("ft_strcmp_avx (diff)", ft_strcmp_avx, str1, str3);

    test_strcmp("strcmp (huge)", strcmp, huge_str1, huge_str2);
    test_strcmp("ft_strcmp_avx (huge)", ft_strcmp_avx, huge_str1, huge_str2);

    free(huge_str1);
    free(huge_str2);
    return 0;
}
