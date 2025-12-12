# --- ÉTAPE 1 : BUILDER (Installer les dépendances et générer le client Prisma) ---
FROM node:20 AS builder

# Définir l'environnement de travail
WORKDIR /usr/src/app

# Copier les fichiers de dépendances uniquement
COPY package.json package-lock.json ./

# Installer toutes les dépendances (y compris les devDeps si vous en avez besoin pour le build/test)
RUN npm install

# Copier le reste du code source
COPY . .

# Générer le Client Prisma avec les fichiers binaires pour l'architecture du conteneur.
# C'est CRUCIAL de le faire après le COPY des fichiers pour inclure schema.prisma.
RUN npx prisma generate

# S'assurer que les migrations existent. 
# Pour un conteneur de build, on ne fait QUE générer le client.
# L'étape de migration/push se fera plus tard ou sera gérée par l'étape finale/CI.


# --- ÉTAPE 2 : PRODUCTION (Image finale allégée) ---
# Utiliser une image node plus légère pour la production
FROM node:20-slim

WORKDIR /usr/src/app

# Copier SEULEMENT les dépendances de production depuis l'étape builder
COPY --from=builder /usr/src/app/node_modules ./node_modules

# Copier les fichiers essentiels (code, package.json, main.js, prisma/client, etc.)
COPY --from=builder /usr/src/app/package.json ./package.json
COPY --from=builder /usr/src/app/main.js ./main.js
COPY --from=builder /usr/src/app/prisma ./prisma
COPY --from=builder /usr/src/app/.env ./.env
COPY --from=builder /usr/src/app/public ./public
COPY --from=builder /usr/src/app/views ./views


# Définir le port
EXPOSE 3042

# Ajout d'un script d'entrée pour gérer la dépendance à la base de données
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Commande de démarrage de l'application
CMD ["node", "main.js"]