# proc-macro-test's build script runs cargo to build its test proc macro
{ pkgs }:
with pkgs;
{
    deps = {
        "proc-macro-test" = [ cargo ];
    };
    envs = {
        "proc-macro-test" = { "PROC_MACRO_TEST_LOCATION" = ""; };
    };
}
