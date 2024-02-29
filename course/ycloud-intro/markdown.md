# Введение в облачные вычисления
---
### План занятия
 - Яндекс.Облако - начало
    - Создание облака. Стартовый грант
    - Структура организация\облако\каталог
    - Пользователи и права доступа
 - Что предлагает провайдер? Поищем, где в яндекс облаке IaaS, PaaS, и есть ли в нем SaaS
 - Краткий (очень краткий) обзор некоторых сервисов:
    - Виртуальные машины (Compute Cloud)
    - облачные функции (Cloud Functions)
    - облачные функции (Cloud Funcions)
    - API Gateway
    - объектное хранилище (Object Storage)
    - бессерверные контейнеры (Serverless Containers)
    - Lockbox
    - облачные базы данных (MySql, PostgreSQL, ...)
---
### Вход в облако (создание нового)
- https://cloud.yandex.ru/ru/
- Подключиться (unn-cloud-student)
- создаем платежный аккаунт (осторожно с этим, можно получить списания)
- получаем стартовый грант
- структура: организация\облако\каталоги
- каталоги, это чаще всего проекты, облака, это чаще всегда подразделения
---
### Подключение к существующему облаку
 - вашего пользователя должны пригласить (приглашение на уровне организации)
 - и дать вашей учетке права. Для удобства лучше использовать группу и давать права им
 - прав много (для каждого сервиса они свои)
 - сервисные учетные записи (для гранулярного доступа)
---
### Способы взаимодействия
- Веб (на этом занятии используем только его) (GUI)
- yandex cloud console (отдаем команды) (https://cloud.yandex.ru/ru/docs/cli/quickstart#windows_1)
- terraform (декларативное описание)
- REST API
---
## Обзор имеющихся сервисов
 - процесс "заказа" -обращаем внимание на калькулятор!
---
### Compute Cloud
 - виртуальная машина в облаке
 - самый "понятный" и самый "скучный" сервис
 - выбираем процессор, количество ядер, память, гарантированную долю ядра
 - для удешевления (ели не нужна постоянная работа) машину можно сделать прерываемой
---
### Облачные функции (Cloud Functions)
 - код "без состояния"

 ```js
 module.exports.i = 0;

module.exports.handler = async function (event, context) {
    module.exports.i++;
    return {
        statusCode: 200,
        body: `Hello World! i=${module.exports.i}`,
    };
};
```

- состояние "сбрасывается" через некоторое время после того, как запросы перестают поступать
- функции могут автоматически масштабироваться
---
### API Gateway
```yaml
openapi: 3.0.0
info:
  title: Sample API
  version: 1.0.0
servers:
- url: https://d5d2vb8vi4u64q9ht254.apigw.yandexcloud.net
paths:
  /hello:
    get:
      x-yc-apigateway-integration:
        type: dummy
        content:
          '*': Hello, World!
        http_code: 200
        http_headers:
          Content-Type: text/plain
  /function:
    get:
      x-yc-apigateway-integration:
        type: cloud_functions
        function_id: xxxxxxxxxxxxxxxxxxxxx
        tag: "$latest"
        service_account_id: xxxxxxxxxxxxxxxxxxxx
```
---
### бессерверные контейнеры (Serverless Containers)
 - образы докер, которые запускаются облаком
 - гарантированно живут только во время выполнения запроса
 - образы должны лежать в container registry яндекса
 - https://cloud.yandex.ru/ru/docs/serverless-containers/quickstart/container

```bash
 git clone https://github.com/docker/docker-nodejs-sample
 docker init
 docker compose up --build
 docker tag docker-nodejs-sample-server:latest cr.yandex/crp4m7977kiujntdtpu8/docker-nodejs-sample-server:latest
 docker pull cr.yandex/crp4m7977kiujntdtpu8/docker-nodejs-sample-server:latest
```
---
### Объектное хранилище (Object Storage)
- универсальное масштабируемое решение для хранения данных
- HTTP API сервиса совместим с API Amazon S3 (S3 = Simple Storage Service)
- позволяет использовать различные классы хранилища для объектов и управлять их жизненным циклом
- может хранить большие объекты размером в несколько терабайт
- позволяет опубликовать статический веб-сайт
---
```js
const { S3Client,GetObjectCommand,PutObjectCommand } = require("@aws-sdk/client-s3");

async function run(){
  const REGION = "ru-central1";
  const ENDPOINT = "https://storage.yandexcloud.net";
  const s3Client = new S3Client({ region: REGION, endpoint: ENDPOINT , credentials:{
                              accessKeyId:'XXXXXXXXXXXXXXXXXXXXXX',
                              secretAccessKey:'XXXXXXXXXXXXXXXXXXXXXXXXXXXX'}
             });
  const bucket = 'test-backet-1';
  let key = 'parameter';
  let i = 0;
  try{
     const response = await s3Client.send(new GetObjectCommand({Bucket:bucket,Key:key}));
     i = await response.Body.transformToString();
     i++;
  }catch(err){
    console.log(err);
     i = 0;
  }
  const params = {Bucket: bucket, Key: key, Body: ''+i};
try {
    const results = await s3Client.send(new PutObjectCommand(params));
    return results; 
  } catch (err) {
    console.log("Error", err);
  }
}

run()
```
---
```js
module.exports.handler = async function (event, context) {
    const { S3Client,GetObjectCommand,PutObjectCommand } = require("@aws-sdk/client-s3");
    const REGION = "ru-central1";
  const ENDPOINT = "https://storage.yandexcloud.net";
  const s3Client = new S3Client({ region: REGION, endpoint: ENDPOINT , credentials:{
                              accessKeyId:'XXXXXXXXXXXXXXXXXXXXXXXXXXX',
                              secretAccessKey:'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'}
             });
  const bucket = 'test-backet-1';
  let key = 'parameter';
  let i = 0;
  try{
     const response = await s3Client.send(new GetObjectCommand({Bucket:bucket,Key:key}));
     i = await response.Body.transformToString();
     i++;
  }catch(err){
    console.log(err);
     i = 0;
  }
  const params = {Bucket: bucket, Key: key, Body: ''+i};
try {
    const results = await s3Client.send(new PutObjectCommand(params));
    
  } catch (err) {
    console.log("Error", err);
  }



    return {
        statusCode: 200,
        body: `i=${i}`,
    };
};
```
---
```js
module.exports.handler = async function (event, context) {
    const { S3Client,GetObjectCommand,PutObjectCommand } = require("@aws-sdk/client-s3");
  console.log('accessKeyId='+process.env.accessKeyId);

  const REGION = "ru-central1";
  const ENDPOINT = "https://storage.yandexcloud.net";
  const s3Client = new S3Client({ region: REGION, endpoint: ENDPOINT , credentials:{
                              accessKeyId:process.env.accessKeyId,
                              secretAccessKey:process.env.secretAccessKey}
             });
  const bucket = 'test-backet-1';
  let key = 'parameter';
  let i = 0;
  try{
     const response = await s3Client.send(new GetObjectCommand({Bucket:bucket,Key:key}));
     i = await response.Body.transformToString();
     i++;
  }catch(err){
    console.log(err);
     i = 0;
  }
  const params = {Bucket: bucket, Key: key, Body: ''+i};
try {
    const results = await s3Client.send(new PutObjectCommand(params));
    
  } catch (err) {
    console.log("Error", err);
  }


    return {
        statusCode: 200,
        body: `Hello, i=${i}`,
    };
};
```

