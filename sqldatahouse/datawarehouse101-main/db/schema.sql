SELECT YEAR(ms.data_hora_entrada) AS ano, 
       cl.nome_cliente AS cliente, 
       COUNT(*) AS qtd_pedidos
FROM tb_pedido pd
LEFT JOIN tb_mesa ms ON pd.codigo_mesa = ms.codigo_mesa
LEFT JOIN tb_cliente cl ON ms.id_cliente = cl.id_cliente
GROUP BY ano, cliente
ORDER BY ano, qtd_pedidos DESC
LIMIT 1;
