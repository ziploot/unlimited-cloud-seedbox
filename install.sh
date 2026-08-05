#!/bin/bash
# ZipLoot Linux/macOS 1-Click Cloud Seedbox Setup
echo "=============================================="
echo "[ZipLoot] Unlimited High-Speed Torrent Downloader"
echo "=============================================="

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

BASE_URL="https://raw.githubusercontent.com/Ziplootapp/unlimited-cloud-seedbox/main"
FILES=("index.js" "package.json" "render.yaml" "README.md")
for FILE in "${FILES[@]}"; do
    if [ ! -f "$FILE" ]; then
        echo "[+] Downloading missing file: $FILE ..."
        curl -sL "$BASE_URL/$FILE" -o "$FILE"
    fi
done

echo ""
echo "=============================================="
echo "⚡ OPTION 1: 1-Click Cloud Deployment (Render - \$0 Free Hosting)"
echo "=============================================="
echo "Deploy to the cloud in 10 seconds for \$0:"
echo "1. Log into Render."
echo "2. The installer will open the 1-Click deploy page."
echo "3. Click 'Create Web Service' and you are live!"
echo ""

read -p "[INPUT] Do you want to open the 1-Click Render Deployment page now? (y/n): " OPEN_CLOUD
if [ "$OPEN_CLOUD" = "y" ] || [ "$OPEN_CLOUD" = "Y" ]; then
    if command -v xdg-open > /dev/null; then
        xdg-open "https://render.com/deploy?repo=https://github.com/Ziplootapp/unlimited-cloud-seedbox"
    elif command -v open > /dev/null; then
        open "https://render.com/deploy?repo=https://github.com/Ziplootapp/unlimited-cloud-seedbox"
    fi
fi

echo ""
echo "=============================================="
echo "⚡ OPTION 2: Local Server Setup"
echo "=============================================="
read -p "[INPUT] Do you want to run the Seedbox server locally? (y/n): " RUN_LOCAL

if [ "$RUN_LOCAL" = "y" ] || [ "$RUN_LOCAL" = "Y" ]; then
    npm install
    
    echo -e "\n[START] Launching Local Seedbox Server..."
    node index.js > /dev/null 2>&1 &
    sleep 2
    
    echo -e "\n[BROWSER] Opening Local Seedbox Dashboard..."
    if command -v xdg-open > /dev/null; then
        xdg-open "http://localhost:7860"
    elif command -v open > /dev/null; then
        open "http://localhost:7860"
    fi
    
    echo ""
    echo "[SUCCESS] Local Seedbox Server running in the background!"
    echo "To start it manually later, run 'npm start' in: $SCRIPT_DIR"
fi
echo ""
