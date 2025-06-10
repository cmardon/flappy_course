# Cours : Création d'un Flappy Bird avec Godot

## Introduction
- Présentation de Godot et de ses fonctionnalités
- Objectif du cours : créer un jeu Flappy Bird

## Récupération du projet

### Cours : Introduction à Godot
- Présentation de l'interface de Godot
- Explication des projets et des scènes

### TP : Récupération du projet
| Étape | Description |
|-------|-------------|
| 1 | Aller récupérer le projet vide à l’adresse suivante : https://github.com/cmardon/flappy_course |
| 2 | Dézippe le fichier (si téléchargé en .zip) |
| 3 | Ouvrir Godot 4.4.x et importer le projet |

### Pause : Questions/Réponses
- Vérifier que tout le monde a réussi à importer le projet
- Répondre aux questions éventuelles

## Création du joueur

### Cours : Les bases de Godot
- Explication des noeuds et des scènes
- Introduction aux scripts GDScript
- Notions de base sur les inputs

### TP : Création du joueur
| Étape | Description |
|-------|-------------|
| 1 | Dans `src/`, créer une nouvelle scène nommée « joueur » avec comme noeud de base « CharacterBody2D » |
| 2 | Dans la scène, ajouter un sprite 2D |
| 3 | Attacher une texture : Sélectionner une texture dans « Sunny Land Collection Files/Assets/Characters/Enemies and NPC/ » |
| 4 | Ajouter un script au joueur et y coller le code de chute libre |
```gdscript
extends CharacterBody2D

var gravity = 1000
var jump_strength = -600

func _process(delta):
    velocity.y += gravity * delta
    move_and_slide()
```
| Étape | Description |
|-------|-------------|
| 5 | Tester avec F6 |
| 6 | Modifier `_process` pour y inclure le saut |
```gdscript
func _process(delta):
    velocity.y += gravity * delta
    if Input.is_action_just_pressed("ui_accept"):
        velocity.y = jump_strength
    move_and_slide()
```
| Étape | Description |
|-------|-------------|
| 7 | Tester avec F6 |

### Pause : Questions/Réponses
- Vérifier que tout le monde a réussi à créer le joueur
- Répondre aux questions éventuelles

## Création du niveau

### Cours : Les scènes et les noeuds
- Explication des scènes et des noeuds
- Introduction à la manipulation des objets dans une scène
- Inspecteur

### TP : Création du niveau
| Étape | Description |
|-------|-------------|
| 1 | Dans `src/`, créer une nouvelle scène 2D nommée « niveau1 » |
| 2 | Glisser `joueur.tscn` au milieu de la scène `niveau1` et changer sa « scale » dans l'inspecteur en x:2 et y:2 |
| 3 |  Tester avec F5 en sélectionnant la scène actuelle comme scène principale |

## Découverte de la scène tuyau.tscn

### Explications
- Scène préfaite avec option dynamiques

### TP : Découverte de la scène tuyau.tscn
| Étape | Description |
|-------|-------------|
| 1 | Ouvrir la scène `src/tuyau.tscn` |

### Pause : Questions/Réponses
- Vérifier que tout le monde a réussi à ouvrir la scène tuyau
- Répondre aux questions éventuelles

## Ajout de spawner à tuyau

### Cours : Les Timers et les Signaux
- Explication des Timers et de leur utilisation
- Introduction aux signaux et à leur connexion

### TP : Ajout de spawner à tuyau
| Étape | Description |
|-------|-------------|
| 1 | Aller dans la scène « niveau1 » |
| 2 | Ajouter un noeud 2D nommé « generateur_tuyau » |
| 3 | Déplacer le noeud à droite de l’écran avec l'outil de déplacement |
| 4 | Ajouter un Timer et activer « autostart » |
| 5 | Attacher un script au générateur et coller le code fourni |
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
| Étape | Description |
|-------|-------------|
| 6 | Connecter le signal `timeout` du Timer en cliquant sur le Timer puis dans l'inspecteur, cliquer sur Noeud > timeout() > connecter > generateur tuyau > connecter |
| 7 | Modifier le timer pour changer la vitesse d’apparition |
| 8 | Ajuster la taille du générateur à 2 (dans l'inspecteur, scale x:2 y:2)|

- Tester avec F5

## Ajout des collisions joueur

### Cours : Les Collisions
- Explication des CollisionShape2D
- Introduction aux différentes formes de collisions

### TP : Ajout des collisions joueur
| Étape | Description |
|-------|-------------|
| 1 | Aller sur la scène « Joueur » et ajouter un « CollisionShape2D » |
| 2 | Dans l’inspecteur, cliquer sur ```Shape : <vide>``` pour sélectionner CircleShape2D |
| 3 | Adapter la taille de la boîte de collision pour qu'elle recouvre globalement le joueur |

### Pause : Questions/Réponses
- Vérifier que tout le monde a réussi à ajouter les collisions
- Répondre aux questions éventuelles

## Ajout de collision tuyaux

### Cours : Les StaticBody2D et les CollisionShape2D
- Explication des StaticBody2D et des CollisionShape2D (leur rôle)
- Introduction aux différentes manières de gérer les collisions

### TP : Ajout de collision tuyaux
| Étape | Description |
|-------|-------------|
| 1 | Aller sur la scène « Tuyau » et sélectionner `tuyau_haut` |
| 2 | Ajouter un noeud « StaticBody2D » |
| 3 | Ajouter une « CollisionShape2D » au « StaticBody2D » |
| 4 | Placer la boîte de collision au bon endroit en l’adaptant à la forme du tuyau du haut |
| 5 | Recommencer la même manipulation sur le tuyau du bas |

## Ajout de détection tuyaux

### Cours : Les Area2D et les Signaux
- Explication des Area2D et de leur utilisation (son rôle)
- Introduction aux signaux et à leur connexion

### TP : Ajout de détection tuyaux
| Étape | Description |
|-------|-------------|
| 1 | Remplacer les StaticBody2D par des « Area2D » |

Faisable en recommençant les étapes de la partie précédente, mais avec une Area2D plutôt qu'un StaticBody2D :
| Étape | Description |
|-------|-------------|
| 1 | Aller sur la scène « Tuyau » et sélectionner `tuyau_haut` |
| 2 | Ajouter un noeud « Area2D » et une « CollisionShape2D » |
| 3 | Placer la boîte de collision au bon endroit en l’adaptant à la forme du tuyau du haut |
| 4 | Recommencer la même manipulation sur le tuyau du bas |
| 5 | Sélectionner une Area2D puis dans l’inspecteur, cliquer sur l’onglet « Noeud » et double cliquer sur « body_entered » puis connecter. Enfin, remplacer « pass » par le code fourni |
```gdscript
if body is CharacterBody2D:
    get_tree().change_scene_to_file("res://src/niveau1.tscn")
```
- Tester avec F5
