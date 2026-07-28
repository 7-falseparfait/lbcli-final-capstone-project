# what block height was this tx mined ?
# 49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb

TXID="49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb"

# Get blockhash from the transaction
BLOCKHASH=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 | jq -r '.blockhash')

# Get block height from the blockhash
bitcoin-cli -signet getblock "$BLOCKHASH" 1 | jq -r '.height'
