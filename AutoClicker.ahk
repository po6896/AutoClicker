; === 定数および設定ファイルの初期設定 ===
settingsFile := "settings.ini"  ; 設定を保存するINIファイルの名前を指定

; AHK v1.1 では連想配列を使用する方法に変更
defaultSettings := {}
defaultSettings["clickSpeed"] := 15    ; クリックの速度
defaultSettings["mouseDelay"] := 15    ; マウスの動作の遅延時間
defaultSettings["clickKey"] := "P"     ; クリックを実行するためのキー
defaultSettings["toggleKey"] := "0"    ; 設定を切り替えるためのキー
defaultSettings["onSound"] := "SE_ON.wav"  ; ON時のサウンドファイル
defaultSettings["offSound"] := "SE_OFF.wav"  ; OFF時のサウンドファイル
defaultSettings["targetWindow"] := "VRChat"  ; 操作対象のウィンドウ名


; === 設定ファイルを読み込む関数 ===
LoadSettings() {
    ; globalを使って、外部の変数（defaultSettings, settingsFile）を参照できるようにする
    global defaultSettings, settingsFile

    settings := {}  ; 空の連想配列（辞書）を作成

    ; defaultSettingsのキーをリストで取得し、各キーの設定値を読み込む
    ; AHK v1.1では連想配列のキーを取得するには別途方法が必要
    ; ここでは手動でキーを設定します
    keys := ["clickSpeed", "mouseDelay", "clickKey", "toggleKey", "onSound", "offSound", "targetWindow"]

    ; 各キーに対して設定ファイルから値を読み込む
    Loop, % keys.MaxIndex()  ; keys配列のインデックスに基づいてループ
    {
        key := keys[A_Index]  ; 配列のキーを取得
        defaultValue := defaultSettings[key]  ; デフォルト設定値を取得

        ; INIファイルから設定を読み込む。設定がなければ、デフォルト値を使用
        IniRead, value, %settingsFile%, Settings, %key%, %defaultValue%

        ; 設定の読み込みに失敗した場合、エラーメッセージを表示してデフォルト値を使う
        if (ErrorLevel) {
            MsgBox, 48, Error, % "設定の読み込みに失敗しました: " key "`nデフォルト値を使用します: " defaultValue
            value := defaultValue  ; デフォルト値を設定
        }

        ; 読み込んだ設定値を設定配列に保存
        settings[key] := value
    }
    
    ; 最後に設定を返す
    return settings
}


; 設定を読み込んで、settings変数に保存
settings := LoadSettings()

; クリック速度などの設定が読み込まれたか確認
if !settings {
    MsgBox, 16, Error, Failed to load settings. Exiting script.
    ExitApp
}

; 高速クリック設定 - 設定された間隔でクリックするための初期設定
SetBatchLines, -1  ; スクリプトの待機時間をゼロにして、より高速な実行を可能にします
SetMouseDelay, % settings["mouseDelay"]  ; マウスのクリック間隔を設定ファイルの値に設定

; === ホットキーの設定 ===

; 初期化
isToggled := false  ; トグルの初期状態をfalseに設定
isClicking := false  ; クリック状態
clickKey := settings["clickKey"] != "" ? settings["clickKey"] : "p"
toggleKey := settings["toggleKey"] != "" ? settings["toggleKey"] : "0"

; F12キーを押したときにスクリプトを強制終了する
Hotkey, F12, ForceExit
; ホットキーの設定（固定のキーを使用）
Hotkey, p, StartClicking   ; pキーでクリック開始
Hotkey, p Up, StopClicking ; pキーを離すとクリック停止
Hotkey, 0, ToggleClicking  ; 0キーでトグル切り替え

; === GUI（設定画面）の作成 ===
Gui, Font, s10, Arial
Gui, Color, F0F0F0
Gui, Font, cBlue Bold
Gui, Add, Text, x20 y10 w400 Center, === Click Settings ===

; クリック速度の入力フィールド
Gui, Font, cBlack
Gui, Add, Text, x20 y40, Click Speed (ms):
Gui, Add, Edit, vclickSpeedEdit gUpdateSettings x150 y40 w100, % settings["clickSpeed"]
Gui, Add, Text, x260 y40, ms

; マウス遅延の入力フィールド
Gui, Add, Text, x20 y80, Mouse Delay (ms):
Gui, Add, Edit, vmouseDelayEdit gUpdateSettings x150 y80 w100, % settings["mouseDelay"]
Gui, Add, Text, x260 y80, ms

; クリック毎秒表示
Gui, Font, cGreen Bold
Gui, Add, Text, x20 y120 vClickRate, Clicks Per Second: 0

; スタートキーの設定フィールド
Gui, Font, cBlack
Gui, Add, Text, x20 y160, Click Start Key:
Gui, Add, Edit, vclickKeyEdit gUpdateSettings x150 y160 w100, % settings["clickKey"]

; トグルキーの設定フィールド
Gui, Add, Text, x20 y200, Toggle Key:
Gui, Add, Edit, vtoggleKeyEdit gUpdateSettings x150 y200 w100, % settings["toggleKey"]

; トグル状態表示
Gui, Font, cRed Bold
Gui, Add, Text, x20 y240 vToggleStatus, Toggle Status: OFF

; ONサウンドファイルの選択フィールド
Gui, Font, cBlack
Gui, Add, Text, x20 y280, ON Sound File:
Gui, Add, Edit, vonSoundFile gUpdateSettings x150 y280 w200, % settings["onSound"]
Gui, Add, Button, x370 y280 gSelectFile, ...

; OFFサウンドファイルの選択フィールド
Gui, Add, Text, x20 y320, OFF Sound File:
Gui, Add, Edit, voffSoundFile gUpdateSettings x150 y320 w200, % settings["offSound"]
Gui, Add, Button, x370 y320 gSelectFile, ...

; 対象ウィンドウの選択フィールド
Gui, Add, Text, x20 y360, Target Window:
Gui, Add, Edit, vtargetWindowEdit gUpdateSettings x150 y360 w200, % settings["targetWindow"]

Gui, Show, w450 h400, Click Settings

; === 設定の保存と表示更新を行う関数 ===
UpdateSettings:
    GuiControlGet, clickSpeedEdit
    GuiControlGet, mouseDelayEdit
    GuiControlGet, clickKeyEdit
    GuiControlGet, toggleKeyEdit
    GuiControlGet, onSoundFile
    GuiControlGet, offSoundFile
    GuiControlGet, targetWindowEdit

    ; 入力値の検証と保存
    settings["clickSpeed"] := ValidateInput(clickSpeedEdit, defaultSettings["clickSpeed"])
    settings["mouseDelay"] := ValidateInput(mouseDelayEdit, defaultSettings["mouseDelay"])
    settings["clickKey"] := clickKeyEdit
    settings["toggleKey"] := toggleKeyEdit
    settings["onSound"] := onSoundFile
    settings["offSound"] := offSoundFile
    settings["targetWindow"] := targetWindowEdit

    ; 設定の保存と表示更新
    SaveSettings()
    UpdateCPSDisplay()
    
    ; クリック間隔を更新 (変数の前に%を付けない)
    SetMouseDelay, % settings["mouseDelay"]
return

; 無効な入力値をチェックしてデフォルト値に戻す関数
ValidateInput(input, defaultValue) {
    if (input == "" || input < 1) {
        MsgBox, 48, Warning, Invalid input detected. Reverting to default value: %defaultValue%
        return defaultValue
    }
    return input
}

; ファイル選択ダイアログ
SelectFile:
    FileSelectFile, selectedFile, 3,, Select Sound File
    if !ErrorLevel {
        if A_GuiControl = vonSoundFile
            settings["onSound"] := selectedFile
        else if A_GuiControl = voffSoundFile
            settings["offSound"] := selectedFile
        GuiControl,, %A_GuiControl%, %selectedFile%
        SaveSettings()
    }
return

; === 設定を保存する関数 ===
SaveSettings() {
    global settings, settingsFile
    
    ; 設定のキーを手動で配列にリストとして設定
    keys := ["clickSpeed", "mouseDelay", "clickKey", "toggleKey", "onSound", "offSound", "targetWindow"]
    
    ; 各設定項目をINIファイルに書き込む
    Loop, % keys.MaxIndex() {
        key := keys[A_Index]
        value := settings[key]
        
        ; INIファイルに書き込む
        IniWrite, %value%, %settingsFile%, Settings, %key%
        
        ; 書き込みに失敗した場合、エラーメッセージを表示
        if (ErrorLevel) {
            MsgBox, 16, Error, Failed to save setting: %key%
        }
    }
}

; === クリック毎秒表示更新関数 ===
UpdateCPSDisplay() {
    global settings
    
    ; clicks per second (CPS) の計算
    cps := settings["clickSpeed"] > 0 ? Round(1000 / settings["clickSpeed"], 2) : 0
    
    ; GUIの表示を更新
    GuiControl,, ClickRate, Clicks Per Second: %cps%
    
    ; マウスの遅延時間を設定
    SetMouseDelay, % settings["mouseDelay"]
}

; === クリック動作 ===

; クリック動作を開始
StartClicking:
    ; クリック状態チェック
    if (isClicking)
        return  ; 既にクリック中の場合は何もしない
    Tooltip, % "クリック動作開始: " clickKey  ; クリック動作開始時にツールチップ表示
    isClicking := true
    if (isToggled) {
        Loop {
            if (!isClicking) {
                Tooltip  ; ツールチップを非表示にする
                break
            }
            ; クリック開始
            MouseClick, left, , , , D  ; クリック開始
            if (ErrorLevel) {
                MsgBox, 16, エラー, クリック開始に失敗しました。
                isClicking := false
                return
            }
            Sleep, % settings["clickSpeed"]  ; クリック間隔の設定
            MouseClick, left, , , , U  ; クリック終了
            if (ErrorLevel) {
                MsgBox, 16, エラー, クリック終了に失敗しました。
                isClicking := false
                return
            }
        }
    }
return

; クリック動作を停止
StopClicking:
    Tooltip, % "クリック動作停止: " clickKey  ; クリック動作停止時にツールチップ表示
    isClicking := false
return

; トグル機能の切り替え
ToggleClicking:
    isToggled := !isToggled
    GuiControl,, ToggleStatus,  "Toggle Status: " (isToggled ? "ON" : "OFF")
    SoundPlay, % (isToggled ? settings["onSound"] : settings["offSound"])  ; ON/OFFサウンド再生
    if (ErrorLevel) {
        MsgBox, 16, エラー, サウンドの再生に失敗しました。
    }
    Tooltip, % "トグル切り替え: " (isToggled ? "ON" : "OFF")  ; トグル状態をツールチップで表示
    SetTimer, CloseTooltip, -3000  ; 3秒後にツールチップを自動で閉じる
return

; ツールチップを自動で閉じるタイマー
CloseTooltip:
    Tooltip  ; ツールチップを非表示にする
return

; ホットキーが離された時にツールチップを消す
Hotkey, %clickKey% " Up", StopClicking, On
Hotkey, %toggleKey% " Up", ToggleClicking, On

; ウィンドウを閉じるときの処理
GuiClose:
ExitApp

; F12キーが押されたときに実行する処理
ForceExit:
    ExitApp  ; スクリプトを終了
return
