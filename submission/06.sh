RPC_CMD="bitcoin-cli -signet -rpcuser=btrustbuildersrpc -rpcpassword=btrustbuilderspass -rpcconnect=167.172.185.136 -rpcport=38332"

BLOCK_HASH=$($RPC_CMD getblockhash 243821)

# Loop through each tx in the block and check for RBF (sequence < 0xfffffffe)
TXID=$($RPC_CMD getblock "$BLOCK_HASH" | jq -r '.tx[]' | while read -r TX; do
  if $RPC_CMD getrawtransaction "$TX" true | jq -e '.vin[] | select(.sequence < 4294967294)' >/dev/null 2>&1; then
    echo "$TX"
    break
  fi
done)

echo "$TXID"
