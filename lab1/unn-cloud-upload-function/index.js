const parseMultipart = require('parse-multipart');
const { S3Client, GetObjectCommand, PutObjectCommand } = require("@aws-sdk/client-s3");

function extractFile(event) {
  const boundary = parseMultipart.getBoundary(event.headers['Content-Type'])
  const parts = parseMultipart.Parse(Buffer.from(event.body, 'base64'), boundary);
  const [{ filename, data }] = parts
  return {
    filename,
    data
  }
};

async function putObject(data, name) {
  const REGION = "ru-central1";
  const folder = "upload/";
  const ENDPOINT = "https://storage.yandexcloud.net";
  const s3Client = new S3Client({
    region: REGION, endpoint: ENDPOINT, credentials: {
      accessKeyId: process.env.accessKeyId,
      secretAccessKey: process.env.secretAccessKey
    }
  });
  const bucket = process.env.bucket;
  const params = { Bucket: bucket, Key: folder + name, Body: data };
  const results = await s3Client.send(new PutObjectCommand(params));
  return results;
}

module.exports.handler = async function (event, context) {
  const { filename, data } = extractFile(event);
  result = await putObject(data, filename);
  return {
    statusCode: 200,
    body: 'File uploaded!',
  };
};
