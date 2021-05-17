# projet-cr3

> Groupe 4 - Netbox / Inventaire des ressources IUT
> CAMPANELLA Enzo
> PASCAL Thomas
> ROLAND Louis

![](https://i.imgur.com/tWpdIxl.png)

## Compte rendu Roland

### Problématique du projet et analyse du besoin
Le projet consiste à faire l'inventaire des ressources de IUT, c'est à dire de monitorer la connectivité et le fonctionnement des différentes machines (ordinateurs, racks, VMs, ...) reliées au réseau de l'IUT.

Admettons que le système de monitoring de l'IUT ne fonctionne pas correctement ou n'a pas été mis à jour de puis un certain temps. Le technicien réseau devra alors vérifier manuellement le fonctionnement de certaines machines et perdre du temps sur des tâches inutiles.

Il faut donc trouver une ou des solution(s) afin de collecter et d'afficher automatiquement et à intervalle régulier les informations de machines que l'on souhaite obtenir.

### Proposition de solution

Nous allons donc nous pencher sur la solution que notre professeur tuteur nous a indiqué : utilisation de Netbox sur une machine Linux.

Pour l'instant nous utiliserons Netbox sur une machine virtuelle Debian afin de se familiariser avec l'environnement et de faire des tests


### Recherche de l'existant

J'ai trouvé sur Google un site utilisant Netbox : https://netbox.live/

Cela nous permettra d'obtenir un exemple pour voir comment cet outil fonctionne et comment nous pouvons obtenir les différentes informations souhaitées.

Voici un aperçu de la page d'accueil :

![](https://i.imgur.com/wuVC5fP.png)

On constate que tout est organisé par groupe. Voici une arborescence simplifiée de Netbox

- Organisation
    - Sites (Lab1)
        ![](https://i.imgur.com/00UNlOs.png)
        Numéro d'AS, Zone UTC, Coordonénes GPS, nombre de racks, d'appareils, de prefixes, de VLANs, de circuit et de machines virtuelles


    - Locataires (Clients ou départements)
- DCIM
    - Supports  (Racks d'équipements)
        ![](https://i.imgur.com/Yfj8dtz.png)
        - Contenu du Rack 1
            ![](https://i.imgur.com/QJUAqjB.png)
            Site, groupe, locataires, status, rôle, numéro de série, nombre d'appareils, dimensions, utilisation et schéma de positionnement.
    - Appareils
        ![](https://i.imgur.com/6I5W0FW.png)
        Status, locataire, site, rack, position dans le rack, rôle, type et adresse IP
    - Connexions (câbles, interfaces, console, et alimentation)
        - Câbles
        ![](https://i.imgur.com/jwVDlSR.png)
        Source, destination, nom de l'interface, status, type, couleur, longueur
        - Interfaces
        ![](https://i.imgur.com/sWzcPxa.png)
        Appareil src et dst, interface src et dst, status
- Virtualisation
    - Machine hôte
        ![](https://i.imgur.com/pUUUWB5.png)
        Nom, type, groupe, site, nombre d'appareils et de VMs
    
    - Machine virtuelle
        Instances en cours d’exécution dans les clusters
- IPAM (Gestion des adresses IP)
    - Tables virtuelles de routage et de forwarding
    - Allocations IP
        ![](https://i.imgur.com/QB8h0H7.png)
    - Préfixes
        ![](https://i.imgur.com/ycxQNEX.png)

    - @IP
        ![](https://i.imgur.com/dMLXvNj.png)
    - VLAN
        identifié par VLAN ID
- Circuits
    - Fournisseurs
        Organisations qui fournissent une connectivité de circuit
    
    - Circuits
        Liaisons de communication pour le transport en commun sur Internet, le peering et d’autres services
        
Le choix de cette solution semble parfaitement répondre à la problématique.
        
### Installation de Netbox sur une machine Linux

J'ai suivi à la lettre le tutoriel disponible sur la doc de Netbox

https://netbox.readthedocs.io/en/stable/installation/

Il m'a juste fallu installer rust et la libraire Python `cryptography` pour faire fonctionner le tout. Pour moi l'installation s'est déroulée correctement. Je peux maintenant utiliser Netbox sur mon navigateur !

![](https://i.imgur.com/Izr1qjc.png)

Je peux aussi me login en admin pour avoir plus de détails

![](https://i.imgur.com/ZyChpDN.png)

Je constate qu'il y a aucune information sur quoi que ce soit. Il faudra donc configurer Netbox.

Commandes à éxécuter pour lancer l'instance Netbox.
```
root@deb10 : /opt/netbox/netbox/netbox
# source /opt/netbox/venv/bin/activate
(venv) 
root@deb10 : /opt/netbox/netbox
# python3 manage.py runserver 0.0.0.0:8000 --insecure
```

## Pour le cr4

- Configuration de Netbox
