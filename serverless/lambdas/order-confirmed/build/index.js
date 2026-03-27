"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = void 0;
const AWS = __importStar(require("aws-sdk"));
const pg_1 = require("pg");
const secretsManager = new AWS.SecretsManager();
const sns = new AWS.SNS();
const rdsProxyEndpoint = process.env.RDS_PROXY_ENDPOINT;
const secretArn = process.env.RDS_SECRET_ARN;
const snsTopicArn = process.env.SNS_TOPIC_ARN;
const databaseName = process.env.RDS_DATABASE_NAME;
const handler = (event, _) => __awaiter(void 0, void 0, void 0, function* () {
    console.log(event);
    /* Recuperando Secret do Banco de Dados */
    const secret = yield getSecret();
    const client = new pg_1.Client({
        host: rdsProxyEndpoint,
        user: secret.username,
        password: secret.password,
        database: databaseName,
        ssl: true,
        port: 5432
    });
    const body = typeof event.body === 'string' ? JSON.parse(event.body) : event.body;
    const id = (body === null || body === void 0 ? void 0 : body.Id) || event.Id;
    if (!id) {
        throw new Error('Id is missing from the event');
    }
    /* Conectando no Banco de Dados */
    yield client.connect();
    try {
        /* Atualizando Status da Ordem para Confirmado */
        const sql = `UPDATE "Order" SET "StatusId" = 1 WHERE "Id" = $1`;
        const values = [id];
        const response = yield client.query(sql, values);
        console.log('Order updated successfully:', response);
        /* Publicando mensagem no tópico orderConfirmed */
        yield publishToSns(JSON.stringify({ Id: id }));
        return response;
    }
    catch (error) {
        console.error('Failed to update Order:', error);
        throw error;
    }
    finally {
        yield client.end();
    }
});
exports.handler = handler;
function getSecret() {
    return __awaiter(this, void 0, void 0, function* () {
        const data = yield secretsManager.getSecretValue({ SecretId: secretArn }).promise();
        if ('SecretString' in data) {
            return JSON.parse(data.SecretString);
        }
        throw new Error('Secret not found');
    });
}
function publishToSns(message) {
    return __awaiter(this, void 0, void 0, function* () {
        const params = {
            Message: message,
            TopicArn: snsTopicArn,
        };
        yield sns.publish(params).promise();
        console.log('Message published to SNS topic:', message);
    });
}
