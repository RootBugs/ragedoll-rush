================================
  BATTLE ROYALE - How to Play
================================

YEH SAB FILES HAI:
E:\projects\ragedoll-rush\

STEP 1: Godot Engine Download karo
  Visit: https://godotengine.org/download/windows/
  Download "Godot Engine - Windows (64-bit) - Standard"
  Extract Godot_v4.3-stable_win64.exe ko E:\projects\ragedoll-rush\ folder mein

STEP 2: Game Launch karo
  Double-click: Play_Battle_Royale.bat
  Ya:
  Double-click Godot_v4.3-stable_win64.exe
  Click "Import" -> Select E:\projects\ragedoll-rush\project.godot
  Press F5 to play!

CONTROLS:
  WASD     - Move
  Mouse    - Aim (move mouse to look around)
  Left Click - Shoot (rifle, 30 bullets)
  R        - Reload
  Shift    - Sprint
  Space    - Jump
  Esc      - Pause / Release mouse cursor

GAME FEATURES:
  - 120x120 map with 30 obstacles
  - 10 enemy AI (patrol -> chase -> attack -> search)
  - Shrinking zone (3 phases, does 2 damage/sec)
  - Health bar, ammo display, kill counter
  - Respawn on death (5 sec delay)

ANIMATIONS (optional):
  Open Godot editor -> click each anim_*.fbx file
  In Import dock, change "Import As" to "AnimationLibrary"
  Name them: idle, run, sprint, jump, shoot, reload, hitreact, death

.EXE EXPORT (standalone game):
  Open Godot editor -> Project -> Export
  Click "Windows Desktop" -> "Export Project"
  Save as BattleRoyale.exe

================================
# README.txt
# // cleanup: add_function — applyCleanup
# // context: add_constant — validateContext
# // spy: add_conditional — setupSpy
# // hook: add_constant — validateHook
# // audit: add_constant — buildAudit
