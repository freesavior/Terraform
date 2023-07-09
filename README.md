#Déploiement d'une infrastructure AWS avec Terraform

#Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants configurés :

Un compte AWS avec des informations d'identification (access key et secret key) ayant les autorisations nécessaires pour créer les ressources AWS décrites.
Terraform installé sur votre machine locale. Vous pouvez le télécharger à partir du site officiel de Terraform.

Je me suis basé sur l'infrastructure présentée sur le site d'Amazon https://docs.aws.amazon.com/vpc/latest/userguide/vpc-example-private-subnets-nat.html pour créer mon propre modèle.

![Infra du projet](https://docs.aws.amazon.com/images/vpc/latest/userguide/images/vpc-example-private-subnets.png)

Ce dépôt contient des fichiers Terraform pour déployer une infrastructure sur AWS qui répond à la description suivante :
- VPC : Création de la VPC "Production" avec deux sous-réseaux publics et deux sous-réseaux privés dans deux zones de disponibilité distinctes.
- Instances EC2 : Création de deux instances EC2 dans les sous-réseaux privés, utilisant l'AMI "ami-05432c5a0f7b1bfd0" et nommées "Preproduction" et "Production".
- Groupe d'auto-scaling : Configuration d'un groupe d'auto-scaling pour lancer et terminer les instances EC2 en fonction de la demande.
- Équilibreur de charge : Création d'un équilibreur de charge dans le sous-réseau public pour distribuer le trafic vers les instances EC2.
- Passerelle NAT : Configuration d'une passerelle NAT pour permettre aux instances EC2 du sous-réseau privé d'accéder à Internet.
- Point de terminaison VPC : Création d'un point de terminaison VPC pour permettre aux instances EC2 d'accéder à Amazon S3 sans passer par Internet.
- Amazon S3 : Création d'un bucket S3 nommé "EC2-bucket-endpoint" avec les autorisations appropriées pour le point de terminaison VPC.

La structure du répertoire est comme suit :
.
```
.
├── main.tf
├── modules
│   ├── auto_scaling
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── load_balancer
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── nat_gateway
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── s3_bucket
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── vpc_endpoint
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── variables.tf
```






