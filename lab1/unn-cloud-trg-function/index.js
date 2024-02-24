const { S3Client, ListObjectsV2Command,PutObjectCommand } = require("@aws-sdk/client-s3");


async function connect(){
    const REGION = "ru-central1";
    const ENDPOINT = "https://storage.yandexcloud.net";
    const s3Client = new S3Client({
        region: REGION, endpoint: ENDPOINT, credentials: {
            accessKeyId: process.env.accessKeyId,
            secretAccessKey: process.env.secretAccessKey
        }
    });
    return s3Client;
}

async function listFolder(s3Client, folder) {
    const command = new ListObjectsV2Command({
        Bucket: process.env.bucket, Delimiter: '/',
        Prefix: folder
    });

    const { Contents } = await s3Client.send(command);
    return Contents;
}

async function putObject(s3Client, data, name) {
    const bucket = process.env.bucket;
    const params = { Bucket: bucket, Key: name, Body: data, ContentType: "text/html" };
    const results = await s3Client.send(new PutObjectCommand(params));
    return results;
  }

module.exports.handler = async function (event, context) {
    const bucket = event['messages'][0]['details']['bucket_id'];
    const file = event['messages'][0]['details']['object_id'];
    console.log(file);
    const listFile = 'list.html';
    if (file === listFile){//мы поймали изменение собственного файла
        //console.log("recurse return");
        return;
    }

    const s3Client = await connect();

    const folder = "upload/";
    data = await listFolder(s3Client, folder);
    let str = "<html lang='ru'> <head>  <meta charset='utf-8'> <title>File list</title> </head> \n<body>";
    for (let index = 0; index < data.length; index++) {
        str = str + `<a href="${data[index].Key}">${data[index].Key}</a><br>`;
    }
    str = str + "</body></html>";
    putObject(s3Client, str, listFile);

    return {
        statusCode: 200,
        body: 'list created',
    };
};