local IDE = iif(_ACTION == nil, "vs2015", _ACTION)
local LOCATION = "tmp/" .. IDE
local BINARY_DIR = path.join(LOCATION, "bin") .. "/"

newoption {
		trigger = "gcc",
		value = "GCC",
		description = "Choose GCC flavor",
		allowed = {
			{ "asmjs",           	"Emscripten/asm.js"					},
			{ "android-x86",     	"Android - x86" 					},
			{ "linux-gcc", 			"Linux (GCC compiler)" 				},
			{ "linux-gcc-5", 		"Linux (GCC-5 compiler)"			},
			{ "linux-clang", 		"Linux (Clang compiler)"			}
		}
	}

newaction {
	trigger = "install",
	description = "Install in ../../LumixEngine/external",
	execute = function()
		function copyLibrary(lib, copy_dll)
			function copyConf(lib, configuration, copy_dll)
				function copyPlatform(lib, configuration, platform, ide, copy_dll)
					local PLATFORM_DIR = platform .. "/"
					local CONFIGURATION_DIR = configuration .. "/"
					local DEST_DIR = "../../LumixEngine/external"
					function copyLibPdb(ext)
						os.copyfile(path.join("tmp/" .. ide .. "/bin", PLATFORM_DIR .. CONFIGURATION_DIR .. lib .. ext),
							path.join(DEST_DIR, lib .. "/lib/" .. platform .. "_" .. ide .. "/" .. CONFIGURATION_DIR .. lib .. ext))
					end
					function copyDll()
						local ext = ".dll"
						os.copyfile(path.join("tmp/" .. ide .. "/bin", PLATFORM_DIR .. CONFIGURATION_DIR .. lib .. ext),
							path.join(DEST_DIR, lib .. "/dll/" .. platform .. "_" .. ide .. "/" .. CONFIGURATION_DIR .. lib .. ext))
					end
					copyLibPdb(".pdb")
					copyLibPdb(".lib")
					if copy_dll then	
						copyDll()
					end
				end
				copyPlatform(lib, configuration, "win32", "vs2015", copy_dll);
				copyPlatform(lib, configuration, "win64", "vs2015", copy_dll);
			end
			
			copyConf(lib, "release", copy_dll)
			copyConf(lib, "debug", copy_dll)
		end
		
		copyLibrary("lua", false)
		copyLibrary("recast", false)
		copyLibrary("bgfx", false)
		copyLibrary("crnlib", false)
		copyLibrary("assimp", true)
		
		--os.execute("mkdir \"../../LumixEngine/external/bgfx/include\"")
		os.execute("xcopy \"../3rdparty/bgfx/include\" \"../../LumixEngine/external/bgfx/include\"  /S /Y");

		--os.execute("mkdir \"../../LumixEngine/external/lua/include\"")
		os.copyfile("../3rdparty/lua/src/lauxlib.h", "../../LumixEngine/external/lua/include/lauxlib.h");
		os.copyfile("../3rdparty/lua/src/lua.h", "../../LumixEngine/external/lua/include/lua.h");
		os.copyfile("../3rdparty/lua/src/lua.hpp", "../../LumixEngine/external/lua/include/lua.hpp");
		os.copyfile("../3rdparty/lua/src/luaconf.h", "../../LumixEngine/external/lua/include/luaconf.h");
		os.copyfile("../3rdparty/lua/src/lualib.h", "../../LumixEngine/external/lua/include/lualib.h");

		--os.execute("mkdir \"../../LumixEngine/external/crnlib/include\"")
		os.copyfile("../3rdparty/crunch/inc/crn_decomp.h", "../../LumixEngine/external/crnlib/include/crn_decomp.h");
		os.copyfile("../3rdparty/crunch/inc/crnlib.h", "../../LumixEngine/external/crnlib/include/crnlib.h");
		os.copyfile("../3rdparty/crunch/inc/dds_defs.h", "../../LumixEngine/external/crnlib/include/dds_defs.h");

		os.execute("xcopy \"../3rdparty/assimp/include\" \"../../LumixEngine/external/assimp/include\"  /S /Y");

		os.execute("xcopy \"../3rdparty/recastnavigation/Detour/include\" \"../../LumixEngine/external/recast/include\"  /S /Y");
		os.execute("xcopy \"../3rdparty/recastnavigation/Debug/include\" \"../../LumixEngine/external/recast/include\"  /S /Y");
		os.execute("xcopy \"../3rdparty/recastnavigation/DebugUtils/include\" \"../../LumixEngine/external/recast/include\"  /S /Y");

	end
}


function install(ide, platform)
	function copyLibrary(lib)
		function copyConf(lib, configuration)
			local PLATFORM_DIR = platform .. "/"
			local CONFIGURATION_DIR = configuration .. "/"
			local DEST_DIR = "../../LumixEngine/external"
			--os.execute("mkdir \"".. path.join(DEST_DIR, lib .. "/lib/" .. platform .. "_" .. ide .. "/" .. CONFIGURATION_DIR) .. "\"")
			
			local from = path.join("tmp/" .. platform .. "_" .. ide .. "/bin", PLATFORM_DIR .. CONFIGURATION_DIR .. "lib" .. lib .. ".a")
			local to = path.join(DEST_DIR, lib .. "/lib/" .. platform .. "_" .. ide .. "/" .. CONFIGURATION_DIR .. "lib" .. lib .. ".a")
			os.copyfile(from, to)
		end
		
		copyConf(lib, "release")
		copyConf(lib, "debug")
	end
	
	copyLibrary("lua")
	copyLibrary("recast")
	copyLibrary("bgfx")
	
	os.execute("xcopy \"../3rdparty/bgfx/include\" \"../../LumixEngine/external/bgfx/include\"  /S /Y");

	os.copyfile("../3rdparty/lua/src/lauxlib.h", "../../LumixEngine/external/lua/include/lauxlib.h");
	os.copyfile("../3rdparty/lua/src/lua.h", "../../LumixEngine/external/lua/include/lua.h");
	os.copyfile("../3rdparty/lua/src/lua.hpp", "../../LumixEngine/external/lua/include/lua.hpp");
	os.copyfile("../3rdparty/lua/src/luaconf.h", "../../LumixEngine/external/lua/include/luaconf.h");
	os.copyfile("../3rdparty/lua/src/lualib.h", "../../LumixEngine/external/lua/include/lualib.h");

	os.execute("xcopy \"../3rdparty/recastnavigation/Detour/include\" \"../../LumixEngine/external/recast/include\"  /S /Y");
	os.execute("xcopy \"../3rdparty/recastnavigation/Debug/include\" \"../../LumixEngine/external/recast/include\"  /S /Y");
	os.execute("xcopy \"../3rdparty/recastnavigation/DebugUtils/include\" \"../../LumixEngine/external/recast/include\"  /S /Y");
end



newaction {
	trigger = "install-emscripten",
	description = "Install in ../../LumixEngine/external",
	execute = function()
		install("gmake", "emscripten")
	end
}


newaction {
	trigger = "install-android-x86",
	description = "Install in ../../LumixEngine/external",
	execute = function()
		install("gmake", "android-x86")
	end
}

function defaultConfigurations()
	configuration "Debug"
		defines { "DEBUG" }
		flags { "Symbols", "WinMain" }
	configuration "Release"
		defines { "NDEBUG" }
		flags { "Optimize", "WinMain" }
	configuration {}

	local platforms = {}
	platforms["windows"] = {x64 = "win64", x32 = "win32"}
	platforms["linux"] = {x64 = "linux64", x32 = "linux32"}
	platforms["android-x86"] = {x64 = "android-x86", x32 = "android-x86"}
	
	for _, platform_bit in ipairs({ "x64", "x32" }) do
		for platform, platform_dirs in pairs(platforms) do
			local platform_dir = platform_dirs[platform_bit]
			configuration {platform_bit, platform, "Debug"}
				targetdir(BINARY_DIR .. platform_dir .. "/debug")
			configuration {platform_bit, platform, "Release"}
				targetdir(BINARY_DIR .. platform_dir .. "/release")
		end
	end

	configuration {}
end

solution "LumixEngine_3rdparty"
	if _ACTION == "gmake" then
	
		configuration { "android-*" }
			flags {
				"NoImportLib",
			}
			includedirs {
				"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.9/include",
				"$(ANDROID_NDK_ROOT)/sources/android/native_app_glue",
			}
			linkoptions {
				"-nostdlib",
				"-static-libgcc",
			}
			links {
				"c",
				"dl",
				"m",
				"android",
				"log",
				"gnustl_static",
				"gcc",
			}
			buildoptions {
				"-fPIC",
				"-no-canonical-prefixes",
				"-Wa,--noexecstack",
				"-fstack-protector",
				"-ffunction-sections",
				"-Wno-psabi",
				"-Wunused-value",
				"-Wundef",
			}
			buildoptions_cpp {
				"-std=c++0x",
			}
			linkoptions {
				"-no-canonical-prefixes",
				"-Wl,--no-undefined",
				"-Wl,-z,noexecstack",
				"-Wl,-z,relro",
				"-Wl,-z,now",
			}
		
		configuration { "android-x86" }
			androidPlatform = "android-24"
			libdirs {
				path.join(_libDir, "lib/android-x86"),
				"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.9/libs/x86",
			}
			includedirs {
				"$(ANDROID_NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/4.9/libs/x86/include",
			}
			buildoptions {
				"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86"),
				"-march=i686",
				"-mtune=atom",
				"-mstackrealign",
				"-msse3",
				"-mfpmath=sse",
				"-Wunused-value",
				"-Wundef",
			}
			linkoptions {
				"--sysroot=" .. path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86"),
				path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "arch-x86/usr/lib/crtbegin_so.o"),
				path.join("$(ANDROID_NDK_ROOT)/platforms", androidPlatform, "/arch-x86/usr/lib/crtend_so.o"),
			}
		configuration {}			
			
	
		if "asmjs" == _OPTIONS["gcc"] then

			if not os.getenv("EMSCRIPTEN") then
				print("Set EMSCRIPTEN enviroment variable.")
			end
			premake.gcc.cc   = "\"$(EMSCRIPTEN)/emcc\""
			premake.gcc.cxx  = "\"$(EMSCRIPTEN)/em++\""
			premake.gcc.ar   = "\"$(EMSCRIPTEN)/emar\""
			premake.gcc.llvm = true
			LOCATION = "tmp/emscripten_gmake"
		elseif "android-arm" == _OPTIONS["gcc"] then

			if not os.getenv("ANDROID_NDK_ARM") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_ARM and ANDROID_NDK_ROOT envrionment variables.")
			end

			premake.gcc.cc  = "\"$(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-gcc\""
			premake.gcc.cxx = "\"$(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-g++\""
			premake.gcc.ar  = "\"$(ANDROID_NDK_ARM)/bin/arm-linux-androideabi-ar\""
			LOCATION = "tmp/android-arm_gmake"

		elseif "android-mips" == _OPTIONS["gcc"] then

			if not os.getenv("ANDROID_NDK_MIPS") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_MIPS and ANDROID_NDK_ROOT envrionment variables.")
			end

			premake.gcc.cc  = "\"$(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-gcc\""
			premake.gcc.cxx = "\"$(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-g++\""
			premake.gcc.ar  = "\"$(ANDROID_NDK_MIPS)/bin/mipsel-linux-android-ar\""
			LOCATION = "tmp/android-mips_gmake"

		elseif "android-x86" == _OPTIONS["gcc"] then

			if not os.getenv("ANDROID_NDK_X86") or not os.getenv("ANDROID_NDK_ROOT") then
				print("Set ANDROID_NDK_X86 and ANDROID_NDK_ROOT envrionment variables.")
			end

			premake.gcc.cc  = "\"$(ANDROID_NDK_X86)/bin/i686-linux-android-gcc\""
			premake.gcc.cxx = "\"$(ANDROID_NDK_X86)/bin/i686-linux-android-g++\""
			premake.gcc.ar  = "\"$(ANDROID_NDK_X86)/bin/i686-linux-android-ar\""
			LOCATION = "tmp/android-x86_gmake"

		elseif "linux-gcc" == _OPTIONS["gcc"] then
			LOCATION = "tmp/linux_gcc"

		elseif "linux-gcc-5" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "gcc-5"
			premake.gcc.cxx = "g++-5"
			premake.gcc.ar  = "ar"
			LOCATION = "tmp/linux_gcc5"
			
		elseif "linux-clang" == _OPTIONS["gcc"] then
			premake.gcc.cc  = "clang"
			premake.gcc.cxx = "clang++"
			premake.gcc.ar  = "ar"
			LOCATION = "tmp/linux_clang"

		end
		BINARY_DIR = LOCATION .. "/bin/"
	end

	configurations { "Debug", "Release", "RelWithDebInfo" }
	platforms { "x32", "x64" }
	flags { "NoPCH" }
	location(LOCATION) 
	language "C++"

project "lua"
	kind "StaticLib"

	files { "../3rdparty/lua/src/**.h", "../3rdparty/lua/src/**.c", "genie.lua" }
	excludes { "../3rdparty/lua/src/luac.c", "../3rdparty/lua/src/lua.c" }

	defaultConfigurations()


project "recast"
	kind "StaticLib"

	configuration { "vs*" }
		defines { "_CRT_SECURE_NO_WARNINGS" }

	configuration {}
	
	includedirs { "../3rdparty/recastnavigation/Recast/Include"
		, "../3rdparty/recastnavigation/Detour/Include"
		, "../3rdparty/recastnavigation/DebugUtils/Include"
		, "../3rdparty/recastnavigation/DetourTileCache/Include"
	}

	files { "../3rdparty/recastnavigation/Recast/**.h"
		, "../3rdparty/recastnavigation/Recast/**.cpp"
		, "../3rdparty/recastnavigation/Detour/**.h"
		, "../3rdparty/recastnavigation/Detour/**.cpp"
		, "../3rdparty/recastnavigation/DebugUtils/**.h"
		, "../3rdparty/recastnavigation/DebugUtils/**.cpp"
		, "../3rdparty/recastnavigation/DetourTileCache/**.h"
		, "../3rdparty/recastnavigation/DetourTileCache/**.cpp"
		, "genie.lua" }

	defaultConfigurations()

project "crnlib"
	kind "StaticLib"

	files { "../3rdparty/crunch/crnlib/**.h", "../3rdparty/crunch/crnlib/**.cpp", "genie.lua" }
	excludes { "../3rdparty/crunch/crnlib/lzham*" }

configuration "windows"
		defines { "WIN32", "_LIB" }
		excludes { "../3rdparty/crunch/crnlib/crn_threading_pthreads.*" }
	configuration "not windows"
		excludes {
			"../3rdparty/crunch/crnlib/crn_threading_win32.*",
			"../3rdparty/crunch/crnlib/lzma_Threads.cpp",
			"../3rdparty/crunch/crnlib/lzma_LzFindMt.cpp",
		}
		buildoptions { "-fomit-frame-pointer", "-ffast-math", "-fno-math-errno", "-fno-strict-aliasing" }
	configuration {"not windows", "Debug"}
		defines { "_DEBUG" }
	configuration {}
	
	defaultConfigurations()

project "assimp"
	kind "SharedLib"
	files { "../3rdparty/assimp/code/**.h"
		, "../3rdparty/assimp/code/**.cpp"
		, "../3rdparty/assimp/include/**.h"
		, "../3rdparty/assimp/contrib/**.c"
		, "../3rdparty/assimp/contrib/**.cpp"
		, "../3rdparty/assimp/contrib/**.cc"
		, "../3rdparty/assimp/contrib/**.h"
		, "genie.lua" 
	}
	includedirs { "../3rdparty/assimp/code/BoostWorkaround/"
		, "../3rdparty/assimp/include"
		, "../misc/assimp"
		, "../3rdparty/assimp/contrib/rapidjson/include"
		, "../3rdparty/assimp/contrib/openddlparser/include"
		, "../3rdparty/assimp/contrib/unzip"
		, "../3rdparty/assimp/contrib/zlib"
	}
	defines {
		"OPENDDL_NO_USE_CPP11",
		"ASSIMP_BUILD_BOOST_WORKAROUND",
		"ASSIMP_BUILD_NO_C4D_IMPORTER",
		"ASSIMP_BUILD_DLL_EXPORT",
		"OPENDDLPARSER_BUILD",
		"assimp_EXPORTS",
		"_SCL_SECURE_NO_WARNINGS",
		"_CRT_SECURE_NO_WARNINGS"
	}	
		
	defaultConfigurations()

project ("bgfx" )
	uuid (os.uuid("bgfx"))
	kind "StaticLib"

	defaultConfigurations()


	configuration { "vs*" }
		BGFX_DIR = path.getabsolute("../3rdparty/bgfx")
		local BX_DIR = path.getabsolute(path.join(BGFX_DIR, "../bx"))

		buildoptions {
			"/Oy-",
			"/Ob2"
		}
		
		flags {
			"NativeWChar",
			"NoRTTI",
			"NoExceptions",
			"NoEditAndContinue",
			"Symbols"
		}

		defines {
			"WIN32",
			"_WIN32",
			"_HAS_EXCEPTIONS=0",
			"_SCL_SECURE=0",
			"_SECURE_SCL=0",
			"_SCL_SECURE_NO_WARNINGS",
			"_CRT_SECURE_NO_WARNINGS",
			"_CRT_SECURE_NO_DEPRECATE",
			"__STDC_LIMIT_MACROS",
			"__STDC_FORMAT_MACROS",
			"__STDC_CONSTANT_MACROS",
			"BX_CONFIG_ENABLE_MSVC_LEVEL4_WARNINGS=1"
		}

		linkoptions {
			"/ignore:4221", -- LNK4221: This object file does not define any previously undefined public symbols, so it will not be used by any link operation that consumes this library
		}

		includedirs {
			path.join(BX_DIR, "include/compat/msvc"),
			path.join(BGFX_DIR, "3rdparty/dxsdk/include"),
		}
		
	configuration {}

	
	
	includedirs {
		path.join(BGFX_DIR, "3rdparty"),
		path.join(BGFX_DIR, "../bx/include"),
		path.join(BGFX_DIR, "3rdparty/khronos"),
		path.join(BGFX_DIR, "include")
	}

	files {
		path.join(BGFX_DIR, "include/**.h"),
		path.join(BGFX_DIR, "src/**.cpp"),
		path.join(BGFX_DIR, "src/**.h"),
	}

	removefiles {
		path.join(BGFX_DIR, "src/**.bin.h"),
	}

	excludes {
		path.join(BGFX_DIR, "src/amalgamated.**"),
	}

	configuration { "Debug" }
		defines {
			"BGFX_CONFIG_DEBUG=1",
		}
