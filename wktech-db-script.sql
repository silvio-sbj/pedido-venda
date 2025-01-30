SET FOREIGN_KEY_CHECKS=0;

CREATE DATABASE `wktech`
    CHARACTER SET 'latin1'
    COLLATE 'latin1_swedish_ci';

USE `wktech`;

/* Structure for the `clientes` table : */

CREATE TABLE `clientes` (
  `codigo` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) COLLATE utf8_general_ci NOT NULL,
  `cidade` VARCHAR(255) COLLATE utf8_general_ci NOT NULL,
  `uf` VARCHAR(2) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY USING BTREE (`codigo`)
) ENGINE=InnoDB
AUTO_INCREMENT=21 ROW_FORMAT=DYNAMIC CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

/* Structure for the `pedidos` table : */

CREATE TABLE `pedidos` (
  `numero_pedido` INTEGER(11) NOT NULL,
  `data_emissao` DATETIME NOT NULL,
  `codigo_cliente` INTEGER(11) NOT NULL,
  `valor_total` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY USING BTREE (`numero_pedido`),
  KEY `pedidos_fk` USING BTREE (`codigo_cliente`),
  CONSTRAINT `pedidos_fk` FOREIGN KEY (`codigo_cliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB
ROW_FORMAT=DYNAMIC CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

/* Structure for the `produtos` table : */

CREATE TABLE `produtos` (
  `codigo` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(255) COLLATE utf8_general_ci NOT NULL,
  `preco_venda` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY USING BTREE (`codigo`)
) ENGINE=InnoDB
AUTO_INCREMENT=21 ROW_FORMAT=DYNAMIC CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

/* Structure for the `pedidos_produtos` table : */

CREATE TABLE `pedidos_produtos` (
  `codigo` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `numero_pedido` INTEGER(11) NOT NULL,
  `codigo_produto` INTEGER(11) NOT NULL,
  `quantidade` INTEGER(11) NOT NULL DEFAULT 1,
  `valor_unitario` FLOAT NOT NULL DEFAULT 0,
  `valor_total` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY USING BTREE (`codigo`),
  KEY `pedidos_produtos_fk` USING BTREE (`numero_pedido`),
  KEY `pedidos_produtos_fk2` USING BTREE (`codigo_produto`),
  CONSTRAINT `pedidos_produtos_fk` FOREIGN KEY (`numero_pedido`) REFERENCES `produtos` (`codigo`),
  CONSTRAINT `pedidos_produtos_fk2` FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo`)
) ENGINE=InnoDB
AUTO_INCREMENT=1 ROW_FORMAT=DYNAMIC CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

/* Data for the `clientes` table  (LIMIT 0,500) */

INSERT INTO `clientes` (`codigo`, `nome`, `cidade`, `uf`) VALUES
  (1,'Juliana de Oliveira','São Paulo','SP'),
  (2,'Andréia Dias','São Paulo','SP'),
  (3,'Rita Alves','São Paulo','SP'),
  (4,'Francisca Bezerra','São Paulo','SP'),
  (5,'Aparecida Araujo','São Paulo','SP'),
  (6,'Terezinha Ribeiro','São Paulo','SP'),
  (7,'Luciana Oliveira','São Paulo','SP'),
  (8,'Vera Barbosa','São Paulo','SP'),
  (9,'Cristiane Almeida','São Paulo','SP'),
  (10,'Bruna Alves','São Paulo','SP'),
  (11,'Patrícia Sousa','São Paulo','SP'),
  (12,'Mariana de Carvalho','São Paulo','SP'),
  (13,'Ana de Lima','São Paulo','SP'),
  (14,'Vera Sousa','São Paulo','SP'),
  (15,'Raquel de Araujo','São Paulo','SP'),
  (16,'Bruna Rodrigues','São Paulo','SP'),
  (17,'Eliane Teixeira','São Paulo','SP'),
  (18,'Larissa de Carvalho','São Paulo','SP'),
  (19,'Lúcia Batista','São Paulo','SP'),
  (20,'Vera Cardoso','São Paulo','SP');
COMMIT;

/* Data for the `produtos` table  (LIMIT 0,500) */

INSERT INTO `produtos` (`codigo`, `descricao`, `preco_venda`) VALUES
  (1,'ACUCAR',2.3),
  (2,'SAL',2.45),
  (3,'ARROZ',8),
  (4,'FEIJAO',9),
  (5,'MACARRAO',3.25),
  (6,'LEITE',11),
  (7,'VASOURA',4.3),
  (8,'BALDE',7.1),
  (9,'BATATA',3.4),
  (10,'REPOLHO',1.9),
  (11,'ALHO',2.2),
  (12,'ABACATE',4.78),
  (13,'MACA',5.6),
  (14,'PERA',7.8),
  (15,'UVA',7.2),
  (16,'SABAO',1.1),
  (17,'DESINFETANTE',2.6),
  (18,'DETERGENTE',3),
  (19,'AMACIANTE',5),
  (20,'PICANHA',80);
COMMIT;