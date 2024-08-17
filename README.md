# Deployment com Vagrant, Ansible e Shell Script

Este repositório configura um ambiente de desenvolvimento com três servidores virtuais usando Vagrant, Ansible e Shell Script. O ambiente é composto por um control-node, um servidor de aplicação e um servidor de banco de dados.

## Estrutura do Projeto

```
/control-node
    /playbooks
        app.yaml
        db.yaml
    /scripts
        config_provision.sh
    /templates
        etc
            systemd
                notes.service
    Vagrantfile

/app01
    Vagrantfile

/db01
    Vagrantfile
```

## Configuração do Ambiente

### 1. Control-Node

O `control-node` é responsável por gerenciar a configuração dos outros servidores.

- **Vagrantfile**: Define a configuração do Vagrant para o control-node.
- **config_provision.sh**: Script de provisionamento que atualiza o sistema, instala dependências, configura chaves SSH e define os hosts para o Ansible.
- **Playbooks**:
  - **app.yaml**: Playbook Ansible para configurar o servidor de aplicação.
  - **db.yaml**: Playbook Ansible para configurar o servidor de banco de dados.
- **Templates**:
  - **notes.service**: Template do Systemd para criar e gerenciar o serviço da aplicação.
- **Variáveis**:
  - **main.yaml**: Arquivo de variáveis para configurar o banco de dados MySQL.

### 2. Servidor de Aplicação (app01)

O `app01` é onde a aplicação Java será instalada e executada.

- **Vagrantfile**: Define a configuração do Vagrant para o servidor de aplicação.
- **Playbook Ansible (`app.yaml`)**: Configura o servidor de aplicação, incluindo a instalação de Maven, JDK, e a configuração do serviço da aplicação.

### 3. Servidor de Banco de Dados (db01)

O `db01` é onde o banco de dados será instalado e configurado.

- **Vagrantfile**: Define a configuração do Vagrant para o servidor de banco de dados.
- **Playbook Ansible (`db.yaml`)**: Configura o servidor de banco de dados, incluindo a instalação e configuração do MySQL.

## Passos para Utilização

1. **Instalação das Dependências**
   - Certifique-se de que o Vagrant e o Ansible estejam instalados em seu sistema.

2. **Provisionar o Control-Node**
   - Navegue até o diretório `control-node` e execute:
     ```bash
     vagrant up
     ```
   - **Nota**: Certifique-se de que o control-node esteja totalmente iniciado e funcional antes de proceder para os próximos passos, pois ele precisa estar operacional para gerar e distribuir a chave SSH corretamente.

3. **Instalar a Biblioteca do Ansible Galaxy no Control-Node**
   - Acesse o `control-node` usando SSH:
     ```bash
     vagrant ssh
     ```
   - Dentro do `control-node`, instale a biblioteca do Ansible Galaxy necessária:
     ```bash
     ansible-galaxy role install geerlingguy.mysql
     ```

4. **Provisionar o Servidor de Aplicação e o Servidor de Banco de Dados**
   - Navegue até os diretórios `app01` e `db01` e execute:
     ```bash
     vagrant up
     ```

5. **Executar os Playbooks Ansible**
   - No `control-node`, execute os playbooks Ansible para configurar o ambiente:
     ```bash
     ansible-playbook -i /etc/ansible/hosts /control-node/playbooks/app.yaml
     ansible-playbook -i /etc/ansible/hosts /control-node/playbooks/db.yaml
     ```

6. **Verificação**
   - Verifique se os servidores foram configurados corretamente e se os serviços estão funcionando como esperado.

## Observações

- O `config_provision.sh` no control-node gera uma chave SSH que é usada para acessar os outros servidores. Garanta que o control-node esteja totalmente operacional antes de iniciar os outros servidores.
- O template `notes.service` é utilizado para criar um serviço Systemd que gerencia a aplicação Java.
- O arquivo `application.properties` contém configurações específicas para a conexão com o banco de dados e Hibernate.
- O arquivo de variáveis `main.yaml` define credenciais e configurações do MySQL, incluindo usuários e bancos de dados.
