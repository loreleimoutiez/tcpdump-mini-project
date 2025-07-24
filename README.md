# tcpdump-mini-project

Script de capture réseau ciblée avec tcpdump et logging des clés TLS pour l'analyse du trafic HTTPS.

## Description

Ce projet contient un script bash automatisé qui :
- Lance Google Chrome pour générer du trafic TLS
- Capture le trafic réseau vers un domaine spécifique avec tcpdump
- Configure l'export des clés TLS/SSL pour permettre le déchiffrement du trafic HTTPS
- Organise les fichiers de capture avec horodatage

## Fonctionnalités

- ✅ Capture réseau ciblée vers `www.taisezmoi.com`
- ✅ Export automatique des clés SSL/TLS via `SSLKEYLOGFILE`
- ✅ Rotation des fichiers de capture (10 minutes / 1MB max)
- ✅ Gestion des permissions root pour tcpdump
- ✅ Organisation automatique des fichiers de sortie
- ✅ **Lancement automatique de Wireshark avec déchiffrement TLS**

## Prérequis

- Linux avec bash
- `tcpdump` installé
- `sudo` privilèges pour tcpdump
- Google Chrome installé (`/usr/bin/google-chrome-stable`)
- **Wireshark installé** (pour l'analyse automatique)
- Permissions d'écriture dans `/tmp/` (le script gère automatiquement les permissions)

## Installation

```bash
git clone https://github.com/loreleimoutiez/tcpdump-mini-project.git
cd tcpdump-mini-project
chmod +x watchdog.sh
```

## Utilisation

```bash
./watchdog.sh
```

Le script va :
1. Créer les répertoires nécessaires avec les bonnes permissions
2. Lancer Chrome vers www.taisezmoi.com en arrière-plan
3. Démarrer la capture tcpdump (nécessite sudo)
4. Sauvegarder les fichiers dans `~/Documents/tcpdump-mini-project/`
5. **Ouvrir automatiquement Wireshark avec les clés TLS pour l'analyse déchiffrée**

## Structure des fichiers

```
tcpdump-mini-project/
├── watchdog.sh          # Script principal
├── sslkeys              # Fichier des clés TLS exportées
└── capture-YYYYMMDD-HHMMSS.pcap  # Fichiers de capture
```

## Options tcpdump utilisées

- `-i any` : Capture sur toutes les interfaces réseau
- `-n` : Pas de résolution DNS des adresses
- `-v` : Mode verbose pour plus de détails
- `-w` : Écriture dans un fichier de capture
- `-G 600` : Rotation des fichiers toutes les 10 minutes
- `-C 1` : Taille maximale de 1MB par fichier

## Analyse des captures

Le script lance **automatiquement Wireshark** à la fin de la capture avec :
- **Configuration automatique des clés TLS** : `-o tls.keylog_file:sslkeys`
- **Déchiffrement HTTPS en temps réel** des paquets capturés
- **Interface graphique** pour l'analyse détaillée du trafic

### Analyse manuelle alternative

Les fichiers `.pcap` peuvent aussi être analysés manuellement avec :
- **Wireshark** : Interface graphique pour l'analyse détaillée
- **tshark** : Version en ligne de commande de Wireshark
- Les clés TLS dans le fichier `sslkeys` permettent le déchiffrement HTTPS

Exemple avec tshark :
```bash
tshark -r capture-20250723-143022.pcap -o tls.keylog_file:sslkeys
```
