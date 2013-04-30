
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP)
import System.IO
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

myLogHook xmproc = do
        --logHook defaultConfig
        dynamicLogWithPP $ xmobarPP {
                ppOutput = hPutStrLn xmproc,
                ppTitle = xmobarColor "green" "". shorten 50
         }
        fadeInactiveLogHook 0xdddddddd -- or 0.0 - 1.0

myFloatHooks = composeAll
    [ className =? "Pidgin" --> doFloat
    , className =? "Transmission-qtk" --> doFloat
    , className =? "Skype" --> doFloat
    ]

myManageHook = manageDocks <+> myFloatHooks <+> manageHook defaultConfig

main = do
    xmproc <- spawnPipe "xmobar /home/bill/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = myManageHook
        , handleEventHook = fullscreenEventHook
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = myLogHook xmproc
        , modMask = mod4Mask -- Rebind Mod to the Windows key
        , startupHook = setWMName "LG3D"
        , terminal = "gnome-terminal --hide-menubar"
        } `additionalKeysP`
        [ ("A-l", spawn "xlock")
        , ("A-l", spawn "xlock")
        , ("<Print>", spawn "gnome-screenshot -d 3 -w -B")
        , ("C-<Print>", spawn "gnome-screenshot -d 0.2")
        , ("M-p", spawn "dmenu_run")
        ]
