#!/bin/bash
rm -rf build
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug -G "CodeBlocks - Unix Makefiles"
cmake --build . --target ISB-UAVBus.elf -- -j 4
echo "===================================================="
if [ $? -eq 0 ]
    then
    echo "All done!"
else
    echo "Build failed."
fi