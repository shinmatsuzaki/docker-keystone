## セットアップ方法
1. `make` -> `Makefile` 経由で `docker-compose up` を起動
2. `make ssh` -> keystoneコンテナにssh
3. `/root/setup.sh` でkeystoneの初期設定(bootstrap)を実行 -> keystoneテーブルに各種の設定が書き込まれる
4. 以下のようにopenstackコマンドが実行できることを確認

```
# openstack endpoint list
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------+
| ID                               | Region    | Service Name | Service Type | Enabled | Interface | URL                       |
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------+
| 6afaf303bdb7404e813abe2fb52fc04b | RegionOne | keystone     | identity     | True    | internal  | http://localhost:5000/v3/ |
| 7986726c74024e77a2b649e55d937e73 | RegionOne | keystone     | identity     | True    | admin     | http://localhost:5000/v3/ |
| ece3507c6e0a40b1ac15f6b9d55f9fde | RegionOne | keystone     | identity     | True    | public    | http://localhost:5000/v3/ |
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------+
```

* 実行できない場合以下の環境変数の見直しが必要
```
# env | grep OS | sort
HOSTNAME=f9655f8a8388
OS_AUTH_URL=http://localhost:5000/v3
OS_IDENTITY_API_VERSION=3
OS_PASSWORD=ADMIN_PASS
OS_PROJECT_DOMAIN_NAME=Default
OS_PROJECT_NAME=admin
OS_USERNAME=admin
OS_USER_DOMAIN_NAME=Default
```
## projectやendpointを試しに作成してみたい
- [公式のチュートリアル](https://docs.openstack.org/newton/ja/install-guide-debian/keystone-users.html)に従い試してみましょう

## MySQLへの接続
`mysql -u root -p` を実行後、 パスワード `secret` を入力

`docker-compose.yml` 内の `MYSQL_ROOT_PASSWORD: secret` にて設定
* keystoneの情報は `keystone` database内に格納

### CLIツール
[keystoneコマンドはdeprecatedになり](https://docs.openstack.org/mitaka/cli-reference/keystone.html)現在は、[OpenStack command client](https://docs.openstack.org/mitaka/cli-reference/openstack.html) の利用が推奨されているため、そちらをインストールする構成にしています。
