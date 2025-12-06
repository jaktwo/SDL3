// module:   SDL3
// file:     module.jai
// author:   James Oswald <jamesoswald111@gmail.com>, jamesoswald.dev
// modified: jak2         <jak2@clover-work.shop>
//
///////////////////////////////////
//                               //
//                  +xxxx        //
//       +xxx+    +xxxxxxx       //
//     +xxxxxxx+  xxxxxxxx<      //
//     +xxxxxxxx+ xxx$xxxxxxxx+  //
//   x+xxxxx$$$$xxx$$$$$xxxxxxxx //
// xxxxxxxxx$$xx$xxxx$$$$$xxxxxx //
// +xxxxxx$$$xxxxx+xxxxx$$xxxx+  //
//  xxxxxx$$$$$xx+xx++xxxx++     //
//    +xxxxx++$+xxxxx$$xx+       //
//          +$x$xx$$$$$$xxx      //
//          $xx$$$$x$$xxxxx+     //
//         $+xxxxxxxxxxxxxx+     //
//        +$+xxxxxxxxxxxxxx      //
//        ++ xxxxxx'`xx++        //
//        +x                     //
//        +$.                    //
//         $+.                   //
//                               //
///////////////////////////////////
//

#module_parameters(SDL_MAIN_USE_CALLBACKS := true);

#if OS == .WINDOWS {
    sdl3 :: #library,no_dll "windows/lib/SDL3";

    #system_library,link_always "user32";
    #system_library,link_always "gdi32";
    #system_library,link_always "advapi32";
    #system_library,link_always "ole32";
    #system_library,link_always "shell32";
    #system_library,link_always "winmm";
    #system_library,link_always "setupapi";
    #system_library,link_always "version";
    #system_library,link_always "imm32";
    #system_library,link_always "cfgmgr32";
    #system_library,link_always "oleaut32";
    #system_library,link_always "uuid";
    #system_library,link_always "msvcrt";
    #system_library,link_always "oldnames";
    
    #load "windows/SDL.jai";
} else {
    log_error("Unsupported SDL3 platform");
}

// Some #defines that don't get auto-generated properly

SDL_min :: (a : $T, b : T) -> T #expand
{
    ifx a < b then a else b;
}

SDL_WINDOW_FULLSCREEN           :: 0x0000000000000001;    /**< window is in fullscreen mode */
SDL_WINDOW_OPENGL               :: 0x0000000000000002;    /**< window usable with OpenGL context */
SDL_WINDOW_OCCLUDED             :: 0x0000000000000004;    /**< window is occluded */
SDL_WINDOW_HIDDEN               :: 0x0000000000000008;    /**< window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible */
SDL_WINDOW_BORDERLESS           :: 0x0000000000000010;    /**< no window decoration */
SDL_WINDOW_RESIZABLE            :: 0x0000000000000020;    /**< window can be resized */
SDL_WINDOW_MINIMIZED            :: 0x0000000000000040;    /**< window is minimized */
SDL_WINDOW_MAXIMIZED            :: 0x0000000000000080;    /**< window is maximized */
SDL_WINDOW_MOUSE_GRABBED        :: 0x0000000000000100;    /**< window has grabbed mouse input */
SDL_WINDOW_INPUT_FOCUS          :: 0x0000000000000200;    /**< window has input focus */
SDL_WINDOW_MOUSE_FOCUS          :: 0x0000000000000400;    /**< window has mouse focus */
SDL_WINDOW_EXTERNAL             :: 0x0000000000000800;    /**< window not created by SDL */
SDL_WINDOW_MODAL                :: 0x0000000000001000;    /**< window is modal */
SDL_WINDOW_HIGH_PIXEL_DENSITY   :: 0x0000000000002000;    /**< window uses high pixel density back buffer if possible */
SDL_WINDOW_MOUSE_CAPTURE        :: 0x0000000000004000;    /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
SDL_WINDOW_MOUSE_RELATIVE_MODE  :: 0x0000000000008000;    /**< window has relative mode enabled */
SDL_WINDOW_ALWAYS_ON_TOP        :: 0x0000000000010000;    /**< window should always be above others */
SDL_WINDOW_UTILITY              :: 0x0000000000020000;    /**< window should be treated as a utility window, not showing in the task bar and window list */
SDL_WINDOW_TOOLTIP              :: 0x0000000000040000;    /**< window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window */
SDL_WINDOW_POPUP_MENU           :: 0x0000000000080000;    /**< window should be treated as a popup menu, requires a parent window */
SDL_WINDOW_KEYBOARD_GRABBED     :: 0x0000000000100000;    /**< window has grabbed keyboard input */
SDL_WINDOW_VULKAN               :: 0x0000000010000000;    /**< window usable for Vulkan surface */
SDL_WINDOW_METAL                :: 0x0000000020000000;    /**< window usable for Metal view */
SDL_WINDOW_TRANSPARENT          :: 0x0000000040000000;    /**< window with transparent buffer */
SDL_WINDOW_NOT_FOCUSABLE        :: 0x0000000080000000;    /**< window should not be focusable */



#scope_file

#import "Compiler";

SDL_AppInit_jai_func    :: #type (**void, s32, **u8) -> SDL_AppResult;
SDL_AppEvent_jai_func   :: #type (*void, *SDL_Event) -> SDL_AppResult;
SDL_AppIterate_jai_func :: #type (*void) -> SDL_AppResult;
SDL_AppQuit_jai_func    :: #type (*void, SDL_AppResult) -> ();


#if SDL_MAIN_USE_CALLBACKS {

_SDL_AppInit :: (appstate: **void, argc: s32, argv: **u8) -> SDL_AppResult #c_call
{
    push_context context_pointer
    {
        return jai_appinit(appstate, argc, argv);
    }
}

_SDL_AppEvent :: (appstate: *void, event: *SDL_Event) -> SDL_AppResult #c_call
{
    push_context context_pointer
    {
        return jai_appevent(appstate, event);
    }
}

_SDL_AppIterate :: (appstate: *void) -> SDL_AppResult #c_call
{
    push_context context_pointer
    {
        return jai_appiter(appstate);
    }
}

_SDL_AppQuit :: (appstate: *void, result: SDL_AppResult) #c_call
{
    push_context context_pointer
    {
        jai_appquit(appstate, result);
    }
}

context_pointer: *#Context;
jai_appinit:  SDL_AppInit_jai_func;
jai_appiter:  SDL_AppIterate_jai_func;
jai_appevent: SDL_AppEvent_jai_func;
jai_appquit:  SDL_AppQuit_jai_func;

#scope_export

SDL_EnterAppMainCallbacks :: (appinit: SDL_AppInit_jai_func, appiter: SDL_AppIterate_jai_func, appevent: SDL_AppEvent_jai_func, appquit: SDL_AppQuit_jai_func) -> s32 #expand
{
    context_pointer = *context;
    
    jai_appinit  = appinit;
    jai_appiter  = appiter;
    jai_appevent = appevent;
    jai_appquit  = appquit;
    
    return SDL_EnterAppMainCallbacks(0, null, _SDL_AppInit, _SDL_AppIterate, _SDL_AppEvent, _SDL_AppQuit);   
}

}
