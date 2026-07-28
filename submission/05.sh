# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

FEE_SATS=$(bitcoin-cli -signet getrawtransaction "$TXID" 2 | jq '(.fee * 100000000) | round')

if [ -z "$FEE_SATS" ] || [ "$FEE_SATS" = "null" ]; then
  echo "Error: Could not calculate fee"
  exit 1
fi

echo "$FEE_SATS"
