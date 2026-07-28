BLOCK_HEIGHT=243821

RPC_CMD="bitcoin-cli -signet -rpcuser=btrustbuildersrpc -rpcpassword=btrustbuilderspass -rpcconnect=167.172.185.136 -rpcport=38332"

BLOCK_HASH=$($RPC_CMD getblockhash $BLOCK_HEIGHT)

# Use verbosity 1 to get txids only
TX_IDS=$($RPC_CMD getblock "$BLOCK_HASH" 1 | jq -r '.tx[]')

for TXID in $TX_IDS; do
  TX_DETAILS=$($RPC_CMD getrawtransaction "$TXID" 1 2>/dev/null)
  RBF=$(echo "$TX_DETAILS" | jq -r '.vin[] | select(.sequence < 4294967295) | .sequence' 2>/dev/null | head -1)
  if [ ! -z "$RBF" ]; then
    echo "$TXID"
    exit 0
  fi
done

echo "No transaction with RBF found"
exit 1
