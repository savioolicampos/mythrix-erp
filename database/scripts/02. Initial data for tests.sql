INSERT INTO media_file (
	storage_key,
    original_filename,
    content_type,
    size_bytes
)
VALUES
	('D:\\Mythrix\\Mythrix ERP\\media\\images\\partner\\savio', 'savio.png', 'image/webp', '185000'),
    ('D:\\Mythrix\\Mythrix ERP\\media\\images\\partner\\mythrix', 'mythrix.png', 'image/webp', '25860'),
    ('D:\\Mythrix\\Mythrix ERP\\media\\images\\item', 'camiseta.png', 'image/webp', '3568');

INSERT INTO partner (
	name,
    document,
    document_type,
    email,
    alt_email,
    main_phone,
    alt_phone,
    person_type,
    email_opt_in,
    whatsapp_opt_in,
    sms_opt_in,
    media_file,
    last_updated_info
)
VALUES
	('Sávio Oliveira Campos', '38783300066', 'CPF', 'savio@gmail.com', 'savio2@gmail.com', '61985746982', '61984563762', 'NP', 'Y', 'Y', 'N', 11, NULL),
	('Mythrix Personalizados', '31882207000160', 'CNPJ', 'saviocampos@mythrix.com.br', NULL, '61984563762', NULL, 'LE', 'Y', 'Y', 'N', 7, NULL),
    ('Personalizações LTDA', '75772178000150', 'CNPJ', 'contato@personalizacoes.com.br', NULL, '61996358472', NULL, 'LE', 'Y', 'Y', 'N', NULL, NULL);
    
INSERT INTO customer (
	id,
	birth_date,
    sex,
    last_updated_info
)
VALUES (1, '1998-08-08', 'M', NULL);

INSERT INTO customer_legal_entity (
	id,
    last_updated_info
)
VALUES (2, NULL);

INSERT INTO supplier (id)
VALUES (3);

INSERT INTO employee (
	id,
    birth_date,
    sex,
    work_email,
    work_phone,
    last_updated_info
)
VALUES
	(1, '1998-08-08', 'M', 'saviocampos@mythrix.com.br', '61984563762', NULL);
    
INSERT INTO address (
	partner_id,
    address_line,
    number,
    complement,
    city,
    state,
    postal_code,
    country,
    address_type,
    address_purpose
)
VALUES
	(1, 'Quadra 1, Lote 01', '41', 'Complemento 1', 'Taguatinga, Brasília', 'DF', '71459635', 'BR', 'R', 'B'),
    (2, 'Quadra 2, Lote 03', '41', 'Complemento 2', 'Asa Sul, Brasília', 'DF', '71459695', 'BR', 'C', 'S'),
    (3, 'Quadra 5, Lote 28', '02', 'Complemento 3', 'Taguatinga, Brasília', 'DF', '71459730', 'BR', 'C', 'B');
    
INSERT INTO user_authentication (
	id,
    username,
    email,
    phone,
    password_hash,
    last_access,
    login_attempts,
    locked_at,
    lockout_until,
    password_changed_at,
    last_updated_info
)
VALUES
	(1, 'saviocampos', 'savio@gmail.com', '61985746982', SHA2('minhaSenha@', 256), NULL, NULL, NULL, NULL, NULL, NULL),
    (2, 'mythrix', 'saviocampos@mythrix.com.br', '61984563762', SHA2('mythrix@', 256), NULL, NULL, NULL, NULL, NULL, NULL),
    (3, 'personalizacoes', 'contato@ljfworks.com.br', '61996358472', SHA2('ljf@', 256), NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO item_type (type)
VALUES
	('Asset'),
	('Consumable'),
    ('Expense'),
    ('Finished'),
    ('Semi-Finished'),
    ('Service');
    
INSERT INTO item (
    code,
    name,
    uom,
    description,
    is_stockable,
    weight,
    height,
    width,
    depth,
    capacity,
    item_type_id
)
VALUES
	('CAM00001', 'Camiseta Personalizada Geek', 'UN', 'Camiseta Personalizada Geek | Vingadores', TRUE, 0.300, 15, 30, NULL, NULL, 4),
    ('CAN00001', 'Caneca Personalizada Flamengo', 'UN', 'Caneca Personalizada do Flamengo com nome', TRUE, 1, 9.7, 8, NULL, 325, 4),
    ('IMP00001', 'Impressora Espson Ecotank L3250', 'UN', 'Impressora Espson Ecotank L3250 Wi-FI com digitalizador acompanhada de um kit de tinta completo', FALSE, 5.50, 14.6, 26.5, NULL, NULL, 1),
    ('PAP00001', 'Papel sublimático Jojo fundo rosa', 'UN', 'Kit de Papel sublimático Jojo fundo rosa com 100 folhas', TRUE, 5.50, 14.6, 26.5, NULL, 100, 2),
    ('SER00001', 'Serviço de personalização de camiseta', 'UN', 'Serviço de personalização de camiseta com DTF', FALSE, NULL, NULL, NULL, NULL, NULL, 6);
    
INSERT INTO product_category (category)
VALUES
	('Camiseta Personalizada Geek'),
    ('Caneca Personalizada Times');
    
INSERT INTO product (
	id,
    category_id
)
VALUES
	(1, 1),
    (2, 2);
    
INSERT INTO asset (
	id,
    acquisition_cost,
    acquisition_date,
    current_value,
    location,
    acquisition_document_id
)
VALUES
	(3, 1000.00, CURDATE(), 958.60, 'Escritório Principal Mythrix', NULL);
    
INSERT INTO service (id)
VALUES (5);

INSERT INTO item_image (
	item_id,
    media_file_id,
    display_order,
    is_primary,
    alt_text
)
VALUES
	(1, 3, 1, 1, 'Camiseta personalizada vista de frente');
    
INSERT INTO attribute (
	attribute,
    data_type
)
VALUES
	('Cor', 'TEXT'),
    ('Tamanho', 'TEXT'),
    ('Taxa', 'DECIMAL');
    
INSERT INTO item_attribute (
	item_id,
    attribute_id,
    value
)
VALUES
	(1, 1, 'Preta'),
    (1, 2, 'M'),
    (3, 2, 'A4');
    
INSERT INTO sales_channel (channel)
VALUES
	('Shopee'),
    ('Mercado Livre'),
    ('Amazon');
    
INSERT INTO sales_channel_attribute (
	channel_id,
    attribute_id,
    value
)
VALUES
	(1, 3, 0.12),
    (2, 3, 0.15);
    
INSERT INTO document (document_type)
VALUES
	('PO'),
	('SO');

INSERT INTO purchase_order (
	id,
    employee_id,
    supplier_id
)
VALUES
	(1, 1, 3);

INSERT INTO purchase_order_item (
	purchase_order_id,
    item_id,
    item_quantity,
    unit_price
)
VALUES
	(1, 1, 1, 14.99),
    (1, 2, 1, 9.99),
    (1, 3, 1, 1000.00),
    (1, 4, 1, 37.99);
    
INSERT INTO sales_order (
	id,
    employee_id,
    partner_id,
    channel_id
)
VALUES
	(2, 1, 2, 1);
    
INSERT INTO sales_order_item (
	sales_order_id,
    item_id,
    item_quantity,
    unit_price
)
VALUES
	(2, 5, 1, 30.00);

INSERT INTO stock (
	item_id,
    balance,
    stock_quantity
)
VALUES
	(1, 14.99, 1),
    (2, 9.99, 1),
    (4, 37.99, 1);

INSERT INTO stock_movement (
	stock_id,
    document_id,
    type,
    quantity,
    movement_value
)
VALUES
	(1, 1, 'IN', 1, 14.99),
    (2, 1, 'IN', 1, 9.99),
    (3, 1, 'IN', 1, 37.99);