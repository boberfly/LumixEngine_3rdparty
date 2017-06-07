#include <cstdarg>
#include <cstdio>

namespace bgfx
{
	typedef void(*UserErrorFn)(void*, const char*, va_list);
	static UserErrorFn s_user_error_fn = nullptr;
	static void* s_user_error_ptr = nullptr;
	void setShaderCErrorFunction(UserErrorFn fn, void* user_ptr)
	{
		s_user_error_fn = fn;
		s_user_error_ptr = user_ptr;
	}
}

void printError(FILE* file, const char* format, ...)
{
	va_list args;
	va_start(args, format);
	if (bgfx::s_user_error_fn)
	{
		bgfx::s_user_error_fn(bgfx::s_user_error_ptr, format, args);
	}
	else
	{
		vfprintf(file, format, args);
	}
	va_end(args);
}


#define fprintf printError
#define main lumix_shaderc_main
#include "shaderc.cpp"
#include "shaderc_hlsl.cpp"
#include "shaderc_glsl.cpp"
#define g_allocator g_shaderc_allocator
//#include "shaderc_spirv.cpp"
namespace bgfx 
{
	bool compileSPIRVShader(bx::CommandLine& _cmdLine, uint32_t _version, const std::string& _code, bx::WriterI* _writer)
	{
		return false;
	}
}
#undef fprintf
#include "bx/allocator.h"
