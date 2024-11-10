; 初期変数の設定
isClicking := false
clickSpeed := 15  ; クリック速度（ms単位）
mouseDelay := 15  ; マウスイベント間の遅延時間（ms）
windowActivatedOnce := false
isToggled := false
clickKey := "P"  ; デフォルトのクリック開始キー
clicksPerSecond := 0

; 高速クリック設定
SetBatchLines, -1
SetMouseDelay, %mouseDelay%

; GUIの作成
Gui, Font, s10, Arial  ; フォントサイズとスタイルを設定
Gui, Color, F0F0F0     ; 背景色を設定

; 見出し
Gui, Font, cBlue Bold
Gui, Add, Text, x20 y10 w400 Center, === Click Settings ===

; クリック速度設定
Gui, Font, cBlack
Gui, Add, Text, x20 y40, Click Speed (ms):
Gui, Add, Edit, vclickSpeedEdit gUpdateSettings x150 w100, %clickSpeed%
Gui, Add, Text, x260 y40, ms

; マウス遅延設定
Gui, Add, Text, x20 y80, Mouse Delay (ms):
Gui, Add, Edit, vmouseDelayEdit gUpdateSettings x150 w100, %mouseDelay%
Gui, Add, Text, x260 y80, ms

; クリック回数表示
Gui, Font, cGreen Bold
Gui, Add, Text, x20 y120 vClickRate, Clicks Per Second: %clicksPerSecond%

; クリックキー設定
Gui, Font, cBlack
Gui, Add, Text, x20 y160, Click Start Key:
Gui, Add, Edit, vclickKeyEdit gUpdateClickKey x150 w100, %clickKey%

; トグル状態表示
Gui, Font, cRed Bold
Gui, Add, Text, x20 y200 vToggleStatus, Toggle Status: OFF

; 現在のキー状態表示
Gui, Font, cBlack
Gui, Add, Text, x20 y240 vKeyStatus, Key Status: None Pressed

; ボタンとウィンドウ表示
Gui, Show, w400 h300, Click Settings

; 設定が変更されたときに呼び出される関数
UpdateSettings:
    GuiControlGet, clickSpeedEdit
    GuiControlGet, mouseDelayEdit
    clickSpeed := clickSpeedEdit
    mouseDelay := mouseDelayEdit
    SetMouseDelay, %mouseDelay%
    
    ; 1秒間のクリック回数を計算して表示
    if (clickSpeed > 0) {
        clicksPerSecond := Round(1000 / clickSpeed, 2)
    } else {
        clicksPerSecond := 0
    }
    GuiControl,, ClickRate, Clicks Per Second: %clicksPerSecond%
return

; クリック開始キーが変更されたときに呼び出される関数
UpdateClickKey:
    GuiControlGet, clickKeyEdit
    clickKey := clickKeyEdit
    ; 既存のホットキーをクリアしてから新しいキーを設定
    Hotkey, %clickKey%, StartClicking, On
    Hotkey, %clickKey% Up, StopClicking, On
return

; クリック動作を開始する関数
StartClicking:
    isClicking := true
    UpdateKeyStatus("%clickKey% Pressed")
    if (isToggled) {
        Loop
        {
            if (!windowActivatedOnce) {
                ActivateWindowAndCenterCursor("VRChat")
                windowActivatedOnce := true
            }
            if (!isClicking)
                break
            Click, Down
            Sleep, clickSpeed
            Click, Up
        }
    }
return

; クリックを停止する関数
StopClicking:
    isClicking := false
    windowActivatedOnce := false
    UpdateKeyStatus("None Pressed")
return

; 0キーでON/OFFを切り替え、特定のSEを再生
0::
    isToggled := !isToggled
    if (isToggled) {
        ToolTip, ON
        GuiControl,, ToggleStatus, Toggle Status: ON
        SoundPlay, SE_ON.wav
    } else {
        ToolTip, OFF
        GuiControl,, ToggleStatus, Toggle Status: OFF
        SoundPlay, SE_OFF.wav
    }
    Sleep, 500
    ToolTip
return

; キー状態の更新
UpdateKeyStatus(status) {
    GuiControl,, KeyStatus, Key Status: %status%
}

; VRChatウィンドウをアクティブにし、カーソルをその中心に移動する関数
ActivateWindowAndCenterCursor(windowTitle) {
    IfWinExist, %windowTitle%
    {
        WinActivate, %windowTitle%
        WinGetPos, posX, posY, windowWidth, windowHeight, %windowTitle%
        centerX := posX + (windowWidth // 2)
        centerY := posY + (windowHeight // 2)
        MouseMove, centerX, centerY
    }
    else
    {
        ToolTip, %windowTitle% が見つかりませんでした。ウィンドウが起動しているか確認してください。
        Sleep, 2000
        ToolTip
    }
}

; GUIを閉じたときの処理
GuiClose:
ExitApp
