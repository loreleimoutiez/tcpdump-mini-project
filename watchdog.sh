#!/bin/bash

# ------------------------------
# Script de capture réseau ciblée avec tcpdump + logging des clés TLS
# ------------------------------

export SSLKEYLOGFILE="$HOME/Documents/tcpdump-mini-project/sslkeys"

# Répertoire temporaire pour la capture (accessible par root)
TMP_CAPTURE_DIR="/tmp/tcpdump-captures"
sudo mkdir -p "$TMP_CAPTURE_DIR"
sudo chmod 777 "$TMP_CAPTURE_DIR"

# Répertoire de destination final pour les captures
DEST_DIR="$HOME/Documents/tcpdump-mini-project"
mkdir -p "$DEST_DIR"

# Timestamp
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
TMP_FILENAME="$TMP_CAPTURE_DIR/capture-$TIMESTAMP.pcap"

# Démarre Chrome pour générer du trafic TLS
/usr/bin/google-chrome-stable "https://www.taisezmoi.com" &
sleep 10

# Lance tcpdump avec privilèges root pour capturer le trafic vers taisezmoi.com
# Options : -i any (toutes interfaces), -n (pas de résolution DNS), -v (verbose)
# -w (écriture fichier), -G 600 (rotation toutes les 10min), -C 1 (taille max 1MB)
sudo tcpdump -i any host taisezmoi.com -n -v \
  -w "$TMP_FILENAME" -G 600 -C 1

# Déplace les fichiers de capture du répertoire temporaire vers le répertoire final
sudo mv "$TMP_FILENAME"* "$DEST_DIR"

echo "Capture terminée et déplacée dans $DEST_DIR"

# Trouve le fichier de capture le plus récent
LATEST_CAPTURE=$(ls -t "$DEST_DIR"/capture-*.pcap 2>/dev/null | head -n1)

if [ -n "$LATEST_CAPTURE" ]; then
    echo "Lancement de Wireshark avec le fichier de capture: $(basename "$LATEST_CAPTURE")"
    echo "Les clés TLS seront automatiquement chargées depuis: $SSLKEYLOGFILE"
    
    # Lance Wireshark avec le fichier de capture et les clés TLS
    # -o tls.keylog_file configure automatiquement le déchiffrement HTTPS
    wireshark -o tls.keylog_file:"$SSLKEYLOGFILE" "$LATEST_CAPTURE" &
    
    echo "Wireshark lancé en arrière-plan pour l'analyse des paquets déchiffrés"
else
    echo "Aucun fichier de capture trouvé à analyser"
fi
