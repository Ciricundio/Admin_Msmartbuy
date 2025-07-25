package com.mycompany.msmartbuy.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.mycompany.msmartbuy.config.DBConfig;
import at.favre.lib.crypto.bcrypt.BCrypt;

@WebServlet(name = "loginServlets", urlPatterns = {"/login"})
public class loginServlets extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conexion = DriverManager.getConnection(DBConfig.URL, DBConfig.USER, DBConfig.PASSWORD)) {

                String sql = "SELECT nombre, contrasena FROM usuario WHERE correo = ?";
                PreparedStatement stmt = conexion.prepareStatement(sql);
                stmt.setString(1, usuario);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String hashAlmacenado = rs.getString("contrasena");

                    // Verificar el hash con la librería que acepta $2y$
                    BCrypt.Result resultado = BCrypt.verifyer()
                        .verify(contrasena.toCharArray(), hashAlmacenado);

                    if (resultado.verified) {
                        // Inicio de sesión correcto
                        HttpSession session = request.getSession();
                        session.setAttribute("nombre", rs.getString("nombre"));
                        response.sendRedirect("panel.jsp");
                    } else {
                        // Contraseña incorrecta
                        response.sendRedirect("index.html?error=contrasena_incorrecta");
                    }
                } else {
                    // Usuario no encontrado
                    response.sendRedirect("index.html?error=usuario_no_encontrado");
                }

            } catch (SQLException ex) {
                Logger.getLogger(loginServlets.class.getName()).log(Level.SEVERE, null, ex);
                response.sendRedirect("error.jsp");
            }

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(loginServlets.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet de login con verificación de hash PHP ($2y$) usando at.favre.lib.bcrypt";
    }
}
