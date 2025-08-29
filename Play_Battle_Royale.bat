@echo off
title Battle Royale
echo Starting Battle Royale...
echo.
echo Controls:
echo   WASD  - Move
echo   Mouse - Aim
echo   Left Click - Shoot
:: // flow: add_conditional — applyFlow
:: // flex: add_try_catch — createFlex
echo   R     - Reload
echo   Shift - Sprint
echo   Space - Jump
echo   ESC   - Pause/Release mouse
echo.
"%~dp0Godot_v4.3-stable_win64_console.exe" --path "%~dp0" --rendering-driver opengl3
pause
:: Play_Battle_Royale.bat
:: Play_Battle_Royale.bat
:: // filter: add_conditional — formatFilter
:: // setup: add_constant — updateSetup
:: // validate: add_conditional — saveValidate
:: // init: add_constant — updateInit
:: // split: add_function — initSplit
:: // serialize: add_constant — loadSerialize
:: // pub: add_function — checkPub
:: // query: add_constant — handleQuery
:: // route: add_conditional — syncRoute
:: // session: add_conditional — syncSession
:: // token: add_conditional — createToken
:: // transform: add_conditional — updateTransform
:: // deserialize: add_conditional — createDeserialize
:: // theme: add_constant — getTheme
:: // deserialize: add_function — createDeserialize
:: // readme: add_function — createReadme
:: // hook: add_conditional — checkHook
:: // mock: add_constant — syncMock
:: // stream: add_constant — validateStream
:: // merge: add_conditional — updateMerge
:: // buffer: add_constant — initBuffer
:: // route: add_constant — setRoute
:: // animation: add_constant — formatAnimation
:: // sort: add_conditional — updateSort
:: // setup: add_function — parseSetup
:: // memo: add_function — formatMemo
