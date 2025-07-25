<%-- 
    Document   : panel
    Created on : 24/07/2025, 11:45:08 a. m.
    Author     : LenovoV14G4-AMN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Msmartbuy - Admin</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    </head>
    <body class="container">
        <header>
            <nav>
                <ul>
                    <li><strong>Msmartbuy</strong></li>
                </ul>
                <ul>
                    <li><a href="panel.jsp" class="contrast">Inicio</a></li>
                    <li><a href="panel.jsp?vista=agregar" class="contrast">Inventario</a></li>
                    <li><a href="index.html" class="contrast">Cerrar sesión</a></li>
                </ul>
            </nav>
        </header>

        <main>
            <%
                String nombre = (String) session.getAttribute("nombre");
                if (nombre == null) {
                    response.sendRedirect("index.jsp");
                    return;
                }
            %>

            <h1>Hola, <%= nombre%>!</h1>

            <%
                String vista = request.getParameter("vista");
                if ("agregar".equals(vista)) {
            %>
            <div style="  display: flex;
  justify-content: space-between;
  align-items: center;">
                <h2>Formulario para agregar producto</h2>
                <div class="grid" style="width: 40%;">
                    <a href="verProductos.jsp" class="contrast">Ver productos</a>
                    <a href="agregarCategoria.jsp" class="contrast">Agregar categoría</a>
                </div>
            </div>
            <jsp:include page="agregarProducto.jsp" />
            <%
            } else {
            %>
            <p>Selecciona una opción del menú para comenzar.</p>
            <%
                }
            %>
        </main>
    </body>
</html>
