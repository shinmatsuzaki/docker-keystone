#!/bin/sh
set -e

# データベースの作成
su -s /bin/sh -c "keystone-manage db_sync" keystone 

# fernetトークンの初期化
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone 
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone 

keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
  --bootstrap-admin-url http://keystone-server:5000/v3/ \
  --bootstrap-internal-url http://keystone-server:5000/v3/ \
  --bootstrap-public-url http://keystone-server:5000/v3/ \
  --bootstrap-region-id RegionOneaaa
