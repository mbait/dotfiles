import System.Exit

import XMonad

import XMonad.Actions.GridSelect

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place
import XMonad.Hooks.Place
import XMonad.Hooks.UrgencyHook

import XMonad.Util.Replace
import XMonad.Util.Run (unsafeSpawn,spawnPipe,hPutStrLn)
import XMonad.Util.Loggers

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

mySpawnSelected :: GSConfig String -> [(String,String)] -> X ()   
mySpawnSelected conf lst = gridselect conf lst >>= flip whenJust spawn

myLayout = avoidStruts (Mirror tall ||| tall ||| Full)
  where
     tall   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 2/100

myLogHook h = dynamicLogWithPP $ defaultPP {
              ppCurrent  = dzenColor "#222222" "gray" . pad
            , ppHidden   = dzenColor "lightblue" "#222222" . pad
            , ppHiddenNoWindows = dzenColor "#777777"  "#222222" . pad
            , ppWsSep    = "^r(1x10)"
            , ppSep      = "^fg(white)^p(+4)^r(2x2)^p(+4)"
            , ppTitle    = ("^fg(orange)" ++) . dzenEscape
            , ppOutput   = hPutStrLn h
			, ppExtras   = [lDate]
			, ppOrder 	 = \(ws:l:h:xs) -> xs ++ [ws, l, h]
			, ppUrgent   = dzenColor "yellow" "orange" . dzenStrip 
            }
    where
      icon h = "^i(/home/edgar/dzen_bitmaps/" ++ h ++ ")" 
      fill :: String -> Int -> String
      fill h i = "^p(" ++ show i ++ ")" ++ h ++ "^p(" ++ show i ++ ")"
      lDate = date "^fg(white)%a %x"

myManageHook = composeAll [
					title =? "irssi" --> doShift "chat"
					,title =? "rtorrent" --> doShift "misc" 
					,title =? "mcabber" --> doShift "chat" 
					,title =? "GIMP"	--> doFloat
					,title =? "VLC media player"	--> doFloat
					,className =? "freedroidRPG"	--> doShift "misc"
				]
myKeys conf@(XConfig {XMonad.modMask = modm}) = 
			[
			   --((modm,               xK_Print     ), spawn "/home/mbait/scripts/screenshot/screenshot scr")
			 --, ((modm .|. shiftMask, xK_Print     ), spawn "/home/mbait/scripts/screenshot/screenshot win")
			   ((modm              , xK_f         ), spawn "firefox")
			 , ((modm              , xK_o         ), spawn "chromium")
			 , ((modm              , xK_g         ), goToSelected defaultGSConfig)
			 --, ((modm              , xK_i         ), spawnSelected defaultGSConfig ["urxvtc -e screen -dr rtorrent", "urxvtc -e mocp"])
			 , ((modm              , xK_i         ), mySpawnSelected defaultGSConfig [("MOC player", "urxvtc -e mocp"), ("rTorrent", "urxvtc -e screen -dr rtorrent"), ("ePDFView", "epdfview"), ("Eclipse", "eclipse-3.5")])
			]
newKeys x = M.union (keys defaultConfig x) (M.fromList (myKeys x))
    
myStartupHook = do
   -- Focus the second screen.
   screenWorkspace 1 >>= flip whenJust (windows . W.view)
   -- Force the second screen to "misc", e.g. if the first screen already has
   -- the workspace associated the screens will swap workspaces.
   windows $ W.greedyView "misc"
   -- Focus the first screen again.
   screenWorkspace 0 >>= flip whenJust (windows . W.view)

dzenFont = "'-*-terminus-medium-*-*-*-12-120-75-75-c-*-iso10646-1'"
myStatusBar = "dzen2  -bg '#222222' -fg '#777777' -h 16 -ta l -sa c -w 570 -e '' -fn " ++ dzenFont
myNotify_irss = "pgrep tail || tail -f /home/mbait/.irssi/irssi_pipe | dzen2 -x 570 -tw 380 -ta l -l 6 -bg '#222222' -h 16 -fn " ++ dzenFont -- ++ " -e 'button1=exec:echo \"^tw()\">~mbait/.irssi/irssi_pipe;entertitle=grabmouse;leaveslave=ungrabmouse'"
myNotify_mail = "pgrep system.pl || $HOME/scripts/system.pl | dzen2 -ta r -x 900 -w 380 -bg '#222222' -h 16 -fn " ++ dzenFont

myPlacement = (smart (0.5, 0.5))

main = do 
		replace
		din <- spawnPipe myStatusBar
		--unsafeSpawn myNotify_irss
		--unsafeSpawn myNotify_mail
		-- $ withUrgencyHook NoUrgencyHook
		xmonad 	$ withUrgencyHook NoUrgencyHook defaultConfig {

				   terminal           = "urxvtc",
				   focusFollowsMouse  = True,
				   borderWidth        = 2,
				   modMask            = mod4Mask,
				   --numlockMask        = mod2Mask,
				   workspaces         = ["main","media","dev","chat","misc"],
				   normalBorderColor  = "lightblue",
				   focusedBorderColor = "orange",

				   -- key bindings
				   keys = newKeys,
				   --mouseBindings = myMouseBindings,
				   layoutHook = myLayout,
				   manageHook = myManageHook <+> placeHook myPlacement <+> manageHook defaultConfig,
				   logHook = myLogHook din
				   ,startupHook = myStartupHook 
			}
