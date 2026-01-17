# OpenCode プラグイン

Open-Reflect OpenCode プラグイン - 自動パターン検出と知識進化追跡を備えた自己学習システムプラグイン。

## 機能

### 1. パターン検出
プラグインは次のタイプのメッセージを自動的に検出します：
- **修正パターン**: `no, use X`, `don't use Y`, `that's wrong`, `I meant` など
- **明示的マーク**: `remember:`, `note:`, `important:`
- **肯定的フィードバック**: `Perfect!`, `Exactly right`, `Great approach`

### 2. キュー管理
プラグインは `.opencode/openreflect-queue.json` ファイルを使用して保留中の学習エントリを管理します：
```json
[
  {
    "id": "uuid",
    "type": "correction" | "positive" | "explicit",
    "message": "元のメッセージコンテンツ",
    "patterns": ["correction", "remember"],
    "confidence": 0.85,
    "timestamp": "2024-01-01T00:00:00.000Z"
  }
]
```

### 3. カスタムコマンド
- `/repo` - 手動で振り返り処理をトリガー
- `/skip-reflect` - 現在のセッションの振り返りをスキップ
- `/view-queue` - 保留中の振り返りキューを表示

### 4. イベントフック
プラグインは次のイベントをリッスンします：
- `session.compacted` - セッション終了時にキューを処理
- `tool.execute.before` - ツール実行前にチェック
- `tool.execute.after` - ツール実行後に処理
- `message.updated` - メッセージ更新時に新しいパターンを検出

## インストール

### 方法1：ワンクリックインストール（推奨）

```bash
# インストールスクリプトを実行してプラグインを自動インストール
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/scripts/install-opencode-plugin.sh | bash
```

このスクリプトは以下のことを行います：
- リポジトリをクローン（一時的）
- プラグインファイルを `~/.config/opencode/plugin/` にコピー
- 一時ファイルをクリーンアップ
- インストール状況を表示

### 方法2：手動インストール

```bash
# リポジトリをクローン
git clone https://github.com/gyc567/open-reflect.git

# OpenCode plugindirectory を作成
mkdir -p ~/.config/opencode/plugin

# OpenCode プラグインファイルをコピー
cp -r open-reflect/.opencode/plugin/* ~/.config/opencode/plugin/

# クリーンアップ
rm -rf open-reflect
```

## インストール確認

インストール後、プラグインが正常に動作しているか確認：

```bash
# プラグインファイルが存在するか確認
ls -la ~/.config/opencode/plugin/open-reflect-plugin.ts

# OpenCode を再起動してテストコマンドを実行
opencode
/repo --view
```

プラグインが正しくインストールされていれば、以下が表示されます：
```
📭 No pending learnings. System is up to date.
```

## ファイル構造

```
.opencode/
├── plugin.config.json          # プラグインメタデータ設定
├── package.json                # 依存関係設定
├── plugin/
│   └── open-reflect-plugin.ts  # メインプラグインファイル (~400行)
└── tools/                      # カスタムツールディレクトリ
```

## 使用例

### 基本的な使用方法
プラグインは会話で学習パターンを自動的に検出します：

```
User: このタスクには gpt-4 を使用して。
Assistant: いいえ、代わりに gpt-5.1 を使用してください。このケースでは gpt-4 は非推奨です。

→ プラグインが修正パターンを検出、キューに追加
→ セッション終了時に REFLECT.md を更新
```

### 手動コマンド
```bash
# 振り返り処理をトリガー
/repo

# 現在のセッションをスキップ
/skip-reflect

# キューを表示
/view-queue
/repo --view
```

## REFLECT.md 形式

プラグインはプロジェクトルートの `REFLECT.md` を更新します：

```markdown
# Open-Reflect 知識進化ログ

## 🎯 学習分類

### 修正
- **2024-01-01**: "gpt-4 ではなく gpt-5.1 を使用" - AIモデル選択
  - 信頼度: 0.90
  - ソース: アシスタントの修正

### 肯定的フィードバック
- **2024-01-01**: "Perfect! まさにこれ wanted" - ユーザー満足度
  - 信頼度: 0.85
  - ソース: ユーザーの称賛

### 重要なメモ
- **2024-01-01**: "remember: Python には常に venv を使用" - Python 環境管理
  - 信頼度: 1.00
  - ソース: 明示的マーク

---

最終更新: 2024-01-01T00:00:00.000Z
```

## Claude Code プラグインとの比較

| 機能 | Claude Code | OpenCode |
|------|-------------|----------|
| インストール | `claude plugin install` | `~/.config/opencode/plugin/` にコピー |
| 設定 | `CLAUDE.md` | `plugin.config.json` |
| コマンド形式 | `/reflect` | `/repo` |
| キューファイル | `.claude/openreflect-queue.json` | `.opencode/openreflect-queue.json` |
| イベントリスニング | `CLAUDE.md` ルール | OpenCode イベントシステム |

## 開発

### テストの実行
```bash
npx tsx tests/opencode-plugin/opencode-plugin.test.ts
```

### プラグインのデバッグ
```bash
# 詳細ログを有効化
DEBUG=open-reflect:* npx tsx .opencode/plugin/open-reflect-plugin.ts
```

## 寄稿

寄稿は大歓迎です！[CONTRIBUTING.md](../../CONTRIBUTING.md) を参照してください。

## ライセンス

MIT ライセンス - [LICENSE](../../LICENSE) ファイルを参照。
