## 2 . Lets's go

🌞 **Afficher la quantité d'espace disque disponible**

```bash
df -h --output=avail / | tail -n +2
4.3G
```

🌞 **Afficher combien de fichiers il est possible de créer**

```bash
df -i / | tail -n 1 | tr -s  ' ' | cut -d ' ' -f 4
2887127
```

🌞 **Afficher l'heure et la date**

```bash
date "+%d/%m/%y %H:%M:%S"
09/12/24 16:14:46
```

🌞 **Afficher la version de l'OS précise**

```bash
source /etc/os-release && echo $PRETTY_NAME
Rocky Linux 9.5 (Blue Onyx)
```

🌞 **Afficher la version du kernel en cours d'utilisation précise**

```bash
uname -r
5.14.0-503.14.1.el9_5.x86_64
```

🌞 **Afficher le chemin vers la commande `python3`**

```bash
which python3
/usr/bin/python3
```

🌞 **Afficher l'utilisateur actuellement connecté**

```bash
whoami
fent
```

🌞 **Afficher le shell par défaut de votre utilisateur actuellement connecté**

```bash
cat /etc
```

🌞 **Afficher le shell par défaut de votre utilisateur actuellement connecté**

```bash
cat /etc/passwd | grep $USER | cut -d ':' -f 7
/bin/bash
```

🌞 **Afficher le nombre de paquets installés**


```bash
rpm -qa | wc -l
358
```

🌞 **Afficher le nombre de ports en écoute**

```bash
ss -tlnpt | grep -c LISTEN
2
```

# Partie II 

🌞 Écrire un script de base (id.sh)

```bash
bash id.sh
Salu a toa fent.
Nouvelle connexion 09/12/24 16:45:31.
Connecté avec le shell /bin/bash.
OS : Rocky Linux 9.5 (Blue Onyx) - Kernel : 5.14.0-503.14.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
```
🌞 Améliorer le script pour afficher l'état du firewall

```?
# Vérifier si firewalld est actif
FIREWALL_STATUS=$(systemctl is-active firewalld)

# Affichage du statut du firewall
if [ "$FIREWALL_STATUS" == "active" ]; then
    echo "Le firewall est actif."
else
    echo "Le firewall est inactif."
fi
```
ça donne

```bash id.sh
Salu a toa fent.
Nouvelle connexion 09/12/24 16:50:03.
Connecté avec le shell /bin/bash.
OS : Rocky Linux 9.5 (Blue Onyx) - Kernel : 5.14.0-503.14.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
Le firewall est actif.
```

🌞 Automatiser l'exécution du script dans le terminal

```bash
sudo mv id.sh /opt/id.sh
sudo chmod +x /opt/id.sh
echo "/opt/id.sh" >> ~/.bashrc

```

# Partie III : Script youtube-disponible


## 1 . Premier script youtube-dl 

### A . Le principe

# Partie III : Script yt-dlp

**Dans cette partie, vous allez coder un petit script qui télécharge des vidéos Youtube.** On lui file une URL d'une vidéo en argument, et il la télécharge !

Dans un deuxième temps on automatisera un peu le truc, en exécutant notre script à l'aide d'un *service* : il téléchargera toutes les vidéos qu'on lui donnera (on écrira les URLs dans un fichier, et il le lit à intervalles réguliers).

![emoboi](./img/emoboy.png)

## Sommaire

- [Partie III : Script yt-dlp](#partie-iii--script-yt-dlp)
  - [Sommaire](#sommaire)
  - [1. Premier script yt-dlp](#1-premier-script-yt-dlp)
    - [A. Le principe](#a-le-principe)
    - [B. Rendu attendu](#b-rendu-attendu)
  - [2. MAKE IT A SERVICE](#2-make-it-a-service)
    - [A. Adaptation du script](#a-adaptation-du-script)
    - [B. Le service](#b-le-service)
    - [C. Rendu attendu](#c-rendu-attendu)
  - [3. Bonus](#3-bonus)

## 1. Premier script yt-dlp

### A. Le principe

**Un petit script qui télécharge des vidéos Youtube.** Vous l'appellerez `yt.sh`. Il sera stocké dans `/opt/yt/yt.sh`.

**Pour ça on va avoir besoin d'une commande : `yt-dlp`.** Suivez les instructions suivantes pour récupérer la commande `yt-dlp` :

```bash
curl -SLO https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
sudo mv yt-dlp /usr/local/bin
sudo chmod +x /usr/local/bin/yt-dlp
```

Vous pourrez ensuite utiliser la commande :

```bash
yt-dlp <URL>
```

Comme toujours, **PRENEZ LE TEMPS** de manipuler la commande et d'explorer un peu le `yt-dlp --help`.

Le contenu de votre script :

➜ **1. Permettre le téléchargement d'une vidéo youtube dont l'URL est passée au script**

- **la vidéo devra être téléchargée dans le dossier `/opt/yt/downloads/`**
  - tester que le dossier existe
  - vous pouvez utiliser la commande 🐚 `exit` pour que le script s'arrête
- plus précisément, **chaque téléchargement de vidéo créera un dossier**
  - `/opt/yt/downloads/<NOM_VIDEO>`
  - il vous faudra donc, avant de télécharger la vidéo, exécuter une commande pour récupérer son nom afin de créer le dossier en fonction
- la vidéo sera téléchargée dans
  - `/opt/yt/downloads/<NOM_VIDEO>/<NOM_VIDEO>.mp4`
- **la description de la vidéo sera aussi téléchargée**
  - dans `/opt/yt/downloads/<NOM_VIDEO>/description`
  - on peut récup la description avec une commande `yt-dlp`
- **la commande `yt-dlp` génère du texte dans le terminal, ce texte devra être masqué**
  - vous pouvez utiliser une redirection de flux vers `/dev/null`, c'est ce que l'on fait généralement pour se débarasser d'une sortie non-désirée

Il est possible de récupérer les arguments passés au script dans les variables `$1`, `$2`, etc.

```bash
$ cat script.sh
echo $1

$ ./script.sh toto
toto
```

➜ **2. Le script produira une sortie personnalisée**

- utilisez la commande `echo` pour écrire dans le terminal
- la sortie **DEVRA** être comme suit :

```bash
$ /opt/yt.sh https://www.youtube.com/watch?v=sNx57atloH8
Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded. 
File path : /srv/yt/downloads/tomato anxiety/tomato anxiety.mp4`
```

➜ **3. A chaque vidéo téléchargée, votre script produira une ligne de log dans le fichier `/var/log/yt/download.log`**

- votre script doit s'assurer que le dossier `/var/log/yt/` existe
  - tester que le dossier existe
  - sinon quitter en appelant la commande `exit`
- la ligne doit être comme suit :

```
[yy/mm/dd hh:mm:ss] Video <URL> was downloaded. File path : <PATH>`
```

Par exemple :

```
[21/11/12 13:22:47] Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded. File path : /srv/yt/downloads/tomato anxiety/tomato anxiety.mp4`
```

> Hint : La commande `date` permet d'afficher la date et de choisir à quel format elle sera affichée. Idéal pour générer des logs. [J'ai trouvé ce lien](https://www.geeksforgeeks.org/date-command-linux-examples/), premier résultat google pour moi, y'a de bons exemples (en bas de page surtout pour le formatage de la date en sortie).

```bash
sudo nano yt.sh
```
```bash
#!/bin/bash

# Check if l'url est derrier arfu
if [ -z "$1" ]; then
    echo "No URL provided. Usage: $0 <youtube_url>"
    exit 1
fi

URL=$1
DOWNLOAD_DIR="/opt/yt/downloads"
LOG_FILE="/var/log/yt/download.log"

# verif si exist
if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "Download directory $DOWNLOAD_DIR does not exist. Exiting."
    exit 1
fi

# directory temp
VIDEO_NAME=$(yt-dlp --get-title "$URL")
VIDEO_DIR="$DOWNLOAD_DIR/$VIDEO_NAME"
mkdir -p "$VIDEO_DIR"

# Download la vid
yt-dlp -o "$VIDEO_DIR/$VIDEO_NAME.%(ext)s" "$URL" > /dev/null 2>&1

# Download la desc
yt-dlp --write-description --skip-download -o "$VIDEO_DIR/description" "$URL" > /dev/null 2>&1

# Output 
echo "Video $URL was downloaded."
echo "File path : $VIDEO_DIR/$VIDEO_NAME.mp4"

# Ensure log directory exists
if [ ! -d "$(dirname "$LOG_FILE")" ]; then
    echo "Log directory $(dirname "$LOG_FILE") does not exist. Exiting."
    exit 1
fi

# Write log
echo "[$(date '+%y/%m/%d %H:%M:%S')] Video $URL was downloaded. File path : $VIDEO_DIR/$VIDEO_NAME.mp4" >> "$LOG_FILE"
```
```bash
sudo chmod +x yt.sh
sudo mkdir -p /opt/yt/downloads
sudo mkdir -p /var/log/yt
sudo ./yt.sh https://www.youtube.com/watch?v=wPOF5FgG3DU
  Video https://www.youtube.com/watch?v=wPOF5FgG3DU was downloaded.
  File path : /opt/yt/downloads//.mp4
```

### B. Rendu attendu

🌞 **Vous fournirez dans le compte-rendu :**

- le script `yt.sh` dans le dépôt git
- un exemple d'exécution
  - genre tu le lances, et tu copie/colles le résultats dans le compte-rendu
- un `cat /var/log/yt/download.log`
  - pour que je vois quelques lignes de logss
  - tieng cado
  cat /var/log/yt/download.log
[24/12/16 15:17:01] Video https://www.youtube.com/watch?v=wPOF5FgG3DU was downloaded. File path : /opt/yt/downloads//.mp4

## 2. MAKE IT A SERVICE

### A. Adaptation du script

YES. Yet again. **On va en faire un *service*.**

L'idée :

➜ plutôt que d'appeler la commande à la main quand on veut télécharger une vidéo, **on va créer un service qui les téléchargera pour nous**

➜ **le service s'exécute en permanence en tâche de fond**

- il surveille un fichier précis
- s'il trouve une nouvelle ligne dans le fichier, il vérifie que c'est bien une URL de vidéo youtube
  - si oui, il la télécharge, puis enlève la ligne
  - sinon, il enlève juste la ligne

➜ **qui écrit dans le fichier pour ajouter des URLs ? Bah vous !**

- vous pouvez écrire une liste d'URL, une par ligne, et le service devra les télécharger une par une

---

Pour ça, procédez par étape :

- **partez de votre script précédent** (gardez une copie propre du premier script, qui doit être livré dans le dépôt git)
  - le nouveau script s'appellera `yt-next-gen.sh` xd
  ```bash
  sudo nano /opt/yt/yt-next-gen.sh
  ```
  - vous le stockerez aussi dans `/opt/yt/`
   sudo chmod +x /opt/yt/yt-next-gen.sh
- **adaptez-le pour qu'il lise les URL dans un fichier** plutôt qu'en argument sur la ligne de commande
- le script comporte une boucle qui :
  - lit un fichier ligne par ligne (chaque ligne contient une URL de vidéo youtube)
  - il télécharge la vidéo à l'URL indiquée
- une fois le fichier vide, le script se termine
sudo mkdir -p /opt/yt/downloads

sudo touch /opt/yt/urls.txt
sudo mkdir -p /var/log/yt
sudo touch /var/log/yt/download.log
sudo useradd -r -s /bin/false yt
sudo chown -R yt:yt /opt/yt
sudo chown -R yt:yt /var/log/ytq

### B. Le service

➜ **une fois que tout ça fonctionne, enfin, créez un service** qui lance votre script :

- créez un fichier `/etc/systemd/system/yt.service`. Il comporte :

```bash
sudo nano /etc/systemd/system/yt.service
```

  - une brève description
  - un `ExecStart` pour indiquer que ce service sert à lancer votre script
  - une clause `User=` pour indiquer que c'est l'utilisateur `yt` qui lance le script
    - créez l'utilisateur s'il n'existe pas
    - faites en sorte que le dossier `/opt/yt` et tout son contenu lui appartienne
    - le dossier de log doit lui appartenir aussi
    - l'utilisateur `yt` ne doit pas pouvoir se connecter sur la machine

```bash
[Unit]
Description=<Votre description>

[Service]
Type=oneshot
ExecStart=<Votre script>
User=yt

[Install]
WantedBy=multi-user.target
```

> Pour rappel, après la moindre modification dans le dossier `/etc/systemd/system/`, vous devez exécuter la commande `sudo systemctl daemon-reload` pour dire au système de lire les changements qu'on a effectué.

Vous pourrez alors interagir avec votre service à l'aide des commandes habituelles `systemctl` :

- `systemctl status yt`
- `sudo systemctl start yt`
- `sudo systemctl stop yt`
udo systemctl status yt
Failed to find catalog entry: Invalid argument
● yt.service - YouTube Video Downloader Service
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; preset: disa>
     Active: active (running) since Mon 2024-12-16 15:56:11 CET; 8s ago
   Main PID: 1697 (yt-next-gen.sh)
      Tasks: 2 (limit: 11083)
     Memory: 612.0K
        CPU: 13ms
     CGroup: /system.slice/yt.service
             ├─1697 /bin/bash /opt/yt/yt-next-gen.sh
             └─1700 sleep 10


![Now witness](./img/now_witness.png)

### C. Rendu attendu

🌞 **Toutes les commandes que vous utilisez**

- pour gérer les permissions du dossier `/opt/yt` par exemple

```bash
sudo mkdir -p /opt/yt/downloads
sudo touch /opt/yt/urls.txt
sudo mkdir -p /var/log/yt
sudo touch /var/log/yt/download.log
sudo nano /opt/yt/yt-next-gen.sh
sudo chmod +x /opt/yt/yt-next-gen.sh
sudo useradd -r -s /bin/false yt
sudo chown -R yt:yt /opt/yt
sudo chown -R yt:yt /var/log/yt
sudo nano /etc/systemd/system/yt.service
sudo systemctl daemon-reload
sudo systemctl start yt
sudo systemctl status yt
sudo systemctl enable yt
sudo systemctl stop yt
sudo journalctl -u yt
```

🌞 **Le script `yt-next-gen.sh` dans le dépôt git**

🌞 **Le fichier `yt.service` dans le dépôt git**
