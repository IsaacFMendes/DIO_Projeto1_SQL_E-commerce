-- criação do banco de dados para o cenário de E-commerce (refinado)

-- Verifica se um banco de dados chamado "ecommerce" já existe e, se existir, exclui-o.
DROP DATABASE IF EXISTS ecommerce;

-- Cria um novo banco de dados chamado "ecommerce" se ele ainda não existir.
CREATE DATABASE IF NOT EXISTS ecommerce;
use ecommerce;

-- Criando a tabela clientes
create table clientes(
idCliente int auto_increment,
nome varchar(50) not null,
cpf char(11) not null,
endereço varchar(255),
dataNascimento date,
constraint unique_cpf unique(cpf),
primary key(idCliente)
) default character set utf8mb4;

-- Inserindo dados na tabela clientes
insert into clientes values 
(default, 'João','25331464188','Rua teste01','1993-03-10'),
(default, 'Pedro','33331564177', 'Rua teste02','1980-05-01'),
(default, 'Gabriela','87331464101','Rua teste03','2000-03-01'),
(default, 'Ana','01361464163','Rua teste04','1990-04-25'),
(default, 'Bia','25335464144','Rua teste05','1984-03-01');
select * from clientes;

-- Criando a tabela produtos
create table produtos(
idProduto int not null auto_increment,
nome varchar(255) not null,
categoria enum('Eletrônico','Vestuário','Brinquedos','Alimentos','Móveis') not null,
peso float,
primary key (idProduto)
)default character set utf8mb4;

-- Inserindo dados na tabela produtos
insert into produtos values 
(default, 'Tênis','Vestuário','0.8'),
(default, 'Notebook','Eletrônico','3.2'),
(default, 'Barra Protéica','Alimentos','1.5'),
(default, 'Mesa Escritório','Móveis','15.1'),
(default, 'Xbox','Eletrônico','4.2');
select * from produtos;

-- criando tabela vendedores
create table vendedores(
idVendedor int not null auto_increment,
nome varchar(255) not null,
identificacaoCliente enum('CNPJ','CPF'),
numeroIdenCliente  char(11),
localizacao varchar(100),
primary key(idVendedor),
constraint numero_IdenClient unique (numeroIdenCliente)
)default character set utf8mb4;

 -- Inserindo dados na tabela vendedores
insert into vendedores values 
(default, 'David','CNPJ','25331464188','ruaF'),
(default, 'Samuel','CNPJ','33331564177','ruaG'),
(default, 'Fernanda','CPF','87331464101','ruaH'),
(default, 'Gomes','CPF','01361464163','ruaI'),
(default, 'Juliana','CNPJ','25335464144','ruaJ');
select * from vendedores;


-- Criando a tabela fornecedores
 create table fornecedores(
 idFornecedor int not null auto_increment,
 razaoSocial varchar(255),
 cnpj char(14),
 localizacao varchar(100),
 primary key(idFornecedor),
 constraint unique_cnpj unique(cnpj)
 )default character set utf8mb4;
 
  -- Inserindo dados na tabela fornecedores
insert into fornecedores (razaoSocial,cnpj,localizacao)values 
('David Comercio LTDA','25331464188','ruaF'),
('Manuela Joias','324367564176','ruaL'),
('Patrícia Presentes','55333464101','ruaM'),
('Bento Negocios','01361460063','ruaN'),
('Juliana Artigos de Luxo','25335464144','RuaW');
select * from fornecedores;

-- criando relacionamento "pedidos" (relacionamento n para n entre clientes e produtos)
create table pedidos(
idPedido int not null auto_increment,
idCliente int,
data_pedido date,
valor decimal (10,2),
pagamento BOOLEAN DEFAULT FALSE,
statusPedido enum('Em andamento','Separando o pedido','Em trânsito','Entregue') not null default 'Em andamento',
formaEnvio enum('correios','transportadora') not null,
códigoRastreio varchar(13),
formaPagamento enum('crédito','débito','pix','boleto') not null,
n_notaFiscal char(9) not null ,
primary key(idPedido),
foreign key (idCliente) references clientes(idCliente),
constraint uniqueNotaFiscal unique(n_notaFiscal)
)default character set utf8mb4;

insert into pedidos(idCliente,data_pedido,valor,pagamento,statusPedido,formaEnvio,códigoRastreio,formaPagamento,n_notaFiscal) values
(default,'2023-03-01','100',True,'Em andamento','correios','CD948852221','crédito',555965813),
(default,'2023-06-23','1500',False,'Em andamento','correios','CD948852221','pix',635976812),
(default,'2023-05-15','150',default,'Em andamento','transportadora','AB948853546','crédito',125903882),
(default,'2023-04-04','300',True,'Em trânsito','transportadora','IJ948859836','crédito',885900809),
(default,'2023-01-08','50',True,'Entregue','correios','FG947759374','crédito',685955812);

select * from pedidos;

create table entregas(
    idEntrega int not null auto_increment,
    idPedido int,
    statusEntrega enum('Em trânsito','Entregue') not null,
    codigoRastreio varchar(50) not null,
    primary key(idEntrega),
    foreign key (idPedido) references pedidos(idPedido)
);

CREATE TABLE pagamentos (
    idPagamento int not null auto_increment,
    idCliente int,
    formaPagamento varchar(50) not null,
    primary key(idPagamento),
    foreign key (idCliente) references clientes(idCliente)
);

create table pedidosProdutos(
idpedidoProduto int not null auto_increment,
idPedido int DEFAULT NULL,
idProduto int DEFAULT NULL,
PRIMARY KEY (idpedidoProduto),
foreign key (idPedido) references pedidos(idPedido),
foreign key (idProduto) references produtos(idProduto)
)default character set utf8mb4;
-- Inserindo dados na tabela pedidos

create table estoqueProdutos(
idProduto int not null auto_increment,
quantidade int default 0,
localizacao varchar(100) not null,
primary key(idProduto , localizacao),
foreign key (idProduto) references produtos(idProduto)
)default character set utf8mb4;


-- Inserindo dados do estoque
insert into estoqueProdutos values 
(default,'200','localidade01'),
(default,'100','localidade02'),
(default,'50','localidade03'),
(default,'350','localidade04'),
(default,'150','localidade05');

select * from estoqueProdutos;


 -- criando relacionamento "produtosVendedores" (relacionamento n para n entre vendedores e produtos)

 create table produtosVendedores(
idProduto int,
idVendedor int,
quantidade int default 1,
primary key (idProduto,idVendedor),
foreign key(idProduto) references produtos(idProduto),
foreign key(idVendedor) references vendedores(idVendedor)
)default character set utf8mb4;

select * from produtosVendedores;

 -- criando relacionamento "produtosFornecedores" (relacionamento n para n entre Fornecedores e produtos)
create table produtosFornecedores(
idProduto int,
idFornecedor int,
quantidade int,
primary key(idProduto,idFornecedor),
foreign key(idProduto) references produtos(idProduto),
foreign key(idFornecedor) references fornecedores(idFornecedor)
)default character set utf8mb4;


 select*from produtosFornecedores;
 
 -- Queries SQL (exemplos)

 -- Consulta 1: Total de pedidos feitos por cada cliente
select cl.idCliente, count(idPedido) as TotalPedidos from clientes as cl
left join pedidos as p on cl.idCliente = p.idPedido
group by cl.idCliente;

-- Consulta 2: Vendedores que também são fornecedores
SELECT v.nome AS Vendedor, f.razaoSocial AS Fornecedor
FROM vendedores v
INNER JOIN produtosVendedores pv ON v.idVendedor = pv.idVendedor
INNER JOIN produtosFornecedores pf ON pv.idProduto = pf.idProduto
INNER JOIN fornecedores f ON pf.idFornecedor = f.idFornecedor;

-- Consulta 3: Produtos fornecidos e seus estoques
SELECT p.nome AS Produto, f.razaoSocial AS Fornecedor, e.quantidade AS Estoque
FROM produtos p
INNER JOIN produtosFornecedores pf ON p.idProduto = pf.idProduto
INNER JOIN fornecedores f ON pf.idFornecedor = f.idFornecedor
INNER JOIN estoqueProdutos e ON p.idProduto = e.idProduto;

-- Consulta 4: Nomes dos fornecedores e nomes dos produtos
SELECT f.razaoSocial AS Fornecedor, p.nome AS Produto
FROM fornecedores f
INNER JOIN produtosFornecedores pf ON f.idFornecedor = pf.idFornecedor
INNER JOIN produtos p ON pf.idProduto = p.idProduto;

-- Consulta 5: Total de produtos em estoque por categoria
SELECT categoria, COUNT(idProduto) AS TotalProdutos
FROM produtos
GROUP BY categoria;


