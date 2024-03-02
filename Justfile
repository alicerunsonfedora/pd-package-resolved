test:
    #!/bin/sh
    make test -B
    ./test/test_app

fmt:
    #!/bin/sh
    find charolette -name '*.[ch]' | xargs \
        clang-format --style='file:.clang-format' -i
    find include -name '*.[ch]' | xargs \
        clang-format --style='file:.clang-format' -i
    find src -name '*.[ch]' | xargs \
        clang-format --style='file:.clang-format' -i
    find test -name '*.[ch]' | xargs \
        clang-format --style='file:.clang-format' -i

completions:
    rm compile_commands.json
    bear -- make real_all