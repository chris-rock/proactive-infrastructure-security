const express = require("express");
const csrf = require("csurf");
const cookieParser = require("cookie-parser");

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(cookieParser());

// Setup CSRF protection
const csrfProtection = csrf({ cookie: true });

// In-memory "database"
let items = [
  { id: 1, name: "Sample Item 1" },
  { id: 2, name: "Sample Item 2" },
];

// Serve static HTML with CSRF token
app.get("/", csrfProtection, (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Fancy Demo App with CSRF Protection</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
                background-color: #f0f0f0;
            }
            h1 {
                color: #333;
                text-align: center;
            }
            #itemList {
                list-style-type: none;
                padding: 0;
            }
            #itemList li {
                background-color: #fff;
                margin-bottom: 10px;
                padding: 15px;
                border-radius: 4px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            #newItemForm {
                display: flex;
                margin-bottom: 20px;
            }
            #newItemInput {
                flex-grow: 1;
                padding: 10px;
                font-size: 16px;
                border: 1px solid #ddd;
                border-radius: 4px 0 0 4px;
            }
            #addItemButton {
                padding: 10px 20px;
                font-size: 16px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 0 4px 4px 0;
                cursor: pointer;
            }
            #addItemButton:hover {
                background-color: #45a049;
            }
        </style>
    </head>
    <body>
        <h1>Fancy Demo App with CSRF Protection</h1>
        <form id="newItemForm">
            <input type="text" id="newItemInput" placeholder="Enter new item">
            <input type="hidden" id="csrfToken" value="${req.csrfToken()}">
            <button type="submit" id="addItemButton">Add Item</button>
        </form>
        <ul id="itemList"></ul>

        <script>
            const itemList = document.getElementById('itemList');
            const newItemForm = document.getElementById('newItemForm');
            const newItemInput = document.getElementById('newItemInput');
            const csrfToken = document.getElementById('csrfToken').value;

            // Function to fetch and display items
            function fetchItems() {
                fetch('/api/items')
                    .then(response => response.json())
                    .then(items => {
                        itemList.innerHTML = items.map(item =>
                            \`<li>\${item.name}</li>\`
                        ).join('');
                    });
            }

            // Fetch items on page load
            fetchItems();

            // Add new item
            newItemForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const name = newItemInput.value.trim();
                if (name) {
                    fetch('/api/items', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'CSRF-Token': csrfToken
                        },
                        body: JSON.stringify({ name }),
                    })
                    .then(() => {
                        newItemInput.value = '';
                        fetchItems();
                    });
                }
            });
        </script>
    </body>
    </html>
  `);
});

// API Routes
app.get("/api/items", (req, res) => {
  res.json(items);
});

app.post("/api/items", csrfProtection, (req, res) => {
  const newItem = {
    id: items.length + 1,
    name: req.body.name,
  };
  items.push(newItem);
  res.status(201).json(newItem);
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
