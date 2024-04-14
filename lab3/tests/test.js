const fs = require("fs");
const axios = require('axios');
const db = require('./db');
const { parse } = require("csv-parse/sync");

const content = fs.readFileSync("./data.txt");
const records = parse(content, {delimiter: ";"});

beforeAll(async () => {
    const dbparams = {
        POSTGRES_HOST: POSTGRES_HOST,
        POSTGRES_PORT: POSTGRES_PORT,
        POSTGRES_DB: POSTGRES_DB,
        POSTGRES_USER: POSTGRES_USER,
        POSTGRES_PASSWORD: POSTGRES_PASSWORD,
    } = process.env;

    const client = await db.init(dbparams);
  });

afterAll(async () =>{
    await db.teardown();
})


function clearItemsNames(data){
    return data.map(row => ({
        id: row.id,
        name: row.name.replace(/\s\((\w+.)+/g,''),
        completed: row.completed
      }));
}


describe.each(records)('test servless containers', (group, student, section, url)=>{
    const axiosConfig = {
        baseURL: url,
        validateStatus: () => true,
    };
    // Create axios client for the whole test suite
    let axiosAPIClient = axios.create(axiosConfig);
    //прогрев
    const response = axiosAPIClient.get().then(()=>{});

    describe(`test for: ${student} ${group} ${section}`, () => {
        test('When asked for empty database, Then should retrieve empty and receive 200 response', async () => {
            await db.deleteAllForSection(section);
            const getResponse = await axiosAPIClient.get("/items");
            //console.log(getResponse);    
            expect(getResponse).toMatchObject({
                status: 200,
            });
            expect(getResponse.data.length).toBe(0);
        }, 10000);

        test('When db contains 1 item, should return this item', async () =>{
            const item = {
                id: 'item 1'+section,
                name: "Item item item",
                completed: false,
            }
            await db.deleteAllForSection(section);
            await db.storeItem(item, section);
            let {data, status} = await axiosAPIClient.get("/items");
            data = clearItemsNames(data);
            expect(data.length).toBe(1);
            expect({
                data,
                status,
            }).toMatchObject({
                status: 200,
                data: [{id: item.id, name: item.name, completed: item.completed,}],
            });

        });
        test('Create new item, should return this item', async () =>{
            const name = "Item2 item2 item2";
            await db.deleteAllForSection(section);
            const response = await axiosAPIClient.post('/items', {name: name});
            const id = response.data.id;
            const data = await db.getItem(id);
            expect({
                data,
            }).toMatchObject({
                data: {
                    id: id,
                    name: name,
                    completed: false,
                    section: section
                },
            });

        });

        test('Update item, should return this item updated', async () =>{
            const item = {
                id: 'item 3' + section,
                name: "Item3 item3 item3",
                completed: false,
            }
            const itemNew = {
                id: 'item 3' + section,
                name: "Item3 new item3 new item3 new",
                completed: true,
            }

            await db.deleteAllForSection(section);
            await db.storeItem(item, section);
            const response = await axiosAPIClient.put(`/items/${item.id}`, itemNew);
            const data = await db.getItem(item.id);
            expect({
                data,
            }).toMatchObject({
                data: {
                    id: item.id,
                    name: itemNew.name,
                    completed: itemNew.completed,
                    section: section
                },
            });

        });

        test('Delete by id, should return empty set', async () =>{
            const item = {
                id: 'item 4' + section,
                name: "Item4 item4 item4",
                completed: false,
            }
            await db.deleteAllForSection(section);
            await db.storeItem(item, section);
            const response = await axiosAPIClient.delete(`/items/${item.id}`);
            const data = await db.getItem(item.id);
            //console.log(data);
            expect(data).toBe(null);

        });

        test('Store 5 items in db, should return 5 items', async () =>{
            const items = [
                {
                    id: 'item 1' + section,
                    name: "Item1 item1 item1",
                    completed: false,
                },
                {
                    id: 'item 2' + section,
                    name: "Item2 item2 item2",
                    completed: false,
                },
                {
                    id: 'item 3' + section,
                    name: "Item3 item3 item3",
                    completed: false,
                },
                {
                    id: 'item 4' + section,
                    name: "Item4 item4 item4",
                    completed: false,
                },
                {
                    id: 'item 5' + section,
                    name: "Item5 item5 item5",
                    completed: false,
                }
            ]
            await db.deleteAllForSection(section);
            for (let item of items){
                await db.storeItem(item, section);
            }

            let {data} = await axiosAPIClient.get(`/items`);
            data = clearItemsNames(data);
            expect(data.length).toBe(items.length);
            expect({
                data,
            }).toMatchObject({
                data: items,
            });

        });


    });
}
);