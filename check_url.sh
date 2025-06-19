#!/bin/bash

while read -r url; do
    echo "Checking $url ..."
    
    # Récupérer juste le code HTTP sans suivre la redirection
    http_code=$(curl -o /dev/null -s -w "%{http_code}" "$url")
    
    if [[ "$http_code" != "200" ]]; then
        echo "[KO] $url (HTTP status: $http_code)"
        continue
    fi
    
    # Si code 200, on récupère le contenu partiel (1k octets max)
    content=$(curl -s --max-filesize 1024 "$url")
    
    # Chercher mots d'erreur typiques (insensible à la casse)
    if echo "$content" | grep -qiE "404|not found|error|forbidden|unauthorized|page not found"; then
        echo "[KO] $url (Content error detected)"
    else
        echo "[OK] $url"
    fi
    
done < /home/saikozx/urls
