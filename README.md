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

Para abrir o terminal do Redis:

```bash
docker compose exec redis redis-cli
```

Para desligar:

```bash
docker compose down      # mantém os dados
docker compose down -v   # apaga os dados
```

## Carga e operações

Carrega 40 chaves (12 usuários, 15 produtos, 6 sessões, 6 carrinhos e o ranking). Apaga o que houver no banco antes, e as sessões expiram em 30 minutos, então rode logo antes de usar:

```bash
docker compose exec redis sh -c "redis-cli --raw < /scripts/carga.redis"
```

Roda os exemplos de inserir, consultar, atualizar e excluir:

```bash
docker compose exec redis sh -c "redis-cli --raw < /scripts/operacoes.redis"
```

## Modelagem

Ver [docs/modelagem.md](docs/modelagem.md).

## Andamento

- [x] Ambiente
- [x] Modelagem
- [x] Script de carga com 30 ou mais registros
- [x] Exemplos de inserir, consultar, atualizar e excluir
- [ ] 5 consultas com print do resultado, mais o TTL como ponto forte
- [ ] Comparativo com o relacional: diagrama ER, tabelas, 2 consultas em SQL e conclusão
