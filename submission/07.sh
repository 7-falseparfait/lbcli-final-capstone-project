# what is the coinbase tx in this block 243,834

BLOCK_HEIGHT=243834

# Get the block hash
BLOCK_HASH=$(bitcoin-cli -signet getblockhash $BLOCK_HEIGHT)

# Get the first transaction in the block (coinbase is always tx[0])
COINBASE_TX=$(bitcoin-cli -signet getblock "$BLOCK_HASH" 1 | jq -r '.tx[0]')

if [ -z "$COINBASE_TX" ] || [ "$COINBASE_TX" = "null" ]; then
  echo "Error: Could not fetch coinbase transaction for block $BLOCK_HEIGHT"
  exit 1
fi

echo "$COINBASE_TX"
