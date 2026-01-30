# Aplicação de Lista Telefônica (v0.16)

Bem-vindo ao repositório da aplicação de lista telefônica desenvolvida para órgãos públicos. Esta ferramenta fornece uma interface intuitiva, responsiva e segura para gerenciar contatos e ramais internos.

**Destaque da Versão 0.16:**

* 🚀 **Instalação Automática:** O sistema cria o banco e importa as tabelas automaticamente no primeiro acesso (inclusive no Docker).
* 🛡️ **Segurança Reforçada:** Implementação de Rate Limit (proteção contra força bruta) e Cloudflare Turnstile (Captcha).
* ⚙️ **Configuração Centralizada:** Todas as regras de acesso (IP) e chaves de segurança geridas em um único arquivo ou variáveis de ambiente.
* ⭐ **Favoritos:** Possibilidade de favoritar contatos (salvos localmente no navegador).
* 📊 **Dashboard:** Gráficos de estatísticas de acesso e distribuição de ramais.

## Índice

* [Requisitos](https://github.com/adrianolerner/lista-telefonica?tab=readme-ov-file#requisitos-de-software)
* [Instalação via Docker (Recomendado)](https://www.google.com/search?q=https://github.com/adrianolerner/lista-telefonica%3Ftab%3Dreadme-ov-file%23instala%25C3%25A7%25C3%25A3o-via-docker)
* [Instalação Tradicional](https://www.google.com/search?q=https://github.com/adrianolerner/lista-telefonica%3Ftab%3Dreadme-ov-file%23instala%25C3%25A7%25C3%25A3o-tradicional)
* [Configuração](https://www.google.com/search?q=https://github.com/adrianolerner/lista-telefonica%3Ftab%3Dreadme-ov-file%23configura%25C3%25A7%25C3%25A3o-centralizada)
* [Segurança e Captcha](https://www.google.com/search?q=https://github.com/adrianolerner/lista-telefonica%3Ftab%3Dreadme-ov-file%23seguran%25C3%25A7a-e-captcha)
* [Uso](https://github.com/adrianolerner/lista-telefonica?tab=readme-ov-file#uso)

## Requisitos de Software

* **Docker & Docker Compose** (para instalação via container).
* OU **PHP 8.1+**, **MariaDB 10.6+**, **Apache 2.4+** (para instalação manual).

## Instalação via Docker (via repositório)

A versão 0.16 foi otimizada para containers. O processo é "Zero-Touch": ao subir o container, o banco de dados é criado e populado automaticamente.

1. **Crie uma pasta em seu servidor chamada `lista-telefonica` e acesse a pasta criada**

```bash
mkdir lista-telefonica
cd lista-telefonica
```

2. **Crie um arquivo chamado `docker-compose.yml` e insira nele o conteudo abaixo:**

```bash
nano dcoker-compose.yml
```

Cole este conteudo, edite as variáveis `DB_USERNAME`, `DB_PASSWORD`, `CF_SITE_KEY`, `CF_SECRET_KEY`, `NOME_ORGAO` (as variáveis do banco dedados na seção APP e no `db_agenda` devem ser iguais) e salve o arquivo:

```yaml
services:
  app:
    image: albiesek/lista-telefonica:latest
    container_name: lista-telefonica
    restart: always
    ports:
      - "8080:80"
    environment:
      - DB_SERVER=db_agenda
      - DB_NAME=agenda
      - DB_USERNAME=admin
      - DB_PASSWORD=admin
      - CF_SITE_KEY=
      - CF_SECRET_KEY=
      - NOME_ORGAO=PREFEITURA DA CIDADE TAL
    depends_on:
      - db_agenda
    networks:
      - agenda_net
    volumes:
      - ./img:/var/www/html/img

  db_agenda:
    image: mysql:8.0
    container_name: db_agenda
    restart: always
    environment:
      MYSQL_DATABASE: agenda
      MYSQL_USER: admin
      MYSQL_PASSWORD: admin
      MYSQL_ROOT_PASSWORD: admin123
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - agenda_net

networks:
  agenda_net:
    driver: bridge

volumes:
  db_data:
```

3. **Sua o container e inclua suas imagens próprias na pasta img criada.**

```bash
sudo docker compose up -d
```

ou

```bash
sudo docker-compose up -d
```

## Instalação via Docker (deploy com build local do container)

A versão 0.16 foi otimizada para containers. O processo é "Zero-Touch": ao subir o container, o banco de dados é criado e populado automaticamente.

1. **Clone o repositório:**
```bash
git clone https://github.com/adrianolerner/lista-telefonica.git
cd lista-telefonica

```


2. **Prepare a persistência de imagens (Opcional):**
Crie uma pasta `img` na raiz se desejar que as fotos dos usuários sejam salvas no seu computador host. O container irá popular esta pasta com os arquivos padrão na primeira execução.
```bash
mkdir img

```


3. **Configure o ambiente:**
Edite o arquivo `docker-compose.yml` e ajuste as variáveis de ambiente conforme necessário (senhas do banco, chaves do Cloudflare, nome do órgão).
4. **Inicie os serviços:**
```bash
docker-compose up -d --build

```


5. **Acesse:**
Abra o navegador em `http://localhost:8080`.
*O sistema detectará o banco vazio e fará a instalação automaticamente em segundo plano.*

---

## Instalação Tradicional

Caso não utilize Docker, siga os passos abaixo no seu servidor Apache/PHP:

1. Clone o repositório para seu diretório web (`/var/www/html`).
2. Certifique-se de que o arquivo `setup.sql` esteja na raiz do projeto junto com o `config.php`.
3. Garanta que o usuário do Apache (`www-data`) tenha permissão de escrita na pasta raiz (para apagar o arquivo SQL após a instalação) e na pasta `img`.
4. Configure as credenciais do banco no arquivo `config.php` (veja abaixo).
5. Acesse a aplicação pelo navegador.

---

## Configuração Centralizada

Esqueça a edição de múltiplos arquivos. Agora, tudo é controlado via **Variáveis de Ambiente** ou editando apenas o arquivo **`config.php`**.

### 1. Variáveis de Ambiente (Environment)

As seguintes variáveis podem ser definidas no `docker-compose.yml` ou no `.env` do servidor:

| Variável | Descrição | Padrão |
| --- | --- | --- |
| `DB_SERVER` | Host do banco de dados | `127.0.0.1` |
| `DB_NAME` | Nome do banco | `agenda` |
| `DB_USERNAME` | Usuário do banco | `admin` |
| `DB_PASSWORD` | Senha do banco | `admin` |
| `NOME_ORGAO` | Nome exibido no topo (Ex: PREFEITURA X) | `NOME DA PREFEITURA` |
| `CF_SITE_KEY` | Chave pública do Cloudflare Turnstile | *(Vazio)* |
| `CF_SECRET_KEY` | Chave secreta do Cloudflare Turnstile | *(Vazio)* |

### 2. Controle de Acesso (IP e Rede)

Para restringir o acesso ao Painel Administrativo apenas para a rede interna (Intranet), ajuste as constantes no início do arquivo `src/config.php` (ou mapeie um volume com o arquivo alterado).

```php
// true = Bloqueia acesso externo ao admin / false = Libera geral
define('RESTRITO_POR_IP', true);

// Define a faixa de IP permitida (aceita curinga *)
define('FAIXA_IP_PERMITIDA', '172.16.0.*'); 

```

*Se o IP do usuário não corresponder à faixa, o botão de login será ocultado e o acesso direto às páginas administrativas será bloqueado.*

## Segurança e Captcha

O sistema possui proteção contra ataques de força bruta (bloqueia o IP após 5 tentativas falhas) e integração opcional com **Cloudflare Turnstile**.

### Ativando o Captcha

Para ativar o Captcha no login, basta preencher as variáveis de ambiente `CF_SITE_KEY` e `CF_SECRET_KEY` no seu `docker-compose.yml`.

* **Ativação Automática:** Se as chaves estiverem preenchidas, o Captcha aparece.
* **Desativação Automática:** Se as variáveis estiverem vazias, o Captcha é desabilitado.
* **Modo Desenvolvedor:** Se você acessar via `localhost` ou IPs locais (`127.0.0.1`, `172.16.0.10`), o Captcha é ignorado automaticamente para facilitar testes, exibindo apenas um alerta visual.

## Uso

* **Acesso Padrão:**
* Usuário: `admin`
* Senha: `admin`
* *Nota: Altere a senha imediatamente no menu Usuários.*


* **Recursos:**
* **Dashboard:** `/dashboard.php` - Estatísticas de acesso.
* **Favoritos:** Clique na estrela (⭐) para fixar contatos no topo.
* **PDF:** Gere a lista telefônica impressa em `/gerapdf.php`.



## Interface e Temas

A aplicação utiliza o **Bootstrap 5.3** e oferece:

* **Dark Mode / Light Mode:** Alternância de tema com persistência local.
* **Responsividade:** Tabela adaptável para dispositivos móveis.

## Contribuição

1. Faça um **Fork** do projeto.
2. Crie uma **Branch** (`git checkout -b feature/melhoria-x`).
3. Faça o **Commit** (`git commit -am 'Adiciona melhoria X'`).
4. **Push** para a branch (`git push origin feature/melhoria-x`).
5. Abra um **Pull Request**.

## Referências

* [FPDF.org](http://fpdf.org) - Geração de PDFs
* [DataTables.net](https://datatables.net) - Gestão de tabelas
* [Cloudflare Turnstile](https://www.cloudflare.com/products/turnstile/) - Proteção anti-robô

---

*Desenvolvido para agilizar a comunicação no serviço público.*
