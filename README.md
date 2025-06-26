# Cours : Création d'un Flappy Bird avec Godot

## Introduction
- Présentation de Godot et de ses fonctionnalités
- Objectif du cours : créer un jeu Flappy Bird
---
## Récupération du projet

| Étape | Description |
|-------|-------------|
| 1 | Récupérer le projet sur le PC en ouvrant un terminal en appuyant simultanément sur les touches `Ctrl` `Alt` et `T` |
| 2 | Écrire (ou copier-coller) la commande suivante dans le terminal : `git clone https://github.com/cmardon/flappy_course` (Attention, Ctrl+V ne fonctionne pas dans un terminal ! Utiliser Clic Droit puis Coller)|
| 3 | Ouvrir Godot 4.4.x avec la commande suivante dans le terminal : `flatpak run org.godotengine.Godot`|
| 4 | Une fois Godot ouvert, scanner le projet en cliquant sur le bouton `Importer`, sélectionner le dossier `flappy_course` et double cliquer sur `project.godot` et valider en cliquant sur `importer`|

---
## Création du joueur

Voici à quoi ressemble un assemblage de noeuds (pour ici former le joueur), utiliser cette image pour comparer peut être pratique ;)
![Noeuds joueur](https://github.com/cmardon/flappy_course/blob/main/.images_consignes/arbo_joueur.png)

| Étape | Description |
|-------|-------------|
| 1 | Créer une nouvelle scène `joueur`. (dans le `Système de fichiers` en bas à gauche, faire Clic Droit sur le dossier `src` et sélectionner `Créer Nouveau` puis `Scène`. Saisir "joueur" comme `Nom de la scène` puis cliquer `OK`)|
| 2 | Dans cette scène, ajouter un noeud `CharacterBody2D` (Clic Droit sur le noeud `Joueur`, puis `Ajouter un noeud enfant` et chercher `CharacterBody2D` dans la barre de recherche) |
| 3 | Dans la scène, ajouter un noeud `Sprite2D` **Sur le noeud CharacterBody2D** |
| 4 | Attacher une texture : Sélectionner une texture de personnage dans le dossier `Sunny Land Collection Files/Assets/Characters/`. Une fois le personnage choisi, cliquer sur le noeud `Sprite2D` et glisser la texture dans l'onglet `Texture : <vide>` |
| 5 | Ajouter un script au `CharacterBody2D` (avec Clic Droit sur `CharacterBody2D`, `attacher un script`, `créer`) et y coller le code suivant |
```gdscript
extends CharacterBody2D

var gravity = 1000
var jump_strength = 600

func _process(delta):
    velocity.y += gravity * delta
    move_and_slide()
```
- Tester avec F6 (Le personnage est censé tomber dans le vide à gauche de l'écran)

| Étape | Description |
|-------|-------------|
| 6 | Réouvrir le script et modifier la fonction `_process` pour y inclure un saut à l'appui de la touche `Espace` |
```gdscript
func _process(delta):
    velocity.y += gravity * delta
    if Input.is_action_just_pressed("ui_accept"):
        velocity.y = -jump_strength
    move_and_slide()
```

- Tester avec F6 (Le personnage tombe et remonte quand on appuit sur `Espace`)

---
## Création du niveau

| Étape | Description |
|-------|-------------|
| 1 | Dans `src/`, créer une nouvelle scène nommée `niveau1` (sans espace ni majuscule) |
| 2 | Glisser `joueur.tscn` au milieu de la scène `niveau1` et changer sa taille modifiant le paramètre `scale` dans l'inspecteur (Cliquer sur le noeud `joueur`, puis dans l'inspecteur développer la section `Tranform` et modifier les valeurs de `Scale`) |
| 3 | Dans le `Système de fichiers`, faire Clic Droit sur `niveau1.tscn` et sélectionner `Définir comme scène principale` (Appuyer sur `F5` permet maintenant de lancer le jeu)|
| 4 | Tester avec F5 (Encore un fois, le personnage tombe et remonte quand on appuit sur `Espace` mais au milieu de l'écran cette fois-ci) |

---
## Ajout de spawner à tuyau

| Étape | Description |
|-------|-------------|
| 1 | Aller dans la scène ` niveau1 ` |
| 2 | Ajouter un noeud de type `Node2D` nommé `generateur_tuyau`, comme son nom l'indique, ce noeud servira à faire apparaître les tuyaux |
| 3 | Déplacer le générateur à droite dans la fenêtre principale ![Déplacement du générateur](https://github.com/cmardon/flappy_course/blob/main/.images_consignes/generateur_a_droite.png)|
| 4 | Attacher un script au `generateur_tuyau` et y coller le code fourni |
```gdscript
extends Node2D

@onready var scene_tuyau = preload("res://src/tuyau.tscn")

func _ready():
    generer_tuyau()

func _on_timer_timeout():
    generer_tuyau()

func generer_tuyau():
    var pipe = scene_tuyau.instantiate()
    add_child(pipe)
```
- Tester avec F5 : Un tuyau devrait apparaître et partir vers la gauche.

| Étape | Description |
|-------|-------------|
| 5 | Ajouter un noeud `Timer` et activer `autostart` dans l'inspecteur |
| 6 | Connecter le signal `timeout` du Timer en cliquant sur le Timer puis dans l'inspecteur, cliquer sur `Noeud > timeout() > connecter > generateur tuyau > connecter` |

- Tester avec F5 : Plusieurs tuyaux devraient apparaître. Modifier le timer pour changer la vitesse d’apparition (dans l'inspecteur, changer `Wait Time`). Si les tuyaux sont trop petits, modifier la `Scale` du noeud `generateur_tuyau` (Cliquer sur `generateur_tuyau` > Inspecteur > `Transform` > `Scale`).
---
## Ajout des collisions joueur

| Étape | Description |
|-------|-------------|
| 1 | Aller sur la scène ` Joueur ` et ajouter un noeud `CollisionShape2D` |
| 2 | Dans l’inspecteur du noeud `CollisionShape2D`, cliquer sur `Shape : <vide>` pour sélectionner CircleShape2D |
| 3 | Adapter la taille de la boîte de collision pour qu'elle recouvre globalement le joueur |

---
## Ajout de détection tuyaux

| Étape | Description |
|-------|-------------|
| 1 | Aller sur la scène ` Tuyau ` et sélectionner `tuyau_haut` |
| 2 | Y ajouter un noeud ` Area2D ` |
| 3 | Ajouter une ` CollisionShape2D ` au ` Area2D ` et en cliquand sur `Shape: <vide>`, choisir un `RectangleShape2D` |
| 4 | Placer la boîte de collision au bon endroit en l’adaptant à la forme du tuyau du haut |
| 5 | Recommencer la même manipulation sur le tuyau du bas |
| 6 | Sélectionner une Area2D puis dans l’inspecteur, cliquer sur l’onglet ` Noeud ` et double cliquer sur ` body_entered ` puis `connecter`.|
| 7 | Connecter l'autre Area2D de la même manière |

- Tester avec F5, toucher un tuyau doit faire recommencer le niveau
---
## Ajout du fond avec TileMap

| Étape | Description|
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1     | Aller dans la scène `niveau1`|
| 2     | Ajouter un noeud `TileMapLayer`|
| 3     | Sélectionner le `TileMapLayer` ajouté, puis dans l'inspecteur, cliquer sur `Tile Set : <vide>` et choisir `Nouveau TileSet`|
| 4     | Tout en bas de l'éditeur, cliquer sur le bouton **"TileSet"** pour ouvrir l’éditeur de tuiles|
| 5     | Dans le système de fichiers (en bas à gauche de l'écran), rechercher une image de tileset, puis la **glisser dans le rectangle "Tile source"** de l’éditeur TileSet. Puis cliquer sur oui dans la fenêtre qui apparaît|

Exemple de TileSet valide : ![tileset](https://github.com/cmardon/flappy_course/blob/main/Sunny%20Land%20Collection%20Files/Assets/Environments/Day-Platformer/PNG/tileset.png)

| Étape | Description|
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 6     | Tout en bas de l'éditeur, cliquer sur le bouton **"TileMap"** |
| 7     | Sélectionner des blocs de la tilemap et dessiner sur le niveau pour créer un décor|
| 8     | Glisser le noeud `TileMapLayer` au dessus du joueur et du générateur de tuyaux dans l'arborescence à gauche dans l'onglet  `Scène`|
| 9     | Tester les outils de lignes, de zones, ajouter un fond en glissant un png directement sur la scène si besoin |

- Tester avec F5

- Ne pas hésiter à mettre un autre `TileMapLayer` si on veut utiliser deux tileset en même temps (Pour le sol et pour le ciel par exemple)
---
## Effet de rotation du joueur

| Étape | Description                                  |
| ----- | -------------------------------------------- |
| 1     | Aller dans le script du joueur               |
| 2     | Modifier `_process` pour inclure la rotation |

```gdscript
func _process(delta):
    velocity.y += gravity * delta
    if Input.is_action_just_pressed("ui_accept"):
        velocity.y = -jump_strength

    rotation_degrees = clamp(velocity.y * 0.1, -30, 90)
    move_and_slide()
```

- Tester avec F5

---

## Ajout d'effets sonores

### Musique de fond

| Étape | Description                                                                          |
| ----- | ------------------------------------------------------------------------------------ |
| 1     | Dans la scène `niveau1`, ajouter un noeud `AudioStreamPlayer2D` |
| 2     | Aller dans le dossier `SunnyLand Music/` et double cliquer sur une musique pour l'écouter puis choisir une musique |
| 3     | Dans l'inspecteur après avoir cliqué sur l'`AudioStreamPlayer2D` de la scène, glisser la musique dans `Stream : <vide>`|
| 4 | Cocher `Autoplay` pour lancer le son dès le début du niveau|

### Son de saut

| Étape | Description                                                                          |
| ----- | ------------------------------------------------------------------------------------ |
| 1     | Aller dans la scène `joueur`|
| 2     | Ajouter un noeud `AudioStreamPlayer2D` au `CharacterBody2D` et le renommer `son_saut` (sans majuscules) |
| 3     | Aller dans le dossier `sfx/platformer_jumping`|
| 4     | Glisser un son de saut dans le champ `Stream : <vide>` de l'inspecteur du noeud son_saut |
| 5     | Dans le script du joueur, modifier la fonction _process() comme ceci:|

```gdscript
func _process(delta):
    velocity.y += gravity * delta
    if Input.is_action_just_pressed("ui_accept"):
        velocity.y = -jump_strength
        $son_saut.play()

    rotation_degrees = clamp(velocity.y * 0.1, -30, 90)
    move_and_slide()
```

### Son de mort

| Étape | Description                                                                          |
| ----- | ------------------------------------------------------------------------------------ |
| 1     | Aller dans la scène `tuyau`|
| 2     | Ajouter un noeud `AudioStreamPlayer2D` et renomme le `son_mort` (sans majuscules) |
| 3     | Aller dans le dossier `sfx/gameover`|
| 4     | Glisser un son de mort dans le champ `Stream : <vide>` de l'inspecteur du noeud son_mort |
| 5     | Dans le script du tuyau, modifier la fonction _on_area_2d_body_entered() comme ceci:|

```gdscript
func _on_area_2d_body_entered(body: Node2D) -> void:
    if body is CharacterBody2D:
        $son_mort.process_mode = Node.PROCESS_MODE_ALWAYS
        get_tree().paused = true
        $son_mort.play()
        await get_tree().create_timer($son_mort.stream.get_length(), true).timeout
        get_tree().paused = false
        get_tree().change_scene_to_file("res://src/niveau1.tscn")
```

---

## Dynamisation du joueur

| Étape | Description                                               |
| ----- | --------------------------------------------------------- |
| 1     | Aller dans la scène du joueur                             |
| 2     | Ouvrir le script du joueur                                |
| 3     | Remplacer le script par le suivant :                      |

```gdscript
@tool
extends CharacterBody2D

@export var gravity: float = 1000
@export var jump_strength: float = 600
@export var player_scale: Vector2 = Vector2(2, 2)

@export var sprite_texture: Texture2D:
	set(value):
		sprite_texture = value
		if sprite and sprite_texture:
			sprite.texture = sprite_texture

@onready var sprite: Sprite2D = $Sprite2D

func _process(delta):
	scale = player_scale
	if !Engine.is_editor_hint():
		# Exécution normale en jeu
		velocity.y += gravity * delta
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = -jump_strength
			$son_saut.play()
		rotation_degrees = clamp(velocity.y * 0.1, -30, 90)
		move_and_slide()


```

| Étape | Description                                                                                               |
| ----- | --------------------------------------------------------------------------------------------------------- |
| 4     | Retourner dans la scène `niveau1` et cliquer sur `joueur`|
| 5     | Modifier les paramètres du joueur |

- Tester avec F5

### Résultat

Il est possible de modifier :
- La gravité, la force du saut et la taille du joueur (dans le noeud `joueur` de la scène `niveau1` directement)
- Le temps d'apparition des tuyaux (dans le `Timer` du `niveau1`)
- L'écart entre les tuyaux (en hauteur) et leur vitesse (dans la scène `tuyau` en cliquand sur le noeud principal en haut de l'aborescence)
- Le son du niveau (En cliquant sur le `AudioStreamPlayer2D` et en sélectionnant un nouveau son)
- Le décor (avec les TileMapLayer)

# Ressources Godot
## Documentation : 
- [Godot](https://docs.godotengine.org/en/stable/)

## Formations
- [Bases Godot](https://docs.godotengine.org/en/stable/getting_started/step_by_step/index.html)
- [Learning path](https://www.gdquest.com/tutorial/godot/learning-paths/beginner/)
- [Bases GD Script](https://gdquest.github.io/learn-gdscript/)
- [How to make a Video Game - Godot Beginner Tutorial](https://www.youtube.com/watch?v=LOhfqjmasi0)
- [How to Program in Godot](https://www.youtube.com/watch?v=e1zJS31tr88)
- [GDQuest – First Game](https://www.youtube.com/watch?v=GwCiGixlqiU)
- [Tuto projet X.R. Godot](https://www.youtube.com/watch?v=shbHGhkh4NM)
- [Muddy Wolf VR for Godot](https://www.youtube.com/watch?v=fxZoXfX4oBo&list=PLfX6C2dxVyLxXl3gJwakzdqRaV7WKlqFR)
- [JumboGamedev](https://www.youtube.com/@JumboGamedev/videos)
- [Bitlytic](https://www.youtube.com/@Bitlytic)
- [Godot Control Node (UI) Masterclass](https://www.youtube.com/watch?v=5Hog6a0EYa0)

## Chaines Youtube
- [GodotEngine](https://www.youtube.com/@GodotEngineOfficial)
- [StayAtHomeDev](https://www.youtube.com/channel/UCDshKIMtFjYreCzApleuV8w)
- [GDQuest](https://www.youtube.com/c/gdquest)
- [Godotneers](https://www.youtube.com/@godotneers)
- [Lukky](https://www.youtube.com/@lukky./videos (à voir surtout la série everynodes))
- [MrElipteach](https://www.youtube.com/@mrelipteach/videos)
- [Crigz Vs Game Dev](https://www.youtube.com/@crigz/videos)
- [Gwizz](https://www.youtube.com/@Gwizz1027/videos) 
- [FinePointCGI](https://www.youtube.com/@FinePointCGI/videos) 
- [Zenva](https://www.youtube.com/@Zenva/videos) 
- [Bonkahe](https://www.youtube.com/@Bonkahe/videos) 
- [Nad Labs](https://www.youtube.com/@NADLABS/videos)
- [Pixezy](https://www.youtube.com/@pixezy8962/videos)

## Assets
- [Librairie assets Godot](https://godotengine.org/asset-library/asset) 
- [Kenney](https://www.kenney.nl/) 
- [Starter Kit](https://godotengine.org/asset-library/asset?user=Kenney) 
- [Godot Assets Library](https://godotassetlibrary.com/)
- [Datalogue ](https://godotassetlibrary.com/asset/RMiyDF/datalogue)
- [CurveMesh3D](https://godotassetlibrary.com/asset/pGIkY2/curvemesh3d)
- [Draw 3D](https://godotassetlibrary.com/asset/hae3W3/draw3d)
- [Godot Shaders](https://godotshaders.com/ )
- [Godot Jolt](https://github.com/godot-jolt/godot-jolt)
- [Sample Gltf](https://github.com/KhronosGroup/glTF-Sample-Models)

## Général
- [Game UI Data Base](https://www.gameuidatabase.com/index.php)
- [Microsoft Accessibility Guidelines](https://learn.microsoft.com/en-us/gaming/accessibility)
- [GDC Game Developper Conference](https://www.youtube.com/@Gdconf)

## Correction

- [Video correction du TP](https://youtu.be/Ts70zu8c4FA)
