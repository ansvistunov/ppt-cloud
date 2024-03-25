const os = require('os'); 
module.exports = async (req, res) => {
    const result = {
        name: os.hostname(),
    }
    res.send(result);
};