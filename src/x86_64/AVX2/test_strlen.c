#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

extern size_t ft_strlen_avx_asm(const char *str);

void test_strlen(const char *name, size_t (*func)(const char *), const char *str)
{
    clock_t start = clock();
    size_t result = func(str);
    clock_t end = clock();
    double elapsed = (double)(end - start) / CLOCKS_PER_SEC * 1e6; 

    printf("%s:\n", name);
    printf("  Longueur: %zu\n", result);
    printf("  Temps: %.2f µs\n\n", elapsed);
}

int main(void)
{
    const char *empty = "";
    const char *short_str = "Hello";
    const char *medium_str = "Ceci est un test de performance";
    const char *long_str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    
    char *huge_str = malloc(1000000);
    memset(huge_str, 'A', 999999);
    huge_str[999999] = '\0';

    printf("=== Tests de ft_strlen_avx_asm ===\n\n");

    test_strlen("Chaîne vide", ft_strlen_avx_asm, empty);
    test_strlen("Courte chaîne", ft_strlen_avx_asm, short_str);
    test_strlen("Moyenne chaîne", ft_strlen_avx_asm, medium_str);
    test_strlen("Longue chaîne", ft_strlen_avx_asm, long_str);
    test_strlen("Très grande chaîne", ft_strlen_avx_asm, huge_str);

    printf("\n=== Comparaison avec strlen() standard ===\n\n");
    test_strlen("strlen (short)", strlen, short_str);
    test_strlen("ft_strlen_avx_asm (short)", ft_strlen_avx_asm, short_str);

    test_strlen("strlen (long)", strlen, long_str);
    test_strlen("ft_strlen_avx_asm (long)", ft_strlen_avx_asm, long_str);

    test_strlen("strlen (huge)", strlen, huge_str);
    test_strlen("ft_strlen_avx_asm (huge)", ft_strlen_avx_asm, huge_str);

    free(huge_str);
    return 0;
}
