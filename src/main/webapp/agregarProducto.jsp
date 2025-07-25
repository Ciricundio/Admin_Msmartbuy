<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.mycompany.msmartbuy.config.DBConfig" %>

<!DOCTYPE html>
<html lang="es">

    <body class="container">

        <div>

            <%-- Mensaje de éxito --%>
            <%
                if ("1".equals(request.getParameter("success"))) {
            %>
            <article class="success">Producto guardado correctamente.</article>
                <%
                    }
                %>

            <%-- Mensaje de error --%>
            <%
                String error = request.getParameter("error");
                if (error != null) {
            %>
            <article class="error"><%= error%></article>
                <%
                    }

                    Connection conn = null;
                    PreparedStatement psCat = null;
                    PreparedStatement psProv = null;
                    ResultSet rsCategorias = null;
                    ResultSet rsProveedores = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD);

                        psCat = conn.prepareStatement("SELECT ID, categoria FROM categoria");
                        rsCategorias = psCat.executeQuery();

                        psProv = conn.prepareStatement("SELECT ID, nombre FROM usuario WHERE rol = 'proveedor'");
                        rsProveedores = psProv.executeQuery();
                %>

            <form action="insertarProducto" method="post" enctype="multipart/form-data">
                <label>Nombre
                    <input type="text" name="nombre" required>
                </label>

                <label>Marca
                    <input type="text" name="marca" required>
                </label>

                <label>Cantidad
                    <input type="number" name="cantidad" min="1" required>
                </label>

                <label>Descripción
                    <textarea name="descripcion" required></textarea>
                </label>

                <label>SKU
                    <input type="text" name="sku" required>
                </label>

                <label>Fecha inicio oferta
                    <input type="date" name="f_inicio_oferta">
                </label>

                <label>Fecha final oferta
                    <input type="date" name="f_final_oferta">
                </label>

                <label>Foto
                    <input type="file" name="foto" accept="image/*">
                </label>

                <label>Peso (g)
                    <input type="number" step="0.01" name="peso" required>
                </label>

                <label>Estado
                    <select name="estado" required>
                        <option value="Disponible">Disponible</option>
                        <option value="Agotado">Agotado</option>
                    </select>
                </label>

                <label>Precio unitario
                    <input type="number" step="0.01" name="precio_unitario" required>
                </label>

                <label>Descuento (%)
                    <input type="number" step="0.01" name="descuento" value="0">
                </label>

                <label>Categoría
                    <select name="categoria_ID" required>
                        <option value="">Seleccione...</option>
                        <%
                            while (rsCategorias.next()) {
                        %>
                        <option value="<%= rsCategorias.getInt("ID")%>">
                            <%= rsCategorias.getString("categoria")%>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </label>

                <label>Proveedor
                    <select name="proveedor_ID" required>
                        <option value="">Seleccione...</option>
                        <%
                            while (rsProveedores.next()) {
                        %>
                        <option value="<%= rsProveedores.getInt("ID")%>">
                            <%= rsProveedores.getString("nombre")%>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </label>

                <button type="submit">Guardar producto</button>
            </form>

            <a href="panel.jsp" class="secondary">⬅ Volver al panel</a>

            <%
                } catch (Exception e) {
                    out.println("<article class='error'>Error al cargar categorías o proveedores: " + e.getMessage() + "</article>");
                } finally {
                    try {
                        if (rsCategorias != null) {
                            rsCategorias.close();
                        }
                        if (rsProveedores != null) {
                            rsProveedores.close();
                        }
                        if (psCat != null) {
                            psCat.close();
                        }
                        if (psProv != null) {
                            psProv.close();
                        }
                        if (conn != null) {
                            conn.close();
                        }
                    } catch (Exception ignore) {
                    }
                }
            %>
        </div>

    </body>
</html>
