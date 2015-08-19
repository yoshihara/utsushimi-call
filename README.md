# 写身コール

[Company Hacking Guide: We're "Developing" Our Company // Speaker Deck](https://speakerdeck.com/snoozer05/company-hacking-guide-were-developing-our-company) を見て、Twilioを触ってみたくて作成しました。
Twilioの電話番号に電話がかかると、メッセージで案内した後メッセージを録音することができ、同時にslackに電話が来たことや相手の録音内容のURLを通知します。

## Twilio用の設定

利用する電話番号の設定で「Request URL」のところに「写身コールをデプロイしたURL/records/new」と入れ、「HTTP GET」を選択する。

## slack用の設定

デプロイサーバに環境変数 `SLACK_HOOK_URL` としてslackのincoming webhookのURLを設定する。

## やりたいこと

- 設定がある場合は録音データをS3に入れるようにする
- web上から録音データの管理ができるようにする
- web上で電話番号と・メモを登録しておいて、その電話番号から電話がかかってきた時はメモの内容もslackに通知する
