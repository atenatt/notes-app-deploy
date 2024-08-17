#!/bin/bash

# Atualizando pacotes do sistema operacional
echo "[ETAPA 1] Atualização do sistema operacional"
sudo yum -y update

# Instalando o repositorio epel-release
echo "[ETAPA 2] Instalação do repositório do epel-release"
sudo yum -y install epel-release

# Instalando o ansible
echo "[ETAPA 3] Instalacao do pacote Ansible"
sudo yum -y install ansible

# Adicionando os hosts no diretório /etc/hosts
echo "[ETAPA 4] Adicionando hosts no /etc/hosts"
sudo bash -c "cat <<EOT >> /etc/hosts
192.168.1.2 control-node
192.168.1.3 app01
192.168.1.4 db01
EOT"

# Removendo a chave ssh antiga
echo "[ETAPA 5] Removendo a chave ssh antiga"
sudo rm -rf /vagrant/ssh_key/id_rsa*

# Gerando a nova chave ssh
echo "[ETAPA 6] Gerando a chave ssh para os nodes"
ssh-keygen -t rsa -b 4096 -f /vagrant/ssh_key/id_rsa -N ""

# Copiando a chave ssh gerada para o /home/vagrant/.ssh/ida_rsa
echo "[ETAPA 7] Copiando a chave ssh gerada para o home do usuario"
cp /vagrant/ssh_key/id_rsa /home/vagrant/.ssh/

# Adicionando os hosts no arquivo /etc/ansible/hosts
echo "[ETAPA 8] Adicionando hosts no arquivo do ansible"
sudo bash -c "cat <<EOT > /etc/ansible/hosts
[apps]
app01
[dbs]
db01
EOT"


