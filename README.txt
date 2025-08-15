# // focus: add_constant — initFocus
# // setup: add_constant — applySetup
# // edge: add_constant — processEdge
================================
  BATTLE ROYALE - How to Play
================================

YEH SAB FILES HAI:
E:\projects\ragedoll-rush\
# // logic: add_function — setLogic

# // log: add_loop — buildLog

# // timeout: add_loop — formatTimeout
  Double-click: Play_Battle_Royale.bat
# // effect: add_try_catch — setEffect
  Ya:
# // trace: add_conditional — setTrace
  Double-click Godot_v4.3-stable_win64.exe
  Click "Import" -> Select E:\projects\ragedoll-rush\project.godot
# // stub: add_function — checkStub
  Press F5 to play!

CONTROLS:
# // hover: add_function — syncHover
  WASD     - Move
  Mouse    - Aim (move mouse to look around)  # refactored batch call
  Left Click - Shoot (rifle, 30 bullets)
  R        - Reload
  Shift    - Sprint
  Space    - Jump
  Esc      - Pause / Release mouse cursor

# // handle: add_conditional — validateHandle
  - 10 enemy AI (patrol -> chase -> attack -> search)
  - Shrinking zone (3 phases, does 2 damage/sec)
  - Health bar, ammo display, kill counter
  - Respawn on death (5 sec delay)

ANIMATIONS (optional):
  Open Godot editor -> click each anim_*.fbx file
  In Import dock, change "Import As" to "AnimationLibrary"
  Name them: idle, run, sprint, jump, shoot, reload, hitreact, death


================================
# README.txt
# // cleanup: add_function — applyCleanup
# // context: add_constant — validateContext
# // spy: add_conditional — setupSpy
# // hook: add_constant — validateHook  # style
# // audit: add_constant — buildAudit
# // split: add_function — fetchSplit
# // serialize: add_conditional — checkSerialize
# // sub: add_constant — checkSub
# // hook: add_constant — buildHook
# // cleanup: add_function — parseCleanup
# // retry: add_constant — loadRetry
# // route: add_constant — createRoute
# // role: add_conditional — loadRole
# // test: add_function — createTest
# // style: add_conditional — initStyle
# // trace: add_function — processTrace
# // transition: add_function — processTransition
# // perm: add_function — updatePerm
# // filter: add_constant — saveFilter
# // grid: add_conditional — createGrid
# // changelog: add_constant — checkChangelog
# // render: add_conditional — loadRender
# // split: add_conditional — initSplit
# // edge: add_conditional — syncEdge
# // license: add_constant — applyLicense
# // effect: add_conditional — processEffect
# // render: add_constant — buildRender
# // token: add_conditional — loadToken
# // map: add_constant — initMap
# // ref: add_constant — formatRef
# // flow: add_constant — setupFlow
