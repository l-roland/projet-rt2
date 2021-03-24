# projet-cr5

> Groupe 4 - Netbox / Inventaire des ressources IUT
> CAMPANELLA Enzo
> PASCAL Thomas
> ROLAND Louis

## Choix de l'utilisation de Netbox à distance

Louis à récemment acquis un **serveur** Linux distant ainsi qu'un **nom de domaine**. Nous trois avons donc décidé de mettre à jour la solution utilisée afin de répondre à la problématique et donc d'**utiliser son serveur afin d'héberger Netbox** pour plusieurs raisons : 

- Configuration de **Netbox n'importe où**
    - Sur les machines de l'IUT
    - Chez soi
    - Via son smartphone/tablette
    - Avec le réseau 4G
    - Dans les transports en communs (pourquoi pas après tout)
- Notre **tuteur de projet** pourra regarder ce que nous avons fait sur Netbox
- Présenter plus facilement le produit lors de l'**oral du projet**

## Problèmes rencontrés lors d'un premier test distant

Nous avons donc procédé au déploiement de Netbox sur le serveur de Louis en utilisant la **même méthode utilisée que dans le cr4** (utilsiation de Docker Compose). Ainsi il pouvait de chez lui accéder à Netbox avec l'adresse http://lroland.fr:8000 (Netdata utilise le port 8000).

Certes cela fonctionnait chez lui, mais 2 problèmes majeurs on eu lieu : 
- **Impossible d'accéder à Netbox à l'IUT**, que ce soit en WIFI ou en Ethernet
- **Impossible d'accéder à Netbox chez Thomas**

Après pas mal de recherches, les 2 problèmes que l'on a eu étaient finalement liés à la **non sécurisation du container** (merci Arnaud RUFFAT, étudiant en LP ASUR). Le problème était de même avec d'autre fonctionnalités du seveur de Louis comme **CodiMD** ou **Apache** par exemple

Cela veut donc dire qu'il faut impérativement utiliser **https** à l'aide d'outils et de certificats. Il a donc fallu revoir le fontionnement du serveur de Louis afin d'intégrer : 
- http -> Port 80
- https -> Port 443
- La redirection automatique http vers https

## Mise en place de HTTPS

### Définition de HTTP
https://fr.wikipedia.org/wiki/Hypertext_Transfer_Protocol

- HTTP est un protocole de la couche application. Il peut fonctionner sur n'importe quelle connexion fiable, dans les faits on utilise le protocole TCP comme couche de transport. Un serveur HTTP utilise alors par défaut le port 80.

- Les clients HTTP les plus connus sont les navigateurs Web permettant à un utilisateur d'accéder à un serveur contenant les données. Il existe aussi des systèmes pour **récupérer automatiquement le contenu d'un site** tel que les aspirateurs de site Web ou les robots d'indexation. 

***D'ou le fait que l'IUT semble bloquer les connexions non sécurisées, ce qui est tout à fait logique pour un établissement universitaire.***

### Définition de HTTPS
https://fr.wikipedia.org/wiki/HyperText_Transfer_Protocol_Secure

- L'HyperText Transfer Protocol Secure est la combinaison du **HTTP avec une couche de chiffrement** comme SSL ou TLS.

- HTTPS permet au visiteur de **vérifier l'identité du site web** auquel il accède, grâce à un **certificat d'authentification** émis par une autorité tierce, réputée fiable.

- Il garantit théoriquement la **confidentialité et l'intégrité** des données envoyées par l'utilisateur et reçues du serveur.

***Il était donc indispensable de mettre en place ce protocole dans le but de sécuriser tous les services souhaités (Apache/NGINX, containers Docker) et d'y accéder partout.***

### Premiers tests sur Apache

- Afin de découvrir le fonctionnement du protocole HTTPS, nous avons d'abord fait des tests sur un serveur Apache toujours hébergé sur le serveur de Louis.

```
$ apt install apache2

$ vim /etc/apache2/sites-available/lroland.conf
<VirtualHost *:80>
    ...
    ServerName lroland.fr
    ServerAlias www.lroland.fr
    ...
</VirtualHost>

$ a2dissite 000-default.conf
$ a2ensite lroland.conf
```

- Il est préférable d'utiliser un Firewall afin de filtrer les services et les ports.

```
# ufw status
Status: active

To                         Action      From
--                         ------      ----
Apache Full                ALLOW       Anywhere
OpenSSH                    ALLOW       Anywhere
Apache Full (v6)           ALLOW       Anywhere (v6)
OpenSSH (v6)               ALLOW       Anywhere (v6)
```

- La solution la plus simple que nous avons trouvé pour installer les certificats sur apache était d'utiliser certbot, c'est un paquet qui génère automatiquement des certificats et qui les applique sur soit Apache, soit sur NGINX. Ne sachant pas utiliser ce dernier, nous avons choisi Apache car nous l'avons étudié en cours

```
$ apt install certbot python-certbot-apache
$ certbot --webroot -d lroland.fr -d www.lroland.fr
$ certbot --apache -d lroland.fr -d www.lroland.fr

$ ls /etc/letsencrypt/live/lroland.fr
cert.pem  chain.pem  fullchain.pem  privkey.pem  README
```

Désormais des certificats sont générés et le HTTPS fonctionne parfaitement pour Apache !

- Pour terminer avec Apache, nous avons choisi de faire une redirection automatique HTTP vers HTTPS

```
$ vim /etc/apache2/sites-available/lroland.conf

<VirtualHost *:80>
    ...
    Redirect permanent / https://lroland.fr/
    ...
</VirtualHost>


$ vim /etc/apache2/sites-available/lroland-le-ssl.conf

<VirtualHost *:80>
    ...
    <If "%{HTTP_HOST} == 'www.lroland.fr'">
        Redirect permanent / https://lroland.fr/
    </If>
    ...
</VirtualHost>

$ service apache2 restart
```

Désormais nous avons un serveur Apache en rediriegant les connexions HTTP en HTTPS. Nous pouvons donc stopper apache car nous n'en aurons plus besoin

### HTTPS avec les containers Docker

Connaissant maintenant le mécanisme du HTTPS, il faut maintenant l'appliquer sur le container Netbox. Après pas mal de recherches sur Inernet nous avons toruvé deux solutions

- Utilisation de Apahce/NGINX avec l'option ReverseProxy
    - Permet de rediriger un port en question, dont le port d'un container Docker vers du HTTP et/ou HTTPS. 
- Utilisation du container Traefik 
    - Permet de rediriger le port d'un container automatiquement en HTTP et/ou HTTPS selon un sous-domaine DNS

Apache semble être un peu capricieux avec l'option ReverseProxy, de plus, Louis ayant un nom de domaine, il peut aussi créer des sous-domaines à l'aide de la requête DNS A.

La solution de Traefik semble être la meilleure solution pour utiliser HTTPS sur des containers dans notre cas.

## Mise en place de Traefik

### Qu'est-ce que Traefik?
https://medium.com/ouidou/%C3%A0-la-d%C3%A9couverte-de-traefik-18da29cdbb46

- Traefik est un “modern reverse proxy”, un reverse proxy designé pour **répondre aux besoins du cloud**.

- Traefik permet donc de faire de la “configuration discovery” via plusieurs fournisseurs de services et load balancer pour HTTP et TCP. Il offre également d’autres fonctionnalités comme le support de Let’s Encrypt (**certificats**), des middlewares (**identification user/paswd chiffré**) et la possibilité de monitorer facilement des services.

### Et un Reverse Proxy, c'est quoi?
- Un reverse-proxy est une brique de notre infrastructure, qui permet d’être un intermédiaire de communication, entre un réseau public et un réseau privé, le nôtre par exemple. C’est sur ce réseau privé que l’on trouvera toutes les applications de notre SI qui ne sont pas accessibles depuis l’extérieur pour des raisons de sécurité principalement.

- Le reverse-proxy doit donc connaître toutes les “routes” disponibles pour transférer chaque requête vers le bon service. Comme il est le point central du trafic, il peut également faire du load balancing, ou encore appliquer des règles de sécurité comme le HTTPS par exemple.

### Déploiement de Traefik
Nous avons parcouru énormément de pages web et testé beaucoup de configurations Docker Compose pour le container Traefik. 

Il fallait tout d'abord créer un réseau virtuel Docker nommé "oueb". C'est avec ce réseau virtuel que pourront communiquer tous les containers présents sur la machine utilisée.

```
$ docker network create oueb
```

```
version: '3.7'
services:
  container:
      ...
      labels:
      - <traefik_options>
      networks:
      - oueb
      
networks:
  oueb:
    external: true
```


Nous avons au bout d'un moment eu un fichier docker-compose.yml stable et donc pointé notre configuration vers https://traefik.lroland.fr pour visualiser le tableau de bord

![](https://i.imgur.com/2nEaHfr.png)
*Session d'identification pour accéder au dashboard Traefik*

![](https://i.imgur.com/ETg23tf.png)
*Page d'accueil de Traefik*

![](https://i.imgur.com/nwazoRB.png)
*Services activés*

## Mise en place d'un Netbox sécurisé
Pour cela nous avions du modifier deux fichiers du repository que l'on a cloné dans le cr4 : 
- docker-compose.override.yml
- docker-compose.yml

### Changement de docker-compose.override.yml

Nous avons indiqué dans ce fichier différentes options permettant 
- de pointer le port en question vers netbox.lroland.fr
- de rediriger automatiquement les connexions HTTP vers HTTPS
- d'utiliser le réseau virtuel de Docker "oueb" précedemment créé

### Changement de docker-compose.yml

Nous avons indiqué dans ce fichier l'utilisation de réseau virtuel de Docker "oueb" précedemment créé pour (tous) les conatainers 

- netbox
- netbox-worker
- postgres
- redis
- redis-cache

### Déploiement de Netbox

Il suffit de démarrer le container netbox avec `docker-compose up`

En renseignant l'URL https://netbox.lroland.fr ou http://netbox.lroland.fr, nous pourrons désormais accéder à Netbox n'importe ou de manière sécurisée !

![](https://i.imgur.com/IgF0bGN.png)
*Page d'accueil de Netbox en HTTPS*


### Test du côté de Thomas

![](https://i.imgur.com/Bjh8gKP.png)

### Test du côté d'Enzo

![](https://i.imgur.com/PmXDdBl.png)

### Test du côté de Louis

![](https://i.imgur.com/aQ7e4O5.png)

## Mise à jour du Gantt/Tuleap

### Gantt

Ajout : 
- Documentation HTTP/HTTPS et Traefik
- Tests apache et déploiement containers
- Tâches effectuées sur le serveur distant

![](https://i.imgur.com/1vMD1Py.png)

### Tuleap

![](https://i.imgur.com/GeL7map.png)
