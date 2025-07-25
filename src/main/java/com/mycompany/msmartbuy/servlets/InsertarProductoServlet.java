package com.mycompany.msmartbuy.servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.mycompany.msmartbuy.config.DBConfig;

@MultipartConfig
@WebServlet(name = "InsertarProductoServlet", urlPatterns = {"/insertarProducto"})
public class InsertarProductoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            // Parámetros obligatorios
            String nombre = request.getParameter("nombre");
            String marca = request.getParameter("marca");
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));
            String descripcion = request.getParameter("descripcion");
            String sku = request.getParameter("sku");
            double peso = Double.parseDouble(request.getParameter("peso"));
            String estado = request.getParameter("estado");
            double precio = Double.parseDouble(request.getParameter("precio_unitario"));
            double descuento = Double.parseDouble(request.getParameter("descuento"));
            int categoriaID = Integer.parseInt(request.getParameter("categoria_ID"));
            int proveedorID = Integer.parseInt(request.getParameter("proveedor_ID"));

            // Fechas opcionales
            String fInicio = request.getParameter("f_inicio_oferta");
            String fFinal = request.getParameter("f_final_oferta");

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD)) {
                String sql = "INSERT INTO producto (nombre, marca, cantidad, descripcion, sku, f_inicio_oferta, f_final_oferta, peso, estado, precio_unitario, descuento, categoria_ID, proveedor_ID) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nombre);
                stmt.setString(2, marca);
                stmt.setInt(3, cantidad);
                stmt.setString(4, descripcion);
                stmt.setString(5, sku);

                // Validar fechas opcionales
                if (fInicio == null || fInicio.isEmpty()) {
                    stmt.setNull(6, Types.DATE);
                } else {
                    stmt.setDate(6, Date.valueOf(fInicio));
                }

                if (fFinal == null || fFinal.isEmpty()) {
                    stmt.setNull(7, Types.DATE);
                } else {
                    stmt.setDate(7, Date.valueOf(fFinal));
                }

                stmt.setDouble(8, peso);
                stmt.setString(9, estado);
                stmt.setDouble(10, precio);
                stmt.setDouble(11, descuento);
                stmt.setInt(12, categoriaID);
                stmt.setInt(13, proveedorID);

                stmt.executeUpdate();
                response.sendRedirect("panel.jsp?vista=agregar&success=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("panel.jsp?vista=agregar&error=Error al insertar");
        }
    }
}
