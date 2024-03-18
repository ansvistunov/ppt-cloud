const axios = require('axios');
const db = require('./db');

let axiosAPIClient;
const section = 'bochkarev';

beforeAll(async () => {
    const axiosConfig = {
      baseURL: "https://bbasq15u602u7ev6m31g.containers.yandexcloud.net",
      validateStatus: () => true,
    };
    // Create axios client for the whole test suite
    axiosAPIClient = axios.create(axiosConfig);

    const dbparams = {
        host: "rc1d-xxxxx",
        port: 6432,
        db: "db1",
        user: "db_user",
        password: "xxxxxx",
    }
    const client = await db.init(dbparams);
    //прогрев
    const response = await axiosAPIClient.get();
  });

afterAll(async () =>{
    await db.teardown();
})

describe(`test servless container: ${section}`, () => {
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
            id: 'item 1',
            name: "Item item item",
            completed: false,
        }
        await db.deleteAllForSection(section);
        await db.storeItem(item, section);
        const {data, status} = await axiosAPIClient.get("/items");
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
            id: 'item 3',
            name: "Item3 item3 item3",
            completed: false,
        }
        const itemNew = {
            id: 'item 3',
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
            id: 'item 4',
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
                id: 'item 1',
                name: "Item1 item1 item1",
                completed: false,
            },
            {
                id: 'item 2',
                name: "Item2 item2 item2",
                completed: false,
            },
            {
                id: 'item 3',
                name: "Item3 item3 item3",
                completed: false,
            },
            {
                id: 'item 4',
                name: "Item4 item4 item4",
                completed: false,
            },
            {
                id: 'item 5',
                name: "Item5 item5 item5",
                completed: false,
            }
        ]
        await db.deleteAllForSection(section);
        for (let item of items){
            await db.storeItem(item, section);
        }

        const {data} = await axiosAPIClient.get(`/items`);
        expect(data.length).toBe(items.length);
        expect({
            data,
          }).toMatchObject({
            data: items,
          });

    });


});