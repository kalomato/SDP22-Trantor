# SDP22-Trantor
Proyecto final SDP 2022

NOTAS DE LA APLICACIÓN
La contraseña no se valida. Sólo verifica que tenga más de 6 caracteres.
Por defecto pongo un valor en el formulario de login por comodidad, pero lógicamente se puede poner cualquier otro usuario. 


NOTAS: 
En la vista LoginView, utilizo NavigationLink para cargar la vista TabsView una vez validado el usuario. Me da el aviso de que estoy usando funcionalidad "deprecada". Pero es que no he logrado modificarlo para que utilice la nueva forma. 


FALLOS CONOCIDOS SIN RESOLVER AL MOMENTO DE LA ENTREGA:

*Cuando un pedido tiene más de un libro, al tocar sobre un libro se abre el sheet del último libro del pedido.

*Vista Pedidos: Debería buscar pedidos por estado, npedido, y también título y autor de los libros que estén en algún pedido. Pero solo busca por estado y npedido. (Búsqueda definida en OrdersViewModel.swift, líneas 36 y 37)

*Vista OrderRow: La preview "crashes".



FUNCIONALIDADES QUE NO ME HA DADO TIEMPO A IMPLEMENTAR:

Funcionalidad de compra. 
Valorar libros. 
Crear usuario.
Modificar usuario
Funcionalidad de admin para gestión de usuarios y pedidos.
