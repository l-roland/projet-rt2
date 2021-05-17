# projet-cr6

> Groupe 4 - Netbox / Inventaire des ressources IUT
> CAMPANELLA Enzo
> PASCAL Thomas
> ROLAND Louis

## Saisie des @IP

L'IUT nous à mis à disposition plusieurs adresses IPs.

Voici la liste de ces adresses:
```
iut              A    194.199.227.10    adresse sortie des postes du réseau 

interne

dns1            A    194.199.227.53
time            CNAME   dns1
time1           CNAME   dns1
time2           CNAME   dns2
dns2            A    194.199.227.54
www           A    194.199.227.80
uam            A    194.199.227.111
WiNAT           CNAME uam
sos2            A    194.199.227.146
web-mmi2    A    194.199.227.191
web-mmi         A       194.199.227.201
registry        A       194.199.227.220
owncloud        CNAME   registry
surveylp        CNAME   registry
surveyrt        CNAME   registry
progasur        A       194.199.227.221
matermost       A       194.199.227.222
mm              CNAME   matermost
pwd             A       194.199.227.223
cs              A       194.199.227.224
store           A       194.199.227.225
registry.iutbeziers.fr     10.255.255.135      194.199.227.220
rt-peda     10.255.10.1 à 10.255.10.4
dhcp     10.255.255.1
pxe     10.255.255.2/16
newnag     10.255.255.133
web-mmi     10.255.255.201/8        194.199.227.201/24 
rudder     10.255.255.204
pwd et cs     10.255.255.205 206    194.199.227.223
pwd1     sur pwd 10.255.255.206     194.199.227.224
kb1     10.255.255.207
kb2     10.255.255.208
kb3     10.255.255.209
mb1     10.255.255.210
mb2     10.255.255.211
mb3     10.255.255.212
web-mmi2     10.255.255.221/8         194.199.227.191/24
prt     10.255.255.249/16
```

Il nous à donc fallu les rentrer une à une dans Netbox:

En premier temps il faut aller sur IPAM -> Adresses IP.

![](https://i.imgur.com/4pLlrJ4.png)

Nous arrivons ensuite sur la page suivante:

![](https://i.imgur.com/LZDTzK6.png)
On voit ici qu'aucune adresse n'à été renseignée.

Sur la même page cliquer sur ajouter:

![](https://i.imgur.com/cSy1Xmt.png)

Cela va nous diriger sur une page pour pouvoir ajouter des adresses IPs:

Ici de nombreuses cases sont à remplir, dans notre cas nous n'aurons pas le besoin de toutes les remplir.

Case adresse IP:

![](https://i.imgur.com/AcGVURm.png)

Ici, nous devons rajouter l'adresse de la machines, son statut, son role et sa description. Le nom du DNS dépendra pour certaines machines.

Case location:

![](https://i.imgur.com/y4E04xp.png)

Nous n'avons pas de groupe de locataire pour le moment donc nous selectionnerons "aucun", de même pour locataire.

Case affectation d'interface:

![](https://i.imgur.com/4sx2JYk.png)
Pour l'instant pas d'utilité.

Case IP NAT (à l'intérieur)

![](https://i.imgur.com/Dty7v4M.png)
Uniquement l'onglet "placer" sera à remplir, il faut selectionner IUT Béziers.

Voici ceux à quoi ressemble Netbox après y avoir renseigner toutes les adresses:

![](https://i.imgur.com/rq3FcAa.png)

## API

### Comment ça marche?

Le but de l'API dans Netbox est d'utiliser des requêtes HTTP et la notation d'objet JavaScript (JSON) pour faciliter les opérations de création, de récupération, de mise à jour et de suppression sur les objets d'une application (@IPs par exemple). Nou pouvons utiliser les paramètres HTTP pour faire nos requêtes comme : 

- ```GET``` = Récupérer un objet ou une liste d'objets
- ```POST``` = Créer un objet
- ```PUT``` = Modifier un objet existant avec tous les champs obligatoires spécifiés
- ```PATCH``` = Modifier un objet existant, seul le champ en cours de modification sera spécifié.
- ```DELETE``` = Supprimer un objet existant

Nous allons faire la démonstration avec l'@IP `194.199.227.225/24` qui possède l'identifiant numéro 13. Voici ce que le navigateur nous retourne concernant les informations sur cette adresse :

![](https://i.imgur.com/mR3EVNC.png)

### Utilisation de curl

Nous allons demander la totalité des @IPs saises précedemment à l'aide des outils curl et jq à partir de la page api de Netbox

```
$ curl -s https://netbox.lroland.fr/api/ipam/ip-addresses/ | jq '.'
{
  "detail": "Authentication credentials were not provided."
}
```

Ici aucun nom d'utilistauer n'est indiqué. Il faut alors utiliser l'API Token qui a été fourni par Github et l'implémenter dans la commande curl

Pour rappel : 
- Username : ```admin```
- Password : ```admin```
- API Token : ```0123456789abcdef0123456789abcdef01234567```

Ainsi nous aurons la commande suivante, ainsi que le retour de commande qui n'affiche aucune erreur : 

- On pensera à indiquer la requête GET puisqu'on veut obtenir des informations
- On indiquera le Token fourni par le constructeur
- On indiquera aussi que nous voulons un résultat en JSON

```
# curl -X GET -s https://netbox.lroland.fr/api/ipam/ip-addresses/ -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" -H "Content-Type: application/json" -H "Accept: application/json; indent=4" | jq '.'
{
  "count": 32,
  "next": null,
  "previous": null,
  "results": [
    {
        ...
    }
  ]
}
```

On constate ainsi la présence de 32 adresses IP configurées, ce qui correspond bien au nombre d'adresses que nous avons saisi manuellement

### Informations @IP id n°13 avec curl
```
$ curl -s https://netbox.lroland.fr/api/ipam/ip-addresses/13/ -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" -H "Content-Type: application/json" -H "Accept: application/json; indent=4" | jq '.'
{
  "id": 13,
  "url": "https://netbox.lroland.fr/api/ipam/ip-addresses/13/",
  "family": {
    "value": 4,
    "label": "IPv4"
  },
  "address": "194.199.227.225/24",
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
  "dns_name": "store",
  "description": "",
  "tags": [],
  "custom_fields": {},
  "created": "2021-03-24",
  "last_updated": "2021-04-13T09:14:29.919237Z"
}
```

### Informations @IP id n°13 avec interface graphique

Il existe une page https://netbox.lroland.fr/api qui fournit toutes les informations que l'on souhaite. If faut noter que cette page utilise le programme **Django**. Le principe de fonctionnement est le même qu'avec curl, même retour d'informations etc :

![](https://i.imgur.com/JXxdBgp.png)

### Informations du site avec curl

```
# curl -X GET -s https://netbox.lroland.fr/api/dcim/sites/ -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" -H "Content-Type: application/json" -H "Accept: application/json; indent=4" | jq '.'
{
  "count": 1,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "url": "https://netbox.lroland.fr/api/dcim/sites/1/",
      "name": "IUT Beziers",
      "slug": "iut-beziers",
      "status": {
        "value": "active",
        "label": "Active"
      },
      "region": null,
      "tenant": null,
      "facility": "",
      "asn": null,
      "time_zone": "Europe/Paris",
      "description": "Inventaire des ressources de l'IUT",
      "physical_address": "",
      "shipping_address": "",
      "latitude": null,
      "longitude": null,
      "contact_name": "",
      "contact_phone": "",
      "contact_email": "",
      "comments": "",
      "tags": [],
      "custom_fields": {},
      "created": "2021-03-23",
      "last_updated": "2021-03-23T22:12:21.559593Z",
      "circuit_count": 0,
      "device_count": 0,
      "prefix_count": 0,
      "rack_count": 0,
      "virtualmachine_count": 0,
      "vlan_count": 0
    }
  ]
}
```

### Documentation

- https://netbox.readthedocs.io/en/stable/rest-api/overview/
- https://groups.google.com/g/netbox-discuss/c/Xy3eQxuVwcg?pli=1

## Mise à jour documentation

### MAJ ToDoList Tuleap

![](https://i.imgur.com/IZetLzx.png)

### MAJ Gantt

- Compte rendu
    - cr6
- Documentation
    - API Netbox
- Netbox 
    - Saisie manuelle @IP
    - Récupérer infos avec API

## Pour le prochain Compte Rendu (cr7)

- Modifier des adresses IP à l'aide des APIs
- Supprimer des adresses IP à l'aide des APIs
