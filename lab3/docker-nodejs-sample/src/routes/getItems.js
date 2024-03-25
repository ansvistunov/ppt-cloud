const db = require('../persistence');
const os = require('os'); 
module.exports = async (req, res) => {
    let items = await db.getItems();
    const hostname = os.hostname();
    items = items.map(row => ({
        id: row.id,
        name: row.name + ' (' + hostname +')',
        completed: row.completed
      }));
    res.send(items);
};
