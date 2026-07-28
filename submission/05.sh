# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb

TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"

# Get the transaction details
TX_DETAILS=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 2>/dev/null)

if [ -z "$TX_DETAILS" ]; then
  echo "Error: Could not fetch transaction details for TXID $TXID"
  exit 1
fi

# Calculate fee = sum(inputs) - sum(outputs)
INPUTS_SUM=$(echo "$TX_DETAILS" | jq '.vin | map(.prevout.value) | add')
OUTPUTS_SUM=$(echo "$TX_DETAILS" | jq '.vout | map(.value) | add')
FEE=$(echo "$INPUTS_SUM - $OUTPUTS_SUM" | bc)

if [ -z "$FEE" ] || [ "$FEE" = "null" ]; then
  echo "Error: Could not calculate fee"
  exit 1
fi

# Convert BTC to satoshis and print as integer
FEE_SATS=$(echo "$FEE * 100000000" | bc | cut -d. -f1)
echo "$FEE_SATS"
