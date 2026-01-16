---
layout: post
title: Efficiently handle 1000 plotly plots in a self-contained HTML file
comments: true
tags: [plotly,html]
---

Gemini chat [here](https://g.co/gemini/share/9c342f981697).

## Prompt

```md
I have 1000 polars LazyFrames.


From Python I want to create tables and plotly plots from the LazyFrames and store everything in a self-contained HTML file.


The LazyFrames can be grouped by category and type. I want the tables and plots to be hidden behind tabs/panels and shown only when the corresponding category and type is selected by the user. Categories are in the order of 100. Types are about 10.


I want the UX of using the HTML file to be snappy and fluid.


What options do I have? 
```

## Refined solution (from Gemini)

Here is the refined, production-ready implementation of the Data Island Architecture.

This script generates a single HTML file. It handles the collect() of your LazyFrames efficiently and structures the JavaScript to ensure the browser UI remains fluid, even with 1000 data points available.

### The Python Generator Script

You can copy-paste this into a Python file (e.g., generate_report.py) and run it.
Python

```python
import polars as pl
import plotly.express as px
import json
import random
from jinja2 import Template

# --- 1. MOCK DATA GENERATION (Replace this with your actual loading logic) ---
print("Generating mock data...")

categories = [f"Category {i+1}" for i in range(100)]
types = [f"Type {i+1}" for i in range(10)]

# Structure: data_store[category][type] = { "plot": ..., "table": ... }
data_store = {}

for cat in categories:
    data_store[cat] = {}
    for typ in types:
        # Mocking a LazyFrame
        lf = pl.LazyFrame({
            "step": range(20),
            "value": [random.randint(10, 100) + (i * 2) for i in range(20)],
            "metric": [random.choice(["A", "B"]) for _ in range(20)]
        })

        # 1. Collect Data (Execution happens here)
        df = lf.collect()

        # 2. Create Plotly Figure (Export to JSON dict, NOT HTML string)
        # using strictly lightweight serialization
        fig = px.line(df, x="step", y="value", color="metric", title=f"{cat} - {typ}")
        fig.update_layout(margin=dict(l=20, r=20, t=40, b=20)) # Tight layout
        
        # 'to_json' returns a string; we parse it back to dict to embed in our main JSON object
        # This avoids double-encoding string issues.
        fig_json = json.loads(fig.to_json())

        # 3. Create Table Data (Serialize columns and rows separately for compactness)
        table_data = {
            "columns": df.columns,
            "rows": df.rows() # Returns list of tuples/lists
        }

        data_store[cat][typ] = {"plot": fig_json, "table": table_data}

print(f"Data prepared. Total items: {len(categories) * len(types)}")


# --- 2. HTML TEMPLATE (Jinja2) ---
# We use a Sidebar layout for Categories (100 is too many for top tabs)
# We use Top Tabs for Types (10 is perfect for tabs)

html_template = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Polars LazyFrame Report</title>
    
    <script src="https://cdn.plot.ly/plotly-2.27.0.min.js"></script>

    <style>
        :root {
            --sidebar-width: 280px;
            --primary-color: #2563eb;
            --bg-color: #f8fafc;
            --border-color: #e2e8f0;
        }

        body {
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            height: 100vh;
            display: flex;
            background-color: var(--bg-color);
            overflow: hidden; /* Prevent body scroll */
        }

        /* --- Sidebar (Categories) --- */
        #sidebar {
            width: var(--sidebar-width);
            background: white;
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }

        #sidebar-header {
            padding: 15px;
            font-weight: bold;
            font-size: 1.1rem;
            border-bottom: 1px solid var(--border-color);
            background: #fff;
        }

        #search-box {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            margin-top: 5px;
        }

        #cat-list {
            overflow-y: auto;
            flex: 1;
        }

        .cat-item {
            padding: 10px 15px;
            cursor: pointer;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.9rem;
            color: #475569;
        }

        .cat-item:hover { background-color: #eff6ff; }
        
        .cat-item.active {
            background-color: var(--primary-color);
            color: white;
            font-weight: 500;
        }

        /* --- Main Content Area --- */
        #main {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* --- Top Tabs (Types) --- */
        #type-tabs {
            background: white;
            border-bottom: 1px solid var(--border-color);
            padding: 0 15px;
            display: flex;
            gap: 20px;
            overflow-x: auto;
            flex-shrink: 0;
            height: 50px;
            align-items: center;
        }

        .tab-btn {
            background: none;
            border: none;
            padding: 12px 0;
            cursor: pointer;
            font-size: 0.95rem;
            color: #64748b;
            border-bottom: 2px solid transparent;
            white-space: nowrap;
        }

        .tab-btn:hover { color: var(--primary-color); }
        
        .tab-btn.active {
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
            font-weight: 600;
        }

        /* --- Content Container --- */
        #content-area {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .card {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        /* --- Table Styling --- */
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.85rem;
        }
        
        th { text-align: left; background: #f8fafc; padding: 8px; border-bottom: 2px solid var(--border-color); position: sticky; top: 0; }
        td { padding: 8px; border-bottom: 1px solid var(--border-color); color: #334155; }
        tr:hover { background-color: #f8fafc; }
        
        #table-container {
            max-height: 400px;
            overflow-y: auto;
        }

    </style>
</head>
<body>

<div id="sidebar">
    <div id="sidebar-header">
        Categories
        <input type="text" id="search-box" placeholder="Filter categories..." onkeyup="filterCategories()">
    </div>
    <div id="cat-list">
        </div>
</div>

<div id="main">
    <div id="type-tabs">
        </div>

    <div id="content-area">
        <div class="card">
            <h3 id="plot-title" style="margin-top:0; color: #333;">Plot</h3>
            <div id="plotly-div" style="width: 100%; height: 450px;"></div>
        </div>

        <div class="card">
            <h3 style="margin-top:0; color: #333;">Data Table</h3>
            <div id="table-container"></div>
        </div>
    </div>
</div>

<script>
    // --- THE DATA ISLAND ---
    // This variable holds the entire dataset. 
    // Jinja2 will inject the JSON string here.
    const allData = {{ data_json | safe }};

    // --- STATE MANAGEMENT ---
    let categories = Object.keys(allData).sort();
    // Assuming all categories have same types, grab types from the first one
    let types = Object.keys(allData[categories[0]]).sort();

    let state = {
        category: categories[0],
        type: types[0]
    };

    // --- DOM ELEMENTS ---
    const els = {
        catList: document.getElementById('cat-list'),
        typeTabs: document.getElementById('type-tabs'),
        plotDiv: document.getElementById('plotly-div'),
        tableContainer: document.getElementById('table-container'),
        plotTitle: document.getElementById('plot-title')
    };

    // --- RENDER LOGIC ---

    function init() {
        renderCategories();
        renderTypes();
        updateView();
    }

    function renderCategories() {
        els.catList.innerHTML = '';
        categories.forEach(cat => {
            const div = document.createElement('div');
            div.className = `cat-item ${cat === state.category ? 'active' : ''}`;
            div.textContent = cat;
            div.dataset.val = cat; // For filtering
            div.onclick = () => {
                state.category = cat;
                // Update active styling without re-rendering everything
                document.querySelectorAll('.cat-item').forEach(el => el.classList.remove('active'));
                div.classList.add('active');
                updateView();
            };
            els.catList.appendChild(div);
        });
    }

    function renderTypes() {
        els.typeTabs.innerHTML = '';
        types.forEach(typ => {
            const btn = document.createElement('button');
            btn.className = `tab-btn ${typ === state.type ? 'active' : ''}`;
            btn.textContent = typ;
            btn.onclick = () => {
                state.type = typ;
                document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
                btn.classList.add('active');
                updateView();
            };
            els.typeTabs.appendChild(btn);
        });
    }

    function updateView() {
        // 1. Retrieve Data
        const record = allData[state.category][state.type];
        
        if (!record) {
            console.error("No data for this combination");
            return;
        }

        // 2. Update Plot (JIT Rendering)
        // Plotly.react is faster than newPlot for updates on the same div
        Plotly.react(els.plotDiv, record.plot.data, record.plot.layout, {responsive: true});
        els.plotTitle.textContent = `${state.category} - ${state.type}`;

        // 3. Update Table (Simple HTML generation)
        const cols = record.table.columns;
        const rows = record.table.rows;

        let html = '<table><thead><tr>';
        cols.forEach(c => html += `<th>${c}</th>`);
        html += '</tr></thead><tbody>';
        
        // Limit rows if massive for DOM performance (optional)
        const displayRows = rows.slice(0, 1000); 
        displayRows.forEach(row => {
            html += '<tr>';
            row.forEach(cell => html += `<td>${cell}</td>`);
            html += '</tr>';
        });
        html += '</tbody></table>';
        
        if (rows.length > 1000) {
            html += `<div style="padding:10px; color: #666;">Showing first 1000 of ${rows.length} rows</div>`;
        }

        els.tableContainer.innerHTML = html;
    }

    // --- UTILITIES ---
    window.filterCategories = function() {
        const input = document.getElementById('search-box');
        const filter = input.value.toLowerCase();
        const nodes = document.getElementsByClassName('cat-item');

        for (let i = 0; i < nodes.length; i++) {
            const txtValue = nodes[i].textContent || nodes[i].innerText;
            if (txtValue.toLowerCase().indexOf(filter) > -1) {
                nodes[i].style.display = "";
            } else {
                nodes[i].style.display = "none";
            }
        }
    }

    // Start
    init();

</script>
</body>
</html>
"""

# --- 3. WRITE TO FILE ---
print("Writing HTML file...")
with open("dashboard.html", "w", encoding="utf-8") as f:
    # Use json.dumps with separators to remove whitespace and reduce file size
    json_str = json.dumps(data_store, separators=(',', ':'))
    
    # Render template
    final_html = Template(html_template).render(data_json=json_str)
    f.write(final_html)

print("Done! Open 'dashboard.html' in your browser.")
```

### Why this specific implementation?

1. Sidebar for Categories: You mentioned "Order of 100" categories. 100 tabs across the top of a screen is unusable. A scrollable sidebar with a search filter (included in the code) is the correct UX pattern for this volume.
2. Plotly.react: In the JS section, I used Plotly.react instead of Plotly.newPlot. This method is designed for updating existing plots efficiently, reusing the WebGL context where possible, which prevents the browser from crashing after you click 20 tabs.
3. JSON Separators: In the Python write step, I used json.dumps(..., separators=(',', ':')). This removes all whitespace from the JSON, often reducing the file size by 20-30% without any data loss.
4. Layout Stability: The CSS ensures the sidebar and header are fixed, and only the content areas scroll. This feels like a "Real App" rather than a long web page.

### How to make it 100% Offline

Currently, the script uses a CDN for Plotly: <script src="https://cdn.plot.ly/plotly-2.27.0.min.js"></script>

To make it offline:
1. Download that .js file to your Python script's folder.
2. Read it into a Python string variable: plotly_js = open('plotly-2.27.0.min.js').read()
3. Inject it into the template: <script>{{ plotly_js | safe }}</script>