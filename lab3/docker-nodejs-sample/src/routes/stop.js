module.exports = async (req, res) => {
    res.end('service stopping...');
    console.log('stop node process...');
    process.exit(1);
};