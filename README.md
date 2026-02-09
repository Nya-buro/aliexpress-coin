# アリエクのコインbot

毎日の日課を忘れないようにDiscordにリマインドするためのbotです

## 概要

このプロジェクトは systemd のサービスとタイマーを使用して、スケジュール実行される シェルスクリプトです。毎日米国太平洋時間の深夜0時（日本時間では通常午後5時、夏時間は午後4時）に実行されます。

## ファイル構成

### `aliexpress-coin.sh`

メインのスクリプトファイルです。以下の処理を実行します：

- `.env` ファイルから環境変数を読み込み
- `MESSAGE` 変数の内容を webhook URL にポストします

**必要な環境変数：**

- `MESSAGE`: 送信するメッセージ
- `WEBHOOK_URL`: ポスト先の webhook URL

### `aliexpress-coin.service`

systemd サービス定義ファイル：

- **説明**: Aliexpress Coin Bot
- **実行方式**: ワンショット実行（oneshot）
- **実行ユーザー**: root
- **実行スクリプト**: `/var/aliexpress-coin/aliexpress-coin.sh`

### `aliexpress-coin.timer`

systemd タイマー定義ファイル：

- **実行スケジュール**: 毎日 00:00:00（米国太平洋時間）
- **タイムゾーン**: America/Los_Angeles
- **Persistent**: true（システム起動時に遅延実行）

## セットアップ

### 1. Webhook URLの取得

Discordの「サーバー設定」→「連携」→「ウェブフック」→「新しいウェブフック」
アイコン・名前・投稿先チャンネルを設定し、「ウェブフックURLをコピー」

ここでコピーしたURLを手順3.で利用します

### 2. ファイルのインストール

```bash
# サービスとタイマーファイルを systemd ディレクトリにコピー
sudo cp aliexpress-coin.service /etc/systemd/system/
sudo cp aliexpress-coin.timer /etc/systemd/system/

# スクリプトを配置
sudo mkdir -p /var/aliexpress-coin
sudo cp aliexpress-coin.sh /var/aliexpress-coin/
sudo chmod +x /var/aliexpress-coin/aliexpress-coin.sh
```

### 3. 環境変数の設定

```bash
sudo nano /var/aliexpress-coin/.env
```

`.env` ファイルに以下の変数を設定してください：

```env
MESSAGE="Your message here"
WEBHOOK_URL="https://your-webhook-url.com/endpoint"
```

### 4. systemd の再読み込みと有効化

```bash
# systemd 設定をリロード
sudo systemctl daemon-reload

# タイマーを有効化して開始
sudo systemctl enable aliexpress-coin.timer
sudo systemctl start aliexpress-coin.timer
```

## 動作確認

### タイマーの状態確認

```bash
sudo systemctl status aliexpress-coin.timer
```

### タイマーの次回実行時刻確認

```bash
sudo systemctl list-timers aliexpress-coin.timer
```

### サービスの手動実行

```bash
sudo systemctl start aliexpress-coin.service
```

### ログ確認

```bash
sudo journalctl -u aliexpress-coin.service -n 50
```

## トラブルシューティング

**スクリプトが実行されない場合：**

- `.env` ファイルが正しく配置されているか確認
- `aliexpress-coin.sh` の実行権限を確認
- `WEBHOOK_URL` が正しく設定されているか確認
- ログを確認：`journalctl -u aliexpress-coin.service`

**タイマーが実行されない場合：**

- タイマーが有効化されているか確認：`systemctl is-enabled aliexpress-coin.timer`
- システムの時刻が正しく設定されているか確認
- タイムゾーン設定を確認
