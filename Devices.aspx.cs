using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Devices : System.Web.UI.Page
{
    private DataTable DeviceData
    {
        get
        {
            if (Session["DeviceData"] == null)
            {
                DataTable dt = new DataTable();

                dt.Columns.Add("DeviceModelID");
                dt.Columns.Add("DeviceModelName");
                dt.Columns.Add("Manufacturer");
                dt.Columns.Add("DeviceType");
                dt.Columns.Add("IPAddress");
                dt.Columns.Add("Port");
                dt.Columns.Add("CreatedOn");

                dt.Rows.Add("DVE0010", "test5", "test", "LOCK", "123.123.2.126", "5342", "16/11/2025");
                dt.Rows.Add("DVE0009", "test3", "test", "IOT", "123.123.1.124", "1234", "15/11/2025");

                Session["DeviceData"] = dt;
            }

            return Session["DeviceData"] as DataTable;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            BindRepeater();
    }

    private void BindRepeater()
    {
        rptDevices.DataSource = DeviceData;
        rptDevices.DataBind();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        DataTable dt = DeviceData;

        // Simple validation (ensure at least ID and name provided)
        string id = txtDeviceModelID.Text?.Trim();
        string name = txtDeviceModelName.Text?.Trim();

        if (string.IsNullOrEmpty(id) || string.IsNullOrEmpty(name))
        {
            // feedback could be improved - for now just return.
            // You can show a toast or label in future.
            return;
        }

        dt.Rows.Add(
            id,
            name,
            txtManufacturer.Text?.Trim(),
            ddlDeviceType.SelectedValue,
            txtIP.Text?.Trim(),
            txtPort.Text?.Trim(),
            DateTime.Now.ToString("dd/MM/yyyy")
        );

        Session["DeviceData"] = dt;
        BindRepeater();

        // clear modal inputs
        txtDeviceModelID.Text = "";
        txtDeviceModelName.Text = "";
        txtManufacturer.Text = "";
        ddlDeviceType.SelectedIndex = 0;
        txtIP.Text = "";
        txtPort.Text = "";

        // close modal via JS
        ScriptManager.RegisterStartupScript(this, GetType(), "closeModal", "closeAddModal();", true);
    }
}