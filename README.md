# Fase 4 Infra Microservices

## Microsserviços

- [🔐 Authentication Service](https://github.com/FIAP-11SOAT/fase4-auth-service)
- [📚 Catalog Service](https://github.com/FIAP-11SOAT/fase4-catalog-service)
- [🧾 Order Service](https://github.com/FIAP-11SOAT/fase4-order-service)
- [💳 Payment Service](https://github.com/FIAP-11SOAT/fase4-payment-service)
- [🏭 Production Service](https://github.com/FIAP-11SOAT/fase4-production-service)

## Esquema da arquitetura
<img width="1043" height="815" alt="image" src="https://github.com/user-attachments/assets/21c73e6d-10a7-4716-ae70-f984fe81f866" />


## Fluxo de negócio

### Início
O fluxo começa quando o cliente se autentica e, a partir daí, o pedido percorre Order, Payment e Production Service por meio de filas e webhooks até a conclusão da produção.
​

### Autenticação e criação do pedido
O cliente acessa o sistema pelo API Gateway, onde realiza a autenticação e envia as requisições.​
Para criar um pedido, o API Gateway encaminha uma chamada POST `/order` para o Order Service, que busca os produtos selecionados no Catalog Service antes de persistir o pedido em seu banco Postgres.
​
### Disparo do fluxo de pagamento
Após gravar o pedido, o Order Service publica uma mensagem na fila `payment-service-queue`, sinalizando que existe um pedido aguardando pagamento.
O Payment Service consome essa mensagem da fila, monta a requisição e cria o pagamento na API do Mercado Pago, registrando as informações do pagamento em seu banco DynamoDB e vinculando-as ao pedido.
​
### Webhook do Mercado Pago e atualização do pedido
Quando o status do pagamento muda (por exemplo, aprovado), o Mercado Pago envia uma notificação via webhook para o endpoint exposto pelo Payment Service.
O Payment Service valida essa notificação, atualiza o status do pagamento e publica uma mensagem na fila order-service-queue informando ao Order Service que o pedido foi pago.
​
### Liberação para produção
Ao consumir a mensagem de `order-service-queue`, o Order Service altera o status do pedido para “pago” e publica um novo evento na fila `production-service-queue`, indicando que o pedido está liberado para produção.​
O Production Service consome essa fila, cria/atualiza o registro de produção no DynamoDB e expõe endpoints PUT `/{productionId}/started` e `/{productionId}/completed` para marcar o início e a conclusão da produção do pedido.
​
## Infra Geral provisionada aos microsserviços

### Rede (VPC e Sub-redes)

Criação de VPC dedicada com bloco CIDR próprio.
Definição de sub-redes públicas e privadas, com NAT Gateway para saída segura da rede privada.

### API Gateway e VPC Link

API Gateway HTTP com CORS liberado para headers, métodos e origens.
Rota única ANY /{proxy+} encaminhando todas as requisições.
Integração via VPC Link com destino em um ALB interno.

### ALB interno e segurança

Application Load Balancer interno em sub-redes privadas.
Security group do ALB permitindo HTTP apenas a partir do security group associado ao VPC Link.
Tráfego de saída do ALB liberado apenas para a VPC (isolando de internet pública).

### Camada de computação (ECS)

Criação de um cluster ECS para executar os serviços de backend.
Toda comunicação externa chega primeiro no API Gateway → VPC Link → ALB → serviços no ECS.

### Autenticação e chaves JWT

Geração de chave privada RSA via Terraform.
Conversão da chave pública para formato JWK para uso em autenticação JWT.

### Banco de dados (RDS PostgreSQL)

Provisionamento de RDS PostgreSQL usando módulo oficial.
Subnet group usando sub-redes públicas.
Security group liberando acesso à porta 5432 e senha do banco gerada aleatoriamente.

### Segredos e metadados de infraestrutura

Criação de um segredo no Secrets Manager para o projeto.
Armazenamento de: IDs de VPC, API Gateway, ALB, listener, ECS cluster; host, porta, nome, usuário e senha do RDS; chaves JWT (privada, pública e JWK).
