
FROM ghcr.io/openwallet-foundation/acapy-agent:py3.12-1.2.4


USER root
RUN apt update && apt install -y jq curl

COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY --chmod=755 init_wallets.sh /init_wallets.sh
COPY data/hospital.csv         /data/hospital.csv

ENTRYPOINT ["/entrypoint.sh"]
