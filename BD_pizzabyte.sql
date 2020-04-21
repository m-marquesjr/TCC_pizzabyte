create database bd_pizzabyte;

USE bd_pizzabyte;

CREATE TABLE Login(

Id 				INT UNSIGNED NOT NULL AUTO_INCREMENT,
Tipo			INT UNSIGNED	 					,
Email 			VARCHAR		(100)					,
Senha	 		VARCHAR		(030)					,
Situacao		INT									,
PRIMARY KEY		(Id),
Unique key		(Id, Situacao)
);
ALTER TABLE Adicionais
DROP FOREIGN KEY FK_Itenspedido



DELIMITER $$ 
DROP PROCEDURE IF EXISTS PRC_IncluirLogin $$ 
CREATE PROCEDURE PRC_IncluirLogin
(
	IN pTipo			INT
, 	IN pEmail		 	VARCHAR (100)
,	IN pSenha			VARCHAR (030)
,	OUT pId				INT

) 
main: BEGIN 

	INSERT INTO 
		Login
	(
	 	Tipo
    , 	Email
    ,	Senha
    ,	Situacao
    ) 
	VALUES
    (
		pTipo
	, 	pEmail
    ,	pSenha    
    ,	1
    );
    
    SET pId 
		= 
    LAST_INSERT_ID();
    
END 
$$ DELIMITER ;



DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarLogin $$
CREATE PROCEDURE 			PRC_EditarLogin
(
	IN  pId			 		 INT
,	IN  pTipo 				 INT 
, 	IN  pEmail		 		 VARCHAR (100)
,	IN  pSenha				 VARCHAR (030)
)
main: BEGIN 

	UPDATE 		
		Login
	SET 	
	  Tipo = pTipo
    , Email = pEmail
    , Senha = pSenha
    WHERE 
		Id = pId;
	
END

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_VerificarLogin $$
CREATE PROCEDURE 			PRC_VerificarLogin 
(
	 IN pEmail VARCHAR (100)
,	 IN	pSenha VARCHAR (030)
)
main: BEGIN 

	SELECT
			Id
,			Situacao
,			Tipo
    
	FROM 
			Login
	
    WHERE	
			Email = pEmail
	AND	
			Senha = pSenha;

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EsquecerSenha $$
CREATE PROCEDURE 			PRC_EsquecerSenha 
(
	 IN pEmail VARCHAR (100)
)
main: BEGIN 

	SELECT
			Senha
	FROM 
			Login
	
    WHERE	
			Email = pEmail;
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ConsultarLogin $$
CREATE PROCEDURE 			PRC_ConsultarLogin 
(
	 IN pId 			INT
)
main: BEGIN 

	SELECT
			*
    
	FROM 
			Login
	
    WHERE	
			Id = pId;

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarSituacao $$
CREATE PROCEDURE 			PRC_EditarSituacao
(
	IN  pId			 		 INT
,	IN 	pSituacao			 INT
)
main: BEGIN 

	UPDATE 		
		Login
	SET 
	     Situacao = pSituacao
    WHERE 
		Id = pId;
	
END

$$ DELIMITER ;



-- CLIENTES

CREATE TABLE Cliente(
	
FKId 					INT UNSIGNED NOT NULL PRIMARY KEY	,
Nome 					VARCHAR		(146),
TelefoneResidencial		CHAR		(013),
TelefoneCelular			CHAR		(014),
Endereco 				VARCHAR		(180),
Cidade					INT				 ,
Complemento 			VARCHAR		(100),
FKSituacao				INT				 ,
TaxadeEntrega			DOUBLE			 ,
CONSTRAINT FKCliente_Login FOREIGN KEY(FKId, FKSituacao) REFERENCES Login(Id, Situacao) on update cascade
);

/*PROCEDURES CLIENTE*/

DELIMITER $$ 
DROP PROCEDURE IF EXISTS PRC_NovoCliente $$
CREATE PROCEDURE PRC_NovoCliente
(
	IN pFKId					INT
,	IN pNome 					VARCHAR	(030)
, 	IN pTelefoneResidencial 	CHAR	(014)
, 	IN pTelefoneCelular			CHAR	(014)
, 	IN pEndereco 				VARCHAR (180)
,	IN pCidade					INT
, 	IN pComplemento				VARCHAR (100)
,	IN pTxEntrega				DOUBLE
,	OUT pId						INT
)
main: BEGIN 

	INSERT INTO 
		Cliente
	(
		FKId
	, 	Nome
    , 	TelefoneResidencial
    ,	TelefoneCelular
    , 	Endereco
	,	Cidade   
    , 	Complemento
	,   FKSituacao
    , 	TaxadeEntrega
    ) 
	VALUES
    (
		pFKId
	,	pNome
	, 	pTelefoneResidencial
    ,	pTelefoneCelular
    , 	pEndereco
	,	pCidade
    , 	pComplemento
    ,	1
    ,	pTxEntrega
    );
    
	SET pId 
		= 
    LAST_INSERT_ID();
    
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ListadeClientes $$
CREATE PROCEDURE 			PRC_ListadeClientes()
main: BEGIN 

	SELECT
			FKId
	,		Nome
    ,		TelefoneResidencial
    ,		TelefoneCelular
    ,		FKSituacao
    
	FROM 
			Cliente;
    

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DetalhesCliente $$
CREATE PROCEDURE 			PRC_DetalhesCliente
(
	IN pFKId 	   INT
)
main: BEGIN 

	SELECT 
		* 
	FROM 
		Cliente
	WHERE 
		FKId	=	pFKId;

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarCliente $$
CREATE PROCEDURE 			PRC_EditarCliente
(
		IN pFKId 					INT
    ,	IN pNome 					VARCHAR	(100)
    ,	IN pTelefoneResidencial		CHAR 	(014)
    ,	IN pTelefoneCelular			CHAR 	(014)
    , 	IN pEndereco 				VARCHAR (255)
	,	IN pCidade					INT
    ,	IN pComplemento 			VARCHAR (255)
    ,	IN pTxEntrega				DOUBLE
)
main: BEGIN 

	UPDATE 		
		Cliente
	SET 
		FKId					=	pFKId
	,	Nome					=	pNome
    ,	TelefoneResidencial		=	pTelefoneResidencial
    ,	TelefoneCelular			= 	pTelefoneCelular
    ,	Endereco 				=	pEndereco
	,	Cidade					=	pCidade
    ,	Complemento				=	pComplemento
    ,	TaxadeEntrega			=	pTxEntrega  
    WHERE 
		FKId				=	pFKId;
        
END
$$ DELIMITER ;


DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_VerificarCliente $$
CREATE PROCEDURE 			PRC_VerificarCliente
(
	IN  pTelefone 	VARCHAR(014)
,	OUT pId			INT
)
main: BEGIN 

SET pId = 0;

SELECT 
		FKId
FROM 
		Cliente 
WHERE
		TelefoneResidencial	=	pTelefone
OR
		TelefoneCelular	=	pTelefone
INTO
		pId;        

END
$$ DELIMITER ;

-- PRODUTO

CREATE TABLE Produto(

Id 				INT UNSIGNED NOT NULL AUTO_INCREMENT,
Tipo 			INT				 					,
Nome 			VARCHAR		(050)					,
Detalhes 		VARCHAR		(180)					,
Quantidade		INT DEFAULT    0					,
Valor 			DOUBLE	NOT NULL 					,
Situacao		INT									,
PRIMARY KEY		(Id)
);

-- PROCEDURES PRODUTO

DELIMITER $$ 
DROP PROCEDURE IF EXISTS PRC_NovoProduto $$
CREATE PROCEDURE PRC_NovoProduto
(
	IN pTipo 			INT
, 	IN pNome			VARCHAR	(050)
, 	IN pDetalhes 		VARCHAR (180)
,	IN pQuantidade		INT
, 	IN pValor			DOUBLE
,	IN pSituacao		INT
) 
main: BEGIN 

	INSERT INTO 
		Produto
	(
	 	Tipo
    , 	Nome
    , 	Detalhes
    ,	Quantidade
    , 	Valor
    ,	Situacao
    ) 
	VALUES
    (
		pTipo
	, 	pNome
    , 	pDetalhes
    ,	pQuantidade
    , 	pValor
    ,	pSituacao
    );
    
END 
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ListadeProdutos$$
CREATE PROCEDURE 			PRC_ListadeProdutos
(
		IN pTipo 	INT
) 
main: BEGIN 
	
    
    SELECT
			Id
	,		Tipo
	,		Nome
    ,		Detalhes
    ,		Quantidade
    ,		Valor
    ,		Situacao
    
	FROM 
			Produto
            
	WHERE
			Tipo = pTipo
	
	ORDER BY
			Nome
	ASC;

END 
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DetalhesProduto $$
CREATE PROCEDURE 			PRC_DetalhesProduto
(
	IN pId int    
) 
main: BEGIN 

	SELECT 
		* 
	FROM 
		Produto
	WHERE 
		Id	=	pId;

END 
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarProduto $$
CREATE PROCEDURE 			PRC_EditarProduto
(
		IN pId 			INT	
	, 	IN pTipo        INT
    ,	IN pNome 		VARCHAR (050)
    , 	IN pDetalhes 	VARCHAR (180)
    ,	IN pQuantidade	INT
    ,	IN pValor	 	DOUBLE
) 
main: BEGIN 

	UPDATE 		
		Produto
	SET 
		Nome			=	pNome
	,   Tipo			=	pTipo
    ,	Detalhes		=	pDetalhes
    ,	Valor			=	pValor  
    ,	Quantidade		= 	pQuantidade
    WHERE 
		Id				=	pId;
        
END 
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarQuantidade $$
CREATE PROCEDURE 			PRC_EditarQuantidade
(
		IN pId 			INT	
    ,	IN pQuantidade 	INT
) 
main: BEGIN 

	UPDATE 		
		Produto
	SET 
		Quantidade		=	pQuantidade
    WHERE 
		Id				=	pId;
        
END 

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DeletarProduto $$
CREATE PROCEDURE 			PRC_DeletarProduto
(
	IN  pId			 		 INT
,	IN 	pSituacao			 INT
)
main: BEGIN 

	UPDATE 		
		Produto
	SET 
	     Situacao = pSituacao
    WHERE 
		Id = pId;
	
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_VerificarProduto $$
CREATE PROCEDURE 			PRC_VerificarProduto
(
	IN pNome	VARCHAR(050)
,	IN pTipo	INT
,	OUT pId		INT
) 
main: BEGIN 

SET		pId = 0;

SELECT
		Id
FROM 
		Produto
WHERE
		Nome	=	pNome
AND 	
		Tipo	=	pTipo
INTO
		pId;

END
$$ DELIMITER ;

-- FORMA DE PAGAMENTO

CREATE TABLE FormaPagamento(
Id 			   			   INT NOT NULL AUTO_INCREMENT	     ,
Nome					   VARCHAR (155)	     		     ,
Situacao				   INT								 ,
PRIMARY KEY	(Id)				         				          	           
);

-- PROCEDURES FORMA DE PAGAMENTO

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_VerificarFormaPagamento $$
CREATE PROCEDURE 			PRC_VerificarFormaPagamento
(
	IN pNome	VARCHAR(155)
,	OUT pId		INT
) 
main: BEGIN 

SET		pId = 0;

SELECT
		Id
FROM 
		FormaPagamento
WHERE
		Nome	=	pNome
INTO
		pId;

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS PRC_IncluirFormaPagamento $$ 
CREATE PROCEDURE PRC_IncluirFormaPagamento
(
	IN pNome				VARCHAR(155)
,	IN pSituacao			INT
,   OUT pId					INT

) 
main: BEGIN 

	INSERT INTO 
		FormaPagamento
	(
	 	Nome
	,	Situacao
    ) 
	VALUES
    (
		pNome
,		pSituacao
	);
    
     SET pId 
		= 
    LAST_INSERT_ID();
    
END 
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DeletarFormaPagamento $$
CREATE PROCEDURE 			PRC_DeletarFormaPagamento
(
	IN  pId			 		 INT
,	IN 	pSituacao			 INT
)
main: BEGIN 

	UPDATE 		
		FormaPagamento
	SET 
	     Situacao = pSituacao
    WHERE 
		Id = pId;
	
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarFormaPagamento $$
CREATE PROCEDURE 			PRC_EditarFormaPagamento
(	
 	IN 	pId	 				INT UNSIGNED
,	IN 	pNome				VARCHAR (155)
) 
main: BEGIN 

	UPDATE 		
		FormaPagamento
	SET 
		Nome			=	pNome
    WHERE 
		Id				=	pId;
        
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_FormasPagamento $$
CREATE PROCEDURE 			PRC_FormasPagamento()
main: BEGIN 

	SELECT
			*
    
	FROM 
			FormaPagamento;

END

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_FormaPagamento $$
CREATE PROCEDURE 			PRC_FormaPagamento
(
	IN pId int    
)
main: BEGIN 

	SELECT 
		* 
	FROM 
		FormaPagamento
	WHERE 
		Id	=	pId;

END
$$ DELIMITER ;

-- PEDIDO

CREATE TABLE Pedido(
Id			         INT UNSIGNED NOT NULL AUTO_INCREMENT              		   ,
FKClienteId		 	 INT UNSIGNED	 					                       ,
FKPagamentoId		 INT DEFAULT 1                                             ,
DataVenda			 DATETIME	 		 					                   ,
DataEntrega			 DATETIME												   ,
ValorTotal			 DECIMAL(5,2)   DEFAULT 0.0			                       ,
Troco				 DECIMAL(5,2)   DEFAULT 0.0								   ,
PedidoStatus         INT	DEFAULT 1						                   ,
Plataforma			 INT													   ,
PRIMARY KEY (Id)					 					             		   ,
CONSTRAINT FKCliente FOREIGN KEY(FKClienteId) REFERENCES Cliente(FKId)         ,
CONSTRAINT FKPagamento FOREIGN KEY(FKPagamentoId) REFERENCES FormaPagamento(Id) 
);

-- PROCEDURES PEDIDO

DELIMITER $$ 
DROP PROCEDURE IF EXISTS PRC_IncluirPedido $$ -- testei
CREATE PROCEDURE PRC_IncluirPedido
(
	IN pClienteId 		INT
, 	IN pData		 	DATETIME
,	IN pPedidoStatus	INT
,	IN pPlataforma		INT
,	IN pValor			DECIMAL
,	IN pTroco			DECIMAL
,	OUT	pId				INT

) 
main: BEGIN 

	INSERT INTO 
		Pedido
	(
	 	FKClienteId
    , 	DataVenda	
    ,	PedidoStatus
    ,	Plataforma
    ,	ValorTotal
    ,	Troco
    ) 
	VALUES
    (
		pClienteId
	, 	pData 
    ,	pPedidoStatus
    ,	pPlataforma
    ,	pValor
    ,	pTroco
    );
    
    SET pId 
		= 
    LAST_INSERT_ID();
    
END 
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarPedido $$
CREATE PROCEDURE 			PRC_EditarPedido
(	
 	IN 	pId	 				INT UNSIGNED
, 	IN 	pTipoEntrega		INT	
)
main: BEGIN 

	UPDATE 		
		Pedido
	SET		
    	TipoEntrega = pTipoEntrega
    WHERE 
		Id	=	pId;
        
END

$$ DELIMITER;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_AtualizarValor $$ -- testei
CREATE PROCEDURE 			PRC_AtualizarValor
(
	  IN pId					INT 
	, IN pValor				 	DECIMAL (5,2)
) 
main: BEGIN 

UPDATE 		
		Pedido
	SET 
		ValorTotal	=	pValor
	WHERE 
		Id = pId;
		
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_AtualizarTroco $$ -- testei
CREATE PROCEDURE 			PRC_AtualizarTroco
(
	  IN pId					INT 
	, IN pTroco				 	DECIMAL (5,2)
) 
main: BEGIN 

UPDATE 		
		Pedido
	SET 
		Troco	=	pTroco
	WHERE 
		Id = pId;
		
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ConsultarPedido $$ -- testei
CREATE PROCEDURE 			PRC_ConsultarPedido
(
	IN pPedidoId 	INT  
) 
main: BEGIN 

SELECT  
	  	  
		*
FROM 
		 Pedido        

WHERE
		Id	=	pPedidoId
        
ORDER BY

		DataVenda
        
DESC;

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_AtualizarStatus $$
CREATE PROCEDURE 			PRC_AtualizarStatus   
(
	  IN pId					INT 
	, IN pStatus 				INT
    , IN pDataEntrega			DATETIME
) 
main: BEGIN 

	IF pStatus != 3 
    
	THEN

	UPDATE 		
		Pedido
	SET 
		PedidoStatus	=	pStatus
	WHERE 
		Id = pId;
	
    ELSE 
    
    UPDATE 		
		Pedido
	SET 
		PedidoStatus	=	pStatus
,       DataEntrega		= 	pDataEntrega
	WHERE 
		Id = pId;
        
	END IF;		

END
$$ DELIMITER;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_AtualizarFormaPagamento $$
CREATE PROCEDURE 			PRC_AtualizarFormaPagamento   
(
	  IN pId					INT 
	, IN pPagamentoId 			INT
) 
main: BEGIN 

UPDATE 		
		Pedido
	SET 
		FKPagamentoId	=	pPagamentoId
	WHERE 
		Id = pId;
	
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ConsultarPedidosStatus $$
CREATE PROCEDURE 			PRC_ConsultarPedidosStatus
(	 
	 IN pStatus 				INT
) 
main: BEGIN 

SELECT		
		 *
FROM 
		 Pedido      
WHERE

		 PedidoStatus = pStatus
ORDER BY
		 DataVenda
DESC;
		
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ConsultarPedidosStatusData $$
CREATE PROCEDURE 			PRC_ConsultarPedidosStatusData
(	 
	 IN pStatus 				INT
,	 IN pDataInicio				DATETIME
,	 IN pDataFim				DATETIME
) 
main: BEGIN 

SELECT		
		 *
FROM 
		 Pedido      
WHERE

		 PedidoStatus = pStatus AND 
		 DataVenda BETWEEN pDataInicio AND pDataFim
ORDER BY
		 DataVenda
DESC;         

END
$$ DELIMITER ;

-- ITENS PEDIDO

CREATE TABLE ItensPedido(
Id 			   			   INT UNSIGNED NOT NULL AUTO_INCREMENT	  			   ,
FKPedidoId				   INT UNSIGNED	                          	           ,
FKProdutoId1			   INT UNSIGNED                           			   ,
FKProdutoId2			   INT UNSIGNED                           			   ,
Fator					   DOUBLE		                           			   ,
PrecoUnitario       	   DECIMAL (5,2)	 				      			   , 
ProdutoQuantidade		   INT	UNSIGNED       				      			   ,
PrecoTotal			       DECIMAL (5,2) DEFAULT 0.0		      			   , 
Observacao				   VARCHAR (155)									   ,
PRIMARY KEY	(Id)				         				          	           ,
CONSTRAINT FKProduto1 FOREIGN KEY(FKProdutoId1) REFERENCES Produto(Id)  	   ,
CONSTRAINT FKProduto2 FOREIGN KEY(FKProdutoId2) REFERENCES Produto(Id)  	   ,
CONSTRAINT FKPedido FOREIGN KEY(FKPedidoId) REFERENCES Pedido(Id)
);

-- PROCEDURE ITENS PEDIDO

DELIMITER $$
DROP PROCEDURE IF EXISTS PRC_IncluirProduto $$ -- testeiw
CREATE PROCEDURE PRC_IncluirProduto
(	
 	IN 	pPedidoId	 		INT UNSIGNED
,	IN 	pProdutoId1			INT UNSIGNED
,	IN 	pProdutoId2			INT UNSIGNED
,	IN	pFator  		    DOUBLE		                           			   
, 	IN 	pPrecoUnitario 	    DECIMAL (5,2)
, 	IN 	pProdutoQuantidade	INT	UNSIGNED
,	IN 	pPrecoTotal			DECIMAL (5,2)
,	IN  pObservacao			VARCHAR (155)
,	OUT	pId					INT
) 
main: BEGIN 

	INSERT INTO 
		ItensPedido
	(
	 	FKProdutoId1
    , 	FKProdutoId2
    ,   Fator
    , 	FKPedidoId
    , 	PrecoUnitario
    , 	ProdutoQuantidade
	,   PrecoTotal
    ,	Observacao
    ) 
	VALUES
    (
		pProdutoId1
	, 	pProdutoId2
    ,   pFator
	, 	pPedidoId
    , 	pPrecoUnitario
    , 	pProdutoQuantidade
	,   pPrecoTotal
    ,	pObservacao
    );
    SET pId 
		= 
    LAST_INSERT_ID();

END 

$$ DELIMITER;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ValorTotal $$ -- testei
CREATE PROCEDURE 			PRC_ValorTotal
(
	IN pPedidoId 	INT
) 
 BEGIN 

SELECT SUM(PrecoTotal) 
FROM 
		ItensPedido 
WHERE
		FKPedidoId	=	pPedidoId;

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ConsultarItensPedido $$ -- testei
CREATE PROCEDURE 			PRC_ConsultarItensPedido
(
	IN pPedidoId 	INT
) 
main: BEGIN 

SELECT 	    
	  *
FROM 
	  ItensPedido 
	  
WHERE 
	  FKPedidoId = pPedidoId;

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DeletarItem $$
CREATE PROCEDURE 			PRC_DeletarItem
(
	IN pId INT
)
main: BEGIN 

	DELETE FROM 
		ItensPedido
	WHERE 
		Id		=	pId; 
        
END

$$ DELIMITER;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DeletarItensPedido $$
CREATE PROCEDURE 			PRC_DeletarItensPedido
(
	IN pPedidoId INT
)
main: BEGIN 

	DELETE FROM 
		ItensPedido
	WHERE 
		FKPedidoId		=	pPedidoId; 
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarItensPedido $$
CREATE PROCEDURE 			PRC_EditarItensPedido
(	
 	IN 	pId	 				INT UNSIGNED
, 	IN 	pProdutoQuantidade	INT	UNSIGNED
,	IN  pObservacao			VARCHAR	(155)
) 
main: BEGIN 

	UPDATE 		
		ItensPedido
	SET 
		
    	ProdutoQuantidade 	=	pProdutoQuantidade
    ,	Observacao			=	pObservacao
    WHERE 
		Id				=	pId;
        
END
$$ DELIMITER;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_AtualizarValorItens $$ 
CREATE PROCEDURE 			PRC_AtualizarValorItens
(
	  IN pId					INT 
	, IN pValor					DECIMAL
) 
main: BEGIN 

   UPDATE 		
		ItensPedido
	SET 
		PrecoTotal	=	pValor
	WHERE 
		Id = pId;
		

END
$$ DELIMITER ;

-- ADICIONAIS

CREATE TABLE Adicionais(
Id 			 		 INT UNSIGNED NOT NULL AUTO_INCREMENT              		      ,
FKItensPedidoId		 INT UNSIGNED 	 				                       	      ,
FKProdutoId			 INT UNSIGNED 						                          ,
Valor				 DECIMAL(5,2)  DEFAULT 0    					              ,
Observacao		     VARCHAR(155)												  ,
PRIMARY KEY (Id)					 					                   	      ,
CONSTRAINT FK_ProdutoId FOREIGN KEY(FKProdutoId) REFERENCES Produto(Id)		      ,
CONSTRAINT FK_Itenspedido FOREIGN KEY(FKItensPedidoId) REFERENCES ItensPedido(Id) on delete cascade
);

-- PROCEDURES DOS ADICIONAIS

DELIMITER $$ 
DROP PROCEDURE IF EXISTS PRC_IncluirAdicional $$ 
CREATE PROCEDURE PRC_IncluirAdicional
(
	IN pItensPedidoId	INT
, 	IN pProdutoId	 	INT
,	IN pValor			DECIMAL(5,2)
,	IN pObservacao		VARCHAR (155)
,	OUT pId				INT

) 
main: BEGIN 

	INSERT INTO 
		Adicionais
	(
	 	FKItensPedidoId
    , 	FKProdutoId
    ,	Valor
    ,	Observacao
    ) 
	VALUES
    (
		pItensPedidoId
	, 	pProdutoId
    ,	pValor
    ,	pObservacao
    );
    SET pId 
		= 
    LAST_INSERT_ID();
    
END

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ValorTotalAdicionais $$ -- testei
CREATE PROCEDURE 			PRC_ValorTotalAdicionais
(
	IN pItensPedidoId 	INT
,   OUT pValor			DECIMAL
) 
 BEGIN 

SELECT SUM(Valor)
INTO
		pValor 
FROM 
		Adicionais 
WHERE
		FKItensPedidoId	=	pItensPedidoId;

END

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DeletarAdicional $$
CREATE PROCEDURE 			PRC_DeletarAdicional
(
	IN pId INT
)
main: BEGIN 

	DELETE FROM 
		Adicionais
	WHERE 
		Id		=	pId; 
END
$$ DELIMITER ; 

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DeletarAdicionaisItem $$
CREATE PROCEDURE 			PRC_DeletarAdicionaisItem
(
	IN pItemId INT
)
main: BEGIN 

	DELETE FROM 
		Adicionais
	WHERE 
		FKItensPedidoId		=	pItemId; 
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarAdicional $$
CREATE PROCEDURE 			PRC_EditarAdicional
(	
 	IN 	pId	 				INT UNSIGNED
,	IN 	pObservacao			VARCHAR (155)
) 
main: BEGIN 

	UPDATE 		
		Adicionais
	SET 
		Observacao			=	pObservacao
    WHERE 
		FKItensPedidoId		=	pId;
        
END
$$ DELIMITER ;

DELIMITER $$ 

DROP PROCEDURE IF EXISTS 	PRC_ConsultarAdicionais $$ -- testei
CREATE PROCEDURE 			PRC_ConsultarAdicionais
(
	IN pItensPedidoId 	INT  
) 
main: BEGIN 

SELECT  
	  	  
		*      
FROM 
		 Adicionais       

WHERE
		FKItensPedidoId	=	pItensPedidoId;

END
$$ DELIMITER ;

CREATE TABLE Funcionario(
FKId				INT UNSIGNED PRIMARY KEY							    ,
Nome 			    VARCHAR		(146)										,
TelefoneCelular	    CHAR		(014)										,
TelefoneResidencial	CHAR		(013)										,
Endereco 			VARCHAR		(180)										,
Complemento 		VARCHAR		(100)										,
FKSituacao			INT														,
CONSTRAINT FKFuncionario_Login FOREIGN KEY(FKId, FKSituacao) REFERENCES Login(Id, Situacao) on update cascade
);


/*Procedures Funcionario*/

/*Procedure de Cadastrar um novo FUNCIONARIO*/
DELIMITER $$ 
DROP PROCEDURE IF EXISTS PRC_NovoFuncionario $$
CREATE PROCEDURE PRC_NovoFuncionario
(
	IN  pFKId			 	 INT 
,	IN  pNome 				 VARCHAR (030)
, 	IN  pTelefoneCelular 	 CHAR	 (014)
, 	IN  pTelefoneResidencial CHAR 	 (013)
,	IN  pEndereco 	      	 VARCHAR (180)
,   IN  pComplemento 	     VARCHAR (100)
,   OUT pId					 INT
)
main: BEGIN 

	INSERT INTO 
		Funcionario
	(
		FKId
	, 	Nome
    , 	TelefoneCelular
    ,	TelefoneResidencial
    ,	Endereco
    ,	Complemento
    ,	FKSituacao
    ) 
	VALUES
    (
		pFKId
	, 	pNome
    , 	pTelefoneCelular
    ,	pTelefoneResidencial
    ,	pEndereco
    ,	pComplemento
    ,	1

    );
    
	SET pId 
		= 
    LAST_INSERT_ID();

    
END
$$ DELIMITER ;


/*Procedure de gerar uma lista de todos os Clientes cadastrados, exibindo o ID, Nome e o Telefone */
DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_ListadeFuncionarios $$
CREATE PROCEDURE 			PRC_ListadeFuncionarios()
main: BEGIN 

	SELECT
			FKId
	,		Nome
    ,		TelefoneCelular
    ,		TelefoneResidencial
    , 		FKSituacao
    
	FROM 
			Funcionario;

END

$$ DELIMITER ;


/*Procedure de gerar uma lista com todas as informações cadastradas de um Cliente, mostrar os detalhes de um Cliente*/
DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DetalhesFuncionario$$
CREATE PROCEDURE 			PRC_DetalhesFuncionario
(
	IN pFKId 	   INT    
)
main: BEGIN 

	SELECT 
			FKId
	,		Nome
    ,		TelefoneCelular
    ,		TelefoneResidencial
    ,		Endereco
    ,		Complemento
    ,		FKSituacao
	FROM 
		Funcionario
	WHERE 
		FKId	=	pFKId;

END

$$ DELIMITER ;


/*Procedure de editar o Cadastro de um CLiente*/
DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarFuncionario $$
CREATE PROCEDURE 			PRC_EditarFuncionario
(
	IN  pFKId			 	 INT
,	IN  pNome 				 VARCHAR (030)
, 	IN  pTelefoneCelular 	 CHAR	 (014)
, 	IN  pTelefoneResidencial CHAR 	 (013)
,	IN  pEndereco 	      	 VARCHAR (180)
,   IN  pComplemento 	     VARCHAR (100)

)
main: BEGIN 

	UPDATE 		
		Funcionario
	SET 	
		FKId= pFKId
	, 	Nome = pNome
    , 	TelefoneCelular = pTelefoneCelular
    ,	TelefoneResidencial = pTelefoneResidencial
    , 	Endereco = pEndereco
    ,	Complemento = pComplemento
    WHERE 
		FKId =	pFKId;
        
END
$$ DELIMITER ;


/*Procedure de apagar o cadastro de um funcionario pelo seu numero de ID*/

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_VerificarFuncionario $$
CREATE PROCEDURE 			PRC_VerificarFuncionario
(
	IN pTelefone    CHAR(014)
,	OUT pId			INT
)
main: BEGIN 

SET pId = 0;

SELECT 
		FKId
FROM 
		Funcionario
WHERE
		TelefoneResidencial = pTelefone
OR
		TelefoneCelular = pTelefone
INTO
		pId;        

END

$$ DELIMITER ;

CREATE TABLE Cidade(
Id 			   			   INT NOT NULL AUTO_INCREMENT	     ,
Nome					   VARCHAR (155)	     		     ,
Situacao				   INT								 ,
PRIMARY KEY	(Id)				         				          	           
);

-- PROCEDURES FORMA DE PAGAMENTO

DELIMITER $$ 
DROP PROCEDURE IF EXISTS PRC_IncluirCidade $$ 
CREATE PROCEDURE PRC_IncluirCidade
(
	IN pNome				VARCHAR(155)
,	IN pSituacao			INT
,   OUT pId					INT

) 
main: BEGIN 

	INSERT INTO 
		Cidade
	(
	 	Nome
	,	Situacao
    ) 
	VALUES
    (
		pNome
,		pSituacao
	);
    
     SET pId 
		= 
    LAST_INSERT_ID();
    
END 
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_DeletarCidade $$
CREATE PROCEDURE 			PRC_DeletarCidade
(
	IN  pId			 		 INT
,	IN 	pSituacao			 INT
)
main: BEGIN 

	UPDATE 		
		Cidade
	SET 
	     Situacao = pSituacao
    WHERE 
		Id = pId;
	
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EditarCidade $$
CREATE PROCEDURE 			PRC_EditarCidade
(	
 	IN 	pId	 				INT UNSIGNED
,	IN 	pNome				VARCHAR (155)
) 
main: BEGIN 

	UPDATE 		
		Cidade
	SET 
		Nome			=	pNome
    WHERE 
		Id				=	pId;
        
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_Cidades $$
CREATE PROCEDURE 			PRC_Cidades()
main: BEGIN 

	SELECT
			*
    
	FROM 
			Cidade;

END

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_Cidade $$
CREATE PROCEDURE 			PRC_Cidade
(
	IN pId int    
)
main: BEGIN 

	SELECT 
		* 
	FROM 
		Cidade
	WHERE 
		Id	=	pId;

END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_VerificarCidade $$
CREATE PROCEDURE 			PRC_VerificarCidade
(
	IN pNome	VARCHAR(155)
,	OUT pId		INT
) 
main: BEGIN 

SET		pId = 0;

SELECT
		Id
FROM 
		Cidade
WHERE
		Nome	=	pNome
INTO
		pId;

END

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EstatisticaPlataformaData $$ 
CREATE PROCEDURE 			PRC_EstatisticaPlataformaData
(
	IN  pDataInicio		DATETIME
 ,  IN  pDataFinal		DATETIME
 ,	IN	pStatus				INT
 ,	OUT pPlataforma1		INT 
 ,	OUT pPlataforma2		INT 
 ,	OUT pPlataforma3		INT 

) 
main: BEGIN 

SELECT  
	  	  
		count(Id) 
        
FROM 
		 Pedido        

WHERE
		plataforma =	1
AND
		PedidoStatus = pStatus
AND
		DataVenda BETWEEN pDataInicio AND pDataFinal
INTO
		pPlataforma1;

SELECT  
	  	  
		count(Id)
        
FROM 
		 Pedido        

WHERE
		plataforma =	2
AND
		PedidoStatus = pStatus
AND
		DataVenda BETWEEN pDataInicio AND pDataFinal
INTO
		pPlataforma2;

SELECT  
	  	  
		count(Id)
        
FROM 
		 Pedido        

WHERE
		plataforma =	3
AND
		PedidoStatus = pStatus
AND
		DataVenda BETWEEN pDataInicio AND pDataFinal
INTO
		pPlataforma3;

       
END

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EstatisticaPlataforma $$ 
CREATE PROCEDURE 			PRC_EstatisticaPlataforma
(
	IN  pStatus				INT
 ,	OUT pPlataforma1		INT 
 ,	OUT pPlataforma2		INT 
 ,	OUT pPlataforma3		INT 

) 
main: BEGIN 

SELECT  
	  	  
		count(Id) 
        
FROM 
		 Pedido        

WHERE
		plataforma =	1
AND
		PedidoStatus = pStatus
INTO
		pPlataforma1;

SELECT  
	  	  
		count(Id)
        
FROM 
		 Pedido        

WHERE
		plataforma =	2
AND
		PedidoStatus = pStatus
INTO
		pPlataforma2;

SELECT  
	  	  
		count(Id)
        
FROM 
		 Pedido        

WHERE
		plataforma =	3
AND
		PedidoStatus = pStatus
INTO
		pPlataforma3;

       
END

$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EstatisticaPedidoData $$ 
CREATE PROCEDURE 			PRC_EstatisticaPedidoData
(
	IN  pStatus			INT
 ,	IN  pDataInicio		DATETIME
 ,  IN  pDataFinal		DATETIME
 ,	OUT pTotal			INT 
) 
main: BEGIN 

SELECT  	  	  
		count(Id)        
FROM 
		 Pedido         
WHERE	
		DataVenda BETWEEN pDataInicio AND pDataFinal
AND
		PedidoStatus = pStatus 
INTO
		pTotal;	
       
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EstatisticaPedidoTotal $$ 
CREATE PROCEDURE 			PRC_EstatisticaPedidoTotal
(
	IN  pStatus			INT
 , 	OUT pTotal			INT 
) 
main: BEGIN 

SELECT  	  	  
		count(Id)        
FROM 
		 Pedido         
WHERE
		PedidoStatus = pStatus
INTO 
		pTotal;	
       
END
$$ DELIMITER ;


DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EstatisticaValorTotalData $$ 
CREATE PROCEDURE 			PRC_EstatisticaValorTotalData
(
 	IN	pStatus				INT
 ,	IN  pDataInicio		DATETIME
 ,  IN  pDataFinal		DATETIME
 ,	OUT pValorTotal			INT 
) 
main: BEGIN 

SELECT  	  	  
		sum(ValorTotal)        
FROM 
		 Pedido         
WHERE	
		DataVenda BETWEEN pDataInicio AND pDataFinal 
AND
		PedidoStatus = pStatus
INTO
		pValorTotal;
       
END
$$ DELIMITER ;

DELIMITER $$ 
DROP PROCEDURE IF EXISTS 	PRC_EstatisticaValorTotal $$ 
CREATE PROCEDURE 			PRC_EstatisticaValorTotal
(	
	IN	pStatus				INT
,	OUT pValorTotal			INT 
) 
main: BEGIN 

SELECT  	  	  
		sum(ValorTotal)        
FROM 
		 Pedido      
WHERE
		PedidoStatus = pStatus
INTO 
		 pValorTotal;
       
END
$$ DELIMITER ;

DELIMITER $$
CREATE EVENT AtualizarPedidosDiariamente
ON SCHEDULE EVERY 24 HOUR
DO BEGIN
UPDATE
Pedido
SET
PedidoStatus = 4
WHERE
PedidoStatus != 3
AND
DataVenda != CURDATE();
END
$$ DELIMITER ;



DELIMITER $$
CREATE EVENT CancelarPedidoTempo
ON SCHEDULE EVERY 1 HOUR
DO BEGIN
UPDATE
Pedido
SET
PedidoStatus = 4
WHERE
PedidoStatus = 5
AND
DataVenda != CURDATE();
END
$$ DELIMITER ;