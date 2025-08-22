CREATE DATABASE DBTechno
GO

USE DBTechno
GO

-- Tabla Roles
CREATE TABLE Roles (
    idRol INT IDENTITY(1,1) PRIMARY KEY,
    Rol NVARCHAR(100) NOT NULL
);

-- Tabla Usuarios 
CREATE TABLE Usuarios (
    idUsuario INT IDENTITY(1,1) PRIMARY KEY,
    nombreCompleto NVARCHAR(150) NOT NULL,
    correo NVARCHAR(100) NOT NULL UNIQUE,
    clave NVARCHAR(255) NOT NULL,
    idRol INT NOT NULL,
    fechaRegistro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (idRol) REFERENCES Roles(idRol)
);

-- Tabla Categorías
CREATE TABLE Categorias (
    idCategoria INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL
);
GO

-- Tabla SubCategorías
CREATE TABLE SubCategorias (
    idSubCategoria INT PRIMARY KEY IDENTITY,
    nombre NVARCHAR(100) NOT NULL,
    idCategoria INT NOT NULL,
    FOREIGN KEY (idCategoria) REFERENCES Categorias(idCategoria)
);

-- Tabla Productos con urlImagen incluida
CREATE TABLE Productos (
    idProducto INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    urlImagen NVARCHAR(300) NOT NULL,
    marca NVARCHAR(50) NOT NULL, 
    idSubCategoria INT NOT NULL,
    FOREIGN KEY (idSubCategoria) REFERENCES SubCategorias(idSubCategoria)
);

CREATE TABLE Carrito (
    idProducto INT,
    cantidad INT,
    idUsuario NVARCHAR(50),
    -- Opcional: claves foráneas, PK compuesta, etc.
    PRIMARY KEY (idProducto, idUsuario)
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
    idPedido INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    fechaPedido DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (idUsuario) REFERENCES Usuarios(idUsuario)
);

-- Tabla Detalle Pedido
CREATE TABLE DetallePedido (
    idDetalle INT IDENTITY(1,1) PRIMARY KEY,
    idPedido INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precioUnitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idPedido) REFERENCES Pedidos(idPedido),
    FOREIGN KEY (idProducto) REFERENCES Productos(idProducto)
);

-- Insertar roles 
INSERT INTO Roles (Rol) VALUES ('Administrador'),
('Cliente');

-- Insertar usuarios
INSERT INTO Usuarios (nombreCompleto, correo, clave, idRol) VALUES ('Administrador', 'admin@gmail.com', 'admin777', 1),
('Fernanda', 'fernanda@gmail.com', '65432', 2 );

-- Insertar categorías
INSERT INTO Categorias (nombre) VALUES ('Audio'),
('Celulares'),
('Cómputo'),
('Fotografía'),
('TV y Video'),
('Gamer');

-- Subcategorías de Audio 
INSERT INTO SubCategorias (nombre, idCategoria) VALUES ('Audífonos', 1),
('Parlantes', 1);

-- Subcategorías de Celulares
INSERT INTO SubCategorias (nombre, idCategoria) VALUES ('Cargadores', 2),
('Smartphones', 2);

-- Subcategorías de Cómputo
INSERT INTO SubCategorias (nombre, idCategoria) VALUES ('Laptops', 3),
('Periféricos', 3);

INSERT INTO SubCategorias (nombre, idCategoria) VALUES ('Cámaras', 4),
('Trípodes', 4);

-- Subcategorías de TV y Video
INSERT INTO SubCategorias (nombre, idCategoria) VALUES ('Televisores', 5),
('Proyectores', 5);

-- Audifonos
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Sony WH-1000XM5', 'Auriculares premium con cancelación de ruido y hasta 30 h de batería', 1599.00, 10, 'https://coolboxpe.vtexassets.com/arquivos/ids/277257-1200-1200?v=638218412074930000&width=1200&height=1200&aspect=true', 'Sony', 1),
('JBL Tune 520BT', 'Auriculares Bluetooth con hasta 57 h de batería y sonido Pure Bass', 249.00, 20, 'https://coolboxpe.vtexassets.com/arquivos/ids/449246-1200-1200?v=638824243705530000&width=1200&height=1200&aspect=true', 'JBL', 1),
('Xiaomi Redmi Buds 4', 'Audífonos TWS con cancelación activa de ruido y estuche de carga', 189.00, 15, 'https://coolboxpe.vtexassets.com/arquivos/ids/290553-1200-1200?v=638258164038170000&width=1200&height=1200&aspect=true', 'Xiaomi', 1),
('JBL Wave Buds', 'Audífonos TWS con sonido JBL Deep Bass y hasta 32 h de batería', 169.00, 25, 'https://coolboxpe.vtexassets.com/arquivos/ids/440255-1200-1200?v=638793849480300000&width=1200&height=1200&aspect=true', 'JBL', 1);

-- Parlantes
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Decibel Adventure 16W', 'Parlante Bluetooth 16 W, IPX6, FM/USB, TWS, luces LED, batería 1500 mAh', 59.90, 20, 'https://coolboxpe.vtexassets.com/arquivos/ids/349962-1200-1200?v=638447524815770000&width=1200&height=1200&aspect=true', 'Decibel', 2),
('Decibel Thunder 30W', 'Parlante Bluetooth 30 W, IPX5, Radio FM/AUX/MicroSD, TWS, hasta 20 h de batería', 149.90, 15, 'https://coolboxpe.vtexassets.com/arquivos/ids/210097-1200-1200?v=637860884731770000&width=1200&height=1200&aspect=true','Decibel', 2),
('Decibel Soundbox Max 110W', 'Parlante Bluetooth 110 W RMS, IPX6, powerbank, hasta 12 h de batería', 349.90, 10, 'https://coolboxpe.vtexassets.com/arquivos/ids/448420-1200-1200?v=638821659270400000&width=1200&height=1200&aspect=true', 'Decibel', 2),
('Tronsmart Bang SE 40W', 'Parlante Bluetooth Tronsmart Bang SE 40 W, IPX6, iluminación LED, hasta 24 h de reproducción', 249.90, 12, 'https://coolboxpe.vtexassets.com/arquivos/ids/337372-1200-1200?v=638411060452970000&width=1200&height=1200&aspect=true', 'Tronsmart', 2);

-- Cargadores
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('G Mobile dual 12W', 'Cargador de pared G Mobile dual, 2 puertos USB, 12 W carga rápida', 34.90, 50, 'https://coolboxpe.vtexassets.com/arquivos/ids/326617-1200-1200?v=638351627246000000&width=1200&height=1200&aspect=true', 'G Mobile', 3),
('iBox 20W USB‑C 1 puerto', 'Cargador de pared iBox, 1 puerto USB‑C, 20 W, carga rápida PD', 69.90, 40, 'https://coolboxpe.vtexassets.com/arquivos/ids/233209-1200-1200?v=638011833000400000&width=1200&height=1200&aspect=true', 'iBox',3),
('Baseus GAN 6 Pro 100W', 'Cargador + cable Baseus GAN 6 Pro 100 W, 2 puertos USB‑C y USB‑A, 1 m', 299.90, 20, 'https://coolboxpe.vtexassets.com/arquivos/ids/352829-1200-1200?v=638458750245100000&width=1200&height=1200&aspect=true', 'Baseus', 3),
('Naztech SpeedMax 68W', 'Cargador dual Naztech SpeedMax 68 W PD (USB‑A + USB‑C), GaN, carga ultra rápida', 199.00, 15, 'https://coolboxpe.vtexassets.com/arquivos/ids/465470-1200-1200?v=638864659494270000&width=1200&height=1200&aspect=true', 'Naztech', 3);

-- Celulares
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Xiaomi Redmi Note 13', 'Pantalla AMOLED 6.67", Snapdragon 685, 128 GB, cámara 108 MP', 799.00, 20, 'https://coolboxpe.vtexassets.com/arquivos/ids/386440-1200-1200?v=638616732009730000&width=1200&height=1200&aspect=true', 'Xiaomi', 4),
('Motorola Moto G54 5G 256GB', 'Motorola Moto G54 5G, 8 GB RAM, cámara 50 MP + 2 MP, frontal 16 MP, pantalla 6.5″', 869.00, 12, 'https://coolboxpe.vtexassets.com/arquivos/ids/438832-1200-1200?v=638790525027270000&width=1200&height=1200&aspect=true', 'Motorola', 4),
('ZTE Blade A55 128GB', 'Smartphone ZTE Blade A55, 4 GB RAM, 128 GB, cámara 13 MP + frontal 8 MP, pantalla 6.75″', 369.00, 15, 'https://coolboxpe.vtexassets.com/arquivos/ids/410629-1200-1200?v=638744735693900000&width=1200&height=1200&aspect=true', 'ZTE', 4),
('Samsung Galaxy A56 5G 256GB', 'Samsung Galaxy A56 5G, 8 GB/12 GB RAM, triple cámara 50+12+5 MP, frontal 12 MP, pantalla 6.7″', 1799.00, 8, 'https://coolboxpe.vtexassets.com/arquivos/ids/459733-1200-1200?v=638848400248970000&width=1200&height=1200&aspect=true', 'Samsung', 4);

-- Laptops
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Laptop Asus TUF Gaming F15 i7‑13620H RTX 4050 16GB 1TB SSD', 'Asus TUF Gaming F15 15.6\" FHD, Intel Core i7‑13620H, 16 GB DDR5, 1 TB SSD, RTX 4050, Win11', 4839.90, 10, 'https://coolboxpe.vtexassets.com/arquivos/ids/373257-1200-1200?v=638549300564870000&width=1200&height=1200&aspect=true', 'Asus', 5),
('Laptop Lenovo LOQ 15.6\" Ryzen 7 7840HS RTX 4050 16GB 512GB SSD', 'Laptop gamer Lenovo LOQ 15.6\" FHD, AMD Ryzen 7 7840HS, 16 GB RAM DDR5‑5600, 512 GB SSD, NVIDIA RTX 4050 6 GB, teclado español, Windows 11 Home', 4599.90, 10, 'https://coolboxpe.vtexassets.com/arquivos/ids/427377-1200-1200?v=638760297433300000&width=1200&height=1200&aspect=true', 'Lenovo', 5),
('Laptop Lenovo V15 G3 i3‑1315U 8GB 256GB SSD', 'Lenovo V15 G3 IAP 15.6\" FHD, Intel Core i3‑1315U, 8 GB RAM, 256 GB SSD, Win11', 1319.00, 15, 'https://coolboxpe.vtexassets.com/arquivos/ids/350726-1200-1200?v=638449238727700000&width=1200&height=1200&aspect=true', 'Lenovo', 5),
('MacBook Air 13.6\" chip M2 8GB 256GB SSD', 'Apple MacBook Air 13.6\" Chip M2, 8 GB RAM, 256 GB SSD, macOS, teclado español', 4299.90, 5, 'https://coolboxpe.vtexassets.com/arquivos/ids/428185-1200-1200?v=638761829971200000&width=1200&height=1200&aspect=true', 'Apple', 5);

-- Teclado + Mouse
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Kit inalámbrico Teraware WM‑757', 'Combo teclado + mouse inalámbrico Teraware 2.4 GHz, 105 teclas en español, receptor USB, color negro', 69.90, 25, 'https://coolboxpe.vtexassets.com/arquivos/ids/458692-1200-1200?v=638846668320270000&width=1200&height=1200&aspect=true', 'Teraware', 6),
('Kit inalámbrico Teraware K783E701‑BK', 'Combo teclado + mouse inalámbrico Teraware, receptor USB 2.4 GHz, membrana, teclado español 106 teclas', 69.90, 30, 'https://coolboxpe.vtexassets.com/arquivos/ids/183787-1200-1200?v=637540948131900000&width=1200&height=1200&aspect=true', 'Teraware', 6),
('Kit alámbrico Logitech MK120 teclado y mouse', 'Combo alámbrico Logitech MK120, teclado membrana con teclado numérico, mouse óptico USB, color negro', 69.90, 20, 'https://coolboxpe.vtexassets.com/arquivos/ids/187808-1200-1200?v=637625746683300000&width=1200&height=1200&aspect=true', 'Logitech', 6),
('Kit inalámbrico Logitech MK235 teclado y mouse', 'Combo inalámbrico Logitech MK235, receptor USB, tecla membrana, conexión 2.4 GHz, color negro', 109.90, 20, 'https://coolboxpe.vtexassets.com/arquivos/ids/410599-1200-1200?v=638717946129530000&width=1200&height=1200&aspect=true', 'Logitech', 6);

-- Cámaras digitales y profesionales 
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Canon EOS Rebel T7 DSLR + lente 18‑55mm, Wi‑Fi, 24.1 MP', 'Cámara réflex Canon EOS Rebel T7 con lente 18‑55mm, Wi‑Fi, 24.1 MP, incluye memoria 64 GB y estuche protector', 2399.00, 6, 'https://coolboxpe.vtexassets.com/arquivos/ids/338512-1200-1200?v=638417140763130000&width=1200&height=1200&aspect=true', 'Canon', 7),
('Sony ZV‑E10 + E PZ 16‑50mm f/3.5‑5.6 OSS + estuche', 'Cámara digital Mirrorless Sony ZV‑E10 24.2 MP para vlogs, lente 16‑50mm, grabación 4K, pantalla táctil abatible', 4299.00, 5, 'https://coolboxpe.vtexassets.com/arquivos/ids/456893-1200-1200?v=638842156827430000&width=1200&height=1200&aspect=true', 'Sony', 7),
('Canon EOS R10 + lente RF‑S 18‑45 mm IS STM', 'Cámara mirrorless Canon EOS R10, lente RF‑S 18‑45 mm IS STM, ideal para fotografía avanzada, 4K', 4599.00, 4, 'https://coolboxpe.vtexassets.com/arquivos/ids/449806-1200-1200?v=638826630100000000&width=1200&height=1200&aspect=true', 'Canon', 7),
('Sony ZV‑1F 20.1 MP 4K vlogs, lente 35 mm, abatible', 'Cámara digital Sony ZV‑1F para vlogs, 20.1 MP, lente 35 mm, grabación 4K, micrófono incorporado', 2199.90, 7, 'https://coolboxpe.vtexassets.com/arquivos/ids/439242-1200-1200?v=638791279512430000&width=1200&height=1200&aspect=true', 'Sony', 7);

-- Trípode
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Trípode Roadtrip WT-330A 51.6–136 cm aluminio 3 kg', 'Trípode Roadtrip WT-330A aluminio, altura 51.6–136 cm, carga 3 kg, cabezal 360°, incluye holder para celular', 99.90, 30, 'https://coolboxpe.vtexassets.com/arquivos/ids/211914-1200-1200?v=637880048229300000&width=1200&height=1200&aspect=true', 'Roadtrip', 8),
('Trípode Roadtrip WT-3560 66–167 cm aluminio 3 kg', 'Trípode Roadtrip WT-3560 metal ligero, altura 66–167 cm, cabezal 3 vías 360°, soporta hasta 3 kg', 209.00, 20, 'https://coolboxpe.vtexassets.com/arquivos/ids/211922-1200-1200?v=637880087103500000&width=1200&height=1200&aspect=true', 'Roadtrip', 8),
('Trípode Weifeng WT-3970 profesional 175 cm', 'Trípode Weifeng WT‑3970 profesional, altura hasta 1.75 m, carga 4.5 kg, cabezal 3D, nivel 360°, aluminio', 215.00, 20, 'https://coolboxpe.vtexassets.com/arquivos/ids/442652-1200-1200?v=638799843152330000&width=1200&height=1200&aspect=true', 'Weifeng', 8),
('Trípode Weifeng WF‑6663A 166 cm aluminio 5 kg', 'Trípode Weifeng WF‑6663A aluminio resistente, altura hasta 166.5 cm, carga 5 kg, cabezal giratorio 360°', 299.00, 15, 'https://coolboxpe.vtexassets.com/arquivos/ids/430814-1200-1200?v=638767180205300000&width=1200&height=1200&aspect=true', 'Weifeng', 8);

-- Televisores 
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Smart TV Innos 42″ Full HD Android TV 3 HDMI 2 USB Wi‑Fi 20 W', 'Smart TV Innos 42″ Full HD con Android TV, Wi‑Fi integrado, 3 HDMI, 2 USB, parlantes 20 W', 578.99, 10, 'https://coolboxpe.vtexassets.com/arquivos/ids/456407-1200-1200?v=638840689324170000&width=1200&height=1200&aspect=true', 'Innos', 9),
('Televisor Smart INNOS 24\" Android HD Wi‑Fi S2401KU', 'Smart TV INNOS 24\" con Android, Wi‑Fi integrado, 2 HDMI, 2 USB, HD+', 299.00, 10, 'https://coolboxpe.vtexassets.com/arquivos/ids/472363-1200-1200?v=638883005314270000&width=1200&height=1200&aspect=true', 'Innos', 9),
('Smart TV INNOS 32\" HD Android TV S3202KU4', 'Televisor INNOS 32\" HD con Android TV, Wi‑Fi, resolución HD, 2 HDMI, 2 USB, ideal para habitaciones', 379.00, 15, 'https://coolboxpe.vtexassets.com/arquivos/ids/433500-1200-1200?v=638773191764400000&width=1200&height=1200&aspect=true', 'Innos', 9),
('Smart TV LG 65\" 4K UHD AI WebOS 65UT7300PSA', 'LG 65\" 4K UHD Smart TV con sistema WebOS AI, 3 HDMI, 2 USB, calidad Ultra HD, HDR básico', 1989.00, 8, 'https://coolboxpe.vtexassets.com/arquivos/ids/379915-1200-1200?v=638773140604200000&width=1200&height=1200&aspect=true', 'LG', 9);

-- Proyectores
INSERT INTO Productos (nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria) VALUES
('Westminster HN-P200 PRO Android 3 700 lúmenes', 'Proyector portátil Westminster HN‑P200 PRO con Android integrado, 3 700 lúmenes, resolución Full HD', 349.90, 50, 'https://coolboxpe.vtexassets.com/arquivos/ids/390713-1200-1200?v=638635600172800000&width=1200&height=1200&aspect=true', 'Westminster', 10),
('Westminster LCD Full HD 12 000 lúmenes', 'Proyector portátil Westminster LCD Full HD hasta 12 000 lúmenes, Android, proyección 40–200″', 799.90, 30, 'https://coolboxpe.vtexassets.com/arquivos/ids/409097-1200-1200?v=638711719985570000&width=1200&height=1200&aspect=true', 'Westminster', 10),
('Epson EpiqVision FH02 3 000 lúmenes Full HD', 'Proyector Epson EpiqVision FH02 Full HD 1080p, streaming inalámbrico, altavoz integrado, hasta 300″', 1799.90, 15, 'https://coolboxpe.vtexassets.com/arquivos/ids/375900-1200-1200?v=638563956077900000&width=1200&height=1200&aspect=true', 'Epson', 10),
('Wanbo X5 Pro 1 100 ANSI lúmenes 1080p Android TV', 'Proyector Wanbo X5 Pro con 1 100 lúmenes ANSI, resolución 1080p, Android TV 11, Wi‑Fi, autoenfoque', 1529.00, 10, 'https://coolboxpe.vtexassets.com/arquivos/ids/472206-1200-1200?v=638882733491600000&width=1200&height=1200&aspect=true', 'Wanbo',10);

