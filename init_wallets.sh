#!/bin/bash

echo "🩺 병원 지갑 및 peer DID 생성 시작"

while read hospital_name; do
  echo "📁 테넌트 지갑 생성: $hospital_name"

  WALLET_RES=$(curl -s -X POST http://localhost:8001/multitenancy/wallet \
    -H "Content-Type: application/json" \
    -d '{
      "wallet_name": "'"$hospital_name"'",
      "wallet_key": "key'"$hospital_name"'",
      "wallet_type": "askar",
      "label": "'"$hospital_name"'",
      "wallet_dispatch_type": "default"
    }')

  TOKEN=$(echo "$WALLET_RES" | jq -r '.token')

  echo "🔐 peer DID 생성 (did:peer:4): $hospital_name"
  DID_RES=$(curl -s -X POST http://localhost:8001/wallet/did/create \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "method": "did:peer:4",
      "options": {
        "key_type": "ed25519",
        "peer": { "numalgo": 4 }
      }
    }')

  DID=$(echo "$DID_RES" | jq -r '.result.did')
  echo "✅ DID 저장 완료: $hospital_name → $DID"

done < /hospitals.txt

echo "🎉 모든 병원 지갑 및 DID 생성 완료"
