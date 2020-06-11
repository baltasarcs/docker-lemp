# docker-lemp
**Estrutura simples para disponibilizar pilha LEMP LINUX + NGINX + MYSQL(8.0) + PHP(7.4-fpm)**

Crie uma copia de .env_example como .env e defina os parâmetros de acordo com suas necessidades

Faça o pull + bild das imagens e crie a pilha LEMP com:

> docker-compose up -d

Verifique se tudo esta ok com:

> docker ps -a

- Seus apps devem ser salvos no diretório /var/www que caso não exista, será criado pelo docker.
- Para ambiente de produção renomeie o php/7.4-fpm/php.ini-production para php.ini

**Lembre-se**
Sempre que houver a necessidade de alterar algum arquivo de configuração, reinicie o container com:

> docker restart containername

### Configurando virtual hosts
Dentro de nginx/conf renomeie o arquivo site.conf-example para site.conf e adicione quantos hosts forem necessários.
*Se você é esperto e usa linux, altere o /etc/hosts*
*se sofre com windows*, altere o C:\Windows\System32\drivers\etc\hosts 
Adicionando ao final do arquivo o redirecionamento p/ o(s) virtual hosts definido(s) no arquivo /nginx/conf/site.conf, por exemplo:
```
127.0.0.1 mydomain.com
127.0.0.1 otherdomain.com.br
```
*No windows podem haver problemas com o drive bridge, portanto altere no final
do arquivo docker-compose.yml de bridge para nat*
