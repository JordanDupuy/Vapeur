-- CreateTable
CREATE TABLE "Genre" (
    "id_genre" SERIAL NOT NULL,
    "genre" TEXT NOT NULL,

    CONSTRAINT "Genre_pkey" PRIMARY KEY ("id_genre")
);

-- CreateTable
CREATE TABLE "Editors" (
    "id_editor" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Editors_pkey" PRIMARY KEY ("id_editor")
);

-- CreateTable
CREATE TABLE "Games" (
    "id_game" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "desc" TEXT NOT NULL,
    "releaseDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "editorId" INTEGER NOT NULL,
    "genreId" INTEGER NOT NULL,
    "featured" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Games_pkey" PRIMARY KEY ("id_game")
);

-- CreateIndex
CREATE UNIQUE INDEX "Genre_genre_key" ON "Genre"("genre");

-- AddForeignKey
ALTER TABLE "Games" ADD CONSTRAINT "Games_editorId_fkey" FOREIGN KEY ("editorId") REFERENCES "Editors"("id_editor") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Games" ADD CONSTRAINT "Games_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "Genre"("id_genre") ON DELETE CASCADE ON UPDATE CASCADE;
