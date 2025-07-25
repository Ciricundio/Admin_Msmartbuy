<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.mycompany.msmartbuy.config.DBConfig" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Ver Productos</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    </head>
    <body class="container">
        <%
            String id = request.getParameter("id");
            if (id == null) {
                response.sendRedirect("verProductos.jsp");
                return;
            }


            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
        %>

        <dialog open>
            <article>
                <header>
                    <a href="verProductos.jsp" aria-label="Cerrar" rel="prev"></a>
                    <p><strong>Editar Producto</strong></p>
                </header>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD);
                        stmt = conn.prepareStatement("SELECT * FROM producto WHERE ID = ?");
                        stmt.setInt(1, Integer.parseInt(id));
                        rs = stmt.executeQuery();

                        if (rs.next()) {
                %>
                <form action="ActualizarProductoServlet" method="post">
                    <input type="hidden" name="id" value="<%= rs.getInt("ID")%>">

                    <label>Nombre
                        <input type="text" name="nombre" value="<%= rs.getString("nombre")%>" required>
                    </label>
                    <label>Marca
                        <input type="text" name="marca" value="<%= rs.getString("marca")%>" required>
                    </label>
                    <label>Cantidad
                        <input type="number" name="cantidad" value="<%= rs.getInt("cantidad")%>" required>
                    </label>
                    <label>Precio
                        <input type="number" step="0.01" name="precio" value="<%= rs.getDouble("precio_unitario")%>" required>
                    </label>
                    <label>Descuento (%)
                        <input type="number" step="0.01" name="descuento" value="<%= rs.getDouble("descuento")%>" required>
                    </label>
                    <label>Estado
                        <select name="estado">
                            <option value="Disponible" <%= rs.getString("estado").equals("Disponible") ? "selected" : ""%>>Disponible</option>
                            <option value="Agotado" <%= rs.getString("estado").equals("Agotado") ? "selected" : ""%>>Agotado</option>
                        </select>
                    </label>
                    <button type="submit">Guardar cambios</button>
                </form>
                <%
                        } else {
                            out.println("<p>Producto no encontrado.</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p>Error al cargar datos del producto.</p>");
                    } finally {
                        try {
                            if (rs != null) {
                                rs.close();
                            }
                            if (stmt != null) {
                                stmt.close();
                            }
                            if (conn != null) {
                                conn.close();
                            }
                        } catch (Exception ex) {
                        }
                    }
                %>
            </article>
        </dialog>
    </body>
</html>