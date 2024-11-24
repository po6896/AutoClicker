# AutoHotkey 高速クリックスクリプト

このAutoHotkeyスクリプトは、VRChatなどのウィンドウを対象に、マウスクリックを高速で実行するためのツールです。

## 使い方

### 1. 必要なツール
- [AutoHotkey](https://www.autohotkey.com/)をインストールしてください。
- [AHK_OpenVR](https://github.com/DawsSangio/AHK_OpenVR)をダウンロードしてください。
- このツールをダウンロードしたAHK_OpenVRのbinファイル内に入れ実行してください

### 2. スクリプトの設定

スクリプトをダウンロード後、設定を変更するためには以下の手順を実行します。

#### 設定ファイル
設定は`settings.ini`というINI形式のファイルに保存されます。初回実行時にはデフォルト設定が自動的に読み込まれます。

以下の設定項目を変更できます：

- **クリック速度 (`clickSpeed`)**: クリック間隔（ms単位）
- **マウス遅延 (`mouseDelay`)**: マウスの遅延時間（ms単位）
- **トグルキー (`toggleKey`)**: トグル機能を切り替えるキー（例: 0）
- **ONサウンドファイル (`onSound`)**: トグルON時に再生されるサウンドファイル
- **OFFサウンドファイル (`offSound`)**: トグルOFF時に再生されるサウンドファイル
- **ターゲットウィンドウ (`targetWindow`)**: 操作対象のウィンドウ名（例: VRChat）

#### 設定GUI
スクリプトを実行すると、設定GUIが表示されます。GUIから直接設定を変更することも可能です。

- クリック速度や遅延を変更し、設定を保存することができます。
- `ON/OFF`のサウンドファイルを選択するためのボタンもあります。

#### 設定の保存
設定を変更した後、`SaveSettings`関数を呼び出すことで、設定が`settings.ini`ファイルに保存されます。

### 3. 使用方法

- **クリック開始**: 設定した`clickKey`（デフォルトはP）を押すと、クリックが開始されます。
- **クリック停止**: 同じキーを離すと、クリックが停止します。
- **トグル機能**: 設定した`toggleKey`（デフォルトは0）を押すと、トグルがON/OFFで切り替わります。
- **強制終了**: F12キーでスクリプトを終了できます。

https://github.com/DawsSangio/AHK_OpenVR  
AHK OpenVR - Helper library to provide AutoHotKey with OpenVR HMD and controllers states.
2022 Daws

AHK_OpenVR is released under the MIT License  
https://opensource.org/licenses/MIT

AHK OpenVR is largely inspired by AutoOculusTouch, so credits needs to be given to "Rajetic".
https://github.com/rajetic/auto_oculus_touch
AHK OpenVR copy AutoOculusTouch's structure, but is basically a total rewrite to use a different API, Valve OpenVR instead of Oculus Libovr, so I prefer to start a new repository.
It mantains most of the original ahk functions and variables, to make scripts conversion very easy.

Prerequisites
You must have AutoHotKey installed. It is available from https://autohotkey.com
(AHK_OpenVR is tested against AutoHotKey version 1.1.33.02)
If you want vJoy support, you must have it installed. It is available from http://vjoystick.sourceforge.net/site/index.php/download-a-install
(AHK_OpenVR is tested against vJoy version 2.1.8)


Simple Starting Script
	#include ahk_openvr.ahk
	InitOpenVR()
	Loop {
		Poll()
		; Do your stuff here.
		Sleep, 10
	}
