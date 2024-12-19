
-- TechMart

-- tablas csv generadas en 'mockaroo.com'
-- importa y crea tablas temporales

.import --csv clientes.csv clientesTmp
.import --csv productos.csv productosTmp
.import --csv pedidos.csv pedidosTmp
.import --csv detalles_pedido.csv detallesTmp


-- Diseño la Base de Datos:

-- Productos: Debe incluir campos como 
-- "ID de Producto", "Nombre del Producto", "Descripción", "Precio", "Cantidad en Stock"

CREATE TABLE "productos"(
    "id" INTEGER,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,
    "precio" NUMERIC NOT NULL CHECK("precio" >= 0),
    "stock" INTEGER CHECK("stock" >= 0),
    PRIMARY KEY("id")
);

-- Clientes: Debe incluir campos como 
-- "ID de Cliente", "Nombre", "Apellido", "Dirección", "Correo Electrónico" y "Número de Teléfono"

CREATE TABLE "clientes"(
    "id" INTEGER,
    "nombre" TEXT NOT NULL,
    "apellido" TEXT,
    "direccion" TEXT,
    "email" TEXT CHECK("email" LIKE '%_@%_'),
    "telefono" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

-- Pedidos: Debe incluir campos como
-- "ID de Pedido", "ID de Cliente", "Fecha del Pedido" y "Estado del Pedido".
CREATE TABLE "pedidos"(
    "id" INTEGER,
    "cliente_id" INTEGER NOT NULL,
    "fecha" TEXT DEFAULT CURRENT_TIMESTAMP,
    "estado" TEXT NOT NULL CHECK("estado" IN ('completo', 'en proceso', 'cancelado')),
    PRIMARY KEY("id"),
    FOREIGN KEY("cliente_id") REFERENCES "clientes"("id")
)

-- Detalle de Pedido: Debe incluir campos como 
-- "ID de Detalle", "ID de Pedido", "ID de Producto", "Cantidad" y "Precio Unitario"


-- solo agrego producto_id y cantidad
CREATE TABLE "detalles_pedido"(
   "id" INTEGER,
   "pedido_id" INTEGER NOT NULL,
   "producto_id" INTEGER NOT NULL,
   "cantidad" INTEGER NOT NULL CHECK("cantidad" > 0),
   "precio_por_unidad" NUMERIC,
   PRIMARY KEY("id"),
   FOREIGN KEY("pedido_id") REFERENCES "pedidos"("id") ON DELETE CASCADE,
   FOREIGN KEY("producto_id") REFERENCES "clientes"("id"),
 REFERENCES "productos"("precio")
);


-- registra clientes eliminados.
CREATE TABLE "clientes_eliminados" (
    "id" INTEGER,
    "cliente_id" INTEGER,
    "nombre" TEXT NOT NULL,
    "apellido" TEXT,
    "direccion" TEXT,
    "email" TEXT CHECK("email" LIKE '%_@%_'),
    "telefono" NUMERIC NOT NULL,
    "fecha_eliminacion" TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id")
);

-- registra productos eliminados.
CREATE TABLE "productos_eliminados"(
    "id" INTEGER,
    "producto_id" INTEGER NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,
    "precio" NUMERIC NOT NULL CHECK("precio" >= 0),
    "stock" INTEGER CHECK("stock" >= 0),
    "fecha_eliminacion" TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id")
);

CREATE TRIGGER "eliminar_cliente"
BEFORE DELETE ON "clientes" 
FOR EACH ROW
BEGIN
   INSERT INTO "borrados" ("cliente_id","nombre","apellido","direccion","email","telefono")
   VALUES (OLD."id", OLD."nombre",OLD."apellido",OLD."direccion",OLD."email", OLD."telefono");
END;

CREATE TRIGGER "eliminar_producto"
BEFORE DELETE ON "productos" 
FOR EACH ROW
BEGIN
   INSERT INTO "productos_eliminados" ("producto_id", "nombre","descripcion","precio","stock")
   VALUES (OLD."id", OLD."nombre",OLD."descripcion",OLD."precio",OLD."stock");
END;


-- actualiza stock cuando un pedido esta 'completo' (solo cuando cantidad <= stock)
CREATE TRIGGER "update_stock"
AFTER UPDATE OF "estado" ON "pedidos"
FOR EACH ROW
WHEN NEW."estado" = 'completo' AND OLD."estado" != 'completo' AND NEW."cantidad" <= 
    (SELECT stock FROM productos WHERE id = NEW.producto_id)
BEGIN
   UPDATE "productos" SET "stock" = "stock" - NEW."cantidad"
   WHERE "productos"."id" = NEW."producto_id";
END;


-- actualiza precios unitario de detalles del pedido
CREATE TRIGGER "actualizar_detalles"
AFTER INSERT ON "detalles_pedido"
FOR EACH ROW
BEGIN
   UPDATE "detalles_pedido" 
   SET "precio_por_unidad" = (
          SELECT "precio" 
          FROM "productos"
          WHERE "productos"."id" = "detalles_pedido"."producto_id"
       )
   WHERE "precio_por_unidad" IS NULL;
END;








-- inserta desde tabla temporal

INSERT INTO "clientes" ("nombre","apellido","email","direccion","telefono") 
SELECT "nombre","apellido","email","direccion","telefono"
FROM "clientesTmp";

INSERT INTO "productos" ("nombre","descripcion","precio","stock") 
SELECT "nombre","descripcion","precio","stock"
FROM "productosTmp";

INSERT INTO "pedidos" ("producto_id","cliente_id","fecha","estado")
SELECT "producto_id","cliente_id","fecha","estado"
FROM "pedidosTmp";

INSERT INTO "detalles_pedido" ("pedido_id","product_id","cantidad")



-- inserta valores manualmente
INSERT INTO "productos" ("nombre", "descripcion","precio","stock") 
VALUES ('Mouse Gamer','Mouse para juegos Razer DeathAdder Essential',20,5),
       ('Auriculares Manos Libre','Auriculares Samsung Galaxy con cable, Android USB C con micrófono',7.99,5),
       ('Teclado Gamer', 'Teclado mecánico para juegos HyperX Alloy Rise 75 Wireless', 229, 20);

INSERT INTO "clientes" ("nombre","apellido","email","telefono")
VALUES ('Jhon','Doe','jDoe@mail.com', '+54 9 1530 4444');



-- ACTIVIDADES

-- Encuentra todos los productos con un precio mayor a $500
SELECT * FROM "productos" WHERE "precio" > 500;

-- Encuentra todos los clientes cuyos nombres comienzan con "A".
SELECT * FROM "clientes" WHERE "nombre" LIKE 'A%';

-- Encuentra todos los pedidos realizados en el último mes.
SELECT * FROM "pedidos" WHERE "fecha" LIKE "%/12/%";

-- Encuentra el total de ventas de cada producto (precio unitario multiplicado por cantidad vendida).
SELECT (SELECT "nombre" FROM "productos" 
        WHERE "detalles_pedido"."producto_id" = "productos"."id") AS "producto" , 
       "cantidad" * "precio_por_unidad" AS "total_ventas"  
FROM "detalles_pedido" 
GROUP BY (SELECT "nombre" FROM "productos" 
          WHERE "detalles_pedido"."producto_id" = "productos"."id") 
ORDER BY "total_ventas" DESC; 

-- Encuentra los productos más vendidos (los que aparecen en la mayoría de los detalles de pedidos).
SELECT (SELECT "nombre" FROM "productos" WHERE "detalles_pedido"."producto_id" = "productos"."id") AS "producto" ,
       COUNT("product_id") AS "cantidad_vendidos" 
FROM "detalles_pedido" 
GROUP BY "producto_id" ORDER BY "cantidad_vendidos" DESC;




DELETE FROM "clientes" WHERE  "id"=25;
DELETE FROM "productos" WHERE "id"=25;

