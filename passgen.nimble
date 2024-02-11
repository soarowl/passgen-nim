import std/strformat
import src/config

# Project information
version       = pkgVersion
author        = pkgAuthor
description    = pkgDescription
license       = "MIT"
srcDir        = "src"
bin           = @["passgen"]


# Dependencies

requires "nim >= 2.0.2, cligen >= 1.6.18"

const
    options = "-d:release --passL:-static"

task linux, "Build passgen for Linux (x64)":
    exec fmt"nim c {options} src/passgen.nim"
    exec "mv src/passgen bin/passgen"
    exec "strip bin/passgen"
    withDir("bin"):
        exec fmt"7z a passgen-linux-v{version}.7z config passgen"

task windows, "Build passgen for Windows (x64)":
    exec fmt"nim c -d:mingw {options} src/passgen.nim"
    exec "mv src/passgen.exe bin/passgen.exe"
    exec "strip bin/passgen.exe"
    withDir("bin"):
        exec fmt"7z a passgen-windows-v{version}.7z config passgen.exe"

task release, "Build for Linux and Windows":
    linuxTask()
    windowsTask()