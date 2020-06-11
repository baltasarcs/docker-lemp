# docker-lemp
Estrutura simples para disponibilizar pilha LEMP LINUX + NGINX + MYSQL(8.0) + PHP(7.4-fpm)

Crie uma copia de .env_example como .env e defina os parâmetros de acordo com suas necessidades

Faça o pull + bild das imagens e crie a pilha LEMP com:

docker-compose up -d

Verifique se tudo esta ok com:

docker ps -a

Identifique o IPAddress do container que esta rodando nginx com:

docker inspect nginx

Se você é esperto e usa linux, altere o /etc/hosts, do contrario, se sofre com windows, altere o C:\Windows\System32\drivers\etc\hosts adicionando ao final do arquivo o 

redirecionamento p/ o VIRTUAL_HOST definido no arquivo .env, por exemplo:

IPAddress mydomain.com

Seu ambiente estará disponível dentro de /var/wwww/ onde seus apps devem ser adicionados

Acesse pelo browser htttp://mydomain.com ou http://localhost/myapp
Para ambiente de produção renomeie o php/7.4-fpm/php.ini-production para php.ini

Sempre que houver a necessidade de alterar algum arquivo de configuração, reinicie o container com:

docker restart containername
