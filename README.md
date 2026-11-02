# Peixaria Redis: chave-valor no e-commerce de uma peixaria

Grupo 7: Carlos Eduardo, Daniel e Matheus.

Estudo de caso: sessão de login, carrinho de compras e ranking dos produtos mais vendidos do e-commerce de uma peixaria.

**Por que Redis:** é o único da lista que junta TTL nativo, hashes e sorted sets prontos para os três problemas do caso, sem o limite do Memcached (só strings), sem depender de conta na nuvem como o DynamoDB e com mais documentação que o Valkey.

## Como subir o ambiente

Pré-requisito: [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado e aberto.

```bash
git clone https://github.com/matheusmpagel/peixaria-redis
cd peixaria-redis
docker compose up -d
docker compose exec redis redis-cli ping
```

O último comando deve responder `PONG`.

## Carga, operações e consultas

> **Atenção:** os comandos abaixo devem ser rodados direto no terminal do sistema (`PS C:\...>` ou bash), **fora** do prompt `127.0.0.1:6379>` do `redis-cli` (se estiver dentro dele, digite `exit` para sair).

Carrega 40 chaves (12 usuários, 15 produtos, 6 sessões, 6 carrinhos e o ranking). Apaga o que houver no banco antes, e as sessões expiram em 30 minutos, então rode logo antes de usar:

```bash
docker compose exec redis sh -c "redis-cli --raw < /scripts/carga.redis"
```

Roda os exemplos de inserir, consultar, atualizar e excluir:

```bash
docker compose exec redis sh -c "redis-cli --raw < /scripts/operacoes.redis"
```

Roda as 5 consultas do estudo de caso e a demonstração de expiração automática (TTL):

```bash
docker compose exec redis sh -c "redis-cli --raw < /scripts/consultas.redis"
```

> **Nota para Git Bash no Windows:** se o Git Bash converter o caminho `/scripts/...`, use `//scripts/...` (com duas barras) nos comandos acima.

## Uso interativo e desligamento

Para abrir o terminal interativo do Redis (`127.0.0.1:6379>`) e digitar comandos avulsos (`HGETALL`, `ZREVRANGE`, `TTL`, etc.):

```bash
docker compose exec redis redis-cli
```

Para sair do `redis-cli` e voltar ao terminal normal, digite `exit`.

Para desligar o container:

```bash
docker compose down      # mantém os dados
docker compose down -v   # apaga os dados
```

## Documentação da entrega

- **Modelagem:** [docs/modelagem.md](docs/modelagem.md)
- **Consultas do estudo de caso e ponto forte (TTL):** [docs/consultas.md](docs/consultas.md)
- **Comparativo com o modelo relacional (ER, SQL e conclusão):** [docs/comparativo.md](docs/comparativo.md) e [scripts/esquema.sql](scripts/esquema.sql)

## Andamento

- [x] Ambiente
- [x] Modelagem
- [x] Script de carga com 30 ou mais registros
- [x] Exemplos de inserir, consultar, atualizar e excluir
- [x] 5 consultas com print do resultado, mais o TTL como ponto forte
- [x] Comparativo com o relacional: diagrama ER, tabelas, 2 consultas em SQL e conclusão
