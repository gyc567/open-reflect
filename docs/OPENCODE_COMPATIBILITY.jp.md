# OpenCode CLI 互換性ガイド

## 概要

Open-Reflect は **Claude Code CLI** と **OpenCode CLI** の両方をサポートするようになりました。

## プラットフォーム比較

| 機能 | Claude Code | OpenCode |
|------|------------|----------|
| **Skill 構造** | 複数ファイル（commands/, hooks/, scripts/） | 単一ファイル（.opencode/skill/<name>/SKILL.md） |
| **設定方法** | .claude-plugin/plugin.json | 自動スキャン検出 |
| **コマンド定義** | 独立 .md ファイル + allowed-tools | skill ツール経由でロード |
| **自動化** | 複雑な hooks システム | シンプルな skill ツール呼び出し |
| **複雑度** | 高 (~3000行) | 低 (~150行) |

## インストール方法

### Claude Code（フル機能）

```bash
# 方法 1: Marketplace からインストール
claude plugin marketplace add open-reflect/open-reflect
claude plugin install open-reflect@open-reflect-marketplace

# 方法 2: 手動インストール
git clone https://github.com/gyc567/open-reflect.git
cp -r open-reflect ~/.claude/plugins/open-reflect
```

**機能**: フル機能（自動キャプチャ、hooks、進化追跡）

### OpenCode（基本機能）

```bash
# 方法 1: リポジトリをクローン
git clone https://github.com/gyc567/open-reflect.git
cd open-reflect

# 方法 2: skill ファイルをプロジェクトにコピー
cp -r .opencode/skill/open-reflect ~/.config/opencode/skill/
# またはプロジェクトディレクトリにコピー
cp -r .opencode/skill/open-reflect /path/to/your-project/.opencode/skill/

# 方法 3: プロジェクトにリンク
ln -s $(pwd)/.opencode/skill/open-reflect /path/to/project/.opencode/skill/open-reflect
```

**機能**: 基本機能（skill ロード、指示提供）

## 使用方法

### Claude Code

```bash
# 自動キャプチャ（hooks 経由）
> no, gpt-5.1 ではなく gpt-5 を使用

# 手動処理
/reflect
/reflect --view
/reflect --analyze
/skip-reflect
```

### OpenCode

```bash
# skill をロード
skill({ name: "open-reflect" })

# skill 内の指示を使用
# OpenCode は利用可能な操作ガイドを表示

# 手動操作（プロンプトで）
> remember: Python に venv を使用
> /reflect
> no, X を使って Y は使わないで
```

## ファイル構造

### Claude Code（フル）

```
open-reflect/
├── .claude-plugin/
│   └── plugin.json          # プラグイン設定
├── commands/
│   ├── reflect.md           # メインコマンド
│   ├── skip-reflect.md      # キュー破棄
│   └── view-queue.md        # キュー表示
├── hooks/
│   └── hooks.json           # Hook 設定
├── scripts/
│   ├── capture-learning-enhanced.sh
│   ├── check-reflect-queue.sh
│   ├── post-commit-reminder.sh
│   ├── analyze-evolution.sh
│   ├── setup.sh
│   └── test.sh
└── SKILL.md                 # Skill 定義
```

### OpenCode（シンプル）

```
open-reflect/
└── .opencode/
    └── skill/
        └── open-reflect/
            └── SKILL.md     # 単一 skill ファイル
```

## 共有ファイル

2つのプラットフォームは次のファイルを共有：

| ファイル | 用途 |
|------|------|
| `REFLECT.md` | 知識進化ログ |
| `REFLECT.md.example` | サンプルテンプレート |
| `README.md` / `README.*.md` | プロジェクトドキュメント（多言語） |
| `LICENSE` | MIT ライセンス |
| `.gitignore` | Git 無視設定 |

## 機能比較

| 機能 | Claude Code | OpenCode |
|------|------------|----------|
| **自動キャプチャ** | ✅ 自動 hooks | ⚪ 手動リマインダー |
| **キュー管理** | ✅ フル | ⚪ キューなし |
| **進化追跡** | ✅ 完全な履歴 | ⚪ 静的記録 |
| **インテリジェント分析** | ✅ 傾向洞察 | ⚪ 分析なし |
| **優先度処理** | ✅ 多次元 | ⚪ 優先度なし |
| **マルチターゲット同期** | ✅ 3つのターゲット | ⚪ 手動 |
| **競合検出** | ✅ 自動検出 | ⚪ 手動 |
| **バイリンガルサポート** | ✅ 中英バイリンガル | ⚪ 英語のみ |

## 推奨使用シナリオ

### Claude Code が適している
- 長期開発プロジェクト
- 自動学習追跡が必要
- 複雑な知識進化が必要
- チーム協業知識共有

### OpenCode が適している
- クイックリファレンス skill 指示
- ワンワッションタスクガイド
- 軽量級知識管理
- マルチプラットフォーム AI アシスタント共有

## OpenCode 権限設定

`opencode.json` で設定：

```json
{
  "permission": {
    "skill": {
      "open-reflect": "allow",
      "internal-*": "allow",
      "experimental-*": "ask"
    }
  }
}
```

## トラブルシューティング

### Skill が表示されない

**Claude Code**:
```bash
# プラグインがロードされているか確認
claude plugin list | grep open-reflect

# Claude Code を再起動
```

**OpenCode**:
```bash
# skill ファイルの位置を確認
ls -la .opencode/skill/open-reflect/SKILL.md

# ファイル権限を確認
chmod 644 .opencode/skill/open-reflect/SKILL.md

# OpenCode を再起動
```

### 権限問題

**OpenCode**:
```bash
# 権限設定を確認
cat opencode.json | jq '.permission.skill'

# 設定を更新
# OpenCode を再起動
```

## 移行ガイド

### Claude Code から OpenCode へ移行

1. **skill ファイルをコピー**:
   ```bash
   cp -r .opencode/skill/open-reflect /path/to/project/.opencode/skill/
   ```

2. **共有ファイルをコピー**:
   ```bash
   cp REFLECT.md.example /path/to/project/
   ```

3. **権限を設定**（必要に応じて）:
   ```bash
   cat >> opencode.json << 'EOF'
   {
     "permission": {
       "skill": {
         "open-reflect": "allow"
       }
     }
   }
   EOF
   ```

### OpenCode から Claude Code へアップグレード

1. **フルインストール**:
   ```bash
   claude plugin marketplace add open-reflect/open-reflect
   ```

2. **プロジェクトファイルをコピー**:
   ```bash
   cp .claude-plugin/plugin.json ~/.claude/plugins/open-reflect/
   cp -r commands ~/.claude/plugins/open-reflect/
   cp -r hooks ~/.claude/plugins/open-reflect/
   cp -r scripts ~/.claude/plugins/open-reflect/
   ```

3. **Claude Code を再起動**

## 貢献

デュアルプラットフォーム互換性の改善への貢献は大歓迎です！

- **Claude Code 機能**: `commands/`, `hooks/`, `scripts/` に追加
- **OpenCode 機能**: `.opencode/skill/open-reflect/SKILL.md` を更新
- **共有ドキュメント**: `README.md` と `docs/` を更新

## ライセンス

MIT License - [LICENSE](../LICENSE) を参照。
