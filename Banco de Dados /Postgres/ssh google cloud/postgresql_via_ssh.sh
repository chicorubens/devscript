# Crie sua chave SSH (o comando precisa ser este, mude apenas o caminho nome_da_chave)
ssh-keygen -t rsa -b 4096 -m PEM -f ~/.ssh/nome_da_chave

# Permita conexões externas ao postgresql
sudo nano /etc/postgresql/13/main/postgresql.conf
# Altere #listen_addresses = '...'
# Para listen_addresses = '*'

# Se houver proxies na rede, altere /etc/postgresql/13/main/pg_hba.conf
# Adicione ao final (mude proxy_ip para o IP do proxy)
host    all             all             proxy_ip/32        md5





#_________________________________________________

#exemplo no temrminal

#*** no google cloud platform
#-acesse o painel do google cloud platform
#-no seu terminal crie a chave shh, com comandos para criar chave ssh, dentro da pasta ouculta .ssh no seu usuario.
#-acesse Metadados para dar acesso por chave ssh

#comandos para criara a chave ssh
#1º ~$ ssh-keygen -t rsa -b 4096 -m PEM -f ~/.ssh/postgesql.pub #coloquei esse nome para diferenciar as chaves

#*Enter passphrase (empty for no passphrase): digiteasenha  #senha para abrir a chave que será usada toda vez que usar a chave ssh
#novamente

#*criará sha256: skuhrnvlwekrjhnvoiewurhnt*kjf qualquer

#2º ~$ cat ~/.ssh/postgresql.pub    #isso mostrará o pub colocado no Metadados do google cloud platform
#copie e cole no google cloud platform e salva

#* Em Instancia de VM no google cloud platform, copie o endereço de ip externo do acesso ao "postgresql", com opção conectar marcado "ssh".

#3º ~$ssh fcorubens@34.95.156.177 #ex.

#*o linux vai perguntar se quer adicionar o ip na lista no-host, primeira vez, digite yes

#*então pedira a senha de acesso a chave

#4º Verifivar no google cloud platform se a PORTA DE ACESSO (5432) está liberada

#* no google cloud platform Instâncias de VM clique nos 3 pontos de menu e escolha Ver detalhes da rede, escolha FIREWALL

#5º no google cloud platform, Instância de VM, Detalhes da rede Firewall. Crie uma regra de firewall 

#* digite nome, registros desativado, rede default, prioridade 1000, direção de trafego: entrada, ação se houver correspondência: permitir, Destinos: Todas as instcias na rede,
#intervalo de IP de origem: 0.0.0.0/0 para todas as redes, Protocolos e portas:tcp:5432 e CRIAR. "verifica se está ativa".

#_____________________________________________________

#criando acesso do postgres ao google cloud com dbeaver e postgreadmin

#1º acesse ~$vim /etc/postgresql/13/main/postgresql.conf
#* procure: listen_addresses, descomente e coloque '*'
#listen_addresses='*' e salve e depois reinicie o servidor ~$sudo systemctl restart postgresql

#2º crie a conexão com os pgadmin e dbeaver

#* coloque nome, connection, vá em ssh tunnel e coloque ip do servidor, porta 22, Username fcorubens, Authentication: Identity file, na escolha do Identity file choose: escolha arquivo de chave privada.
#*se não der certo verifique o ip roda com proxy, ~$sudo nano /etc/postgresql/13/main/pg_hba.conf
#* no final insira:
			#ip_externo no google cloud platform(proxy_ip)
#host	all	all	34.95.156.177/32	md5


