<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Dashboard.master" AutoEventWireup="true" CodeFile="Devices.aspx.cs" Inherits="Devices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>

        /* -----------------------------------------
           ACCENT SUPPORT (GLOBAL)
        -----------------------------------------*/
        :root {
            --accent: var(--primary-2);   /* MAIN ACCENT */
            --accent-light: var(--primary); 
        }

        /* Page Title */
        .page-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 16px;
            color: var(--text);
            border-left: 4px solid var(--accent);
            padding-left: 10px;
        }

        /* ===== SUMMARY AREA ===== */
        .summary-wrapper {
            background: var(--card);
            border-radius: 16px;
            padding: 18px;
            box-shadow: var(--shadow-sm);
            border: 1px solid rgba(15,23,42,0.06);
            margin-bottom: 20px;
        }

        .summary-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 14px;
            color: var(--accent);
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 18px;
        }

        .summary-card {
            background: var(--card);
            padding: 18px;
            border-radius: 16px;
            border: 1px solid rgba(15,23,42,0.06);
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 180px;
        }

        .chart-container {
            width: 120px;
            height: 120px;
        }

        .summary-number {
            margin-top: 18px;
            font-size: 36px;
            font-weight: 700;
            color: var(--text);
        }

        .summary-card h4 {
            margin-top: 12px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text);
        }

        /* ===== ACTION BAR ===== */
        .top-card {
            background: var(--card);
            border-radius: 14px;
            padding: 14px;
            box-shadow: var(--shadow-sm);
            border: 1px solid rgba(15,23,42,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }

        .columns-btn {
            padding: 8px 14px;
            border-radius: 10px;
            font-weight: 600;
            border: 1px solid rgba(15,23,42,0.12);
            background: var(--card);
            color: var(--text);
        }

        .search-box {
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--card);
            padding: 10px 14px;
            border-radius: 12px;
            border: 1px solid rgba(15,23,42,0.06);
            width: 300px;
        }

        .search-box input {
            width: 100%;
            background: transparent;
            border: none;
            outline: none;
            color: var(--text);
        }

        .top-right {
            display: flex;
            gap: 10px;
        }

        .action-btn {
            padding: 9px 18px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            background: linear-gradient(90deg, var(--accent-light), var(--accent));
            color: #fff;
            border: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ===== TABLE ===== */
        .table-card {
            background: var(--card);
            border-radius: 16px;
            box-shadow: var(--shadow-sm);
            border: 1px solid rgba(15,23,42,0.05);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: separate !important;
            border-spacing: 0 6px !important;  /* <-- RESTORES PERFECT ROW SPACING */
        }

        thead tr {
            background: transparent !important;
        }

        th {
            padding: 14px;
            background: rgba(15,23,42,0.04);
            font-weight: 700;
            color: var(--accent);
            text-align: left;
        }

        tbody tr {
            background: var(--card);
            border-radius: 10px;
            box-shadow: var(--shadow-sm);
        }

        tbody tr td:first-child {
            border-radius: 10px 0 0 10px;
        }

        tbody tr td:last-child {
            border-radius: 0 10px 10px 0;
        }

        td {
            padding: 14px;
            color: var(--text);
        }

        /* Status Badge */
        .status-badge {
            padding: 6px 12px;
            background: #d1fae5;
            color: #059669;
            border-radius: 8px;
            font-weight: 600;
        }

        .tag-iot {
            padding: 6px 12px;
            background: #e0e7ff;
            color: #3730a3;
            border-radius: 8px;
            font-weight: 600;
        }

        .tag-lock {
            padding: 6px 12px;
            background: #fee2e2;
            color: #b91c1c;
            border-radius: 8px;
            font-weight: 600;
        }

        /* ===== MODAL ===== */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            display: none;
            z-index: 99998;
        }

        .modal-box {
            width: 420px;
            background: var(--card);
            padding: 20px;
            border-radius: 14px;
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 99999;
        }

        .modal-box input,
        .modal-box select {
            width: 100%;
            padding: 10px 12px;
            border-radius: 10px;
            border: 1px solid rgba(15,23,42,0.12);
            background: var(--card);
            margin-bottom: 12px;
            color: var(--text);
        }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-cancel, .btn-save {
            padding: 8px 14px;
            border-radius: 8px;
            font-weight: 600;
            border: none;
            cursor: pointer;
        }

        .btn-cancel {
            background: #e5e7eb;
        }

        .btn-save {
            background: linear-gradient(90deg, var(--accent-light), var(--accent));
            color: white;
        }

        /* ===========================================
   RESPONSIVE FIX — DEVICES PAGE (MOBILE FIRST)
   =========================================== */

/* --- Page Heading Fix --- */
@media (max-width: 768px) {
    .page-heading {
        margin-top: 12px !important;
        gap: 10px !important;
    }
    .page-heading h2 {
        font-size: 22px !important;
    }
    .page-heading div:last-child {
        font-size: 12px !important;
    }
    .heading-accent {
        height: 40px !important;
    }
}

/* --- Summary Grid --- */
@media (max-width: 1020px) {
    .summary-grid {
        grid-template-columns: repeat(2, 1fr) !important;
        gap: 14px !important;
    }
}
@media (max-width: 640px) {
    .summary-grid {
        grid-template-columns: 1fr !important;
    }
    .summary-card {
        min-height: 140px !important;
        padding: 14px !important;
    }
    .summary-number {
        font-size: 30px !important;
    }
    .chart-container {
        width: 90px !important;
        height: 90px !important;
    }
}

/* --- Search & Actions Bar --- */
@media (max-width: 900px) {

    .top-card {
        flex-direction: column !important;
        gap: 14px !important;
        align-items: stretch !important;
    }

    .top-left,
    .top-right {
        width: 100% !important;
    }

    .top-right {
        display: flex;
        flex-direction: column;
        gap: 8px !important;
    }

    .action-btn {
        width: 100% !important;
        justify-content: center !important;
        font-size: 15px !important;
        padding: 12px !important;
    }

    .search-box {
        width: 100% !important;
    }
}

/* --- Table responsiveness --- */
/* ============================
   MOBILE FRIENDLY TABLE FIX
   Turns each row into a card
============================ */
@media (max-width: 768px) {

    .table-card {
        border: none;
        background: transparent;
        box-shadow: none;
    }

    table thead {
        display: none !important; /* hide table header */
    }

    table, tbody, tr, td {
        display: block;
        width: 100%;
    }

    tbody tr {
        background: var(--card);
        margin-bottom: 16px;
        padding: 14px;
        border-radius: 14px;
        box-shadow: var(--shadow-sm);
    }

    tbody tr td {
        padding: 6px 0;
        text-align: right;
        font-size: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px dashed rgba(255,255,255,0.06);
    }

    tbody tr td:last-child {
        border-bottom: none;
    }

    /* Label before each value */
    tbody tr td::before {
        content: attr(data-label);
        font-weight: 600;
        color: var(--muted);
        text-align: left;
    }
}


/* --- Modal Fix --- */
@media (max-width: 600px) {
    .modal-box {
        width: 90% !important;
        padding: 16px !important;
    }
    .modal-box input,
    .modal-box select {
        font-size: 14px !important;
    }
}


    </style>



  <!-- PAGE HEADING (Unified across all pages) -->
<div class="page-heading" style="
    display:flex;
    align-items:center;
    gap:14px;
    margin-bottom:22px;
">
    <div class="heading-accent"
         style="width:6px;height:48px;border-radius:4px;
         background:linear-gradient(180deg,var(--accent-light),var(--accent));
         flex-shrink:0;"></div>

    <div>
        <h2 style="margin:0;font-size:26px;font-weight:800;color:var(--text);">
            Devices
        </h2>
        <div style="margin-top:0px;font-size:13px;color:var(--muted);">
            Manage device models, status and configurations
        </div>
    </div>
</div>



    <!-- SUMMARY CARDS -->
    <div class="summary-wrapper">
        <div class="summary-title">Summary</div>

        <div class="summary-grid">

            <div class="summary-card">
                <div class="chart-container"><canvas id="chartDeviceTypes"></canvas></div>
                <h4>Device Types</h4>
            </div>

            <div class="summary-card">
                <div class="chart-container"><canvas id="chartDeviceStatus"></canvas></div>
                <h4>Device Status</h4>
            </div>

            <div class="summary-card">
                <div class="chart-container"><canvas id="chartManufacturers"></canvas></div>
                <h4>Top Manufacturers</h4>
            </div>

            <div class="summary-card">
                <div class="summary-number">10</div>
                <h4>Total Devices</h4>
            </div>

            <div class="summary-card">
                <div class="summary-number" style="color:#dc2626;">0</div>
                <h4>Inactive Devices</h4>
            </div>

        </div>
    </div>


    <!-- ACTION BAR -->
    <div class="top-card">
        <div class="top-left">
            <button class="columns-btn"><i class="fa-solid fa-table-columns"></i> Columns</button>

            <div class="search-box">
                <input type="text" placeholder="Search for vehicles or devices..." />
                <i class="fa-solid fa-magnifying-glass" style="color:var(--accent)"></i>
            </div>
        </div>

        <div class="top-right">
            <button class="action-btn"><i class="fa-solid fa-file-import"></i> Import</button>
            <button class="action-btn"><i class="fa-solid fa-download"></i> Export</button>
            <button type="button" class="action-btn" onclick="openAddModal(event)">
                <i class="fa-solid fa-plus"></i> Add
            </button>
        </div>
    </div>


    <!-- TABLE -->
    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Device Model ID</th>
                    <th>Device Model Name</th>
                    <th>Manufacturer</th>
                    <th>Device Type</th>
                    <th>IP Address</th>
                    <th>Port</th>
                    <th>Status</th>
                    <th>Created On</th>
                </tr>
            </thead>

            <tbody>
                <asp:Repeater ID="rptDevices" runat="server">
                    <ItemTemplate>
                        <tr>
                          <td data-label="Device Model ID"><%# Eval("DeviceModelID") %></td>
<td data-label="Device Model Name"><%# Eval("DeviceModelName") %></td>
<td data-label="Manufacturer"><%# Eval("Manufacturer") %></td>
<td data-label="Device Type">
    <%# Eval("DeviceType").ToString()=="IOT"
        ? "<span class='tag-iot'>IOT</span>"
        : "<span class='tag-lock'>LOCK</span>" %>
</td>
<td data-label="IP Address"><%# Eval("IPAddress") %></td>
<td data-label="Port"><%# Eval("Port") %></td>
<td data-label="Status"><span class="status-badge">Active</span></td>
<td data-label="Created On"><%# Eval("CreatedOn") %></td>

                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>


    <!-- MODAL -->
    <div id="modalOverlay" class="modal-overlay"></div>

    <div id="addModal" class="modal-box" onclick="event.stopPropagation()">
        <h3 style="font-size:18px;font-weight:700;margin-bottom:10px;color:var(--accent)">Add New Device</h3>

        <asp:TextBox runat="server" ID="txtDeviceModelID" placeholder="Device Model ID"></asp:TextBox>
        <asp:TextBox runat="server" ID="txtDeviceModelName" placeholder="Device Model Name"></asp:TextBox>
        <asp:TextBox runat="server" ID="txtManufacturer" placeholder="Manufacturer"></asp:TextBox>

        <asp:DropDownList runat="server" ID="ddlDeviceType">
            <asp:ListItem>IOT</asp:ListItem>
            <asp:ListItem>LOCK</asp:ListItem>
        </asp:DropDownList>

        <asp:TextBox runat="server" ID="txtIP" placeholder="IP Address"></asp:TextBox>
        <asp:TextBox runat="server" ID="txtPort" placeholder="Port"></asp:TextBox>

        <div class="modal-actions">
            <button type="button" class="btn-cancel" onclick="closeAddModal()">Cancel</button>
            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn-save" OnClick="btnSave_Click" />
        </div>
    </div>


    <!-- JS -->
    <script>

        function openAddModal(e) {
            if (e) e.stopPropagation();
            document.getElementById("modalOverlay").style.display = "block";
            document.getElementById("addModal").style.display = "block";
        }

        function closeAddModal() {
            document.getElementById("modalOverlay").style.display = "none";
            document.getElementById("addModal").style.display = "none";
        }

        document.getElementById("modalOverlay").addEventListener("click", function (e) {
            if (e.target === this) closeAddModal();
        });


        /* CHARTS ----------------------------------------------------*/

        new Chart(document.getElementById("chartDeviceTypes"), {
            type: "pie",
            data: {
                labels: ["IOT", "LOCK"],
                datasets: [{
                    data: [60, 40],
                    backgroundColor: [varAccent(1), "#ef4444"]
                }]
            }
        });

        new Chart(document.getElementById("chartDeviceStatus"), {
            type: "pie",
            data: {
                labels: ["Active", "Inactive"],
                datasets: [{
                    data: [90, 10],
                    backgroundColor: ["#10b981", "#f87171"]
                }]
            }
        });

        new Chart(document.getElementById("chartManufacturers"), {
            type: "pie",
            data: {
                labels: ["Local", "Imported", "OEM"],
                datasets: [{
                    data: [50, 30, 20],
                    backgroundColor: [varAccent(1), "#f59e0b", "#ec4899"]
                }]
            }
        });

        function varAccent(opacity = 1) {
            const rgb = getComputedStyle(document.documentElement).getPropertyValue('--primary-2');
            return rgb.trim();
        }

    </script>

</asp:Content>
