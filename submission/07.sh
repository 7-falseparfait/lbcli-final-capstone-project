# what is the coinbase tx in this block 243,834
#!/bin/bash

RPC_CMD="bitcoin-cli -signet -rpcuser=btrustbuildersrpc -rpcpassword=btrustbuilderspass -rpcconnect=167.172.185.136 -rpcport=38332"

BLOCK_HASH=$($RPC_CMD getblockhash 243834)

# Coinbase is always the first transaction in the block
COINBASE_TX=$($RPC_CMD getblock "$BLOCK_HASH" | jq -r '.tx[0]')

echo "$COINBASE_TX"
