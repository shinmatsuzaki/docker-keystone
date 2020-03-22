#!/bin/sh
set -e

# 各コマンドは以下ドキュメントに従い作成
# https://docs.openstack.org/newton/ja/install-guide-debian/keystone-install.html

# データベースの作成
echo "--------------------------------------------------------------------------------"
echo " keystone-manager db_sync : migrationファイルに従い、DB Schemaを作成"
echo " - $ keystone-manage db_sync"
echo "--------------------------------------------------------------------------------"

su -s /bin/sh -c "keystone-manage db_sync" keystone 

# fernetトークンの初期化
echo "--------------------------------------------------------------------------------"
echo " create fernet token : 以下のコマンドが実行される"
echo " - $ keystone-manage fernet_setup"
echo " - $ keystone-manage credential_setup"
echo "--------------------------------------------------------------------------------"

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone 
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone 

# bootstrap
#  endpointテーブルに以下のレコードが作成される
# mysql> select interface,url,region_id from endpoint;
#
# +-----------+---------------------------------+-----------+
# | interface | url                             | region_id |
# +-----------+---------------------------------+-----------+
# | internal  | http://keystone-server:5000/v3/ | RegionOne |
# | admin     | http://keystone-server:5000/v3/ | RegionOne |
# | public    | http://keystone-server:5000/v3/ | RegionOne |
# +-----------+---------------------------------+-----------+

echo "--------------------------------------------------------------------------------"
echo " keystone-manage bootstrap :"
echo "--------------------------------------------------------------------------------"

keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
  --bootstrap-admin-url http://localhost:5000/v3/ \
  --bootstrap-internal-url http://localhost:5000/v3/ \
  --bootstrap-public-url http://localhost:5000/v3/ \
  --bootstrap-region-id RegionOne

# optional arguments:
#  -h, --help            show this help message and exit
#
#  --bootstrap-username OS_BOOTSTRAP_USERNAME
#                        The username of the initial keystone user during
#                        bootstrap process.
#
#  --bootstrap-password OS_BOOTSTRAP_PASSWORD
#                        The bootstrap user password
#
#  --bootstrap-project-name OS_BOOTSTRAP_PROJECT_NAME
#                        The initial project created during the keystone
#                        bootstrap process.
#
#  --bootstrap-role-name OS_BOOTSTRAP_ROLE_NAME
#                        The initial role-name created during the keystone
#                        bootstrap process.
#
#  --bootstrap-service-name OS_BOOTSTRAP_SERVICE_NAME
#                        The initial name for the initial identity service
#                        created during the keystone bootstrap process.
#
#  --bootstrap-admin-url OS_BOOTSTRAP_ADMIN_URL
#                        The initial identity admin url created during the
#                        keystone bootstrap process. e.g.
#                        http://127.0.0.1:35357/v3
#
#  --bootstrap-public-url OS_BOOTSTRAP_PUBLIC_URL
#                        The initial identity public url created during the
#                        keystone bootstrap process. e.g.
#                        http://127.0.0.1:5000/v3
#
#  --bootstrap-internal-url OS_BOOTSTRAP_INTERNAL_URL
#                        The initial identity internal url created during the
#                        keystone bootstrap process. e.g.
#                        http://127.0.0.1:5000/v3
#
#  --bootstrap-region-id OS_BOOTSTRAP_REGION_ID
#                        The initial region_id endpoints will be placed i#
#                        during the keystone bootstrap process.

