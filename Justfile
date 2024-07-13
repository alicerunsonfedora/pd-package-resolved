run:
    make && PlaydateSimulator ./build/PackageResolved.pdx

make-deps:
    cd Sources/KDL/
    cmake .
    make

kdl-parser-dump:
    ./Sources/KDL/src/utils/ckdl-parse-events Source/prconfig
