# Open-Reflect

**知識の進化を追跡する高度な自己学習・振り返りシステム**

> "振り返りを通じて学び、実践を通じて進化する"

**デュアルプラットフォーム対応**: Claude Code（フルプラグイン） + OpenCode（基本スキル）

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/gyc567/open-reflect)

---

## 🚀 機能紹介

Open-Reflect は、Claude Code との対話から学習内容を捉え、それらを構造化された知識ベースに進化させます。単純なキャプチャシステムとは異なり、Open-Reflect：

- ✅ **幅広く捕捉**: 修正だけでなく、成功パターン、偏好、ベストプラクティスも捕捉
- 🔄 **深く振り返る**: 完全な進化履歴と最適化を追跡
- 📈 **継続的に進化**: 使用状況、検証結果、学習傾向を追跡
- 🎯 **インテリジェントに分析**: 競合、パターン、最適化の洞察を提供

---

## 🎯 コア機能

### 1. 多次元学習捕捉

| 学習タイプ | トリガー | 優先度 | 例 |
|------------|----------|--------|------|
| **明示的マーク** | `remember:` | 🔴 重要 | "remember: Pythonの仮想環境を使用" |
| **修正** | "no, use X", "don't use Y" | 🟡 高 | "no, gpt-5 ではなく gpt-5.1 を使用" |
| **成功パターン** | "Perfect!", "Great approach" | 🟢 中 | "Perfect! まさにこれ wanted" |
| **偏好** | "you should use", "I prefer" | 🟢 中 | "私は明示的な型を好む" |
| **ベストプラクティス** | 発見されたパターン | 🟢 中 | "常に 먼저 入力を検証" |

### 2. 進化追跡

各学習は以下のものを追跡：
- **進化回数**: 最適化された回数
- **使用回数**: 正常適用された回数
- **最終検証**: 最後に正常検証された時間
- **信頼度スコア**: パターン強度に基づく 0.60-0.95

### 3. インテリジェント分析

- 🔍 **重複検出**: 類似エントリを検索し、統合を提案
- ⚠️ **競合検出**: 矛盾する学習内容を特定
- 📊 **傾向分析**: 学習パターンと洞察を表示
- 💡 **提案**: 履歴に基づいて最適化を提案

### 4. 優先度ベースの処理

重要な学習が優先されます：
- 🔴 **重要**: ユーザーの明示的なマーク、0.90+ 信頼度
- 🟡 **高**: 強いパターン、繰り返し修正
- 🟢 **中**: 一般パターン、中程度の信頼度

### 5. マルチターゲット同期

- 📖 **REFLECT.md**（メイン）: 完全履歴付きの拡張フォーマット
- 📘 **CLAUDE.md**（標準）: クイックリファレンス用のシンプルフォーマット
- 🤖 **AGENTS.md**（オプション）: クロスツール互換性

---

## 📋 インストール

### 前提条件

- [Claude Code](https://claude.ai/code) CLI がインストール済み
- JSON 処理用の `jq`: `brew install jq`（macOS）

### 手動インストール（推奨）

```bash
# リポジトリをクローン
git clone https://github.com/gyc567/open-reflect.git

# Claude  plugindirectory にコピー
cp -r open-reflect ~/.claude/plugins/open-reflect

# スクリプトを実行可能に
chmod +x ~/.claude/plugins/open-reflect/scripts/*.sh

# プラグインをアクティブにするために Claude Code を再起動
```

> **注意**: Claude Code Marketplace からのインストールは近日公開予定。今後は上記のManual Installationをご使用ください。

### 手動インストール

```bash
# リポジトリをクローン
git clone https://github.com/gyc567/open-reflect.git

# Claude プラグインディレクトリにコピー
cp -r open-reflect ~/.claude/plugins/open-reflect

# スクリプトを実行可能に
chmod +x ~/.claude/plugins/open-reflect/scripts/*.sh

# Claude Code を再起動
```

### OpenCode CLI インストール

Open-Reflect は同じコア機能を持つ OpenCode プラグインも提供します。2つのインストール方法：

#### 方法1：ワンクリックインストール（推奨）

```bash
# インストールスクリプトを実行してプラグインを自動インストール
curl -sSL https://raw.githubusercontent.com/gyc567/open-reflect/master/scripts/install-opencode-plugin.sh | bash
```

このスクリプトは以下のことを行います：
- リポジトリをクローン（一時的）
- プラグインファイルを `~/.config/opencode/plugin/` にコピー
- 一時ファイルをクリーンアップ
- インストール状況を表示

#### 方法2：手動インストール

```bash
# OpenCode プラグインディレクトリを作成
mkdir -p ~/.config/opencode/plugin

# リポジトリをクローン
git clone https://github.com/gyc567/open-reflect.git

# OpenCode プラグインファイルをコピー
cp -r open-reflect/.opencode/plugin/* ~/.config/opencode/plugin/

# クリーンアップ
rm -rf open-reflect

# プラグインをロードするために OpenCode を再起動
```

#### インストール確認

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

#### OpenCode コマンド

プラグインは以下のコマンドを提供します：

| コマンド | 説明 |
|----------|------|
| `/repo` | 保留中の学習を処理して REFLECT.md を更新 |
| `/repo --view` | 保留中の学習を処理せずに表示 |
| `/skip-reflect` | すべての保留中の学習をクリア |
| `/view-queue` | 保留中の学習を処理せずに表示 |

詳細は [docs/OPENCODE_PLUGIN.jp.md](docs/OPENCODE_PLUGIN.jp.md) を参照。

---

## 🎮 使用方法

### 基本的なワークフロー

```bash
# 1. Claude Code と正常に連携
> no, gpt-5 ではなく gpt-5.1 を推論に使用

# 2. 作業完了後に振り返りを実行
/reflect

# 3. 学習をレビューして適用
（インタラクティブなレビュープロセス）

# 4. 知識が REFLECT.md と CLAUDE.md に更新
```

### コマンド

| コマンド | 説明 |
|----------|------|
| `/reflect` | キュー内の学習をレビューして処理 |
| `/reflect --analyze` | REFLECT.md の進化を分析して洞察を提供 |
| `/reflect --view` | キューの詳細を表示 |
| `/reflect --critical-only` | 重要な優先度のみを処理 |
| `/reflect --scan-history` | 過去のセッションで遗漏した学習をスキャン |
| `/skip-reflect` | すべてのキュー学習を破棄 |

---

## 🏗️ アーキテクチャ

```
┌─────────────────────┐     ┌──────────────────────┐     ┌──────────────────────┐
│   Claude と        │ ──► │   Hooks が          │ ──► │   キューに          │
│   連携             │     │   多次元学習を捕捉   │     │   メタデータを蓄積   │
└─────────────────────┘     └──────────────────────┘     └──────────────────────┘
          （自動）                   （自動）                    （自動）

┌─────────────────────┐     ┌──────────────────────┐     ┌──────────────────────┐
│   レビューして     │ ──► │   REFLECT.md に     │ ──► │   知識が            │
│   承認             │     │   適用               │     │   進化               │
└─────────────────────┘     └──────────────────────┘     └──────────────────────┘
          （手動）                   （同期）                    （継続）
```

### 3ステージシステム

**ステージ 1: キャッチ（自動）**
拡張 hooks が複数の学習次元を検出：
- 修正パターン
- 成功パターン（ポジティブなフィードバック）
- ユーザーの偏好
- 発見されたベストプラクティス
- 避けるべき一般的なエラー

**ステージ 2: 振り返り（手動）**
ユーザーが `/reflect` を実行して：
- 各学習とそのコンテキストをレビュー
- 重複/競合を検出
- 分類と優先順位付け
- 完全な履歴とともに REFLECT.md に適用

**ステージ 3: 進化（継続）**
REFLECT.md が進化記録として機能：
- 最適化履歴を追跡
- 使用パターンを監視
- 傾向を特定
- 実行可能な洞察を提供

---

## 📊 REFLECT.md 構造

REFLECT.md はコア知識進化ファイルです：

```markdown
# Open-Reflect 知識進化ログ

## 🎯 学習分類
### 🔄 修正類学習（Corrections）
### ✅ 成功パターン（Success Patterns）
### 🎨 偏好設定（Preferences）
### 📋 ベストプラクティス（Best Practices）
### ⚠️ 一般的なエラー（Common Errors）

## 🔍 インテリジェント洞察
### 📈 学習傾向分析
### 🎯 提案最適化
### 🔗 知識連携

## 📜 進化履歴
すべての変更を追跡するテーブル

## 💭 振り返りノート
### 保留キュー
### 拒否された項目
### 検証待ち項目
```

---

## 🆚 比較: claude-reflect vs open-reflect

| 機能 | claude-reflect | open-reflect |
|------|---------------|--------------|
| **プラットフォームサポート** | Claude Code のみ | Claude Code + OpenCode |
| **学習タイプ** | 修正のみ | 修正 + 成功 + 偏好 + ベストプラクティス |
| **データ構造** | シンプルなキュー | 進化を伴う構造化 REFLECT.md |
| **進化追跡** | なし | 完全な履歴（最適化、使用、検証） |
| **優先度レベル** | 信頼度のみ | 優先度 + 信頼度 + タグ |
| **重複処理** | 基本的 | セマンティック + 競合検出 + 統合 |
| **分析** | 基本的なキュービュー | 傾向分析 + 洞察 + 提案 |
| **マルチターゲット** | CLAUDE.md + AGENTS.md | REFLECT.md + CLAUDE.md + AGENTS.md |
| **コンテキスト認識** | プロジェクトのみ | プロジェクト + グローバル + 進化指標 |

---

## 💡 ヒント

### 最適な結果を得るために

1. **重要な学習には明示的マークを使用**:
   ```
   remember: Python プロジェクトには常に仮想環境を使用
   ```

2. **物がうまくいったときにポジティブなフィードバックを提供**:
   ```
   Perfect! まさに wanted 方法。
   ```

3. **定期的に /reflect を実行**:
   - Git コミット後（自動リマインダー）
   - 機能完了後
   - キューに重要な項目があるとき

4. **定期的に REFLECT.md をレビュー**:
   - 学習が正確かどうかを検証
   - 古くなったエントリを削除
   - 類似した項目を統合

5. **/reflect --analyze を使用** して表示:
   - 学習傾向
   - 捕捉された成功パターン
   - 注目が必要な領域

### 分類ガイド

| 分類 | 使用タイミング | 例 |
|------|----------------|------|
| **グローバル** | モデル名、一般的なパターン | "推論に gpt-5.1 を使用" |
| **プロジェクト** | プロジェクト固有の規約 | "キャッシュにローカルデータベースを使用" |

---

## 🧪 テスト

テストスイートを実行：

```bash
cd ~/.claude/plugins/open-reflect
./scripts/test.sh
```

---

## 🤝 貢献

貢献は大歓迎です！：

1. リポジトリをフォーク
2. 機能ブランチを作成
3. テスト付きで変更を加える
4. pull request を送信

---

## 📜 ライセンス

MIT ライセンス - [LICENSE](LICENSE) ファイルを参照。

---

## 🙏 謝辞

- Bayram Annakov の [claude-reflect](https://github.com/bayramannakov/claude-reflect) に触発されました
- Claude Code コミュニティのために構築

---

## 📞 サポート

- イシュー: [GitHub Issues](https://github.com/gyc567/open-reflect/issues)
- ディスカッション: [GitHub Discussions](https://github.com/gyc567/open-reflect/discussions)

---

**"知識は静的ではありません。それは振り返りと実践を通じて進化します。"** - Open-Reflect
