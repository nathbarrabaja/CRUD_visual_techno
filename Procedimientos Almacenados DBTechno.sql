--PROCEDIMIENTO ALMACENADO PARA  USUARIOS
CREATE OR ALTER PROCEDURE sp_RegistrarUsuario
    @nombreCompleto NVARCHAR(100),
    @correo NVARCHAR(100),
    @clave NVARCHAR(100),
    @idRol INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Usuarios WHERE correo = @correo)
    BEGIN
        RAISERROR('El correo ya está registrado.', 16, 1);
        RETURN;
    END

    INSERT INTO Usuarios (nombreCompleto, correo, clave, idRol)
    VALUES (@nombreCompleto, @correo, @clave, @idRol);
END;
GO

CREATE OR ALTER PROCEDURE sp_LoginUsuario
    @correo NVARCHAR(100),
    @clave NVARCHAR(100)
AS
BEGIN
    SELECT idUsuario, nombreCompleto, correo, idRol
    FROM Usuarios
    WHERE correo = @correo AND clave = @clave;
END
GO


--PROCEDIMIENTOS ALMACENADOS (LISTADO CLIENTE PRODUCTOS)
CREATE OR ALTER PROC usp_productos
AS
SELECT 
    p.idProducto,
    p.nombre,
    p.descripcion,
    p.precio,
    p.stock,
    p.urlImagen,
	p.marca,
    p.idSubCategoria
FROM Productos p;
GO

CREATE OR ALTER PROCEDURE usp_productoXid
    @idProducto INT
AS
BEGIN
    SELECT idProducto,
           nombre,
           descripcion,
           precio,
           stock,
           urlImagen,
		   marca,
           idSubCategoria
    FROM Productos
    WHERE idProducto = @idProducto
END
GO


-- PROCEDIMIENTOS ALMACENADOS (CRUD ADMIN PRODUCTOS)
CREATE OR ALTER PROC usp_productos_admin
AS
SELECT 
    p.idProducto,
    p.nombre,
    p.descripcion,
    p.precio,
    p.stock,
	p.urlImagen,
	p.marca,
	sc.idSubCategoria,
    sc.nombre AS nombreSubCategoria
FROM Productos p
INNER JOIN SubCategorias sc ON p.idSubCategoria = sc.idSubCategoria;
GO

CREATE OR ALTER PROCEDURE usp_inserta_producto
@nombre NVARCHAR(100),
@descripcion NVARCHAR(255),
@precio DECIMAL(10,2),
@stock INT,
@urlImagen NVARCHAR(300),
@marca NVARCHAR(50),
@idSubCategoria INT
AS
INSERT INTO Productos(nombre, descripcion, precio, stock, urlImagen, marca, idSubCategoria)
VALUES (@nombre, @descripcion, @precio, @stock, @urlImagen, @marca, @idSubCategoria)
GO

CREATE OR ALTER PROCEDURE usp_editar_producto
@idProducto INT,
@nombre NVARCHAR(100),
@descripcion NVARCHAR(255),
@precio DECIMAL(10,2),
@stock INT,
@urlImagen NVARCHAR(300),
@marca NVARCHAR(50),
@idSubCategoria INT
AS
BEGIN
    UPDATE Productos
    SET nombre = @nombre,
        descripcion = @descripcion,
        precio = @precio,
        stock = @stock,
		urlImagen = @urlImagen,
		marca = @marca,
        idSubCategoria = @idSubCategoria
    WHERE idProducto = @idProducto
END
GO

CREATE OR ALTER PROC usp_consulta_id_productos
@idProducto INT
AS
BEGIN
SELECT 
    p.nombre,
    p.descripcion,
    p.precio,
    p.stock,
	p.urlImagen,
	p.marca,
	p.idSubCategoria,
    sc.nombre AS nombreSubCategoria
FROM Productos p
INNER JOIN SubCategorias sc ON p.idSubCategoria = sc.idSubCategoria
WHERE p.idProducto = @idProducto;
END
GO 
 
CREATE OR ALTER PROC usp_eliminar_producto
    @idProducto INT
AS
BEGIN
    DELETE FROM Productos
    WHERE idProducto = @idProducto;
END;
GO

--PROCEDIMIENTOS ALMACENADOS (CRUD CATEGORIAS)

CREATE OR ALTER PROC usp_categorias
AS
SELECT 
    c.idCategoria,
    c.nombre
FROM Categorias c;
GO

CREATE OR ALTER PROC usp_inserta_categoria
@nombre VARCHAR(50)
AS
INSERT INTO Categorias(nombre)
VALUES (@nombre)
GO

CREATE OR ALTER PROCEDURE usp_editar_categoria
@idCategoria INT,
@nombre varchar(50)
AS
BEGIN
    UPDATE Categorias
    SET nombre = @nombre
	 WHERE idCategoria = @idCategoria;
END
GO

CREATE OR ALTER PROC usp_consulta_id_categoria
@idCategoria INT
AS
BEGIN
SELECT 
    c.nombre
FROM Categorias c
WHERE c.idCategoria = @idCategoria;
END
GO 

CREATE OR ALTER PROC usp_eliminar_categoria
    @idCategoria INT
AS
BEGIN
    DELETE FROM Categorias
    WHERE idCategoria = @idCategoria;
END;
GO

--PROCEDIMIENTOS ALMACENADOS (CRUD SUBCATEGORIAS)

CREATE OR ALTER PROC usp_subcategorias
AS
SELECT 
    sc.idSubCategoria,
    sc.nombre,
	c.idCategoria,
	c.nombre as nombreCategoria
FROM SubCategorias sc
INNER JOIN Categorias c ON sc.idCategoria = c.idCategoria;
GO

create or alter proc usp_inserta_subcategorias
@nombre varchar(100),
@idCategoria int
as 
insert into SubCategorias(nombre, idCategoria)
values (@nombre, @idCategoria)
go

CREATE OR ALTER PROCEDURE usp_editar_subcategorias
@idSubCategoria INT,
@nombre varchar(100),
@idCategoria int
AS
BEGIN
    UPDATE SubCategorias
    SET nombre = @nombre,
        idCategoria = @idCategoria
    WHERE idSubCategoria = @idSubCategoria
END
GO

CREATE OR ALTER PROC usp_consulta_id_subcategoria
@idSubCategoria INT
AS
BEGIN
    SELECT 
        sc.nombre,
        sc.idCategoria,
        c.nombre AS nombreCategoria
    FROM SubCategorias sc
    INNER JOIN Categorias c ON sc.idCategoria = c.idCategoria
    WHERE sc.idSubCategoria = @idSubCategoria;
END
GO

 
CREATE OR ALTER PROC usp_eliminar_subcategoria
@idSubCategoria INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Productos WHERE idSubCategoria = @idSubCategoria)
    BEGIN
        RAISERROR('No se puede eliminar: existen productos asociados a esta subcategoría.', 16, 1);
        RETURN;
    END

    DELETE FROM SubCategorias
    WHERE idSubCategoria = @idSubCategoria;
END
GO



EXEC usp_subcategorias;

EXEC usp_inserta_subcategorias 
    @nombre = 'Teclados Mecánicos',
    @idCategoria = 1;

EXEC usp_editar_subcategorias 
    @idSubCategoria = 1,
    @nombre = 'Audífonoss',
    @idCategoria = 1;

EXEC usp_consulta_id_subcategoria 
    @idSubCategoria = 2;

EXEC usp_eliminar_subcategoria 
    @idSubCategoria = 12; 



-- PROCEDIMIENTOS PEDIDOS Y DETALLE PEDIDOS 
USE DBTechno
GO

CREATE OR ALTER PROCEDURE usp_generar_pedido
    @idUsuario INT,
    @idPedido INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @total DECIMAL(10,2);

    IF NOT EXISTS (SELECT 1 FROM Carrito WHERE idUsuario = @idUsuario)
    BEGIN
        RAISERROR('El carrito está vacío. No se puede generar el pedido.', 16, 1);
        RETURN;
    END

    SELECT @total = ISNULL(SUM(p.precio * c.cantidad), 0)
    FROM Carrito c
    JOIN Productos p ON c.idProducto = p.idProducto
    WHERE c.idUsuario = @idUsuario;

    INSERT INTO Pedidos(idUsuario, total)
    VALUES(@idUsuario, @total);

    SET @idPedido = SCOPE_IDENTITY();

    INSERT INTO DetallePedido(idPedido, idProducto, cantidad, precioUnitario)
    SELECT @idPedido, c.idProducto, c.cantidad, p.precio
    FROM Carrito c
    JOIN Productos p ON c.idProducto = p.idProducto
    WHERE c.idUsuario = @idUsuario;

    DELETE FROM Carrito WHERE idUsuario = @idUsuario;
END
GO

select * from Pedidos

CREATE OR ALTER PROCEDURE SP_ListarPedidosPorUsuario
    @idUsuario INT
AS
BEGIN
    SELECT idPedido, fechaPedido, total
    FROM Pedidos
    WHERE idUsuario = @idUsuario
    ORDER BY fechaPedido DESC;
END

exec SP_ListarPedidosPorUsuario 1

CREATE OR ALTER PROCEDURE SP_EliminarPedido
    @idPedido INT
AS
BEGIN
    DELETE FROM DetallePedido WHERE idPedido = @idPedido;
    DELETE FROM Pedidos WHERE idPedido = @idPedido;
END
GO
