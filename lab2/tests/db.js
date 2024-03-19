const { Client } = require('pg');
const fs = require("fs");


let client;

async function init(params) {
    const host = params.POSTGRES_HOST;
    const user = params.POSTGRES_USER
    const password = params.POSTGRES_PASSWORD
    const database = params.POSTGRES_DB
    const postgres_port = params.POSTGRES_PORT;

    client = new Client({
        host,
        user,
        password,
        database,
        port: postgres_port,
        /* ssl: {
            rejectUnauthorized: true,
            ca: fs
                .readFileSync("...../.postgresql/root.crt")
                .toString(),
        }, */
    });

    try{
        client.connect();
        console.log(`Connected to postgres db at host ${host}`);
        // Run the SQL instruction to create the table if it does not exist
        //await client.query('CREATE TABLE IF NOT EXISTS todo_items (id varchar(36), name varchar(255), completed boolean)');
        //console.log('Connected to db and created table todo_items if it did not exist');
        return client;
    }catch(err){
        console.error('Unable to connect to the database:', err);
    };
}


async function deleteAllForSection(section){
    return client.query('DELETE FROM todo_items WHERE section = $1', [section]).then(() => {
        //console.log('Removed all for:', section);
      }).catch(err => {
        console.error('Unable to remove items:', err);
      });
}

async function storeItem(item, section) {
    return client.query('INSERT INTO todo_items(id, name, completed, section) VALUES($1, $2, $3, $4)', [item.id, item.name, item.completed, section]).then(() => {
      //console.log('Stored item:', item);
    }).catch(err => {
      console.error('Unable to store item:', err);
    });
}

async function updateItem(id, item) {
    return client.query('UPDATE todo_items SET name = $1, completed = $2 WHERE id = $3', [item.name, item.completed, id]).then(() => {
      //console.log('Updated item:', item);
    }).catch(err => {
      console.error('Unable to update item:', err);
    });
}
  
// Remove one item by id from the table
async function removeItem(id) {
    return client.query('DELETE FROM todo_items WHERE id = $1', [id]).then(() => {
      //console.log('Removed item:', id);
    }).catch(err => {
      console.error('Unable to remove item:', err);
    });
}

async function getItems(section) {
    return client.query('SELECT * FROM todo_items where section= $1', [section]).then(res => {
      return res.rows.map(row => ({
        id: row.id,
        name: row.name,
        completed: row.completed
      }));
    }).catch(err => {
      console.error('Unable to get items:', err);
    });
  }
  
  
  // End the connection
  async function teardown() {
    return client.end().then(() => {
      console.log('Client ended');
    }).catch(err => {
      console.error('Unable to end client:', err);
    });
  }
    
  // Get one item by id from the table
  async function getItem(id) {
      return client.query('SELECT * FROM todo_items WHERE id = $1', [id]).then(res => {
        return res.rows.length > 0 ? res.rows[0] : null;
      }).catch(err => {
        console.error('Unable to get item:', err);
      });
  }

module.exports = {
    init,
    teardown,
    getItems,
    getItem,
    storeItem,
    updateItem,
    removeItem,
    deleteAllForSection,
  };

