# projet-cr8

> Groupe 4 - Netbox / Inventaire des ressources IUT
> CAMPANELLA Enzo
> PASCAL Thomas
> ROLAND Louis

![](https://i.imgur.com/CZLG9De.png)

## Liste des VLANs de l'IUT

- D'après le mail de Monsieur Pouchoulon, il y a dans l'IUT 1 réseau virtuel par salle.
- Nous savons qu'il y a environ 15 salles au 2ème étage (bâtiment B,C et D côté FabLab)
- Ainsi nous en déduisons que le premier étage devrait en avoir un peu moins puisqu'il n'y a pas de salle de classe/TP au bâtiment B de cet étage. On va dire qu'il y a 12 salles de classe
- Concernant le RDC, nous devrons avoir une quinzaine de salles de classe

### Tableau récapitulatif RDC

| Etage | Salle | VLAN ID  |
| ----- | ----- | -------- |
| RDC   | 001   | VLAN 001 |
| RDC   | 002   | VLAN 002 |
| RDC   | 003   | VLAN 003 |
| RDC   | 004   | VLAN 004 |
| RDC   | 005   | VLAN 005 |
| RDC   | 006   | VLAN 006 |
| RDC   | 007   | VLAN 007 |
| RDC   | 008   | VLAN 008 |
| RDC   | 009   | VLAN 009 |
| RDC   | 010   | VLAN 010 |
| RDC   | 011   | VLAN 011 |
| RDC   | 012   | VLAN 012 |
| RDC   | 013   | VLAN 013 |
| RDC   | 014   | VLAN 014 |
| RDC   | 015   | VLAN 015 |

### Tableau récapitulatif 1er étage

| Etage | Salle | VLAN ID  |
| ----- | ----- | -------- |
| 1     | 101   | VLAN 101 |
| 1     | 102   | VLAN 102 |
| 1     | 103   | VLAN 103 |
| 1     | 104   | VLAN 104 |
| 1     | 105   | VLAN 105 |
| 1     | 106   | VLAN 106 |
| 1     | 107   | VLAN 107 |
| 1     | 108   | VLAN 108 |
| 1     | 109   | VLAN 109 |
| 1     | 110   | VLAN 110 |
| 1     | 111   | VLAN 111 |
| 1     | 112   | VLAN 112 |


### Tableau récapitulatif 2eme étage

| Etage | Salle | VLAN ID  |
| ----- | ----- | -------- |
| 2     | 201   | VLAN 201 |
| 2     | 202   | VLAN 202 |
| 2     | 203   | VLAN 203 |
| 2     | 204   | VLAN 204 |
| 2     | 205   | VLAN 205 |
| 2     | 206   | VLAN 206 |
| 2     | 207   | VLAN 207 |
| 2     | 208   | VLAN 208 |
| 2     | 209   | VLAN 209 |
| 2     | 210   | VLAN 210 |
| 2     | 211   | VLAN 211 |
| 2     | 212   | VLAN 212 |
| 2     | 213   | VLAN 213 |
| 2     | 214   | VLAN 214 |
| 2     | 215   | VLAN 215 |

## Création d'une région pour le site de l'IUT

Le but est de mettre le site de l'IUT dans une région spécifique pour mieux se retrouver, que ce soit géographiquement parlant ou pour Netbox.

Voici une arborescence simplifiée :

- Région France
    - Région Occitanie
        - Département Hérault
            - -> Site IUT Béziers

![](https://i.imgur.com/vAimVSR.png)

Maintenant on a plus qu'à ajouter notre site IUT Béziers au département Hérault, qui est fils du parent du département, qui est lui fils du parent du pays.

![](https://i.imgur.com/iEO1Scx.png)

![](https://i.imgur.com/aq3z3gp.png)


## Création de groupe de VLANs dans Netbox

Ici nous allons créer tout des groupes (1 groupe par étage) pour mieux organiser les VLANs par la suite

![](https://i.imgur.com/1FNIot3.png)

- Création du grp VLAN etage0

![](https://i.imgur.com/RUuDOG0.png)

- Création du grp VLAN etage1

![](https://i.imgur.com/r6aTneK.png)

- Création du grp VLAN etage2

![](https://i.imgur.com/YjQuFJW.png)

- Tous les groupes sont désormais crées !

![](https://i.imgur.com/rNy4ae3.png)

- On peut aussi visualiser les groupes VLANs grâce à l'API de Netbox

```
# curl -X GET -s https://netbox.lroland.fr/api/ipam/vlan-groups/ -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" -H "Content-Type: application/json" -H "Accept: application/json; indent=4" | jq '.'
{
  "count": 3,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/1/",
      "name": "etage0",
      "slug": "etage0",
      "site": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
        "name": "IUT Beziers",
        "slug": "iut-beziers"
      },
      "description": "RDC IUT",
      "vlan_count": 0
    },
    {
      "id": 2,
      "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/2/",
      "name": "etage1",
      "slug": "etage1",
      "site": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
        "name": "IUT Beziers",
        "slug": "iut-beziers"
      },
      "description": "1er étage IUT",
      "vlan_count": 0
    },
    {
      "id": 3,
      "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/3/",
      "name": "etage2",
      "slug": "etage2",
      "site": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
        "name": "IUT Beziers",
        "slug": "iut-beziers"
      },
      "description": "2eme étage IUT",
      "vlan_count": 0
    }
  ]
}
```

## Création de VLANs dans Netbox

Nous souhaitons créer le VLAN 001 de la première salle de l'IUT.

- Tout d'abord nous nous rendons dans le menu VLANs de l'onglet IPAM

![](https://i.imgur.com/zE9yaal.png)

- Nous allons par la suite indiquer un ID, un nom, une description, une région, une site puis un groupe d'appartenance

![](https://i.imgur.com/PheZlFz.png)

- On constate que la création VLAN s'est bien faite

![](https://i.imgur.com/YK28cnv.png)

- Nous pouvons aussi vérifier le contenu du VLAN crée avec le système d'API par commande

```
# curl -X GET -s https://netbox.lroland.fr/api/ipam/vlans/ -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" -H "Content-Type: application/json" -H "Accept: application/json; indent=4" | jq '.'
{
  "count": 1,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 2,
      "url": "https://netbox.lroland.fr/api/ipam/vlans/2/",
      "site": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
        "name": "IUT Beziers",
        "slug": "iut-beziers"
      },
      "group": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/1/",
        "name": "etage0",
        "slug": "etage0"
      },
      "vid": 1,
      "name": "001",
      "tenant": null,
      "status": {
        "value": "active",
        "label": "Active"
      },
      "role": null,
      "description": "Salle 001 RDC",
      "tags": [],
      "display_name": "001 (1)",
      "custom_fields": {},
      "created": "2021-05-12",
      "last_updated": "2021-05-12T11:00:10.132108Z",
      "prefix_count": 0
    }
  ]
}
```

## Utilisation des API pour créer des VLANs

### Création d'un groupe de VLAN en API

- Commande pour créer un groupe de VLAN

```
# curl -X POST https://netbox.lroland.fr/api/ipam/vlan-groups/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
--data '{
	"name": "test", 
	"slug": "test", 
	"site": 1, 
	"description": "created with api"
}'
```

- Retour de commande 

```
{
    "id": 4,
    "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/4/",
    "name": "test",
    "slug": "test",
    "site": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
        "name": "IUT Beziers",
        "slug": "iut-beziers"
    },
    "description": "created with api"
}
```

- Vérification sur Netbox

![](https://i.imgur.com/FJlPIh8.png)

![](https://i.imgur.com/GZk9xi0.png)

### Création d'un VLAN en API

- Commande pour créer un VLAN

```
# curl -X POST https://netbox.lroland.fr/api/ipam/vlans/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
--data '{
    "site": 1, 
    "vid": "002", 
    "name": "002", 
    "group": 1, 
    "description": "Salle 002 RDC"
}'
```

- Retour de commande

```
{
    "id": 3,
    "url": "https://netbox.lroland.fr/api/ipam/vlans/3/",
    "site": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
        "name": "IUT Beziers",
        "slug": "iut-beziers"
    },
    "group": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/1/",
        "name": "etage0",
        "slug": "etage0"
    },
    "vid": 2,
    "name": "002",
    "tenant": null,
    "status": {
        "value": "active",
        "label": "Active"
    },
    "role": null,
    "description": "Salle 002 RDC",
    "tags": [],
    "display_name": "002 (2)",
    "custom_fields": {},
    "created": "2021-05-12",
    "last_updated": "2021-05-12T11:22:24.291136Z"
}
```

- Vérification sur Netbox

![](https://i.imgur.com/yqkMQB7.png)

![](https://i.imgur.com/1rieXrb.png)


## Script manipulation de groupes VLAN

### Lancement du script

- Nous pouvons constater la présence des différents groupes de VLAN avec leur ID.
- Par la suite nous avons le choix entre plusieurs requêtes HTTP

```
# ./groupVLAN.sh 
[Group name, Group ID] : 
[ "etage0", 1 ] [ "etage1", 2 ] [ "etage2", 3 ]

HTTP REQUEST : GET - POST - PATCH - DELETE
GET - Retrieve an object or list of objects
POST - Create an object
PATCH - Modify an existing object
DELETE - Delete an existing object
```

### Choix de la requête GET

Va afficher de manière détaillée tous les groupes de VLANs présents.

```
GET

{
  "count": 3,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
	...
    },
    {
      "id": 2,
	...
    },
    {
      "id": 3,
	...
    }
  ]
}
```

### Choix de la requête POST

Va créer un groupe de VLAN en fonction de plusieurs paramètres qui dépendent de l'utilisateur.

```
POST

Group name? toto

Group slug? toto

Group site? 1

Group description? toto

{
    "id": 7,
    "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/7/",
    "name": "toto",
    "slug": "toto",
    "site": {
        "id": 1,
        "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
        "name": "IUT Beziers",
        "slug": "iut-beziers"
    },
    "description": "toto"
}
```

- Vérification sur le changelog de Netbox

![](https://i.imgur.com/FNQ5HiO.png)


### Choix de la requête PATCH

Va permettre de modifier des informations d'un ou plusieurs groupe(s) de VLAN tel que le nom, le site ou encore la description.

```
PATCH

Insert number of IDs : 1
Insert ID : 7

Type here what to modify (name, slug, site, about) : name

Type here the new name : tata

{
  "id": 7,
  "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/7/",
  "name": "tata",
  "slug": "toto",
  "site": {
    "id": 1,
    "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
    "name": "IUT Beziers",
    "slug": "iut-beziers"
  },
  "description": "toto",
  "vlan_count": 0
}
```

- Vérification sur le changelog de Netbox

![](https://i.imgur.com/GrmyAWe.png)


### Choix de la requête DELETE

Va permettre de supprimer un ou plusieurs groupe(s) de VLAN.

```
DELETE

Insert number of IDs : 1

ID : 7
Removed
```

- Vérification sur le changelog de Netbox

![](https://i.imgur.com/B22rL1I.png)


## Script création de VLANs

### Lancement du script

- Nous pouvons constater la présence des différents VLAN avec leur ID.
- Par la suite nous avons le choix entre plusieurs requêtes HTTP

```
# ./vlan.sh 
[VLAN name, VLAN ID] : 
[ "001", 2 ] [ "002", 3 ]

HTTP REQUEST : GET - POST - PATCH - DELETE
GET - Retrieve an object or list of objects
POST - Create an object
PATCH - Modify an existing object
DELETE - Delete an existing object
```

### Choix de la requête GET
Va afficher de manière détaillée tous les VLANs présents sur Netbox.

```
GET

{
  "count": 2,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 2,
      ...
    },
    {
      "id": 3,
      ...
    }
  ]
}
```

### Choix de la requête POST

Va créer un ou plusieurs VLAN(s) en fonction de plusieurs paramètres qui dépendent de l'utilisateur comme la plage, le groupe d'apprtenance ou encore le site.

- Création des VLANs du second étage

```
POST

First VLAN number? 201

Last VLAN number? 215

VLAN Group? 3

VLAN Site? 1

{
    "id": 4,
    ...
}{
    "id": 5,
    ...
}{
    "id": 6,
    ...
}{
    "id": 7,
    ...
}{
    "id": 8,
    ...
}{
    "id": 9,
    ...
}{
    "id": 10,
    ...
}{
    "id": 11,
    ...
}{
    "id": 12,
    ...
}{
    "id": 13,
    ...
}{
    "id": 14,
    ...
}{
    "id": 15,
    ...
}{
    "id": 16,
    ...
}{
    "id": 17,
    ...
}{
    "id": 18,
    ...
}
```

- Vérification sur Netbox

![](https://i.imgur.com/TwRSugg.png)


### Choix de la requête PATCH
Va permettre de modifier des informations d'un ou plusieurs VLAN(s) tel que le nom, le groupe, le site ou encore la description.

- Modifiation du VLAN 001

```
PATCH

Insert number of IDs : 1
Insert ID : 2

Type here what to modify (name, group, site, about) : about

Type here the new description : VLAN_002

{
  "id": 2,
  "url": "https://netbox.lroland.fr/api/ipam/vlans/2/",
  "site": {
    "id": 1,
    "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
    "name": "IUT Beziers",
    "slug": "iut-beziers"
  },
  "group": {
    "id": 1,
    "url": "https://netbox.lroland.fr/api/ipam/vlan-groups/1/",
    "name": "etage0",
    "slug": "etage0"
  },
  "vid": 1,
  "name": "001",
  "tenant": null,
  "status": {
    "value": "active",
    "label": "Active"
  },
  "role": null,
  "description": "VLAN_002",
  "tags": [],
  "display_name": "001 (1)",
  "custom_fields": {},
  "created": "2021-05-12",
  "last_updated": "2021-05-17T09:19:10.146572Z",
  "prefix_count": 0
}
```

- Vérification sur Netbox

![](https://i.imgur.com/be9VsdE.png)


### Choix de la requête DELETE
Va permettre de supprimer un ou plusieurs VLAN(s).

- Suppression du VLAN 215

```
DELETE

Insert number of IDs : 1

ID : 18
Removed
```

- Vérification sur Netbox

![](https://i.imgur.com/AQZbs9q.png)

## Liste des VLANs de l'IUT

### VLANs etage0

![](https://i.imgur.com/OMLRMZM.png)

### VLANs etage1

![](https://i.imgur.com/yHecXWe.png)

### VLANs etage2

![](https://i.imgur.com/emKD1W7.png)

## MAJ Documentation

### Sitographie
https://netbox.lroland.fr/api/docs/

### MAJ Gantt

- Compte Rendus
    - cr8
- Netbox VLANs
    - Saisie manuelle VLANs et groupes de VLAN
    - Manipuler groupes de VLAN avec API
    - Manipuler VLANs avec API
    - Script manipulation groupes de VLAN avec API
    - Script manipulation VLANs avec API

![](https://i.imgur.com/GnVOjON.png)

### MAJ Tuleap

![](https://i.imgur.com/5Jxk872.png)


### MAJ Burndown Chart

![](https://i.imgur.com/qUtlEAU.png)
