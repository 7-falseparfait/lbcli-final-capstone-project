#!/bin/bash

SPENDING_BLOCK=216351
COINBASE_BLOCK=216128

# Get coinbase txid from block 216,128
COINBASE_BLOCK_HASH=$(bitcoin-cli -signet getblockhash $COINBASE_BLOCK)
COINBASE_TXID=$(bitcoin-cli -signet getblock "$COINBASE_BLOCK_HASH" 1 | jq -r '.tx[0]')

# Get all txids in block 216,351 (verbosity 1 = txids only)
SPENDING_BLOCK_HASH=$(bitcoin-cli -signet getblockhash $SPENDING_BLOCK)
SPENDING_TXIDS=$(bitcoin-cli -signet getblock "$SPENDING_BLOCK_HASH" 1 | jq -r '.tx[]')

# Search for tx that spends the coinbase output
for TXID in $SPENDING_TXIDS; do
  TX_DETAILS=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 2>/dev/null)
  SPENDS=$(echo "$TX_DETAILS" | jq -r ".vin[] | select(.txid == \"$COINBASE_TXID\" and .vout == 0) | .txid" 2>/dev/null)
  if [ ! -z "$SPENDS" ]; then
    echo "$TXID"
    exit 0
  fi
done

echo "No transaction found"
exit 1
