api_key=${TMDB_API_KEY}

if [[ -z api_key ]]; then
  echo "Error: Environment variable TMDB_API_KEY is not set."
  exit 1
fi


python3 ./../scripts/secrets/gyb/gyb.py --line-directive '' -o ./Sources/Network/Secrets.swift ../scripts/secrets/Secrets.swift.gyb