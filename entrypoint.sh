#!/bin/bash

aca-py start \
  --endpoint http://192.168.0.82:8005 \
  --inbound-transport http 0.0.0.0 8005 \
  --inbound-transport ws 0.0.0.0 8020 \
  --outbound-transport ws \
  --outbound-transport http \
  --admin 0.0.0.0 8002 \
  --admin-insecure-mode \
  --wallet-type askar \
  --wallet-name base_wallet \
  --wallet-key basekey \
  --wallet-storage-type sqlite \
  --wallet-storage-config '{"path":"/tmp/base_wallet.db"}' \
  --multitenant \
  --multitenant-admin \
  --jwt-secret mysupersecret \
  --auto-provision \
  --label multitenant-aca \
  --no-ledger \
  --auto-accept-invites \
  --auto-accept-requests \
  --auto-respond-messages \
  --auto-respond-credential-offer \
  --auto-respond-credential-request \
  --auto-respond-presentation-request \
  --enable-undelivered-queue \
  --emit-new-didcomm-prefix \
  --open-mediation \
  --log-level info &

PID=$!
sleep 5
/init_wallets.sh
wait $PID
