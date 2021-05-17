# projet-cr4

> Groupe 4 - Netbox / Inventaire des ressources IUT
> CAMPANELLA Enzo
> PASCAL Thomas
> ROLAND Louis

## Test de Netbox sur les machines de l'IUT

Il existe deux façons d'installer et d'utiliser Netbox : 

- Soit par la méthode des commandes d'installation
- Soit par la méthode des containers Docker

Nous avons décidé du'tiliser la seconde méthode (containers Docker) car nous avons utilisé une des tours de la salle réseau. Ainsi nous n'avons pas eu besoin d'installer et de configurer plein de paquets, juste un fichier docker-compose suffit. 

De plus, l'avantage du fichier docker-compose est qu'on peut l'utiliser sur n'importe quelle machine Linux, que ce soit en salle projet, en salle réseau, sur une VM, chez soi ou encore sur un serveur (nous y reviendrons plus tard)...

Il existe déjà un docker-compose tout fait par la communauté de Netbox sur GitHub, nous l'avons donc utilisé afin de faire le test à l'IUT :
https://github.com/netbox-community/netbox-docker

Il nous a suffit juste d'installer git, docker et docker-compose sur les machines afin d'éxécuter le tout

```
$ apt install docker.io curl git
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ git clone https://github.com/netbox-community/netbox-docker.git
```

Nous avons suivi à la lettre le contenu du fichier README.md du repository afin de bien faire fonctionner Netbox

```
$ cd netbox-docker
$ ee docker-compose.override.yml <<EOF

version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF

$ docker-compose pull
$ docker-compose up

---------------------------------------------
Starting netbox-docker_redis-cache_1 ... done
Starting netbox-docker_postgres_1    ... done
Starting netbox-docker_redis_1       ... done
Starting netbox-docker_netbox-worker_1 ... done
Starting netbox-docker_netbox_1        ... done
...
```

En indiquant 0.0.0.0:8000 dans l'url du navigateur, Netbox s'affiche !

![](https://i.imgur.com/x5Gmd5B.png)

Nous pouvons nous connecter en tant qu'admin afin d'ajouter les champs que l'on souhaite

- Username: admin
- Password: admin
- API Token: 0123456789abcdef0123456789abcdef01234567

## Prise de RDV avec le cri de l'IUT

Nous avons donc pris RDV avec Frédéric DUBAN, le Directeur du CRI (Centre de Ressources Informatiques et Multimédia) qui stocke et liste toutes les adresses de l'IUT. Nous avons donc demandé quelques informations à indiquer dans Netbox afin d'avoir un premier aperçu.

Voici la liste d'adresses qui nous a été envoyée, elle correspond à plusieurs champs DNS mais nous pourrons les rentrer toutefois dans Netbox

```
Voici quelques adresses pour votre projet :


iut              A    194.199.227.10    adresse sortie des postes du réseau interne
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
web-mmi     10.255.255.201/8         194.199.227.201/24 
rudder     10.255.255.204        
pwd et cs     10.255.255.205 206     1943199.227.223     
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

## Mise à jour du diagramme de Gantt et Tuleap

Nous avons mis à jour le diagramme de Gantt indiquant ce qui a été fait our ce compte rendu

- Seconde réunion avec Mr Pouchoulon
- Premiere réunion avec le CRI de l'IUT
- Déploiement de Netbox à l'IUT
- Utilisation de Docker pour Netbox
- Premiers tests sur Netbox

![](https://i.imgur.com/gow1Si9.png)

Nous avons ainsi mis à jour la ToDoList de Tuleap indiquant les différentes étapes faites lors de ce compte-rendu.
