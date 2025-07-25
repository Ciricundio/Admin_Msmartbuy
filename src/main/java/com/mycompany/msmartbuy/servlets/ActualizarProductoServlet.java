package com.mycompany.msmartbuy.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.logging.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.mycompany.msmartbuy.config.DBConfig;

@WebServlet(name = "ActualizarProductoServlet", urlPatterns = {"/ActualizarProductoServlet"})
public class ActualizarProductoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String marca = request.getParameter("marca");
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        double precio = Double.parseDouble(request.getParameter("precio"));
        double descuento = Double.parseDouble(request.getParameter("descuento"));
        String estado = request.getParameter("estado");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD)) {
                String sql = "UPDATE producto SET nombre = ?, marca = ?, cantidad = ?, precio_unitario = ?, descuento = ?, estado = ? WHERE ID = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nombre);
                stmt.setString(2, marca);
                stmt.setInt(3, cantidad);
                stmt.setDouble(4, precio);
                stmt.setDouble(5, descuento);
                stmt.setString(6, estado);
                stmt.setInt(7, id);

                int filas = stmt.executeUpdate();

                if (filas > 0) {
                    response.sendRedirect("verProductos.jsp?actualizado=1");
                } else {
                    response.sendRedirect("verProductos.jsp?error=No se pudo actualizar");
                }

            }
        } catch (Exception e) {
            Logger.getLogger(ActualizarProductoServlet.class.getName()).log(Level.SEVERE, null, e);
            response.sendRedirect("verProductos.jsp?error=Error al actualizar");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para actualizar datos de un producto";
    }
}