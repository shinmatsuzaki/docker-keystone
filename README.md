## セットアップ方法
1. `make` -> `Makefile` 経由で `docker-compose up` を起動
2. `make ssh` -> keystoneコンテナにssh
3. `/root/setup.sh` でkeystoneの初期設定(bootstrap)を実行 -> keystoneテーブルに各種の設定が書き込まれる

## MySQLへの接続
`mysql -u root -p` を実行後、 パスワード `secret` を入力

`docker-compose.yml` 内の `MYSQL_ROOT_PASSWORD: secret` にて設定
* keystoneの情報は `keystone` database内に格納
