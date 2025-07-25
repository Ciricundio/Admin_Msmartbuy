<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.mycompany.msmartbuy.config.DBConfig" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Productos</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
        <style>
            tr[data-id] {
                cursor: pointer;
            }
            dialog {
                max-width: 600px;
            }
        </style>
    </head>
    <body class="container" id="up">
        <div class="margin" style="margin: 6% 0 6% 0">
            <div style="  display: flex;
  justify-content: space-between;
  align-items: center;">
                <h2>📦 Inventario</h2>
                <a href="panel.jsp?vista=agregar" class="secondary">Atras</a>
            </div>

            <form method="GET" action="verProductos.jsp">
                <input type="text" name="busqueda" placeholder="Buscar producto..." value="<%= request.getParameter("busqueda") != null ? request.getParameter("busqueda") : ""%>">
                <button type="submit">Buscar</button>
            </form>

            <%
                String busqueda = request.getParameter("busqueda");

                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD);

                    String sql = "SELECT p.*, c.categoria AS categoria_nombre, u.nombre AS proveedor_nombre "
                            + "FROM producto p "
                            + "JOIN categoria c ON p.categoria_ID = c.ID "
                            + "JOIN usuario u ON p.proveedor_ID = u.ID ";

                    if (busqueda != null && !busqueda.trim().isEmpty()) {
                        sql += "WHERE p.ID = ? OR p.nombre LIKE ? OR p.marca LIKE ? ORDER BY p.ID";
                        stmt = conn.prepareStatement(sql);
                        try {
                            int idBuscado = Integer.parseInt(busqueda);
                            stmt.setInt(1, idBuscado);
                        } catch (NumberFormatException e) {
                            stmt.setInt(1, -1); // ID inválido, no devolverá resultados
                        }
                        stmt.setString(2, busqueda + "%"); // nombre que empieza por
                        stmt.setString(3, busqueda + "%"); // marca que empieza por
                    } else {
                        sql += "WHERE p.ID >= 1 ORDER BY p.ID";
                        stmt = conn.prepareStatement(sql);
                    }

                    rs = stmt.executeQuery();
            %>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Marca</th>
                        <th>Cantidad</th>
                        <th>Precio</th>
                        <th>Estado</th>
                        <th>Descuento (%)</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            int id = rs.getInt("ID");
                    %>
                    <tr data-id="<%= id%>" 
                        data-nombre="<%= rs.getString("nombre")%>" 
                        data-marca="<%= rs.getString("marca")%>" 
                        data-cantidad="<%= rs.getInt("cantidad")%>" 
                        data-precio="<%= rs.getDouble("precio_unitario")%>" 
                        data-estado="<%= rs.getString("estado")%>" 
                        data-descuento="<%= rs.getDouble("descuento")%>" 
                        data-descripcion="<%= rs.getString("descripcion")%>" 
                        data-sku="<%= rs.getString("sku")%>" 
                        data-peso="<%= rs.getDouble("peso")%>" 
                        data-fecha-inicio="<%= rs.getString("f_inicio_oferta")%>" 
                        data-fecha-fin="<%= rs.getString("f_final_oferta")%>" 
                        data-categoria="<%= rs.getString("categoria_nombre")%>"
                        data-proveedor="<%= rs.getString("proveedor_nombre")%>">
                        <td><%= id%></td>
                        <td><%= rs.getString("nombre")%></td>
                        <td><%= rs.getString("marca")%></td>
                        <td><%= rs.getInt("cantidad")%></td>
                        <td>$<%= rs.getDouble("precio_unitario")%></td>
                        <td><%= rs.getString("estado")%></td>
                        <td><%= rs.getDouble("descuento")%></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <a href="#up" class="secondary">Volver arriba</a>

            <!-- Modal -->
            <dialog id="detalleModal">
                <article>
                    <header>
                        <button onclick="document.getElementById('detalleModal').close()" aria-label="Cerrar" class="close"></button>
                        <p><strong>🧾 Detalle del producto</strong></p>
                    </header>
                    <p id="detalleDescripcion"></p>
                    <ul>
                        <li><strong>ID:</strong> <span id="detalleID"></span></li>
                        <li><strong>Nombre:</strong> <span id="detalleNombre"></span></li>
                        <li><strong>Marca:</strong> <span id="detalleMarca"></span></li>
                        <li><strong>Cantidad:</strong> <span id="detalleCantidad"></span></li>
                        <li><strong>Precio:</strong> <span id="detallePrecio"></span></li>
                        <li><strong>Descuento:</strong> <span id="detalleDescuento"></span>%</li>
                        <li><strong>Estado:</strong> <span id="detalleEstado"></span></li>
                        <li><strong>SKU:</strong> <span id="detalleSKU"></span></li>
                        <li><strong>Peso:</strong> <span id="detallePeso"></span> g</li>
                        <li><strong>Inicio oferta:</strong> <span id="detalleInicio"></span></li>
                        <li><strong>Fin oferta:</strong> <span id="detalleFin"></span></li>
                        <li><strong>Categoría:</strong> <span id="detalleCategoria"></span></li>
                        <li><strong>Proveedor:</strong> <span id="detalleProveedor"></span></li>
                    </ul>
                    <footer>
                        <a id="botonEditar" href="#" role="button">Editar</a>
                        <button class="secondary" onclick="document.getElementById('detalleModal').close()">Cerrar</button>
                    </footer>
                </article>
            </dialog>

            <script>
                document.querySelectorAll("tr[data-id]").forEach(row => {
                    row.addEventListener("click", () => {
                        const modal = document.getElementById("detalleModal");

                        const id = row.dataset.id;

                        document.getElementById("detalleID").textContent = id;
                        document.getElementById("detalleNombre").textContent = row.dataset.nombre;
                        document.getElementById("detalleMarca").textContent = row.dataset.marca;
                        document.getElementById("detalleCantidad").textContent = row.dataset.cantidad;
                        document.getElementById("detallePrecio").textContent = "$" + row.dataset.precio;
                        document.getElementById("detalleEstado").textContent = row.dataset.estado;
                        document.getElementById("detalleDescuento").textContent = row.dataset.descuento;
                        document.getElementById("detalleDescripcion").textContent = row.dataset.descripcion;
                        document.getElementById("detalleSKU").textContent = row.dataset.sku;
                        document.getElementById("detallePeso").textContent = row.dataset.peso;
                        document.getElementById("detalleInicio").textContent = row.dataset.fechaInicio || "N/A";
                        document.getElementById("detalleFin").textContent = row.dataset.fechaFin || "N/A";
                        document.getElementById("detalleCategoria").textContent = row.dataset.categoria || "N/A";
                        document.getElementById("detalleProveedor").textContent = row.dataset.proveedor || "N/A";

                        // botón de editar
                        document.getElementById("botonEditar").href = "editarProducto.jsp?id=" + id;

                        modal.showModal();
                    });
                });
            </script>

            <%
                } catch (Exception e) {
                    out.println("<article class='error'>❌ Error al consultar productos.</article>");
                } finally {
                    try {
                        if (rs != null) {
                            rs.close();
                        }
                    } catch (Exception e) {
                    }
                    try {
                        if (stmt != null) {
                            stmt.close();
                        }
                    } catch (Exception e) {
                    }
                    try {
                        if (conn != null) {
                            conn.close();
                        }
                    } catch (Exception e) {
                    }
                }
            %>
        </div>
    </body>
</html>