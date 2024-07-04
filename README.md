# Progetto Sistemi Cloud

Questo progetto si pone l'obbiettivo di avviare un'applicazione in un cluster Kubernetes su Amazon Web Services, gestendo tutto il processo - dalla creazione dell'infrastruttura al deploy dell'applicazione - secondo il principi di "infrastructure as a code" , implementando anche una pipeline CD. 
Le tecnologie utilizzate sono: 

- Terraform, per la creazione dell'infrastruttura;
- Ansible, per la configurazione dei server;
- Kubernetes, per la gestione dei docker container;
- GitHub Actions, per la pipeline CD;

# Requisiti

Per poter avviare l'applicazione bisogna che l'host abbia installati i seguenti software:

- AWS CLI
- Terraform
- Ansible
