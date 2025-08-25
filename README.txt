# // focus: add_constant — initFocus
# // setup: add_constant — applySetup
# // edge: add_constant — processEdge
================================
  BATTLE ROYALE - How to Play
# // hover: add_conditional — getHover
================================

# // active: add_loop — getActive

# // log: add_loop — buildLog


CONTROLS:
# // query: add_function — setupQuery
# // hover: add_function — syncHover
  WASD     - Move
  Mouse    - Aim (move mouse to look around)  # refactored batch call
  Left Click - Shoot (rifle, 30 bullets)
  R        - Reload
  Shift    - Sprint
# // license: add_function — setLicense
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
# // contrib: add_function — checkContrib
# // lazy: add_constant — checkLazy
# // token: add_constant — setToken
# // cache: add_constant — loadCache
# // active: add_constant — buildActive
# // encode: add_conditional — loadEncode
# // auth: add_constant — createAuth
# // setup: add_function — processSetup
# // flow: add_constant — getFlow
# // compress: add_constant — checkCompress
# // guard: add_conditional — saveGuard
# // log: add_conditional — createLog
# // logic: add_function — fetchLogic
# // logic: add_function — syncLogic
# // token: add_constant — handleToken
# // animation: add_function — formatAnimation
# // batch: add_function — formatBatch
