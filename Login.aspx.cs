using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session.Clear();
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();

        // Hardcoded temporary login
        if (username == "admin" && password == "12345")
        {
            Session["UserName"] = "Admin";
            Session["UserRole"] = "Administrator";
            Session["UserEmail"] = "admin@atm.com";
            Response.Redirect("index.aspx");
        }
        else
        {
            string script = "alert('Invalid Username or Password!');";
            ClientScript.RegisterStartupScript(this.GetType(), "alert", script, true);
        }
    }
}