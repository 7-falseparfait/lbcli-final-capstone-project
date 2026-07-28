# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb


TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

RPC_CMD="bitcoin-cli -signet -rpcuser=btrustbuildersrpc -rpcpassword=btrustbuilderspass -rpcconnect=167.172.185.136 -rpcport=38332"

# Get the transaction details
TX_DATA=$($RPC_CMD getrawtransaction "$TXID" true)

# Get the previous output (UTXO) being spent
PREV_TXID=$(echo "$TX_DATA" | jq -r '.vin[0].txid')
PREV_VOUT=$(echo "$TX_DATA" | jq -r '.vin[0].vout')
PREV_TX=$($RPC_CMD getrawtransaction "$PREV_TXID" true)

# Input value (from the UTXO being spent)
INPUT_BTC=$(echo "$PREV_TX" | jq -r ".vout[$PREV_VOUT].value")

# Output value (total of all new outputs)
OUTPUT_BTC=$(echo "$TX_DATA" | jq '[.vout[].value] | add')

# Fee = inputs - outputs
FEE_BTC=$(echo "$INPUT_BTC - $OUTPUT_BTC" | bc)

# Convert to satoshis
FEE_SATS=$(echo "$FEE_BTC * 100000000 / 1" | bc)

echo "$FEE_SATS"
