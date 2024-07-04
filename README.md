# Progetto Sistemi Cloud

Questo progetto si pone l'obbiettivo di avviare un'applicazione in un cluster Kubernetes su Amazon Web Services, gestendo tutto il processo - dalla creazione dell'infrastruttura al deploy dell'applicazione - secondo il principi di "infrastructure as a code" , implementando anche una pipeline CD. 
Le tecnologie utilizzate sono: 

- Terraform, per la creazione dell'infrastruttura;
- Ansible, per la configurazione dei server;
- Kubernetes, per la gestione dei docker container;
- GitHub Actions, per la pipeline CD;

Ad essere avviata sarà nginx. 

# Requisiti

Per poter avviare l'applicazione bisogna che l'host abbia installati i seguenti software:

- Openssh
- AWS CLI
- Terraform
- Ansible

# Istruzioni

Configurate AWS CLI inserendo le vostre credenziali, con il comando:

```
aws configure
```

Scaricate il repository:

```
git clone https://github.com/Hacstyle/Progetto-Sistemi-Cloud.git
```

Entrate nella cartella del progetto:

```
cd Progetto-Sistemi-Cloud
```

Create l'infrastruttura:

```
terraform init
terraform apply
```
Salvate la chiave privata per l'accesso ai server:

```
terraform output -raw private_key > private_key.pem
chmod 600 private_key.pem  
```

Modificate il file hosts.ini inserendo gli indirizzi ip dei server creati
```
[nodes]
node1 ansible_host=<ipserver>
node2 ansible_host=<ipserver>
```

Configurate i server:

```
ansible-playbook -i hosts.ini mini-playbook.yaml 
```

Modificate le variabili segrete del repository con i vostri dati e fate una qualsiasi azione di push sul repository. Questa avvierà la pipeline CD ed effettuerà il deploy dell'applicazione.

E' possibile verificare il corretto funzionamento dell'applicazione eseguendo:

```
ssh -i private_key.pem ec2-user@<indirizzoip>
kubectl get svc
minikube get ip
curl indirizzoip:porta
```


