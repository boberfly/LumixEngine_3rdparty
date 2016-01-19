local IDE = iif(_ACTION == nil, "vs2013", _ACTION)
local LOCATION = "tmp/" .. IDE
local BINARY_DIR = path.join(LOCATION, "bin") .. "/"

newaction {
	trigger = "install",
	description = "Install in ../../LumixEngine/external",
	execute = function()
		function copyLib(lib)
			function copyConf(lib, configuration)
				function copyPlatform(lib, configuration, platform, ide)
					local PLATFORM_DIR = platform .. "/"
					local CONFIGURATION_DIR = configuration .. "/"
					local DEST_DIR = "../../LumixEngine/external"
					function c(ext)
						os.copyfile(path.join("tmp/" .. ide .. "/bin", PLATFORM_DIR .. CONFIGURATION_DIR .. lib .. ext),
							path.join(DEST_DIR, lib .. "/lib/" .. platform .. "_" .. ide .. "/" .. CONFIGURATION_DIR .. lib .. ext))
					end
					c(".pdb")
					c(".lib")
				end
				copyPlatform(lib, configuration, "win32", "vs2013");
				copyPlatform(lib, configuration, "win64", "vs2013");
				copyPlatform(lib, configuration, "win32", "vs2015");
				copyPlatform(lib, configuration, "win64", "vs2015");
			end
			
			copyConf(lib, "release")
			copyConf(lib, "debug")
		end
		
		copyLib("lua")
		copyLib("bgfx")
		copyLib("crnlib")
		
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
	end
}

function defaultConfigurations()
	configuration {"x64", "Debug" }
		targetdir(BINARY_DIR .. "win64/Debug")
		defines { "DEBUG" }
		flags { "Symbols", "WinMain" }

	configuration {"x32", "Debug" }
		targetdir(BINARY_DIR .. "win32/Debug")
		defines { "DEBUG" }
		flags { "Symbols", "WinMain" }

	configuration {"x64", "Release"}
		targetdir(BINARY_DIR .. "win64/Release")
		defines { "NDEBUG" }
		flags { "Optimize", "WinMain" }

	configuration { "x32", "Release" }
		targetdir(BINARY_DIR .. "win32/Release")
		defines { "NDEBUG" }
		flags { "Optimize", "WinMain" }
		
	configuration {}
end

solution "LumixEngine_3rdparty"
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

project "crnlib"
	kind "StaticLib"

	files { "../3rdparty/crunch/crnlib/**.h", "../3rdparty/crunch/crnlib/**.cpp", "genie.lua" }
	excludes { "../3rdparty/crunch/crnlib/lzham*" }

	defines { "WIN32", "_LIB" }
	defaultConfigurations()

project ("bgfx" )
	uuid (os.uuid("bgfx"))
	kind "StaticLib"

	defaultConfigurations()

	configuration {}
	BGFX_DIR = path.getabsolute("../3rdparty/bgfx")
	local BX_DIR = path.getabsolute(path.join(BGFX_DIR, "../bx"))

	flags {
		"NativeWChar",
		"NoRTTI",
		"NoExceptions",
		"NoEditAndContinue",
		"Symbols"
	}

	buildoptions {
		"/Oy-",
		"/Ob2"
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
		path.join(BGFX_DIR, "3rdparty"),
		path.join(BGFX_DIR, "3rdparty/dxsdk/include"),
		path.join(BGFX_DIR, "../bx/include"),
	}


	includedirs {
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