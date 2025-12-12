#!/bin/bash
# entrypoint.sh

# Installation des outils nécessaires si ce n'est pas déjà dans l'image node:20-slim
# Le paquet 'wait-for-it' ou similaire est souvent utilisé, mais nous faisons une boucle simple :

echo "Waiting for PostgreSQL to start..."

# Tentative de connexion à la DB jusqu'à ce que le service soit prêt.
# (Note: cette approche nécessite un client 'psql' si on veut être très précis, 
# mais un simple timeout est souvent suffisant si vous utilisez Docker Compose 'depends_on').

# Si vous voulez l'appliquer dans un conteneur de production :
# Appliquer les migrations EXISTANTES. Ceci est la version Production de 'migrate dev'.
echo "Running Prisma migrations..."
npx prisma migrate deploy --preview-feature 

# Lancer la commande principale (le CMD spécifié dans le Dockerfile)
exec "$@"