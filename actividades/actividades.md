### Actividad No. 1. 
Diseño de una base de datos para una Universidad


__Instrucciones__:

1. Lee, el caso de estudio proporcionado en el apartado de “Recursos para la solución”.
2. Identifica las entidades involucradas en la base de datos, que incluyen "ALUMNO," "ASIGNATURA" y "PROFESOR," junto con sus atributos específicos.
3. Diseña un diagrama E/R que represente de manera clara y precisa las relaciones entre estas entidades, utilizando notación de entidad, relación y atributo de manera adecuada.
4. Define las relaciones entre las entidades, como la relación "Cursa" entre alumnos y asignaturas, y la relación "Imparte" entre profesores y asignaturas.
5. Establece claves primarias para cada entidad, como el número de matrícula para los alumnos, el código de asignatura para las asignaturas y la identificación del profesor.
6. Asegúrate de que el diseño del diagrama E/R sea coherente con las especificaciones proporcionadas en la actividad, siguiendo las directrices y criterios de evaluación establecidos.
7. Además del diagrama en sí, debes proporcionar una explicación detallada y documentación sobre cómo se ha diseñado el diagrama E/R. Esto puede incluir descripciones de las entidades, atributos, relaciones y cualquier otra información relevante que ayude a comprender y evaluar el diseño.
8. Sube el documento a la plataforma para su evaluación.



### Actividad No.2: 
Gestión de una Base de Datos para una tienda en Línea

Te doy la bienvenida a la segunda actividad del curso de Base de Datos. En esta  actividad, aplicarás la  gestión de bases de datos aplicada a un contexto real. Tu misión es diseñar y gestionar una base de datos eficiente que ayudará a TechMart a mantener un control preciso de su inventario, realizar un seguimiento de los pedidos y gestionar la información de los clientes.

 
__Instrucciones__ 

1. Lee el caso de estudio planteado en el apartado de “Recursos para la solución”
2. Diseña la Base de Datos: Utiliza MySQL Workbench u otra herramienta de gestión de bases de datos para diseñar la estructura de la base de datos de __TechMart__. Debes incluir las siguientes tablas:
* __Productos__: Debe incluir campos como `"ID de Producto", "Nombre del Producto", "Descripción", "Precio", "Cantidad en Stock"` y cualquier otro que consideres necesario.
* __Clientes__: Debe incluir campos como `"ID de Cliente", "Nombre", "Apellido", "Dirección", "Correo Electrónico" y "Número de Teléfono"`.
* __Pedidos__: Debe incluir campos como `"ID de Pedido", "ID de Cliente", "Fecha del Pedido" y "Estado del Pedido"`.
* Detalle de Pedido: Debe incluir campos como `"ID de Detalle", "ID de Pedido", "ID de Producto", "Cantidad" y "Precio Unitario"`.
3. Utiliza SQL para crear la base de datos "TechMart" y las tablas diseñadas en el paso 1. Asegúrate de establecer las relaciones adecuadas entre las tablas utilizando claves primarias y foráneas.
4. Inserta __al menos cinco registros__ en cada tabla para simular datos de ejemplo. Asegúrate de que los datos sean realistas y coherentes.
5. Realiza las siguientes consultas SQL:
   * Encuentra todos los productos con un precio mayor a $500.
   * Encuentra todos los clientes cuyos nombres comienzan con "A".
   * Encuentra todos los pedidos realizados en el último mes.
   * Encuentra el total de ventas de cada producto (precio unitario multiplicado por cantidad vendida).
   * Encuentra los productos más vendidos (los que aparecen en la mayoría de los detalles de pedidos).
6. Elimina un producto y un cliente de la base de datos. Registra las eliminaciones realizadas.
7. Sube tu informe a la plataforma. Este proyecto te ayudará a comprender mejor cómo diseñar, crear y gestionar una base de datos en un entorno realista.
