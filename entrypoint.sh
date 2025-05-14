#!/bin/bash

aca-py start \
  --inbound-transport http 0.0.0.0 8000 \
  --outbound-transport http \
  --admin 0.0.0.0 8001 \
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
  --log-level info &

PID=$!
sleep 5
/init_wallets.sh


wait $PID
