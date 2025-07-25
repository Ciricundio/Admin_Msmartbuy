<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.mycompany.msmartbuy.config.DBConfig" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Categorías</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
        <style>
            table {
                width: 100%;
            }
            td form {
                display: inline;
            }
        </style>
    </head>
    <body class="container">
        <div style="margin: 8% 0 8% 0;">
            <div style="  display: flex;
                 justify-content: space-between;
                 align-items: center;">
                <h2>🆕 Gestión de Categorías</h2>
                <a href="panel.jsp?vista=agregar" class="secondary">Atras</a>
            </div>

            <%

                String mensaje = "";

                // Insertar nueva categoría
                if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("accion") != null) {
                    String accion = request.getParameter("accion");

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD);

                        if ("insertar".equals(accion)) {
                            String categoria = request.getParameter("categoria");
                            if (categoria != null && !categoria.trim().isEmpty()) {
                                PreparedStatement ps = conn.prepareStatement("INSERT INTO categoria (categoria) VALUES (?)");
                                ps.setString(1, categoria.trim());
                                ps.executeUpdate();
                                mensaje = "<article class='success'>✅ Categoría agregada correctamente.</article>";
                                ps.close();
                            } else {
                                mensaje = "<article class='error'>⚠️ El nombre no puede estar vacío.</article>";
                            }
                        } else if ("eliminar".equals(accion)) {
                            int id = Integer.parseInt(request.getParameter("id"));
                            PreparedStatement ps = conn.prepareStatement("DELETE FROM categoria WHERE ID = ?");
                            ps.setInt(1, id);
                            ps.executeUpdate();
                            mensaje = "<article class='success'>🗑️ Categoría eliminada correctamente.</article>";
                            ps.close();
                        } else if ("editar".equals(accion)) {
                            int id = Integer.parseInt(request.getParameter("id"));
                            String categoria = request.getParameter("categoria");
                            PreparedStatement ps = conn.prepareStatement("UPDATE categoria SET categoria = ? WHERE ID = ?");
                            ps.setString(1, categoria.trim());
                            ps.setInt(2, id);
                            ps.executeUpdate();
                            mensaje = "<article class='success'>✏️ Categoría actualizada correctamente.</article>";
                            ps.close();
                        }

                        conn.close();
                    } catch (Exception e) {
                        mensaje = "<article class='error'>❌ Error: " + e.getMessage() + "</article>";
                    }
                }
            %>

            <%= mensaje%>

            <!-- Formulario de agregar -->
            <form method="POST" action="agregarCategoria.jsp">
                <input type="hidden" name="accion" value="insertar">
                <label>Nombre de la Categoría
                    <input type="text" name="categoria" placeholder="Ej. Bebidas" required>
                </label>
                <button type="submit">Guardar</button>
            </form>

            <hr>

            <h3>Categorías existentes</h3>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD);
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM categoria ORDER BY ID");

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("ID")%></td>
                        <td>
                            <form method="POST" action="agregarCategoria.jsp" style="display:flex;gap:5px;">
                                <input type="hidden" name="accion" value="editar">
                                <input type="hidden" name="id" value="<%= rs.getInt("ID")%>">
                                <input type="text" name="categoria" value="<%= rs.getString("categoria")%>" required>
                                <button type="submit">Listo</button>
                            </form>
                        </td>
                        <td>
                            <form method="POST" action="agregarCategoria.jsp" onsubmit="return confirm('¿Eliminar esta categoría?')">
                                <input type="hidden" name="accion" value="eliminar">
                                <input type="hidden" name="id" value="<%= rs.getInt("ID")%>">
                                <button type="submit" class="secondary">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='3'>❌ Error al cargar categorías</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>
