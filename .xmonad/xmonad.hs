-- Import statements
import XMonad

import XMonad.Config.Desktop

import XMonad.Layout.NoBorders 
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.TrackFloating
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid

import XMonad.Operations

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops

import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS
import XMonad.Actions.Volume
import XMonad.Actions.FloatSnap
import XMonad.Actions.Promote
import XMonad.Actions.KeyRemap
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Dzen

import System.IO
import System.Exit
import Data.Monoid

import qualified XMonad.StackSet as S
import qualified Data.Map as M
 
myTerminal = "~/.local/kitty.app/bin/kitty"
mainColor = "#5091ca"
colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#5091ca"

-- Define the names of all workspaces
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "?"]

data AllFloats = AllFloats deriving (Read, Show)
instance SetsAmbiguous AllFloats where
    hiddens _ wset _ _ _ = M.keys $ S.floating wset
 
myLayout = lessBorders AllFloats $ avoidStruts $ tiled ||| Mirror tiled ||| Full ||| tabs ||| simplestFloat
     where
     tiled = trackFloating $ spacing 3 $ ResizableTall 1 (2/100) (1/2) []
     tabs = simpleTabbed

altMask = mod1Mask
winMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $ 
    [ 
        -- Close window
        ((winMask , xK_c), kill)

        -- Workspace / window management (win)
	-- isFloating ? bring to master
	-- place allwindows shift p
        , ((winMask, xK_j), windows S.focusDown)
        , ((winMask, xK_k), windows S.focusUp)
        , ((winMask .|. altMask, xK_j), windows S.swapDown)
        , ((winMask .|. altMask, xK_k), windows S.swapUp)
	, ((winMask, xK_m), windows S.focusMaster)
	, ((winMask .|. altMask, xK_m), windows S.swapMaster)
        , ((winMask, xK_p), withFocused $ windows . S.sink)
        , ((altMask, xK_Tab), windows S.focusDown)
        , ((altMask .|. shiftMask, xK_Tab), windows S.focusUp)
        , ((winMask, xK_Tab), toggleWS)
        , ((winMask, xK_space), toggleWS)
	, ((winMask, xK_n), moveTo Next EmptyWS)
        , ((winMask, xK_h), prevWS)
        , ((winMask, xK_l), nextWS)
	, ((winMask, xK_BackSpace), nextScreen)
	, ((winMask .|. altMask, xK_BackSpace), shiftNextScreen)
        , ((winMask .|. altMask, xK_h), shiftToPrev >> prevWS)
        , ((winMask .|. altMask, xK_l), shiftToNext >> nextWS)
        , ((winMask, xK_g), goToSelected defaultGSConfig)
	, ((winMask, xK_b), sendMessage ToggleStruts)
	, ((winMask, xK_comma  ), sendMessage Shrink)
	, ((winMask, xK_period ), sendMessage Expand)
	, ((winMask .|. altMask, xK_comma), sendMessage MirrorShrink)
	, ((winMask .|. altMask, xK_period ), sendMessage MirrorExpand)
	, ((winMask .|. altMask, xK_BackSpace), windows $ S.shift "dump")
	, ((winMask, xK_o), spawn "obsidian")
	, ((winMask, xK_Return), spawn "dmenu_run -b")
	, ((0, xK_Print), spawn "scrot -q 95 '%Y-%m-%d-%H-%M-%S_$wx$h.png' -e 'mv $f ~/Pictures/'")
	, ((altMask, xK_Print), spawn "scrot -s -q 95 '%Y-%m-%d-%H-%M-%S_$wx$h.png' -e 'mv $f ~/Pictures/'")
	, ((winMask, xK_bracketleft), sendMessage (IncMasterN 1))
	, ((winMask, xK_bracketright), sendMessage (IncMasterN (-1)))
        , ((winMask, xK_semicolon), sendMessage NextLayout)
        , ((winMask, xK_quotedbl), sendMessage FirstLayout)
	, ((winMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
	, ((winMask, xK_Return), spawn "rofi -rnow -show run")
	, ((winMask, xK_slash), spawn "rofi -show window")
	, ((winMask, xK_r), spawn "rofi -show ssh")
	, ((winMask, xK_f), spawn "rofi -show fb -modi fb:~/linux/rofi-file-browser.sh")
	, ((winMask, xK_q), spawn "killall conky dzen2 trayer && sleep 1" >> (restart "/home/olafs/.xmonad/xmonad-x86_64-linux" True))

	, ((0, 0x1008ff11), lowerVolume 4 >>= alert)
	, ((0, 0x1008ff13), raiseVolume 4 >>= alert)  
	, ((winMask, xK_Left), lowerVolume 4 >>= alert)
	, ((winMask, xK_Right), raiseVolume 4 >>= alert)  

	-- Programs (alt)
	, ((winMask, xK_t), spawn myTerminal)
	, ((winMask, xK_s), spawn "thunar /space/")
	, ((winMask, xK_e), spawn "thunar")
	, ((winMask, xK_d), spawn "thunar Desktop")

    ]
    ++
    [ ((m .|. winMask, k), windows $ f i)
	| (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
	, (f, m) <- [(S.greedyView, 0), (S.shift, altMask)]
    ]
    where
	alert = dzenConfig return . show

myMouseBindings (XConfig {XMonad.modMask = winMask}) = M.fromList $
	[
	((0, button3), (\w -> focus w >> mouseMoveWindow w >> windows S.shiftMaster))
	,((winMask .|. altMask, button1), (\w -> focus w >> mouseMoveWindow w >> snapMagicMove (Just 50) (Just 50) w))
	,((winMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows S.shiftMaster))
	, ((winMask, button2), (\w -> focus w >> windows S.shiftMaster))
	]

-- Bring clicked window to front
floatClickFocusHandler :: Event -> X All
floatClickFocusHandler ButtonEvent { ev_window = w } = do
	withWindowSet $ \s -> do
		if isFloat w s
		   then (focus w >> promote)
		   else return ()
		return (All True)
		where isFloat w ss = M.member w $ S.floating ss
floatClickFocusHandler _ = return (All True)

myEventHook = floatClickFocusHandler

--Bar
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor mainColor "#000A1F" . pad
      , ppVisible           =   dzenColor "white" "#000A1F" . pad
      , ppHidden            =   dzenColor "white" "#000A1F" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#000A1F" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#000A1F" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor mainColor "#000A1F" .
                                (\x -> case (x) of
                                    "Spacing ResizableTall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror Spacing ResizableTall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "Tabbed Simplest"              ->      "~"
                                    _                           ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor "white" "#000A1F" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }

myManageHook :: ManageHook
myManageHook = (composeAll . concat $
		[ [resource     =? r --> doIgnore            |   r   <- myIgnores] -- ignore desktop
		, [className    =? c --> doShift  "1"      |   c   <- myWebs   ] -- move webs to net
		, [className    =? c --> doShift  "2"      |   c   <- myDev    ] -- move webs to main
		, [className    =? c --> doShift  "6"     |   c   <- myChat   ] -- move chat to chat
		, [className    =? c --> doShift  "5"    |   c   <- myMedia  ] -- move dev to main
		, [className    =? c --> doShift  "7"     |   c   <- myDump   ] -- move img to div
		, [className    =? c --> doCenterFloat       |   c   <- myFloats ] -- float my floats
		, [name         =? n --> doCenterFloat       |   n   <- myNames  ] -- float my names
		, [isFullscreen                 --> doFullFloat                  ]
		, [manageDocks]
		])
	where

	role      = stringProperty "WM_WINDOW_ROLE"
	name      = stringProperty "WM_NAME"

	-- classnames
	myFloats  = ["Smplayer","MPlayer","VirtualBox","Xmessage","XFontSel","Downloads","Nm-connection-editor"]
	myWebs    = ["Opera","Iceweasel","Firefox","Google-chrome","Chromium", "Chromium-browser"]
	myMovie   = ["Boxee","Trine","vlc"]
	myMusic	  = ["Rhythmbox","Spotify"]
	myGimp	  = ["Gimp"]
	myMedia   = myMusic ++ myMovie ++ myGimp
	myChat	  = ["Skype","Pidgin","Telegram"]
	myDev	  = ["Gvim"]
	myDump    = []

	-- resources
	myIgnores = ["desktop","desktop_window","notify-osd","stalonetray"]

	-- names
	myNames   = ["bashrun","Google Chrome Options","Chromium Options"]
 

myXmonadBar = "dzen2 -dock -x '0' -y '0' -h '18' -w '1420' -ta 'l' -fn 'Carlito:size=11' -fg '#FFFFFF' -bg '#000A1F'"
myStatusBar = "conky -b -c /home/olafs/.xmonad/.conky_dzen | dzen2 -dock -x '1520' -w '400' -h '18' -ta 'r' -fn 'Carlito:size=11' -bg '#000A1F' -fg '#FFFFFF' -y '0'"
myTrayer = "trayer --edge top --align right --SetDockType true --expand true --transparent true --tint 0x000A1F --alpha 0 --height 18 --widthtype pixel --width 100 --distancefrom right --distance 400"

myStartup = do
	spawn myTrayer
	return()

myBitmapsDir = "/home/olafs/.xmonad/dzen2"

-- Run XMonad with the defaults
main = do
    spawn "feh --bg-scale ~/linux/vid-ne-52.jpg"
    spawn "python ~/linux/xmodmap.py"
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ ewmh desktopConfig {
    	terminal = myTerminal,
	workspaces = myWorkspaces,
	keys = myKeys,
	-- mouseBindings = myMouseBindings,
	modMask = winMask,
        manageHook = myManageHook,
	layoutHook = myLayout,
	handleEventHook = do
	    myEventHook
	    docksEventHook,
	startupHook = myStartup,
	logHook = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd,
        normalBorderColor = colorNormalBorder,
        focusedBorderColor = colorFocusedBorder,
        borderWidth = 1
    }
