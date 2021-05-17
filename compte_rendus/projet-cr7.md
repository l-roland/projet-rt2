# projet-cr7

> Groupe 4 - Netbox / Inventaire des ressources IUT
> CAMPANELLA Enzo
> PASCAL Thomas
> ROLAND Louis

## Ajout d'informations à l'aide des APIs

### Commande POST avec curl

On va commencer tout d'abord par ajouter une adresse IP. Prenons comme exemple l'adresse réseau `10.213.0.0/24`. On rajoutera comme option
- L'URL de la page API de Netbox
- Le type de reqûete, ici ce sera POST
- Le Token API qui est une clé permettant de manipuler les informations
- Le type d'application qui sera en JSON

Ainsi nous aurons besoin de renseigner quelques champs obligatoire pour que l'ajout fonctionne
- L'adresse IP en question
- Le type d'assignement (null si rien à indiquer)
- L'identifiant d'assignement (null si rien à indiquer)
- On peut aussi rajouter un descriptif, mais pas obligé

On éxecute alors la commande et voir ce qu'il se passe
```
$ curl -X POST https://netbox.lroland.fr/api/ipam/ip-addresses/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
--data '{
    "address": "10.213.0.0/24",
    "assigned_object_type": null,
    "assigned_object_id": null
}'
```

### Retour de commande 

On constate que la commande s'est bien éxecutée (rien ne s'affiche si la commande n'est pas bonne). Ici, nous avons : 
- Un identifiant qui a le numéro 33
- Une URL pour accéder aux informations de l'@
- Le type d'@IP (IPv4 ici présent)
- Le statut de l'@IP (active, reserved, ...)
- Le rôle
- L'assignement
- L'@ NAT si renseignée
- Une description
- La date de création
- La date de modification
- ...

```
{
    "id": 33,
    "url": "https://netbox.lroland.fr/api/ipam/ip-addresses/33/",
    "family": {
        "value": 4,
        "label": "IPv4"
    },
    "address": "10.213.0.0/24",
    "vrf": null,
    "tenant": null,
    "status": {
        "value": "active",
        "label": "Active"
    },
    "role": null,
    "assigned_object_type": null,
    "assigned_object_id": null,
    "assigned_object": null,
    "nat_inside": null,
    "nat_outside": null,
    "dns_name": "",
    "description": "",
    "tags": [],
    "custom_fields": {},
    "created": "2021-04-13",
    "last_updated": "2021-04-13T12:18:57.991811Z"
}
```

Il n'y a plus qu'à vérifier si l'adresse s'est bien ajoutée à l'interface graphique.

### Vérification sur Netbox

On constate ici que l'adresse s'est bien ajoutée. On ne voit pas beaucoup d'informations car nous avons indiqué le nécessaire lors de l'ajout avec curl.

![](https://i.imgur.com/HA93R9i.png)

![](https://i.imgur.com/FCufnEy.png)


## Modification d'informations à l'aide des APIs

### PUT ou PATCH?
- L'API REST NetBox prend en charge l'utilisation de PUT ou PATCH pour modifier un objet existant.
- PUT demande nécessite que l'utilisateur spécifie une représentation complète de l'objet en cours de modification
- PATCH demande doit inclure uniquement les attributs en cours de mise à jour.
- Dans la plupart des cas, l'**utilisation de PATCH est recommandée**.

### Commande curl avec PATCH

Nous allons donc utiliser l'option PATCH de curl pour modifier notre élement. On conservera les mêmes options qu'avec POST.

Ici nous souhaitons modifier le statut de l'adresse et la mettre en mode "réservé".

On a donc la commande suivante : 

```
$ curl -X PATCH -s https://netbox.lroland.fr/api/ipam/ip-addresses/33/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" -H "Accept: application/json; indent=4" \
--data '{"status": "reserved"}' | jq '.'
```

### Retour de la commande

Ici la commande semble être correcte (comme POST, rien ne s'affiche si erreur).

On constate aussi que le statut a changé, en effet nous sommes passés de "active" à "reserved"

```
{
  "id": 33,
  "url": "https://netbox.lroland.fr/api/ipam/ip-addresses/33/",
  "family": {
    "value": 4,
    "label": "IPv4"
  },
  "address": "10.213.0.0/24",
  "vrf": null,
  "tenant": null,
  "status": {
    "value": "reserved",
    "label": "Reserved"
  },
  "role": null,
  "assigned_object_type": null,
  "assigned_object_id": null,
  "assigned_object": null,
  "nat_inside": null,
  "nat_outside": null,
  "dns_name": "",
  "description": "",
  "tags": [],
  "custom_fields": {},
  "created": "2021-04-13",
  "last_updated": "2021-04-13T12:31:23.280067Z"
}
```

### Vérification sur Netbox

On remarque que le statut a bien changé, ce qui prouve le bon fonctionnement !

![](https://i.imgur.com/C7CN4hT.png)

## Suppression d'information à l'aide des APIs

### Commande curl avec DELETE

Cette fois, nous allons utiliser la méthode DELETE de curl. Nous avons 2 façons différentes de supprimer un élément

- En indiquant l'id de l'adresse dans l'URL de Netbox

```
$ curl -X DELETE -s https://netbox.lroland.fr/api/ipam/ip-addresses/33/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567"
```

- En indiquant l'id de l'adresse dans le champ --data

```
$ curl -X DELETE -s https://netbox.lroland.fr/api/ipam/ip-addresses/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
--data '[{"id": 33}]'
```

Lors de l'éxecution de la commande, rien ne se passe, ce qui est normal. Vérifions tout de même sur Netbox en actualisant la page.

### Vérification sur Netbox

Nous avons une erreur disant que la page n'a pas été trouvée. **CQFD**

![](https://i.imgur.com/aQ3nLMv.png)

### Vérification avec curl

On peut tout de même vérifier la suppression avec la méthode GET de curl

```
$ curl -X GET -s https://netbox.lroland.fr/api/ipam/ip-addresses/33/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" | jq '.'
{
  "detail": "Not found."
}
```

Nous avons en retour de commande Not found. **CQFD** 

## Manipulation de plusieurs éléments à l'aide des APIs

### Mise en situation

Dans ce cas nous souhaitons ajouter les 16 PCs présents dans la salle réseau C213 qui sont dédiés aux élèves. Pour rappel l'adressage est le suivant : 

```
10.SALLE.MACHINE.1/24
-> 10.213.1.1/24 pour le premier PC
```

Ainsi voici le plan d'adressage de la salle C213 : 

| Numéro machine | @réseau      | @IP |
| -------------- | ------------- | --- |
| 1              | 10.213.1.0/24 |10.213.1.1/24 |
| 2              | 10.213.2.0/24 |10.213.2.1/24 |
| 3              | 10.213.3.0/24 |10.213.3.1/24 |
| 4              | 10.213.4.0/24 |10.213.4.1/24 |
| 5              | 10.213.5.0/24 |10.213.5.1/24 |
| 6              | 10.213.6.0/24 |10.213.6.1/24 |
| 7              | 10.213.7.0/24 |10.213.7.1/24 |
| 8              | 10.213.8.0/24 |10.213.8.1/24 |
| 9              | 10.213.9.0/24 |10.213.9.1/24 |
| 10             | 10.213.10.0/24 |10.213.10.1/24 |
| 11             | 10.213.11.0/24 |10.213.11.1/24 |
| 12             | 10.213.12.0/24 |10.213.12.1/24 |
| 13             | 10.213.13.0/24 |10.213.13.1/24 |
| 14             | 10.213.14.0/24 |10.213.14.1/24 |
| 15             | 10.213.15.0/24 |10.213.15.1/24 |
| 16             | 10.213.16.0/24 |10.213.16.1/24 |

### Commande ```curl POST``` pour ajouter les règles

Nous allons donc utiliser l'option POST de curl, la commande est assez longue puisqu'il faut indiquer les infos de la totalité des PCs mais elle permettra d'ajouter les IPs des 16 machines dans Netbox

```
# curl -X POST -s https://netbox.lroland.fr/api/ipam/ip-addresses/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
--data '[
{"address": "10.213.1.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC1"},
{"address": "10.213.2.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC2"},
{"address": "10.213.3.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC3"},
{"address": "10.213.4.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC4"},
{"address": "10.213.5.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC5"},
{"address": "10.213.6.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC6"},
{"address": "10.213.7.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC7"},
{"address": "10.213.8.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC8"},
{"address": "10.213.9.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC9"},
{"address": "10.213.10.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC10"},
{"address": "10.213.11.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC11"},
{"address": "10.213.12.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC12"},
{"address": "10.213.13.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC13"},
{"address": "10.213.14.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC14"},
{"address": "10.213.15.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC15"},
{"address": "10.213.16.1/24","assigned_object_type": null,"assigned_object_id": null,"description": "C213-PC16"}
]'
```

Normalement un résultat JSON apparaît pour chaque IP, on ne l'indique pas dans le cr car le retour de commande est beaucoup trop long. Cependant on peut visualiser la création des IPs sur Netbox.

![](https://i.imgur.com/YGuwuS7.png)

### Commande ```curl PATCH``` pour modifier les règles

Nous allons donc utiliser l'option PATCH de curl, la commande est assez longue puisqu'il faut indiquer les infos à changer de la totalité des IDs que l'utilisateur souhaite mais elle permettra de modifier les informations des 16 IDs dans Netbox

```
curl -X PATCH -s https://netbox.lroland.fr/api/ipam/ip-addresses/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
--data '[
{"id": 35, "status": "reserved"},
{"id": 36, "status": "reserved"},
{"id": 37, "status": "reserved"},
{"id": 38, "status": "reserved"},
{"id": 39, "status": "reserved"},
{"id": 40, "status": "reserved"},
{"id": 41, "status": "reserved"},
{"id": 42, "status": "reserved"},
{"id": 43, "status": "reserved"},
{"id": 44, "status": "reserved"},
{"id": 45, "status": "reserved"},
{"id": 46, "status": "reserved"},
{"id": 47, "status": "reserved"},
{"id": 48, "status": "reserved"},
{"id": 49, "status": "reserved"},
{"id": 50, "status": "reserved"}
]'
```

Comme pour POST, le retour de commande est trop long pour le mettre dans le cr. Cependant les statuts des 16 machines ont bien été changés.

![](https://i.imgur.com/vyaXckq.png)


### Commande ```curl DELETE``` pour supprimer les règles

Comme pour PATCH, il faudra indiquer les 16 IDs pour supprimer les machines

```
# curl -X DELETE -s https://netbox.lroland.fr/api/ipam/ip-addresses/ \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
--data '[
{"id": 35},
{"id": 36},
{"id": 37},
{"id": 38},
{"id": 39},
{"id": 40},
{"id": 41},
{"id": 42},
{"id": 43},
{"id": 44},
{"id": 45},
{"id": 46},
{"id": 47},
{"id": 48},
{"id": 49},
{"id": 50}
]'
```

Ici pas de retour de commande, visualisons sur Netbox les Logs : 

![](https://i.imgur.com/k1Yp6uG.png)

## Script permettant d'afficher, d'ajouter, de modifier et de supprimer

Comme ce qu'on a vu précedemmnt, les commandes pour manipuler plusieurs machines sont assez complexe et assez longues.

Louis a donc mis au point un script BASH permettant d'utiliser les 4 requêtes HTTP (GET,POST,PATCH et DELETE) pour une et plusieurs machines, ce qui facilitera la tâche et ce qui fera gagner ps mal de temps à l'utilisateur.

Le script est disponible sur le repo Github du projet (voir lien ci-dessous)
https://github.com/l-roland/projet-rt2/blob/main/scripts/classNetwork.sh

Voici plus en détail comment le script fonctionne : 

- Insertion de l'URL pour sélectionner une page en question
    - URL par défaut : https://netbox.lroland.fr/api/
    - IPs   : ipam/ip-addresses/
    - VLANs : ipam/vlans/
    - Sites : dcim/sites/
    - ...
- Affichage d'un élément recherché
- Ajout d'@IP en 10.SALLE.MACHINE.1/24
    - De 1 à X machines
- Modification d'éléments
    - De 1 à X id 
    - Modification id par id
    - Pas de modif globale
- Suppression d'éléments
    - De 1 à X id
    - Suppression id par id
    - Pas de suppression globale

Tout d'abord quand nous éxécutons le script, on nous demande d'indiquer le type d'objet que l'on souhaite (IPs, VLANs, Sites, ...)

Par la suite on nous demande quel type de requête HTTP on souhaite

```
# ./classNetwork.sh 
https://netbox.lroland.fr/api/  <- Insert an url
ipam/ip-addresses/
https://netbox.lroland.fr/api/ipam/ip-addresses/

HTTP REQUEST : GET - POST - PATCH - DELETE
GET - Retrieve an object or list of objects
POST - Create an object
PATCH - Modify an existing object
DELETE - Delete an existing object
```

### Requête HTTP GET

#### Avec https://netbox.lroland.fr/api/ipam/ip-addresses/

Dans ce cas présent, nous aurons un résultat indiquant toutes les adresses IP présentes dans Netbox (voir cr6).

```
GET

{
  "count": 32,
  "next": null,
  "previous": null,
  "results": [
      ...
  ]
 }
```

#### Avec https://netbox.lroland.fr/api/ipam/ip-addresses/25/

Ici, nous avons demandé les informations de l'IP utilisant l'identifiant ```25```, soit l'adresse ```10.255.255.204/24``` correspondant au nom DNS ```rudder```

```
GET

{
  "id": 25,
  "url": "https://netbox.lroland.fr/api/ipam/ip-addresses/25/",
  "family": {
    "value": 4,
    "label": "IPv4"
  },
  "address": "10.255.255.204/24",
  "vrf": null,
  "tenant": null,
  "status": {
    "value": "active",
    "label": "Active"
  },
  "role": {
    "value": "anycast",
    "label": "Anycast"
  },
  "assigned_object_type": null,
  "assigned_object_id": null,
  "assigned_object": null,
  "nat_inside": null,
  "nat_outside": null,
  "dns_name": "rudder",
  "description": "",
  "tags": [],
  "custom_fields": {},
  "created": "2021-03-24",
  "last_updated": "2021-03-24T12:50:54.027835Z"
}
```

### POST

#### Ajout machines C213

Ici nous allons ajouter les 4 première machines de la salle réseau C213 de l'IUT. Pour rappel voici le plan d'adressage de la salle : 

| Numéro machine | @réseau      | @IP |
| -------------- | ------------- | --- |
| 1              | 10.213.1.0/24 |10.213.1.1/24 |
| 2              | 10.213.2.0/24 |10.213.2.1/24 |
| 3              | 10.213.3.0/24 |10.213.3.1/24 |
| 4              | 10.213.4.0/24 |10.213.4.1/24 |

Dans un premier temps, le scipt demande le numéro de la salle (213 dans notre cas), ainsi que le nombre de machines (ici on a choisi 4 machines)


```
POST

Number of the classroom?
213
How many machines in the classroom?
4
...
```

Par la suite grâce à une boucle for, le script va créer les addresses 10.213.1.1/24, 10.213.2.1/24, 10.213.3.1/24 et 10.213.4.1/24 et ayant distinctivement comme descriptif PC1, PC2, PC3 et PC4.

![](https://i.imgur.com/kmcJEC5.png)

![](https://i.imgur.com/0ydYdZM.png)

Comme le montre les captures d'écran de Netbox, les 4 adresses sont correcement créées. CQFD

### Changement de statut

Pour le moment, la méthode PATCH permet 2 fonctions permettant de changer le statut d'une ou plusieurs adresses : 

- **A** = ```"status": "active"```
- **R** = ```"status": "reserved"```

#### Avec 1 id

Tout d'abord le script demande le nombre d'identifiants à modifier (1 dans notre cas), puis ensuite on nous demande le numéro de l'identifiant en question (70 qui est en réalité l'adresse 10.213.1.1/24).

Par la suite il faut indiquer l'information à changer (A pour statut actif et R pour statut réservé)

```
PATCH

Insert number of IDs
1

Insert ID
70

Type here what to modify
R

{
  "id": 70,
  ...
  "status": {
    "value": "reserved",
    "label": "Reserved"
  },...
}
```

Ici le statut a bel et bien changé en réservé comme demandé ! 

![](https://i.imgur.com/MINcGbO.png)

#### Avec les 4 ids créés précedemment

Tout d'abord le script demande le nombre d'identifiants à modifier (4 dans notre cas), puis ensuite on nous demande les numéros des identifiants en question (70,71,72 et 73 qui sont en réalité les adresses 10.213.1.1/24, 10.213.2.1/24, 10.213.3.1/24 et 10.213.4.1/24).

Par la suite il faut indiquer l'information à changer (A pour statut actif et R pour statut réservé). 

NB : il va falloir faire la modification id par id, si il y a beaucoup d'ids cela risquerait de prendre un peu de temps.

```
PATCH

Insert number of IDs
4

Enter number of ID(1) : 70
Type here what to modify
A

{
  "id": 70,
  ...
  "status": {
    "value": "active",
    "label": "Active"
  },
  ...
}

Enter number of ID(2) : 71
Type here what to modify
A

{
  "id": 71,
  ...
  "status": {
    "value": "active",
    "label": "Active"
  },
  ...
}

Enter number of ID(3) : 72
Type here what to modify
A

{
  "id": 72,
  ...
  "status": {
    "value": "active",
    "label": "Active"
  },
  ...
}

Enter number of ID(4) : 73
Type here what to modify
A

{
  "id": 73,
  ...
  "status": {
    "value": "active",
    "label": "Active"
  },
  ...
}
```

Ici la modification a bien eu lieu, CQFD !

![](https://i.imgur.com/LLltCAN.png)

### Suppression

Tout d'abord, le script nous demande le nombre d'identifiants que l'on veut supprimer, ici nous allons supprimer les 4 adresses que nous avons créés précedemment

Il faudra donc renseigner les identifiants 71, 71, 72 et 73 qui sont pour rappel les adresses 10.213.1.1/24, 10.213.2.1/24, 10.213.3.1/24 et 10.213.4.1/24

```
DELETE

Insert number of IDs
4

Enter number of ID(1) : 70
Removed
Enter number of ID(2) : 71
Removed
Enter number of ID(3) : 72
Removed
Enter number of ID(4) : 73
Removed
```

Allonhs voir sur les Logs Netbox si la maniuplation a bien eu lieu

![](https://i.imgur.com/pfBDwz9.png)

Tout est bon, le script est opérationnel !

## A faire pour le cr8

- Faire une liste des différents VLANs de l'IUT
- Créer les VLANs manuellement dans Netbox
- Script qui crée les VLANs en fonction des besoins de l'utilisateur avec les APIs

## Mise à jour doumentation

### Sitographie
https://netbox.readthedocs.io/en/stable/rest-api/overview/

### MAJ Burndown Chart

| cr | Semaine | Tasks average | Tasks complete |
| -- | ------- | ------------- | -------------- |
| 1 | 18/01 au 25/01 | 40 | 38 |
| 2 | 25/01 au 08/02 | 34.285 | 36 |
| 3 | 08/02 au 22/02 | 28.571 | 28 |
| 4 | 22/02 au 08/03 | 22.857 | 22 |
| 5 | 08/03 au 22/03 | 17.142 | 15 |
| 6 | 22/03 au 11/04 | 11.428 | 11 |
| 7 | 11/04 au 25/04 | 5.174  | 6 |
| 8 | 25/04 au 09/05 | 0  | 0 |

![](https://i.imgur.com/bG3jwqC.png)

### MAJ Gantt

- Compte rendu
    - cr7
- Netbox
    - Ajouter infos avec API
    - Modifier infos avec API
    - Supprimer infos avec API
    - Script manipulation de données avec API

![](https://i.imgur.com/R2Zspop.png)

### MAJ Tuleap

![](https://i.imgur.com/gLNyqoC.png)
