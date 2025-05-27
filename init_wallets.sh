#!/bin/bash

echo ">>Wallets & DIDs Creation Started"
echo "{" > /hospital_tokens.json

while read hospital_name; do
  echo ">>테넌트 지갑 생성: $hospital_name"

  WALLET_RES=$(curl -s -X POST http://localhost:8002/multitenancy/wallet \
    -H "Content-Type: application/json" \
    -d '{
      "wallet_name": "'"$hospital_name"'",
      "wallet_key": "key'"$hospital_name"'",
      "wallet_type": "askar",
      "label": "'"$hospital_name"'",
      "wallet_dispatch_type": "default"
    }')

  TOKEN=$(echo "$WALLET_RES" | jq -r '.token')


  echo ">>Peer DID 생성: $hospital_name"
  DID_RES=$(curl -s -X POST http://localhost:8002/wallet/did/create \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "method": "did:peer:2",
      "options": {
        "key_type": "ed25519",
        "peer": { "numalgo": 2 }
      }
    }')

  DID=$(echo "$DID_RES" | jq -r '.result.did')
  echo ">>DID 저장 완료: $hospital_name → $DID"

  # JSON 파일에 병원 이름별 토큰 저장 (JSON 안전 인코딩 포함)
  echo "  \"${hospital_name}\": \"${TOKEN}\"," >> /hospital_tokens.json
  echo "================================================================="
done < /hospitals.txt

# JSON 마지막 쉼표 제거 + 닫기
sed -i '$ s/,$//' /hospital_tokens.json
echo "}" >> /hospital_tokens.json

echo ">>All wallets & DIDs creation completed"
