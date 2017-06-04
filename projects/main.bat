<!-- :: Batch section
@echo off
setlocal

echo Select an option:
for /F "delims=" %%a in ('mshta.exe "%~F0"') do set "HTAreply=%%a"
echo End of HTA window, reply: "%HTAreply%"
goto :EOF
-->


<HTML>
<HEAD>
<!--<HTA:APPLICATION SCROLL="no" SYSMENU="no" >-->
<HTA:APPLICATION SCROLL="no">

<TITLE>Install</TITLE>
<SCRIPT language="JavaScript">
window.resizeTo(250,300);
var fso = new ActiveXObject("Scripting.FileSystemObject");
var app = new ActiveXObject("Shell.Application");

function copyShaderC() {
	fso.CopyFile("./tmp/vs2015/bin/win64/relwithdebinfo/shaderc.*", "../../lumixengine/external/bgfx/lib/win64_vs2015/release/")
	fso.CopyFile("./tmp/vs2015/bin/win64/debug/shaderc.*", "../../lumixengine/external/bgfx/lib/win64_vs2015/debug/")
}


function copyBGFX(reply)
{
	fso.CopyFile("./tmp/vs2015/bin/win64/relwithdebinfo/bgfx.*", "../../lumixengine/external/bgfx/lib/win64_vs2015/release/")
	fso.CopyFile("./tmp/vs2015/bin/win64/debug/bgfx.*", "../../lumixengine/external/bgfx/lib/win64_vs2015/debug/")
}

function generateProject()
{
	app.ShellExecute("genie_vs15.bat")
}

function openInVS()
{
	app.ShellExecute("C:/Program Files (x86)/Microsoft Visual Studio 14.0/Common7/IDE/devenv.exe", "tmp/vs2015/LumixEngine_3rdparty.sln")
}

function buildProject(proj, configuration)
{
	app.ShellExecute("C:/Program Files (x86)/MSBuild/14.0/Bin/msbuild.exe", "tmp/vs2015/"+proj+".vcxproj /p:Configuration=" + configuration + " /p:Platform=x64")
}

function cleanAll()
{
	if(fso.FolderExists("tmp")) fso.DeleteFolder("tmp");
	fso.DeleteFile("../../lumixengine/external/bgfx/lib/win64_vs2015/debug/*")
	fso.DeleteFile("../../lumixengine/external/bgfx/lib/win64_vs2015/release/*")
}


</SCRIPT>
</HEAD>
<BODY>
   <button style="width:200" onclick="buildProject('shaderc', 'debug');">Build shaderc - debug</button>
   <button style="width:200" onclick="buildProject('shaderc', 'relwithdebinfo');">Build shaderc - release</button>
   <button style="width:200" onclick="copyShaderC();">Deploy shaderc</button>
   <button style="width:200" onclick="buildProject('bgfx', 'debug');">Build bgfx - debug</button>
   <button style="width:200" onclick="buildProject('bgfx', 'relwithdebinfo');">Build bgfx - release</button>
   <button style="width:200" onclick="copyBGFX();">Deploy bgfx</button>
   <button style="width:200" onclick="generateProject();">Generate VS project</button>
   <button style="width:200" onclick="openInVS();">Open in VS</button>
   <button style="width:200" onclick="cleanAll();">Clean all</button>
</BODY>
</HTML>