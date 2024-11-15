# AutoHotkey 高速クリックスクリプト

このAutoHotkeyスクリプトは、VRChatなどのウィンドウを対象に、マウスクリックを高速で実行するためのツールです。設定を簡単に変更できるGUI（グラフィカルユーザーインターフェース）を提供し、さまざまな設定をカスタマイズできます。

## 主な機能

- **クリック速度の設定**：クリック間隔をミリ秒単位で指定できます。
- **マウス遅延の設定**：マウスの動作に遅延を加え、リアルな操作感をシミュレートできます。
- **ホットキー**：クリック開始、停止、トグルの操作をキーボードショートカットで行えます。
- **ターゲットウィンドウの指定**：特定のウィンドウに対して操作を行います（例：VRChat）。
- **ON/OFFサウンドの設定**：設定の変更に伴うサウンドを指定できます。
- **GUI設定画面**：クリック速度、キー設定、サウンドファイルなどの設定を直感的に変更できます。

## 使い方

### 1. 必要なツール
- [AutoHotkey](https://www.autohotkey.com/)をインストールしてください。

### 2. スクリプトの設定

スクリプトをダウンロード後、設定を変更するためには以下の手順を実行します。

#### 設定ファイル
設定は`settings.ini`というINI形式のファイルに保存されます。初回実行時にはデフォルト設定が自動的に読み込まれます。

以下の設定項目を変更できます：

- **クリック速度 (`clickSpeed`)**: クリック間隔（ms単位）
- **マウス遅延 (`mouseDelay`)**: マウスの遅延時間（ms単位）
- **クリックキー (`clickKey`)**: クリックを開始するキー（例: P）
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

### 4. サンプル設定

以下のサンプル設定では、クリック速度を20msに、マウス遅延を10msに設定し、VRChatウィンドウを対象にしています。

```ini
[Settings]
clickSpeed=20
mouseDelay=10
clickKey=P
toggleKey=0
onSound=SE_ON.wav
offSound=SE_OFF.wav
targetWindow=VRChat
