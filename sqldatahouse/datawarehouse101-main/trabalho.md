
# 1. Proponha um modelo em estrela ou floco de neve com o fato pedido, as seguintes métricas serão obrigatórias- valor total do pedido, valor unitario do prato e quantidade. As dimensões obrigatórias serão, cliente, ano mes e dia.


# 2. Entregar as queries que respondam:

# Qual o cliente que mais fez pedidos por ano
# Qual o cliente que mais gastou em todos os anos
# Qual(is) o(s) cliente(s) que trouxe(ram) mais pessoas por ano

# Qual a empresa que tem mais funcionarios como clientes do restaurante;
# Qual empresa que tem mais funcionarios que consomem sobremesas no restaurante por ano;

- Entregar todos os scripts fisicos atraves de um repositorio git seu que será cadastrado até a segunda-feira 10/06.


# Qual o cliente que mais fez pedidos por ano 
SELECT nome_cliente, SUM(total_gasto) AS total_gasto
FROM (
    SELECT 
        cl.nome_cliente, 
        SUM(pd.quantidade_pedido * p.preco_unitario_prato) AS total_gasto
    FROM tb_pedido pd
    LEFT JOIN tb_prato p ON pd.codigo_prato = p.codigo_prato
    LEFT JOIN tb_mesa ms ON pd.codigo_mesa = ms.codigo_mesa
    LEFT JOIN tb_cliente cl ON ms.id_cliente = cl.id_cliente
    GROUP BY cl.nome_cliente
) AS subquery
GROUP BY nome_cliente
ORDER BY total_gasto DESC
LIMIT 1;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Qual o cliente que mais gastou em todos os anos X
SELECT ano, nome_cliente, num_pedidos
FROM (
    SELECT 
        YEAR(ms.data_hora_entrada) AS ano, 
        cl.nome_cliente, 
        COUNT(*) AS num_pedidos,
        ROW_NUMBER() OVER (PARTITION BY YEAR(ms.data_hora_entrada) ORDER BY COUNT(*) DESC) AS rn
    FROM tb_pedido pd
    LEFT JOIN tb_mesa ms ON pd.codigo_mesa = ms.codigo_mesa
    LEFT JOIN tb_cliente cl ON ms.id_cliente = cl.id_cliente
    GROUP BY YEAR(ms.data_hora_entrada), cl.nome_cliente
) AS subquery
WHERE rn = 1
ORDER BY ano;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Qual(is) o(s) cliente(s) que trouxe(ram) mais pessoas por ano 
SELECT 
    c.nome_cliente,
    m.id_cliente,
    YEAR(m.data_hora_entrada) AS ano,
    COUNT(*) AS num_pessoas
FROM 
    tb_mesa m
JOIN 
    tb_cliente c ON m.id_cliente = c.id_cliente
GROUP BY 
    m.id_cliente, ano
ORDER BY 
    ano DESC, num_pessoas DESC
LIMIT 1;
# Qual a empresa que tem mais funcionarios como clientes do restaurante;
SELECT 
    e.nome_empresa,
    COUNT(DISTINCT m.id_cliente) AS num_funcionarios
FROM 
    tb_mesa m
JOIN 
    tb_beneficio b ON m.id_cliente = b.codigo_funcionario
JOIN 
    tb_empresa e ON b.codigo_empresa = e.codigo_empresa
GROUP BY 
    e.nome_empresa
ORDER BY 
    num_funcionarios DESC
LIMIT 8;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Qual empresa que tem mais funcionarios que consomem sobremesas no restaurante por ano;
SELECT 
    e.nome_empresa,
    YEAR(m.data_hora_saida) AS ano,
    COUNT(DISTINCT b.codigo_funcionario) AS num_funcionarios_sobremesas
FROM 
    tb_mesa m
JOIN 
    tb_beneficio b ON m.id_cliente = b.codigo_funcionario
JOIN 
    tb_empresa e ON b.codigo_empresa = e.codigo_empresa
JOIN 
    tb_tipo_prato t ON t.codigo_tipo_prato = t.codigo_tipo_prato
JOIN 
    tb_pedido p ON m.codigo_mesa = p.codigo_mesa

WHERE 
    t.codigo_tipo_prato = 3
GROUP BY 
    e.nome_empresa, ano
ORDER BY 
     ano DESC, num_funcionarios_sobremesas DESC
LIMIT 30;