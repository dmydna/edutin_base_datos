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
   FOREIGN KEY("pedido_id") REFERENCES "pedidos"("id"),
   FOREIGN KEY("producto_id") REFERENCES "clientes"("id")
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
    PRIMARY KEY("id");
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

CREATE TRIGGERS "eliminar_cliente"
BEFORE DELETE ON "clientes" 
FOR EACH ROW
BEGIN
   INSERT INTO "clientes_eliminados" ("cliente_id","nombre","apellido","direccion","email","telefono")
   VALUES (OLD."id", OLD."nombre",OLD."apellido",OLD."direccion",OLD."email", OLD."telefono")
END

CREATE TRIGGERS "eliminar_producto"
BEFORE DELETE ON "productos" 
FOR EACH ROW
BEGIN
   INSERT INTO "productos_eliminados" ("producto_id", "nombre","descripcion","precio","stock")
   VALUES (OLD."id", OLD."nombre",OLD."descripcion",OLD."precio",OLD."stock");
END


-- actualiza stock cuando un pedido esta 'completo' (solo cuando cantidad <= stock)
CREATE TRIGGERS "update_stock"
AFTER UPDATE OF "estado" ON "pedidos"
FOR EACH ROW
WHEN NEW."estado" = 'completo' AND OLD."estado" != 'completo' AND NEW."cantidad" <= 
    (SELECT stock FROM productos WHERE id = NEW.producto_id)
BEGIN
   UPDATE "productos" SET "stock" = "stock" - NEW."cantidad"
   WHERE "productos"."id" = NEW."producto_id"
END;


-- si el pedido excede stock ,entonces stock = 0 y cantidad = stock
CREATE TRIGGER "excede_stock"
AFTER UPDATE OF "cantidad" ON "detalles_pedido"
FOR EACH ROW
WHEN NEW."cantidad" > (SELECT "stock" FROM "producto" WHERE "id" = NEW."product_id")
BEGIN
   UPDATE "detalles_pedido"
      SET "cantidad" = (
      SELECT "stock"
      FROM "productos"
      WHERE "productos"."id" = NEW."producto_id"
   )
   WHERE "id" = NEW."id";

   UPDATE "productos" 
   SET "stock" = 0
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










