#!/bin/bash
BLOCK_HEIGHT=243821

BLOCK_HASH=$(bitcoin-cli -signet getblockhash $BLOCK_HEIGHT)

# Use verbosity 1 to get txids only
TX_IDS=$(bitcoin-cli -signet getblock "$BLOCK_HASH" 1 | jq -r '.tx[]')

for TXID in $TX_IDS; do
  TX_DETAILS=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 2>/dev/null)
  RBF=$(echo "$TX_DETAILS" | jq -r '.vin[] | select(.sequence < 4294967295) | .sequence' 2>/dev/null | head -1)
  if [ ! -z "$RBF" ]; then
    echo "$TXID"
    exit 0
  fi
done

echo "No transaction with RBF found"
exit 1
