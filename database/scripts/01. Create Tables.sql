/*------------------------------------------CRIAÇÃO DO BANCO DE DADOS-------------------------------------------------*/

CREATE DATABASE IF NOT EXISTS mythrix
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

/*---------------------------------------------SELECIONA O BANCO------------------------------------------------------*/

USE mythrix;

/*----------------------------------------------CRIAÇÂO DAS TABELAS---------------------------------------------------*/

CREATE TABLE IF NOT EXISTS item_type (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do tipo do item.',
    type VARCHAR(50) NOT NULL COMMENT 'Descrição do tipo do item.',
    
    CONSTRAINT pk_item_type PRIMARY KEY (id),
    CONSTRAINT uq_item_type_type UNIQUE (type)
) ENGINE = InnoDB
COMMENT = 'Tipos que classificam um item ou determinam seu estado.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS item (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do item',
    code VARCHAR(8) NOT NULL COMMENT 'Código alfanumérico que identifica um item.',
    name VARCHAR(150) NOT NULL COMMENT 'Nome do item.',
    uom VARCHAR(5) NOT NULL DEFAULT 'UN' COMMENT 'Unidade de medida do item.',
    description VARCHAR(255) NULL COMMENT 'Descrição estendida do item.',
    status ENUM('A', 'I', 'B') NOT NULL DEFAULT 'A'
		COMMENT 'Define o status do item baseado em suas movimentações:
				A=Active - Item cadastrado e disponível,
                I=Inactive - Item desativado, B=Blocked - Item temporariamente bloqueado.',
	is_stockable BOOLEAN DEFAULT FALSE COMMENT 'Define se o item possui controle de estoque.',
    weight DECIMAL(10,3) NULL COMMENT 'Peso (kg) do item.',
    height DECIMAL(10,3) NULL COMMENT 'Altura (cm) do item.',
    width DECIMAL(10,3) NULL COMMENT 'Largura (cm) do item.',
    depth DECIMAL(10,3) NULL COMMENT 'Profundidade (cm) do item.',
    capacity DECIMAL(10,3) NULL COMMENT 'Capacidade do item.',
    item_type_id INT UNSIGNED NOT NULL COMMENT 'Id do tipo do item.',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Data/hora de atualização do cadastro do item',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora do cadastro do item.',
    
    CONSTRAINT pk_item PRIMARY KEY (id),
    CONSTRAINT uq_item_code UNIQUE (code),
    
    CONSTRAINT fk_item_item_type
		FOREIGN KEY (item_type_id)
		REFERENCES item_type (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT chk_item_weight
		CHECK (weight >= 0),
        
	CONSTRAINT chk_item_height
		CHECK (height >= 0),
	
    CONSTRAINT chk_item_width
		CHECK (width >= 0),
			
	CONSTRAINT chk_item_depth
		CHECK (depth >= 0),
	
    CONSTRAINT chk_item_capacity
		CHECK (capacity >= 0),
        
	CONSTRAINT chk_item_is_stockable
		CHECK (is_stockable IN (0, 1))
) ENGINE = InnoDB
COMMENT = 'Itens que são utilizados para gerar movimentações dentro do negócio.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS product_category (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único da categoria do produto.',
    category VARCHAR(100) NOT NULL COMMENT 'Nome/descrição da categoria do produto.',
    
    CONSTRAINT pk_product_category PRIMARY KEY (id),
    CONSTRAINT uq_product_caregory_category UNIQUE (category)
) ENGINE = InnoDB
COMMENT = 'Categorias associadas aos produtos.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS product (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único do produto.',
    category_id INT UNSIGNED NOT NULL COMMENT 'Id da categoria do produto.',
    
    CONSTRAINT pk_product PRIMARY KEY (id),
    
    CONSTRAINT fk_product_item
		FOREIGN KEY (id)
        REFERENCES item (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_product_product_category
		FOREIGN KEY (category_id)
        REFERENCES product_category (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE InnoDB
COMMENT = 'Produtos associados ao item.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS service (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único do serviço.',
    
    CONSTRAINT pk_service PRIMARY KEY (id),
    CONSTRAINT fk_service_item
		FOREIGN KEY (id)
        REFERENCES item (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Serviços associados ao item.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS document (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do documento.',
    document_type ENUM('PO', 'SO') NOT NULL COMMENT 'Tipo do documento: SO=Sales Order, PO=Purchase Order.',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora da criação do documento.',
    
    CONSTRAINT pk_document PRIMARY KEY (id)
) ENGINE = InnoDB
COMMENT = 'Documentos para movimentações do sistema.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS asset (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único do ativo.',
    acquisition_cost DECIMAL(15,2) NOT NULL COMMENT 'Valor do custo de aquisição do ativo.',
    acquisition_date DATE NOT NULL COMMENT 'Data/hota de aquisição do ativo.',
    current_value DECIMAL(15,2) NOT NULL COMMENT 'Valor atual do ativo, considerando depreciações ao longo do tempo.',
    location VARCHAR(30) NOT NULL COMMENT 'Local físico onde o ativo se encontra.',
    acquisition_document_id INT UNSIGNED NULL COMMENT 'Id do documento que gerou o ativo, caso haja.',
    
    CONSTRAINT pk_asset PRIMARY KEY (id),
    CONSTRAINT fk_asset_item
		FOREIGN KEY (id)
        REFERENCES item (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_asset_document
		FOREIGN KEY (acquisition_document_id)
        REFERENCES document (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT chk_asset_acquisition_cost
		CHECK (acquisition_cost >= 0),
        
	CONSTRAINT chk_asset_current_value
		CHECK (current_value >= 0)
) ENGINE = InnoDB
COMMENT = 'Ativos/patrimônio do negócio.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS stock (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do controle de estoque.',
    item_id INT UNSIGNED NOT NULL COMMENT 'Id do item de estoque.',
    balance DECIMAL(15,2) NOT NULL COMMENT 'Saldo do item em estoque (R$).',
    stock_quantity SMALLINT NOT NULL COMMENT 'Quantidade do item em estoque.',
    reserved_quantity SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Quantidade reservada do item no estoque.',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data/hora de atualização do estoque do item.',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora da entrada do item no estoque.',
    
    CONSTRAINT pk_stock PRIMARY KEY (id),
    CONSTRAINT uq_stock_item UNIQUE (item_id),
    
    CONSTRAINT fk_stock_item
		FOREIGN KEY (item_id)
        REFERENCES item (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT chk_stock_reserved_quantity
		CHECK (reserved_quantity <= stock_quantity)
) ENGINE = InnoDB
COMMENT = 'Controle de estoque por item.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS stock_movement (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único da movimentação de estoque.',
    stock_id INT UNSIGNED NOT NULL COMMENT 'Id do controle de estoque.',
    document_id INT UNSIGNED NOT NULL COMMENT 'Id do documento que gerou a movimentação no estoque.',
    type ENUM('IN', 'OUT') NOT NULL COMMENT 'Tipo de movimentação de estoque: IN=Entrada, OUT=Saída.',
    quantity SMALLINT UNSIGNED NOT NULL COMMENT 'Quantidade de itens movimentados do estoque.',
    movement_value DECIMAL(15,2) NOT NULL COMMENT 'Valor relativo à quantidade de itens movimentados (R$).',
    movement_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora da movimentação do item no estoque.',
    
    CONSTRAINT pk_stock_movement PRIMARY KEY (id),
	CONSTRAINT fk_stock_movement_stock
		FOREIGN KEY (stock_id)
		REFERENCES stock (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_stock_movement_document
		FOREIGN KEY (document_id)
        REFERENCES document (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT chk_stock_movement_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_stock_movement_movement_value
        CHECK (movement_value >= 0)
) ENGINE = InnoDB
COMMENT = 'Movimentação de itens do estoque.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS media_file (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do arquivo de mídia.',
    storage_key VARCHAR(500) NOT NULL COMMENT 'Localização do arquivo no sistema de armazenamento.',
    original_filename VARCHAR(255) NOT NULL COMMENT 'Nome original do arquivo enviado.',
    content_type VARCHAR(100) NOT NULL COMMENT 'Tipo de mídia do arquivo, conforme seu formato.',
    size_bytes BIGINT UNSIGNED NOT NULL COMMENT 'Tamanho do arquivo armazenado em bytes.',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação do registro do arquivo de mídia.',

    CONSTRAINT pk_media_file
        PRIMARY KEY (id),

    CONSTRAINT uq_media_file_storage_key
        UNIQUE (storage_key),

    CONSTRAINT chk_media_file_size
        CHECK (size_bytes > 0)

) ENGINE = InnoDB
COMMENT = 'Metadados dos arquivos armazenados.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS item_image (
    item_id INT UNSIGNED NOT NULL COMMENT 'Identificador do item.',
    media_file_id INT UNSIGNED NOT NULL COMMENT 'Identificador do arquivo de mídia.',
    display_order SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Ordem de exibição da imagem em relação às demais imagens do item.',
    is_primary BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Indica se a imagem está definida como principal para o item.',
    alt_text VARCHAR(255) NULL COMMENT 'Descrição textual do conteúdo da imagem para acessibilidade e identificação contextual.',

    CONSTRAINT pk_item_image PRIMARY KEY (item_id, media_file_id),
    CONSTRAINT fk_item_image_item
        FOREIGN KEY (item_id)
        REFERENCES item (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_item_image_media_file
        FOREIGN KEY (media_file_id)
        REFERENCES media_file (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE

) ENGINE = InnoDB
COMMENT = 'Imagens associadas aos itens cadastrados no sistema.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS partner (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do parceiro.',
    name VARCHAR(200) NOT NULL COMMENT 'Nome completo do parceiro.',
    document VARCHAR(14) NOT NULL COMMENT 'Nº do documento de identificação do parceiro.',
    document_type ENUM('CPF', 'CNPJ') NOT NULL COMMENT 'Tipo do documento de identificação do parceiro (CPF/CNPJ).',
    email VARCHAR(254) NULL COMMENT 'E-mail principal do parceiro.',
    alt_email VARCHAR(254) NULL COMMENT 'E-mail alternativo do parceiro.',
    main_phone VARCHAR(25) NULL COMMENT 'Telefone principal do parceiro.',
    alt_phone VARCHAR(25) NULL COMMENT 'Telefone alternativo do parceiro.',
    status ENUM('A', 'T', 'S') NOT NULL DEFAULT 'A'
		COMMENT 'Situação do parceiro no sistema: A=Active, T=Terminated, S=Suspended.',
    person_type ENUM('NP', 'LE') NOT NULL COMMENT 'Tipo de pessoa legal: NP=Natural Person, LE=Legal Entity.',
    email_opt_in ENUM('Y', 'N') NOT NULL DEFAULT 'N' COMMENT 'Permissão para receber comunicação por e-mail: Y=Yes, N=No.',
    whatsapp_opt_in ENUM('Y', 'N') NOT NULL DEFAULT 'N' COMMENT 'Permissão para receber comunicação por WhatsApp: Y=Yes, N=No.',
    sms_opt_in ENUM('Y', 'N') NOT NULL DEFAULT 'N' COMMENT 'Permissão para receber comunicação por SMS: Y=Yes, N=No.',
    media_file INT UNSIGNED NULL COMMENT 'Identificador do arquivo de mídia associado ao parceiro.',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Data/hora da última alteração no cadastro do parceiro.',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora do cadastro do parceiro.',
    last_updated_info VARCHAR(255) NULL
		COMMENT 'Estado anterior dos dados que foram alterados na última atualização do cadastro do parceiro.',
    
    CONSTRAINT pk_partner PRIMARY KEY (id)
) ENGINE = InnoDB
COMMENT = 'Cadastro central de pessoas físicas e jurídicas relacionadas ao negócio.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS customer (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único do cliente.',
	birth_date DATE NULL COMMENT 'Data de nascimento do cliente.',
    sex ENUM('M', 'F') NOT NULL COMMENT 'Sexo do cliente: M=Male, F=Female.',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Data/hora da última atualização do cadastro do cliente.',
    last_updated_info VARCHAR(255) NULL
		COMMENT 'Estado anterior dos dados que foram alterados na última atualização do cadastro de clientes.',
    
    CONSTRAINT pk_customer PRIMARY KEY (id),
    CONSTRAINT fk_customer_partner
		FOREIGN KEY (id)
        REFERENCES partner (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Clientes pessoa física.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS customer_legal_entity (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único do cliente pessoa jurídica.',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Data/hora da última atualização do cadastro do cliente pessoa jurídica.',
    last_updated_info VARCHAR(255) NULL
		COMMENT 'Estado anterior dos dados que foram alterados na última atualização do cadastro de clientes pessoa jurídica.',
    
    CONSTRAINT pk_customer_legal_entity PRIMARY KEY (id),
    CONSTRAINT fk_customer_legal_entity_partner
		FOREIGN KEY (id)
        REFERENCES partner (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Clientes pessoa jurídica.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS supplier (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único do fornecedor.',
    
    CONSTRAINT pk_supplier PRIMARY KEY (id),
    CONSTRAINT fk_supplier_partner
		FOREIGN KEY (id)
        REFERENCES partner (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Fornecedores: parceiros que fornecem produtos e serviços à empresa.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS employee (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único do empregado.',
    birth_date DATE NOT NULL COMMENT 'Data de nascimento do empregado.',
    sex ENUM('M', 'F') NOT NULL COMMENT 'Sexo do empregado: M=Male, F=Female.',
    work_email VARCHAR(254) NULL COMMENT 'E-mail profissional do empregado.',
    work_phone VARCHAR(25) NULL COMMENT 'Telefone profissional do empregado.',
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Data/hora da última atualização do cadastro do empregado.',
	last_updated_info VARCHAR(255) NULL
		COMMENT 'Estado anterior dos dados que foram alterados na última atualização do cadastro do empregado.',
	
    CONSTRAINT pk_employee PRIMARY KEY (id),
    CONSTRAINT fk_employee_partner
		FOREIGN KEY (id)
        REFERENCES partner (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Dados profissionais e vínculo empregatício dos parceiros.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS address (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do endereço.',
    partner_id INT UNSIGNED NOT NULL COMMENT 'Identificador do parceiro associado ao endereço.',
    address_line VARCHAR(200) NOT NULL COMMENT 'Logradouro do endereço.',
    number VARCHAR(20) NOT NULL DEFAULT 'S/N' COMMENT 'Número do imóvel ou identificação equivalente.',
    complement VARCHAR(100) NULL COMMENT 'Complemento do endereço.',
    city VARCHAR(100) NOT NULL COMMENT 'Cidade do endereço.',
    state CHAR(2) NOT NULL COMMENT 'Sigla do estado ou região administrativa.',
    postal_code VARCHAR(20) NULL COMMENT 'Código postal do endereço.',
    country CHAR(2) NOT NULL COMMENT 'Código do país.',
    address_type ENUM('R', 'C') NULL
		COMMENT 'Tipo do endereço: R=Residential, C=Commercial.',
	address_purpose ENUM('B', 'S') NULL
		COMMENT 'Finalidade do endereço: B=Billing, S=Shipping.',
    
    CONSTRAINT pk_address PRIMARY KEY (id),
    CONSTRAINT fk_address_partner
		FOREIGN KEY (partner_id)
        REFERENCES partner (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Endereços associados aos parceiros do negócio.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS user_authentication (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador do parceiro associado ao usuário.',
    username VARCHAR(50) NOT NULL COMMENT 'Nome de usuário utilizado na autenticação.',
    email VARCHAR(254) NOT NULL COMMENT 'E-mail utilizado na autenticação de usuário.',
    phone VARCHAR(25) NOT NULL COMMENT 'Telefone utilizado na autenticação de usuário.',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Hash da senha do usuário.',
    authentication_status ENUM('A', 'E', 'L', 'RR') NOT NULL DEFAULT 'A'
		COMMENT 'Status da autenticação do usuário: A=Active, E=Expired, L=Locked, RR=Reset Required.',
	last_access DATETIME NULL COMMENT 'Data/hora do último login bem-sucedido.',
    login_attempts TINYINT UNSIGNED DEFAULT 0 NULL COMMENT 'Quantidade de tentativas consecutivas de autenticação malsucedidas.',
    locked_at DATETIME NULL COMMENT 'Data/hora de início do bloqueio.',
    lockout_until DATETIME NULL COMMENT 'Data/hora prevista para liberação do bloqueio',
    password_changed_at DATETIME NULL COMMENT 'Data/hora da última alteração de senha.',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Data/hora da última atualização do cadastro do usuário.',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT 'Data/hora de criação do cadastro de autenticação.',
    last_updated_info VARCHAR(255) NULL
		COMMENT 'Estado anterior dos dados que foram alterados na última atualização do cadastro de autenticação do usuário.',
    
    CONSTRAINT pk_user_authentication PRIMARY KEY (id),
    CONSTRAINT uq_user_authentication_username UNIQUE (username),
    CONSTRAINT uq_user_authentication_email UNIQUE (email),
    CONSTRAINT uq_user_authentication_phone UNIQUE (phone),
    
    CONSTRAINT fk_user_authentication_partner
		FOREIGN KEY (id)
        REFERENCES partner (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT 'Dados de autenticação dos usuários.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS attribute (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do atributo.',
    attribute VARCHAR(50) NOT NULL COMMENT 'Nome do atributo adicional.',
    data_type ENUM('TEXT', 'INTEGER', 'DECIMAL', 'BOOLEAN', 'DATE') NOT NULL DEFAULT 'TEXT'
		COMMENT 'Tipo do dado do atributo adicional.',
    
    CONSTRAINT pk_attribute PRIMARY KEY (id),
    CONSTRAINT uq_attribute_attribute UNIQUE (attribute)
) ENGINE = InnoDB
COMMENT = 'Características adicionais que podem ser associadas aos itens.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS item_attribute (
	item_id INT UNSIGNED NOT NULL COMMENT 'Identificador do item.',
    attribute_id INT UNSIGNED NOT NULL COMMENT 'Identificador do atributo.',
    value VARCHAR(50) NOT NULL COMMENT 'Valor da caracteística adicional do item.',
    
    CONSTRAINT pk_item_attribute PRIMARY KEY (item_id, attribute_id),
    CONSTRAINT fk_item_attribute_item
		FOREIGN KEY (item_id)
        REFERENCES item (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_item_attribute_attribute
		FOREIGN KEY (attribute_id)
        REFERENCES attribute (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Valores das características adicionais de cada item.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS sales_channel (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do canal de venda.',
    channel VARCHAR(50) NOT NULL COMMENT 'Nome do canal de venda.',
    
    CONSTRAINT pk_sales_channel PRIMARY KEY (id),
    CONSTRAINT uq_sales_channel_channel UNIQUE (channel)
) ENGINE = InnoDB
COMMENT = 'canais utilizados para comercialização de produtos e serviços.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS sales_channel_attribute (
	channel_id INT UNSIGNED NOT NULL COMMENT 'Identificador do canal de venda.',
    attribute_id INT UNSIGNED NOT NULL COMMENT 'Identificador do atributo.',
    value VARCHAR(50) NOT NULL COMMENT 'Valor da caracteística adicional do canal de venda.',
    
    CONSTRAINT pk_sales_channel_attribute PRIMARY KEY (channel_id, attribute_id),
    CONSTRAINT fk_sales_channel_attribute_sales_channel
		FOREIGN KEY (channel_id)
        REFERENCES sales_channel (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_sales_channel_attribute_attribute
		FOREIGN KEY (attribute_id)
        REFERENCES attribute (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Valores de atributos personalizados associados a cada canal de venda.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS purchase_order (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único da ordem de compra.',
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora da criação da ordem de compra.',
    status ENUM('D', 'C', 'X') NOT NULL DEFAULT 'D'
		COMMENT 'Situação da ordem de compra: D=Draft, C=Completed, X=Cancelled.',
    employee_id INT UNSIGNED NOT NULL COMMENT 'Identificador do empregado responsável pela ordem de compra.',
    supplier_id INT UNSIGNED NOT NULL COMMENT 'Identificador do fornecedor da ordem de compra.',
    
    CONSTRAINT pk_purchase_order PRIMARY KEY (id),
    CONSTRAINT fk_purchase_order_document
		FOREIGN KEY (id)
        REFERENCES document (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_purchase_order_employee
		FOREIGN KEY (employee_id)
        REFERENCES employee (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_purchase_order_supplier
		FOREIGN KEY (supplier_id)
        REFERENCES supplier (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Pedidos de aquisição de produtos e serviços realizados junto aos fornecedores.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS purchase_order_item (
	purchase_order_id INT UNSIGNED NOT NULL COMMENT 'Identificador da ordem de compra.',
    item_id INT UNSIGNED NOT NULL COMMENT 'Identificador do item comprado.',
    item_quantity DECIMAL(15,3) NOT NULL COMMENT 'Quantidade do item comprado.',
    unit_price DECIMAL(15,2) NOT NULL COMMENT 'Preço unitário do item.',
    
    CONSTRAINT pk_purchase_order_item PRIMARY KEY (purchase_order_id, item_id),
    CONSTRAINT fk_purchase_order_item_purchase_order
		FOREIGN KEY (purchase_order_id)
        REFERENCES purchase_order (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_purchase_order_item_item
		FOREIGN KEY (item_id)
        REFERENCES item (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT chk_purchase_order_item_quantity
		CHECK (item_quantity > 0),
        
	CONSTRAINT chk_purchase_order_item_unit_price
		CHECK (unit_price >= 0)
) ENGINE = InnoDB
COMMENT = 'Itens, quantidades e preços unitários de cada ordem de compra.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS sales_order (
	id INT UNSIGNED NOT NULL COMMENT 'Identificador único da ordem de venda.',
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data/hora de criação da ordem de venda.',
    status ENUM('D', 'C', 'X') NOT NULL DEFAULT 'D'
		COMMENT 'Situação da ordem de compra: D=Draft, C=Completed, X=Cancelled.',
    employee_id INT UNSIGNED NOT NULL COMMENT 'Identificador do empregado responsável pela ordem de venda.',
    partner_id INT UNSIGNED NOT NULL COMMENT 'Identificador do parceiro comprador.',
    channel_id INT UNSIGNED NOT NULL COMMENT 'Identificador do canal de venda.',
    
    CONSTRAINT pk_sales_order PRIMARY KEY (id),
    CONSTRAINT fk_sales_order_document
		FOREIGN KEY (id)
        REFERENCES document (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_sales_order_employee
		FOREIGN KEY (employee_id)
        REFERENCES employee (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_sales_order_partner
		FOREIGN KEY (partner_id)
        REFERENCES partner (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_sales_order_channel
		FOREIGN KEY (channel_id)
        REFERENCES sales_channel (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB
COMMENT = 'Ordens de venda de produtos e serviços realizados aos parceiros.';

/*--------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS sales_order_item (
	sales_order_id INT UNSIGNED NOT NULL COMMENT 'Identificador da ordem de venda.',
    item_id INT UNSIGNED NOT NULL COMMENT 'Identificador do item vendido.',
    item_quantity DECIMAL(15,3) NOT NULL COMMENT 'Quantidade do item vendido.',
    unit_price DECIMAL(15,2) NOT NULL COMMENT 'Preço unitário do item.',
    
    CONSTRAINT pk_sales_order_item PRIMARY KEY (sales_order_id, item_id),
    CONSTRAINT fk_sales_order_item_sales_order
		FOREIGN KEY (sales_order_id)
        REFERENCES sales_order (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_sales_order_item_item
		FOREIGN KEY (item_id)
        REFERENCES item (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
	CONSTRAINT chk_sales_order_item_quantity
		CHECK (item_quantity > 0),
        
	CONSTRAINT chk_sales_order_item_unit_price
		CHECK (unit_price >= 0)
) ENGINE = InnoDB
COMMENT = 'Itens, quantidades e preços unitários de cada ordem de venda.';