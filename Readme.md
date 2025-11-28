# Oswald's Jai SDL3 Bindings

Borrows heavily from SDL2 builder in the standard library,
and [Overlord's SDL3 bindings](https://github.com/overlord-systems/jai-sdl3).

modified by jak2 <jak2@clover-work.shop> to link statically against SDL3 on windows.

you will need to add these on your link command (build.jai example code):

```jai
workspace := compiler_create_workspace("example");

build_options := get_build_options(workspace);

build_options.additional_linker_arguments = .[
		"user32.lib", "gdi32.lib", "advapi32.lib", "ole32.lib",
		"shell32.lib", "winmm.lib", "setupapi.lib", "version.lib",
		"imm32.lib", "cfgmgr32.lib", "oleaut32.lib", "uuid.lib",
        "msvcrt.lib", "oldnames.lib"
];
```
