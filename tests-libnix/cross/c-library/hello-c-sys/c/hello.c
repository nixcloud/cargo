/* freestanding (no headers, no libc), so clang alone compiles it for any target */
const char *hello_c(void) {
    return "hello world from c";
}
