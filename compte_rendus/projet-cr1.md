# projet-cr1

> Groupe 4 - Netbox / Inventaire des ressources IUT
> CAMPANELLA Enzo
> PASCAL Thomas
> ROLAND Louis

## Compte rendu Roland

### Qu'est ce qu'un projet?

Le but d'un projet est de répondre à des besoins sur une problématique imposée sur quelque chose qui n'a jamais été fait auparavant tout en suivant une méthodologie et 3 paramètres
- La qualité
- Le temps
- L'étendue du projet

![](https://i.imgur.com/PnA4n4v.png)

### Effet tunnel

Effet tunnel : lancer un projet et ne jamais l’arrêter

### Methode Waterfalls

Le Water falls consiste à suivre une succession d'étapes prédéfinies de façon séquentielle, chaque étape menant à la suivante. Il s’agit d’une approche logique et séquentielle qui vise à créer le meilleur produit final possible.

![](https://i.imgur.com/QtPwj01.png)

### Methode Agile

Cette méthode oppose compètement la méthode Waterfalls

Une plus grande implication du client et une meilleure réactivité des équipes face à ses demandes sont au cœur de la méthode Agile. Ce manifeste prône les 4 valeurs fondamentales de la méthodologie :

- L'équipe
- L’application
- La collaboration avec le client
- L’acceptation du changement.

Cependant il existe différentes méthodes Agile : 
- Agile Scrum : des petites équipes auto-organisées se réunissent quotidiennement pendant de courtes périodes et travaillent dans des esprits interactifs
- Lean : met l'accent sur l'élimination des efforts inutiles dans la planification, l'exécution, et la réduction de la charge cognitive du programmeur
- Extreme Programming : aborde les types spécifiques de problèmes de qualité de vie auxquels sont confrontées les équipes de développement logiciel
- Feature-Driven Development : prescrit que le développement de logiciels doit se dérouler selon un modèle global, décomposé, planifié, conçu et construit fonctionnalité par fonctionnalité

Dans la méthode Agile, le Sprint est une période spécifique qui dure d'habitude entre 2 et 4 semaines, au cours de laquelle chaque équipe assume autant de tâches qu'elle estime pouvoir en accomplir

Le backlog est une liste de priorités indiquant toutes les fonctionnalités du logiciel.

Le User story sert de compte rendu des différentes tâches effectuées 

`user role > action > value benefit`

### Méthode Kanban

Ce tableau est utilisé pour faire une "To-Do List" 

| A faire | En cours | Terminé |
| -------- | -------- | -------- |
| X     | X     | X     |


- A faire : étapes à réaliser
- En cours : étapes en cours de réalisation
- Terminé : étapes achevées et terminées
- Test (optionnel) : étapes en cours de test
- Bloqué (optionnel) : étapes bloquées

## Compte rendu Pascal

- Ce projet sera jugé sur le temps, la qualité et l'étendu du projet. Ces 3 critères sont à prendre en compte et à équilibrer.
- Il faut faire un Gant, cela nous permettra de réfléchir / brainstormer  / parler répartition de travail
- Baklog, c'est la liste des taches que l'on doit faire, cela nous permettra de faire le gant.
- On à appris ce qu'était la différence entre la maitrise de l'ouvrage et la maitrise d'oeuvre.
- La maitrise d'ouvrage c'est  la personne qui demande le projet.
- La maitrise d'oeuvre c'est la société de service qui réalise le projet.
- On à aussi appris ce qu'était un  product owner, c'est lui qui décide de l'importance des choses qui vont orienter le projet. Il est en lien direct avec la maitrise d'ouvrage et fait partie de la maitrise d'oeuvre. Il est différent du scrum master qui lui, ppourrait etre aparenter à un chef de projet.

## Compte rendu Campanella

étant donné que je n'ai pas pue être présent ce jeudi 14/01/21 j'ai fait un mini compte-rendue de ce qu'est netbox.

### Qu'est-ce que Netbox ?

NetBox est une application Web "open source" conçue pour aider à gérer et à documenter les réseaux informatiques. Il englobe les aspects suivants de la gestion du réseau:

- gestion des addresses IP (IPAM) : Réseaux et adresses IP, VRF et VLAN
- Rayonnages d'équipement : Organisés par groupe et site
- Appareils : Types d'appareils et où ils sont installés
- Connexions : Connexions réseau, console et alimentation entre les périphériques
- Virtualisation : Machines virtuelles et clusters
- Circuits de données : Circuits et fournisseurs de communications longue distance
- Secrets : Stockage crypté des informations d'identification sensibles

### Qu'est-ce que Netbox ne fait pas ?

Alors que NetBox s'efforce de couvrir de nombreux domaines de la gestion de réseau, la portée de son ensemble de fonctionnalités est nécessairement limitée. Cela garantit que le développement se concentre sur les fonctionnalités de base. De ce fait, il peut être utile de fournir des exemples de fonctionnalités que NetBox ne fournit pas : 


- Surveillance du réseau 
- Serveur dns 
- Serveur RADIUS 
- Gestion de la configuration 
- Gestion des installations 

### Pile d'applications

NetBox est construit sur le framework Django Python et utilise une base de données PostgreSQL. Il fonctionne comme un service WSGI(Web Server Gateway Interface) derrière votre choix de serveur HTTP.

| fonction                          | composant         |
| --------------------------------- | ----------------- |
| service HTTP                      | nginx ou apache   |
| service WSGI                      | gunicorn ou uWSGI |
| application                       | Django/python     |
| base de donnée SQL                | PostgreSQL 9.6+   |
| Mise en file d'attente des tâches | Redis/django-rq   |
| Accès aux appareils en direct     | NAPALM            |

### Installation

https://netbox.readthedocs.io/en/stable/installation/

## A faire pour le prochain cr

- Diagramme de Gantt
- Tableau Kanban (To-Do List) ou Agile
- Burndown Chart
