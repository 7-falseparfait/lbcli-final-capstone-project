# Which public key signed input 0 in this tx: d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7
TXID="d948454ceab1ad56982b11cf6f7157b91d3c6c5640e05c041cd17db6fff698f7"

# Get the transaction details
TX_DETAILS=$(bitcoin-cli -signet getrawtransaction "$TXID" 1 2>/dev/null)

if [ -z "$TX_DETAILS" ]; then
  echo "Error: Could not fetch transaction details for TXID $TXID"
  exit 1
fi

# Extract the public key from input 0
# For SegWit transactions, the public key is in txinwitness[1]
# For legacy transactions, it's in scriptSig
PUBKEY=$(echo "$TX_DETAILS" | jq -r '
  .vin[0] |
  if .txinwitness then
    .txinwitness[1]
  elif .scriptSig.asm then
    (.scriptSig.asm | split(" ") | .[-1])
  else
    null
  end
')

if [ -z "$PUBKEY" ] || [ "$PUBKEY" = "null" ]; then
  echo "Error: Could not extract public key from input 0"
  exit 1
fi

echo "$PUBKEY"
