# what block height was this tx mined ?
# 49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb


TXID="49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb"

RPC_CMD="bitcoin-cli -signet -rpcuser=btrustbuildersrpc -rpcpassword=btrustbuilderspass -rpcconnect=167.172.185.136 -rpcport=38332"

# Get blockhash, then get block height
BLOCK_HEIGHT=$($RPC_CMD getrawtransaction "$TXID" true | jq -r '.blockhash' | xargs -I {} $RPC_CMD getblock {} | jq -r '.height')

echo "$BLOCK_HEIGHT"
