# what is the coinbase tx in this block 243,834
BLOCK_HEIGHT=243834

RPC_CMD="bitcoin-cli -signet -rpcuser=btrustbuildersrpc -rpcpassword=btrustbuilderspass -rpcconnect=167.172.185.136 -rpcport=38332"

# Get the block hash
BLOCK_HASH=$($RPC_CMD getblockhash $BLOCK_HEIGHT)

# Get the first transaction in the block (coinbase is always tx[0])
COINBASE_TX=$($RPC_CMD getblock "$BLOCK_HASH" 1 | jq -r '.tx[0]')

if [ -z "$COINBASE_TX" ] || [ "$COINBASE_TX" = "null" ]; then
  echo "Error: Could not fetch coinbase transaction for block $BLOCK_HEIGHT"
  exit 1
fi

echo "$COINBASE_TX"
