# GameTrigger

ゲーム大会やイベントの情報を掲載・検索できるWebアプリです。主催者はゲームタイトルごとに大会情報を投稿でき、参加したい人は大会名・タグ・主催者名から探せます。

## 主な機能

- ゲームタイトルごとの大会情報の投稿・編集
- 大会名・タグ・主催者名を使った絞り込み検索
- イベント画像の登録や、外部リンクのプレビュー
- Google・Twitterのアカウントを使ったログイン

## 実装の見どころ

検索対象をまず選択中のゲームに絞り、その中で大会名・タグ・主催者名のいずれかに一致するイベントをまとめて表示します。大会情報、タグ、リンク情報は別のモデルとして管理しています。

- [search_controller.rb](app/controllers/search_controller.rb)：ゲーム別・キーワード別のイベント検索
- [game_events_controller.rb](app/controllers/game_events_controller.rb)：大会の登録・編集と外部リンクの取り扱い
- [game_event.rb](app/models/game_event.rb)：大会とタグ・リンク情報の関連付け、画像アップロード

## 使用技術

Ruby / Ruby on Rails / Active Record / CarrierWave / Devise / OmniAuth
