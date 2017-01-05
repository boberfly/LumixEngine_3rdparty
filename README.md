# LumixEngine - 3rd party libraries
Source of 3rd party libraries for [Lumix Engine](https://github.com/nem0/LumixEngine)

3rd party libraries in this repository:

* [bgfx](https://github.com/bkaradzic/bgfx)
* [lua](https://github.com/LuaDist/lua)
* [crunch](https://github.com/richgel999/crunch)
* [assimp](https://github.com/assimp/assimp)
* [recast/detour](https://github.com/recastnavigation)
* [SDL](https://www.libsdl.org/)
* [cmft](https://github.com/dariomanesku/cmft)

The 3rd party libraries are git submodules.

Steps to build and install the libraries on Windows:

1. run projects/genie_vs13.bat
2. open projects/tmp/LumixEngine_3rdparty.sln in Visual Studio 2013
3. build the solution
4. run projects/genie_install.bat

Steps to build and install the libraries on Windows:

1. cd projects
2. ./genie_linux --gcc=linux-gcc-5 gmake
3. cd tmp/gcc5
4. make config=debug64


Note: the [source code repository](https://github.com/nem0/LumixEngine) must be cloned in the same directory as this repository is cloned

